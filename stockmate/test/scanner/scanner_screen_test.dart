import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:stockmate/src/data/app_database.dart';
import 'package:stockmate/src/data/database_provider.dart';
import 'package:stockmate/src/scanner/scanner_screen.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  testWidgets('releases the camera before opening checkout for a sale', (
    tester,
  ) async {
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

    final controller = RecordingScannerController();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: MaterialApp(home: ScannerScreen(controller: controller)),
      ),
    );

    await tester.enterText(find.byType(TextField), 'MILK-1');
    await tester.tap(find.text('Use Code'));
    // Cannot use pumpAndSettle: the injected controller keeps MobileScanner in
    // its placeholder state, whose progress indicator animates indefinitely.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Record Sale'), findsOneWidget);

    final stopsBeforeCheckout = controller.stopCalls;
    await tester.tap(find.text('Record Sale'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Add Order'), findsOneWidget);
    expect(
      controller.stopCalls,
      greaterThan(stopsBeforeCheckout),
      reason: 'the scan-tab camera must be released so the checkout '
          'scanner can acquire it',
    );
  });

  testWidgets('manual scan result stays visible', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: ScannerScreen()),
      ),
    );

    await tester.enterText(find.byType(TextField), '  INT-000001  ');
    await tester.tap(find.text('Use Code'));
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Unknown product'), findsOneWidget);
    expect(find.text('Last scanned: INT-000001'), findsOneWidget);
    expect(find.text('Add New Product'), findsOneWidget);
    expect(find.text('Link to Existing Product'), findsOneWidget);
  });

  testWidgets('camera fallback explains manual entry', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: ScannerCameraFallback())),
    );

    expect(find.text('Camera unavailable'), findsOneWidget);
    expect(find.text('Enter the product code manually below.'), findsOneWidget);
  });
}

/// A [MobileScannerController] that records start/stop calls without touching
/// the camera platform channels, so tests can assert lifecycle behaviour.
class RecordingScannerController extends MobileScannerController {
  int startCalls = 0;
  int stopCalls = 0;

  @override
  Future<void> start({
    CameraFacing? cameraDirection,
    CameraLensType? cameraLensType,
  }) async {
    startCalls++;
  }

  @override
  Future<void> stop() async {
    stopCalls++;
  }
}
