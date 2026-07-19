import 'package:basir_accounting_system/features/budget/domain/entities/budget.dart';
import 'package:basir_accounting_system/features/budget/domain/repositories/budget_repository.dart';
import 'package:decimal/decimal.dart';

/// خدمة إدارة الميزانيات الشخصية (PRD BUD-*)
class BudgetService {
  /// إنشاء خدمة ميزانية مع الحقن للمستودع
  BudgetService(this._budgetRepo);
  final BudgetRepository _budgetRepo;

  /// جلب كافة الميزانيات النشطة
  Future<List<Budget>> getActiveBudgets() async {
    final budgets = await _budgetRepo.getBudgets();
    return budgets.where((b) => b.isActive).toList();
  }

  /// جلب ميزانية محددة بالمعرف
  Future<Budget?> getBudget(String id) async => _budgetRepo.getBudget(id);

  /// حفظ أو إنشاء ميزانية جديدة
  Future<void> createOrUpdateBudget(Budget budget) async {
    await _budgetRepo.saveBudget(budget);
  }

  /// حذف ميزانية
  Future<void> deleteBudget(String id) async {
    await _budgetRepo.deleteBudget(id);
  }

  /// حساب المبلغ المتبقي في الميزانية
  Decimal getRemainingAmount(Budget budget) =>
      budget.limitAmount - budget.spentAmount;

  /// التحقق مما إذا كان الصرف قد تجاوز عتبة التنبيه (PRD BUD-003)
  bool isAlertTriggered(Budget budget) {
    if (budget.limitAmount == Decimal.zero) return false;
    final ratio = budget.spentAmount.toDouble() / budget.limitAmount.toDouble();
    return ratio >= budget.alertThreshold;
  }

  /// حساب النسبة المئوية للمصروف من الميزانية
  double getSpentPercentage(Budget budget) {
    if (budget.limitAmount == Decimal.zero) return 0;
    return (budget.spentAmount.toDouble() / budget.limitAmount.toDouble()) *
        100;
  }
}
