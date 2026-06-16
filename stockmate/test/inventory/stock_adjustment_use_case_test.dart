import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stockmate/src/data/app_database.dart';
import 'package:stockmate/src/inventory/inventory_repository.dart';
import 'package:stockmate/src/inventory/stock_adjustment_use_case.dart';

void main() {
  late AppDatabase db;
  late StockAdjustmentUseCase useCase;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    useCase = StockAdjustmentUseCase(InventoryRepository(db));
  });

  tearDown(() => db.close());

  test('blocks negative adjustment beyond available stock', () async {
    final productId = await db
        .into(db.products)
        .insert(ProductsCompanion.insert(name: 'Soap', sellingPriceMinor: 700));
    await db
        .into(db.stockBatches)
        .insert(
          StockBatchesCompanion.insert(
            productId: productId,
            quantityReceived: 3,
            quantityRemaining: 3,
            costPerUnitMinor: 450,
          ),
        );

    final result = await useCase.adjustStock(
      productId: productId,
      adjustmentQuantity: -4,
      reason: 'loss',
      note: 'Count correction',
    );

    expect(result.isSuccess, false);
    expect(
      result.message,
      'Cannot reduce stock below zero. Available stock is 3.',
    );
  });

  test('reduces oldest stock batches for negative adjustment', () async {
    final productId = await db
        .into(db.products)
        .insert(ProductsCompanion.insert(name: 'Soap', sellingPriceMinor: 700));
    await db
        .into(db.stockBatches)
        .insert(
          StockBatchesCompanion.insert(
            productId: productId,
            quantityReceived: 2,
            quantityRemaining: 2,
            costPerUnitMinor: 400,
            receivedAt: Value(DateTime(2026, 1, 1)),
          ),
        );
    await db
        .into(db.stockBatches)
        .insert(
          StockBatchesCompanion.insert(
            productId: productId,
            quantityReceived: 5,
            quantityRemaining: 5,
            costPerUnitMinor: 450,
            receivedAt: Value(DateTime(2026, 2, 1)),
          ),
        );

    final result = await useCase.adjustStock(
      productId: productId,
      adjustmentQuantity: -4,
      reason: 'damage',
      note: 'Broken items',
    );

    final batches = await db.select(db.stockBatches).get();
    final adjustment = await db.select(db.stockAdjustments).getSingle();

    expect(result.isSuccess, true);
    expect(batches[0].quantityRemaining, 0);
    expect(batches[1].quantityRemaining, 3);
    expect(adjustment.reason, 'damage');
  });
}
