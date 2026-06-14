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
}
