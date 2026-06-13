import 'package:flutter/material.dart';

class ProductFormScreen extends StatefulWidget {
  const ProductFormScreen({super.key});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final quantityController = TextEditingController();
  final costController = TextEditingController();

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
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
            ),
            TextFormField(
              controller: quantityController,
              decoration: const InputDecoration(labelText: 'Quantity received'),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
            ),
            TextFormField(
              controller: costController,
              decoration: const InputDecoration(labelText: 'Cost per unit'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => formKey.currentState!.validate(),
              child: const Text('Save Product'),
            ),
          ],
        ),
      ),
    );
  }
}
