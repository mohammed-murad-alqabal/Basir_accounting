import 'package:basir_accounting_system/core/persistence/drift_settings_shadow_read.dart';
import 'package:basir_accounting_system/features/settings/domain/entities/business_settings.dart';
import 'package:basir_accounting_system/features/settings/domain/entities/profile.dart';
import 'package:basir_accounting_system/features/settings/domain/repositories/business_settings_repository.dart';
import 'package:basir_accounting_system/features/settings/domain/repositories/profile_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final recordedAt = DateTime.utc(2026, 8, 15, 9);

  test('closed Profile flag does not invoke candidate or recorder', () async {
    final source = _ProfileRepository(
      value: const Profile(id: 'source', email: 'source@test'),
    );
    final candidate = _ProfileRepository(
      value: const Profile(id: 'candidate', email: 'candidate@test'),
    );
    final sink = InMemoryDriftShadowReadSink();
    final repository = ShadowReadProfileRepository(
      source: source,
      candidate: candidate,
      comparator: DriftSettingsShadowReadComparator(
        recorder: sink.record,
        clock: () => recordedAt,
      ),
      enabled: false,
    );

    final result = await repository.getProfile();

    expect(result?.id, 'source');
    expect(candidate.readCount, 0);
    expect(sink.events, isEmpty);
  });

  test('enabled Profile shadow-read returns source and records candidate match',
      () async {
    const profile = Profile(id: 'same', email: 'same@test');
    final source = _ProfileRepository(value: profile);
    final candidate = _ProfileRepository(value: profile);
    final sink = InMemoryDriftShadowReadSink();
    final repository = ShadowReadProfileRepository(
      source: source,
      candidate: candidate,
      comparator: DriftSettingsShadowReadComparator(
        recorder: sink.record,
        clock: () => recordedAt,
      ),
      enabled: true,
    );

    final result = await repository.getProfile();

    expect(result, profile);
    expect(candidate.readCount, 1);
    expect(sink.events.single.outcome, DriftShadowReadOutcome.match);
  });

  test('BusinessSettings shadow-read preserves source on mismatch', () async {
    final source = _BusinessSettingsRepository(
      value: const BusinessSettings(id: 'settings', companyName: 'Source'),
    );
    final candidate = _BusinessSettingsRepository(
      value: const BusinessSettings(id: 'settings', companyName: 'Candidate'),
    );
    final sink = InMemoryDriftShadowReadSink();
    final repository = ShadowReadBusinessSettingsRepository(
      source: source,
      candidate: candidate,
      comparator: DriftSettingsShadowReadComparator(
        recorder: sink.record,
        clock: () => recordedAt,
      ),
      enabled: true,
    );

    final result = await repository.getSettings();

    expect(result?.companyName, 'Source');
    expect(candidate.readCount, 1);
    expect(sink.events.single.outcome, DriftShadowReadOutcome.mismatch);
  });

  test('shadow decorators delegate writes only to Isar source', () async {
    final profileSource = _ProfileRepository();
    final profileCandidate = _ProfileRepository();
    final settingsSource = _BusinessSettingsRepository();
    final settingsCandidate = _BusinessSettingsRepository();
    final sink = InMemoryDriftShadowReadSink();
    final comparator = DriftSettingsShadowReadComparator(
      recorder: sink.record,
      clock: () => recordedAt,
    );
    final profileRepository = ShadowReadProfileRepository(
      source: profileSource,
      candidate: profileCandidate,
      comparator: comparator,
      enabled: true,
    );
    final settingsRepository = ShadowReadBusinessSettingsRepository(
      source: settingsSource,
      candidate: settingsCandidate,
      comparator: comparator,
      enabled: true,
    );

    await profileRepository.saveProfile(
      const Profile(id: 'p', email: 'p@test'),
    );
    await settingsRepository.saveSettings(
      const BusinessSettings(id: 's', companyName: 'S'),
    );

    expect(profileSource.writeCount, 1);
    expect(profileCandidate.writeCount, 0);
    expect(settingsSource.writeCount, 1);
    expect(settingsCandidate.writeCount, 0);
  });
}

class _ProfileRepository implements ProfileRepository {
  _ProfileRepository({this.value});

  Profile? value;
  int readCount = 0;
  int writeCount = 0;

  @override
  Future<Profile?> getProfile() async {
    readCount += 1;
    return value;
  }

  @override
  Future<void> saveProfile(Profile profile) async {
    writeCount += 1;
    value = profile;
  }

  @override
  Future<void> deleteProfile() async {
    writeCount += 1;
    value = null;
  }
}

class _BusinessSettingsRepository implements BusinessSettingsRepository {
  _BusinessSettingsRepository({this.value});

  BusinessSettings? value;
  int readCount = 0;
  int writeCount = 0;

  @override
  Future<BusinessSettings?> getSettings() async {
    readCount += 1;
    return value;
  }

  @override
  Future<void> saveSettings(BusinessSettings settings) async {
    writeCount += 1;
    value = settings;
  }
}
