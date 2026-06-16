class AvailableBatch {
  const AvailableBatch({
    required this.id,
    required this.quantityRemaining,
    required this.costPerUnitMinor,
  });

  final int id;
  final int quantityRemaining;
  final int costPerUnitMinor;
}

class BatchAllocation {
  const BatchAllocation({
    required this.stockBatchId,
    required this.quantity,
    required this.costPerUnitMinor,
  });

  final int stockBatchId;
  final int quantity;
  final int costPerUnitMinor;

  int get costTotalMinor => quantity * costPerUnitMinor;

  @override
  bool operator ==(Object other) {
    return other is BatchAllocation &&
        other.stockBatchId == stockBatchId &&
        other.quantity == quantity &&
        other.costPerUnitMinor == costPerUnitMinor;
  }

  @override
  int get hashCode => Object.hash(stockBatchId, quantity, costPerUnitMinor);
}

class AllocationResult {
  const AllocationResult.success(this.allocations)
    : message = '',
      isSuccess = true;

  const AllocationResult.failure(this.message)
    : allocations = const [],
      isSuccess = false;

  final bool isSuccess;
  final String message;
  final List<BatchAllocation> allocations;

  int get costTotalMinor {
    return allocations.fold(
      0,
      (total, allocation) => total + allocation.costTotalMinor,
    );
  }
}

class StockAllocator {
  AllocationResult allocate({
    required int requestedQuantity,
    required List<AvailableBatch> batches,
  }) {
    final available = batches.fold(
      0,
      (total, batch) => total + batch.quantityRemaining,
    );
    if (available < requestedQuantity) {
      return AllocationResult.failure('Only $available units available.');
    }

    var remaining = requestedQuantity;
    final allocations = <BatchAllocation>[];

    for (final batch in batches) {
      if (remaining == 0) {
        break;
      }
      final quantity = batch.quantityRemaining < remaining
          ? batch.quantityRemaining
          : remaining;
      allocations.add(
        BatchAllocation(
          stockBatchId: batch.id,
          quantity: quantity,
          costPerUnitMinor: batch.costPerUnitMinor,
        ),
      );
      remaining -= quantity;
    }

    return AllocationResult.success(allocations);
  }
}
