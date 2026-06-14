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

  test('links new barcode to existing product and adds stock', () async {
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
            codeValue: 'PRIMARY-CODE',
            codeType: 'barcode',
            source: 'scanned',
            isPrimary: const Value(true),
          ),
        );

    await repository.linkCodeToExistingProduct(
      productId: productId,
      codeValue: 'ALIAS-CODE',
      quantityReceived: 8,
      costPerUnitMinor: 1500,
    );

    final codes = await (db.select(
      db.productCodes,
    )..orderBy([(row) => OrderingTerm.asc(row.codeValue)])).get();
    final batch = await db.select(db.stockBatches).getSingle();
    final stock = await repository.currentStock(productId);

    expect(codes.map((code) => code.codeValue), ['ALIAS-CODE', 'PRIMARY-CODE']);
    expect(codes.first.isPrimary, false);
    expect(batch.quantityReceived, 8);
    expect(batch.quantityRemaining, 8);
    expect(batch.costPerUnitMinor, 1500);
    expect(stock, 8);
  });

  test('rejects duplicate barcode aliases', () async {
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
            codeValue: 'DUPLICATE-CODE',
            codeType: 'barcode',
            source: 'scanned',
            isPrimary: const Value(true),
          ),
        );

    expect(
      () => repository.linkCodeToExistingProduct(
        productId: productId,
        codeValue: 'DUPLICATE-CODE',
        quantityReceived: 1,
        costPerUnitMinor: 100,
      ),
      throwsA(isA<DuplicateProductCodeException>()),
    );
  });

  test('watches product codes and active product lookup items', () async {
    final activeId = await db
        .into(db.products)
        .insert(
          ProductsCompanion.insert(name: 'Milo Tin', sellingPriceMinor: 2550),
        );
    final inactiveId = await db
        .into(db.products)
        .insert(
          ProductsCompanion.insert(
            name: 'Old Product',
            sellingPriceMinor: 100,
            isActive: const Value(false),
          ),
        );
    await db
        .into(db.productCodes)
        .insert(
          ProductCodesCompanion.insert(
            productId: activeId,
            codeValue: 'PRIMARY-CODE',
            codeType: 'barcode',
            source: 'scanned',
            isPrimary: const Value(true),
          ),
        );
    await db
        .into(db.productCodes)
        .insert(
          ProductCodesCompanion.insert(
            productId: activeId,
            codeValue: 'ALIAS-CODE',
            codeType: 'barcode',
            source: 'scanned',
          ),
        );
    await db
        .into(db.productCodes)
        .insert(
          ProductCodesCompanion.insert(
            productId: inactiveId,
            codeValue: 'INACTIVE-CODE',
            codeType: 'barcode',
            source: 'scanned',
          ),
        );

    final codes = await repository.watchProductCodes(activeId).first;
    final products = await repository.watchActiveProductLookup().first;

    expect(codes.map((code) => code.codeValue), ['PRIMARY-CODE', 'ALIAS-CODE']);
    expect(codes.first.isPrimary, true);
    expect(products.map((product) => product.name), ['Milo Tin']);
  });

  test('deletes secondary code but protects primary code', () async {
    final productId = await db
        .into(db.products)
        .insert(
          ProductsCompanion.insert(name: 'Milo Tin', sellingPriceMinor: 2550),
        );
    final primaryCodeId = await db
        .into(db.productCodes)
        .insert(
          ProductCodesCompanion.insert(
            productId: productId,
            codeValue: 'PRIMARY-CODE',
            codeType: 'barcode',
            source: 'scanned',
            isPrimary: const Value(true),
          ),
        );
    final aliasCodeId = await db
        .into(db.productCodes)
        .insert(
          ProductCodesCompanion.insert(
            productId: productId,
            codeValue: 'ALIAS-CODE',
            codeType: 'barcode',
            source: 'scanned',
          ),
        );

    await repository.deleteProductCode(aliasCodeId);

    expect(
      () => repository.deleteProductCode(primaryCodeId),
      throwsA(isA<PrimaryProductCodeException>()),
    );

    final remainingCodes = await db.select(db.productCodes).get();
    expect(remainingCodes.map((code) => code.codeValue), ['PRIMARY-CODE']);
  });
}
