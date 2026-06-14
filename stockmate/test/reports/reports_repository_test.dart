import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stockmate/src/data/app_database.dart';
import 'package:stockmate/src/reports/reports_repository.dart';

void main() {
  late AppDatabase db;
  late ReportsRepository repository;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repository = ReportsRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('watches revenue, top products, and stock value', () async {
    final productId = await db
        .into(db.products)
        .insert(ProductsCompanion.insert(name: 'Milk', sellingPriceMinor: 500));
    await db
        .into(db.stockBatches)
        .insert(
          StockBatchesCompanion.insert(
            productId: productId,
            quantityReceived: 5,
            quantityRemaining: 3,
            costPerUnitMinor: 300,
          ),
        );
    final saleId = await db
        .into(db.sales)
        .insert(
          SalesCompanion.insert(
            receiptNumber: 'R-1',
            subtotalMinor: 1000,
            totalMinor: 1000,
            costTotalMinor: 600,
            grossProfitMinor: 400,
            paymentMethod: 'cash',
          ),
        );
    await db
        .into(db.saleLines)
        .insert(
          SaleLinesCompanion.insert(
            saleId: saleId,
            productId: productId,
            quantity: 2,
            unitPriceMinor: 500,
            lineTotalMinor: 1000,
            costTotalMinor: 600,
            grossProfitMinor: 400,
          ),
        );

    final summary = await repository.watchSummary().first;

    expect(summary.revenueMinor, 1000);
    expect(summary.grossProfitMinor, 400);
    expect(summary.stockValueMinor, 900);
    expect(summary.topProducts.single.name, 'Milk');
    expect(summary.topProducts.single.quantitySold, 2);
  });
}
