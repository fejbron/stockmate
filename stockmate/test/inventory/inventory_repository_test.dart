import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stockmate/src/data/app_database.dart';
import 'package:stockmate/src/inventory/inventory_repository.dart';

void main() {
  late AppDatabase db;
  late InventoryRepository repository;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repository = InventoryRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('watches active products with current stock totals', () async {
    final productId = await db
        .into(db.products)
        .insert(
          ProductsCompanion.insert(name: 'Milo Tin', sellingPriceMinor: 2550),
        );
    await db
        .into(db.stockBatches)
        .insert(
          StockBatchesCompanion.insert(
            productId: productId,
            quantityReceived: 12,
            quantityRemaining: 12,
            costPerUnitMinor: 1700,
          ),
        );

    final items = await repository.watchInventoryItems().first;

    expect(items, hasLength(1));
    expect(items.single.name, 'Milo Tin');
    expect(items.single.sellingPriceMinor, 2550);
    expect(items.single.stockQuantity, 12);
  });

  test('updates product details and primary code', () async {
    final productId = await db
        .into(db.products)
        .insert(
          ProductsCompanion.insert(name: 'Milo Tin', sellingPriceMinor: 2550),
        );
    await db
        .into(db.productCodes)
        .insert(
          ProductCodesCompanion.insert(
            productId: productId,
            codeValue: 'OLD-CODE',
            codeType: 'barcode',
            source: 'scanned',
            isPrimary: const Value(true),
          ),
        );

    await repository.updateProduct(
      productId: productId,
      name: 'Milo Sachet',
      codeValue: 'NEW-CODE',
      sellingPriceMinor: 3000,
      lowStockThreshold: 2,
      quantityReceived: 4,
      costPerUnitMinor: 1800,
    );

    final product = await db.select(db.products).getSingle();
    final code = await db.select(db.productCodes).getSingle();
    final batch = await db.select(db.stockBatches).getSingle();

    expect(product.name, 'Milo Sachet');
    expect(product.sellingPriceMinor, 3000);
    expect(product.lowStockThreshold, 2);
    expect(code.codeValue, 'NEW-CODE');
    expect(batch.quantityRemaining, 4);
  });

  test('soft deletes product from active inventory', () async {
    final productId = await db
        .into(db.products)
        .insert(
          ProductsCompanion.insert(name: 'Milo Tin', sellingPriceMinor: 2550),
        );

    await repository.deactivateProduct(productId);

    final product = await db.select(db.products).getSingle();
    final items = await repository.watchInventoryItems().first;

    expect(product.isActive, false);
    expect(items, isEmpty);
  });
}
