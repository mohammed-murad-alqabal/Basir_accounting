library;

import 'package:flutter/foundation.dart';
/// معاينة أثر ترحيل الوثيقة قبل التنفيذ الفعلي.
///
/// تعرض الملخصَ المحاسبي والمخزني للترحيل القادم دون تطبيقه؛
/// تُستخدم في لوحة الملخص/الاعتماد لعرض ما سيحدث بعد التأكيد.
/// المرجع: مخطط UI/UX التنفيذي — القسم 8 (ملخص قبل الترحيل) + العقود الموحدة.

import 'package:basir_accounting_system/core/domain/contracts/audit_entry.dart';

/// نوع الأثر المحاسبي/المخزني لحركة واحدة في المعاينة.
enum PostingImpactKind {
  /// قيد بدفتر الأستاذ.
  ledgerEntry,

  /// تعديل مخزون صنف.
  inventoryMovement,

  /// تعديل رصيد عميل/مورّد.
  partnerBalance,

  /// أثر ضريبي (ذمم الضريبة).
  taxLiability;

  /// مسمّى نوع الأثر بالعربية.
  String get localizedLabel {
    switch (this) {
      case PostingImpactKind.ledgerEntry:
        return 'قيد دفتر';
      case PostingImpactKind.inventoryMovement:
        return 'حركة مخزون';
      case PostingImpactKind.partnerBalance:
        return 'رصيد طرف';
      case PostingImpactKind.taxLiability:
        return 'ذمة ضريبية';
    }
  }
}

/// اتجاه الحركة في معاينة الأثر.
enum PostingDirection {
  /// إضافة/مدين.
  debit,

  /// طرح/دائن.
  credit,

  /// أثر عكسي معلن (إلغاء/عكس).
  reversal;

  /// مسمّى الاتجاه بالعربية.
  String get localizedLabel {
    switch (this) {
      case PostingDirection.debit:
        return 'مدين';
      case PostingDirection.credit:
        return 'دائن';
      case PostingDirection.reversal:
        return 'عكسي';
    }
  }
}

/// حركة أثر واحدة داخل معاينة الترحيل.
@immutable
class PostingImpactLine {
  /// يبني حركة بإلزامية النوع والاتجاه والوصف والمبلغ.
  const PostingImpactLine({
    required this.kind,
    required this.direction,
    required this.description,
    required this.amount,
    this.currencyCode = 'SAR',
  });

  /// نوع الأثر (قيد/مخزون/رصيد/ضريبي).
  final PostingImpactKind kind;

  /// اتجاه الحركة (مدين/دائن/عكسي).
  final PostingDirection direction;

  /// وصف الحركة (الحساب أو الصنف المتأثر).
  final String description;

  /// قيمة الأثر.
  final double amount;

  /// رمز العملة.
  final String currencyCode;

  @override
  String toString() =>
      'PostingImpactLine(${kind.localizedLabel} $direction: $description = $amount)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostingImpactLine &&
          runtimeType == other.runtimeType &&
          kind == other.kind &&
          direction == other.direction &&
          description == other.description &&
          amount == other.amount &&
          currencyCode == other.currencyCode;

  @override
  int get hashCode =>
      Object.hash(kind, direction, description, amount, currencyCode);
}

/// معاينة أثر الترحيل الكاملة قبل التنفيذ.
///
/// تتضمن ملخص الأثر (مدين/دائن)، الحركات التفصيلية، والقيود المحيطة
/// (تحتاج اعتمادًا إضافيًا/سياسة). لا يجري الترحيل إلا بعد عرض هذه
/// المعاينة للمستخدم والتأكيد الصريح منه.
@immutable
class PostingPreview {
  /// يبني معاينة بإلزامية معرّف الوثيقة وخطوط الأثر.
  const PostingPreview({
    required this.documentId,
    required this.lines,
    this.requiresAdditionalApproval = false,
    this.approvalReason,
    this.scheduledAt,
    this.notes,
  });

  /// معرّف الوثيقة موضوع الترحيل.
  final String documentId;

  /// الحركات التفصيلية المتوقعة على الدفاتر والمخزون والأرصدة.
  final List<PostingImpactLine> lines;

  /// هل يتطلب هذا الترحيل اعتمادًا إضافيًا من صاحب صلاحية أعلى؟
  final bool requiresAdditionalApproval;

  /// سبب طلب الاعتماد الإضافي (إن وُجد).
  final String? approvalReason;

  /// زمن الترحيل الجدولي إن كان مقررًا لاحقًا (فارغ = فوري).
  final DateTime? scheduledAt;

  /// ملاحظات المعاينة.
  final String? notes;

  /// مجموع الأثر المدين (الحركات الموجبة).
  double get totalDebit => lines
      .where((line) => line.direction != PostingDirection.reversal)
      .fold<double>(0, (total, line) => total + line.amount);

  /// مجموع الأثر العكسي (حركات الإلغاء والعكس).
  double get totalReversal => lines
      .where((line) => line.direction == PostingDirection.reversal)
      .fold<double>(0, (total, line) => total + line.amount);

  /// هل الترحيل فوري دون جدولة؟
  bool get isImmediate => scheduledAt == null;

  /// ينشئ حدث اعتماد تدقيقيًا مرفقًا بهذه المعاينة عند التنفيذ.
  AuditEntry buildApprovalEvent({
    required String approverName,
    required String reason,
    DateTime? occurredAt,
  }) =>
      AuditEntry(
        type: AuditEventType.approved,
        operatorName: approverName,
        occurredAt: occurredAt ?? DateTime.now(),
        reason: reason,
        referenceId: documentId,
      );

  @override
  String toString() =>
      'PostingPreview($documentId: ${lines.length} lines, immediate: $isImmediate)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostingPreview &&
          runtimeType == other.runtimeType &&
          documentId == other.documentId &&
          lines.length == other.lines.length &&
          requiresAdditionalApproval == other.requiresAdditionalApproval;

  @override
  int get hashCode =>
      Object.hash(documentId, lines.length, requiresAdditionalApproval);
}
