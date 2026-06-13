import 'package:flutter_test/flutter_test.dart';
import 'package:stockmate/src/labels/internal_code_generator.dart';

void main() {
  test('generates stable internal code format', () {
    final generator = InternalCodeGenerator();

    final code = generator.generate(productId: 42);

    expect(code, startsWith('INT-000042-'));
    expect(code.length, greaterThan(14));
  });
}
