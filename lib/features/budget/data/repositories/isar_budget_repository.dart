import 'package:basir_accounting_system/features/budget/data/models/budget_model.dart';
import 'package:basir_accounting_system/features/budget/domain/entities/budget.dart';
import 'package:basir_accounting_system/features/budget/domain/repositories/budget_repository.dart';
import 'package:isar/isar.dart';

/// تطبيق Isar لمستودع الميزانية (PRD BUD-001)
class IsarBudgetRepository implements BudgetRepository {
  /// إنشاء مستودع ميزانية Isar مع دعم اختيار مستخدم معين
  IsarBudgetRepository(this._isar, {String? userId}) : _userId = userId;
  final Isar _isar;
  final String? _userId;

  @override
  Future<List<Budget>> getBudgets() async {
    final models = await _isar.budgetModels
        .filter()
        .optional(
          _userId != null,
          (q) => q.userIdEqualTo(_userId),
        )
        .findAll();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Budget?> getBudget(String id) async {
    final model =
        await _isar.budgetModels.filter().budgetIdEqualTo(id).findFirst();
    return model?.toEntity();
  }

  @override
  Future<void> saveBudget(Budget budget) async {
    final model = BudgetModel.fromEntity(budget);
    final existing = await _isar.budgetModels
        .filter()
        .budgetIdEqualTo(budget.id)
        .findFirst();
    if (existing != null) {
      model.id = existing.id;
    }
    await _isar.writeTxn(() => _isar.budgetModels.put(model));
  }

  @override
  Future<void> deleteBudget(String id) async {
    await _isar.writeTxn(
      () => _isar.budgetModels.filter().budgetIdEqualTo(id).deleteFirst(),
    );
  }
}
