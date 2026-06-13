import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stockmate/src/app.dart';

void main() {
  testWidgets('app boots to dashboard tab', (tester) async {
    await tester.pumpWidget(ProviderScope(child: StockmateApp()));
    await tester.pumpAndSettle();

    expect(find.text('Dashboard'), findsWidgets);
    expect(find.text('Inventory'), findsOneWidget);
    expect(find.text('Scan'), findsOneWidget);
    expect(find.text('Sales'), findsWidgets);
    expect(find.text('Reports'), findsOneWidget);
  });
}
