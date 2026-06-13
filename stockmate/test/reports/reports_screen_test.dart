import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stockmate/src/reports/reports_screen.dart';

void main() {
  testWidgets('reports screen exposes required report types', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ReportsScreen()));

    expect(find.text('Revenue'), findsOneWidget);
    expect(find.text('Gross Profit'), findsOneWidget);
    expect(find.text('Top Products'), findsOneWidget);
    expect(find.text('Stock Value'), findsOneWidget);
  });
}
