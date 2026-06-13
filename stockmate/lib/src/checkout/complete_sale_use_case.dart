import '../shared/result.dart';
import 'cart_models.dart';
import 'checkout_repository.dart';
import 'stock_allocator.dart';

class CompleteSaleResult {
  const CompleteSaleResult(this.saleId);

  final int saleId;
}

class CompleteSaleUseCase {
  CompleteSaleUseCase({required this.repository, required this.allocator});

  final CheckoutRepository repository;
  final StockAllocator allocator;

  Future<AppResult<CompleteSaleResult>> completeSale({
    required Cart cart,
  }) async {
    final amountPaidMinor = cart.amountPaidMinor;
    if (amountPaidMinor != null && amountPaidMinor < cart.totalMinor) {
      return const AppFailure('Amount paid is less than sale total.');
    }

    final availableBatchesByProduct = <int, List<AvailableBatch>>{};
    final allocationsByLineIndex = <int, List<BatchAllocation>>{};

    for (var index = 0; index < cart.lines.length; index += 1) {
      final line = cart.lines[index];
      final batches = await _availableBatchesForLine(
        line.productId,
        availableBatchesByProduct,
      );
      final allocationResult = allocator.allocate(
        requestedQuantity: line.quantity,
        batches: batches,
      );
      if (!allocationResult.isSuccess) {
        return AppFailure(allocationResult.message);
      }
      allocationsByLineIndex[index] = allocationResult.allocations;
      _consumeAllocatedBatches(
        productId: line.productId,
        allocations: allocationResult.allocations,
        availableBatchesByProduct: availableBatchesByProduct,
      );
    }

    final saleId = await repository.persistSale(
      cart: cart,
      allocationsByLineIndex: allocationsByLineIndex,
    );
    return AppSuccess(CompleteSaleResult(saleId));
  }

  Future<List<AvailableBatch>> _availableBatchesForLine(
    int productId,
    Map<int, List<AvailableBatch>> availableBatchesByProduct,
  ) async {
    final cached = availableBatchesByProduct[productId];
    if (cached != null) {
      return cached;
    }

    final batches = await repository.availableBatches(productId);
    availableBatchesByProduct[productId] = batches;
    return batches;
  }

  void _consumeAllocatedBatches({
    required int productId,
    required List<BatchAllocation> allocations,
    required Map<int, List<AvailableBatch>> availableBatchesByProduct,
  }) {
    final batches = availableBatchesByProduct[productId] ?? const [];
    final updatedBatches = <AvailableBatch>[];

    for (final batch in batches) {
      var quantityRemaining = batch.quantityRemaining;
      for (final allocation in allocations) {
        if (allocation.stockBatchId == batch.id) {
          quantityRemaining -= allocation.quantity;
        }
      }

      if (quantityRemaining > 0) {
        updatedBatches.add(
          AvailableBatch(
            id: batch.id,
            quantityRemaining: quantityRemaining,
            costPerUnitMinor: batch.costPerUnitMinor,
          ),
        );
      }
    }

    availableBatchesByProduct[productId] = updatedBatches;
  }
}
