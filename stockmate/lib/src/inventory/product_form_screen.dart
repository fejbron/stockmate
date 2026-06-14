import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../shared/money.dart';
import 'inventory_providers.dart';
import 'inventory_repository.dart';

class ProductFormScreen extends ConsumerStatefulWidget {
  const ProductFormScreen({this.initialCode, this.productId, super.key});

  final String? initialCode;
  final int? productId;

  @override
  ConsumerState<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends ConsumerState<ProductFormScreen> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final codeController = TextEditingController();
  final aliasCodeController = TextEditingController();
  final lowStockController = TextEditingController();
  final quantityController = TextEditingController();
  final costController = TextEditingController();
  var isSaving = false;
  var isLoading = false;

  bool get isEditing => widget.productId != null;

  @override
  void initState() {
    super.initState();
    codeController.text = widget.initialCode ?? '';
    if (isEditing) {
      isLoading = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadProduct());
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    codeController.dispose();
    aliasCodeController.dispose();
    lowStockController.dispose();
    quantityController.dispose();
    costController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Product' : 'Add Product')),
      body: Form(
        key: formKey,
        child: SafeArea(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Product details',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: nameController,
                              decoration: const InputDecoration(
                                labelText: 'Product name',
                                prefixIcon: Icon(Icons.inventory_2),
                              ),
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Enter product name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: priceController,
                              decoration: const InputDecoration(
                                labelText: 'Selling price',
                                prefixIcon: Icon(Icons.sell),
                              ),
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              textInputAction: TextInputAction.next,
                              validator: _optionalMoneyValidator,
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: codeController,
                              decoration: const InputDecoration(
                                labelText: 'Product code',
                                prefixIcon: Icon(Icons.qr_code_2),
                              ),
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: lowStockController,
                              decoration: const InputDecoration(
                                labelText: 'Low stock threshold',
                                prefixIcon: Icon(Icons.warning_amber),
                              ),
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              validator: _optionalWholeNumberValidator,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (isEditing && widget.productId != null) ...[
                      _BarcodeAliasesCard(
                        productId: widget.productId!,
                        aliasCodeController: aliasCodeController,
                        onAddCode: _addAliasCode,
                        onDeleteCode: _deleteAliasCode,
                      ),
                      const SizedBox(height: 16),
                    ],
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              isEditing ? 'Add stock' : 'Initial stock',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: quantityController,
                              decoration: InputDecoration(
                                labelText: isEditing
                                    ? 'Add stock quantity'
                                    : 'Quantity received',
                                prefixIcon: const Icon(Icons.add_box),
                              ),
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              validator: _optionalWholeNumberValidator,
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: costController,
                              decoration: const InputDecoration(
                                labelText: 'Cost per unit',
                                prefixIcon: Icon(Icons.price_change),
                              ),
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              validator: _optionalMoneyValidator,
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
            onPressed: isSaving || isLoading ? null : _saveProduct,
            icon: Icon(isEditing ? Icons.save : Icons.add),
            label: Text(
              isSaving
                  ? 'Saving...'
                  : isEditing
                  ? 'Update Product'
                  : 'Save Product',
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _loadProduct() async {
    final productId = widget.productId;
    if (productId == null) {
      return;
    }

    try {
      final product = await ref
          .read(inventoryRepositoryProvider)
          .productForEdit(productId);
      if (!mounted) {
        return;
      }

      if (product == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Product not found')));
        Navigator.of(context).maybePop();
        return;
      }

      setState(() {
        nameController.text = product.name;
        priceController.text = Money(product.sellingPriceMinor).format();
        codeController.text = product.codeValue;
        lowStockController.text = '${product.lowStockThreshold}';
        isLoading = false;
      });
    } on Exception catch (error) {
      if (!mounted) {
        return;
      }
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not load product: $error')));
    }
  }

  Future<void> _saveProduct() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    setState(() => isSaving = true);
    try {
      if (isEditing) {
        await _updateProduct();
      } else {
        await _createProduct();
      }

      if (!mounted) {
        return;
      }
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop(true);
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isEditing ? 'Product updated' : 'Product saved'),
        ),
      );
      if (!isEditing) {
        nameController.clear();
        priceController.clear();
        codeController.clear();
        lowStockController.clear();
        quantityController.clear();
        costController.clear();
      }
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

  Future<void> _createProduct() async {
    final useCase = ref.read(addStockUseCaseProvider);
    final generator = ref.read(internalCodeGeneratorProvider);
    final enteredCode = codeController.text.trim();
    await useCase.createProductWithStock(
      name: nameController.text.trim(),
      codeValue: enteredCode.isEmpty
          ? generator.generate(productId: 0)
          : enteredCode,
      codeType: enteredCode.isEmpty ? 'internal' : 'barcode',
      source: enteredCode.isEmpty ? 'generated' : 'scanned',
      sellingPriceMinor: _moneyMinorOrZero(priceController.text),
      quantityReceived: _intOrZero(quantityController.text),
      costPerUnitMinor: _moneyMinorOrZero(costController.text),
      lowStockThreshold: _intOrZero(lowStockController.text),
    );
  }

  Future<void> _updateProduct() async {
    final productId = widget.productId;
    if (productId == null) {
      return;
    }

    await ref
        .read(inventoryRepositoryProvider)
        .updateProduct(
          productId: productId,
          name: nameController.text.trim(),
          codeValue: codeController.text.trim(),
          sellingPriceMinor: _moneyMinorOrZero(priceController.text),
          lowStockThreshold: _intOrZero(lowStockController.text),
          quantityReceived: _intOrZero(quantityController.text),
          costPerUnitMinor: _moneyMinorOrZero(costController.text),
        );
  }

  Future<void> _addAliasCode() async {
    final productId = widget.productId;
    final codeValue = aliasCodeController.text.trim();
    if (productId == null || codeValue.isEmpty) {
      return;
    }

    try {
      await ref
          .read(inventoryRepositoryProvider)
          .linkCodeToExistingProduct(
            productId: productId,
            codeValue: codeValue,
            quantityReceived: 0,
            costPerUnitMinor: 0,
          );
      aliasCodeController.clear();
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Barcode added')));
      }
    } on DuplicateProductCodeException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.toString())));
      }
    }
  }

  Future<void> _deleteAliasCode(ProductCodeItem code) async {
    try {
      await ref.read(inventoryRepositoryProvider).deleteProductCode(code.id);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Barcode removed')));
      }
    } on PrimaryProductCodeException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.toString())));
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

