import 'package:basir_drift_storage/src/basir_database.dart';
import 'package:basir_drift_storage/src/user_scope.dart';
import 'package:drift/drift.dart';

/// DTO محايد لملف المستخدم؛ لا يعتمد على Freezed أو Isar أو Riverpod.
class ProfileRecord {
  const ProfileRecord({
    required this.id,
    required this.email,
    required this.displayName,
    required this.avatarUrl,
    required this.phoneNumber,
    required this.userId,
    required this.syncStatus,
    required this.serverUpdatedAt,
    required this.isDeleted,
  });

  final String id;
  final String email;
  final String? displayName;
  final String? avatarUrl;
  final String? phoneNumber;
  final String? userId;
  final String syncStatus;
  final DateTime? serverUpdatedAt;
  final bool isDeleted;
}

/// عقد Profile القابل للاختبار من دون كشف أنواع Drift إلى التطبيق المضيف.
abstract interface class ProfileStorage {
  Future<ProfileRecord?> readForUser(String? userId);

  Future<void> save(ProfileRecord record);

  Future<void> deleteForUser(String? userId);
}

/// DAO Profile للموجة الثانية. يفرض سجلًا واحدًا لكل نطاق مستخدم ويستخدم
/// upsert كي يطابق استبدال Isar للسجل داخل repository المقيد بالمستخدم.
class ProfileStore implements ProfileStorage {
  ProfileStore(this._database);

  final BasirDatabase _database;

  @override
  Future<ProfileRecord?> readForUser(String? userId) async {
    final row = await (_database.select(_database.profiles)
          ..where((table) => table.scopeKey.equals(userScopeKey(userId))))
        .getSingleOrNull();
    return row == null ? null : _toRecord(row);
  }

  @override
  Future<void> save(ProfileRecord record) {
    _validate(record);
    return _database.into(_database.profiles).insertOnConflictUpdate(
          ProfilesCompanion.insert(
            scopeKey: userScopeKey(record.userId),
            id: record.id,
            email: record.email,
            displayName: Value(record.displayName),
            avatarUrl: Value(record.avatarUrl),
            phoneNumber: Value(record.phoneNumber),
            userId: Value(record.userId),
            syncStatus: Value(record.syncStatus),
            serverUpdatedAt: Value(record.serverUpdatedAt?.toUtc()),
            isDeleted: Value(record.isDeleted),
          ),
        );
  }

  @override
  Future<void> deleteForUser(String? userId) =>
      (_database.delete(_database.profiles)
            ..where((table) => table.scopeKey.equals(userScopeKey(userId))))
          .go();

  static ProfileRecord _toRecord(Profile row) => ProfileRecord(
        id: row.id,
        email: row.email,
        displayName: row.displayName,
        avatarUrl: row.avatarUrl,
        phoneNumber: row.phoneNumber,
        userId: row.userId,
        syncStatus: row.syncStatus,
        serverUpdatedAt: row.serverUpdatedAt,
        isDeleted: row.isDeleted,
      );

  static void _validate(ProfileRecord record) {
    if (record.id.isEmpty || record.email.isEmpty) {
      throw ArgumentError.value(
        record,
        'record',
        'Profile id and email are required.',
      );
    }
    _validateSyncStatus(record.syncStatus);
  }
}

void validateProfileSyncStatus(String value) => _validateSyncStatus(value);

void _validateSyncStatus(String value) {
  if (!const {'synced', 'pendingPush', 'pendingPull', 'conflict'}
      .contains(value)) {
    throw ArgumentError.value(value, 'syncStatus', 'Unsupported sync status.');
  }
}
