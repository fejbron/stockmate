import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../checkout/cart_controller.dart';
import '../checkout/checkout_providers.dart';
import '../checkout/checkout_screen.dart';
import '../checkout/checkout_repository.dart';
import '../inventory/link_barcode_screen.dart';
import '../inventory/product_form_screen.dart';
import '../shared/money.dart';
import 'manual_code_entry.dart';

class ScannerScreen extends ConsumerStatefulWidget {
  const ScannerScreen({super.key});

  @override
  ConsumerState<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends ConsumerState<ScannerScreen> {
  String? lastCode;
  SellableProduct? matchedProduct;
  bool isLookingUp = false;

  Future<void> _handleCode(String code) async {
    final trimmedCode = code.trim();
    if (trimmedCode.isEmpty || isLookingUp) {
      return;
    }

    setState(() {
      lastCode = trimmedCode;
      matchedProduct = null;
      isLookingUp = true;
    });

    final product = await ref
        .read(checkoutRepositoryProvider)
        .findProductByCode(trimmedCode);

    if (!mounted) {
      return;
    }

    setState(() {
      matchedProduct = product;
      isLookingUp = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          product == null
              ? 'No product found for $trimmedCode'
              : '${product.name} found',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final code = lastCode;
    final product = matchedProduct;

    return Scaffold(
      appBar: AppBar(title: const Text('Scan Product')),
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              errorBuilder: (context, error) => const ScannerCameraFallback(),
              placeholderBuilder: (context) => const ColoredBox(
                color: Colors.black,
                child: Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
              onDetect: (capture) {
                final detected = capture.barcodes.firstOrNull?.rawValue;
                if (detected != null && detected.trim() != lastCode) {
                  _handleCode(detected);
                }
              },
            ),
          ),
          if (isLookingUp) const LinearProgressIndicator(),
          if (code != null)
            ScannerResultPanel(
              code: code,
              product: product,
              onAddToCart: product == null ? null : () => _addProduct(product),
              onRecordSale: product == null ? null : _openCheckout,
              onAddNewProduct: () => _openNewProduct(code),
              onLinkExistingProduct: () => _openLinkProduct(code),
            ),
          ManualCodeEntry(onSubmitted: _handleCode),
        ],
      ),
    );
  }

  void _addProduct(SellableProduct product) {
    if (product.stockQuantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${product.name} is out of stock')),
      );
      return;
    }
    ref.read(checkoutCartProvider.notifier).addProduct(product);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('${product.name} added to cart')));
  }

  void _openCheckout() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const CheckoutScreen()));
  }

  void _openNewProduct(String code) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ProductFormScreen(initialCode: code),
      ),
    );
  }

  Future<void> _openLinkProduct(String code) async {
    final linked = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => LinkBarcodeScreen(codeValue: code),
      ),
    );
    if (linked == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Barcode linked and stock added')),
      );
      await _handleCode(code);
    }
  }
}

class ScannerResultPanel extends StatelessWidget {
  const ScannerResultPanel({
    required this.code,
    required this.product,
    required this.onAddToCart,
    required this.onRecordSale,
    required this.onAddNewProduct,
    required this.onLinkExistingProduct,
    super.key,
  });

  final String code;
  final SellableProduct? product;
  final VoidCallback? onAddToCart;
  final VoidCallback? onRecordSale;
  final VoidCallback onAddNewProduct;
  final VoidCallback onLinkExistingProduct;

  @override
  Widget build(BuildContext context) {
    final product = this.product;
    final price = product == null
        ? null
        : Text(
            Money(product.sellingPriceMinor).format(),
            style: Theme.of(context).textTheme.titleMedium,
          );

    return Card(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Icon(Icons.qr_code_2),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product?.name ?? 'Unknown product',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text('Last scanned: $code'),
                    ],
                  ),
                ),
                if (price != null) ...[const SizedBox(width: 12), price],
              ],
            ),
            const SizedBox(height: 12),
            if (product == null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FilledButton.icon(
                    onPressed: onLinkExistingProduct,
                    icon: const Icon(Icons.link),
                    label: const Text('Link to Existing Product'),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: onAddNewProduct,
                    icon: const Icon(Icons.add_box),
                    label: const Text('Add New Product'),
                  ),
                ],
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton.icon(
                    onPressed: onAddToCart,
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text('Add to Sale'),
                  ),
                  OutlinedButton.icon(
                    onPressed: onRecordSale,
                    icon: const Icon(Icons.point_of_sale),
                    label: const Text('Record Sale'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class ScannerCameraFallback extends StatelessWidget {
  const ScannerCameraFallback({super.key});

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: Colors.black,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.no_photography, color: Colors.white, size: 40),
              SizedBox(height: 12),
              Text(
                'Camera unavailable',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Enter the product code manually below.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
