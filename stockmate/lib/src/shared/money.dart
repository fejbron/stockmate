import 'package:intl/intl.dart';

class Money {
  const Money(this.minorUnits);

  final int minorUnits;

  static const zero = Money(0);

  factory Money.fromDecimal(String value) {
    final normalized = value.trim();
    final parsed = double.parse(normalized);
    return Money((parsed * 100).round());
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
