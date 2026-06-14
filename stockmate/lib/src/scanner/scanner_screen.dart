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
    final trimmedCode = code.trim();
    if (trimmedCode.isEmpty) {
      return;
    }
    setState(() => lastCode = trimmedCode);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Scanned $trimmedCode')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Product')),
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              errorBuilder: (context, error) => const ScannerCameraFallback(),
              placeholderBuilder: (context) => const ColoredBox(
                color: Colors.black,
                child: Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
              onDetect: (capture) {
                final code = capture.barcodes.firstOrNull?.rawValue;
                if (code != null && code != lastCode) {
                  _handleCode(code);
                }
              },
            ),
          ),
          if (lastCode case final code?)
            ListTile(
              leading: const Icon(Icons.qr_code_2),
              title: const Text('Last scanned'),
              subtitle: Text(code),
            ),
          ManualCodeEntry(onSubmitted: _handleCode),
        ],
      ),
    );
  }
}

class ScannerCameraFallback extends StatelessWidget {
  const ScannerCameraFallback({super.key});

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: Colors.black,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.no_photography, color: Colors.white, size: 40),
              SizedBox(height: 12),
              Text(
                'Camera unavailable',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Enter the product code manually below.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
