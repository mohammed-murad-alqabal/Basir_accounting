import 'package:basir_accounting_system/core/persistence/drift_settings_shadow_read.dart';
import 'package:basir_accounting_system/features/settings/domain/entities/business_settings.dart';
import 'package:basir_accounting_system/features/settings/domain/entities/profile.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final recordedAt = DateTime.utc(2026, 8, 14, 12);
  late InMemoryDriftShadowReadSink sink;
  late DriftSettingsShadowReadComparator comparator;

  setUp(() {
    sink = InMemoryDriftShadowReadSink();
    comparator = DriftSettingsShadowReadComparator(
      recorder: sink.record,
      clock: () => recordedAt,
    );
  });

  test('records a safe match event for equivalent profiles', () async {
    const profile = Profile(
      id: 'profile-a',
      email: 'user@example.test',
      userId: 'user-a',
    );

    final result = await comparator.compareProfile(
      operation: 'getProfile',
      sourceRead: () async => profile,
      candidateRead: () async => profile,
    );

    expect(result.matched, isTrue);
    expect(sink.events, hasLength(1));
    expect(sink.events.single.slice, 'profiles');
    expect(sink.events.single.operation, 'getProfile');
    expect(sink.events.single.outcome, DriftShadowReadOutcome.match);
    expect(sink.events.single.recordedAt, recordedAt);
  });

  test('records mismatch without returning candidate data', () async {
    final result = await comparator.compareBusinessSettings(
      operation: 'getSettings',
      sourceRead: () async => const BusinessSettings(
        id: 'settings-a',
        companyName: 'Source',
      ),
      candidateRead: () async => const BusinessSettings(
        id: 'settings-a',
        companyName: 'Candidate',
      ),
    );

    expect(result.outcome, DriftShadowReadOutcome.mismatch);
    expect(sink.events.single.slice, 'business-settings');
    expect(sink.events.single.operation, 'getSettings');
  });

  test('classifies source and candidate failures separately', () async {
    final sourceFailure = await comparator.compareProfile(
      operation: 'getProfile',
      sourceRead: () => Future<Profile?>.error(StateError('source-only')),
      candidateRead: () async => null,
    );
    final candidateFailure = await comparator.compareProfile(
      operation: 'getProfile',
      sourceRead: () async => null,
      candidateRead: () => Future<Profile?>.error(StateError('candidate-only')),
    );

    expect(sourceFailure.outcome, DriftShadowReadOutcome.sourceError);
    expect(candidateFailure.outcome, DriftShadowReadOutcome.candidateError);
    expect(
      sink.events.map((event) => event.outcome),
      [
        DriftShadowReadOutcome.sourceError,
        DriftShadowReadOutcome.candidateError,
      ],
    );
  });

  test('treats two absent records as a match', () async {
    final result = await comparator.compareProfile(
      operation: 'getProfile',
      sourceRead: () async => null,
      candidateRead: () async => null,
    );

    expect(result.outcome, DriftShadowReadOutcome.match);
  });
}
