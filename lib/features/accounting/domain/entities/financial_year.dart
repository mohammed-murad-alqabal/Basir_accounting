import 'package:basir_app/core/models/sync_status.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'financial_year.freezed.dart';
part 'financial_year.g.dart';

/// تمثل السنة المالية وفتراتها المحاسبية.
@freezed
class FinancialYear with _$FinancialYear {
  /// إنشاء سنة مالية جديدة.
  const factory FinancialYear({
    /// معرف فريد للسنة.
    required String id,

    /// اسم السنة المالية (مثال: "السنة المالية 2024").
    required String name,

    /// تاريخ بداية السنة.
    required DateTime startDate,

    /// تاريخ نهاية السنة.
    required DateTime endDate,

    /// هل تم إغلاق السنة نهائياً؟
    @Default(false) bool isClosed,

    /// تاريخ الإغلاق.
    DateTime? closedAt,

    /// معرف المستخدم الذي قام بالإغلاق.
    String? closedBy,

    /// الفترات الشهرية المغلقة داخل هذه السنة.
    @Default([]) List<String> lockedPeriodIds,

    /// معرف المستخدم صاحب السنة (لعزل البيانات)
    String? userId,

    /// حالة المزامنة
    @Default(SyncStatus.synced) SyncStatus syncStatus,

    /// تاريخ آخر تحديث من السيرفر
    DateTime? serverUpdatedAt,

    /// هل السجل محذوف (حذف ناعم)
    @Default(false) bool isDeleted,
  }) = _FinancialYear;

  /// التحويل من JSON
  factory FinancialYear.fromJson(Map<String, dynamic> json) =>
      _$FinancialYearFromJson(json);
  const FinancialYear._();

  /// التحقق من أن تاريخ معين يقع ضمن هذه السنة المالية
  bool containsDate(DateTime date) =>
      (date.isAfter(startDate) || date.isAtSameMomentAs(startDate)) &&
      (date.isBefore(endDate) || date.isAtSameMomentAs(endDate));

  /// التحقق من صحة تواريخ السنة
  bool get isValid => endDate.isAfter(startDate);
}
