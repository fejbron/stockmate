import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stockmate/src/inventory/product_form_screen.dart';

void main() {
  testWidgets('requires product name before save', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ProductFormScreen()));

    await tester.tap(find.text('Save Product'));
    await tester.pump();

    expect(find.text('Enter product name'), findsOneWidget);
  });
}
