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
        child: MaterialApp(
          home: CheckoutScreen(scannerBuilder: inertScannerBuilder),
        ),
      ),
    );

    expect(find.text('Add Order'), findsOneWidget);
    expect(find.text('Order Items'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('orderCodeField')), 'MILK-1');
    await tester.tap(find.byKey(const Key('manualAddOrderButton')));
    await tester.pumpAndSettle();

    expect(find.text('Milk'), findsOneWidget);
    expect(find.text('5.00'), findsWidgets);
    expect(
      tester.widget<Text>(find.byKey(Key('orderLineQuantity-$productId'))).data,
      '1',
    );

    await tester.tap(find.byTooltip('Increase quantity').first);
    await tester.pumpAndSettle();
    expect(
      tester.widget<Text>(find.byKey(Key('orderLineQuantity-$productId'))).data,
      '2',
    );

    await tester.tap(find.byKey(const Key('openOrderInfoButton')));
    await tester.pumpAndSettle();

    expect(find.text('Order info'), findsOneWidget);
    expect(find.text('Total price'), findsOneWidget);
    expect(find.text('10.00'), findsWidgets);

    await tester.enterText(find.bySemanticsLabel('Discount'), '1');
    await tester.pumpAndSettle();
    expect(find.text('9.00'), findsWidgets);

    await tester.enterText(find.bySemanticsLabel('Amount Paid'), '4');
    await tester.pumpAndSettle();
    expect(find.text('5.00'), findsWidgets);

    await tester.ensureVisible(find.byKey(const Key('submitOrderButton')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('submitOrderButton')));
    await tester.pump();

    expect(await db.select(db.sales).get(), hasLength(1));
    final sale = await db.select(db.sales).getSingle();
    expect(sale.discountTotalMinor, 100);
    expect(sale.amountPaidMinor, 400);
    expect((await db.select(db.stockBatches).getSingle()).quantityRemaining, 1);
    expect(
      find.text('Search or scan to add products to this order.'),
      findsOneWidget,
    );
  });

  testWidgets('adds product when order scanner detects a code', (tester) async {
    final productId = await db
        .into(db.products)
        .insert(
          ProductsCompanion.insert(name: 'Nido', sellingPriceMinor: 4500),
        );
    await db
        .into(db.productCodes)
        .insert(
          ProductCodesCompanion.insert(
            productId: productId,
            codeValue: 'NIDO-1',
            codeType: 'barcode',
            source: 'manufacturer',
          ),
        );
    await db
        .into(db.stockBatches)
        .insert(
          StockBatchesCompanion.insert(
            productId: productId,
            quantityReceived: 4,
            quantityRemaining: 4,
            costPerUnitMinor: 2800,
          ),
        );

    CheckoutCodeDetected? detectedCode;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: MaterialApp(
          home: CheckoutScreen(
            scannerBuilder: (context, onCodeDetected) {
              detectedCode = onCodeDetected;
              return const ColoredBox(
                key: Key('fakeCheckoutScanner'),
                color: Color(0xFF111827),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('openOrderScannerButton')));
    await tester.pumpAndSettle();

    expect(find.text('Scan barcode'), findsOneWidget);
    detectedCode!('NIDO-1');
    await tester.pumpAndSettle();

    expect(find.text('Nido'), findsOneWidget);
    expect(
      tester.widget<Text>(find.byKey(Key('orderLineQuantity-$productId'))).data,
      '1',
    );
  });
}

Widget inertScannerBuilder(
  BuildContext context,
  CheckoutCodeDetected onCodeDetected,
) {
  return const ColoredBox(
    color: Color(0xFF111827),
    child: Center(
      child: Text('Scanner ready', style: TextStyle(color: Colors.white)),
    ),
  );
}
