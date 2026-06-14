import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../shared/money.dart';
import 'cart_models.dart';
import 'checkout_repository.dart';

final checkoutCartProvider =
    NotifierProvider<CheckoutCartController, CartDraft>(
      CheckoutCartController.new,
    );

class CheckoutCartController extends Notifier<CartDraft> {
  @override
  CartDraft build() => CartDraft.empty();

  void addProduct(SellableProduct product) {
    state = state.addProduct(product);
  }

  void updateQuantity(int productId, int quantity) {
    state = state.updateQuantity(productId, quantity);
  }

  void removeProduct(int productId) {
    state = state.removeProduct(productId);
  }

  void setAmountPaid(String value) {
    state = state.copyWith(
      amountPaidMinor: value.trim().isEmpty
          ? null
          : Money.fromDecimal(value).minorUnits,
    );
  }

  void clear() {
    state = CartDraft.empty();
  }
}

class CartDraft {
  const CartDraft({
    required this.lines,
    required this.paymentMethod,
    required this.amountPaidMinor,
  });

  factory CartDraft.empty() {
    return const CartDraft(
      lines: [],
      paymentMethod: 'cash',
      amountPaidMinor: null,
    );
  }

  final List<CartDraftLine> lines;
  final String paymentMethod;
  final int? amountPaidMinor;

  bool get isEmpty => lines.isEmpty;

  int get subtotalMinor {
    var total = 0;
    for (final line in lines) {
      total += line.subtotalMinor;
    }
    return total;
  }

  int get discountTotalMinor => 0;

  int get totalMinor => subtotalMinor - discountTotalMinor;

  CartDraft addProduct(SellableProduct product) {
    final updatedLines = <CartDraftLine>[];
    var found = false;

    for (final line in lines) {
      if (line.productId == product.id) {
        found = true;
        updatedLines.add(
          line.copyWith(
            quantity: (line.quantity + 1).clamp(1, line.stockQuantity),
          ),
        );
      } else {
        updatedLines.add(line);
      }
    }

    if (!found && product.stockQuantity > 0) {
      updatedLines.add(
        CartDraftLine(
          productId: product.id,
          name: product.name,
          codeValue: product.codeValue,
          quantity: 1,
          stockQuantity: product.stockQuantity,
          unitPriceMinor: product.sellingPriceMinor,
        ),
      );
    }

    return copyWith(lines: updatedLines);
  }

  CartDraft updateQuantity(int productId, int quantity) {
    if (quantity <= 0) {
      return removeProduct(productId);
    }

    return copyWith(
      lines: [
        for (final line in lines)
          if (line.productId == productId)
            line.copyWith(quantity: quantity.clamp(1, line.stockQuantity))
          else
            line,
      ],
    );
  }

  CartDraft removeProduct(int productId) {
    return copyWith(
      lines: [
        for (final line in lines)
          if (line.productId != productId) line,
      ],
    );
  }

  Cart toCart() {
    return Cart(
      lines: [
        for (final line in lines)
          CartLine(
            productId: line.productId,
            name: line.name,
            quantity: line.quantity,
            unitPriceMinor: line.unitPriceMinor,
            discountMinor: 0,
          ),
      ],
      paymentMethod: paymentMethod,
      amountPaidMinor: amountPaidMinor,
    );
  }

  CartDraft copyWith({
    List<CartDraftLine>? lines,
    String? paymentMethod,
    Object? amountPaidMinor = _unset,
  }) {
    return CartDraft(
      lines: lines ?? this.lines,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      amountPaidMinor: amountPaidMinor == _unset
          ? this.amountPaidMinor
          : amountPaidMinor as int?,
    );
  }
}

class CartDraftLine {
  const CartDraftLine({
    required this.productId,
    required this.name,
    required this.codeValue,
    required this.quantity,
    required this.stockQuantity,
    required this.unitPriceMinor,
  });

  final int productId;
  final String name;
  final String codeValue;
  final int quantity;
  final int stockQuantity;
  final int unitPriceMinor;

  int get subtotalMinor => quantity * unitPriceMinor;

  CartDraftLine copyWith({
    int? quantity,
    int? stockQuantity,
    int? unitPriceMinor,
  }) {
    return CartDraftLine(
      productId: productId,
      name: name,
      codeValue: codeValue,
      quantity: quantity ?? this.quantity,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      unitPriceMinor: unitPriceMinor ?? this.unitPriceMinor,
    );
  }
}

const _unset = Object();
