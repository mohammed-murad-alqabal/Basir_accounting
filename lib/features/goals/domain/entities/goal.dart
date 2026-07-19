import 'package:basir_accounting_system/features/goals/domain/entities/goal_category.dart';
import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'goal.freezed.dart';

/// كينونة الهدف المالي (Financial Goal Entity)
/// (PRD GOL-001)
@freezed
class Goal with _$Goal {
  /// Creates a [Goal].
  const factory Goal({
    /// المعرف الفريد
    required String id,

    /// اسم الهدف
    required String name,

    /// تصنيف الهدف
    required GoalCategory category,

    /// المبلغ المستهدف
    required Decimal targetAmount,

    /// المبلغ الحالي
    required Decimal currentAmount,

    /// تاريخ البداية
    required DateTime startDate,

    /// تاريخ النهاية المستهدف
    required DateTime targetDate,

    /// حالة النشاط
    @Default(true) bool isActive,

    /// وصف اختياري
    String? description,

    /// معرف المستخدم
    String? userId,
  }) = _Goal;

  const Goal._();

  /// حساب نسبة الإنجاز
  double get progressPercentage {
    if (targetAmount == Decimal.zero) return 0;
    return (currentAmount.toDouble() / targetAmount.toDouble()) * 100;
  }

  /// هل تم تحقيق الهدف؟
  bool get isAchieved => currentAmount >= targetAmount;

  /// المبلغ المتبقي
  Decimal get remainingAmount => targetAmount - currentAmount;
}
