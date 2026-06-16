# Data Backup & Restore Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Let users back up all EziTally data to a single SQLite file (shared via the OS share sheet) and restore it later, replacing the current data, on iOS/Android.

**Architecture:** A platform-agnostic `BackupService` does the file work (checkpoint+copy for backup; validate+`.bak`+overwrite+rollback for restore) against the live `AppDatabase` and a resolved database file. A thin Riverpod/UI layer wires `share_plus`/`file_picker`/`path_provider`. Restore reopens the database by tearing down and recreating the root `ProviderContainer` (no process restart), made safe by an idempotent `AppDatabase.close()`.

**Tech Stack:** Flutter, Riverpod, Drift (SQLite), `sqlite3`, `path_provider`, `share_plus`, `file_picker`, `path`.

---

## Notes for the implementer

- All paths are relative to the Flutter project root: `.worktrees/build-ios-sales-inventory/stockmate/`.
- Run Flutter commands from that directory. `flutter` needs to write to its SDK cache, so commands run outside the sandbox.
- The database is a Drift SQLite DB stored at `<getApplicationDocumentsDirectory()>/stockmate.sqlite` in WAL mode. Backup must checkpoint the WAL before copying. Restore must remove `-wal`/`-shm` sidecars.
- Follow existing conventions: `require_trailing_commas`, `always_declare_return_types`, `prefer_final_locals`, no narrating comments.

---

## Task 0: Add dependencies

**Files:**
- Modify: `pubspec.yaml`

- [ ] **Step 1: Add the packages via the package manager**

Run:
```bash
flutter pub add share_plus file_picker path_provider sqlite3 path
```
Expected: `pubspec.yaml` gains these under `dependencies:` and `flutter pub get` resolves successfully.

- [ ] **Step 2: Verify resolution**

Run: `flutter pub get`
Expected: "Got dependencies!" with no version-solving errors.

- [ ] **Step 3: Commit**

```bash
git add pubspec.yaml pubspec.lock
git commit -m "chore: add backup/restore dependencies"
```

---

## Task 1: Database file location + idempotent close

This gives backup/restore a single source of truth for the DB path and makes reopen safe.

**Files:**
- Create: `lib/src/data/database_location.dart`
- Modify: `lib/src/data/app_database.dart`

- [ ] **Step 1: Create the path resolver**

Create `lib/src/data/database_location.dart`:
```dart
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Resolves the on-disk location of the app's SQLite database.
///
/// Matches drift_flutter's default for `driftDatabase(name: 'stockmate')`:
/// `<application documents directory>/stockmate.sqlite`.
Future<File> resolveDatabaseFile() async {
  final directory = await getApplicationDocumentsDirectory();
  return File(p.join(directory.path, 'stockmate.sqlite'));
}
```

- [ ] **Step 2: Make `AppDatabase.close()` idempotent and pin the native path**

In `lib/src/data/app_database.dart`, the existing imports are:
```dart
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
```
Add a relative import for the new file directly below them:
```dart
import 'database_location.dart';
```

Replace the entire `AppDatabase` class (currently lines 149-172, the block starting `class AppDatabase extends _$AppDatabase {`) with:
```dart
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  AppDatabase.defaults()
    : super(
        driftDatabase(
          name: 'stockmate',
          native: DriftNativeOptions(
            databasePath: () async => (await resolveDatabaseFile()).path,
          ),
          web: DriftWebOptions(
            sqlite3Wasm: Uri.parse('sqlite3.wasm'),
            driftWorker: Uri.parse('drift_worker.js'),
          ),
        ),
      );

  bool _isClosed = false;

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  @override
  Future<void> close() async {
    if (_isClosed) {
      return;
    }
    _isClosed = true;
    await super.close();
  }
}
```
Note: `DriftNativeOptions` and `DriftWebOptions` come from `drift_flutter` (already imported). On web, `databasePath` is ignored.

- [ ] **Step 3: Analyze**

Run: `flutter analyze lib/src/data/app_database.dart lib/src/data/database_location.dart`
Expected: No issues.

- [ ] **Step 4: Confirm existing tests still pass**

