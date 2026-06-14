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
}
