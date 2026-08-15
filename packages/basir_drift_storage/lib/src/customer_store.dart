import 'package:basir_drift_storage/src/basir_database.dart';
import 'package:basir_drift_storage/src/user_scope.dart';
import 'package:drift/drift.dart';

/// DTO محايد للعميل؛ يحافظ على الحقول التشغيلية والمحاسبية والمزامنة.
class CustomerRecord {
  const CustomerRecord({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.taxNumber,
    required this.phone,
    required this.email,
    required this.address,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
    required this.creditLimit,
    required this.balance,
    required this.receivableAccountId,
    required this.userId,
    required this.syncStatus,
    required this.serverUpdatedAt,
    required this.isDeleted,
  });

  final String id;
  final String nameAr;
  final String nameEn;
  final String? taxNumber;
  final String? phone;
  final String? email;
  final String? address;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double creditLimit;
  final double balance;
  final String? receivableAccountId;
  final String? userId;
  final String syncStatus;
  final DateTime? serverUpdatedAt;
  final bool isDeleted;
}

/// عقد تخزين Customer مستقل عن Drift generated rows وكيانات التطبيق.
abstract interface class CustomerStorage {
  Future<List<CustomerRecord>> readAllForUser(String? userId);

  Future<List<CustomerRecord>> readAll();

  Future<CustomerRecord?> readById(String id, String? userId);

  Future<List<CustomerRecord>> searchForUser(String query, String? userId);

  Future<void> save(CustomerRecord record);

  Future<void> deleteById(String id, String? userId);

  Future<void> deleteAllForUser(String? userId);
}

/// DAO تجريبي لـCustomer. لا يغير Providers ولا يشارك في Supabase sync.
class CustomerStore implements CustomerStorage {
  CustomerStore(this._database);

  final BasirDatabase _database;

  @override
  Future<List<CustomerRecord>> readAllForUser(String? userId) async {
    final rows = await (_database.select(_database.customers)
          ..where((table) => table.scopeKey.equals(userScopeKey(userId)))
          ..orderBy([
            (table) => OrderingTerm.asc(table.nameAr),
            (table) => OrderingTerm.asc(table.uuid),
          ]))
        .get();
    return rows.map(_toRecord).toList(growable: false);
  }

  @override
  Future<List<CustomerRecord>> readAll() async {
    final rows = await (_database.select(_database.customers)
          ..orderBy([
            (table) => OrderingTerm.asc(table.scopeKey),
            (table) => OrderingTerm.asc(table.uuid),
          ]))
        .get();
    return rows.map(_toRecord).toList(growable: false);
  }

  @override
  Future<CustomerRecord?> readById(String id, String? userId) async {
    final row = await (_database.select(_database.customers)
          ..where(
            (table) =>
                table.scopeKey.equals(userScopeKey(userId)) &
                table.uuid.equals(id),
          ))
        .getSingleOrNull();
    return row == null ? null : _toRecord(row);
  }

  @override
  Future<List<CustomerRecord>> searchForUser(
    String query,
    String? userId,
  ) async {
    // يطابق Isar case-insensitive name search. يبقى filtering هنا محليًا
    // مؤقتًا لتجنب اختلافات LIKE/escaping بين SQLite وWASM.
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
  Future<void> save(CustomerRecord record) {
    _validate(record);
    return _database.into(_database.customers).insertOnConflictUpdate(
          CustomersCompanion.insert(
            scopeKey: userScopeKey(record.userId),
            uuid: record.id,
            nameAr: record.nameAr,
            nameEn: record.nameEn,
            taxNumber: Value(record.taxNumber),
            phone: Value(record.phone),
            email: Value(record.email),
            address: Value(record.address),
            notes: Value(record.notes),
            createdAt: record.createdAt.toUtc(),
            updatedAt: record.updatedAt.toUtc(),
            creditLimit: Value(record.creditLimit),
            balance: Value(record.balance),
            receivableAccountId: Value(record.receivableAccountId),
            userId: Value(record.userId),
            syncStatus: Value(record.syncStatus),
            serverUpdatedAt: Value(record.serverUpdatedAt?.toUtc()),
            isDeleted: Value(record.isDeleted),
          ),
        );
  }

  @override
  Future<void> deleteById(String id, String? userId) =>
      (_database.delete(_database.customers)
            ..where(
              (table) =>
                  table.scopeKey.equals(userScopeKey(userId)) &
                  table.uuid.equals(id),
            ))
          .go();

  @override
  Future<void> deleteAllForUser(String? userId) =>
      (_database.delete(_database.customers)
            ..where((table) => table.scopeKey.equals(userScopeKey(userId))))
          .go();

  static CustomerRecord _toRecord(Customer row) => CustomerRecord(
        id: row.uuid,
        nameAr: row.nameAr,
        nameEn: row.nameEn,
        taxNumber: row.taxNumber,
        phone: row.phone,
        email: row.email,
        address: row.address,
        notes: row.notes,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
        creditLimit: row.creditLimit,
        balance: row.balance,
        receivableAccountId: row.receivableAccountId,
        userId: row.userId,
        syncStatus: row.syncStatus,
        serverUpdatedAt: row.serverUpdatedAt,
        isDeleted: row.isDeleted,
      );

  static void _validate(CustomerRecord record) {
    if (record.id.isEmpty || record.nameAr.isEmpty || record.nameEn.isEmpty) {
      throw ArgumentError.value(
        record,
        'record',
        'Customer id and names are required.',
      );
    }
    validateCustomerSyncStatus(record.syncStatus);
  }
}

void validateCustomerSyncStatus(String value) {
  if (!const {'synced', 'pendingPush', 'pendingPull', 'conflict'}
      .contains(value)) {
    throw ArgumentError.value(value, 'syncStatus', 'Unsupported sync status.');
  }
}
