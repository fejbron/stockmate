import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database_provider.dart';
import 'dashboard_repository.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepository(ref.watch(databaseProvider));
});

final dashboardMetricsProvider = StreamProvider.autoDispose<DashboardMetrics>((
  ref,
) {
  return ref.watch(dashboardRepositoryProvider).watchMetrics();
});
