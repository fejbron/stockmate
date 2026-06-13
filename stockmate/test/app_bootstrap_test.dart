import 'package:flutter_test/flutter_test.dart';
import 'package:stockmate/main.dart' as app;

void main() {
  testWidgets('app boots to dashboard tab', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    expect(find.text('Dashboard'), findsWidgets);
    expect(find.text('Inventory'), findsOneWidget);
    expect(find.text('Scan'), findsOneWidget);
    expect(find.text('Sales'), findsOneWidget);
    expect(find.text('Reports'), findsOneWidget);
  });
}
