import 'package:basir_accounting_system/core/persistence/drift_settings_parity.dart';
import 'package:basir_drift_storage/basir_drift_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DriftSettingsParityVerifier', () {
    test('reports clean parity for matching user-scoped snapshots', () async {
      final profiles = [_profile(id: 'profile-a', userId: 'user-a')];
      final businessSettings = [_settings(id: 'settings-a', userId: 'user-a')];

      final report = await _verifier(
        profiles: profiles,
        businessSettings: businessSettings,
        profileStorage: _ProfileStorage(profiles),
        businessSettingsStorage: _BusinessSettingsStorage(businessSettings),
      ).verify();

      expect(report.isClean, isTrue);
      expect(report.profiles.matches, isTrue);
      expect(report.businessSettings.matches, isTrue);
      expect(report.ambiguousProfileScopes, isEmpty);
      expect(report.ambiguousBusinessSettingsScopes, isEmpty);
    });

    test('detects a stale extra Drift record without exposing its user id',
        () async {
      final profiles = [_profile(id: 'profile-a', userId: 'user-a')];
      final report = await _verifier(
        profiles: profiles,
        businessSettings: const [],
        profileStorage: _ProfileStorage([
          ...profiles,
          _profile(id: 'profile-stale', userId: 'user-stale'),
        ]),
        businessSettingsStorage: _BusinessSettingsStorage(const []),
      ).verify();

      expect(report.isClean, isFalse);
      expect(report.profiles.actualCount, 2);
      expect(report.profiles.expectedCount, 1);
      expect(report.profiles.scope, 'settings/profiles/all');
    });

    test(
        'blocks progression when Isar contains duplicate records for one scope',
        () async {
      final duplicateProfiles = [
        _profile(id: 'profile-a1', userId: 'user-a'),
        _profile(id: 'profile-a2', userId: 'user-a'),
      ];
      final duplicateBusinessSettings = [
        _settings(id: 'settings-a1', userId: 'user-a'),
        _settings(id: 'settings-a2', userId: 'user-a'),
      ];

      final report = await _verifier(
        profiles: duplicateProfiles,
        businessSettings: duplicateBusinessSettings,
        profileStorage: _ProfileStorage([duplicateProfiles.last]),
        businessSettingsStorage: _BusinessSettingsStorage([
          duplicateBusinessSettings.last,
        ]),
      ).verify();

      expect(report.isClean, isFalse);
      expect(report.ambiguousProfileScopes, hasLength(1));
      expect(report.ambiguousBusinessSettingsScopes, hasLength(1));
      expect(report.ambiguousProfileScopes.single, isNot('user-a'));
      expect(report.ambiguousBusinessSettingsScopes.single, isNot('user-a'));
    });
  });
}

DriftSettingsParityVerifier _verifier({
  required List<ProfileRecord> profiles,
  required List<BusinessSettingsRecord> businessSettings,
  required ProfileStorage profileStorage,
  required BusinessSettingsStorage businessSettingsStorage,
}) =>
    DriftSettingsParityVerifier(
      profileSource: () async => profiles,
      businessSettingsSource: () async => businessSettings,
      profileStorage: profileStorage,
      businessSettingsStorage: businessSettingsStorage,
    );

class _ProfileStorage implements ProfileStorage {
  _ProfileStorage(this.records);

  final List<ProfileRecord> records;

  @override
  Future<void> deleteForUser(String? userId) async {}

  @override
  Future<List<ProfileRecord>> readAll() async => List.of(records);

  @override
  Future<ProfileRecord?> readForUser(String? userId) async => null;

  @override
  Future<void> save(ProfileRecord record) async {}
}

class _BusinessSettingsStorage implements BusinessSettingsStorage {
  _BusinessSettingsStorage(this.records);

  final List<BusinessSettingsRecord> records;

  @override
  Future<List<BusinessSettingsRecord>> readAll() async => List.of(records);

  @override
  Future<BusinessSettingsRecord?> readForUser(String? userId) async => null;

  @override
  Future<void> save(BusinessSettingsRecord record) async {}
}

ProfileRecord _profile({required String id, required String? userId}) =>
    ProfileRecord(
      id: id,
      email: '$id@example.test',
      displayName: null,
      avatarUrl: null,
      phoneNumber: null,
      userId: userId,
      syncStatus: 'synced',
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
      syncStatus: 'synced',
      serverUpdatedAt: DateTime.utc(2026, 8, 14),
      isDeleted: false,
    );
