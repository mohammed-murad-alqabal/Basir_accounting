import 'package:basir_drift_storage/src/basir_database.dart';
import 'package:basir_drift_storage/src/user_scope.dart';
import 'package:decimal/decimal.dart';
import 'package:drift/drift.dart';

/// DTO محايد لميزانية، يحافظ على Decimal كنص.
class BudgetRecord {
  const BudgetRecord({
    required this.id,
    required this.name,
    required this.category,
    required this.limitAmount,
    required this.spentAmount,
    required this.startDate,
    required this.endDate,
    required this.alertThreshold,
    required this.isRollover,
    required this.isActive,
    required this.userId,
  });

  final String id;
  final String name;
  final String category;
  final String limitAmount;
  final String spentAmount;
  final DateTime startDate;
  final DateTime endDate;
  final double alertThreshold;
  final bool isRollover;
  final bool isActive;
  final String? userId;
}

/// عقد ميزانية مقيد بالنطاق، مع إبقاء active filtering في طبقة الخدمة.
abstract interface class BudgetStorage {
  Future<List<BudgetRecord>> readAllForUser(String? userId);

  Future<BudgetRecord?> readById(String id, String? userId);

  Future<void> save(BudgetRecord record);

  Future<void> deleteById(String id, String? userId);
}

/// DAO ميزانيات مستقل عن domain ويحتفظ بدقة المبالغ المالية.
class BudgetStore implements BudgetStorage {
  BudgetStore(this._database);

  final BasirDatabase _database;

  @override
  Future<List<BudgetRecord>> readAllForUser(String? userId) async {
    final rows = await (_database.select(_database.budgets)
          ..where((table) => table.scopeKey.equals(userScopeKey(userId)))
          ..orderBy([
            (table) => OrderingTerm.asc(table.startDate),
            (table) => OrderingTerm.asc(table.budgetId),
          ]))
        .get();
    return rows.map(_toRecord).toList(growable: false);
  }

  @override
  Future<BudgetRecord?> readById(String id, String? userId) async {
    final row = await (_database.select(_database.budgets)
          ..where(
            (table) =>
                table.scopeKey.equals(userScopeKey(userId)) &
                table.budgetId.equals(id),
          ))
        .getSingleOrNull();
    return row == null ? null : _toRecord(row);
  }

  @override
  Future<void> save(BudgetRecord record) {
    _validate(record);
    return _database.into(_database.budgets).insertOnConflictUpdate(
          BudgetsCompanion.insert(
            scopeKey: userScopeKey(record.userId),
            budgetId: record.id,
            name: record.name,
            category: record.category,
            limitAmount: record.limitAmount,
            spentAmount: record.spentAmount,
            startDate: record.startDate.toUtc(),
            endDate: record.endDate.toUtc(),
            alertThreshold: record.alertThreshold,
            isRollover: Value(record.isRollover),
            isActive: Value(record.isActive),
            userId: Value(record.userId),
          ),
        );
  }

  @override
  Future<void> deleteById(String id, String? userId) =>
      (_database.delete(_database.budgets)
            ..where(
              (table) =>
                  table.scopeKey.equals(userScopeKey(userId)) &
                  table.budgetId.equals(id),
            ))
          .go();

  static BudgetRecord _toRecord(Budget row) => BudgetRecord(
        id: row.budgetId,
        name: row.name,
        category: row.category,
        limitAmount: row.limitAmount,
        spentAmount: row.spentAmount,
        startDate: row.startDate,
        endDate: row.endDate,
        alertThreshold: row.alertThreshold,
        isRollover: row.isRollover,
        isActive: row.isActive,
        userId: row.userId,
      );

  static void _validate(BudgetRecord record) {
    if (record.id.isEmpty || record.name.isEmpty) {
      throw ArgumentError.value(
        record,
        'record',
        'Budget id and name required.',
      );
    }
    Decimal.parse(record.limitAmount);
    Decimal.parse(record.spentAmount);
    if (record.category.isEmpty ||
        record.alertThreshold.isNaN ||
        record.alertThreshold.isInfinite) {
      throw ArgumentError.value(record, 'record', 'Invalid budget values.');
    }
  }
}
