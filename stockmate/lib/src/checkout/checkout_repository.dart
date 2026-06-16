import 'package:drift/drift.dart';

import '../data/app_database.dart';
import 'cart_models.dart';
import 'stock_allocator.dart';

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

  Future<int> persistSale({
    required Cart cart,
    required Map<int, List<BatchAllocation>> allocationsByLineIndex,
  }) {
    return db.transaction(() async {
      final receiptNumber = 'R-${DateTime.now().microsecondsSinceEpoch}';
      final costTotalMinor = _costTotalMinor(allocationsByLineIndex);

      final saleId = await db
          .into(db.sales)
          .insert(
            SalesCompanion.insert(
              receiptNumber: receiptNumber,
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
