import 'package:flutter/material.dart';

class ManualCodeEntry extends StatefulWidget {
  const ManualCodeEntry({required this.onSubmitted, super.key});

  final ValueChanged<String> onSubmitted;

  @override
  State<ManualCodeEntry> createState() => _ManualCodeEntryState();
}

class _ManualCodeEntryState extends State<ManualCodeEntry> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Enter barcode or internal code',
              ),
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () {
                final value = controller.text.trim();
                if (value.isNotEmpty) {
                  widget.onSubmitted(value);
                }
              },
              child: const Text('Use Code'),
            ),
          ],
        ),
      ),
    );
  }
}
