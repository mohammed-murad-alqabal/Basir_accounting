import 'dart:convert';

import 'package:basir_accounting_system/core/persistence/drift_settings_migration.dart';
import 'package:basir_accounting_system/core/persistence/drift_settings_parity.dart';
import 'package:basir_drift_storage/basir_drift_storage.dart';

/// لقطة معقمة لا ترتبط بقاعدة Isar التشغيلية.
class DriftSettingsSnapshot {
  const DriftSettingsSnapshot({
    required this.schemaVersion,
    required this.profiles,
    required this.businessSettings,
  });

  factory DriftSettingsSnapshot.fromJsonString(String source) =>
      DriftSettingsSnapshot.fromJson(
        jsonDecode(source) as Map<String, Object?>,
      );

  factory DriftSettingsSnapshot.fromJson(Map<String, Object?> json) {
    if (json['sanitized'] != true) {
      throw const FormatException('Snapshot must explicitly be sanitized.');
    }
    if (json['schemaVersion'] != 1) {
      throw FormatException(
        'Unsupported snapshot schema: ${json['schemaVersion']}.',
      );
    }

    return DriftSettingsSnapshot(
      schemaVersion: 1,
      profiles: _readList(json['profiles'], _profileFromJson),
      businessSettings: _readList(
        json['businessSettings'],
        _businessSettingsFromJson,
      ),
    );
  }

  final int schemaVersion;
  final List<ProfileRecord> profiles;
  final List<BusinessSettingsRecord> businessSettings;

  static List<T> _readList<T>(
    Object? value,
    T Function(Map<String, Object?> json) decode,
  ) {
    if (value is! List<Object?>) {
      throw const FormatException('Snapshot collection is missing.');
    }
    return value.map((item) {
      if (item is! Map<String, Object?>) {
        throw const FormatException('Snapshot record must be an object.');
      }
      return decode(item);
    }).toList(growable: false);
  }
}

/// نتيجة تشغيل offline؛ لا تحتفظ بقاعدة البيانات أو payload بعد الإغلاق.
class DriftSettingsSnapshotRunReport {
  const DriftSettingsSnapshotRunReport({
    required this.migration,
    required this.parity,
  });

  final DriftSettingsMigrationReport migration;
  final DriftSettingsParityReport parity;

  bool get isClean => migration.isComplete && parity.isClean;
}

/// يشغل snapshot معقمة داخل SQLite في الذاكرة فقط.
class DriftSettingsSnapshotRunner {
  Future<DriftSettingsSnapshotRunReport> run(
    DriftSettingsSnapshot snapshot, {
    required BasirDatabase Function() databaseFactory,
    int batchSize = 250,
  }) async {
    final database = databaseFactory();
    try {
      final profileStorage = ProfileStore(database);
      final businessSettingsStorage = BusinessSettingsStore(database);
      final checkpoints = LocalMetadataMigrationCheckpointStore(database);
      Future<List<ProfileRecord>> profileSource() async => snapshot.profiles;
      Future<List<BusinessSettingsRecord>> businessSettingsSource() async =>
          snapshot.businessSettings;

      final migration = await DriftSettingsMigrator(
        profileSource: profileSource,
        businessSettingsSource: businessSettingsSource,
        profileStorage: profileStorage,
        businessSettingsStorage: businessSettingsStorage,
        checkpoints: checkpoints,
      ).migrate(batchSize: batchSize);
      final parity = await DriftSettingsParityVerifier(
        profileSource: profileSource,
        businessSettingsSource: businessSettingsSource,
        profileStorage: profileStorage,
        businessSettingsStorage: businessSettingsStorage,
      ).verify();

      return DriftSettingsSnapshotRunReport(
        migration: migration,
        parity: parity,
      );
    } finally {
      await database.close();
    }
  }
}

ProfileRecord _profileFromJson(Map<String, Object?> json) => ProfileRecord(
      id: _requiredString(json, 'id'),
      email: _requiredString(json, 'email'),
      displayName: _optionalString(json, 'displayName'),
      avatarUrl: _optionalString(json, 'avatarUrl'),
      phoneNumber: _optionalString(json, 'phoneNumber'),
      userId: _optionalString(json, 'userId'),
      syncStatus: _requiredString(json, 'syncStatus'),
      serverUpdatedAt: _optionalDate(json, 'serverUpdatedAt'),
      isDeleted: _requiredBool(json, 'isDeleted'),
    );

BusinessSettingsRecord _businessSettingsFromJson(Map<String, Object?> json) =>
    BusinessSettingsRecord(
      id: _requiredString(json, 'id'),
      companyName: _requiredString(json, 'companyName'),
      taxNumber: _optionalString(json, 'taxNumber'),
      address: _optionalString(json, 'address'),
      logoUrl: _optionalString(json, 'logoUrl'),
      defaultTaxRate: _requiredNumber(json, 'defaultTaxRate'),
      currencyCode: _requiredString(json, 'currencyCode'),
      currencySymbol: _requiredString(json, 'currencySymbol'),
      userId: _optionalString(json, 'userId'),
      syncStatus: _requiredString(json, 'syncStatus'),
      serverUpdatedAt: _optionalDate(json, 'serverUpdatedAt'),
      isDeleted: _requiredBool(json, 'isDeleted'),
    );

String _requiredString(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value is! String || value.isEmpty) {
    throw FormatException('Snapshot field $key must be a non-empty string.');
  }
  return value;
}

String? _optionalString(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value == null) return null;
  if (value is! String) {
    throw FormatException('Snapshot field $key must be a string or null.');
  }
  return value;
}

DateTime? _optionalDate(Map<String, Object?> json, String key) {
  final value = _optionalString(json, key);
  if (value == null) return null;
  final parsed = DateTime.tryParse(value);
  if (parsed == null) throw FormatException('Snapshot field $key is invalid.');
  return parsed.toUtc();
}

bool _requiredBool(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value is! bool) {
    throw FormatException('Snapshot field $key must be boolean.');
  }
  return value;
}

double _requiredNumber(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value is num) return value.toDouble();
  throw FormatException('Snapshot field $key must be numeric.');
}
