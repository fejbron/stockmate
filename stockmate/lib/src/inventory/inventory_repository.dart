import 'package:drift/drift.dart';

import '../data/app_database.dart';

class ProductInventoryItem {
  const ProductInventoryItem({
    required this.id,
    required this.name,
    required this.sellingPriceMinor,
    required this.stockQuantity,
  });

  final int id;
  final String name;
  final int sellingPriceMinor;
  final int stockQuantity;
}

class EditableProduct {
  const EditableProduct({
    required this.id,
    required this.name,
    required this.codeValue,
    required this.sellingPriceMinor,
    required this.lowStockThreshold,
  });

  final int id;
  final String name;
  final String codeValue;
  final int sellingPriceMinor;
  final int lowStockThreshold;
}

class InventoryRepository {
  InventoryRepository(this.db);

  final AppDatabase db;

  Stream<List<ProductInventoryItem>> watchInventoryItems() {
    return db
        .customSelect(
          '''
          SELECT
            p.id,
            p.name,
            p.selling_price_minor,
            COALESCE(SUM(sb.quantity_remaining), 0) AS stock_quantity
          FROM products p
          LEFT JOIN stock_batches sb ON sb.product_id = p.id
          WHERE p.is_active = 1
          GROUP BY p.id, p.name, p.selling_price_minor
          ORDER BY LOWER(p.name)
          ''',
          readsFrom: {db.products, db.stockBatches},
        )
        .watch()
        .map(
          (rows) => [
            for (final row in rows)
              ProductInventoryItem(
                id: row.read<int>('id'),
                name: row.read<String>('name'),
                sellingPriceMinor: row.read<int>('selling_price_minor'),
                stockQuantity: row.read<int>('stock_quantity'),
              ),
          ],
        );
  }

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

  Future<EditableProduct?> productForEdit(int productId) async {
    final rows = await db
        .customSelect(
          '''
          SELECT
            p.id,
            p.name,
            p.selling_price_minor,
            p.low_stock_threshold,
            pc.code_value
          FROM products p
          LEFT JOIN product_codes pc
            ON pc.product_id = p.id AND pc.is_primary = 1
          WHERE p.id = ?
          LIMIT 1
          ''',
          variables: [Variable(productId)],
          readsFrom: {db.products, db.productCodes},
        )
        .get();

    if (rows.isEmpty) {
      return null;
    }

    final row = rows.single;
    return EditableProduct(
      id: row.read<int>('id'),
      name: row.read<String>('name'),
      codeValue: row.read<String?>('code_value') ?? '',
      sellingPriceMinor: row.read<int>('selling_price_minor'),
      lowStockThreshold: row.read<int>('low_stock_threshold'),
    );
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

  Future<void> updateProduct({
    required int productId,
    required String name,
    required String codeValue,
    required int sellingPriceMinor,
    required int lowStockThreshold,
    required int quantityReceived,
    required int costPerUnitMinor,
  }) {
    return db.transaction(() async {
      await (db.update(
        db.products,
      )..where((row) => row.id.equals(productId))).write(
        ProductsCompanion(
          name: Value(name),
          sellingPriceMinor: Value(sellingPriceMinor),
          lowStockThreshold: Value(lowStockThreshold),
          updatedAt: Value(DateTime.now()),
        ),
      );

      await _upsertPrimaryCode(productId: productId, codeValue: codeValue);

      if (quantityReceived > 0) {
        await db
            .into(db.stockBatches)
            .insert(
              StockBatchesCompanion.insert(
                productId: productId,
                quantityReceived: quantityReceived,
                quantityRemaining: quantityReceived,
                costPerUnitMinor: costPerUnitMinor,
                note: const Value('Stock added while editing product'),
              ),
            );
      }
    });
  }

  Future<void> deactivateProduct(int productId) {
    return (db.update(
      db.products,
    )..where((row) => row.id.equals(productId))).write(
      ProductsCompanion(
        isActive: const Value(false),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> _upsertPrimaryCode({
    required int productId,
    required String codeValue,
  }) async {
    final trimmedCode = codeValue.trim();
    if (trimmedCode.isEmpty) {
      return;
    }

    final existingCodes =
        await (db.select(db.productCodes)
              ..where(
                (row) =>
                    row.productId.equals(productId) &
                    row.isPrimary.equals(true),
              )
              ..limit(1))
            .get();

    if (existingCodes.isEmpty) {
      await db
          .into(db.productCodes)
          .insert(
            ProductCodesCompanion.insert(
              productId: productId,
              codeValue: trimmedCode,
              codeType: 'barcode',
              source: 'scanned',
              isPrimary: const Value(true),
            ),
          );
      return;
    }

    await (db.update(
      db.productCodes,
    )..where((row) => row.id.equals(existingCodes.single.id))).write(
      ProductCodesCompanion(
        codeValue: Value(trimmedCode),
        codeType: const Value('barcode'),
        source: const Value('scanned'),
        isPrimary: const Value(true),
      ),
    );
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
