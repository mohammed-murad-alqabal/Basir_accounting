import 'package:basir_accounting_system/features/settings/data/models/business_settings_model.dart';
import 'package:basir_accounting_system/features/settings/data/models/profile_model.dart';
import 'package:basir_drift_storage/basir_drift_storage.dart';
import 'package:isar/isar.dart';

/// شرائح الاستيراد المستقلة لموجة الإعدادات المقيدة بالمستخدم.
abstract final class DriftSettingsMigrationSlice {
  static const profiles = 'settings-profiles-v1';
  static const businessSettings = 'settings-business-settings-v1';
}

/// قارئ ملفات المستخدم في المصدر القديم، مفصول عن Isar لاختبارات المهاجر.
typedef ProfileMigrationReader = Future<List<ProfileRecord>> Function();

/// قارئ إعدادات العمل في المصدر القديم، مفصول عن Isar لاختبارات المهاجر.
typedef BusinessSettingsMigrationReader = Future<List<BusinessSettingsRecord>>
    Function();

/// قراءة ملفات المستخدم من Isar وتحويلها إلى DTO محايد بترتيب حتمي.
class IsarProfileMigrationSource {
  IsarProfileMigrationSource(this._isar);

  final Isar _isar;

  Future<List<ProfileRecord>> readAll() async {
    final records = (await _isar.profileModels.where().findAll())
        .map(_toRecord)
        .toList(growable: false)
      ..sort(_compareProfiles);
    return records;
  }

  static ProfileRecord _toRecord(ProfileModel model) => ProfileRecord(
        id: model.id,
        email: model.email,
        displayName: model.displayName,
        avatarUrl: model.avatarUrl,
        phoneNumber: model.phoneNumber,
        userId: model.userId,
        syncStatus: model.syncStatus.name,
        serverUpdatedAt: model.serverUpdatedAt?.toUtc(),
        isDeleted: model.isDeleted,
      );
}

/// قراءة إعدادات العمل من Isar وتحويلها إلى DTO محايد بترتيب حتمي.
class IsarBusinessSettingsMigrationSource {
  IsarBusinessSettingsMigrationSource(this._isar);

  final Isar _isar;

  Future<List<BusinessSettingsRecord>> readAll() async {
    final records = (await _isar.businessSettingsModels.where().findAll())
        .map(_toRecord)
        .toList(growable: false)
      ..sort(_compareBusinessSettings);
    return records;
  }

  static BusinessSettingsRecord _toRecord(BusinessSettingsModel model) =>
      BusinessSettingsRecord(
        id: model.id,
        companyName: model.companyName,
        taxNumber: model.taxNumber,
        address: model.address,
        logoUrl: model.logoUrl,
        defaultTaxRate: model.defaultTaxRate,
        currencyCode: model.currencyCode,
        currencySymbol: model.currencySymbol,
        userId: model.userId,
        syncStatus: model.syncStatus.name,
        serverUpdatedAt: model.serverUpdatedAt?.toUtc(),
        isDeleted: model.isDeleted,
      );
}

/// ناتج استيراد الموجة الثانية؛ لا يحتوي سجلات أعمال أو userIds.
class DriftSettingsMigrationReport {
  const DriftSettingsMigrationReport({
    required this.profiles,
    required this.businessSettings,
  });

  final MigrationCheckpoint profiles;
  final MigrationCheckpoint businessSettings;

  bool get isComplete => profiles.isComplete && businessSettings.isComplete;
}

/// يستورد Profile وBusinessSettings إلى Drift بصورة idempotent.
///
/// Isar مصدر قراءة فقط، وDrift هدف كتابة فقط. لا يسجّل هذا الكائن في Riverpod
/// ولا ينفذ تلقائيًا ضمن التطبيق؛ تشغيله يتطلب استدعاءً صريحًا في بيئة معتمدة.
class DriftSettingsMigrator {
  DriftSettingsMigrator({
    required ProfileMigrationReader profileSource,
    required BusinessSettingsMigrationReader businessSettingsSource,
    required ProfileStorage profileStorage,
    required BusinessSettingsStorage businessSettingsStorage,
    required MigrationCheckpointStorage checkpoints,
  })  : _profileSource = profileSource,
        _businessSettingsSource = businessSettingsSource,
        _profileStorage = profileStorage,
        _businessSettingsStorage = businessSettingsStorage,
        _checkpoints = checkpoints;

  final ProfileMigrationReader _profileSource;
  final BusinessSettingsMigrationReader _businessSettingsSource;
  final ProfileStorage _profileStorage;
  final BusinessSettingsStorage _businessSettingsStorage;
  final MigrationCheckpointStorage _checkpoints;

  Future<DriftSettingsMigrationReport> migrate({int batchSize = 250}) async {
    if (batchSize <= 0) {
      throw ArgumentError.value(batchSize, 'batchSize', 'Must be positive.');
    }

    final profiles = await _migrateProfiles(batchSize: batchSize);
    final businessSettings =
        await _migrateBusinessSettings(batchSize: batchSize);
    return DriftSettingsMigrationReport(
      profiles: profiles,
      businessSettings: businessSettings,
    );
  }

  Future<MigrationCheckpoint> _migrateProfiles({required int batchSize}) async {
    final records = await _profileSource();
    return _writeBatches<ProfileRecord>(
      slice: DriftSettingsMigrationSlice.profiles,
      records: records,
      batchSize: batchSize,
      write: _profileStorage.save,
    );
  }

  Future<MigrationCheckpoint> _migrateBusinessSettings({
    required int batchSize,
  }) async {
    final records = await _businessSettingsSource();
    return _writeBatches<BusinessSettingsRecord>(
      slice: DriftSettingsMigrationSlice.businessSettings,
      records: records,
      batchSize: batchSize,
      write: _businessSettingsStorage.save,
    );
  }

  Future<MigrationCheckpoint> _writeBatches<T>({
    required String slice,
    required List<T> records,
    required int batchSize,
    required Future<void> Function(T record) write,
  }) async {
    var migratedCount = 0;
    for (var start = 0; start < records.length; start += batchSize) {
      final end = start + batchSize < records.length
          ? start + batchSize
          : records.length;
      for (final record in records.sublist(start, end)) {
        await write(record);
        migratedCount += 1;
      }
      await _saveCheckpoint(
        slice: slice,
        sourceCount: records.length,
        migratedCount: migratedCount,
      );
    }

    final checkpoint = MigrationCheckpoint(
      slice: slice,
      sourceCount: records.length,
      migratedCount: migratedCount,
      completedAt: DateTime.now().toUtc(),
    );
    await _checkpoints.save(checkpoint);
    return checkpoint;
  }

  Future<void> _saveCheckpoint({
    required String slice,
    required int sourceCount,
    required int migratedCount,
  }) =>
      _checkpoints.save(
        MigrationCheckpoint(
          slice: slice,
          sourceCount: sourceCount,
          migratedCount: migratedCount,
          completedAt: null,
        ),
      );
}

int _compareProfiles(ProfileRecord left, ProfileRecord right) {
  final scope = userScopeKey(left.userId).compareTo(userScopeKey(right.userId));
  if (scope != 0) return scope;
  return left.id.compareTo(right.id);
}

int _compareBusinessSettings(
  BusinessSettingsRecord left,
  BusinessSettingsRecord right,
) {
  final scope = userScopeKey(left.userId).compareTo(userScopeKey(right.userId));
  if (scope != 0) return scope;
  return left.id.compareTo(right.id);
}
