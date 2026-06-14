import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database_provider.dart';
import '../labels/internal_code_generator.dart';
import 'add_stock_use_case.dart';
import 'inventory_repository.dart';

final inventoryRepositoryProvider = Provider<InventoryRepository>((ref) {
  return InventoryRepository(ref.watch(databaseProvider));
});

final addStockUseCaseProvider = Provider<AddStockUseCase>((ref) {
  return AddStockUseCase(ref.watch(inventoryRepositoryProvider));
});

final internalCodeGeneratorProvider = Provider<InternalCodeGenerator>((ref) {
  return InternalCodeGenerator();
});

final inventoryItemsProvider =
    StreamProvider.autoDispose<List<ProductInventoryItem>>((ref) {
      return ref.watch(inventoryRepositoryProvider).watchInventoryItems();
    });

final activeProductLookupProvider =
    StreamProvider.autoDispose<List<ProductLookupItem>>((ref) {
      return ref.watch(inventoryRepositoryProvider).watchActiveProductLookup();
    });

final productCodesProvider = StreamProvider.autoDispose
    .family<List<ProductCodeItem>, int>((ref, productId) {
      return ref
          .watch(inventoryRepositoryProvider)
          .watchProductCodes(productId);
    });
