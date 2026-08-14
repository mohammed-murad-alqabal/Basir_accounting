import 'package:basir_accounting_system/core/persistence/drift_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Drift rollout providers', () {
    test('keeps Isar as the safe default rollout stage', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(
        container.read(driftRolloutStageProvider),
        DriftRolloutStage.isarPrimary,
      );
    });

    test('reports readiness when the injected verifier succeeds', () async {
      final container = ProviderContainer(
        overrides: [
          driftConnectionVerifierProvider.overrideWithValue(_succeeds),
        ],
      );
      addTearDown(container.dispose);

      final readiness = await container.read(driftReadinessProvider.future);

      expect(readiness, isA<DriftReady>());
    });

    test('preserves a verifier failure as an unavailable readiness result',
        () async {
      final failure = StateError('sqlite unavailable');
      final container = ProviderContainer(
        overrides: [
          driftConnectionVerifierProvider.overrideWithValue(
            () => Future<void>.error(failure),
          ),
        ],
      );
      addTearDown(container.dispose);

      final readiness = await container.read(driftReadinessProvider.future);

      expect(readiness, isA<DriftUnavailable>());
      expect((readiness as DriftUnavailable).error, same(failure));
    });
  });
}

Future<void> _succeeds() async {}
