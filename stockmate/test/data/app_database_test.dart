import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stockmate/src/data/app_database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  test('stores product with unique code and stock batch', () async {
    final productId = await db
        .into(db.products)
        .insert(
          ProductsCompanion.insert(
            name: 'Milo Tin',
            sellingPriceMinor: 2500,
            lowStockThreshold: const Value(3),
          ),
        );

    await db
        .into(db.productCodes)
        .insert(
          ProductCodesCompanion.insert(
            productId: productId,
            codeValue: '8991234567890',
            codeType: 'barcode',
            source: 'manufacturer',
            isPrimary: const Value(true),
          ),
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

    final product = await db.select(db.products).getSingle();
    final code = await db.select(db.productCodes).getSingle();
    final batch = await db.select(db.stockBatches).getSingle();

    expect(product.name, 'Milo Tin');
    expect(code.codeValue, '8991234567890');
    expect(batch.quantityRemaining, 12);
  });

  test('prevents duplicate product codes', () async {
    final first = await db
        .into(db.products)
        .insert(
          ProductsCompanion.insert(name: 'Item A', sellingPriceMinor: 1000),
        );
    final second = await db
        .into(db.products)
        .insert(
          ProductsCompanion.insert(name: 'Item B', sellingPriceMinor: 1200),
        );

    await db
        .into(db.productCodes)
        .insert(
          ProductCodesCompanion.insert(
            productId: first,
            codeValue: 'DUPLICATE',
            codeType: 'internal',
            source: 'generated',
          ),
        );

    expect(
      () => db
          .into(db.productCodes)
          .insert(
            ProductCodesCompanion.insert(
              productId: second,
              codeValue: 'DUPLICATE',
              codeType: 'internal',
              source: 'generated',
            ),
          ),
      throwsA(isA<SqliteException>()),
    );
  });
}
