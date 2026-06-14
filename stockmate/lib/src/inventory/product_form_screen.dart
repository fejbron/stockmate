import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../shared/money.dart';
import 'inventory_providers.dart';

class ProductFormScreen extends ConsumerStatefulWidget {
  const ProductFormScreen({super.key});

  @override
  ConsumerState<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends ConsumerState<ProductFormScreen> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final quantityController = TextEditingController();
  final costController = TextEditingController();
  var isSaving = false;

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    quantityController.dispose();
    costController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Product')),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Product name'),
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Enter product name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'Selling price'),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              textInputAction: TextInputAction.next,
              validator: _optionalMoneyValidator,
            ),
            TextFormField(
              controller: quantityController,
              decoration: const InputDecoration(labelText: 'Quantity received'),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              validator: _optionalWholeNumberValidator,
            ),
            TextFormField(
              controller: costController,
              decoration: const InputDecoration(labelText: 'Cost per unit'),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: _optionalMoneyValidator,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: isSaving ? null : _saveProduct,
              child: Text(isSaving ? 'Saving...' : 'Save Product'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveProduct() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    setState(() => isSaving = true);
    try {
      final useCase = ref.read(addStockUseCaseProvider);
      final generator = ref.read(internalCodeGeneratorProvider);
      await useCase.createProductWithStock(
        name: nameController.text.trim(),
        codeValue: generator.generate(productId: 0),
        codeType: 'internal',
        source: 'generated',
        sellingPriceMinor: _moneyMinorOrZero(priceController.text),
        quantityReceived: _intOrZero(quantityController.text),
        costPerUnitMinor: _moneyMinorOrZero(costController.text),
        lowStockThreshold: 0,
      );

      if (!mounted) {
        return;
      }
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop(true);
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Product saved')));
      nameController.clear();
      priceController.clear();
      quantityController.clear();
      costController.clear();
    } on Exception catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not save product: $error')));
    } finally {
      if (mounted) {
        setState(() => isSaving = false);
      }
    }
  }

  String? _optionalMoneyValidator(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return null;
    }
    try {
      Money.fromDecimal(text);
      return null;
    } on FormatException {
      return 'Enter a valid amount';
    }
  }

  String? _optionalWholeNumberValidator(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return null;
    }
    final parsed = int.tryParse(text);
    if (parsed == null || parsed < 0) {
      return 'Enter a valid quantity';
    }
    return null;
  }

  int _moneyMinorOrZero(String value) {
    final text = value.trim();
    if (text.isEmpty) {
      return 0;
    }
    return Money.fromDecimal(text).minorUnits;
  }

  int _intOrZero(String value) {
    final text = value.trim();
    if (text.isEmpty) {
      return 0;
    }
    return int.parse(text);
  }
}
