import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stockmate/src/data/app_database.dart';
import 'package:stockmate/src/inventory/add_stock_use_case.dart';
import 'package:stockmate/src/inventory/inventory_repository.dart';

void main() {
  late AppDatabase db;
  late AddStockUseCase useCase;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    useCase = AddStockUseCase(InventoryRepository(db));
  });

  tearDown(() => db.close());

  test(
    'creates product, code alias, and stock batch in one workflow',
    () async {
      final productId = await useCase.createProductWithStock(
        name: 'Rice 5kg',
        codeValue: 'INT-RICE-5KG',
        codeType: 'internal',
        source: 'generated',
        sellingPriceMinor: 12000,
        quantityReceived: 10,
        costPerUnitMinor: 9000,
        lowStockThreshold: 2,
      );

      final product = await (db.select(
        db.products,
      )..where((row) => row.id.equals(productId))).getSingle();
      final code = await db.select(db.productCodes).getSingle();
      final batch = await db.select(db.stockBatches).getSingle();

      expect(product.name, 'Rice 5kg');
      expect(code.codeValue, 'INT-RICE-5KG');
      expect(batch.quantityRemaining, 10);
    },
  );
}
