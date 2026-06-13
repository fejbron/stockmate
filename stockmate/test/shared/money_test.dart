import 'package:flutter_test/flutter_test.dart';
import 'package:stockmate/src/shared/money.dart';

void main() {
  group('Money.fromDecimal', () {
    test('parses whole and fractional amounts exactly', () {
      expect(Money.fromDecimal('1').minorUnits, 100);
      expect(Money.fromDecimal('1.2').minorUnits, 120);
      expect(Money.fromDecimal('1.23').minorUnits, 123);
      expect(Money.fromDecimal(' 0.05 ').minorUnits, 5);
    });

    test('rejects invalid or over-precise decimal values', () {
      expect(() => Money.fromDecimal('abc'), throwsFormatException);
      expect(() => Money.fromDecimal('1.234'), throwsFormatException);
      expect(() => Money.fromDecimal('1.'), throwsFormatException);
    });
  });
}
