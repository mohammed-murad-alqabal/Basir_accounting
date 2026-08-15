import 'package:basir_drift_storage/src/basir_database.dart';
import 'package:basir_drift_storage/src/user_scope.dart';
import 'package:decimal/decimal.dart';
import 'package:drift/drift.dart';

/// DTO محايد لهدف مالي، يحافظ على Decimal كنص.
class GoalRecord {
  const GoalRecord({
    required this.id,
    required this.name,
    required this.category,
    required this.targetAmount,
    required this.currentAmount,
    required this.startDate,
    required this.targetDate,
    required this.isActive,
    required this.description,
    required this.userId,
  });

  final String id;
  final String name;
  final String category;
  final String targetAmount;
  final String currentAmount;
  final DateTime startDate;
  final DateTime targetDate;
  final bool isActive;
  final String? description;
  final String? userId;
}

/// عقد هدف مقيد بالنطاق؛ لا يعيد سجلات نطاق آخر عند userId = null.
abstract interface class GoalStorage {
  Future<List<GoalRecord>> readAllForUser(String? userId);

  Future<List<GoalRecord>> readAll();

  Future<GoalRecord?> readById(String id, String? userId);

  Future<void> save(GoalRecord record);

  Future<void> deleteById(String id, String? userId);

  Future<void> updateProgress(String id, String? userId, String amount);
}

/// DAO أهداف مع تحديث Decimal داخل معاملة Drift واحدة.
class GoalStore implements GoalStorage {
  GoalStore(this._database);

  final BasirDatabase _database;

  @override
  Future<List<GoalRecord>> readAllForUser(String? userId) async {
    final rows = await (_database.select(_database.goals)
          ..where((table) => table.scopeKey.equals(userScopeKey(userId)))
          ..orderBy([
            (table) => OrderingTerm.asc(table.startDate),
            (table) => OrderingTerm.asc(table.uuid),
          ]))
        .get();
    return rows.map(_toRecord).toList(growable: false);
  }

  @override
  Future<List<GoalRecord>> readAll() async {
    final rows = await (_database.select(_database.goals)
          ..orderBy([
            (table) => OrderingTerm.asc(table.scopeKey),
            (table) => OrderingTerm.asc(table.uuid),
          ]))
        .get();
    return rows.map(_toRecord).toList(growable: false);
  }

  @override
  Future<GoalRecord?> readById(String id, String? userId) async {
    final row = await (_database.select(_database.goals)
          ..where(
            (table) =>
                table.scopeKey.equals(userScopeKey(userId)) &
                table.uuid.equals(id),
          ))
        .getSingleOrNull();
    return row == null ? null : _toRecord(row);
  }

  @override
  Future<void> save(GoalRecord record) {
    _validate(record);
    return _database.into(_database.goals).insertOnConflictUpdate(
          GoalsCompanion.insert(
            scopeKey: <credential-fixture>(record.userId),
            uuid: record.id,
            name: record.name,
            category: record.category,
            targetAmount: record.targetAmount,
            currentAmount: record.currentAmount,
            startDate: record.startDate.toUtc(),
            targetDate: record.targetDate.toUtc(),
            isActive: Value(record.isActive),
            description: Value(record.description),
            userId: Value(record.userId),
          ),
        );
  }

  @override
  Future<void> deleteById(String id, String? userId) =>
      (_database.delete(_database.goals)
            ..where(
              (table) =>
                  table.scopeKey.equals(userScopeKey(userId)) &
                  table.uuid.equals(id),
            ))
          .go();

  @override
  Future<void> updateProgress(String id, String? userId, String amount) async {
    final row = await (_database.select(_database.goals)
          ..where(
            (table) =>
                table.scopeKey.equals(userScopeKey(userId)) &
                table.uuid.equals(id),
          ))
        .getSingleOrNull();
    if (row == null) return;

    final current = Decimal.parse(row.currentAmount);
    final next = current + Decimal.parse(amount);
    await (_database.update(_database.goals)
          ..where(
            (table) =>
                table.scopeKey.equals(userScopeKey(userId)) &
                table.uuid.equals(id),
          ))
        .write(GoalsCompanion(currentAmount: Value(next.toString())));
  }

  static GoalRecord _toRecord(Goal row) => GoalRecord(
        id: row.uuid,
        name: row.name,
        category: row.category,
        targetAmount: row.targetAmount,
        currentAmount: row.currentAmount,
        startDate: row.startDate,
        targetDate: row.targetDate,
        isActive: row.isActive,
        description: row.description,
        userId: row.userId,
      );

  static void _validate(GoalRecord record) {
    if (record.id.isEmpty || record.name.isEmpty) {
      throw ArgumentError.value(record, 'record', 'Goal id and name required.');
    }
    Decimal.parse(record.targetAmount);
    Decimal.parse(record.currentAmount);
    if (record.category.isEmpty) {
      throw ArgumentError.value(record, 'record', 'Goal category required.');
    }
  }
}
