import 'dart:convert';
import 'dart:io';

import 'package:basir_accounting_system/core/persistence/drift_stock_movements_golden.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Map<String, dynamic> catalog;

  setUpAll(() {
    final source = File(
      'test/fixtures/stock_movements_blocked_payloads.json',
    ).readAsStringSync();
    catalog = jsonDecode(source) as Map<String, dynamic>;
  });

  test('catalog is sanitized and keeps four independent blocked cases', () {
    expect(catalog['sanitized'], isTrue);
    expect(catalog['fixtureVersion'], 1);
    expect(catalog['blockedCases'], hasLength(4));
  });

  test('each blocked payload fails at its declared parser stage', () {
    final cases = catalog['blockedCases'] as List<dynamic>;

    for (final item in cases) {
      final blocked = item as Map<String, dynamic>;
      final caseId = blocked['id'] as String;
      final expectedStage = blocked['expectedFailureStage'] as String;
      final expectedMessage = blocked['messageContains'] as String;
      final variants = blocked['payloadVariants'];
      final payloads = variants is List
          ? variants.map((variant) {
              final value = variant as Map<String, dynamic>;
              return (
                label: '$caseId/${value['variant']}',
                payload: value['payload'] as Map<String, dynamic>,
              );
            })
          : <({String label, Map<String, dynamic> payload})>[
              (
                label: caseId,
                payload: blocked['payload'] as Map<String, dynamic>,
              ),
            ];

      for (final entry in payloads) {
        Object? caught;
        try {
          StockMovementGoldenFixture.fromJson(
            entry.payload.map<String, Object?>(
              (key, value) => MapEntry(key, value),
            ),
          );
        } on Object catch (error) {
          caught = error;
        }

        expect(caught, isA<FormatException>(), reason: entry.label);
        final error = caught! as FormatException;
        expect(error.message, contains(expectedMessage), reason: entry.label);
        expect(
          _failureStage(error),
          expectedStage,
          reason: entry.label,
        );
      }
    }
  });
}

String _failureStage(FormatException error) {
  final message = error.message;
  if (message.contains('blocked standalone transfer type')) {
    return 'cleanContract';
  }
  return 'parser';
}
