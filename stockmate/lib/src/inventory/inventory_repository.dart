import 'package:drift/drift.dart';

import '../data/app_database.dart';

class InventoryRepository {
  InventoryRepository(this.db);

  final AppDatabase db;

  Future<int> currentStock(int productId) async {
    final batches = await (db.select(
      db.stockBatches,
    )..where((row) => row.productId.equals(productId))).get();
    var total = 0;
    for (final batch in batches) {
      total += batch.quantityRemaining;
    }
    return total;
  }

  Future<int> createProductWithStock({
    required String name,
    required String codeValue,
    required String codeType,
    required String source,
    required int sellingPriceMinor,
    required int quantityReceived,
    required int costPerUnitMinor,
    required int lowStockThreshold,
  }) {
    return db.transaction(() async {
      final productId = await db
          .into(db.products)
          .insert(
            ProductsCompanion.insert(
              name: name,
              sellingPriceMinor: sellingPriceMinor,
              lowStockThreshold: Value(lowStockThreshold),
            ),
          );

      await db
          .into(db.productCodes)
          .insert(
            ProductCodesCompanion.insert(
              productId: productId,
              codeValue: codeValue,
              codeType: codeType,
              source: source,
              isPrimary: const Value(true),
            ),
          );

      await db
          .into(db.stockBatches)
          .insert(
            StockBatchesCompanion.insert(
              productId: productId,
              quantityReceived: quantityReceived,
              quantityRemaining: quantityReceived,
              costPerUnitMinor: costPerUnitMinor,
            ),
          );

      return productId;
    });
  }

  Future<void> addStockAdjustment({
    required int productId,
    required int adjustmentQuantity,
    required String reason,
    required String? note,
  }) {
    return db.transaction(() async {
      await db
          .into(db.stockAdjustments)
          .insert(
            StockAdjustmentsCompanion.insert(
              productId: productId,
              adjustmentQuantity: adjustmentQuantity,
              reason: reason,
              note: Value(note),
            ),
          );

      if (adjustmentQuantity > 0) {
        await db
            .into(db.stockBatches)
            .insert(
              StockBatchesCompanion.insert(
                productId: productId,
                quantityReceived: adjustmentQuantity,
                quantityRemaining: adjustmentQuantity,
                costPerUnitMinor: 0,
                note: const Value('Manual stock increase'),
              ),
            );
      } else if (adjustmentQuantity < 0) {
        var remainingToRemove = -adjustmentQuantity;
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

        for (final batch in batches) {
          if (remainingToRemove == 0) {
            break;
          }
          final remove = batch.quantityRemaining < remainingToRemove
              ? batch.quantityRemaining
              : remainingToRemove;
          await (db.update(
            db.stockBatches,
          )..where((row) => row.id.equals(batch.id))).write(
            StockBatchesCompanion(
              quantityRemaining: Value(batch.quantityRemaining - remove),
            ),
          );
          remainingToRemove -= remove;
        }
      }
    });
  }
}
