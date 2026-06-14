import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../shared/money.dart';
import 'receipt_providers.dart';
import 'receipt_repository.dart';

class ReceiptDetailScreen extends ConsumerWidget {
  const ReceiptDetailScreen({required this.saleId, super.key});

  final int saleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(receiptDetailProvider(saleId));

    return Scaffold(
      appBar: AppBar(title: const Text('Receipt')),
      body: detail.when(
        data: (value) {
          if (value == null) {
            return const Center(child: Text('Receipt not found'));
          }
          return _ReceiptDetailContent(detail: value);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('Could not load receipt: $error'),
          ),
        ),
      ),
    );
  }
}

class _ReceiptDetailContent extends StatelessWidget {
  const _ReceiptDetailContent({required this.detail});

  final ReceiptDetail detail;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Receipt ${detail.receiptNumber}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(DateFormat.yMMMd().add_jm().format(detail.soldAt)),
                const SizedBox(height: 8),
                Text('Payment: ${detail.paymentMethod}'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text('Items', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        for (final line in detail.lines) ...[
          _ReceiptLineTile(line: line),
          const SizedBox(height: 8),
        ],
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _TotalRow(
                  label: 'Subtotal',
                  value: Money(detail.subtotalMinor).format(),
                ),
                if (detail.discountTotalMinor > 0)
                  _TotalRow(
                    label: 'Discount',
                    value: Money(detail.discountTotalMinor).format(),
                  ),
                _TotalRow(
                  label: 'Total',
                  value: Money(detail.totalMinor).format(),
                  emphasized: true,
                ),
                _TotalRow(
                  label: 'Cost',
                  value: Money(detail.costTotalMinor).format(),
                ),
                _TotalRow(
                  label: 'Profit',
                  value: Money(detail.grossProfitMinor).format(),
                ),
                if (detail.amountPaidMinor != null)
                  _TotalRow(
                    label: 'Amount paid',
                    value: Money(detail.amountPaidMinor!).format(),
                  ),
                if (detail.changeDueMinor != null)
                  _TotalRow(
                    label: 'Change due',
                    value: Money(detail.changeDueMinor!).format(),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ReceiptLineTile extends StatelessWidget {
  const _ReceiptLineTile({required this.line});

  final ReceiptDetailLine line;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const Icon(Icons.inventory_2),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    line.productName,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${line.quantity} x ${Money(line.unitPriceMinor).format()}',
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              Money(line.lineTotalMinor).format(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  const _TotalRow({
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  final String label;
  final String value;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final style = emphasized
        ? Theme.of(context).textTheme.titleMedium
        : Theme.of(context).textTheme.bodyMedium;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(value, style: style),
        ],
      ),
    );
  }
}
