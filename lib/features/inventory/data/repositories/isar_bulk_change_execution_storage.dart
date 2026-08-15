import 'dart:convert';

import 'package:basir_accounting_system/core/domain/contracts/audit_entry.dart';
import 'package:basir_accounting_system/features/inventory/application/bulk_price_change_service.dart';
import 'package:basir_accounting_system/features/inventory/domain/entities/bulk_price_change.dart';
import 'package:basir_accounting_system/features/inventory/data/models/bulk_price_change_execution_model.dart';
import 'package:isar/isar.dart';

/// تنفيذ تخزين سجلات تغيير الأسعار الجماعي عبر قاعدة Isar.
///
/// يحفظ كل سجل تنفيذ بشفرة JSON واحدة قابلة للفهرسة، ويوثق الإلغاء
/// الزماني عبر تحديث حقل الإلغاء على السجل الأصلي بدل إنشاء نسخة جديدة.
class IsarBulkChangeExecutionStorage implements BulkChangeExecutionStorage {
  /// يبني المخزن بمستودع Isar جاهز.
  IsarBulkChangeExecutionStorage({required Isar isar}) : _isar = isar;

  final Isar _isar;

  @override
  Future<BulkChangeExecutionRecord> save(
      BulkChangeExecutionRecord record) async {
    final model = BulkPriceChangeExecutionModel.fromRecord(record);
    await _isar.writeTxn(() async {
      await _isar.bulkPriceChangeExecutionModels.put(model);
    });
    return record;
  }

  @override
  Future<BulkChangeExecutionRecord?> fetch(String id) async {
    final model = await _isar.bulkPriceChangeExecutionModels
        .filter()
        .idEqualTo(id)
        .findFirst();
    return model?.toRecord();
  }

  @override
  Future<void> markCancelled(String id, AuditEntry cancellation) async {
    final model = await _isar.bulkPriceChangeExecutionModels
        .filter()
        .idEqualTo(id)
        .findFirst();
    if (model == null) return;

    final record = model.toRecord().copyWithCancellation(cancellation);
    model
      ..recordJson = _encodeRecord(record)
      ..cancelledAt = cancellation.occurredAt;
    await _isar.writeTxn(() async {
      await _isar.bulkPriceChangeExecutionModels.put(model);
    });
  }

  String _encodeRecord(BulkChangeExecutionRecord record) =>
      jsonEncode(record.toJson());
}

/// ملحق كيان سجل التنفيذ لتوثيق الإلغاء ضمن السلسلةية.
extension BulkChangeExecutionRecordCancellation
    on BulkChangeExecutionRecord {
  /// يبني نسخة من السجل تحمل حدث الإلغاء الموثق.
  BulkChangeExecutionRecord copyWithCancellation(
      AuditEntry cancellation) {
    return BulkChangeExecutionRecord(
      id: id,
      operatorName: operatorName,
      executedAt: executedAt,
      reason: reason,
      rule: rule,
      scopeItemIds: scopeItemIds,
      affectedItemIds: affectedItemIds,
      previousValues: previousValues,
      auditTrail: [
        ...auditTrail,
        cancellation,
      ],
      effectiveAt: effectiveAt,
      cancellationDeadline: cancellationDeadline,
      cancellation: cancellation,
    );
  }
}
