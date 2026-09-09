import 'dart:io';

import 'package:basir_accounting_system/core/models/sync_status.dart';
import 'package:basir_accounting_system/core/persistence/drift_settings_migration.dart';
import 'package:basir_accounting_system/core/persistence/drift_settings_parity.dart';
import 'package:basir_accounting_system/features/settings/data/models/business_settings_model.dart';
import 'package:basir_accounting_system/features/settings/data/models/profile_model.dart';
import 'package:basir_drift_storage/basir_drift_storage.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';

void main() {
  late Directory temporaryDirectory;
  late Isar isar;
  late BasirDatabase driftDatabase;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
  });

  setUp(() async {
    temporaryDirectory = await Directory.systemTemp.createTemp(
      'basir-drift-settings-',
    );
    isar = await Isar.open(
      [ProfileModelSchema, BusinessSettingsModelSchema],
      directory: temporaryDirectory.path,
      name: 'settings-source',
    );
    driftDatabase = BasirDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await driftDatabase.close();
    await isar.close(deleteFromDisk: true);
    if (temporaryDirectory.existsSync()) {
      await temporaryDirectory.delete(recursive: true);
    }
  });

  test('migrates user-scoped settings and verifies parity end to end',
      () async {
    await isar.writeTxn(() async {
      await isar.profileModels.putAll([
        _profile(id: 'profile-a', userId: 'user-a'),
        _profile(id: 'profile-b', userId: 'user-b'),
      ]);
      await isar.businessSettingsModels.putAll([
        _settings(id: 'settings-a', userId: 'user-a'),
        _settings(id: 'settings-b', userId: 'user-b'),
      ]);
    });

    final profileSource = IsarProfileMigrationSource(isar);
    final businessSettingsSource = IsarBusinessSettingsMigrationSource(isar);
    final profileStorage = ProfileStore(driftDatabase);
    final businessSettingsStorage = BusinessSettingsStore(driftDatabase);
    final checkpoints = LocalMetadataMigrationCheckpointStore(driftDatabase);

    final migration = await DriftSettingsMigrator(
      profileSource: profileSource.readAll,
      businessSettingsSource: businessSettingsSource.readAll,
      profileStorage: profileStorage,
      businessSettingsStorage: businessSettingsStorage,
      checkpoints: checkpoints,
    ).migrate(batchSize: 1);
    final parity = await DriftSettingsParityVerifier(
      profileSource: profileSource.readAll,
      businessSettingsSource: businessSettingsSource.readAll,
      profileStorage: profileStorage,
      businessSettingsStorage: businessSettingsStorage,
    ).verify();

    expect(migration.isComplete, isTrue);
    expect(parity.isClean, isTrue);
    expect(
      (await checkpoints.read(DriftSettingsMigrationSlice.profiles))
          ?.isComplete,
      isTrue,
    );
    expect(
      (await checkpoints.read(DriftSettingsMigrationSlice.businessSettings))
          ?.isComplete,
      isTrue,
    );
    expect((await profileStorage.readForUser('user-a'))?.id, 'profile-a');
    expect(
      (await businessSettingsStorage.readForUser('user-b'))?.id,
      'settings-b',
    );
    expect(await isar.profileModels.count(), 2);
    expect(await isar.businessSettingsModels.count(), 2);
  });
}

ProfileModel _profile({required String id, required String userId}) =>
    ProfileModel()
      ..id = id
      ..email = '$id@example.test'
      ..displayName = id
      ..avatarUrl = null
      ..phoneNumber = '+966500000000'
      ..userId = userId
      ..syncStatus = SyncStatus.pendingPush
      ..serverUpdatedAt = DateTime.utc(2026, 8, 14)
      ..isDeleted = false;

BusinessSettingsModel _settings({
  required String id,
  required String userId,
}) =>
    BusinessSettingsModel()
      ..id = id
      ..companyName = id
      ..taxNumber = '300000000000003'
      ..address = 'Riyadh'
      ..logoUrl = null
      ..defaultTaxRate = 15
      ..currencyCode = 'SAR'
      ..currencySymbol = 'ر.س'
      ..userId = userId
      ..syncStatus = SyncStatus.pendingPull
      ..serverUpdatedAt = DateTime.utc(2026, 8, 14)
      ..isDeleted = false;
