import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../shared/money.dart';
import '../shared/result.dart';
import 'cart_controller.dart';
import 'checkout_providers.dart';
import 'complete_sale_use_case.dart';

typedef CheckoutCodeDetected = void Function(String code);
typedef CheckoutScannerBuilder =
    Widget Function(BuildContext context, CheckoutCodeDetected onCodeDetected);

const _orderAccent = Color(0xFFFF6237);
const _orderBackground = Color(0xFFEFF3F6);
const _orderText = Color(0xFF111827);

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({this.scannerBuilder, super.key});

  final CheckoutScannerBuilder? scannerBuilder;

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final codeController = TextEditingController();
  var isAdding = false;
  String? lastScannedCode;
  DateTime? lastScannedAt;

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(checkoutCartProvider);

    return Scaffold(
      backgroundColor: _orderBackground,
      appBar: AppBar(
        title: const Text('Add Order'),
        backgroundColor: _orderBackground,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                children: [
                  _ScanHeader(
                    controller: codeController,
                    isAdding: isAdding,
                    onAdd: _addProductByCode,
                    onScan: _openScanner,
                  ),
                  const SizedBox(height: 18),
                  _OrderItemsHeader(itemCount: cart.lines.length),
                  const SizedBox(height: 8),
                  if (cart.isEmpty)
                    const _EmptyOrder()
                  else
                    ...cart.lines.map((line) => _OrderLineTile(line: line)),
                ],
              ),
            ),
            _OrderSummaryBar(
              cart: cart,
              onCreateOrder: cart.isEmpty ? null : _openOrderInfo,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addProductByCode() async {
    final code = codeController.text.trim();
    await _addProductFromCode(code, clearInputAfterSuccess: true);
  }

  Future<void> _openScanner() async {
    final code = await Navigator.of(context).push<String>(
      MaterialPageRoute<String>(
        builder: (_) =>
            CheckoutScannerScreen(scannerBuilder: widget.scannerBuilder),
      ),
    );
    if (code != null) {
      await _handleScannedCode(code);
    }
  }

  Future<void> _handleScannedCode(String code) async {
    final trimmedCode = code.trim();
    if (trimmedCode.isEmpty) {
      return;
    }

    final now = DateTime.now();
    final lastAt = lastScannedAt;
    if (trimmedCode == lastScannedCode &&
        lastAt != null &&
        now.difference(lastAt) < const Duration(milliseconds: 1200)) {
      return;
    }

    lastScannedCode = trimmedCode;
    lastScannedAt = now;
    await _addProductFromCode(trimmedCode, clearInputAfterSuccess: false);
  }

  Future<void> _addProductFromCode(
    String code, {
    required bool clearInputAfterSuccess,
  }) async {
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
      if (clearInputAfterSuccess) {
        codeController.clear();
      }
      _showMessage('${product.name} added to order');
    } finally {
      if (mounted) {
        setState(() => isAdding = false);
      }
    }
  }

  Future<void> _openOrderInfo() async {
    final recorded = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(builder: (_) => const OrderInfoScreen()),
    );
    if (recorded == true && mounted) {
      _showMessage('Order created');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 104),
      ),
    );
  }
}

class _ScanHeader extends StatelessWidget {
  const _ScanHeader({
    required this.controller,
    required this.isAdding,
    required this.onAdd,
    required this.onScan,
  });

