import 'inventory_repository.dart';

class StockAdjustmentUseCase {
  StockAdjustmentUseCase(this.repository);

  final InventoryRepository repository;

  Future<AdjustmentResult> adjustStock({
    required int productId,
    required int adjustmentQuantity,
    required String reason,
    required String? note,
  }) async {
    final available = await repository.currentStock(productId);
    if (adjustmentQuantity < 0 && -adjustmentQuantity > available) {
      return AdjustmentResult.failure(
        'Cannot reduce stock below zero. Available stock is $available.',
      );
    }

    await repository.addStockAdjustment(
      productId: productId,
      adjustmentQuantity: adjustmentQuantity,
      reason: reason,
      note: note,
    );
    return const AdjustmentResult.success();
  }
}

class AdjustmentResult {
  const AdjustmentResult.success() : isSuccess = true, message = '';

  const AdjustmentResult.failure(this.message) : isSuccess = false;

  final bool isSuccess;
  final String message;
}
