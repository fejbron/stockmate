import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../shared/money.dart';
import 'reports_providers.dart';
import 'reports_repository.dart';

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(reportsSummaryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Reports')),
      body: summary.when(
        data: (value) => _ReportsContent(summary: value),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('Could not load reports: $error'),
          ),
        ),
      ),
    );
  }
}

class _ReportsContent extends StatelessWidget {
  const _ReportsContent({required this.summary});

  final ReportsSummary summary;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _ReportTile(
          icon: Icons.payments,
          title: 'Revenue',
          value: Money(summary.revenueMinor).format(),
          subtitle: 'Sales totals after discounts',
        ),
        _ReportTile(
          icon: Icons.trending_up,
          title: 'Gross Profit',
          value: Money(summary.grossProfitMinor).format(),
          subtitle: 'Revenue minus batch costs',
        ),
        _ReportTile(
          icon: Icons.inventory,
          title: 'Stock Value',
          value: Money(summary.stockValueMinor).format(),
          subtitle: 'Remaining stock valued by batch cost',
        ),
        const SizedBox(height: 16),
        Text('Top Products', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        if (summary.topProducts.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text('No product sales yet'),
            ),
          )
        else
          ...summary.topProducts.map((product) {
            return Card(
              child: ListTile(
                leading: const Icon(Icons.local_offer),
                title: Text(product.name),
                subtitle: Text('${product.quantitySold} sold'),
                trailing: Text(Money(product.revenueMinor).format()),
              ),
            );
          }),
      ],
    );
  }
}

class _ReportTile extends StatelessWidget {
  const _ReportTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String value;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Text(value, style: Theme.of(context).textTheme.titleMedium),
      ),
    );
  }
}
