import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:stockmate/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('app opens dashboard and navigates main tabs', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    expect(find.text('Today'), findsOneWidget);

    await tester.tap(_navText('Inventory'));
    await tester.pumpAndSettle();
    expect(find.text('Inventory'), findsWidgets);

    await tester.tap(_navText('Scan'));
    await tester.pumpAndSettle();
    expect(find.text('Scan Product'), findsOneWidget);

    await tester.tap(_navText('Sales'));
    await tester.pumpAndSettle();
    expect(find.text('Sales'), findsWidgets);

    await tester.tap(_navText('Reports'));
    await tester.pumpAndSettle();
    expect(find.text('Reports'), findsWidgets);
  });
}

Finder _navText(String label) {
  return find.descendant(
    of: find.byType(NavigationBar),
    matching: find.text(label),
  );
}
