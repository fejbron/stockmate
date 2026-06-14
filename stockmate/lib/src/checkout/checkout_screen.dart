import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../shared/money.dart';
import '../shared/result.dart';
import 'cart_controller.dart';
import 'checkout_providers.dart';
import 'complete_sale_use_case.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final codeController = TextEditingController();
  final amountPaidController = TextEditingController();
  var isAdding = false;
  var isRecording = false;

  @override
  void dispose() {
    codeController.dispose();
    amountPaidController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(checkoutCartProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _CodeLookupPanel(
            controller: codeController,
            isAdding: isAdding,
            onAdd: _addProductByCode,
          ),
          const SizedBox(height: 16),
          Text('Cart', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          if (cart.isEmpty)
            const _EmptyCart()
          else
            ...cart.lines.map((line) => _CartLineTile(line: line)),
          const SizedBox(height: 16),
          _PaymentPanel(
            cart: cart,
            amountPaidController: amountPaidController,
            isRecording: isRecording,
            onRecordSale: cart.isEmpty ? null : _recordSale,
          ),
        ],
      ),
    );
  }

  Future<void> _addProductByCode() async {
    final code = codeController.text.trim();
    if (code.isEmpty || isAdding) {
      return;
    }

    setState(() => isAdding = true);
    try {
      final product = await ref
          .read(checkoutRepositoryProvider)
          .findProductByCode(code);
      if (!mounted) {
        return;
      }

      if (product == null) {
        _showMessage('No product found for $code');
        return;
      }
      if (product.stockQuantity <= 0) {
        _showMessage('${product.name} is out of stock');
        return;
      }

      ref.read(checkoutCartProvider.notifier).addProduct(product);
      codeController.clear();
      _showMessage('${product.name} added to cart');
    } finally {
      if (mounted) {
        setState(() => isAdding = false);
      }
    }
  }

  Future<void> _recordSale() async {
    if (isRecording) {
      return;
    }

    setState(() => isRecording = true);
    try {
      final amountText = amountPaidController.text.trim();
      if (amountText.isNotEmpty) {
        ref.read(checkoutCartProvider.notifier).setAmountPaid(amountText);
      }
      final cart = ref.read(checkoutCartProvider);
      final result = await ref
          .read(completeSaleUseCaseProvider)
          .completeSale(cart: cart.toCart());
      if (!mounted) {
        return;
      }

      switch (result) {
        case AppSuccess<CompleteSaleResult>():
          ref.read(checkoutCartProvider.notifier).clear();
          amountPaidController.clear();
          _showMessage('Sale recorded');
        case AppFailure<CompleteSaleResult>(:final message):
          _showMessage(message);
      }
    } on FormatException {
      if (mounted) {
        _showMessage('Enter a valid amount paid');
      }
    } finally {
      if (mounted) {
        setState(() => isRecording = false);
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _CodeLookupPanel extends StatelessWidget {
  const _CodeLookupPanel({
    required this.controller,
    required this.isAdding,
    required this.onAdd,
  });

  final TextEditingController controller;
  final bool isAdding;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  labelText: 'Barcode or product code',
                  prefixIcon: Icon(Icons.qr_code_scanner),
                ),
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => onAdd(),
              ),
            ),
            const SizedBox(width: 12),
            FilledButton.icon(
              onPressed: isAdding ? null : onAdd,
              icon: const Icon(Icons.add_shopping_cart),
              label: Text(isAdding ? 'Adding' : 'Add Product'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          'Scan a product or enter its code to add it to this sale.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _CartLineTile extends ConsumerWidget {
  const _CartLineTile({required this.line});

  final CartDraftLine line;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(checkoutCartProvider.notifier);

    return Card(
      child: ListTile(
        leading: const Icon(Icons.inventory_2),
        title: Text(line.name),
        subtitle: Text('${line.quantity} in cart'),
        trailing: SizedBox(
          width: 168,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                tooltip: 'Decrease quantity',
                onPressed: () => controller.updateQuantity(
                  line.productId,
                  line.quantity - 1,
                ),
                icon: const Icon(Icons.remove_circle_outline),
              ),
              Text('${line.quantity}'),
              IconButton(
                tooltip: 'Increase quantity',
                onPressed: line.quantity >= line.stockQuantity
                    ? null
                    : () => controller.updateQuantity(
                        line.productId,
                        line.quantity + 1,
                      ),
                icon: const Icon(Icons.add_circle_outline),
              ),
              Text(Money(line.subtotalMinor).format()),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaymentPanel extends StatelessWidget {
  const _PaymentPanel({
    required this.cart,
    required this.amountPaidController,
    required this.isRecording,
    required this.onRecordSale,
  });

  final CartDraft cart;
  final TextEditingController amountPaidController;
  final bool isRecording;
  final VoidCallback? onRecordSale;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TotalRow(
              label: 'Subtotal',
              value: Money(cart.subtotalMinor).format(),
            ),
            _TotalRow(label: 'Total', value: Money(cart.totalMinor).format()),
            const SizedBox(height: 12),
            TextField(
              controller: amountPaidController,
              decoration: const InputDecoration(
                labelText: 'Amount paid',
                prefixIcon: Icon(Icons.payments),
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: isRecording ? null : onRecordSale,
              icon: const Icon(Icons.receipt_long),
              label: Text(isRecording ? 'Recording...' : 'Record Sale'),
            ),
          ],
        ),
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  const _TotalRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(value, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}
