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
}
