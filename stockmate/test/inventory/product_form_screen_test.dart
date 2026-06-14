import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stockmate/src/data/app_database.dart';
import 'package:stockmate/src/data/database_provider.dart';
import 'package:stockmate/src/inventory/product_form_screen.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  testWidgets('requires product name before save', (tester) async {
    await tester.pumpWidget(_testApp(db));

    await tester.tap(find.text('Save Product'));
    await tester.pump();

    expect(find.text('Enter product name'), findsOneWidget);
  });

  testWidgets('saves valid product with initial stock', (tester) async {
    await tester.pumpWidget(_testApp(db));

    await tester.enterText(find.bySemanticsLabel('Product name'), 'Milo Tin');
    await tester.enterText(find.bySemanticsLabel('Selling price'), '25.50');
    await tester.enterText(find.bySemanticsLabel('Quantity received'), '12');
    await tester.enterText(find.bySemanticsLabel('Cost per unit'), '17.00');
    await tester.tap(find.text('Save Product'));
    await tester.pump();
    await tester.pump();

    final product = await db.select(db.products).getSingle();
    final code = await db.select(db.productCodes).getSingle();
    final batch = await db.select(db.stockBatches).getSingle();

    expect(product.name, 'Milo Tin');
    expect(product.sellingPriceMinor, 2550);
    expect(code.codeType, 'internal');
    expect(code.source, 'generated');
    expect(batch.quantityReceived, 12);
    expect(batch.quantityRemaining, 12);
    expect(batch.costPerUnitMinor, 1700);
    expect(find.text('Product saved'), findsOneWidget);
  });
}

Widget _testApp(AppDatabase db) {
  return ProviderScope(
    overrides: [databaseProvider.overrideWithValue(db)],
    child: const MaterialApp(home: ProductFormScreen()),
  );
}
