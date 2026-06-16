import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stockmate/src/dashboard/dashboard_repository.dart';
import 'package:stockmate/src/data/app_database.dart';

void main() {
  late AppDatabase db;
  late DashboardRepository repository;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repository = DashboardRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('watches sales and stock metrics from persisted data', () async {
    final productId = await db
        .into(db.products)
        .insert(
          ProductsCompanion.insert(
            name: 'Milo Tin',
            sellingPriceMinor: 2550,
            lowStockThreshold: const Value(3),
          ),
        );
    await db
        .into(db.stockBatches)
        .insert(
          StockBatchesCompanion.insert(
            productId: productId,
            quantityReceived: 3,
            quantityRemaining: 2,
            costPerUnitMinor: 1700,
          ),
        );
    await db
        .into(db.sales)
        .insert(
          SalesCompanion.insert(
            receiptNumber: 'R-1',
            subtotalMinor: 2550,
            totalMinor: 2550,
            costTotalMinor: 1700,
            grossProfitMinor: 850,
            paymentMethod: 'cash',
          ),
        );

    final metrics = await repository.watchMetrics().first;

    expect(metrics.revenueMinor, 2550);
    expect(metrics.grossProfitMinor, 850);
    expect(metrics.salesCount, 1);
    expect(metrics.lowStockCount, 1);
  });
}
