import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database_provider.dart';
import 'reports_repository.dart';

final reportsRepositoryProvider = Provider<ReportsRepository>((ref) {
  return ReportsRepository(ref.watch(databaseProvider));
});

final reportsSummaryProvider = StreamProvider.autoDispose<ReportsSummary>((
  ref,
) {
  return ref.watch(reportsRepositoryProvider).watchSummary();
});
