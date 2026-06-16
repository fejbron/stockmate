import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'backup/backup_providers.dart';

/// Hosts the root [ProviderContainer] and can rebuild it, which reopens the
/// database. Used to apply a restored backup without a process restart.
class AppRestarter extends StatefulWidget {
  const AppRestarter({super.key});

  @override
  State<AppRestarter> createState() => AppRestarterState();

  static AppRestarterState of(BuildContext context) {
    final state = context.findAncestorStateOfType<AppRestarterState>();
    assert(state != null, 'AppRestarter ancestor not found');
    return state!;
  }
}

class AppRestarterState extends State<AppRestarter> {
  ProviderContainer _container = ProviderContainer();
  bool _busy = false;

  /// Restores [backup], reopening the database afterwards. Shows a snackbar
  /// with the outcome.
  Future<void> restoreFromFile(File backup) async {
    if (_busy) {
      return;
    }
    final service = _container.read(backupServiceProvider);

    setState(() => _busy = true);
    await WidgetsBinding.instance.endOfFrame;

    String message;
    try {
      await service.restoreBackup(backup);
      message = 'Data restored successfully.';
    } on Object catch (error) {
      message = 'Restore failed: $error';
    }

    final old = _container;
    _container = ProviderContainer();
    old.dispose();

    if (!mounted) {
      return;
    }
    setState(() => _busy = false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      rootScaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(content: Text(message)),
      );
    });
  }

  @override
  void dispose() {
    _container.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_busy) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }
    return UncontrolledProviderScope(
      container: _container,
      child: StockmateApp(),
    );
  }
}
