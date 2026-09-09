import 'package:basir_accounting_system/core/persistence/drift_goals_budgets_shadow_read.dart';
import 'package:basir_accounting_system/core/persistence/drift_providers.dart';
import 'package:basir_accounting_system/core/persistence/drift_settings_shadow_read.dart';
import 'package:basir_accounting_system/features/budget/domain/entities/budget.dart';
import 'package:basir_accounting_system/features/budget/domain/entities/budget_category.dart';
import 'package:basir_accounting_system/features/budget/domain/repositories/budget_repository.dart';
import 'package:basir_accounting_system/features/goals/domain/entities/goal.dart';
import 'package:basir_accounting_system/features/goals/domain/entities/goal_category.dart';
import 'package:basir_accounting_system/features/goals/domain/repositories/goal_repository.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('records Goal match and Budget mismatch without payload', () async {
    final sink = InMemoryDriftShadowReadSink();
    final comparator = DriftGoalsBudgetsShadowReadComparator(
      recorder: sink.record,
      clock: () => DateTime.utc(2026, 8, 15),
    );
    final goal = _goal();

    final goalResult = await comparator.compareGoal(
      operation: 'getGoalById',
      sourceRead: () async => goal,
      candidateRead: () async => goal,
    );
    final budgetResult = await comparator.compareBudget(
      operation: 'getBudget',
      sourceRead: () async => _budget,
      candidateRead: () async =>
          _budget.copyWith(spentAmount: Decimal.parse('4')),
    );

    expect(goalResult.outcome, DriftShadowReadOutcome.match);
    expect(budgetResult.outcome, DriftShadowReadOutcome.mismatch);
    expect(sink.events, hasLength(2));
    expect(sink.events.every((event) => event.slice != 'user-a'), isTrue);
  });

  test('records list parity for Goals and Budgets', () async {
    final sink = InMemoryDriftShadowReadSink();
    final comparator =
        DriftGoalsBudgetsShadowReadComparator(recorder: sink.record);

    await comparator.compareGoals(
      operation: 'getAllGoals',
      sourceRead: () async => [_goal()],
      candidateRead: () async => [_goal()],
    );
    await comparator.compareBudgets(
      operation: 'getBudgets',
      sourceRead: () async => [_budget],
      candidateRead: () async => [_budget],
    );

    expect(
      sink.events.map((event) => event.operation),
      containsAll(<String>['getAllGoals', 'getBudgets']),
    );
    expect(
      sink.events
          .every((event) => event.outcome == DriftShadowReadOutcome.match),
      isTrue,
    );
  });

  test('flags are closed and rollout remains Isar-primary by default', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(container.read(driftGoalsShadowReadEnabledProvider), isFalse);
    expect(container.read(driftBudgetsShadowReadEnabledProvider), isFalse);
    expect(
      container.read(driftRolloutStageProvider),
      DriftRolloutStage.isarPrimary,
    );
  });

  test('disabled Goal decorator never calls candidate and delegates writes',
      () async {
    final source = _GoalRepository(value: _goal());
    final candidate = _GoalRepository(throwOnRead: true);
    final sink = InMemoryDriftShadowReadSink();
    final repository = ShadowReadGoalRepository(
      source: source,
      candidate: candidate,
      comparator: DriftGoalsBudgetsShadowReadComparator(recorder: sink.record),
      enabled: false,
    );

    expect(await repository.getGoalById('goal-a'), _goal());
    await repository.saveGoal(_goal());

    expect(candidate.readCount, 0);
    expect(source.saveCount, 1);
    expect(sink.events, isEmpty);
  });

  test('enabled Budget decorator returns Isar value and records mismatch',
      () async {
    final source = _BudgetRepository(value: _budget);
    final candidate = _BudgetRepository(
      value: _budget.copyWith(spentAmount: Decimal.parse('4')),
    );
    final sink = InMemoryDriftShadowReadSink();
    final repository = ShadowReadBudgetRepository(
      source: source,
      candidate: candidate,
      comparator: DriftGoalsBudgetsShadowReadComparator(recorder: sink.record),
      enabled: true,
    );

    expect(await repository.getBudget('budget-a'), _budget);
    expect(sink.events.single.outcome, DriftShadowReadOutcome.mismatch);
    expect(source.saveCount, 0);
  });
}

Goal _goal() => Goal(
      id: 'goal-a',
      name: 'Emergency fund',
      category: GoalCategory.emergencyFund,
      targetAmount: Decimal.parse('10.00'),
      currentAmount: Decimal.parse('1.25'),
      startDate: DateTime.utc(2026),
      targetDate: DateTime.utc(2026, 12),
      userId: 'user-a',
    );

Budget _budget = Budget(
  id: 'budget-a',
  name: 'Housing',
  category: BudgetCategory.housing,
  limitAmount: Decimal.parse('100.000'),
  startDate: DateTime.utc(2026),
  endDate: DateTime.utc(2026, 1, 31),
  spentAmount: Decimal.parse('2.500'),
  userId: 'user-a',
);

class _GoalRepository implements GoalRepository {
  _GoalRepository({this.value, this.throwOnRead = false});

  final Goal? value;
  final bool throwOnRead;
  int readCount = 0;
  int saveCount = 0;

  @override
  Future<void> deleteGoal(String id) async {}

  @override
  Future<List<Goal>> getAllGoals({String? userId}) async {
    if (throwOnRead) throw StateError('candidate read');
    return value == null ? const [] : [value!];
  }

  @override
  Future<Goal?> getGoalById(String id) async {
    readCount += 1;
    if (throwOnRead) throw StateError('candidate read');
    return value;
  }

  @override
  Future<void> saveGoal(Goal goal) async {
    saveCount += 1;
  }

  @override
  Future<void> updateGoalProgress(String id, double amount) async {}
}

class _BudgetRepository implements BudgetRepository {
  _BudgetRepository({required this.value});

  final Budget? value;
  int saveCount = 0;

  @override
  Future<void> deleteBudget(String id) async {}

  @override
  Future<Budget?> getBudget(String id) async => value;

  @override
  Future<List<Budget>> getBudgets() async =>
      value == null ? const [] : [value!];

  @override
  Future<void> saveBudget(Budget budget) async {
    saveCount += 1;
  }
}
