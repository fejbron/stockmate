import 'package:drift/drift.dart';

import '../data/app_database.dart';
import 'cart_models.dart';
import 'stock_allocator.dart';

/// Thrown inside [CheckoutRepository.persistSale] when stock is insufficient
/// at commit time. The transaction rolls back; callers convert this into a
/// clean failure result rather than letting it escape.
class InsufficientStockException implements Exception {
  const InsufficientStockException(this.message);

  final String message;

  @override
  String toString() => 'InsufficientStockException: $message';
}

class SellableProduct {
  const SellableProduct({
    required this.id,
    required this.name,
    required this.codeValue,
    required this.sellingPriceMinor,
    required this.stockQuantity,
  });

  final int id;
  final String name;
  final String codeValue;
  final int sellingPriceMinor;
  final int stockQuantity;
}

class SaleListItem {
  const SaleListItem({
    required this.id,
    required this.receiptNumber,
    required this.soldAt,
    required this.totalMinor,
    required this.grossProfitMinor,
    required this.itemCount,
  });

  final int id;
  final String receiptNumber;
  final DateTime soldAt;
  final int totalMinor;
  final int grossProfitMinor;
  final int itemCount;
}

class CheckoutRepository {
  CheckoutRepository(this.db);

  final AppDatabase db;

  Future<SellableProduct?> findProductByCode(String code) async {
    final trimmedCode = code.trim();
    if (trimmedCode.isEmpty) {
      return null;
    }

    final rows = await db
        .customSelect(
          '''
          SELECT
            p.id,
            p.name,
            pc.code_value,
            p.selling_price_minor,
            COALESCE(SUM(sb.quantity_remaining), 0) AS stock_quantity
          FROM product_codes pc
          INNER JOIN products p ON p.id = pc.product_id
          LEFT JOIN stock_batches sb ON sb.product_id = p.id
          WHERE pc.code_value = ? AND p.is_active = 1
          GROUP BY p.id, p.name, pc.code_value, p.selling_price_minor
          LIMIT 1
          ''',
          variables: [Variable(trimmedCode)],
          readsFrom: {db.productCodes, db.products, db.stockBatches},
        )
        .get();

    if (rows.isEmpty) {
      return null;
    }

    final row = rows.single;
    return SellableProduct(
      id: row.read<int>('id'),
      name: row.read<String>('name'),
      codeValue: row.read<String>('code_value'),
      sellingPriceMinor: row.read<int>('selling_price_minor'),
      stockQuantity: row.read<int>('stock_quantity'),
    );
  }

  Stream<List<SaleListItem>> watchRecentSales() {
    return db
        .customSelect(
          '''
          SELECT
            s.id,
            s.receipt_number,
            s.sold_at,
            s.total_minor,
            s.gross_profit_minor,
            COALESCE(SUM(sl.quantity), 0) AS item_count
          FROM sales s
          LEFT JOIN sale_lines sl ON sl.sale_id = s.id
          GROUP BY s.id, s.receipt_number, s.sold_at, s.total_minor, s.gross_profit_minor
          ORDER BY s.sold_at DESC, s.id DESC
          LIMIT 50
          ''',
          readsFrom: {db.sales, db.saleLines},
        )
        .watch()
        .map(
          (rows) => [
            for (final row in rows)
              SaleListItem(
                id: row.read<int>('id'),
                receiptNumber: row.read<String>('receipt_number'),
                soldAt: row.read<DateTime>('sold_at'),
                totalMinor: row.read<int>('total_minor'),
                grossProfitMinor: row.read<int>('gross_profit_minor'),
                itemCount: row.read<int>('item_count'),
              ),
          ],
        );
  }

  Future<List<AvailableBatch>> availableBatches(int productId) async {
    final batches =
        await (db.select(db.stockBatches)
              ..where(
                (row) =>
                    row.productId.equals(productId) &
                    row.quantityRemaining.isBiggerThanValue(0),
              )
              ..orderBy([
                (row) => OrderingTerm.asc(row.receivedAt),
                (row) => OrderingTerm.asc(row.id),
              ]))
            .get();

    return [
      for (final batch in batches)
        AvailableBatch(
          id: batch.id,
          quantityRemaining: batch.quantityRemaining,
          costPerUnitMinor: batch.costPerUnitMinor,
        ),
    ];
  }

