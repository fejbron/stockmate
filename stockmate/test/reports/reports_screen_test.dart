import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stockmate/src/reports/reports_providers.dart';
import 'package:stockmate/src/reports/reports_repository.dart';
import 'package:stockmate/src/reports/reports_screen.dart';

void main() {
  testWidgets('reports screen shows live report totals', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          reportsSummaryProvider.overrideWithValue(
            const AsyncData(
              ReportsSummary(
                revenueMinor: 1000,
                grossProfitMinor: 400,
                stockValueMinor: 900,
                topProducts: [
                  ReportTopProduct(
                    name: 'Milk',
                    quantitySold: 2,
                    revenueMinor: 1000,
                  ),
                ],
              ),
            ),
          ),
        ],
        child: const MaterialApp(home: ReportsScreen()),
      ),
    );

    expect(find.text('Revenue'), findsOneWidget);
    expect(find.text('₵ 10.00'), findsWidgets);
    expect(find.text('Gross Profit'), findsOneWidget);
    expect(find.text('₵ 4.00'), findsOneWidget);
    expect(find.text('Top Products'), findsOneWidget);
    expect(find.text('Milk'), findsOneWidget);
    expect(find.text('Stock Value'), findsOneWidget);
    expect(find.text('₵ 9.00'), findsOneWidget);
  });
}
