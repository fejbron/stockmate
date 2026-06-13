import 'package:flutter_test/flutter_test.dart';
import 'package:stockmate/src/checkout/stock_allocator.dart';

void main() {
  test('allocates oldest batches first and calculates cost', () {
    final allocator = StockAllocator();
    final result = allocator.allocate(
      requestedQuantity: 8,
      batches: const [
        AvailableBatch(id: 1, quantityRemaining: 5, costPerUnitMinor: 100),
        AvailableBatch(id: 2, quantityRemaining: 10, costPerUnitMinor: 150),
      ],
    );

    expect(result.isSuccess, true);
    expect(result.allocations, [
      const BatchAllocation(
        stockBatchId: 1,
        quantity: 5,
        costPerUnitMinor: 100,
      ),
      const BatchAllocation(
        stockBatchId: 2,
        quantity: 3,
        costPerUnitMinor: 150,
      ),
    ]);
    expect(result.costTotalMinor, 950);
  });

  test('fails when available stock is too low', () {
    final allocator = StockAllocator();
    final result = allocator.allocate(
      requestedQuantity: 4,
      batches: const [
        AvailableBatch(id: 1, quantityRemaining: 2, costPerUnitMinor: 100),
      ],
    );

    expect(result.isSuccess, false);
    expect(result.message, 'Only 2 units available.');
  });
}
