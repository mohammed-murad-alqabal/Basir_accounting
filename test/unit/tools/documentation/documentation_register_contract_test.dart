import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'documentation register and historical banners satisfy BKIP P4 contract',
    () {
      final register = File('docs/00-governance/DOCUMENTATION_REGISTER.md');
      final migrationPlan = File(
        'docs/audits/bkip-2026-08/P4_DOCUMENTATION_MIGRATION_PLAN_2026-08.md',
      );
      final historicalDocuments = <File>[
        File('.kiro/FINAL_STATUS.md'),
        File('.kiro/BLUEPRINT_STATUS.md'),
        File('docs/status/PROJECT_STATUS.md'),
      ];

      expect(register.existsSync(), isTrue);
      expect(migrationPlan.existsSync(), isTrue);

      final registerText = register.readAsStringSync();
      expect(registerText, contains('**document_id:** GOV-DOC-001'));
      expect(registerText, contains('**status:** DRAFT'));
      expect(
        registerText,
        contains(
          '**last_verified_sha:** `93df611433a62f7935e7aa622d3741c2bb1869d6`',
        ),
      );
      expect(registerText, contains('لا يحذف هذا السجل'));

      final migrationText = migrationPlan.readAsStringSync();
      expect(migrationText, contains('MOVE'));
      expect(migrationText, contains('MERGE'));
      expect(migrationText, contains('ARCHIVE'));
      expect(migrationText, contains('خطة هجرة وليست تصريح حذف'));

      for (final document in historicalDocuments) {
        expect(document.existsSync(), isTrue);
        final text = document.readAsStringSync();
        expect(text, contains('historical_as_of_date'));
        expect(text, contains('historical_as_of_sha'));
        expect(text, contains('**not_current_source_of_truth:** true'));
      }
    },
  );
}
