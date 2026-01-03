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

    /// مركز التكلفة (اختياري) - (FR-ACC-011)
    String? costCenterId,
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

    /// تاريخ القيد
    required DateTime date,

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
