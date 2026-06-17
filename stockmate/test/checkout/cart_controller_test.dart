import 'package:flutter_test/flutter_test.dart';
import 'package:stockmate/src/checkout/cart_controller.dart';
import 'package:stockmate/src/checkout/checkout_repository.dart';

void main() {
  test('adds scanned product and increments repeated scans', () {
    final cart = CartDraft.empty()
        .addProduct(
          const SellableProduct(
            id: 1,
            name: 'Milo Tin',
            codeValue: '8991234567890',
            sellingPriceMinor: 2550,
            stockQuantity: 12,
          ),
        )
        .addProduct(
          const SellableProduct(
            id: 1,
            name: 'Milo Tin',
            codeValue: '8991234567890',
            sellingPriceMinor: 2550,
            stockQuantity: 12,
          ),
        );

    expect(cart.lines, hasLength(1));
    expect(cart.lines.single.quantity, 2);
    expect(cart.totalMinor, 5100);
  });

  test('limits quantity to available stock', () {
    final cart = CartDraft.empty()
        .addProduct(
          const SellableProduct(
            id: 1,
            name: 'Milo Tin',
            codeValue: '8991234567890',
            sellingPriceMinor: 2550,
            stockQuantity: 1,
          ),
        )
        .addProduct(
          const SellableProduct(
            id: 1,
            name: 'Milo Tin',
            codeValue: '8991234567890',
            sellingPriceMinor: 2550,
            stockQuantity: 1,
          ),
        );

    expect(cart.lines.single.quantity, 1);
  });

  test('applies cart discount across sale lines', () {
    final cart = CartDraft.empty()
        .addProduct(
          const SellableProduct(
            id: 1,
            name: 'Milo Tin',
            codeValue: '8991234567890',
            sellingPriceMinor: 1000,
            stockQuantity: 12,
          ),
        )
        .addProduct(
          const SellableProduct(
            id: 2,
            name: 'Milk',
            codeValue: 'MILK-1',
            sellingPriceMinor: 500,
            stockQuantity: 8,
          ),
        )
        .setDiscountAmount('3.00');

    expect(cart.subtotalMinor, 1500);
    expect(cart.discountTotalMinor, 300);
    expect(cart.totalMinor, 1200);

    final saleCart = cart.toCart();
    expect(saleCart.discountTotalMinor, 300);
    expect(saleCart.lines.first.discountMinor, 200);
    expect(saleCart.lines.last.discountMinor, 100);
  });

  test('calculates percentage discount and balance due', () {
    final cart = CartDraft.empty()
        .addProduct(
          const SellableProduct(
            id: 1,
            name: 'Milo Tin',
            codeValue: '8991234567890',
            sellingPriceMinor: 1000,
            stockQuantity: 12,
          ),
        )
        .setDiscountPercent('10')
        .setAmountPaid('4.00');

    expect(cart.discountTotalMinor, 100);
    expect(cart.totalMinor, 900);
    expect(cart.balanceDueMinor, 500);
  });

  test('percent discount tracks live subtotal after cart edits', () {
    final cart = CartDraft.empty()
        .addProduct(
          const SellableProduct(
            id: 1,
            name: 'Expensive',
            codeValue: 'EXP-1',
            sellingPriceMinor: 9000,
            stockQuantity: 5,
          ),
        )
        .setDiscountPercent('10');

    // 10% of 9000 = 900.
    expect(cart.discountTotalMinor, 900);

    final mutated = cart.removeProduct(1).addProduct(
      const SellableProduct(
        id: 2,
        name: 'Cheap',
        codeValue: 'CHP-1',
        sellingPriceMinor: 1000,
        stockQuantity: 5,
      ),
    );

    // Subtotal is now 1000; 10% must be 100, not the stale 900.
    expect(mutated.subtotalMinor, 1000);
    expect(mutated.discountTotalMinor, 100);
    expect(mutated.totalMinor, 900);
  });

  test('absolute discount stays fixed after cart edits', () {
    final cart = CartDraft.empty()
        .addProduct(
          const SellableProduct(
            id: 1,
            name: 'Item',
            codeValue: 'IT-1',
            sellingPriceMinor: 5000,
            stockQuantity: 5,
          ),
        )
        .setDiscountAmount('3.00');

    expect(cart.discountTotalMinor, 300);

    final mutated = cart.addProduct(
      const SellableProduct(
        id: 2,
        name: 'Item2',
        codeValue: 'IT-2',
        sellingPriceMinor: 2000,
        stockQuantity: 5,
      ),
    );

    // Absolute discount remains fixed at 300.
    expect(mutated.discountTotalMinor, 300);
  });

  test('distributed discounts are never negative and sum to total', () {
    final cart = CartDraft.empty()
        .addProduct(
          const SellableProduct(
            id: 1,
            name: 'Tiny',
            codeValue: 'TY-1',
            sellingPriceMinor: 1,
            stockQuantity: 5,
          ),
        )
        .addProduct(
          const SellableProduct(
            id: 2,
            name: 'Tiny',
            codeValue: 'TY-1',
            sellingPriceMinor: 1,
            stockQuantity: 5,
          ),
        )
        .addProduct(
          const SellableProduct(
            id: 3,
            name: 'Big',
            codeValue: 'BG-1',
            sellingPriceMinor: 998,
            stockQuantity: 5,
          ),
        )
        .setDiscountAmount('10.00');

    final saleCart = cart.toCart();
    for (final line in saleCart.lines) {
      expect(line.discountMinor >= 0, isTrue);
      expect(line.discountMinor <= line.subtotalMinor, isTrue);
    }
    final sum = saleCart.lines.fold<int>(
      0,
      (acc, line) => acc + line.discountMinor,
    );
    expect(sum, cart.discountTotalMinor);
  });

  test('adding a zero-stock existing line does not throw', () {
    final cart = CartDraft.empty().addProduct(
      const SellableProduct(
        id: 1,
        name: 'OOS',
        codeValue: 'OOS-1',
        sellingPriceMinor: 1000,
        stockQuantity: 3,
      ),
    );

    final withZeroStockLine = CartDraft(
      lines: [
        cart.lines.single.copyWith(stockQuantity: 0),
      ],
      paymentMethod: cart.paymentMethod,
      amountPaidMinor: cart.amountPaidMinor,
      discountMode: cart.discountMode,
      discountValue: cart.discountValue,
    );

    expect(
      () => withZeroStockLine.addProduct(
        const SellableProduct(
          id: 1,
          name: 'OOS',
          codeValue: 'OOS-1',
          sellingPriceMinor: 1000,
          stockQuantity: 0,
        ),
      ),
      returnsNormally,
    );
    expect(
      withZeroStockLine
          .addProduct(
            const SellableProduct(
              id: 1,
              name: 'OOS',
              codeValue: 'OOS-1',
              sellingPriceMinor: 1000,
              stockQuantity: 0,
            ),
          )
          .lines
          .single
          .quantity,
      1,
    );
  });

  test('malformed input is ignored and does not throw', () {
    final base = CartDraft.empty().addProduct(
      const SellableProduct(
        id: 1,
        name: 'Item',
        codeValue: 'IT-1',
        sellingPriceMinor: 1000,
        stockQuantity: 5,
      ),
    );

    expect(() => base.setAmountPaid('abc'), returnsNormally);
    expect(() => base.setDiscountAmount('1,5'), returnsNormally);
    expect(() => base.setDiscountPercent('ten'), returnsNormally);

    // State remains sensible (unchanged) on bad input.
    expect(base.setAmountPaid('abc').amountPaidMinor, base.amountPaidMinor);
    expect(
      base.setDiscountAmount('1,5').discountTotalMinor,
      base.discountTotalMinor,
    );
    expect(
      base.setDiscountPercent('ten').discountTotalMinor,
      base.discountTotalMinor,
    );
  });
}