  final TextEditingController controller;
  final bool isAdding;
  final VoidCallback onAdd;
  final VoidCallback onScan;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 148,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(26),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/icon/stockmate_icon_1024.png',
                fit: BoxFit.cover,
                opacity: const AlwaysStoppedAnimation(0.16),
              ),
              const ColoredBox(color: Color(0xFF101828)),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.05),
                      Colors.black.withValues(alpha: 0.45),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 18,
                right: 18,
                bottom: 16,
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.88),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.qr_code_scanner,
                        color: _orderAccent,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Ready to scan product barcodes',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    FilledButton.icon(
                      key: const Key('openOrderScannerButton'),
                      onPressed: onScan,
                      style: FilledButton.styleFrom(
                        backgroundColor: _orderAccent,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(0, 42),
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      icon: const Icon(Icons.center_focus_strong, size: 18),
                      label: const Text('Scan'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.only(left: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 16,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  key: const Key('orderCodeField'),
                  controller: controller,
                  decoration: const InputDecoration(
                    labelText: 'Barcode or product code',
                    hintText: 'Search product...',
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    filled: false,
                  ),
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => onAdd(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(6),
                child: SizedBox.square(
                  dimension: 50,
                  child: FilledButton(
                    key: const Key('manualAddOrderButton'),
                    onPressed: isAdding ? null : onAdd,
                    style: FilledButton.styleFrom(
                      backgroundColor: _orderAccent,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                    child: Icon(isAdding ? Icons.hourglass_top : Icons.tune),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CheckoutLiveScanner extends StatelessWidget {
  const CheckoutLiveScanner({required this.onCodeDetected, super.key});

  final CheckoutCodeDetected onCodeDetected;

  @override
  Widget build(BuildContext context) {
    return MobileScanner(
      key: const Key('checkoutLiveScanner'),
      fit: BoxFit.cover,
      errorBuilder: (context, error) => const _CheckoutScannerFallback(),
      placeholderBuilder: (context) => const ColoredBox(
        color: Color(0xFF111827),
        child: Center(child: CircularProgressIndicator(color: Colors.white)),
      ),
      onDetect: (capture) {
        final detected = capture.barcodes.firstOrNull?.rawValue;
        if (detected != null) {
          onCodeDetected(detected);
        }
      },
    );
  }
}

class CheckoutScannerScreen extends StatefulWidget {
  const CheckoutScannerScreen({this.scannerBuilder, super.key});

  final CheckoutScannerBuilder? scannerBuilder;

  @override
  State<CheckoutScannerScreen> createState() => _CheckoutScannerScreenState();
}

class _CheckoutScannerScreenState extends State<CheckoutScannerScreen> {
  var didReturnCode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Scan barcode'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          widget.scannerBuilder?.call(context, _returnCode) ??
              CheckoutLiveScanner(onCodeDetected: _returnCode),
          IgnorePointer(
            child: Center(
              child: Container(
                width: 240,
                height: 140,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ),
          const Positioned(
            left: 24,
            right: 24,
            bottom: 36,
            child: Text(
              'Hold the barcode inside the frame',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _returnCode(String code) {
    if (didReturnCode || code.trim().isEmpty) {
      return;
    }
    didReturnCode = true;
    Navigator.of(context).pop(code.trim());
  }
}

class _CheckoutScannerFallback extends StatelessWidget {
  const _CheckoutScannerFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF111827),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(18),
      child: const Text(
        'Camera unavailable. Enter the barcode below.',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

class _OrderItemsHeader extends StatelessWidget {
  const _OrderItemsHeader({required this.itemCount});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Order Items',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: _orderText,
            fontWeight: FontWeight.w800,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            '$itemCount',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: _orderAccent,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptyOrder extends StatelessWidget {
  const _EmptyOrder();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Text(
        'Search or scan to add products to this order.',
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _OrderLineTile extends ConsumerWidget {
  const _OrderLineTile({required this.line});

  final CartDraftLine line;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(checkoutCartProvider.notifier);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 7),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF1EC),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(Icons.inventory_2, color: _orderAccent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  line.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  Money(line.unitPriceMinor).format(),
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.black54),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _QuantityButton(
            tooltip: 'Increase quantity',
            icon: Icons.add,
            onPressed: line.quantity >= line.stockQuantity
                ? null
                : () => controller.updateQuantity(
                    line.productId,
                    line.quantity + 1,
                  ),
          ),
          SizedBox(
            width: 34,
            child: Text(
              '${line.quantity}',
              key: Key('orderLineQuantity-${line.productId}'),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          _QuantityButton(
            tooltip: 'Decrease quantity',
            icon: Icons.remove,
            onPressed: () =>
                controller.updateQuantity(line.productId, line.quantity - 1),
          ),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 34,
      child: IconButton.filled(
        tooltip: tooltip,
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        style: IconButton.styleFrom(
          backgroundColor: _orderAccent,
          disabledBackgroundColor: const Color(0xFFFFD4C8),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }
}

class _OrderSummaryBar extends StatelessWidget {
  const _OrderSummaryBar({required this.cart, required this.onCreateOrder});

  final CartDraft cart;
  final VoidCallback? onCreateOrder;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0,
      color: Colors.white,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Expanded(child: Text('Total price')),
                  Text(
                    Money(cart.totalMinor).format(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  key: const Key('openOrderInfoButton'),
                  onPressed: onCreateOrder,
                  style: FilledButton.styleFrom(
                    backgroundColor: _orderAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text('Create order'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _DiscountMode { amount, percentage }

class OrderInfoScreen extends ConsumerStatefulWidget {
  const OrderInfoScreen({super.key});

  @override
  ConsumerState<OrderInfoScreen> createState() => _OrderInfoScreenState();
}

class _OrderInfoScreenState extends ConsumerState<OrderInfoScreen> {
  final discountController = TextEditingController();
  final amountPaidController = TextEditingController();
  var discountMode = _DiscountMode.amount;
  var isRecording = false;

  @override
  void dispose() {
    discountController.dispose();
    amountPaidController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(checkoutCartProvider);
    final amountPaid = cart.amountPaidMinor ?? 0;
    final balance = cart.balanceDueMinor;
    final changeDue = (amountPaid - cart.totalMinor).clamp(0, amountPaid);

    return Scaffold(
      backgroundColor: _orderBackground,
      appBar: AppBar(
        title: const Text('Order info'),
        backgroundColor: _orderBackground,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          children: [
            _OrderInfoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total price',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    Money(cart.totalMinor).format(),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _OrderInfoCard(
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: discountController,
                          decoration: const InputDecoration(
                            labelText: 'Discount',
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          onChanged: _setDiscount,
                        ),
                      ),
                      const SizedBox(width: 12),
                      DropdownButton<_DiscountMode>(
                        value: discountMode,
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          setState(() => discountMode = value);
                          _setDiscount(discountController.text);
                        },
                        items: const [
                          DropdownMenuItem(
                            value: _DiscountMode.amount,
                            child: Text('Amount'),
                          ),
                          DropdownMenuItem(
                            value: _DiscountMode.percentage,
                            child: Text('Percentage'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    controller: amountPaidController,
                    decoration: const InputDecoration(labelText: 'Amount Paid'),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    onChanged: (value) => ref
                        .read(checkoutCartProvider.notifier)
                        .setAmountPaid(value),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _BalancePanel(
              label: balance > 0 ? 'Balance' : 'Change due',
              value: Money(balance > 0 ? balance : changeDue.toInt()).format(),
            ),
            const SizedBox(height: 18),
            ExpansionTile(
              tilePadding: EdgeInsets.zero,
              title: const Text('Customer Info'),
              childrenPadding: const EdgeInsets.only(bottom: 8),
              children: const [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Customer name',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                ),
                SizedBox(height: 12),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Phone number',
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
            const SizedBox(height: 24),
            FilledButton(
              key: const Key('submitOrderButton'),
              onPressed: isRecording || cart.isEmpty ? null : _recordSale,
              style: FilledButton.styleFrom(
                backgroundColor: _orderAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: Text(isRecording ? 'Creating...' : 'Create order'),
            ),
          ],
        ),
      ),
    );
  }

  void _setDiscount(String value) {
    final controller = ref.read(checkoutCartProvider.notifier);
    if (discountMode == _DiscountMode.amount) {
      controller.setDiscountAmount(value);
    } else {
      controller.setDiscountPercent(value);
    }
  }

  Future<void> _recordSale() async {
    if (isRecording) {
      return;
    }

    setState(() => isRecording = true);
    try {
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
          Navigator.of(context).pop(true);
        case AppFailure<CompleteSaleResult>(:final message):
          _showMessage(message);
      }
    } on FormatException {
      if (mounted) {
        _showMessage('Enter valid payment details');
      }
    } finally {
      if (mounted) {
        setState(() => isRecording = false);
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}

class _OrderInfoCard extends StatelessWidget {
  const _OrderInfoCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
      ),
      child: child,
    );
  }
}

class _BalancePanel extends StatelessWidget {
  const _BalancePanel({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: _orderAccent,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
