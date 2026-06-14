import 'package:drift/drift.dart';
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

  testWidgets('edits existing product details', (tester) async {
    final productId = await db
        .into(db.products)
        .insert(
          ProductsCompanion.insert(name: 'Milo Tin', sellingPriceMinor: 2550),
        );
    await db
        .into(db.productCodes)
        .insert(
          ProductCodesCompanion.insert(
            productId: productId,
            codeValue: 'OLD-CODE',
            codeType: 'barcode',
            source: 'scanned',
            isPrimary: const Value(true),
          ),
        );

    await tester.pumpWidget(_testApp(db, productId: productId));
    await tester.pump();
    await tester.pump();

    expect(find.text('Edit Product'), findsOneWidget);

    await tester.enterText(
      find.bySemanticsLabel('Product name'),
      'Milo Sachet',
    );
    await tester.enterText(find.bySemanticsLabel('Selling price'), '30.00');
    await tester.enterText(find.bySemanticsLabel('Product code'), 'NEW-CODE');
    await tester.tap(find.text('Update Product'));
    await tester.pump();
    await tester.pump();

    final product = await db.select(db.products).getSingle();
    final code = await db.select(db.productCodes).getSingle();

    expect(product.name, 'Milo Sachet');
    expect(product.sellingPriceMinor, 3000);
    expect(code.codeValue, 'NEW-CODE');
    expect(find.text('Product updated'), findsOneWidget);

    await _clearWidgetTree(tester);
  });

  testWidgets('shows and adds barcode aliases in edit mode', (tester) async {
    final productId = await db
        .into(db.products)
        .insert(
          ProductsCompanion.insert(name: 'Milo Tin', sellingPriceMinor: 2550),
        );
    await db
        .into(db.productCodes)
        .insert(
          ProductCodesCompanion.insert(
            productId: productId,
            codeValue: 'PRIMARY-CODE',
            codeType: 'barcode',
            source: 'scanned',
            isPrimary: const Value(true),
          ),
        );

    await tester.pumpWidget(_testApp(db, productId: productId));
    await tester.pump();
    await tester.pump();

    expect(find.text('Barcodes'), findsOneWidget);
    expect(find.text('PRIMARY-CODE'), findsWidgets);
    expect(find.text('Primary'), findsOneWidget);

    await tester.drag(find.byType(ListView), const Offset(0, -320));
    await tester.pump();
    await tester.enterText(
      find.byKey(const Key('additionalBarcodeField')),
      'ALIAS-CODE',
    );
    await tester.tap(find.text('Add Barcode'));
    await tester.pump();
    await tester.pump();

    final codes = await (db.select(
      db.productCodes,
    )..orderBy([(row) => OrderingTerm.asc(row.codeValue)])).get();

    expect(codes.map((code) => code.codeValue), ['ALIAS-CODE', 'PRIMARY-CODE']);
    expect(find.text('Barcode added'), findsOneWidget);

    await _clearWidgetTree(tester);
  });
}

Widget _testApp(AppDatabase db, {int? productId}) {
  return ProviderScope(
    overrides: [databaseProvider.overrideWithValue(db)],
    child: MaterialApp(home: ProductFormScreen(productId: productId)),
  );
}

Future<void> _clearWidgetTree(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump(const Duration(milliseconds: 1));
}
