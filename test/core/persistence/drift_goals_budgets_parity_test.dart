import 'package:basir_accounting_system/core/persistence/drift_goals_budgets_parity.dart';
import 'package:basir_drift_storage/basir_drift_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('reports clean parity for matching Goals and Budgets', () async {
    final goals = [_goal(id: 'goal-a', userId: 'user-a')];
    final budgets = [_budget(id: 'budget-a', userId: 'user-a')];

    final report = await _verifier(
      goals: goals,
      budgets: budgets,
      goalStorage: _GoalStorage(goals),
      budgetStorage: _BudgetStorage(budgets),
    ).verify();

    expect(report.isClean, isTrue);
    expect(report.goals.matches, isTrue);
    expect(report.budgets.matches, isTrue);
  });

  test('detects an extra target record', () async {
    final goals = [_goal(id: 'goal-a', userId: 'user-a')];
    final report = await _verifier(
      goals: goals,
      budgets: const [],
      goalStorage: _GoalStorage([
        ...goals,
        _goal(id: 'stale-goal', userId: 'user-stale'),
      ]),
      budgetStorage: _BudgetStorage(),
    ).verify();

    expect(report.isClean, isFalse);
    expect(report.goals.expectedCount, 1);
    expect(report.goals.actualCount, 2);
  });

  test('blocks duplicate source scopes for both collections', () async {
    final goals = [
      _goal(id: 'goal-a1', userId: 'user-a'),
      _goal(id: 'goal-a2', userId: 'user-a'),
    ];
    final budgets = [
      _budget(id: 'budget-a1', userId: 'user-a'),
      _budget(id: 'budget-a2', userId: 'user-a'),
    ];
    final report = await _verifier(
      goals: goals,
      budgets: budgets,
      goalStorage: _GoalStorage([goals.last]),
      budgetStorage: _BudgetStorage([budgets.last]),
    ).verify();

    expect(report.isClean, isFalse);
    expect(report.ambiguousGoalScopes, hasLength(1));
    expect(report.ambiguousBudgetScopes, hasLength(1));
    expect(report.ambiguousGoalScopes.single, isNot('user-a'));
    expect(report.ambiguousBudgetScopes.single, isNot('user-a'));
  });
}

DriftGoalsBudgetsParityVerifier _verifier({
  required List<GoalRecord> goals,
  required List<BudgetRecord> budgets,
  required GoalStorage goalStorage,
  required BudgetStorage budgetStorage,
}) =>
    DriftGoalsBudgetsParityVerifier(
      goalSource: () async => goals,
      budgetSource: () async => budgets,
      goalStorage: goalStorage,
      budgetStorage: budgetStorage,
    );

class _GoalStorage implements GoalStorage {
  _GoalStorage([List<GoalRecord> records = const []])
      : records = List.of(records);

  final List<GoalRecord> records;

  @override
  Future<void> deleteById(String id, String? userId) async {}

  @override
  Future<List<GoalRecord>> readAll() async => List.of(records);

  @override
  Future<List<GoalRecord>> readAllForUser(String? userId) async =>
      records.where((record) => record.userId == userId).toList();

  @override
  Future<GoalRecord?> readById(String id, String? userId) async => null;

  @override
  Future<void> save(GoalRecord record) async {}

  @override
  Future<void> updateProgress(String id, String? userId, String amount) async {}
}

class _BudgetStorage implements BudgetStorage {
  _BudgetStorage([List<BudgetRecord> records = const []])
      : records = List.of(records);

  final List<BudgetRecord> records;

  @override
  Future<void> deleteById(String id, String? userId) async {}

  @override
  Future<List<BudgetRecord>> readAll() async => List.of(records);

  @override
  Future<List<BudgetRecord>> readAllForUser(String? userId) async =>
      records.where((record) => record.userId == userId).toList();

  @override
  Future<BudgetRecord?> readById(String id, String? userId) async => null;

  @override
  Future<void> save(BudgetRecord record) async {}
}

GoalRecord _goal({required String id, required String? userId}) => GoalRecord(
      id: id,
      name: 'Emergency fund',
      category: 'emergencyFund',
      targetAmount: '10.00',
      currentAmount: '1.25',
      startDate: DateTime.utc(2026),
      targetDate: DateTime.utc(2026, 12),
      isActive: true,
      description: null,
      userId: userId,
    );

BudgetRecord _budget({required String id, required String? userId}) =>
    BudgetRecord(
      id: id,
      name: 'Housing',
      category: 'housing',
      limitAmount: '100.000',
      spentAmount: '2.500',
      startDate: DateTime.utc(2026),
      endDate: DateTime.utc(2026, 1, 31),
      alertThreshold: 0.8,
      isRollover: false,
      isActive: true,
      userId: userId,
    );
