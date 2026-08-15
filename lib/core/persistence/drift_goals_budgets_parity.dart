import 'dart:convert';

import 'package:basir_accounting_system/core/persistence/drift_goals_budgets_migration.dart';
import 'package:basir_drift_storage/basir_drift_storage.dart';

class DriftGoalsBudgetsParityComparison {
  const DriftGoalsBudgetsParityComparison({
    required this.scope,
    required this.expectedCount,
    required this.actualCount,
    required this.expectedFingerprint,
    required this.actualFingerprint,
  });

  final String scope;
  final int expectedCount;
  final int actualCount;
  final String expectedFingerprint;
  final String actualFingerprint;

  bool get matches =>
      expectedCount == actualCount && expectedFingerprint == actualFingerprint;
}

class DriftGoalsBudgetsParityReport {
  const DriftGoalsBudgetsParityReport({
    required this.goals,
    required this.budgets,
    required this.ambiguousGoalScopes,
    required this.ambiguousBudgetScopes,
  });

  final DriftGoalsBudgetsParityComparison goals;
  final DriftGoalsBudgetsParityComparison budgets;
  final List<String> ambiguousGoalScopes;
  final List<String> ambiguousBudgetScopes;

  bool get isClean =>
      goals.matches &&
      budgets.matches &&
      ambiguousGoalScopes.isEmpty &&
      ambiguousBudgetScopes.isEmpty;
}

/// يقارن Isar وDrift بعد import Goals وBudgets دون حذف أو إصلاح تلقائي.
class DriftGoalsBudgetsParityVerifier {
  DriftGoalsBudgetsParityVerifier({
    required GoalMigrationReader goalSource,
    required BudgetMigrationReader budgetSource,
    required GoalStorage goalStorage,
    required BudgetStorage budgetStorage,
  })  : _goalSource = goalSource,
        _budgetSource = budgetSource,
        _goalStorage = goalStorage,
        _budgetStorage = budgetStorage;

  final GoalMigrationReader _goalSource;
  final BudgetMigrationReader _budgetSource;
  final GoalStorage _goalStorage;
  final BudgetStorage _budgetStorage;

  Future<DriftGoalsBudgetsParityReport> verify() async {
    final sourceGoals = await _goalSource();
    final sourceBudgets = await _budgetSource();
    final actualGoals = await _goalStorage.readAll();
    final actualBudgets = await _budgetStorage.readAll();

    return DriftGoalsBudgetsParityReport(
      goals: _comparison(
        scope: 'goals/all',
        expected: _sortGoals(sourceGoals).map(_canonicalGoal).toList(),
        actual: _sortGoals(actualGoals).map(_canonicalGoal).toList(),
      ),
      budgets: _comparison(
        scope: 'budgets/all',
        expected: _sortBudgets(sourceBudgets).map(_canonicalBudget).toList(),
        actual: _sortBudgets(actualBudgets).map(_canonicalBudget).toList(),
      ),
      ambiguousGoalScopes: _ambiguousScopes(
        sourceGoals.map((record) => record.userId),
      ),
      ambiguousBudgetScopes: _ambiguousScopes(
        sourceBudgets.map((record) => record.userId),
      ),
    );
  }

  static DriftGoalsBudgetsParityComparison _comparison({
    required String scope,
    required List<String> expected,
    required List<String> actual,
  }) =>
      DriftGoalsBudgetsParityComparison(
        scope: scope,
        expectedCount: expected.length,
        actualCount: actual.length,
        expectedFingerprint: _fingerprint(expected),
        actualFingerprint: _fingerprint(actual),
      );

  static List<GoalRecord> _sortGoals(List<GoalRecord> records) =>
      [...records]..sort(_compareGoals);

  static List<BudgetRecord> _sortBudgets(List<BudgetRecord> records) =>
      [...records]..sort(_compareBudgets);

  static List<String> _ambiguousScopes(Iterable<String?> userIds) {
    final counts = <String, int>{};
    for (final userId in userIds) {
      final scope = userScopeKey(userId);
      counts.update(scope, (count) => count + 1, ifAbsent: () => 1);
    }
    return counts.entries
        .where((entry) => entry.value > 1)
        .map((entry) => _fingerprint([entry.key]))
        .toList(growable: false)
      ..sort();
  }
}

String _canonicalGoal(GoalRecord record) => [
      record.id,
      record.name,
      record.category,
      record.targetAmount,
      record.currentAmount,
      record.startDate.toUtc().toIso8601String(),
      record.targetDate.toUtc().toIso8601String(),
      record.isActive.toString(),
      _nullable(record.description),
      _nullable(record.userId),
    ].join('\u0000');

String _canonicalBudget(BudgetRecord record) => [
      record.id,
      record.name,
      record.category,
      record.limitAmount,
      record.spentAmount,
      record.startDate.toUtc().toIso8601String(),
      record.endDate.toUtc().toIso8601String(),
      record.alertThreshold.toStringAsPrecision(17),
      record.isRollover.toString(),
      record.isActive.toString(),
      _nullable(record.userId),
    ].join('\u0000');

String _nullable(String? value) => value == null ? '\u0001' : '\u0002$value';

String _fingerprint(List<String> values) {
  var hash = 0x811c9dc5;
  for (final value in values) {
    for (final byte in utf8.encode(value)) {
      hash = ((hash * 31) + byte).toUnsigned(32);
    }
    hash = ((hash * 31) + 0xff).toUnsigned(32);
  }
  return hash.toRadixString(16).padLeft(8, '0');
}

int _compareGoals(GoalRecord left, GoalRecord right) {
  final scope = userScopeKey(left.userId).compareTo(userScopeKey(right.userId));
  if (scope != 0) return scope;
  return left.id.compareTo(right.id);
}

int _compareBudgets(BudgetRecord left, BudgetRecord right) {
  final scope = userScopeKey(left.userId).compareTo(userScopeKey(right.userId));
  if (scope != 0) return scope;
  return left.id.compareTo(right.id);
}
