import 'package:basir_accounting_system/core/persistence/drift_settings_shadow_read.dart';
import 'package:basir_accounting_system/features/budget/domain/entities/budget.dart';
import 'package:basir_accounting_system/features/budget/domain/repositories/budget_repository.dart';
import 'package:basir_accounting_system/features/goals/domain/entities/goal.dart';
import 'package:basir_accounting_system/features/goals/domain/repositories/goal_repository.dart';

/// Comparator تشخيصي لـGoals وBudgets؛ لا يغير نتيجة المصدر القديم.
class DriftGoalsBudgetsShadowReadComparator {
  DriftGoalsBudgetsShadowReadComparator({
    required DriftShadowReadRecorder recorder,
    DateTime Function()? clock,
  })  : _recorder = recorder,
        _clock = clock ?? DateTime.now;

  final DriftShadowReadRecorder _recorder;
  final DateTime Function() _clock;

  Future<DriftShadowReadResult> compareGoal({
    required String operation,
    required Future<Goal?> Function() sourceRead,
    required Future<Goal?> Function() candidateRead,
  }) =>
      _compare(
        slice: 'goals',
        operation: operation,
        sourceRead: sourceRead,
        candidateRead: candidateRead,
        equals: _goalsEqual,
      );

  Future<DriftShadowReadResult> compareGoals({
    required String operation,
    required Future<List<Goal>> Function() sourceRead,
    required Future<List<Goal>> Function() candidateRead,
  }) =>
      _compare(
        slice: 'goals',
        operation: operation,
        sourceRead: sourceRead,
        candidateRead: candidateRead,
        equals: _goalListsEqual,
      );

  Future<DriftShadowReadResult> compareBudget({
    required String operation,
    required Future<Budget?> Function() sourceRead,
    required Future<Budget?> Function() candidateRead,
  }) =>
      _compare(
        slice: 'budgets',
        operation: operation,
        sourceRead: sourceRead,
        candidateRead: candidateRead,
        equals: _budgetsEqual,
      );

  Future<DriftShadowReadResult> compareBudgets({
    required String operation,
    required Future<List<Budget>> Function() sourceRead,
    required Future<List<Budget>> Function() candidateRead,
  }) =>
      _compare(
        slice: 'budgets',
        operation: operation,
        sourceRead: sourceRead,
        candidateRead: candidateRead,
        equals: _budgetListsEqual,
      );

  Future<DriftShadowReadResult> _compare<T>({
    required String slice,
    required String operation,
    required Future<T?> Function() sourceRead,
    required Future<T?> Function() candidateRead,
    required bool Function(T source, T candidate) equals,
  }) async {
    late final T? source;
    try {
      source = await sourceRead();
    } on Object {
      return _record(
        slice: slice,
        operation: operation,
        outcome: DriftShadowReadOutcome.sourceError,
      );
    }

    late final T? candidate;
    try {
      candidate = await candidateRead();
    } on Object {
      return _record(
        slice: slice,
        operation: operation,
        outcome: DriftShadowReadOutcome.candidateError,
      );
    }

    final matches = source == null || candidate == null
        ? source == null && candidate == null
        : equals(source, candidate);
    return _record(
      slice: slice,
      operation: operation,
      outcome: matches
          ? DriftShadowReadOutcome.match
          : DriftShadowReadOutcome.mismatch,
    );
  }

  Future<DriftShadowReadResult> _record({
    required String slice,
    required String operation,
    required DriftShadowReadOutcome outcome,
  }) async {
    final recordedAt = _clock().toUtc();
    await _recorder(
      DriftShadowReadEvent(
        slice: slice,
        operation: operation,
        outcome: outcome,
        recordedAt: recordedAt,
      ),
    );
    return DriftShadowReadResult(outcome: outcome, recordedAt: recordedAt);
  }
}

/// Decorator قراءة Goals؛ يعيد Isar دائمًا ويستعمل Drift تشخيصيًا فقط.
class ShadowReadGoalRepository implements GoalRepository {
  ShadowReadGoalRepository({
    required GoalRepository source,
    required GoalRepository candidate,
    required DriftGoalsBudgetsShadowReadComparator comparator,
    required bool enabled,
  })  : _source = source,
        _candidate = candidate,
        _comparator = comparator,
        _enabled = enabled;

