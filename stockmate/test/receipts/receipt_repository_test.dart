import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stockmate/src/data/app_database.dart';
import 'package:stockmate/src/receipts/receipt_repository.dart';

void main() {
  late AppDatabase db;
  late ReceiptRepository repository;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repository = ReceiptRepository(db);
  });

  tearDown(() => db.close());

  test('marks receipt shared and printed timestamps', () async {
    final saleId = await db
        .into(db.sales)
        .insert(
          SalesCompanion.insert(
            receiptNumber: 'R-1',
            subtotalMinor: 1000,
            totalMinor: 1000,
            costTotalMinor: 600,
            grossProfitMinor: 400,
            paymentMethod: 'cash',
          ),
        );
    final receiptId = await db
        .into(db.receipts)
        .insert(ReceiptsCompanion.insert(saleId: saleId, receiptNumber: 'R-1'));
    final sharedAt = DateTime(2026, 6, 13, 10);
    final printedAt = DateTime(2026, 6, 13, 11);

    await repository.markShared(receiptId, sharedAt);
    await repository.markPrinted(receiptId, printedAt);

    final receipt = await db.select(db.receipts).getSingle();
    expect(receipt.lastSharedAt, sharedAt);
    expect(receipt.lastPrintedAt, printedAt);
  });
}
