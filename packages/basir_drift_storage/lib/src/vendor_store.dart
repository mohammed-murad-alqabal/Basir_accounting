import 'package:basir_drift_storage/src/basir_database.dart';
import 'package:basir_drift_storage/src/user_scope.dart';
import 'package:drift/drift.dart';

/// DTO محايد للمورد؛ يحافظ على الحقول التشغيلية والمحاسبية والمزامنة.
class VendorRecord {
  const VendorRecord({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.phone,
    required this.email,
    required this.address,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
    required this.payableAccountId,
    required this.vatNumber,
    required this.registrationNumber,
    required this.balance,
    required this.userId,
    required this.syncStatus,
    required this.serverUpdatedAt,
    required this.isDeleted,
  });

  final String id;
  final String nameAr;
  final String nameEn;
  final String? phone;
  final String? email;
  final String? address;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? payableAccountId;
  final String? vatNumber;
  final String? registrationNumber;
  final double balance;
  final String? userId;
  final String syncStatus;
  final DateTime? serverUpdatedAt;
  final bool isDeleted;
}

/// عقد تخزين Vendor مستقل عن Drift generated rows وكيانات التطبيق.
abstract interface class VendorStorage {
  Future<List<VendorRecord>> readAllForUser(String? userId);

  Future<List<VendorRecord>> readAll();

  Future<VendorRecord?> readById(String id, String? userId);

  Future<List<VendorRecord>> searchForUser(String query, String? userId);

  Future<void> save(VendorRecord record);

  Future<void> deleteById(String id, String? userId);
}

/// DAO تجريبي لـVendor. لا يغير Providers ولا يشارك في Supabase sync.
class VendorStore implements VendorStorage {
  VendorStore(this._database);

  final BasirDatabase _database;

  @override
  Future<List<VendorRecord>> readAllForUser(String? userId) async {
    final rows = await (_database.select(_database.vendors)
          ..where((table) => table.scopeKey.equals(userScopeKey(userId)))
          ..orderBy([
            (table) => OrderingTerm.asc(table.nameAr),
            (table) => OrderingTerm.asc(table.uuid),
          ]))
        .get();
    return rows.map(_toRecord).toList(growable: false);
  }

  @override
  Future<List<VendorRecord>> readAll() async {
    final rows = await (_database.select(_database.vendors)
          ..orderBy([
            (table) => OrderingTerm.asc(table.scopeKey),
            (table) => OrderingTerm.asc(table.uuid),
          ]))
        .get();
    return rows.map(_toRecord).toList(growable: false);
  }

  @override
  Future<VendorRecord?> readById(String id, String? userId) async {
    final row = await (_database.select(_database.vendors)
          ..where(
            (table) =>
                table.scopeKey.equals(userScopeKey(userId)) &
                table.uuid.equals(id),
          ))
        .getSingleOrNull();
    return row == null ? null : _toRecord(row);
  }

  @override
  Future<List<VendorRecord>> searchForUser(String query, String? userId) async {
    // يطابق Isar case-insensitive name search، مع إبقاء escaping خارج SQL.
    final normalized = query.toLowerCase();
    final records = await readAllForUser(userId);
    return records
        .where(
          (record) =>
              record.nameAr.toLowerCase().contains(normalized) ||
              record.nameEn.toLowerCase().contains(normalized),
        )
        .toList(growable: false);
  }

  @override
  Future<void> save(VendorRecord record) {
    _validate(record);
    return _database.into(_database.vendors).insertOnConflictUpdate(
          VendorsCompanion.insert(
            scopeKey: userScopeKey(record.userId),
            uuid: record.id,
            nameAr: record.nameAr,
            nameEn: record.nameEn,
            phone: Value(record.phone),
            email: Value(record.email),
            address: Value(record.address),
            notes: Value(record.notes),
            createdAt: record.createdAt.toUtc(),
            updatedAt: record.updatedAt.toUtc(),
            payableAccountId: Value(record.payableAccountId),
            vatNumber: Value(record.vatNumber),
            registrationNumber: Value(record.registrationNumber),
            balance: Value(record.balance),
            userId: Value(record.userId),
            syncStatus: Value(record.syncStatus),
            serverUpdatedAt: Value(record.serverUpdatedAt?.toUtc()),
            isDeleted: Value(record.isDeleted),
          ),
        );
  }

  @override
  Future<void> deleteById(String id, String? userId) =>
      (_database.delete(_database.vendors)
            ..where(
              (table) =>
                  table.scopeKey.equals(userScopeKey(userId)) &
                  table.uuid.equals(id),
            ))
          .go();

  static VendorRecord _toRecord(Vendor row) => VendorRecord(
        id: row.uuid,
        nameAr: row.nameAr,
        nameEn: row.nameEn,
        phone: row.phone,
        email: row.email,
        address: row.address,
        notes: row.notes,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
        payableAccountId: row.payableAccountId,
        vatNumber: row.vatNumber,
        registrationNumber: row.registrationNumber,
        balance: row.balance,
        userId: row.userId,
        syncStatus: row.syncStatus,
        serverUpdatedAt: row.serverUpdatedAt,
        isDeleted: row.isDeleted,
      );

  static void _validate(VendorRecord record) {
    if (record.id.isEmpty || record.nameAr.isEmpty || record.nameEn.isEmpty) {
      throw ArgumentError.value(
        record,
        'record',
        'Vendor id and names are required.',
      );
    }
    validateVendorSyncStatus(record.syncStatus);
  }
}

void validateVendorSyncStatus(String value) {
  if (!const {'synced', 'pendingPush', 'pendingPull', 'conflict'}
      .contains(value)) {
    throw ArgumentError.value(value, 'syncStatus', 'Unsupported sync status.');
  }
}
