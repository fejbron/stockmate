import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../shared/money.dart';
import 'inventory_providers.dart';
import 'inventory_repository.dart';

class LinkBarcodeScreen extends ConsumerStatefulWidget {
  const LinkBarcodeScreen({required this.codeValue, super.key});

  final String codeValue;

  @override
  ConsumerState<LinkBarcodeScreen> createState() => _LinkBarcodeScreenState();
}

class _LinkBarcodeScreenState extends ConsumerState<LinkBarcodeScreen> {
  final formKey = GlobalKey<FormState>();
  final quantityController = TextEditingController();
  final costController = TextEditingController();
  int? selectedProductId;
  var isSaving = false;

  @override
  void dispose() {
    quantityController.dispose();
    costController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(activeProductLookupProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Link Barcode')),
      body: SafeArea(
        child: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Scanned barcode',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      SelectableText(widget.codeValue),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Existing product',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      products.when(
                        data: (items) {
                          if (items.isEmpty) {
                            return const Text(
                              'Add a product first, then link this barcode.',
                            );
                          }

                          return DropdownButtonFormField<int>(
                            initialValue: selectedProductId,
                            decoration: const InputDecoration(
                              labelText: 'Select product',
                              prefixIcon: Icon(Icons.inventory_2),
                            ),
                            items: [
                              for (final item in items)
                                DropdownMenuItem<int>(
                                  value: item.id,
                                  child: Text(item.name),
                                ),
                            ],
                            onChanged: isSaving
                                ? null
                                : (value) {
                                    setState(() => selectedProductId = value);
                                  },
                            validator: (value) {
                              if (value == null) {
                                return 'Select a product';
                              }
                              return null;
                            },
                          );
                        },
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (error, stackTrace) =>
                            Text('Could not load products: $error'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Add stock',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: quantityController,
                        decoration: const InputDecoration(
                          labelText: 'Quantity received',
                          prefixIcon: Icon(Icons.add_box),
                        ),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        validator: _wholeNumberValidator,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: costController,
                        decoration: const InputDecoration(
                          labelText: 'Cost per unit',
                          prefixIcon: Icon(Icons.price_change),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        validator: _moneyValidator,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: FilledButton.icon(
            onPressed: isSaving ? null : _save,
            icon: const Icon(Icons.link),
            label: Text(isSaving ? 'Linking...' : 'Link Barcode'),
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    final productId = selectedProductId;
    if (productId == null) {
      _showMessage('Select a product');
      return;
    }

    setState(() => isSaving = true);
    try {
      await ref
          .read(inventoryRepositoryProvider)
          .linkCodeToExistingProduct(
            productId: productId,
            codeValue: widget.codeValue,
            quantityReceived: _intOrZero(quantityController.text),
            costPerUnitMinor: _moneyMinorOrZero(costController.text),
          );
      if (!mounted) {
        return;
      }
      Navigator.of(context).pop(true);
    } on DuplicateProductCodeException catch (error) {
      if (mounted) {
        _showMessage(error.toString());
      }
    } on Exception catch (error) {
      if (mounted) {
        _showMessage('Could not link barcode: $error');
      }
    } finally {
      if (mounted) {
        setState(() => isSaving = false);
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  String? _wholeNumberValidator(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return 'Enter quantity received';
    }
    final parsed = int.tryParse(text);
    if (parsed == null || parsed <= 0) {
      return 'Enter a valid quantity';
    }
    return null;
  }

  String? _moneyValidator(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return 'Enter cost per unit';
    }
    try {
      Money.fromDecimal(text);
      return null;
    } on FormatException {
      return 'Enter a valid amount';
    }
  }

  int _moneyMinorOrZero(String value) => Money.fromDecimal(value).minorUnits;

  int _intOrZero(String value) => int.parse(value.trim());
}
