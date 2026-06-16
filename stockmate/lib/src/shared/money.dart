import 'package:intl/intl.dart';

class Money {
  const Money(this.minorUnits);

  final int minorUnits;

  static const zero = Money(0);

  factory Money.fromDecimal(String value) {
    final normalized = value.trim();
    final match = RegExp(r'^(\d+)(?:\.(\d{1,2}))?$').firstMatch(normalized);
    if (match == null) {
      throw FormatException('Invalid money amount', value);
    }

    final whole = int.parse(match.group(1)!);
    final fraction = (match.group(2) ?? '').padRight(2, '0');
    return Money((whole * 100) + int.parse(fraction));
  }

  Money operator +(Money other) => Money(minorUnits + other.minorUnits);

  Money operator -(Money other) => Money(minorUnits - other.minorUnits);

  Money operator *(int quantity) => Money(minorUnits * quantity);

  bool get isNegative => minorUnits < 0;

  String format({String symbol = ''}) {
    final formatter = NumberFormat.currency(symbol: symbol, decimalDigits: 2);
    return formatter.format(minorUnits / 100);
  }
}
