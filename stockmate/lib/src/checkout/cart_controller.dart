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

enum DiscountMode { none, percent, absolute }

class CartDraft {
  const CartDraft({
    required this.lines,
    required this.paymentMethod,
    required this.amountPaidMinor,
    this.discountMode = DiscountMode.none,
    this.discountValue = 0,
  });

  factory CartDraft.empty() {
    return const CartDraft(
      lines: [],
      paymentMethod: 'cash',
      amountPaidMinor: null,
      discountMode: DiscountMode.none,
      discountValue: 0,
    );
  }

  final List<CartDraftLine> lines;
  final String paymentMethod;
  final int? amountPaidMinor;

  /// How the discount should be interpreted.
  final DiscountMode discountMode;

  /// The raw discount value: a percent (0-100) when [discountMode] is
  /// [DiscountMode.percent], or an absolute amount in minor units when
  /// [discountMode] is [DiscountMode.absolute]. Ignored for [DiscountMode.none].
  final num discountValue;

  bool get isEmpty => lines.isEmpty;

  int get subtotalMinor {
    var total = 0;
    for (final line in lines) {
      total += line.subtotalMinor;
    }
    return total;
  }

  int get discountTotalMinor {
    switch (discountMode) {
      case DiscountMode.none:
        return 0;
      case DiscountMode.percent:
        final percent = discountValue.clamp(0, 100);
        final discount = (subtotalMinor * (percent / 100)).round();
        return discount.clamp(0, subtotalMinor).toInt();
      case DiscountMode.absolute:
        return discountValue.toInt().clamp(0, subtotalMinor).toInt();
    }
  }

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
        if (line.stockQuantity > 0) {
          updatedLines.add(
            line.copyWith(
              quantity: (line.quantity + 1).clamp(1, line.stockQuantity),
            ),
          );
        } else {
          // No stock available: leave the existing line unchanged rather than
          // calling clamp(1, 0), which would throw.
          updatedLines.add(line);
        }
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
    if (value.trim().isEmpty) {
      return copyWith(amountPaidMinor: null);
    }
    try {
      return copyWith(amountPaidMinor: Money.fromDecimal(value).minorUnits);
    } on FormatException {
      // Malformed input: leave the amount paid unchanged.
      return this;
    }
  }

  CartDraft setDiscountAmount(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return copyWith(
        discountMode: DiscountMode.none,
        discountValue: 0,
      );
    }
    try {
      final amount = Money.fromDecimal(trimmed).minorUnits;
      return copyWith(
        discountMode: DiscountMode.absolute,
        discountValue: amount,
      );
    } on FormatException {
      // Malformed input: leave the discount unchanged.
      return this;
    }
  }

  CartDraft setDiscountPercent(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return copyWith(
        discountMode: DiscountMode.none,
        discountValue: 0,
      );
    }

    final percent = double.tryParse(trimmed);
    if (percent == null) {
      // Malformed input: leave the discount unchanged.
      return this;
    }
    return copyWith(
      discountMode: DiscountMode.percent,
      discountValue: percent.clamp(0, 100),
    );
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
        // Last line bears the rounding remainder, clamped so it can never go
        // negative or exceed this line's subtotal.
        final remainder = (discountTotalMinor - assigned)
            .clamp(0, line.subtotalMinor)
            .toInt();
        discounts.add(remainder);
      } else {
        final lineDiscount = (discountTotalMinor *
                (line.subtotalMinor / subtotalMinor))
            .round()
            .clamp(0, line.subtotalMinor)
            .toInt();
        discounts.add(lineDiscount);
        // Accumulate the CLAMPED value so the remainder stays consistent.
        assigned += lineDiscount;
      }
    }
    return discounts;
  }

  CartDraft copyWith({
    List<CartDraftLine>? lines,
    String? paymentMethod,
    Object? amountPaidMinor = _unset,
    DiscountMode? discountMode,
    num? discountValue,
  }) {
    return CartDraft(
      lines: lines ?? this.lines,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      amountPaidMinor: amountPaidMinor == _unset
          ? this.amountPaidMinor
          : amountPaidMinor as int?,
      discountMode: discountMode ?? this.discountMode,
      discountValue: discountValue ?? this.discountValue,
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
