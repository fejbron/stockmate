import 'package:drift/drift.dart';

import '../data/app_database.dart';

class ReceiptDetail {
  const ReceiptDetail({
    required this.saleId,
    required this.receiptNumber,
    required this.soldAt,
    required this.subtotalMinor,
    required this.discountTotalMinor,
    required this.totalMinor,
    required this.costTotalMinor,
    required this.grossProfitMinor,
    required this.paymentMethod,
    required this.amountPaidMinor,
    required this.changeDueMinor,
    required this.lines,
  });

  final int saleId;
  final String receiptNumber;
  final DateTime soldAt;
  final int subtotalMinor;
  final int discountTotalMinor;
  final int totalMinor;
  final int costTotalMinor;
  final int grossProfitMinor;
  final String paymentMethod;
  final int? amountPaidMinor;
  final int? changeDueMinor;
  final List<ReceiptDetailLine> lines;
}

class ReceiptDetailLine {
  const ReceiptDetailLine({
    required this.productName,
    required this.quantity,
    required this.unitPriceMinor,
    required this.discountAmountMinor,
    required this.lineTotalMinor,
    required this.costTotalMinor,
    required this.grossProfitMinor,
  });

  final String productName;
  final int quantity;
  final int unitPriceMinor;
  final int discountAmountMinor;
  final int lineTotalMinor;
  final int costTotalMinor;
  final int grossProfitMinor;
}

class ReceiptRepository {
  ReceiptRepository(this.db);

  final AppDatabase db;

  Future<void> markShared(int receiptId, DateTime sharedAt) {
    return (db.update(db.receipts)..where((row) => row.id.equals(receiptId)))
        .write(ReceiptsCompanion(lastSharedAt: Value(sharedAt)));
  }

  Future<void> markPrinted(int receiptId, DateTime printedAt) {
    return (db.update(db.receipts)..where((row) => row.id.equals(receiptId)))
        .write(ReceiptsCompanion(lastPrintedAt: Value(printedAt)));
  }

  Future<ReceiptDetail?> receiptDetail(int saleId) async {
    final saleRows = await db
        .customSelect(
          '''
          SELECT
            s.id,
            r.receipt_number,
            s.sold_at,
            s.subtotal_minor,
            s.discount_total_minor,
            s.total_minor,
            s.cost_total_minor,
            s.gross_profit_minor,
            s.payment_method,
            s.amount_paid_minor,
            s.change_due_minor
          FROM sales s
          INNER JOIN receipts r ON r.sale_id = s.id
          WHERE s.id = ?
          LIMIT 1
          ''',
          variables: [Variable(saleId)],
          readsFrom: {db.sales, db.receipts},
        )
        .get();

    if (saleRows.isEmpty) {
      return null;
    }

    final lineRows = await db
        .customSelect(
          '''
          SELECT
            p.name AS product_name,
            sl.quantity,
            sl.unit_price_minor,
            sl.discount_amount_minor,
            sl.line_total_minor,
            sl.cost_total_minor,
            sl.gross_profit_minor
          FROM sale_lines sl
          INNER JOIN products p ON p.id = sl.product_id
          WHERE sl.sale_id = ?
          ORDER BY sl.id
          ''',
          variables: [Variable(saleId)],
          readsFrom: {db.saleLines, db.products},
        )
        .get();

    final sale = saleRows.single;
    return ReceiptDetail(
      saleId: sale.read<int>('id'),
      receiptNumber: sale.read<String>('receipt_number'),
      soldAt: sale.read<DateTime>('sold_at'),
      subtotalMinor: sale.read<int>('subtotal_minor'),
      discountTotalMinor: sale.read<int>('discount_total_minor'),
      totalMinor: sale.read<int>('total_minor'),
      costTotalMinor: sale.read<int>('cost_total_minor'),
      grossProfitMinor: sale.read<int>('gross_profit_minor'),
      paymentMethod: sale.read<String>('payment_method'),
      amountPaidMinor: sale.read<int?>('amount_paid_minor'),
      changeDueMinor: sale.read<int?>('change_due_minor'),
      lines: [
        for (final line in lineRows)
          ReceiptDetailLine(
            productName: line.read<String>('product_name'),
            quantity: line.read<int>('quantity'),
            unitPriceMinor: line.read<int>('unit_price_minor'),
            discountAmountMinor: line.read<int>('discount_amount_minor'),
            lineTotalMinor: line.read<int>('line_total_minor'),
            costTotalMinor: line.read<int>('cost_total_minor'),
            grossProfitMinor: line.read<int>('gross_profit_minor'),
          ),
      ],
    );
  }
}
