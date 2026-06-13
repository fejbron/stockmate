import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stockmate/src/labels/label_screen.dart';

void main() {
  testWidgets('shows generated label code', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: LabelScreen(code: 'INT-000042-ABCD1234')),
    );

    expect(find.text('Product Label'), findsOneWidget);
    expect(find.text('INT-000042-ABCD1234'), findsOneWidget);
  });
}
