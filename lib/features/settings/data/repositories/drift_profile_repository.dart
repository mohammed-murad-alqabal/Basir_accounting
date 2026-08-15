import 'package:basir_accounting_system/core/models/sync_status.dart';
import 'package:basir_accounting_system/features/settings/domain/entities/profile.dart';
import 'package:basir_accounting_system/features/settings/domain/repositories/profile_repository.dart';
import 'package:basir_drift_storage/basir_drift_storage.dart';

/// مكيّف تجريبي لعقد Profile باستخدام Drift.
///
/// لا يُسجل هذا التنفيذ في Riverpod بعد؛ يبقى ProfileRepositoryImpl المعتمد
/// على Isar المسار النشط حتى تجتاز الموجة بوابات الاستيراد والتكافؤ والـcanary.
class DriftProfileRepository implements ProfileRepository {
  DriftProfileRepository(BasirDatabase database, {this.userId})
      : _storage = ProfileStore(database);

  /// منشئ اختبار/حقن يحافظ على عزل طبقة domain عن أنواع Drift.
  DriftProfileRepository.withStorage(this._storage, {this.userId});

  final ProfileStorage _storage;
  final String? userId;

  @override
  Future<Profile?> getProfile() => _storage
      .readForUser(userId)
      .then((record) => record == null ? null : _toEntity(record));

  @override
  Future<void> saveProfile(Profile profile) => _storage.save(
        _toRecord(
          Profile(
            id: profile.id,
            email: profile.email,
            displayName: profile.displayName,
            avatarUrl: profile.avatarUrl,
            phoneNumber: profile.phoneNumber,
            userId: userId,
            syncStatus: profile.syncStatus,
            serverUpdatedAt: profile.serverUpdatedAt,
            isDeleted: profile.isDeleted,
          ),
        ),
      );

  @override
  Future<void> deleteProfile() => _storage.deleteForUser(userId);

  static ProfileRecord _toRecord(Profile profile) => ProfileRecord(
        id: profile.id,
        email: profile.email,
        displayName: profile.displayName,
        avatarUrl: profile.avatarUrl,
        phoneNumber: profile.phoneNumber,
        userId: profile.userId,
        syncStatus: profile.syncStatus.name,
        serverUpdatedAt: profile.serverUpdatedAt,
        isDeleted: profile.isDeleted,
      );

  static Profile _toEntity(ProfileRecord record) => Profile(
        id: record.id,
        email: record.email,
        displayName: record.displayName,
        avatarUrl: record.avatarUrl,
        phoneNumber: record.phoneNumber,
        userId: record.userId,
        syncStatus: _syncStatusFromStorage(record.syncStatus),
        serverUpdatedAt: record.serverUpdatedAt,
        isDeleted: record.isDeleted,
      );

  static SyncStatus _syncStatusFromStorage(String value) => switch (value) {
        'synced' => SyncStatus.synced,
        'pendingPush' => SyncStatus.pendingPush,
        'pendingPull' => SyncStatus.pendingPull,
        'conflict' => SyncStatus.conflict,
        _ => throw StateError('Unsupported persisted sync status: $value'),
      };
}
