/// سجل حدث تدقيق موحد لنظام بصير المحاسبي.
///
/// يرافق كل وثيقة سجل تدقيق: من أنشأ، من عدّل، من اعتمد، متى، ولماذا.
/// المرجع: مخطط UI/UX التنفيذي — القسم 6 (حالات الوثائق والأثر المحاسبي).
library;

import 'package:basir_accounting_system/core/theme/tokens/app_colors.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// أنواع أحداث التدقيق المدعومة في السجل الزمني.
enum AuditEventType {
  /// إنشاء الوثيقة أو الكيان.
  created,

  /// تعديل البيانات قبل الترحيل.
  edited,

  /// اعتماد من صاحب صلاحية.
  approved,

  /// إرجاع للاعتماد من صاحب الصلاحية.
  returned,

  /// ترحيل نهائي بأثر مثبت.
  posted,

  /// إلغاء بسبب موثق.
  cancelled,

  /// عكس بوثيقة عكسية.
  reversed,

  /// حدث إداري عام (تغيير إعداد، تغيير سعر جماعي...).
  administrative;

  /// مسمّى نوع الحدث بالعربية.
  String get localizedLabel {
    switch (this) {
      case AuditEventType.created:
        return 'إنشاء';
      case AuditEventType.edited:
        return 'تعديل';
      case AuditEventType.approved:
        return 'اعتماد';
      case AuditEventType.returned:
        return 'إرجاع';
      case AuditEventType.posted:
        return 'ترحيل';
      case AuditEventType.cancelled:
        return 'إلغاء';
      case AuditEventType.reversed:
        return 'عكس';
      case AuditEventType.administrative:
        return 'إجراء إداري';
    }
  }

  /// مسمّى نوع الحدث وفق لغة سياق العرض الحالي.
  String localizedLabelOf(BuildContext context) {
    switch (this) {
      case AuditEventType.created:
        return AppLocalizations.of(context).workAuditEventCreated;
      case AuditEventType.edited:
        return AppLocalizations.of(context).workAuditEventModified;
      case AuditEventType.approved:
        return AppLocalizations.of(context).workAuditEventApproved;
      case AuditEventType.returned:
        return AppLocalizations.of(context).workAuditEventReturned;
      case AuditEventType.posted:
        return AppLocalizations.of(context).workAuditEventPosted;
      case AuditEventType.cancelled:
        return AppLocalizations.of(context).workAuditEventCancelled;
      case AuditEventType.reversed:
        return AppLocalizations.of(context).workAuditEventReversed;
      case AuditEventType.administrative:
        return AppLocalizations.of(context).workAuditEventAdministrative;
    }
  }

  /// اللون الدلالي لنوع الحدث داخل السجل الزمني.
  Color get semanticColor {
    switch (this) {
      case AuditEventType.created:
        return AppColors.info;
      case AuditEventType.edited:
        return AppColors.textSecondary;
      case AuditEventType.approved:
        return AppColors.success;
      case AuditEventType.returned:
        return AppColors.warning;
      case AuditEventType.posted:
        return AppColors.primary;
      case AuditEventType.cancelled:
        return AppColors.error;
      case AuditEventType.reversed:
        return AppColors.statusPending;
      case AuditEventType.administrative:
        return AppColors.textSecondary;
    }
  }

  /// الأيقونة المرافقة لنوع الحدث داخل السجل الزمني.
  IconData get icon {
    switch (this) {
      case AuditEventType.created:
        return Icons.add_circle;
      case AuditEventType.edited:
        return Icons.edit;
      case AuditEventType.approved:
        return Icons.check_circle;
      case AuditEventType.returned:
        return Icons.reply;
      case AuditEventType.posted:
        return Icons.receipt_long_outlined;
      case AuditEventType.cancelled:
        return Icons.cancel;
      case AuditEventType.reversed:
        return Icons.undo;
      case AuditEventType.administrative:
        return Icons.admin_panel_settings;
    }
  }
}

/// حدث تدقيق واحد: من، ماذا، متى، ولماذا.
@immutable
class AuditEntry {
  /// يبني حدث تدقيق إلزامي [operatorName] و[type] مع [occurredAt] وتفسير اختياري.
  const AuditEntry({
    required this.type,
    required this.operatorName,
    required this.occurredAt,
    this.reason,
    this.referenceId,
  });

  /// نوع الحدث (إنشاء/تعديل/اعتماد...).
  final AuditEventType type;

  /// اسم من نفّذ الحدث.
  final String operatorName;

  /// زمن وقوع الحدث.
  final DateTime occurredAt;

  /// التفسير الإلزامي للقرارات عالية الأثر (اعتماد، إلغاء، عكس...).
  final String? reason;

  /// معرّف الوثيقة المرتبطة عند الحاجة للرجوع (الوثيقة المعكوسة أو الملغية).
  final String? referenceId;

  @override
  String toString() =>
      'AuditEntry(${type.localizedLabel}: $operatorName @ $occurredAt)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuditEntry &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          operatorName == other.operatorName &&
          occurredAt == other.occurredAt &&
          reason == other.reason &&
          referenceId == other.referenceId;

  @override
  int get hashCode =>
      Object.hash(type, operatorName, occurredAt, reason, referenceId);
}
