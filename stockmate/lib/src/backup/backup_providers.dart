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
