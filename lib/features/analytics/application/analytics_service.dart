import 'dart:async';
import 'dart:convert';

import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/analytics/domain/entities/analytics_event.dart';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'analytics_service.g.dart';

/// الخدمة المسؤولة عن تتبع التحليلات المحلية
class AnalyticsService {
  /// إنشاء خدمة التحليلات
  AnalyticsService(this._isar);

  final Isar _isar;

  /// حالة تفعيل التتبع
  bool isEnabled = true;

  /// تتبع حدث جديد
  Future<void> logEvent(
    AnalyticsEventType type, {
    Map<String, dynamic> metadata = const {},
  }) async {
    if (!isEnabled) return;

    final metadataJson = metadata.isNotEmpty ? jsonEncode(metadata) : null;

    final event = AnalyticsEvent(
      type: type,
      timestamp: DateTime.now(),
      metadataJson: metadataJson,
    );

    await _isar.writeTxn(() async {
      await _isar.analyticsEvents.put(event);
    });
  }

  /// الحصول على إجمالي عدد الأحداث لنوع معين
  Future<int> getEventCount(AnalyticsEventType type) async =>
      _isar.analyticsEvents.where().filter().typeEqualTo(type).count();

  /// الحصول على قائمة بأحدث الأحداث
  Future<List<AnalyticsEvent>> getRecentEvents({int limit = 10}) async =>
      _isar.analyticsEvents
          .where()
          .sortByTimestampDesc()
          .limit(limit)
          .findAll();

  /// حذف جميع بيانات التحليلات
  Future<void> clearAllData() async {
    await _isar.writeTxn(() async {
      await _isar.analyticsEvents.clear();
    });
  }

  /// حساب عدد الجلسات اليومية (مثال لمقياس نمو)
  Future<int> getDailyActiveUsersCount() async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);

    return _isar.analyticsEvents
        .where()
        .filter()
        .typeEqualTo(AnalyticsEventType.sessionStart)
        .and()
        .timestampGreaterThan(startOfDay)
        .count();
  }
}

/// المزود الخاص بخدمة التحليلات
@Riverpod(keepAlive: true)
AnalyticsService? analyticsService(AnalyticsServiceRef ref) {
  final isar = ref.watch(isarProvider).value;
  if (isar == null) return null;
  return AnalyticsService(isar);
}
