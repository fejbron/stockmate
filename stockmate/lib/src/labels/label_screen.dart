import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';

class LabelScreen extends StatelessWidget {
  const LabelScreen({required this.code, super.key});

  final String code;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Label')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BarcodeWidget(
                barcode: Barcode.qrCode(),
                data: code,
                width: 220,
                height: 220,
              ),
              const SizedBox(height: 16),
              SelectableText(
                code,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
