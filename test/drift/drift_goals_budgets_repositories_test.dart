import 'package:basir_accounting_system/features/budget/data/repositories/drift_budget_repository.dart';
import 'package:basir_accounting_system/features/budget/domain/entities/budget.dart';
import 'package:basir_accounting_system/features/budget/domain/entities/budget_category.dart';
import 'package:basir_accounting_system/features/goals/data/repositories/drift_goal_repository.dart';
import 'package:basir_accounting_system/features/goals/domain/entities/goal.dart';
import 'package:basir_accounting_system/features/goals/domain/entities/goal_category.dart';
import 'package:basir_drift_storage/basir_drift_storage.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Goal adapter forces user scope and preserves Decimal progress',
      () async {
    final storage = _GoalStorage();
    final repository = DriftGoalRepository.withStorage(
      storage,
      userId: 'user-a',
    );

    await repository.saveGoal(
      Goal(
        id: 'goal-a',
        name: 'Emergency fund',
        category: GoalCategory.emergencyFund,
        targetAmount: Decimal.parse('10.00'),
        currentAmount: Decimal.parse('1.25'),
        startDate: DateTime.utc(2026),
        targetDate: DateTime.utc(2026, 12),
        userId: 'wrong-user',
      ),
    );
    await repository.updateGoalProgress('goal-a', 0.1);

    final goals = await repository.getAllGoals();

    expect(storage.saved.single.userId, 'user-a');
    expect(storage.progressUpdates, ['goal-a:user-a:0.1']);
    expect(goals.single.category, GoalCategory.emergencyFund);
    expect(goals.single.currentAmount, Decimal.parse('1.25'));
  });

  test('Budget adapter forces scope and maps decimal/category fields',
      () async {
    final storage = _BudgetStorage();
    final repository = DriftBudgetRepository.withStorage(
      storage,
      userId: 'user-a',
    );

    await repository.saveBudget(
      Budget(
        id: 'budget-a',
        name: 'Housing',
        category: BudgetCategory.housing,
        limitAmount: Decimal.parse('100.000'),
        spentAmount: Decimal.parse('3.750'),
        startDate: DateTime.utc(2026),
        endDate: DateTime.utc(2026, 1, 31),
        userId: 'wrong-user',
      ),
    );

    final budget = await repository.getBudget('budget-a');

    expect(storage.saved.single.userId, 'user-a');
    expect(budget?.category, BudgetCategory.housing);
    expect(budget?.limitAmount, Decimal.parse('100.000'));
    expect(budget?.spentAmount, Decimal.parse('3.750'));
  });
}

class _GoalStorage implements GoalStorage {
  final saved = <GoalRecord>[];
  final progressUpdates = <String>[];

  @override
  Future<void> deleteById(String id, String? userId) async {}

  @override
  Future<List<GoalRecord>> readAllForUser(String? userId) async =>
      saved.where((record) => record.userId == userId).toList(growable: false);

  @override
  Future<GoalRecord?> readById(String id, String? userId) async => saved
      .where((record) => record.id == id && record.userId == userId)
      .firstOrNull;

  @override
  Future<void> save(GoalRecord record) async {
    saved.removeWhere(
      (existing) =>
          existing.id == record.id && existing.userId == record.userId,
    );
    saved.add(record);
  }

  @override
  Future<void> updateProgress(String id, String? userId, String amount) async {
    progressUpdates.add('$id:$userId:$amount');
  }
}

class _BudgetStorage implements BudgetStorage {
  final saved = <BudgetRecord>[];

  @override
  Future<void> deleteById(String id, String? userId) async {}

  @override
  Future<List<BudgetRecord>> readAllForUser(String? userId) async =>
      saved.where((record) => record.userId == userId).toList(growable: false);

  @override
  Future<BudgetRecord?> readById(String id, String? userId) async => saved
      .where((record) => record.id == id && record.userId == userId)
      .firstOrNull;

  @override
  Future<void> save(BudgetRecord record) async {
    saved.removeWhere(
      (existing) =>
          existing.id == record.id && existing.userId == record.userId,
    );
    saved.add(record);
  }
}
