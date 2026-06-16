import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database_provider.dart';
import 'checkout_repository.dart';
import 'complete_sale_use_case.dart';
import 'stock_allocator.dart';

final checkoutRepositoryProvider = Provider<CheckoutRepository>((ref) {
  return CheckoutRepository(ref.watch(databaseProvider));
});

final completeSaleUseCaseProvider = Provider<CompleteSaleUseCase>((ref) {
  return CompleteSaleUseCase(
    repository: ref.watch(checkoutRepositoryProvider),
    allocator: StockAllocator(),
  );
});

final productByCodeProvider = FutureProvider.autoDispose
    .family<SellableProduct?, String>((ref, code) {
      return ref.watch(checkoutRepositoryProvider).findProductByCode(code);
    });

final recentSalesProvider = StreamProvider.autoDispose<List<SaleListItem>>((
  ref,
) {
  return ref.watch(checkoutRepositoryProvider).watchRecentSales();
});
