import 'package:basir_accounting_system/core/persistence/drift_settings_migration.dart';
import 'package:basir_drift_storage/basir_drift_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DriftSettingsMigrator', () {
    late _ProfileStorage profiles;
    late _BusinessSettingsStorage businessSettings;
    late _CheckpointStorage checkpoints;

    setUp(() {
      profiles = _ProfileStorage();
      businessSettings = _BusinessSettingsStorage();
      checkpoints = _CheckpointStorage();
    });

    test('migrates user-scoped settings in batches and is safe to rerun',
        () async {
      final migrator = DriftSettingsMigrator(
        profileSource: () async => [
          _profile(id: 'profile-b', userId: 'user-b'),
          _profile(id: 'profile-a', userId: 'user-a'),
        ],
        businessSettingsSource: () async => [
          _settings(id: 'settings-b', userId: 'user-b'),
          _settings(id: 'settings-a', userId: 'user-a'),
        ],
        profileStorage: profiles,
        businessSettingsStorage: businessSettings,
        checkpoints: checkpoints,
      );

      final firstRun = await migrator.migrate(batchSize: 1);
      final secondRun = await migrator.migrate(batchSize: 1);

      expect(firstRun.isComplete, isTrue);
      expect(secondRun.isComplete, isTrue);
      expect(profiles.records, hasLength(2));
      expect(businessSettings.records, hasLength(2));
      expect(profiles.records[userScopeKey('user-a')]?.id, 'profile-a');
      expect(
        businessSettings.records[userScopeKey('user-b')]?.id,
        'settings-b',
      );
      expect(
        checkpoints.records[DriftSettingsMigrationSlice.profiles]?.isComplete,
        isTrue,
      );
      expect(
        checkpoints
            .records[DriftSettingsMigrationSlice.businessSettings]?.isComplete,
        isTrue,
      );
    });

    test('records empty sources as complete and rejects a non-positive batch',
        () async {
      final migrator = DriftSettingsMigrator(
        profileSource: () async => const [],
        businessSettingsSource: () async => const [],
        profileStorage: profiles,
        businessSettingsStorage: businessSettings,
        checkpoints: checkpoints,
      );

      await expectLater(
        migrator.migrate(batchSize: 0),
        throwsArgumentError,
      );
      final report = await migrator.migrate();

      expect(report.profiles.sourceCount, 0);
      expect(report.businessSettings.sourceCount, 0);
      expect(report.isComplete, isTrue);
    });
  });
}

class _ProfileStorage implements ProfileStorage {
  final records = <String, ProfileRecord>{};

  @override
  Future<void> deleteForUser(String? userId) async {
    records.remove(userScopeKey(userId));
  }

  @override
  Future<List<ProfileRecord>> readAll() async => records.values.toList();

  @override
  Future<ProfileRecord?> readForUser(String? userId) async =>
      records[userScopeKey(userId)];

  @override
  Future<void> save(ProfileRecord record) async {
    records[userScopeKey(record.userId)] = record;
  }
}

class _BusinessSettingsStorage implements BusinessSettingsStorage {
  final records = <String, BusinessSettingsRecord>{};

  @override
  Future<List<BusinessSettingsRecord>> readAll() async =>
      records.values.toList();

  @override
  Future<BusinessSettingsRecord?> readForUser(String? userId) async =>
      records[userScopeKey(userId)];

  @override
  Future<void> save(BusinessSettingsRecord record) async {
    records[userScopeKey(record.userId)] = record;
  }
}

class _CheckpointStorage implements MigrationCheckpointStorage {
  final records = <String, MigrationCheckpoint>{};

  @override
  Future<MigrationCheckpoint?> read(String slice) async => records[slice];

  @override
  Future<void> save(MigrationCheckpoint checkpoint) async {
    records[checkpoint.slice] = checkpoint;
  }
}

ProfileRecord _profile({required String id, required String? userId}) =>
    ProfileRecord(
      id: id,
      email: '$id@example.test',
      displayName: id,
      avatarUrl: null,
      phoneNumber: null,
      userId: userId,
      syncStatus: 'pendingPush',
      serverUpdatedAt: DateTime.utc(2026, 8, 14),
      isDeleted: false,
    );

BusinessSettingsRecord _settings({
  required String id,
  required String? userId,
}) =>
    BusinessSettingsRecord(
      id: id,
      companyName: id,
      taxNumber: null,
      address: null,
      logoUrl: null,
      defaultTaxRate: 15,
      currencyCode: 'SAR',
      currencySymbol: 'ر.س',
      userId: userId,
      syncStatus: 'pendingPush',
      serverUpdatedAt: DateTime.utc(2026, 8, 14),
      isDeleted: false,
    );
