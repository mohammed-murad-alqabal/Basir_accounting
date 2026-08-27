import 'package:basir_accounting_system/features/budget/data/models/budget_model.dart';
import 'package:basir_accounting_system/features/goals/data/models/goal_model.dart';
import 'package:basir_drift_storage/basir_drift_storage.dart';
import 'package:isar/isar.dart';

/// شرائح مستقلة لمهاجر Goals وBudgets.
abstract final class DriftGoalsBudgetsMigrationSlice {
  static const goals = 'goals-v1';
  static const budgets = 'budgets-v1';
}

typedef GoalMigrationReader = Future<List<GoalRecord>> Function();
typedef BudgetMigrationReader = Future<List<BudgetRecord>> Function();

/// قارئ Goals من Isar فقط، مع تحويل محايد وترتيب deterministic.
class IsarGoalMigrationSource {
  IsarGoalMigrationSource(this._isar);

  final Isar _isar;

  Future<List<GoalRecord>> readAll() async {
    final records = (await _isar.goalModels.where().findAll())
        .map(_toRecord)
        .toList(growable: false)
      ..sort(_compareGoals);
    return records;
  }

  static GoalRecord _toRecord(GoalModel model) => GoalRecord(
        id: model.uuid,
        name: model.name,
        category: model.category.name,
        targetAmount: model.targetAmount,
        currentAmount: model.currentAmount,
        startDate: model.startDate.toUtc(),
        targetDate: model.targetDate.toUtc(),
        isActive: model.isActive,
        description: model.description,
        userId: model.userId,
      );
}

/// قارئ Budgets من Isar فقط، مع حفظ Decimal كنص وترتيب deterministic.
class IsarBudgetMigrationSource {
  IsarBudgetMigrationSource(this._isar);

  final Isar _isar;

  Future<List<BudgetRecord>> readAll() async {
    final records = (await _isar.budgetModels.where().findAll())
        .map(_toRecord)
        .toList(growable: false)
      ..sort(_compareBudgets);
    return records;
  }

  static BudgetRecord _toRecord(BudgetModel model) => BudgetRecord(
        id: model.budgetId,
        name: model.name,
        category: model.category.name,
        limitAmount: model.limitAmountStr,
        spentAmount: model.spentAmountStr,
        startDate: model.startDate.toUtc(),
        endDate: model.endDate.toUtc(),
        alertThreshold: model.alertThreshold,
        isRollover: model.isRollover,
        isActive: model.isActive,
        userId: model.userId,
      );
}

class DriftGoalsBudgetsMigrationReport {
  const DriftGoalsBudgetsMigrationReport({
    required this.goals,
    required this.budgets,
  });

  final MigrationCheckpoint goals;
  final MigrationCheckpoint budgets;

  bool get isComplete => goals.isComplete && budgets.isComplete;
}

/// يستورد Goals وBudgets إلى Drift؛ لا يسجل Providers ولا يكتب Isar.
class DriftGoalsBudgetsMigrator {
  DriftGoalsBudgetsMigrator({
    required GoalMigrationReader goalSource,
    required BudgetMigrationReader budgetSource,
    required GoalStorage goalStorage,
    required BudgetStorage budgetStorage,
    required MigrationCheckpointStorage checkpoints,
  })  : _goalSource = goalSource,
        _budgetSource = budgetSource,
        _goalStorage = goalStorage,
        _budgetStorage = budgetStorage,
        _checkpoints = checkpoints;

  final GoalMigrationReader _goalSource;
  final BudgetMigrationReader _budgetSource;
  final GoalStorage _goalStorage;
  final BudgetStorage _budgetStorage;
  final MigrationCheckpointStorage _checkpoints;

  Future<DriftGoalsBudgetsMigrationReport> migrate({
    int batchSize = 250,
  }) async {
    if (batchSize <= 0) {
      throw ArgumentError.value(batchSize, 'batchSize', 'Must be positive.');
    }

    final goals = await _migrateGoals(batchSize: batchSize);
    final budgets = await _migrateBudgets(batchSize: batchSize);
    return DriftGoalsBudgetsMigrationReport(goals: goals, budgets: budgets);
  }

  Future<MigrationCheckpoint> _migrateGoals({required int batchSize}) async {
    final records = await _goalSource();
    return _writeBatches<GoalRecord>(
      slice: DriftGoalsBudgetsMigrationSlice.goals,
      records: records,
      batchSize: batchSize,
      write: _goalStorage.save,
    );
  }

  Future<MigrationCheckpoint> _migrateBudgets({required int batchSize}) async {
    final records = await _budgetSource();
    return _writeBatches<BudgetRecord>(
      slice: DriftGoalsBudgetsMigrationSlice.budgets,
      records: records,
      batchSize: batchSize,
      write: _budgetStorage.save,
    );
  }

  Future<MigrationCheckpoint> _writeBatches<T>({
    required String slice,
    required List<T> records,
    required int batchSize,
    required Future<void> Function(T record) write,
  }) async {
    var migratedCount = 0;
    for (var start = 0; start < records.length; start += batchSize) {
      final end = start + batchSize < records.length
          ? start + batchSize
          : records.length;
      for (final record in records.sublist(start, end)) {
        await write(record);
        migratedCount += 1;
      }
      await _checkpoints.save(
        MigrationCheckpoint(
          slice: slice,
          sourceCount: records.length,
          migratedCount: migratedCount,
          completedAt: null,
        ),
      );
    }

    final checkpoint = MigrationCheckpoint(
      slice: slice,
      sourceCount: records.length,
      migratedCount: migratedCount,
      completedAt: DateTime.now().toUtc(),
    );
    await _checkpoints.save(checkpoint);
    return checkpoint;
  }
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
