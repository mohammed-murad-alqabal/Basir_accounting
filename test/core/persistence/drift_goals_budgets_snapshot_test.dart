import 'package:basir_accounting_system/core/persistence/drift_goals_budgets_snapshot.dart';
import 'package:basir_drift_storage/basir_drift_storage.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('runs a clean Goals and Budgets snapshot in SQLite memory', () async {
    final snapshot = DriftGoalsBudgetsSnapshot.fromJson(_snapshotJson());

    final report = await DriftGoalsBudgetsSnapshotRunner().run(
      snapshot,
      batchSize: 1,
      databaseFactory: () => BasirDatabase(NativeDatabase.memory()),
    );

    expect(report.isClean, isTrue);
    expect(report.migration.goals.sourceCount, 1);
    expect(report.migration.budgets.sourceCount, 1);
    expect(report.migration.goals.migratedCount, 1);
    expect(report.migration.budgets.migratedCount, 1);
    expect(report.parity.goals.matches, isTrue);
    expect(report.parity.budgets.matches, isTrue);
    expect(report.parity.ambiguousGoalScopes, isEmpty);
    expect(report.parity.ambiguousBudgetScopes, isEmpty);
  });

  test('rejects snapshots that are not explicitly sanitized', () {
    final json = _snapshotJson()..['sanitized'] = false;

    expect(
      () => DriftGoalsBudgetsSnapshot.fromJson(json),
      throwsFormatException,
    );
  });

  test('rejects malformed Decimal fields before opening SQLite', () {
    final json = _snapshotJson();
    final goals = json['goals']! as List<Object?>;
    final firstGoal = goals.first! as Map<String, Object?>;
    goals[0] = {
      ...firstGoal,
      'targetAmount': 'not-a-decimal',
    };

    expect(
      () => DriftGoalsBudgetsSnapshot.fromJson(json),
      throwsFormatException,
    );
  });

  test('blocks clean acceptance when a user scope is ambiguous', () async {
    final json = _snapshotJson();
    final budgets = json['budgets']! as List<Object?>;
    final firstBudget = budgets.first! as Map<String, Object?>;
    budgets.add({
      ...firstBudget,
      'id': 'budget-b',
    });
    final snapshot = DriftGoalsBudgetsSnapshot.fromJson(json);

    final report = await DriftGoalsBudgetsSnapshotRunner().run(
      snapshot,
      databaseFactory: () => BasirDatabase(NativeDatabase.memory()),
    );

    expect(report.parity.budgets.matches, isTrue);
    expect(report.parity.ambiguousBudgetScopes, hasLength(1));
    expect(report.isClean, isFalse);
  });
}

Map<String, Object?> _snapshotJson() => {
      'sanitized': true,
      'schemaVersion': 1,
      'goals': <Object?>[
        <String, Object?>{
          'id': 'goal-a',
          'name': 'Emergency fund',
          'category': 'emergencyFund',
          'targetAmount': '100.00',
          'currentAmount': '12.50',
          'startDate': '2026-01-01T00:00:00Z',
          'targetDate': '2026-12-31T00:00:00Z',
          'isActive': true,
          'description': 'sanitized fixture',
          'userId': 'user-a',
        },
      ],
      'budgets': <Object?>[
        <String, Object?>{
          'id': 'budget-a',
          'name': 'Housing',
          'category': 'housing',
          'limitAmount': '1000.000',
          'spentAmount': '250.125',
          'startDate': '2026-01-01T00:00:00Z',
          'endDate': '2026-01-31T00:00:00Z',
          'alertThreshold': 0.8,
          'isRollover': false,
          'isActive': true,
          'userId': 'user-a',
        },
      ],
    };
