import 'package:basir_app/core/models/sync_status.dart';
import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'journal_entry.freezed.dart';
part 'journal_entry.g.dart';

/// حالة القيد المحاسبي
enum JournalEntryStatus {
  /// مسودة - يمكن التعديل
  draft,

  /// مرحل - نهائي لا يمكن التعديل (FR-ACC-006)
  posted,

  /// ملغي - مع قيد عكسي
  voided,
}

/// تبرير التاريخ (Temporal Justification)
/// (CP-008: شمولية التبرير الزمني)
@freezed
class TemporalJustification with _$TemporalJustification {
  /// إنشاء تبرير زمني.
  const factory TemporalJustification({
    /// تاريخ العملية الفعلي (Transaction Date)
    required DateTime transactionDate,

    /// تاريخ الأثر المحاسبي (Effective Date)
    required DateTime effectiveDate,

    /// تاريخ التسجيل في النظام (Recording Date)
    required DateTime recordingDate,
  }) = _TemporalJustification;

  /// إنشاء من JSON.
  factory TemporalJustification.fromJson(Map<String, dynamic> json) =>
      _$TemporalJustificationFromJson(json);
}

/// تبرير المعايير (Standards Justification)
/// (CP-002: شمولية مرجعية المعايير)
@freezed
class StandardsJustification with _$StandardsJustification {
  /// إنشاء تبرير معايير.
  const factory StandardsJustification({
    /// مرجع المعيار (مثل IFRS 15.35)
    required String standardReference,

    /// أساس الاعتراف (Recognition Basis)
    String? recognitionBasis,

    /// أساس القياس (Measurement Basis)
    String? measurementBasis,
  }) = _StandardsJustification;

  /// إنشاء من JSON.
  factory StandardsJustification.fromJson(Map<String, dynamic> json) =>
      _$StandardsJustificationFromJson(json);
}

/// بند القيد المحاسبي (الطرف المدين أو الدائن)
@freezed
class JournalEntryLine with _$JournalEntryLine {
  /// إنشاء بند قيد محاسبي جديد.
  const factory JournalEntryLine({
    /// معرف الحساب (يربط مع Account)
    required String accountId,

    /// اسم الحساب (للعرض السريع)
    required String accountName,

    /// المبلغ المدين (Debit)
    required Decimal debit,

    /// المبلغ الدائن (Credit)
    required Decimal credit,

    /// الوصف الخاص بالبند
    String? description,

    /// مرجع المستند المصدر (Source Document Reference)
    /// (CP-009: شمولية التتبع)
    String? sourceDocumentRef,

    /// مركز التكلفة (اختياري) - (FR-ACC-011)
    String? costCenterId,

    /// العملة الأصلية (للمعاملات متعددة العملات)
    String? originalCurrency,

    /// سعر الصرف وقت العملية
    Decimal? exchangeRate,

    /// المبلغ بالعملة الأصلية
    Decimal? originalAmount,
  }) = _JournalEntryLine;

  /// إنشاء بند قيد من JSON
  factory JournalEntryLine.fromJson(Map<String, dynamic> json) =>
      _$JournalEntryLineFromJson(json);
}

/// القيد المحاسبي (Journal Entry)
/// (FR-ACC-001: القيود المحاسبية التلقائية)
/// (FR-ACC-008: مسار التدقيق شومل)
@freezed
class JournalEntry with _$JournalEntry {
  /// إنشاء قيد محاسبي جديد.
  const factory JournalEntry({
    /// معرف فريد للقيد
    required String id,

    /// رقم القيد المرجعي (مثال: JE-2024-001)
    required String referenceNumber,

    /// تاريخ القيد (للتوافق، يفضل استخدام temporalCheck)
    required DateTime date,

    /// التبرير الزمني الشامل (CP-008)
    required TemporalJustification temporal,

    /// التبرير المرجعي للمعايير (CP-002)
    required StandardsJustification standards,

    /// شرح القيد
    required String description,

    /// حالة القيد
    required JournalEntryStatus status,

    /// بنود القيد
    required List<JournalEntryLine> lines,

    /// المصدر (فاتورة مبيعات، سند قبض، قيد يدوي)
    /// يساعد في التتبع (Audit Trail)
    required String sourceDocument,
    required String sourceId,

    /// معرف المستخدم الذي أنشأ القيد
    required String createdBy,

    /// تاريخ الإنشاء
    required DateTime createdAt,

    /// تاريخ آخر تحديث
    required DateTime updatedAt,

    /// بصمة سلامة البيانات (Hash Trail)
    /// (CP-003: عدم القابلية للتعديل)
    String? hash,
    String? previousHash,

    /// تاريخ النشر (تاريخ الترحيل النهائي)
    DateTime? postedAt,

    /// معرف المستخدم لغرض عزل البيانات
    String? userId,

    /// حالة المزامنة
    @Default(SyncStatus.synced) SyncStatus syncStatus,

    /// تاريخ آخر تحديث من السيرفر
    DateTime? serverUpdatedAt,

    /// هل السجل محذوف (حذف ناعم)
    @Default(false) bool isDeleted,
  }) = _JournalEntry;

  /// إنشاء قيد من JSON
  factory JournalEntry.fromJson(Map<String, dynamic> json) =>
      _$JournalEntryFromJson(json);

  const JournalEntry._();

  /// إجمالي المدين
  Decimal get totalDebit =>
      lines.fold(Decimal.zero, (sum, line) => sum + line.debit);

  /// إجمالي الدائن
  Decimal get totalCredit =>
      lines.fold(Decimal.zero, (sum, line) => sum + line.credit);

  /// التحقق من توازن القيد (المدين = الدائن)
  /// (FR-ACC-002: ضمان توازن المعادلة المحاسبية)
  bool get isBalanced => totalDebit == totalCredit;
}