Run: `flutter test test/data/app_database_test.dart`
Expected: PASS (these construct `AppDatabase(NativeDatabase.memory())`, unaffected by `.defaults()` changes).

- [ ] **Step 5: Commit**

```bash
git add lib/src/data/app_database.dart lib/src/data/database_location.dart
git commit -m "feat: resolve db file path and make close idempotent"
```

---

## Task 2: BackupService core (TDD)

The platform-agnostic core. No `path_provider`/`share_plus`/`file_picker` imports here.

**Files:**
- Create: `lib/src/backup/backup_service.dart`
- Test: `test/backup/backup_service_test.dart`

- [ ] **Step 1: Write the failing test**

Create `test/backup/backup_service_test.dart`:
```dart
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:stockmate/src/backup/backup_service.dart';
import 'package:stockmate/src/data/app_database.dart';

void main() {
  late Directory tempDir;
  late File dbFile;
  late AppDatabase db;
  late BackupService service;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('ezitally_backup_test');
    dbFile = File(p.join(tempDir.path, 'stockmate.sqlite'));
    db = AppDatabase(NativeDatabase(dbFile));
    service = BackupService(
      database: db,
      resolveDatabaseFile: () async => dbFile,
    );
  });

  tearDown(() async {
    await db.close();
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('createBackup writes a copy that validates', () async {
    await db
        .into(db.products)
        .insert(ProductsCompanion.insert(name: 'Milk', sellingPriceMinor: 500));

    final backup = await service.createBackup(tempDir);

    expect(await backup.exists(), isTrue);
    expect(p.basename(backup.path), startsWith('ezitally-backup-'));
    expect(p.extension(backup.path), '.sqlite');
    final validation = await service.validateBackup(backup);
    expect(validation.isValid, isTrue);
  });

  test('validateBackup rejects a non-sqlite file', () async {
    final junk = File(p.join(tempDir.path, 'notes.txt'));
    await junk.writeAsString('this is not a database');

    final validation = await service.validateBackup(junk);

    expect(validation.isValid, isFalse);
    expect(validation.reason, isNotNull);
  });

  test('restoreBackup replaces current data with the backup', () async {
    await db
        .into(db.products)
        .insert(ProductsCompanion.insert(name: 'Milk', sellingPriceMinor: 500));
    final backup = await service.createBackup(tempDir);

    // Mutate after the backup was taken.
    await db
        .into(db.products)
        .insert(ProductsCompanion.insert(name: 'Sugar', sellingPriceMinor: 300));

    await service.restoreBackup(backup);

    // service.restoreBackup closes `db`; open a fresh handle to verify.
    final reopened = AppDatabase(NativeDatabase(dbFile));
    final names = (await reopened.select(reopened.products).get())
        .map((row) => row.name)
        .toList();
    await reopened.close();

    expect(names, ['Milk']);
    expect(File('${dbFile.path}-wal').existsSync(), isFalse);
    expect(File('${dbFile.path}.bak').existsSync(), isFalse);
  });
}
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `flutter test test/backup/backup_service_test.dart`
Expected: FAIL — `backup_service.dart` does not exist / `BackupService` undefined.

- [ ] **Step 3: Write the implementation**

Create `lib/src/backup/backup_service.dart`:
```dart
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
    final dest = File(p.join(destination.path, 'ezitally-backup-$stamp.sqlite'));
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
      return const BackupValidation.invalid('This file is not a database backup.');
    }

    Database? probe;
    try {
      probe = sqlite3.open(file.path, mode: OpenMode.readOnly);
      final version = probe.select('PRAGMA user_version;').first.columnAt(0) as int;
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
    } on Exception {
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
```

- [ ] **Step 4: Run the test to verify it passes**

Run: `flutter test test/backup/backup_service_test.dart`
Expected: PASS (3 tests).

- [ ] **Step 5: Analyze**

Run: `flutter analyze lib/src/backup/backup_service.dart`
Expected: No issues.

- [ ] **Step 6: Commit**

```bash
git add lib/src/backup/backup_service.dart test/backup/backup_service_test.dart
git commit -m "feat: add backup service with create/validate/restore"
```

---

## Task 3: Backup provider

Exposes `BackupService` to the widget layer.

**Files:**
- Create: `lib/src/backup/backup_providers.dart`

- [ ] **Step 1: Create the provider**

Create `lib/src/backup/backup_providers.dart`:
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database_location.dart';
import '../data/database_provider.dart';
import 'backup_service.dart';

final backupServiceProvider = Provider<BackupService>((ref) {
  return BackupService(
    database: ref.watch(databaseProvider),
    resolveDatabaseFile: resolveDatabaseFile,
  );
});
```

- [ ] **Step 2: Analyze**

Run: `flutter analyze lib/src/backup/backup_providers.dart`
Expected: No issues.

- [ ] **Step 3: Commit**

```bash
git add lib/src/backup/backup_providers.dart
git commit -m "feat: expose backup service provider"
```

---

## Task 4: AppRestarter root wrapper + global messenger

Owns the root `ProviderContainer` so a restore can deterministically close the old database, swap files, and reopen.

**Files:**
- Create: `lib/src/app_restarter.dart`
- Modify: `lib/main.dart`
- Modify: `lib/src/app.dart`

- [ ] **Step 1: Add a global scaffold messenger key to the app**

In `lib/src/app.dart`, add above the `StockmateApp` class:
```dart
/// Used to show snackbars after the provider tree is rebuilt (e.g. restore).
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
```
Then add `scaffoldMessengerKey: rootScaffoldMessengerKey,` to the `MaterialApp.router(...)` call (next to `title: 'EziTally',`).

- [ ] **Step 2: Create the AppRestarter**

Create `lib/src/app_restarter.dart`:
```dart
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
    await old.dispose();

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
```

- [ ] **Step 3: Use AppRestarter in main**

Replace `lib/main.dart` contents with:
```dart
import 'package:flutter/material.dart';

import 'src/app_restarter.dart';

void main() {
  runApp(const AppRestarter());
}
```

- [ ] **Step 4: Analyze**

Run: `flutter analyze lib/main.dart lib/src/app_restarter.dart lib/src/app.dart`
Expected: No issues.

- [ ] **Step 5: Confirm the app still boots in tests**

Run: `flutter test test/app_bootstrap_test.dart`
Expected: PASS. (This test pumps `StockmateApp` directly inside its own `ProviderScope`, so it is unaffected.)

- [ ] **Step 6: Commit**

```bash
git add lib/main.dart lib/src/app_restarter.dart lib/src/app.dart
git commit -m "feat: add AppRestarter to reopen database after restore"
```

---

## Task 5: DataBackupCard in Reports (TDD widget test)

**Files:**
- Create: `lib/src/backup/data_backup_card.dart`
- Modify: `lib/src/reports/reports_screen.dart`
- Test: `test/backup/data_backup_card_test.dart`

- [ ] **Step 1: Write the failing widget test**

Create `test/backup/data_backup_card_test.dart`:
```dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stockmate/src/backup/backup_providers.dart';
import 'package:stockmate/src/backup/backup_service.dart';
import 'package:stockmate/src/backup/data_backup_card.dart';

class _FakeBackupService implements BackupService {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<BackupValidation> validateBackup(File file) async =>
      const BackupValidation.valid();
}

void main() {
  testWidgets('restore asks for confirmation before applying', (tester) async {
    final fakeFile = File('${Directory.systemTemp.path}/fake-backup.sqlite');
    var pickCalled = false;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          backupServiceProvider.overrideWithValue(_FakeBackupService()),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: DataBackupCard(
              pickFile: () async {
                pickCalled = true;
                return fakeFile;
              },
              shareFile: (_) async {},
            ),
          ),
        ),
      ),
    );

    expect(find.text('Back up data'), findsOneWidget);
    expect(find.text('Restore from file'), findsOneWidget);

    await tester.tap(find.text('Restore from file'));
    await tester.pumpAndSettle();

    expect(pickCalled, isTrue);
    expect(find.text('Replace all current data?'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `flutter test test/backup/data_backup_card_test.dart`
Expected: FAIL — `data_backup_card.dart` / `DataBackupCard` undefined.

- [ ] **Step 3: Implement the card**

Create `lib/src/backup/data_backup_card.dart`:
```dart
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
```
Note on `share_plus` API: the code above targets `share_plus` v11+ (`SharePlus.instance.share(ShareParams(...))`). If `flutter pub add` resolved an older major (v7–v10), replace the body of `_defaultShare` with:
```dart
await Share.shareXFiles([XFile(file.path)], text: 'EziTally data backup');
```
Verify which API exists by opening the resolved package, and use the matching one.

- [ ] **Step 4: Run the widget test to verify it passes**

Run: `flutter test test/backup/data_backup_card_test.dart`
Expected: PASS.

- [ ] **Step 5: Add the card to the Reports screen (hidden on web)**

In `lib/src/reports/reports_screen.dart`, add these imports below the existing `package:flutter_riverpod` import at the top:
```dart
import 'package:flutter/foundation.dart' show kIsWeb;

import '../backup/data_backup_card.dart';
```

Then, in `_ReportsContent.build`, append the card to the end of the inner `Column`'s `children`. The Column currently ends like this (lines ~90-96):
```dart
                      ...summary.topProducts.map((product) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _TopProductTile(product: product),
                        );
                      }),
                  ],
