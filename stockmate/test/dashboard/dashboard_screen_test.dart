import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stockmate/src/dashboard/dashboard_providers.dart';
import 'package:stockmate/src/dashboard/dashboard_repository.dart';
import 'package:stockmate/src/dashboard/dashboard_screen.dart';

void main() {
  testWidgets('dashboard shows live sales summary metrics', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          dashboardMetricsProvider.overrideWithValue(
            const AsyncData(
              DashboardMetrics(
                revenueMinor: 2550,
                grossProfitMinor: 850,
                salesCount: 1,
                lowStockCount: 2,
              ),
            ),
          ),
        ],
        child: const MaterialApp(home: DashboardScreen()),
      ),
    );
    await tester.pump();

    expect(find.text('Today'), findsOneWidget);
    expect(find.text('Revenue'), findsOneWidget);
    expect(
      find.byKey(const Key('stockmateLogo'), skipOffstage: false),
      findsOneWidget,
    );
    expect(find.text('25.50'), findsOneWidget);
    expect(find.text('Gross Profit'), findsOneWidget);
    expect(find.text('8.50'), findsOneWidget);
    expect(find.text('Low Stock'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
  });
}
