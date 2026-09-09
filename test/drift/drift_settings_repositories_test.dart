import 'package:basir_accounting_system/core/models/sync_status.dart';
import 'package:basir_accounting_system/features/settings/data/repositories/drift_business_settings_repository.dart';
import 'package:basir_accounting_system/features/settings/data/repositories/drift_profile_repository.dart';
import 'package:basir_accounting_system/features/settings/domain/entities/business_settings.dart';
import 'package:basir_accounting_system/features/settings/domain/entities/profile.dart';
import 'package:basir_drift_storage/basir_drift_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DriftProfileRepository', () {
    late _ProfileStorage storage;
    late DriftProfileRepository repository;

    setUp(() {
      storage = _ProfileStorage();
      repository =
          DriftProfileRepository.withStorage(storage, userId: 'user-a');
    });

    test('forces the repository user scope when saving a profile', () async {
      await repository.saveProfile(
        const Profile(
          id: 'profile-a',
          email: 'user@example.test',
          userId: 'incorrect-user',
          syncStatus: SyncStatus.pendingPush,
        ),
      );

      final saved = storage.saved.single;
      expect(saved.userId, 'user-a');
      expect(saved.syncStatus, 'pendingPush');
    });

    test('maps a stored profile and deletes using only the scoped user',
        () async {
      storage.records['user-a'] = _profileRecord(userId: 'user-a');

      final profile = await repository.getProfile();
      await repository.deleteProfile();

      expect(profile?.email, 'user@example.test');
      expect(profile?.syncStatus, SyncStatus.conflict);
      expect(storage.deletedUsers, ['user-a']);
    });
  });

  group('DriftBusinessSettingsRepository', () {
    late _BusinessSettingsStorage storage;
    late DriftBusinessSettingsRepository repository;

    setUp(() {
      storage = _BusinessSettingsStorage();
      repository = DriftBusinessSettingsRepository.withStorage(
        storage,
        userId: 'user-a',
      );
    });

    test('forces repository scope while preserving business settings fields',
        () async {
      await repository.saveSettings(
        const BusinessSettings(
          id: 'settings-a',
          companyName: 'Basir Test',
          userId: 'incorrect-user',
          defaultTaxRate: 5,
          currencyCode: 'USD',
          currencySymbol: r'$',
          syncStatus: SyncStatus.pendingPull,
        ),
      );

      final saved = storage.saved.single;
      expect(saved.userId, 'user-a');
      expect(saved.defaultTaxRate, 5);
      expect(saved.currencyCode, 'USD');
      expect(saved.syncStatus, 'pendingPull');
    });

    test('maps all persisted fields back to the domain entity', () async {
      storage.records['user-a'] = _settingsRecord(userId: 'user-a');

      final settings = await repository.getSettings();

      expect(settings?.id, 'settings-a');
      expect(settings?.companyName, 'Basir Test');
      expect(settings?.isDeleted, isTrue);
      expect(settings?.syncStatus, SyncStatus.conflict);
    });
  });
}

class _ProfileStorage implements ProfileStorage {
  final records = <String?, ProfileRecord>{};
  final saved = <ProfileRecord>[];
  final deletedUsers = <String?>[];

  @override
  Future<void> deleteForUser(String? userId) async {
    deletedUsers.add(userId);
    records.remove(userId);
  }

  @override
  Future<ProfileRecord?> readForUser(String? userId) async => records[userId];

  @override
  Future<List<ProfileRecord>> readAll() async => records.values.toList();

  @override
  Future<void> save(ProfileRecord record) async {
    saved.add(record);
    records[record.userId] = record;
  }
}

class _BusinessSettingsStorage implements BusinessSettingsStorage {
  final records = <String?, BusinessSettingsRecord>{};
  final saved = <BusinessSettingsRecord>[];

  @override
  Future<BusinessSettingsRecord?> readForUser(String? userId) async =>
      records[userId];

  @override
  Future<List<BusinessSettingsRecord>> readAll() async =>
      records.values.toList();

  @override
  Future<void> save(BusinessSettingsRecord record) async {
    saved.add(record);
    records[record.userId] = record;
  }
}

ProfileRecord _profileRecord({required String? userId}) => ProfileRecord(
      id: 'profile-a',
      email: 'user@example.test',
      displayName: 'User A',
      avatarUrl: null,
      phoneNumber: '+966500000000',
      userId: userId,
      syncStatus: 'conflict',
      serverUpdatedAt: DateTime.utc(2026, 8, 14),
      isDeleted: false,
    );

BusinessSettingsRecord _settingsRecord({required String? userId}) =>
    BusinessSettingsRecord(
      id: 'settings-a',
      companyName: 'Basir Test',
      taxNumber: '300000000000003',
      address: 'Riyadh',
      logoUrl: null,
      defaultTaxRate: 15,
      currencyCode: 'SAR',
      currencySymbol: 'ر.س',
      userId: userId,
      syncStatus: 'conflict',
      serverUpdatedAt: DateTime.utc(2026, 8, 14),
      isDeleted: true,
    );
