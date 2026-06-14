import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stockmate/src/scanner/scanner_screen.dart';

void main() {
  testWidgets('manual scan result stays visible', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ScannerScreen()));

    await tester.enterText(find.byType(TextField), '  INT-000001  ');
    await tester.tap(find.text('Use Code'));
    await tester.pump();

    expect(find.text('Last scanned'), findsOneWidget);
    expect(find.text('INT-000001'), findsOneWidget);
  });

  testWidgets('camera fallback explains manual entry', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: ScannerCameraFallback())),
    );

    expect(find.text('Camera unavailable'), findsOneWidget);
    expect(find.text('Enter the product code manually below.'), findsOneWidget);
  });
}
