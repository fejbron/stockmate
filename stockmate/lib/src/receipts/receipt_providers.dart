import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database_provider.dart';
import 'receipt_repository.dart';

final receiptRepositoryProvider = Provider<ReceiptRepository>((ref) {
  return ReceiptRepository(ref.watch(databaseProvider));
});

final receiptDetailProvider = FutureProvider.autoDispose
    .family<ReceiptDetail?, int>((ref, saleId) {
      return ref.watch(receiptRepositoryProvider).receiptDetail(saleId);
    });
