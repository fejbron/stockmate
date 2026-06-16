import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

import '../data/app_database.dart';

/// Result of checking whether a file is a usable EziTally backup.
class BackupValidation {
  const BackupValidation.valid() : isValid = true, reason = null;
  const BackupValidation.invalid(this.reason) : isValid = false;

  final bool isValid;
  final String? reason;
}

/// Thrown when a restore cannot be completed.
class BackupException implements Exception {
  const BackupException(this.message);

  final String message;

  @override
  String toString() => 'BackupException: $message';
}

/// Platform-agnostic backup/restore of the app's SQLite database.
class BackupService {
  BackupService({
    required this.database,
    required this.resolveDatabaseFile,
  });

  final AppDatabase database;
  final Future<File> Function() resolveDatabaseFile;

  static const List<String> _requiredTables = ['products', 'sales'];

  /// Creates a timestamped copy of the database in [destination].
  Future<File> createBackup(Directory destination) async {
    await database.customStatement('PRAGMA wal_checkpoint(TRUNCATE);');
    final dbFile = await resolveDatabaseFile();
    final stamp = _timestamp(DateTime.now());
    final dest = File(
      p.join(destination.path, 'ezitally-backup-$stamp.sqlite'),
    );
    await dbFile.copy(dest.path);
    return dest;
  }

  /// Verifies [file] is a SQLite database created by this app version.
  Future<BackupValidation> validateBackup(File file) async {
    if (!await file.exists()) {
      return const BackupValidation.invalid('Backup file not found.');
    }

    final handle = await file.open();
    List<int> header;
    try {
      header = await handle.read(16);
    } finally {
      await handle.close();
    }
    if (!_hasSqliteHeader(header)) {
      return const BackupValidation.invalid(
        'This file is not a database backup.',
      );
    }

    Database? probe;
    try {
      probe = sqlite3.open(file.path, mode: OpenMode.readOnly);
      final version =
          probe.select('PRAGMA user_version;').first.columnAt(0) as int;
      if (version != database.schemaVersion) {
        return const BackupValidation.invalid(
          'This backup was made with a different app version.',
        );
      }
      final tables = probe
          .select("SELECT name FROM sqlite_master WHERE type = 'table';")
          .map((row) => row['name'] as String)
          .toSet();
      for (final required in _requiredTables) {
        if (!tables.contains(required)) {
          return const BackupValidation.invalid(
            'This backup is missing required data.',
          );
        }
      }
    } on SqliteException {
      return const BackupValidation.invalid('This backup file is unreadable.');
    } finally {
      probe?.dispose();
    }

    return const BackupValidation.valid();
  }

  /// Replaces the current database with [file]. Closes [database].
  ///
  /// On failure, the original database file is restored from a `.bak` sidecar.
  Future<void> restoreBackup(File file) async {
    final validation = await validateBackup(file);
    if (!validation.isValid) {
      throw BackupException(validation.reason ?? 'Invalid backup file.');
    }

    final backupBytes = await file.readAsBytes();
    final dbFile = await resolveDatabaseFile();
    final bak = File('${dbFile.path}.bak');
    if (await dbFile.exists()) {
      await dbFile.copy(bak.path);
    }

    await database.close();

    try {
      await dbFile.writeAsBytes(backupBytes, flush: true);
      await _deleteIfExists(File('${dbFile.path}-wal'));
      await _deleteIfExists(File('${dbFile.path}-shm'));
      await _deleteIfExists(bak);
    } catch (_) {
      if (await bak.exists()) {
        await bak.copy(dbFile.path);
        await _deleteIfExists(bak);
      }
      rethrow;
    }
  }

  bool _hasSqliteHeader(List<int> header) {
    const expected = 'SQLite format 3\u0000';
    if (header.length < expected.length) {
      return false;
    }
    for (var i = 0; i < expected.length; i++) {
      if (header[i] != expected.codeUnitAt(i)) {
        return false;
      }
    }
    return true;
  }

  Future<void> _deleteIfExists(File file) async {
    if (await file.exists()) {
      await file.delete();
    }
  }

  String _timestamp(DateTime now) {
    String two(int v) => v.toString().padLeft(2, '0');
    return '${now.year}${two(now.month)}${two(now.day)}-'
        '${two(now.hour)}${two(now.minute)}${two(now.second)}';
  }
}
