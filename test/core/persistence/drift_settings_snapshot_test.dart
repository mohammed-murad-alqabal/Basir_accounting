import 'package:basir_accounting_system/core/persistence/drift_settings_snapshot.dart';
import 'package:basir_drift_storage/basir_drift_storage.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('runs a sanitized snapshot through SQLite and returns clean parity',
      () async {
    final snapshot = DriftSettingsSnapshot.fromJsonString(_validSnapshot);

    final report = await DriftSettingsSnapshotRunner().run(
      snapshot,
      databaseFactory: () => BasirDatabase(NativeDatabase.memory()),
      batchSize: 1,
    );

    expect(report.isClean, isTrue);
    expect(report.migration.profiles.sourceCount, 1);
    expect(report.migration.businessSettings.sourceCount, 1);
    expect(report.parity.profiles.matches, isTrue);
    expect(report.parity.businessSettings.matches, isTrue);
  });

  test('rejects snapshots that are not explicitly sanitized', () {
    expect(
      () => DriftSettingsSnapshot.fromJson({
        'sanitized': false,
        'schemaVersion': 1,
        'profiles': const [],
        'businessSettings': const [],
      }),
      throwsFormatException,
    );
  });

  test('rejects missing collections and invalid fields', () {
    expect(
      () => DriftSettingsSnapshot.fromJson({
        'sanitized': true,
        'schemaVersion': 1,
        'profiles': const [],
      }),
      throwsFormatException,
    );
    expect(
      () => DriftSettingsSnapshot.fromJsonString(_invalidProfileSnapshot),
      throwsFormatException,
    );
  });

  test('reports duplicate source scopes as a parity blocker', () async {
    final snapshot = DriftSettingsSnapshot.fromJsonString(
      _validSnapshot.replaceFirst(
        '"profile-a@example.test"',
        '"profile-b@example.test"',
      ),
    );

    final duplicate = DriftSettingsSnapshot(
      schemaVersion: snapshot.schemaVersion,
      profiles: [
        snapshot.profiles.single,
        ProfileRecord(
          id: 'profile-b',
          email: snapshot.profiles.single.email,
          displayName: snapshot.profiles.single.displayName,
          avatarUrl: snapshot.profiles.single.avatarUrl,
          phoneNumber: snapshot.profiles.single.phoneNumber,
          userId: snapshot.profiles.single.userId,
          syncStatus: snapshot.profiles.single.syncStatus,
          serverUpdatedAt: snapshot.profiles.single.serverUpdatedAt,
          isDeleted: snapshot.profiles.single.isDeleted,
        ),
      ],
      businessSettings: snapshot.businessSettings,
    );
    final report = await DriftSettingsSnapshotRunner().run(
      duplicate,
      databaseFactory: () => BasirDatabase(NativeDatabase.memory()),
    );

    expect(report.isClean, isFalse);
    expect(report.parity.ambiguousProfileScopes, hasLength(1));
  });
}

const _validSnapshot = '''
{
  "sanitized": true,
  "schemaVersion": 1,
  "profiles": [
    {
      "id": "profile-a",
      "email": "profile-a@example.test",
      "displayName": "Redacted A",
      "avatarUrl": null,
      "phoneNumber": null,
      "userId": "user-a-redacted",
      "syncStatus": "synced",
      "serverUpdatedAt": "2026-08-15T00:00:00Z",
      "isDeleted": false
    }
  ],
  "businessSettings": [
    {
      "id": "settings-a",
      "companyName": "Redacted Company",
      "taxNumber": null,
      "address": null,
      "logoUrl": null,
      "defaultTaxRate": 15,
      "currencyCode": "SAR",
      "currencySymbol": "ر.س",
      "userId": "user-a-redacted",
      "syncStatus": "synced",
      "serverUpdatedAt": "2026-08-15T00:00:00Z",
      "isDeleted": false
    }
  ]
}
''';

const _invalidProfileSnapshot = '''
{
  "sanitized": true,
  "schemaVersion": 1,
  "profiles": [
    {
      "id": "profile-a",
      "email": "",
      "syncStatus": "synced",
      "isDeleted": false
    }
  ],
  "businessSettings": []
}
''';
