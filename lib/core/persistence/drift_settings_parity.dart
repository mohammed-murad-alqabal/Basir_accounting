import 'dart:convert';

import 'package:basir_accounting_system/core/persistence/drift_settings_migration.dart';
import 'package:basir_drift_storage/basir_drift_storage.dart';

/// نتيجة تكافؤ دون تسجيل قيم الأعمال أو userIds في التقرير التشخيصي.
class DriftSettingsParityComparison {
  const DriftSettingsParityComparison({
    required this.scope,
    required this.expectedCount,
    required this.actualCount,
    required this.expectedFingerprint,
    required this.actualFingerprint,
  });

  final String scope;
  final int expectedCount;
  final int actualCount;
  final String expectedFingerprint;
  final String actualFingerprint;

  bool get matches =>
      expectedCount == actualCount && expectedFingerprint == actualFingerprint;
}

/// تقرير parity للموجة الثانية. تمنع النطاقات الغامضة التقدم إلى shadow-read
/// لأن سلوك Isar التاريخي يسمح بأكثر من سجل لنطاق مستخدم واحد.
class DriftSettingsParityReport {
  const DriftSettingsParityReport({
    required this.profiles,
    required this.businessSettings,
    required this.ambiguousProfileScopes,
    required this.ambiguousBusinessSettingsScopes,
  });

  final DriftSettingsParityComparison profiles;
  final DriftSettingsParityComparison businessSettings;
  final List<String> ambiguousProfileScopes;
  final List<String> ambiguousBusinessSettingsScopes;

  bool get isClean =>
      profiles.matches &&
      businessSettings.matches &&
      ambiguousProfileScopes.isEmpty &&
      ambiguousBusinessSettingsScopes.isEmpty;
}

/// يقارن لقطة Isar مع Drift بعد استيراد الموجة الثانية.
///
/// الأداة قراءة فقط: لا تنفذ import، ولا تسجل Providers، ولا تعالج الاختلافات
/// تلقائيًا. البصمات تشخيصية 32-bit وليست آلية أمنية أو مصادقة للبيانات.
class DriftSettingsParityVerifier {
  DriftSettingsParityVerifier({
    required ProfileMigrationReader profileSource,
    required BusinessSettingsMigrationReader businessSettingsSource,
    required ProfileStorage profileStorage,
    required BusinessSettingsStorage businessSettingsStorage,
  })  : _profileSource = profileSource,
        _businessSettingsSource = businessSettingsSource,
        _profileStorage = profileStorage,
        _businessSettingsStorage = businessSettingsStorage;

  final ProfileMigrationReader _profileSource;
  final BusinessSettingsMigrationReader _businessSettingsSource;
  final ProfileStorage _profileStorage;
  final BusinessSettingsStorage _businessSettingsStorage;

  Future<DriftSettingsParityReport> verify() async {
    final sourceProfiles = await _profileSource();
    final sourceBusinessSettings = await _businessSettingsSource();
    final actualProfiles = await _profileStorage.readAll();
    final actualBusinessSettings = await _businessSettingsStorage.readAll();

    return DriftSettingsParityReport(
      profiles: _comparison(
        scope: 'settings/profiles/all',
        expected:
            _sortedProfiles(sourceProfiles).map(_canonicalProfile).toList(),
        actual: _sortedProfiles(actualProfiles).map(_canonicalProfile).toList(),
      ),
      businessSettings: _comparison(
        scope: 'settings/business-settings/all',
        expected: _sortedBusinessSettings(sourceBusinessSettings)
            .map(_canonicalBusinessSettings)
            .toList(),
        actual: _sortedBusinessSettings(actualBusinessSettings)
            .map(_canonicalBusinessSettings)
            .toList(),
      ),
      ambiguousProfileScopes: _ambiguousScopes(
        sourceProfiles.map((record) => record.userId),
      ),
      ambiguousBusinessSettingsScopes: _ambiguousScopes(
        sourceBusinessSettings.map((record) => record.userId),
      ),
    );
  }

  static DriftSettingsParityComparison _comparison({
    required String scope,
    required List<String> expected,
    required List<String> actual,
  }) =>
      DriftSettingsParityComparison(
        scope: scope,
        expectedCount: expected.length,
        actualCount: actual.length,
        expectedFingerprint: _fingerprint(expected),
        actualFingerprint: _fingerprint(actual),
      );

  static List<ProfileRecord> _sortedProfiles(List<ProfileRecord> records) =>
      [...records]..sort(_compareProfiles);

  static List<BusinessSettingsRecord> _sortedBusinessSettings(
    List<BusinessSettingsRecord> records,
  ) =>
      [...records]..sort(_compareBusinessSettings);

  static List<String> _ambiguousScopes(Iterable<String?> userIds) {
    final counts = <String, int>{};
    for (final userId in userIds) {
      final scope = userScopeKey(userId);
      counts.update(scope, (count) => count + 1, ifAbsent: () => 1);
    }
    return counts.entries
        .where((entry) => entry.value > 1)
        .map((entry) => _fingerprint([entry.key]))
        .toList(growable: false)
      ..sort();
  }
}

String _canonicalProfile(ProfileRecord record) => [
      record.id,
      record.email,
      _nullable(record.displayName),
      _nullable(record.avatarUrl),
      _nullable(record.phoneNumber),
      _nullable(record.userId),
      record.syncStatus,
      _nullableDate(record.serverUpdatedAt),
      record.isDeleted.toString(),
    ].join('\u0000');

String _canonicalBusinessSettings(BusinessSettingsRecord record) => [
      record.id,
      record.companyName,
      _nullable(record.taxNumber),
      _nullable(record.address),
      _nullable(record.logoUrl),
      record.defaultTaxRate.toStringAsPrecision(17),
      record.currencyCode,
      record.currencySymbol,
      _nullable(record.userId),
      record.syncStatus,
      _nullableDate(record.serverUpdatedAt),
      record.isDeleted.toString(),
    ].join('\u0000');

String _nullable(String? value) => value == null ? '\u0001' : '\u0002$value';

String _nullableDate(DateTime? value) =>
    value == null ? '\u0001' : value.toUtc().toIso8601String();

String _fingerprint(List<String> values) {
  var hash = 0x811c9dc5;
  for (final value in values) {
    for (final byte in utf8.encode(value)) {
      hash = ((hash * 31) + byte).toUnsigned(32);
    }
    hash = ((hash * 31) + 0xff).toUnsigned(32);
  }
  return hash.toRadixString(16).padLeft(8, '0');
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
