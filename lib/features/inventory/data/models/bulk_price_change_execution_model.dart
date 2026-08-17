import 'dart:convert';

import 'package:basir_accounting_system/features/inventory/domain/entities/bulk_price_change.dart';
import 'package:isar/isar.dart';

part 'bulk_price_change_execution_model.g.dart';

/// نموذج Isar لسجل تنفيذ تغيير الأسعار الجماعي.
///
/// يُحفظ سجل التنفيذ بصيغة JSON واحدة قابلة للفهرسة الزمنية لإتاحة
/// الإلغاء الزمني الموثق خلال نافذة الأربع وعشرين ساعة من لحظة
/// التنفيذ، مع كامل أثر التدقيق والقيم السابقة.
@collection
class BulkPriceChangeExecutionModel {
  /// إنشاء نموذج سجل تنفيذ.
  BulkPriceChangeExecutionModel();

  /// إنشاء نموذج من سجل التنفيذ الكياني.
  factory BulkPriceChangeExecutionModel.fromRecord(
    BulkChangeExecutionRecord record,
  ) =>
      BulkPriceChangeExecutionModel()
        ..id = record.id
        ..operatorName = record.operatorName
        ..executedAt = record.executedAt
        ..reason = record.reason
        ..recordJson = jsonEncode(record.toJson())
        ..effectiveAt = record.effectiveAt
        ..cancellationDeadline = record.cancellationDeadline
        ..cancelledAt = record.cancellation?.occurredAt
        ..createdAt = DateTime.now();

  /// معرّف Isar التلقائي.
  Id? isarId;

  /// المعرف الفريد لسجل التنفيذ.
  @Index(unique: true, replace: true)
  late String id;

  /// اسم منفذ العملية.
  @Index()
  late String operatorName;

  /// تاريخ التنفيذ.
  @Index()
  late DateTime executedAt;

  /// سبب التغيير الموثق.
  late String reason;

  /// سجل التنفيذ كاملًا بصيغة JSON (القاعدة، النطاق، القيم السابقة،
  /// أثر التدقيق، وإحداث الإلغاء).
  late String recordJson;

  /// تاريخ نفاذ القاعدة عند التحديد.
  DateTime? effectiveAt;

  /// نافذة الإلغاء (24 ساعة من التنفيذ افتراضيًا).
  @Index()
  late DateTime cancellationDeadline;

  /// زمن الإلغاء عند الاسترجاع داخل النافذة الزمنية.
  DateTime? cancelledAt;

  /// تاريخ إنشاء السجل في قاعدة البيانات.
  late DateTime createdAt;

  /// تحويل النموذج إلى كيان سجل التنفيذ.
  BulkChangeExecutionRecord toRecord() => BulkChangeExecutionRecord.fromJson(
        Map<String, dynamic>.from(jsonDecode(recordJson) as Map),
      );
}
