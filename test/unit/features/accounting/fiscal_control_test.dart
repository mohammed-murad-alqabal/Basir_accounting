import 'package:basir_app/features/accounting/domain/entities/financial_year.dart';
import 'package:basir_app/features/accounting/domain/entities/journal_entry.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Fiscal Control Precision Tests', () {
    test('Journal entry balanced precision check', () {
      final line1 = JournalEntryLine(
        accountId: 'acc1',
        accountName: 'Account 1',
        debit: Decimal.parse('100.00000001'),
        credit: Decimal.zero,
      );
      final line2 = JournalEntryLine(
        accountId: 'acc2',
        accountName: 'Account 2',
        credit: Decimal.parse('100.00000001'),
        debit: Decimal.zero,
      );

      final entry = JournalEntry(
        id: 'je1',
        referenceNumber: 'REF1',
        date: DateTime.now(),
        temporal: TemporalJustification(
          transactionDate: DateTime.now(),
          effectiveDate: DateTime.now(),
          recordingDate: DateTime.now(),
        ),
        standards: const StandardsJustification(standardReference: 'IFRS 9'),
        description: 'Precision test',
        status: JournalEntryStatus.posted,
        lines: [line1, line2],
        sourceDocument: 'manual',
        sourceId: 'src1',
        createdAt: DateTime.now(),
        createdBy: 'user',
        updatedAt: DateTime.now(),
      );

      expect(entry.isBalanced, isTrue);
      expect(entry.totalDebit, Decimal.parse('100.00000001'));
    });
  });

  group('Financial Year Logic', () {
    test('containsDate logic', () {
      final fy = FinancialYear(
        id: 'fy-2024',
        name: 'FY 2024',
        startDate: DateTime(2024),
        endDate: DateTime(2024, 12, 31),
      );

      expect(fy.containsDate(DateTime(2024, 6, 15)), isTrue);
      expect(fy.containsDate(DateTime(2023, 12, 31)), isFalse);
      expect(fy.containsDate(DateTime(2025)), isFalse);
    });
  });
}
