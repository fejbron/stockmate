import 'inventory_repository.dart';

class AddStockUseCase {
  AddStockUseCase(this.repository);

  final InventoryRepository repository;

  Future<int> createProductWithStock({
    required String name,
    required String codeValue,
    required String codeType,
    required String source,
    required int sellingPriceMinor,
    required int quantityReceived,
    required int costPerUnitMinor,
    required int lowStockThreshold,
  }) {
    return repository.createProductWithStock(
      name: name,
      codeValue: codeValue,
      codeType: codeType,
      source: source,
      sellingPriceMinor: sellingPriceMinor,
      quantityReceived: quantityReceived,
      costPerUnitMinor: costPerUnitMinor,
      lowStockThreshold: lowStockThreshold,
    );
  }
}
