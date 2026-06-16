import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stockmate/src/data/app_database.dart';
import 'package:stockmate/src/checkout/checkout_repository.dart';

void main() {
  late AppDatabase db;
  late CheckoutRepository repository;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repository = CheckoutRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('finds an active product by barcode with current stock', () async {
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
            codeValue: '8991234567890',
            codeType: 'barcode',
            source: 'manufacturer',
          ),
        );
    await db
        .into(db.stockBatches)
        .insert(
          StockBatchesCompanion.insert(
            productId: productId,
            quantityReceived: 12,
            quantityRemaining: 9,
            costPerUnitMinor: 1700,
          ),
        );

    final product = await repository.findProductByCode(' 8991234567890 ');

    expect(product, isNotNull);
    expect(product!.name, 'Milo Tin');
    expect(product.stockQuantity, 9);
    expect(product.sellingPriceMinor, 2550);
  });
}
