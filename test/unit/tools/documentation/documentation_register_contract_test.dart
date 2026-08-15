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
      expect(
        migrationText,
        contains('لا تنفذ أي `git mv` أو `MERGE` أو حذف أو إعادة تصنيف نهائي'),
      );
      expect(migrationText, contains('22 رابطًا صالحًا و8 روابط مكسورة'));
      expect(migrationText, contains('`KEEP`: pointer تشغيلي'));
      expect(migrationText, contains('`KEEP` للجذري؛ لا حذف'));

      final decisionRows = migrationText
          .split('\n')
          .where(
            (line) =>
                RegExp(
                  r'\| `(MOVE|ARCHIVE|MERGE|RECLASSIFY)-P4-[0-9]+`',
                ).hasMatch(line) &&
                (line.contains('PENDING_REVIEW') ||
                    line.contains('KEEP_APPROVED')),
          )
          .toList();
      expect(decisionRows, hasLength(9));
      final pendingRows =
          decisionRows.where((row) => row.contains('PENDING_REVIEW')).toList();
      expect(pendingRows, hasLength(7));
      for (final row in pendingRows) {
        expect(row, isNot(contains('APPROVED')));
        expect(row, isNot(contains('CANONICAL-ACTIVE')));
      }

      final keepRows =
          decisionRows.where((row) => row.contains('KEEP_APPROVED')).toList();
      expect(keepRows, hasLength(2));
      expect(keepRows.any((row) => row.contains('MERGE-P4-003')), isTrue);
      expect(keepRows.any((row) => row.contains('MERGE-P4-005')), isTrue);

      final indexRow = migrationText
          .split('\n')
          .firstWhere((line) => line.contains('`INDEX-P4-001`'));
      expect(indexRow, contains('DRAFT'));

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
