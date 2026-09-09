import 'package:basir_drift_storage/src/basir_database.dart';
import 'package:basir_drift_storage/src/user_scope.dart';
import 'package:drift/drift.dart';

/// DTO محايد للمستودع؛ لا يضيف sync أو soft-delete غير موجودين في المصدر.
class WarehouseRecord {
  const WarehouseRecord({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.location,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String nameAr;
  final String nameEn;
  final String? location;
  final String? userId;
  final DateTime createdAt;
  final DateTime updatedAt;
}

/// عقد تخزين Warehouse مستقل عن كيانات domain وProviders التطبيق.
abstract interface class WarehouseStorage {
  Future<List<WarehouseRecord>> readAllForUser(String? userId);

  Future<List<WarehouseRecord>> readAll();

  Future<WarehouseRecord?> readById(String id, String? userId);

  Future<void> save(WarehouseRecord record);

  Future<void> deleteById(String id, String? userId);
}

/// DAO تجريبي لـWarehouse. لا يغير Isar أو Supabase sync.
class WarehouseStore implements WarehouseStorage {
  WarehouseStore(this._database);

  final BasirDatabase _database;

  @override
  Future<List<WarehouseRecord>> readAllForUser(String? userId) async {
    final rows = await (_database.select(_database.warehouses)
          ..where((table) => table.scopeKey.equals(userScopeKey(userId)))
          ..orderBy([
            (table) => OrderingTerm.asc(table.uuid),
          ]))
        .get();
    return rows.map(_toRecord).toList(growable: false);
  }

  @override
  Future<List<WarehouseRecord>> readAll() async {
    final rows = await (_database.select(_database.warehouses)
          ..orderBy([
            (table) => OrderingTerm.asc(table.scopeKey),
            (table) => OrderingTerm.asc(table.uuid),
          ]))
        .get();
    return rows.map(_toRecord).toList(growable: false);
  }

  @override
  Future<WarehouseRecord?> readById(String id, String? userId) async {
    final row = await (_database.select(_database.warehouses)
          ..where(
            (table) =>
                table.scopeKey.equals(userScopeKey(userId)) &
                table.uuid.equals(id),
          ))
        .getSingleOrNull();
    return row == null ? null : _toRecord(row);
  }

  @override
  Future<void> save(WarehouseRecord record) {
    _validate(record);
    return _database.into(_database.warehouses).insertOnConflictUpdate(
          WarehousesCompanion.insert(
            scopeKey: userScopeKey(record.userId),
            uuid: record.id,
            nameAr: record.nameAr,
            nameEn: record.nameEn,
            location: Value(record.location),
            userId: Value(record.userId),
            createdAt: record.createdAt.toUtc(),
            updatedAt: record.updatedAt.toUtc(),
          ),
        );
  }

  @override
  Future<void> deleteById(String id, String? userId) =>
      (_database.delete(_database.warehouses)
            ..where(
              (table) =>
                  table.scopeKey.equals(userScopeKey(userId)) &
                  table.uuid.equals(id),
            ))
          .go();

  static WarehouseRecord _toRecord(Warehouse row) => WarehouseRecord(
        id: row.uuid,
        nameAr: row.nameAr,
        nameEn: row.nameEn,
        location: row.location,
        userId: row.userId,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
      );

  static void _validate(WarehouseRecord record) {
    if (record.id.isEmpty || record.nameAr.isEmpty || record.nameEn.isEmpty) {
      throw ArgumentError.value(
        record,
        'record',
        'Warehouse id and names are required.',
      );
    }
  }
}
