import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stockmate/src/checkout/checkout_screen.dart';

void main() {
  testWidgets('empty checkout prompts scanning or searching', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: CheckoutScreen()));

    expect(find.text('Checkout'), findsOneWidget);
    expect(
      find.text('Scan or search products to add them to the cart.'),
      findsOneWidget,
    );
  });
}
