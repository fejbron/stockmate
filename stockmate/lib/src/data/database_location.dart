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
