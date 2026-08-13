// ignore_for_file: prefer_expression_function_bodies, require_trailing_commas

import 'package:basir_accounting_system/features/accounting/domain/entities/journal_entry.dart';
import 'package:basir_accounting_system/features/accounting/domain/validation/journal_entry_validation_exception.dart';
import 'package:basir_accounting_system/features/accounting/domain/validation/journal_entry_validator.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('JournalEntryValidator', () {
    test('accepts a balanced two-line entry with exclusive positive sides', () {
      final entry = _entry(lines: <JournalEntryLine>[
        _line(accountId: 'cash', debit: Decimal.parse('100')),
        _line(accountId: 'revenue', credit: Decimal.parse('100')),
      ]);

      expect(JournalEntryValidator.validate(entry), isEmpty);
      expect(
          () => JournalEntryValidator.ensurePostable(entry), returnsNormally);
    });

    test('rejects a single line even when its totals are mathematically equal',
        () {
      final entry = _entry(lines: <JournalEntryLine>[
        _line(accountId: 'cash', debit: Decimal.zero, credit: Decimal.zero),
      ]);

      final failures = JournalEntryValidator.validate(entry);

      expect(
        failures.map((failure) => failure.code),
        containsAll(<JournalEntryValidationCode>[
          JournalEntryValidationCode.tooFewLines,
          JournalEntryValidationCode.zeroAmount,
        ]),
      );
    });

    test('rejects a line carrying both debit and credit', () {
      final entry = _entry(lines: <JournalEntryLine>[
        _line(
          accountId: 'cash',
          debit: Decimal.parse('100'),
          credit: Decimal.parse('100'),
        ),
        _line(accountId: 'revenue', credit: Decimal.parse('100')),
      ]);

      final failures = JournalEntryValidator.validate(entry);

      expect(
        failures.map((failure) => failure.code),
        contains(JournalEntryValidationCode.debitAndCreditSet),
      );
    });

    test('rejects negative amounts and an unbalanced total', () {
      final entry = _entry(lines: <JournalEntryLine>[
        _line(accountId: 'cash', debit: Decimal.parse('-10')),
        _line(accountId: 'revenue', credit: Decimal.parse('10')),
      ]);

      final failures = JournalEntryValidator.validate(entry);

      expect(
        failures.map((failure) => failure.code),
        containsAll(<JournalEntryValidationCode>[
          JournalEntryValidationCode.negativeAmount,
          JournalEntryValidationCode.unbalanced,
        ]),
      );
    });

    test('requires original currency amount and exchange rate together', () {
      final entry = _entry(lines: <JournalEntryLine>[
        _line(
          accountId: 'cash',
          debit: Decimal.parse('375'),
          originalCurrency: 'USD',
          originalAmount: Decimal.parse('100'),
        ),
        _line(accountId: 'revenue', credit: Decimal.parse('375')),
      ]);

      final failures = JournalEntryValidator.validate(entry);

      expect(
        failures.map((failure) => failure.code),
        contains(JournalEntryValidationCode.invalidOriginalCurrency),
      );
    });

    test('accepts complete positive original currency context', () {
      final entry = _entry(lines: <JournalEntryLine>[
        _line(
          accountId: 'cash',
          debit: Decimal.parse('375'),
          originalCurrency: 'USD',
          originalAmount: Decimal.parse('100'),
          exchangeRate: Decimal.parse('3.75'),
        ),
        _line(accountId: 'revenue', credit: Decimal.parse('375')),
      ]);

      expect(JournalEntryValidator.validate(entry), isEmpty);
    });

    test('rejects voided entries before persistence', () {
      final entry = _entry(
        status: JournalEntryStatus.voided,
        lines: <JournalEntryLine>[
          _line(accountId: 'cash', debit: Decimal.parse('100')),
          _line(accountId: 'revenue', credit: Decimal.parse('100')),
        ],
      );

      expect(
        () => JournalEntryValidator.ensurePostable(entry),
        throwsA(
          isA<JournalEntryValidationException>().having(
            (error) => error.failures.first.code,
            'first failure',
            JournalEntryValidationCode.invalidStatus,
          ),
        ),
      );
    });
  });
}

JournalEntry _entry({
  required List<JournalEntryLine> lines,
  JournalEntryStatus status = JournalEntryStatus.draft,
}) {
  final now = DateTime.utc(2026, 8, 13);
  return JournalEntry(
    id: 'entry-1',
    referenceNumber: 'JE-001',
    date: now,
    temporal: TemporalJustification(
      transactionDate: now,
      effectiveDate: now,
      recordingDate: now,
    ),
    standards: const StandardsJustification(standardReference: 'IFRS 15'),
    description: 'Validator fixture',
    status: status,
    lines: lines,
    sourceDocument: 'manual',
    sourceId: 'source-1',
    createdBy: 'tester',
    createdAt: now,
    updatedAt: now,
  );
}

JournalEntryLine _line({
  required String accountId,
  Decimal? debit,
  Decimal? credit,
  String? originalCurrency,
  Decimal? originalAmount,
  Decimal? exchangeRate,
}) {
  return JournalEntryLine(
    accountId: accountId,
    accountName: 'Account $accountId',
    debit: debit ?? Decimal.zero,
    credit: credit ?? Decimal.zero,
    originalCurrency: originalCurrency,
    originalAmount: originalAmount,
    exchangeRate: exchangeRate,
  );
}