class _BarcodeAliasesCard extends ConsumerWidget {
  const _BarcodeAliasesCard({
    required this.productId,
    required this.aliasCodeController,
    required this.onAddCode,
    required this.onDeleteCode,
  });

  final int productId;
  final TextEditingController aliasCodeController;
  final VoidCallback onAddCode;
  final ValueChanged<ProductCodeItem> onDeleteCode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final codes = ref.watch(productCodesProvider(productId));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Barcodes', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            codes.when(
              data: (items) {
                if (items.isEmpty) {
                  return const Text('No barcodes linked yet');
                }

                return Column(
                  children: [
                    for (final code in items)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            const Icon(Icons.qr_code_2),
                            const SizedBox(width: 12),
                            Expanded(child: Text(code.codeValue)),
                            if (code.isPrimary)
                              const Chip(label: Text('Primary'))
                            else
                              IconButton(
                                tooltip: 'Remove barcode',
                                onPressed: () => onDeleteCode(code),
                                icon: const Icon(Icons.delete_outline),
                              ),
                          ],
                        ),
                      ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) =>
                  Text('Could not load barcodes: $error'),
            ),
            const SizedBox(height: 4),
            LayoutBuilder(
              builder: (context, constraints) {
                final field = TextField(
                  key: const Key('additionalBarcodeField'),
                  controller: aliasCodeController,
                  decoration: const InputDecoration(
                    labelText: 'Additional barcode',
                    prefixIcon: Icon(Icons.link),
                  ),
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => onAddCode(),
                );
                final button = FilledButton.icon(
                  onPressed: onAddCode,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Barcode'),
                );

                if (constraints.maxWidth < 520) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [field, const SizedBox(height: 12), button],
                  );
                }

                return Row(
                  children: [
                    Expanded(child: field),
                    const SizedBox(width: 12),
                    button,
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
