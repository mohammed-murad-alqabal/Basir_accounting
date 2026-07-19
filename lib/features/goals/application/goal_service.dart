import 'package:basir_accounting_system/features/goals/domain/entities/goal.dart';
import 'package:basir_accounting_system/features/goals/domain/repositories/goal_repository.dart';
import 'package:decimal/decimal.dart';

/// خدمة الأهداف المالية (Financial Goal Service)
/// (PRD GOL-002)
class GoalService {
  /// إنشاء خدمة الأهداف
  GoalService(this._repository);
  final GoalRepository _repository;

  /// الحصول على جميع الأهداف
  Future<List<Goal>> getActiveGoals() async {
    final all = await _repository.getAllGoals();
    return all.where((g) => g.isActive).toList();
  }

  /// إنشاء أو تحديث هدف
  Future<void> saveGoal(Goal goal) async {
    await _repository.saveGoal(goal);
  }

  /// حذف هدف
  Future<void> deleteGoal(String id) async {
    await _repository.deleteGoal(id);
  }

  /// إضافة تقدم في الهدف (مثلاً عند التوفير)
  Future<void> addProgress(String id, double amount) async {
    await _repository.updateGoalProgress(id, amount);
  }

  /// الحصول على المدخرات المطلوبة شهرياً لتحقيق الهدف في وقته
  Decimal getRequiredMonthlySavings(Goal goal) {
    if (goal.isAchieved) return Decimal.zero;

    final now = DateTime.now();
    if (goal.targetDate.isBefore(now)) return goal.remainingAmount;

    final monthsRemaining = (goal.targetDate.year - now.year) * 12 +
        (goal.targetDate.month - now.month);
    if (monthsRemaining <= 0) return goal.remainingAmount;

    return (goal.remainingAmount / Decimal.fromInt(monthsRemaining)).toDecimal(
      scaleOnInfinitePrecision: 2,
    );
  }
}
