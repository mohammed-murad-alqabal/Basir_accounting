import 'package:basir_accounting_system/features/budget/domain/entities/budget_category.dart';
import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'budget.freezed.dart';
part 'budget.g.dart';

/// تمثيل الميزانية الشخصية في النظام (PRD BUD-*)
@freezed
class Budget with _$Budget {
  /// إنشاء ميزانية جديدة
  const factory Budget({
    /// المعرف الفريد للميزانية
    required String id,

    /// اسم الميزانية (مثلاً: "ميزانية يناير")
    required String name,

    /// التصنيف المخصص لهذه الميزانية
    required BudgetCategory category,

    /// الحد الأقصى للميزانية (Decimal لدقة عالية)
    required Decimal limitAmount,

    /// تاريخ البدء
    required DateTime startDate,

    /// تاريخ الانتهاء
    required DateTime endDate,

    /// المبلغ المصروف فعلياً
    required Decimal spentAmount,

    /// عتبة التنبيه (مثلاً 0.8 تعني 80%)
    @Default(0.8) double alertThreshold,

    /// هل يتم ترحيل الفائض للشهر التالي (Rollover)
    @Default(false) bool isRollover,

    /// حالة تفعيل الميزانية
    @Default(true) bool isActive,

    /// معرف المستخدم صاحب الميزانية
    String? userId,
  }) = _Budget;

  /// التحويل من JSON
  factory Budget.fromJson(Map<String, dynamic> json) => _$BudgetFromJson(json);
}
