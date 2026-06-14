import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../checkout/checkout_providers.dart';
import '../checkout/checkout_screen.dart';
import '../checkout/checkout_repository.dart';
import '../shared/money.dart';

class SalesHistoryScreen extends ConsumerWidget {
  const SalesHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sales = ref.watch(recentSalesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Sales')),
      body: sales.when(
        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text('No sales recorded yet'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) => _SaleTile(item: items[index]),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('Could not load sales: $error'),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const CheckoutScreen()),
          );
        },
        icon: const Icon(Icons.point_of_sale),
        label: const Text('Record Sale'),
      ),
    );
  }
}

class _SaleTile extends StatelessWidget {
  const _SaleTile({required this.item});

  final SaleListItem item;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.receipt_long),
        title: Text(item.receiptNumber),
        subtitle: Text('${item.itemCount} items'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              Money(item.totalMinor).format(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text('Profit ${Money(item.grossProfitMinor).format()}'),
          ],
        ),
      ),
    );
  }
}
