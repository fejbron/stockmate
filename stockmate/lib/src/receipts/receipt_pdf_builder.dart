import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ReceiptLine {
  const ReceiptLine({
    required this.name,
    required this.quantity,
    required this.unitPriceMinor,
    required this.discountMinor,
  });

  final String name;
  final int quantity;
  final int unitPriceMinor;
  final int discountMinor;

  int get lineTotalMinor => quantity * unitPriceMinor - discountMinor;
}

class ReceiptPdfBuilder {
  Future<Uint8List> build({
    required String receiptNumber,
    required DateTime soldAt,
    required List<ReceiptLine> lines,
    required int subtotalMinor,
    required int discountTotalMinor,
    required int totalMinor,
    required String paymentMethod,
  }) async {
    final doc = pw.Document();

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'EziTally Receipt',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(receiptNumber),
              pw.Text(soldAt.toIso8601String()),
              pw.SizedBox(height: 12),
              for (final line in lines)
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(line.name),
                    pw.Text(
                      '${line.quantity} x ${_money(line.unitPriceMinor)}'
                      '   ${_money(line.lineTotalMinor)}',
                    ),
                  ],
                ),
              pw.Divider(),
              pw.Text('Subtotal: ${_money(subtotalMinor)}'),
              pw.Text('Discount: ${_money(discountTotalMinor)}'),
              pw.Text(
                'Total: ${_money(totalMinor)}',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.Text('Payment: $paymentMethod'),
            ],
          );
        },
      ),
    );

    return doc.save();
  }

  String _money(int minor) => (minor / 100).toStringAsFixed(2);
}