  final GoalRepository _source;
  final GoalRepository _candidate;
  final DriftGoalsBudgetsShadowReadComparator _comparator;
  final bool _enabled;

  @override
  Future<List<Goal>> getAllGoals({String? userId}) async {
    final sourceValue = await _source.getAllGoals(userId: userId);
    if (_enabled) {
      await _comparator.compareGoals(
        operation: 'getAllGoals',
        sourceRead: () async => sourceValue,
        candidateRead: () => _candidate.getAllGoals(userId: userId),
      );
    }
    return sourceValue;
  }

  @override
  Future<Goal?> getGoalById(String id) async {
    final sourceValue = await _source.getGoalById(id);
    if (_enabled) {
      await _comparator.compareGoal(
        operation: 'getGoalById',
        sourceRead: () async => sourceValue,
        candidateRead: () => _candidate.getGoalById(id),
      );
    }
    return sourceValue;
  }

  @override
  Future<void> saveGoal(Goal goal) => _source.saveGoal(goal);

  @override
  Future<void> deleteGoal(String id) => _source.deleteGoal(id);

  @override
  Future<void> updateGoalProgress(String id, double amount) =>
      _source.updateGoalProgress(id, amount);
}

/// Decorator قراءة Budgets؛ يعيد Isar دائمًا ويستعمل Drift تشخيصيًا فقط.
class ShadowReadBudgetRepository implements BudgetRepository {
  ShadowReadBudgetRepository({
    required BudgetRepository source,
    required BudgetRepository candidate,
    required DriftGoalsBudgetsShadowReadComparator comparator,
    required bool enabled,
  })  : _source = source,
        _candidate = candidate,
        _comparator = comparator,
        _enabled = enabled;

  final BudgetRepository _source;
  final BudgetRepository _candidate;
  final DriftGoalsBudgetsShadowReadComparator _comparator;
  final bool _enabled;

  @override
  Future<List<Budget>> getBudgets() async {
    final sourceValue = await _source.getBudgets();
    if (_enabled) {
      await _comparator.compareBudgets(
        operation: 'getBudgets',
        sourceRead: () async => sourceValue,
        candidateRead: _candidate.getBudgets,
      );
    }
    return sourceValue;
  }

  @override
  Future<Budget?> getBudget(String id) async {
    final sourceValue = await _source.getBudget(id);
    if (_enabled) {
      await _comparator.compareBudget(
        operation: 'getBudget',
        sourceRead: () async => sourceValue,
        candidateRead: () => _candidate.getBudget(id),
      );
    }
    return sourceValue;
  }

  @override
  Future<void> saveBudget(Budget budget) => _source.saveBudget(budget);

  @override
  Future<void> deleteBudget(String id) => _source.deleteBudget(id);
}

bool _goalListsEqual(List<Goal> left, List<Goal> right) =>
    left.length == right.length &&
    left
        .asMap()
        .entries
        .every((entry) => _goalsEqual(entry.value, right[entry.key]));

bool _budgetListsEqual(List<Budget> left, List<Budget> right) =>
    left.length == right.length &&
    left
        .asMap()
        .entries
        .every((entry) => _budgetsEqual(entry.value, right[entry.key]));

bool _goalsEqual(Goal left, Goal right) =>
    left.id == right.id &&
    left.name == right.name &&
    left.category == right.category &&
    left.targetAmount == right.targetAmount &&
    left.currentAmount == right.currentAmount &&
    left.startDate.toUtc() == right.startDate.toUtc() &&
    left.targetDate.toUtc() == right.targetDate.toUtc() &&
    left.isActive == right.isActive &&
    left.description == right.description &&
    left.userId == right.userId;

bool _budgetsEqual(Budget left, Budget right) =>
    left.id == right.id &&
    left.name == right.name &&
    left.category == right.category &&
    left.limitAmount == right.limitAmount &&
    left.spentAmount == right.spentAmount &&
    left.startDate.toUtc() == right.startDate.toUtc() &&
    left.endDate.toUtc() == right.endDate.toUtc() &&
    left.alertThreshold == right.alertThreshold &&
    left.isRollover == right.isRollover &&
    left.isActive == right.isActive &&
    left.userId == right.userId;