```
Change it to:
```dart
                      ...summary.topProducts.map((product) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _TopProductTile(product: product),
                        );
                      }),
                    if (!kIsWeb) ...[
                      const SizedBox(height: 28),
                      const DataBackupCard(),
                    ],
                  ],
```

- [ ] **Step 6: Analyze + run reports tests**

Run: `flutter analyze lib/src/backup/data_backup_card.dart lib/src/reports/reports_screen.dart`
Expected: No issues.

Run: `flutter test test/reports/reports_screen_test.dart`
Expected: PASS (the card renders only its own buttons; existing report assertions are unaffected). If a test fails because more than one screen scrolls the card off-screen, no change is needed — the card is appended below existing content.

- [ ] **Step 7: Commit**

```bash
git add lib/src/backup/data_backup_card.dart lib/src/reports/reports_screen.dart test/backup/data_backup_card_test.dart
git commit -m "feat: add data backup card to reports screen"
```

---

## Task 6: Full verification

**Files:** none (verification only)

- [ ] **Step 1: Analyze the whole project**

Run: `flutter analyze`
Expected: "No issues found!"

- [ ] **Step 2: Run the whole test suite**

Run: `flutter test`
Expected: All tests pass — the full pre-existing suite plus the 3 new `backup_service_test.dart` cases and the 1 new `data_backup_card_test.dart` case.

- [ ] **Step 3: Manual device/simulator check (document results)**

On an iOS device or simulator:
1. Add a product and record a sale.
2. Reports -> Data Backup -> Back up data -> save the file via the share sheet (e.g. to Files).
3. Delete the product / record more sales.
4. Reports -> Restore from file -> pick the saved backup -> confirm.
5. Verify the app reopens and the data matches the backup point; confirm no `-wal`/`-shm`/`.bak` files linger next to `stockmate.sqlite`.

- [ ] **Step 4: Commit any doc updates** (if notes are added to the README about backups)

```bash
git add -A
git commit -m "docs: note backup/restore in readme"
```

---

## Self-review checklist (completed by plan author)

- Spec coverage: backup (Task 2 `createBackup` + Task 5 share), restore with validation/rollback (Task 2 `validateBackup`/`restoreBackup`), reopen without process restart (Task 4 `AppRestarter`), Reports entry hidden on web (Task 5), dependencies (Task 0), tests (Tasks 2 & 5). All covered.
- Type consistency: `BackupService`, `BackupValidation`, `BackupException`, `backupServiceProvider`, `AppRestarter.restoreFromFile`, `PickBackupFile`/`ShareBackupFile`, `rootScaffoldMessengerKey` are defined once and referenced consistently.
- Idempotent `AppDatabase.close()` (Task 1) makes the `restoreBackup` close + container-dispose close safe.
