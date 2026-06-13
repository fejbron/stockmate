import 'package:drift/drift.dart';

import '../data/app_database.dart';

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
}
