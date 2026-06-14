import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stockmate/src/checkout/checkout_providers.dart';
import 'package:stockmate/src/checkout/checkout_repository.dart';
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
}
