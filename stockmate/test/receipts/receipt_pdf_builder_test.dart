import 'package:flutter_test/flutter_test.dart';
import 'package:stockmate/src/receipts/receipt_pdf_builder.dart';

void main() {
  test('builds non-empty receipt pdf bytes', () async {
    final builder = ReceiptPdfBuilder();

    final bytes = await builder.build(
      receiptNumber: 'R-1',
      soldAt: DateTime(2026, 6, 13, 9, 30),
      lines: const [
        ReceiptLine(
          name: 'Milk',
          quantity: 2,
          unitPriceMinor: 500,
          discountMinor: 100,
        ),
      ],
      subtotalMinor: 1000,
      discountTotalMinor: 100,
      totalMinor: 900,
      paymentMethod: 'cash',
    );

    expect(bytes.length, greaterThan(500));
  });
}
