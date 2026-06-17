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
    if (cart.lines.isEmpty) {
      return const AppFailure(
        'Add at least one product before recording sale.',
      );
    }

    // Allocation is recomputed authoritatively inside persistSale, within the
    // same DB transaction, so it is atomic against concurrent stock changes.
    // Any DB failure (constraint violation, receipt collision, or an
    // insufficient-stock shortfall detected at commit time) is converted into
    // a clean AppFailure and never escapes as a throw.
    try {
      final saleId = await repository.persistSale(
        cart: cart,
        allocator: allocator,
      );
      return AppSuccess(CompleteSaleResult(saleId));
    } on InsufficientStockException catch (error) {
      return AppFailure(error.message);
    } catch (_) {
      return const AppFailure(
        'Could not record sale. Please try again.',
      );
    }
  }
}
