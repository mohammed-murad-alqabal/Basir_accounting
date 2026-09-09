import 'dart:io';

import 'package:basir_accounting_system/core/persistence/drift_snapshot_preflight.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late String cleanFixtureSource;

  setUpAll(() {
    cleanFixtureSource = File(
      'test/fixtures/stock_movements_golden_fixtures.json',
    ).readAsStringSync();
  });

  test('accepts sanitized golden catalog with safe counters', () {
    final report = DriftSnapshotPreflight.validate(cleanFixtureSource);

    expect(report.isValid, isTrue);
    expect(report.sanitized, isTrue);
    expect(report.fixtureVersion, 1);
    expect(report.cleanFixtureCount, 6);
    expect(report.blockedFixtureCount, 4);
    expect(report.toSafeJson(), isNot(contains('user-')));
  });

  test('rejects secret patterns without returning their values', () {
    final secret = 'ghp_' + '123456789012345678901234';
    final source = '{"sanitized":true,"token":"$secret"}';

    final report = DriftSnapshotPreflight.validate(source);

    expect(report.isValid, isFalse);
    expect(report.failure, DriftSnapshotPreflightFailure.secretPattern);
    expect(report.toSafeJson().toString(), isNot(contains('ghp_')));
  });

  test('rejects an unsanitized catalog before parsing rows', () {
    const source = '{"sanitized":false,"fixtureVersion":1}';

    final report = DriftSnapshotPreflight.validate(source);

    expect(report.isValid, isFalse);
    expect(report.failure, DriftSnapshotPreflightFailure.invalidCatalog);
  });

  test('rejects malformed JSON without exposing source content', () {
    const source = '{"sanitized":true,INVALID_SECRET_VALUE';

    final report = DriftSnapshotPreflight.validate(source);

    expect(report.isValid, isFalse);
    expect(report.failure, DriftSnapshotPreflightFailure.invalidJson);
    expect(report.toSafeJson().toString(), isNot(contains('INVALID_SECRET')));
  });
}
