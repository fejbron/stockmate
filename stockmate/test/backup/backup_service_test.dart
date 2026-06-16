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

  test('restoreBackup rejects an invalid file without modifying the db',
      () async {
    await db
        .into(db.products)
        .insert(ProductsCompanion.insert(name: 'Milk', sellingPriceMinor: 500));
    final junk = File(p.join(tempDir.path, 'not-a-backup.txt'));
    await junk.writeAsString('nope');

    await expectLater(
      service.restoreBackup(junk),
      throwsA(isA<BackupException>()),
    );

    // db must be untouched and still usable (not closed by a failed restore).
    final names = (await db.select(db.products).get())
        .map((row) => row.name)
        .toList();
    expect(names, ['Milk']);
    expect(File('${dbFile.path}.bak').existsSync(), isFalse);
  });
}
