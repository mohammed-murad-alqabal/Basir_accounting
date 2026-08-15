import 'dart:io';

import 'package:basir_accounting_system/core/persistence/drift_goals_budgets_migration.dart';
import 'package:basir_accounting_system/core/persistence/drift_goals_budgets_parity.dart';
import 'package:basir_accounting_system/features/budget/data/models/budget_model.dart';
import 'package:basir_accounting_system/features/budget/domain/entities/budget_category.dart';
import 'package:basir_accounting_system/features/goals/data/models/goal_model.dart';
import 'package:basir_accounting_system/features/goals/domain/entities/goal_category.dart';
import 'package:basir_drift_storage/basir_drift_storage.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';

void main() {
  late Directory temporaryDirectory;
  late Isar isar;
  late BasirDatabase driftDatabase;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
  });

  setUp(() async {
    temporaryDirectory = await Directory.systemTemp.createTemp(
      'basir-drift-goals-budgets-',
    );
    isar = await Isar.open(
      [GoalModelSchema, BudgetModelSchema],
      directory: temporaryDirectory.path,
      name: 'goals-budgets-source',
    );
    driftDatabase = BasirDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await driftDatabase.close();
    await isar.close(deleteFromDisk: true);
    if (temporaryDirectory.existsSync()) {
      await temporaryDirectory.delete(recursive: true);
    }
  });

  test('migrates and verifies Goals and Budgets end to end', () async {
    await isar.writeTxn(() async {
      await isar.goalModels.putAll([
        _goal(id: 'goal-a', userId: 'user-a'),
        _goal(id: 'goal-b', userId: 'user-b'),
      ]);
      await isar.budgetModels.putAll([
        _budget(id: 'budget-a', userId: 'user-a'),
        _budget(id: 'budget-b', userId: 'user-b'),
      ]);
    });

    final goalSource = IsarGoalMigrationSource(isar);
    final budgetSource = IsarBudgetMigrationSource(isar);
    final goalStorage = GoalStore(driftDatabase);
    final budgetStorage = BudgetStore(driftDatabase);
    final checkpoints = LocalMetadataMigrationCheckpointStore(driftDatabase);

    final migration = await DriftGoalsBudgetsMigrator(
      goalSource: goalSource.readAll,
      budgetSource: budgetSource.readAll,
      goalStorage: goalStorage,
      budgetStorage: budgetStorage,
      checkpoints: checkpoints,
    ).migrate(batchSize: 1);
    final parity = await DriftGoalsBudgetsParityVerifier(
      goalSource: goalSource.readAll,
      budgetSource: budgetSource.readAll,
      goalStorage: goalStorage,
      budgetStorage: budgetStorage,
    ).verify();

    expect(migration.isComplete, isTrue);
    expect(parity.isClean, isTrue);
    expect(
      (await checkpoints.read(DriftGoalsBudgetsMigrationSlice.goals))
          ?.isComplete,
      isTrue,
    );
    expect(
      (await checkpoints.read(DriftGoalsBudgetsMigrationSlice.budgets))
          ?.isComplete,
      isTrue,
    );
    expect(
      (await goalStorage.readById('goal-a', 'user-a'))?.targetAmount,
      '10.00',
    );
    expect(
      (await budgetStorage.readById('budget-b', 'user-b'))?.spentAmount,
      '2.500',
    );
    expect(await isar.goalModels.count(), 2);
    expect(await isar.budgetModels.count(), 2);
  });
}

GoalModel _goal({required String id, required String userId}) => GoalModel()
  ..uuid = id
  ..name = 'Emergency fund'
  ..category = GoalCategory.emergencyFund
  ..targetAmount = '10.00'
  ..currentAmount = '1.25'
  ..startDate = DateTime.utc(2026)
  ..targetDate = DateTime.utc(2026, 12)
  ..isActive = true
  ..description = null
  ..userId = userId;

BudgetModel _budget({required String id, required String userId}) =>
    BudgetModel()
      ..budgetId = id
      ..name = 'Housing'
      ..category = BudgetCategory.housing
      ..limitAmountStr = '100.000'
      ..spentAmountStr = '2.500'
      ..startDate = DateTime.utc(2026)
      ..endDate = DateTime.utc(2026, 1, 31)
      ..alertThreshold = 0.8
      ..isRollover = false
      ..isActive = true
      ..userId = userId;
