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
    state = state.setAmountPaid(value);
  }

  void setDiscountAmount(String value) {
    state = state.setDiscountAmount(value);
  }

  void setDiscountPercent(String value) {
    state = state.setDiscountPercent(value);
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
    required this.discountMinor,
  });

  factory CartDraft.empty() {
    return const CartDraft(
      lines: [],
      paymentMethod: 'cash',
      amountPaidMinor: null,
      discountMinor: 0,
    );
  }

  final List<CartDraftLine> lines;
  final String paymentMethod;
  final int? amountPaidMinor;
  final int discountMinor;

  bool get isEmpty => lines.isEmpty;

  int get subtotalMinor {
    var total = 0;
    for (final line in lines) {
      total += line.subtotalMinor;
    }
    return total;
  }

  int get discountTotalMinor => discountMinor.clamp(0, subtotalMinor).toInt();

  int get totalMinor => subtotalMinor - discountTotalMinor;

  int get balanceDueMinor {
    final amountPaid = amountPaidMinor ?? 0;
    return (totalMinor - amountPaid).clamp(0, totalMinor).toInt();
  }

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

  CartDraft setAmountPaid(String value) {
    return copyWith(
      amountPaidMinor: value.trim().isEmpty
          ? null
          : Money.fromDecimal(value).minorUnits,
    );
  }

  CartDraft setDiscountAmount(String value) {
    final trimmed = value.trim();
    final discount = trimmed.isEmpty
        ? 0
        : Money.fromDecimal(trimmed).minorUnits;
    return copyWith(discountMinor: discount.clamp(0, subtotalMinor).toInt());
  }

  CartDraft setDiscountPercent(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return copyWith(discountMinor: 0);
    }

    final percent = double.parse(trimmed).clamp(0, 100);
    final discount = (subtotalMinor * (percent / 100)).round();
    return copyWith(discountMinor: discount.clamp(0, subtotalMinor).toInt());
  }

  Cart toCart() {
    final lineDiscounts = _distributedDiscounts();
    return Cart(
      lines: [
        for (var index = 0; index < lines.length; index += 1)
          CartLine(
            productId: lines[index].productId,
            name: lines[index].name,
            quantity: lines[index].quantity,
            unitPriceMinor: lines[index].unitPriceMinor,
            discountMinor: lineDiscounts[index],
          ),
      ],
      paymentMethod: paymentMethod,
      amountPaidMinor: amountPaidMinor,
    );
  }

  List<int> _distributedDiscounts() {
    if (lines.isEmpty || discountTotalMinor == 0 || subtotalMinor == 0) {
      return [for (final _ in lines) 0];
    }

    final discounts = <int>[];
    var assigned = 0;
    for (var index = 0; index < lines.length; index += 1) {
      final line = lines[index];
      if (index == lines.length - 1) {
        discounts.add(discountTotalMinor - assigned);
      } else {
        final lineDiscount =
            (discountTotalMinor * (line.subtotalMinor / subtotalMinor)).round();
        discounts.add(lineDiscount.clamp(0, line.subtotalMinor).toInt());
        assigned += lineDiscount;
      }
    }
    return discounts;
  }

  CartDraft copyWith({
    List<CartDraftLine>? lines,
    String? paymentMethod,
    Object? amountPaidMinor = _unset,
    int? discountMinor,
  }) {
    return CartDraft(
      lines: lines ?? this.lines,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      amountPaidMinor: amountPaidMinor == _unset
          ? this.amountPaidMinor
          : amountPaidMinor as int?,
      discountMinor: discountMinor ?? this.discountMinor,
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
