import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stockmate/src/checkout/checkout_providers.dart';
import 'package:stockmate/src/checkout/checkout_repository.dart';
import 'package:stockmate/src/data/app_database.dart';
import 'package:stockmate/src/data/database_provider.dart';
import 'package:stockmate/src/sales/sales_history_screen.dart';

void main() {
  testWidgets('sales history shows recent sales and record sale action', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          recentSalesProvider.overrideWithValue(
            AsyncData([
              SaleListItem(
                id: 1,
                receiptNumber: 'R-1',
                soldAt: DateTime(2026, 6, 14, 10),
                totalMinor: 1000,
                grossProfitMinor: 400,
                itemCount: 2,
              ),
            ]),
          ),
        ],
        child: const MaterialApp(home: SalesHistoryScreen()),
      ),
    );

    expect(find.text('Sales'), findsOneWidget);
    expect(find.text('Record Sale'), findsOneWidget);
    expect(find.text('R-1'), findsOneWidget);
    expect(find.text('10.00'), findsOneWidget);
  });

  testWidgets('opens receipt detail from a sale row', (tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    final productId = await db
        .into(db.products)
        .insert(ProductsCompanion.insert(name: 'Milk', sellingPriceMinor: 500));
    final saleId = await db
        .into(db.sales)
        .insert(
          SalesCompanion.insert(
            receiptNumber: 'R-1',
            soldAt: Value(DateTime(2026, 6, 14, 10)),
            subtotalMinor: 1000,
            totalMinor: 1000,
            costTotalMinor: 600,
            grossProfitMinor: 400,
            paymentMethod: 'cash',
            amountPaidMinor: const Value(1200),
            changeDueMinor: const Value(200),
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
    await db
        .into(db.receipts)
        .insert(ReceiptsCompanion.insert(saleId: saleId, receiptNumber: 'R-1'));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: SalesHistoryScreen()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    await tester.tap(find.text('R-1'));
    await tester.pumpAndSettle();

    expect(find.text('Receipt R-1'), findsOneWidget);
    expect(find.text('Milk'), findsOneWidget);
    expect(find.text('2 x 5.00'), findsOneWidget);
    expect(find.text('Amount paid'), findsOneWidget);
    expect(find.text('12.00'), findsOneWidget);

    await _clearWidgetTree(tester);
  });
}

Future<void> _clearWidgetTree(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump(const Duration(milliseconds: 1));
}
