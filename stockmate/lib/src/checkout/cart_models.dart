class Cart {
  const Cart({
    required this.lines,
    required this.paymentMethod,
    required this.amountPaidMinor,
  });

  final List<CartLine> lines;
  final String paymentMethod;
  final int? amountPaidMinor;

  int get subtotalMinor {
    var total = 0;
    for (final line in lines) {
      total += line.subtotalMinor;
    }
    return total;
  }

  int get discountTotalMinor {
    var total = 0;
    for (final line in lines) {
      total += line.discountMinor;
    }
    return total;
  }

  int get totalMinor => subtotalMinor - discountTotalMinor;
}

class CartLine {
  const CartLine({
    required this.productId,
    required this.name,
    required this.quantity,
    required this.unitPriceMinor,
    required this.discountMinor,
  });

  final int productId;
  final String name;
  final int quantity;
  final int unitPriceMinor;
  final int discountMinor;

  int get subtotalMinor => quantity * unitPriceMinor;

  int get lineTotalMinor => subtotalMinor - discountMinor;
}
