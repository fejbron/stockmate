import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stockmate/src/checkout/checkout_screen.dart';
import 'package:stockmate/src/data/app_database.dart';
import 'package:stockmate/src/data/database_provider.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  testWidgets('looks up code and records a sale', (tester) async {
    final productId = await db
        .into(db.products)
        .insert(ProductsCompanion.insert(name: 'Milk', sellingPriceMinor: 500));
    await db
        .into(db.productCodes)
        .insert(
          ProductCodesCompanion.insert(
            productId: productId,
            codeValue: 'MILK-1',
            codeType: 'barcode',
            source: 'manufacturer',
          ),
        );
    await db
        .into(db.stockBatches)
        .insert(
          StockBatchesCompanion.insert(
            productId: productId,
            quantityReceived: 3,
            quantityRemaining: 3,
            costPerUnitMinor: 300,
          ),
        );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: CheckoutScreen()),
      ),
    );

    expect(find.text('Checkout'), findsOneWidget);

    await tester.enterText(
      find.bySemanticsLabel('Barcode or product code'),
      'MILK-1',
    );
    await tester.tap(find.text('Add Product'));
    await tester.pumpAndSettle();

    expect(find.text('Milk'), findsOneWidget);
    expect(find.text('1 in cart'), findsOneWidget);

    await tester.tap(find.text('Record Sale'));
    await tester.pump();

    expect(await db.select(db.sales).get(), hasLength(1));
    expect((await db.select(db.stockBatches).getSingle()).quantityRemaining, 2);
    expect(
      find.text('Scan a product or enter its code to add it to this sale.'),
      findsOneWidget,
    );
  });
}
