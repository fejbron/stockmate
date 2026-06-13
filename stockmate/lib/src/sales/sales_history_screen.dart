import 'package:flutter/material.dart';

class SalesHistoryScreen extends StatelessWidget {
  const SalesHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sales')),
      body: const Center(child: Text('No sales recorded yet')),
    );
  }
}
