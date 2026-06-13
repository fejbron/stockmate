import 'package:drift/drift.dart';

import '../data/app_database.dart';
import 'cart_models.dart';
import 'stock_allocator.dart';

class CheckoutRepository {
  CheckoutRepository(this.db);

  final AppDatabase db;

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
    return amountPaidMinor - cart.totalMinor;
  }
}
