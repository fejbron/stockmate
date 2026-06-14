import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stockmate/src/inventory/inventory_providers.dart';
import 'package:stockmate/src/inventory/inventory_repository.dart';
import 'package:stockmate/src/inventory/inventory_screen.dart';

void main() {
  testWidgets('shows saved products with current stock', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          inventoryItemsProvider.overrideWithValue(
            const AsyncData([
              ProductInventoryItem(
                id: 1,
                name: 'Milo Tin',
                sellingPriceMinor: 2550,
                stockQuantity: 12,
              ),
            ]),
          ),
        ],
        child: const MaterialApp(home: InventoryScreen()),
      ),
    );
    await tester.pump();

    expect(find.text('Milo Tin'), findsOneWidget);
    expect(find.text('12 in stock'), findsOneWidget);
    expect(find.text('25.50'), findsOneWidget);
    expect(find.text('No products yet'), findsNothing);
  });
}
