import 'package:flutter/material.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reports')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ListTile(
            title: Text('Revenue'),
            subtitle: Text('Sales totals after discounts'),
          ),
          ListTile(
            title: Text('Gross Profit'),
            subtitle: Text('Revenue minus batch costs'),
          ),
          ListTile(
            title: Text('Top Products'),
            subtitle: Text('Best-selling products by quantity'),
          ),
          ListTile(
            title: Text('Stock Value'),
            subtitle: Text('Remaining stock valued by batch cost'),
          ),
        ],
      ),
    );
  }
}
