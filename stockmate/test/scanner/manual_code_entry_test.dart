import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stockmate/src/scanner/manual_code_entry.dart';

void main() {
  testWidgets('submits trimmed manual code', (tester) async {
    String? submitted;
    await tester.pumpWidget(
      MaterialApp(
        home: ManualCodeEntry(onSubmitted: (value) => submitted = value),
      ),
    );

    await tester.enterText(find.byType(TextField), '  ABC-123  ');
    await tester.tap(find.text('Use Code'));
    await tester.pump();

    expect(submitted, 'ABC-123');
  });
}
