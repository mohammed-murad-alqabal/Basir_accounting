import 'dart:convert';

import 'package:basir_accounting_system/core/persistence/drift_goals_budgets_migration.dart';
import 'package:basir_accounting_system/core/persistence/drift_goals_budgets_parity.dart';
import 'package:basir_drift_storage/basir_drift_storage.dart';
import 'package:decimal/decimal.dart';

/// لقطة معقمة لا ترتبط بقاعدة Isar التشغيلية.
class DriftGoalsBudgetsSnapshot {
  const DriftGoalsBudgetsSnapshot({
    required this.schemaVersion,
    required this.goals,
    required this.budgets,
  });

  factory DriftGoalsBudgetsSnapshot.fromJsonString(String source) =>
      DriftGoalsBudgetsSnapshot.fromJson(
        jsonDecode(source) as Map<String, Object?>,
      );

  factory DriftGoalsBudgetsSnapshot.fromJson(Map<String, Object?> json) {
    if (json['sanitized'] != true) {
      throw const FormatException('Snapshot must explicitly be sanitized.');
    }
    if (json['schemaVersion'] != 1) {
      throw FormatException(
        'Unsupported snapshot schema: ${json['schemaVersion']}.',
      );
    }

    return DriftGoalsBudgetsSnapshot(
      schemaVersion: 1,
      goals: _readList(json['goals'], _goalFromJson),
      budgets: _readList(json['budgets'], _budgetFromJson),
    );
  }

  final int schemaVersion;
  final List<GoalRecord> goals;
  final List<BudgetRecord> budgets;

  static List<T> _readList<T>(
    Object? value,
    T Function(Map<String, Object?> json) decode,
  ) {
    if (value is! List<Object?>) {
      throw const FormatException('Snapshot collection is missing.');
    }
    return value.map((item) {
      if (item is! Map<String, Object?>) {
        throw const FormatException('Snapshot record must be an object.');
      }
      return decode(item);
    }).toList(growable: false);
  }
}

/// نتيجة تشغيل offline؛ لا تحتفظ بقاعدة البيانات أو payload بعد الإغلاق.
class DriftGoalsBudgetsSnapshotRunReport {
  const DriftGoalsBudgetsSnapshotRunReport({
    required this.migration,
    required this.parity,
  });

  final DriftGoalsBudgetsMigrationReport migration;
  final DriftGoalsBudgetsParityReport parity;

  bool get isClean => migration.isComplete && parity.isClean;
}

/// يشغل snapshot معقمة داخل SQLite في الذاكرة فقط.
class DriftGoalsBudgetsSnapshotRunner {
  Future<DriftGoalsBudgetsSnapshotRunReport> run(
    DriftGoalsBudgetsSnapshot snapshot, {
    required BasirDatabase Function() databaseFactory,
    int batchSize = 250,
  }) async {
    final database = databaseFactory();
    try {
      final goalStorage = GoalStore(database);
      final budgetStorage = BudgetStore(database);
      final checkpoints = LocalMetadataMigrationCheckpointStore(database);
      Future<List<GoalRecord>> goalSource() async => snapshot.goals;
      Future<List<BudgetRecord>> budgetSource() async => snapshot.budgets;

      final migration = await DriftGoalsBudgetsMigrator(
        goalSource: goalSource,
        budgetSource: budgetSource,
        goalStorage: goalStorage,
        budgetStorage: budgetStorage,
        checkpoints: checkpoints,
      ).migrate(batchSize: batchSize);
      final parity = await DriftGoalsBudgetsParityVerifier(
        goalSource: goalSource,
        budgetSource: budgetSource,
        goalStorage: goalStorage,
        budgetStorage: budgetStorage,
      ).verify();

      return DriftGoalsBudgetsSnapshotRunReport(
        migration: migration,
        parity: parity,
      );
    } finally {
      await database.close();
    }
  }
}

GoalRecord _goalFromJson(Map<String, Object?> json) => GoalRecord(
      id: _requiredString(json, 'id'),
      name: _requiredString(json, 'name'),
      category: _requiredString(json, 'category'),
      targetAmount: _requiredDecimalString(json, 'targetAmount'),
      currentAmount: _requiredDecimalString(json, 'currentAmount'),
      startDate: _requiredDate(json, 'startDate'),
      targetDate: _requiredDate(json, 'targetDate'),
      isActive: _requiredBool(json, 'isActive'),
      description: _optionalString(json, 'description'),
      userId: _optionalString(json, 'userId'),
    );

BudgetRecord _budgetFromJson(Map<String, Object?> json) => BudgetRecord(
      id: _requiredString(json, 'id'),
      name: _requiredString(json, 'name'),
      category: _requiredString(json, 'category'),
      limitAmount: _requiredDecimalString(json, 'limitAmount'),
      spentAmount: _requiredDecimalString(json, 'spentAmount'),
      startDate: _requiredDate(json, 'startDate'),
      endDate: _requiredDate(json, 'endDate'),
      alertThreshold: _requiredFiniteNumber(json, 'alertThreshold'),
      isRollover: _requiredBool(json, 'isRollover'),
      isActive: _requiredBool(json, 'isActive'),
      userId: _optionalString(json, 'userId'),
    );

String _requiredString(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value is! String || value.isEmpty) {
    throw FormatException('Snapshot field $key must be a non-empty string.');
  }
  return value;
}

String _requiredDecimalString(Map<String, Object?> json, String key) {
  final value = _requiredString(json, key);
  try {
    Decimal.parse(value);
  } on FormatException {
    throw FormatException(
      'Snapshot field $key must be a valid Decimal string.',
    );
  }
  return value;
}

String? _optionalString(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value == null) return null;
  if (value is! String) {
    throw FormatException('Snapshot field $key must be a string or null.');
  }
  return value;
}

DateTime _requiredDate(Map<String, Object?> json, String key) {
  final value = _requiredString(json, key);
  final parsed = DateTime.tryParse(value);
  if (parsed == null) throw FormatException('Snapshot field $key is invalid.');
  return parsed.toUtc();
}

bool _requiredBool(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value is! bool) {
    throw FormatException('Snapshot field $key must be boolean.');
  }
  return value;
}

double _requiredFiniteNumber(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value is num && value.toDouble().isFinite) return value.toDouble();
  throw FormatException('Snapshot field $key must be a finite number.');
}
