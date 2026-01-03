import 'package:isar/isar.dart';

part 'analytics_event.g.dart';

/// أنواع الأحداث المتعلقة بالتحليلات
enum AnalyticsEventType {
  /// بدء جلسة جديدة
  sessionStart,

  /// إنشاء فاتورة
  invoiceCreated,

  /// إضافة عميل
  customerAdded,

  /// عرض تقرير
  reportViewed,

  /// تغيير إعداد
  settingChanged,

  /// خطأ في النظام
  errorOccurred,

  /// ميزة مستخدمة
  featureUsed,
}

/// كيان يمثل حدث تحليلي محلي
@collection
class AnalyticsEvent {
  /// إنشاء حدث تحليلي
  AnalyticsEvent({
    required this.type,
    required this.timestamp,
    this.metadataJson,
  });

  /// المعرف التلقائي لـ Isar
  Id id = Isar.autoIncrement;

  /// نوع الحدث
  @enumerated
  final AnalyticsEventType type;

  /// وقت حدوث الحدث
  final DateTime timestamp;

  /// بيانات إضافية للحدث مخزنة كـ JSON string
  /// ملاحظة: Isar في هذا الإصدار لا يدعم Map بشكل أصلي، لذا سنخزنها كنص.
  final String? metadataJson;
}
