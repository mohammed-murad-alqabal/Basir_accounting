import 'package:basir_accounting_system/features/analytics/application/analytics_service.dart';
import 'package:basir_accounting_system/features/analytics/domain/entities/analytics_event.dart';

/// Mock implementation of AnalyticsService for testing
class MockAnalyticsService implements AnalyticsService {
  final List<AnalyticsEventType> loggedEvents = [];
  final List<Map<String, dynamic>> loggedMetadata = [];

  @override
  bool isEnabled = true;

  @override
  Future<void> logEvent(
    AnalyticsEventType event, {
    Map<String, dynamic>? metadata,
  }) async {
    loggedEvents.add(event);
    if (metadata != null) {
      loggedMetadata.add(metadata);
    }
  }

  @override
  Future<int> getEventCount(AnalyticsEventType type) async =>
      loggedEvents.where((e) => e == type).length;

  @override
  Future<List<AnalyticsEvent>> getRecentEvents({int limit = 10}) async => [];

  @override
  Future<void> clearAllData() async {
    loggedEvents.clear();
    loggedMetadata.clear();
  }

  @override
  Future<int> getDailyActiveUsersCount() async => 0;

  /// Clear logged events for testing
  void clearLogs() {
    loggedEvents.clear();
    loggedMetadata.clear();
  }
}
