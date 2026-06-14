import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
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
  });

  testWidgets('camera fallback explains manual entry', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: ScannerCameraFallback())),
    );

    expect(find.text('Camera unavailable'), findsOneWidget);
    expect(find.text('Enter the product code manually below.'), findsOneWidget);
  });
}
