import 'package:basir_accounting_system/core/persistence/drift_goals_budgets_migration.dart';
import 'package:basir_drift_storage/basir_drift_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('migrates Goals and Budgets in batches and is safe to rerun', () async {
    final goals = _GoalStorage();
    final budgets = _BudgetStorage();
    final checkpoints = _CheckpointStorage();
    final migrator = DriftGoalsBudgetsMigrator(
      goalSource: () async => [
        _goal(id: 'goal-b', userId: 'user-b'),
        _goal(id: 'goal-a', userId: 'user-a'),
      ],
      budgetSource: () async => [
        _budget(id: 'budget-b', userId: 'user-b'),
        _budget(id: 'budget-a', userId: 'user-a'),
      ],
      goalStorage: goals,
      budgetStorage: budgets,
      checkpoints: checkpoints,
    );

    final first = await migrator.migrate(batchSize: 1);
    final second = await migrator.migrate(batchSize: 1);

    expect(first.isComplete, isTrue);
    expect(second.isComplete, isTrue);
    expect(goals.records, hasLength(2));
    expect(budgets.records, hasLength(2));
    expect(goals.records[userScopeKey('user-a')]?.currentAmount, '1.25');
    expect(budgets.records[userScopeKey('user-b')]?.spentAmount, '2.500');
    expect(
      checkpoints.records[DriftGoalsBudgetsMigrationSlice.goals]?.isComplete,
      isTrue,
    );
    expect(
      checkpoints.records[DriftGoalsBudgetsMigrationSlice.budgets]?.isComplete,
      isTrue,
    );
  });

  test('rejects a non-positive batch size', () async {
    final migrator = DriftGoalsBudgetsMigrator(
      goalSource: () async => const [],
      budgetSource: () async => const [],
      goalStorage: _GoalStorage(),
      budgetStorage: _BudgetStorage(),
      checkpoints: _CheckpointStorage(),
    );

    expect(migrator.migrate(batchSize: 0), throwsArgumentError);
  });
}

class _GoalStorage implements GoalStorage {
  final records = <String, GoalRecord>{};

  @override
  Future<void> deleteById(String id, String? userId) async {}

  @override
  Future<List<GoalRecord>> readAll() async => records.values.toList();

  @override
  Future<List<GoalRecord>> readAllForUser(String? userId) async =>
      records.values
          .where((record) => record.userId == userId)
          .toList(growable: false);

  @override
  Future<GoalRecord?> readById(String id, String? userId) async =>
      records[userScopeKey(userId)];

  @override
  Future<void> save(GoalRecord record) async {
    records[userScopeKey(record.userId)] = record;
  }

  @override
  Future<void> updateProgress(String id, String? userId, String amount) async {}
}

class _BudgetStorage implements BudgetStorage {
  final records = <String, BudgetRecord>{};

  @override
  Future<void> deleteById(String id, String? userId) async {}

  @override
  Future<List<BudgetRecord>> readAll() async => records.values.toList();

  @override
  Future<List<BudgetRecord>> readAllForUser(String? userId) async =>
      records.values
          .where((record) => record.userId == userId)
          .toList(growable: false);

  @override
  Future<BudgetRecord?> readById(String id, String? userId) async =>
      records[userScopeKey(userId)];

  @override
  Future<void> save(BudgetRecord record) async {
    records[userScopeKey(record.userId)] = record;
  }
}

class _CheckpointStorage implements MigrationCheckpointStorage {
  final records = <String, MigrationCheckpoint>{};

  @override
  Future<MigrationCheckpoint?> read(String slice) async => records[slice];

  @override
  Future<void> save(MigrationCheckpoint checkpoint) async {
    records[checkpoint.slice] = checkpoint;
  }
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
