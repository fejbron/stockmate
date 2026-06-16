import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../app_restarter.dart';
import 'backup_providers.dart';

typedef PickBackupFile = Future<File?> Function();
typedef ShareBackupFile = Future<void> Function(File file);

class DataBackupCard extends ConsumerStatefulWidget {
  const DataBackupCard({this.pickFile, this.shareFile, super.key});

  /// Injection seams for tests. Default to real plugin calls.
  final PickBackupFile? pickFile;
  final ShareBackupFile? shareFile;

  @override
  ConsumerState<DataBackupCard> createState() => _DataBackupCardState();
}

class _DataBackupCardState extends ConsumerState<DataBackupCard> {
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Data Backup',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            const Text(
              'Save all your products and sales to a file, or restore from a '
              'previous backup.',
            ),
            const SizedBox(height: 16),
            if (_busy)
              const Center(child: CircularProgressIndicator())
            else ...[
              FilledButton.icon(
                onPressed: _backup,
                icon: const Icon(Icons.backup),
                label: const Text('Back up data'),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: _restore,
                icon: const Icon(Icons.restore),
                label: const Text('Restore from file'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _backup() async {
    setState(() => _busy = true);
    try {
      final service = ref.read(backupServiceProvider);
      final dir = await getTemporaryDirectory();
      final file = await service.createBackup(dir);
      await (widget.shareFile ?? _defaultShare)(file);
    } on Object catch (error) {
      _showMessage('Backup failed: $error');
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  Future<void> _restore() async {
    final pick = widget.pickFile ?? _defaultPick;
    final file = await pick();
    if (file == null || !mounted) {
      return;
    }

    final service = ref.read(backupServiceProvider);
    final validation = await service.validateBackup(file);
    if (!mounted) {
      return;
    }
    if (!validation.isValid) {
      _showMessage(validation.reason ?? 'Invalid backup file.');
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Replace all current data?'),
        content: const Text(
          'Restoring will overwrite all current products and sales with the '
          'contents of this backup. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Restore'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) {
      return;
    }

    await AppRestarter.of(context).restoreFromFile(file);
  }

  Future<void> _defaultShare(File file) async {
    await SharePlus.instance.share(
      ShareParams(files: [XFile(file.path)], text: 'EziTally data backup'),
    );
  }

  Future<File?> _defaultPick() async {
    final result = await FilePicker.platform.pickFiles();
    final path = result?.files.single.path;
    return path == null ? null : File(path);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