  /// Persists a sale atomically.
  ///
  /// Stock allocation is recomputed INSIDE the transaction against freshly
  /// read batch quantities, so concurrent sales (or a sale racing a stock
  /// adjustment) cannot oversell. If stock is insufficient at commit time an
  /// [InsufficientStockException] is thrown so the caller can surface a clean
  /// failure; the transaction rolls back and no partial sale is written.
  Future<int> persistSale({
    required Cart cart,
    required StockAllocator allocator,
  }) {
    return db.transaction(() async {
      // Authoritatively allocate against the current on-disk stock, tracking
      // running consumption so duplicate product lines do not double-spend.
      final availableBatchesByProduct = <int, List<AvailableBatch>>{};
      final allocationsByLineIndex = <int, List<BatchAllocation>>{};

      for (var index = 0; index < cart.lines.length; index += 1) {
        final line = cart.lines[index];
        final batches = await _availableBatchesInTransaction(
          line.productId,
          availableBatchesByProduct,
        );
        final allocationResult = allocator.allocate(
          requestedQuantity: line.quantity,
          batches: batches,
        );
        if (!allocationResult.isSuccess) {
          throw InsufficientStockException(allocationResult.message);
        }
        allocationsByLineIndex[index] = allocationResult.allocations;
        availableBatchesByProduct[line.productId] = _consumeAllocatedBatches(
          batches: batches,
          allocations: allocationResult.allocations,
        );
      }

      final costTotalMinor = _costTotalMinor(allocationsByLineIndex);

      _pendingReceiptCounter += 1;
      final saleId = await db
          .into(db.sales)
          .insert(
            SalesCompanion.insert(
              // Temporary placeholder; replaced below with a value derived from
              // the auto-increment sale id so it is collision-free. The counter
              // keeps the placeholder unique against the UNIQUE constraint even
              // for back-to-back sales before each receives its id.
              receiptNumber: 'R-pending-$_pendingReceiptCounter',
              subtotalMinor: cart.subtotalMinor,
              discountTotalMinor: Value(cart.discountTotalMinor),
              totalMinor: cart.totalMinor,
              costTotalMinor: costTotalMinor,
              grossProfitMinor: cart.totalMinor - costTotalMinor,
              paymentMethod: cart.paymentMethod,
              amountPaidMinor: Value(cart.amountPaidMinor),
              changeDueMinor: Value(_changeDueMinor(cart)),
            ),
          );

      // Derive a unique receipt number from the auto-increment sale id.
      final receiptNumber = 'R-$saleId';
      await (db.update(
        db.sales,
      )..where((row) => row.id.equals(saleId))).write(
        SalesCompanion(receiptNumber: Value(receiptNumber)),
      );

      for (var index = 0; index < cart.lines.length; index += 1) {
        final line = cart.lines[index];
        final allocations = allocationsByLineIndex[index] ?? const [];
        var lineCostTotalMinor = 0;
        for (final allocation in allocations) {
          lineCostTotalMinor += allocation.costTotalMinor;
        }

        final saleLineId = await db
            .into(db.saleLines)
            .insert(
              SaleLinesCompanion.insert(
                saleId: saleId,
                productId: line.productId,
                quantity: line.quantity,
                unitPriceMinor: line.unitPriceMinor,
                discountAmountMinor: Value(line.discountMinor),
                lineTotalMinor: line.lineTotalMinor,
                costTotalMinor: lineCostTotalMinor,
                grossProfitMinor: line.lineTotalMinor - lineCostTotalMinor,
              ),
            );

        for (final allocation in allocations) {
          await db
              .into(db.saleLineBatchAllocations)
              .insert(
                SaleLineBatchAllocationsCompanion.insert(
                  saleLineId: saleLineId,
                  stockBatchId: allocation.stockBatchId,
                  quantity: allocation.quantity,
                  costPerUnitMinor: allocation.costPerUnitMinor,
                  costTotalMinor: allocation.costTotalMinor,
                ),
              );

          final batch =
              await (db.select(db.stockBatches)
                    ..where((row) => row.id.equals(allocation.stockBatchId)))
                  .getSingle();
          await (db.update(
            db.stockBatches,
          )..where((row) => row.id.equals(allocation.stockBatchId))).write(
            StockBatchesCompanion(
              quantityRemaining: Value(
                batch.quantityRemaining - allocation.quantity,
              ),
            ),
          );
        }
      }

      await db
          .into(db.receipts)
          .insert(
            ReceiptsCompanion.insert(
              saleId: saleId,
              receiptNumber: receiptNumber,
            ),
          );

      return saleId;
    });
  }

  // Monotonic counter making the in-transaction placeholder receipt number
  // unique even before the sale id is known, avoiding the UNIQUE collision
  // that two concurrent transactions could otherwise hit.
  int _pendingReceiptCounter = 0;

  Future<List<AvailableBatch>> _availableBatchesInTransaction(
    int productId,
    Map<int, List<AvailableBatch>> availableBatchesByProduct,
  ) async {
    final cached = availableBatchesByProduct[productId];
    if (cached != null) {
      return cached;
    }
    final batches = await availableBatches(productId);
    availableBatchesByProduct[productId] = batches;
    return batches;
  }

  List<AvailableBatch> _consumeAllocatedBatches({
    required List<AvailableBatch> batches,
    required List<BatchAllocation> allocations,
  }) {
    final updatedBatches = <AvailableBatch>[];
    for (final batch in batches) {
      var quantityRemaining = batch.quantityRemaining;
      for (final allocation in allocations) {
        if (allocation.stockBatchId == batch.id) {
          quantityRemaining -= allocation.quantity;
        }
      }
      if (quantityRemaining > 0) {
        updatedBatches.add(
          AvailableBatch(
            id: batch.id,
            quantityRemaining: quantityRemaining,
            costPerUnitMinor: batch.costPerUnitMinor,
          ),
        );
      }
    }
    return updatedBatches;
  }

  int _costTotalMinor(Map<int, List<BatchAllocation>> allocationsByLineIndex) {
    var total = 0;
    for (final allocations in allocationsByLineIndex.values) {
      for (final allocation in allocations) {
        total += allocation.costTotalMinor;
      }
    }
    return total;
  }

  int? _changeDueMinor(Cart cart) {
    final amountPaidMinor = cart.amountPaidMinor;
    if (amountPaidMinor == null) {
      return null;
    }
    return (amountPaidMinor - cart.totalMinor)
        .clamp(0, amountPaidMinor)
        .toInt();
  }
}
