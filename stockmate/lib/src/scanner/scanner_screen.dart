import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'manual_code_entry.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  String? lastCode;

  void _handleCode(String code) {
    setState(() => lastCode = code);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Scanned $code')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Product')),
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              onDetect: (capture) {
                final code = capture.barcodes.firstOrNull?.rawValue;
                if (code != null && code != lastCode) {
                  _handleCode(code);
                }
              },
            ),
          ),
          ManualCodeEntry(onSubmitted: _handleCode),
        ],
      ),
    );
  }
}
