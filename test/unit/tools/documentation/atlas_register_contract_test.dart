import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  const inventoryPath = 'docs/02-domain/atlas_screen_legacy_inventory.csv';
  const registerPath = 'docs/02-domain/ATLAS_FEATURE_REGISTER.md';
  const atlasPath =
      '.kiro/specs/active/basir_master_specification/08_FORENSIC_ATLAS_INDEX.md';

  test(
    'Atlas inventory represents every legacy screen ID from 001 through 099',
    () {
      final lines = File(inventoryPath)
          .readAsLinesSync()
          .where((line) => line.startsWith('FR-ATLAS-'))
          .toList();

      expect(lines, hasLength(99));

      final ids = lines
          .map(
            (line) => RegExp(r'^FR-ATLAS-(\d{3}),').firstMatch(line)!.group(1),
          )
          .toList();
      expect(
        ids,
        List<String>.generate(99, (index) => '${index + 1}'.padLeft(3, '0')),
      );
    },
  );

  test(
    'Atlas inventory retains observed duplicate and missing source conditions',
    () {
      final inventory = File(inventoryPath).readAsStringSync();

      expect(
        RegExp('DUPLICATE_LEGACY_REFERENCE').allMatches(inventory),
        hasLength(4),
      );
      expect(RegExp('MISSING_IN_ATLAS').allMatches(inventory), hasLength(8));
      expect(
        RegExp('EXTRACTED_FROM_ATLAS').allMatches(inventory),
        hasLength(87),
      );
    },
  );

  test(
    'legacy Atlas defers implementation status to the governed feature register',
    () {
      final atlas = File(atlasPath).readAsStringSync();
      final register = File(registerPath).readAsStringSync();

      expect(atlas, contains('ATLAS_FEATURE_REGISTER.md'));
      expect(atlas, contains('legacy claims'));
      expect(register, contains('REQ-UX-004'));
      expect(register, contains('FR-ATLAS-001'));
      expect(register, contains('FR-ATLAS-099'));
      expect(
        RegExp(r'\| FR-ATLAS-\d{3} .*\| COMPLETE \|').hasMatch(register),
        isFalse,
        reason: 'No Atlas feature can be complete without direct evidence.',
      );
    },
  );
}
