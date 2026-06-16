import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({required this.productName, super.key});

  final String productName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(productName)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ListTile(
            leading: Icon(Icons.inventory_2),
            title: Text('Current Stock'),
            subtitle: Text('Stock batch details will appear here.'),
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text('Adjustments'),
            subtitle: Text('Manual stock changes will appear here.'),
          ),
        ],
      ),
    );
  }
}
