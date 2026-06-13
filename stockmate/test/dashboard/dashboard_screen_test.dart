import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stockmate/src/dashboard/dashboard_screen.dart';

void main() {
  testWidgets('dashboard shows sales summary labels', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: DashboardScreen()));

    expect(find.text('Today'), findsOneWidget);
    expect(find.text('Revenue'), findsOneWidget);
    expect(find.text('Gross Profit'), findsOneWidget);
    expect(find.text('Low Stock'), findsOneWidget);
  });
}
