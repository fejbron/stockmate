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
