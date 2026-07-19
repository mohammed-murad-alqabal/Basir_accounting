import 'package:basir_accounting_system/features/budget/domain/entities/budget.dart';

/// واجهة مستودع الميزانية (PRD BUD-001)
abstract class BudgetRepository {
  /// جلب كافة الميزانيات
  Future<List<Budget>> getBudgets();

  /// جلب ميزانية محددة بالمعرف
  Future<Budget?> getBudget(String id);

  /// حفظ أو تحديث ميزانية
  Future<void> saveBudget(Budget budget);

  /// حذف ميزانية
  Future<void> deleteBudget(String id);
}
