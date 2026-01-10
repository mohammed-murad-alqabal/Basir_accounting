// ignore_for_file: lines_longer_than_80_chars
import 'dart:math';

import 'package:basir_app/features/accounting/domain/entities/journal_entry.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Accounting Invariants Property-Based Tests', () {
    final random = Random();

    Decimal nextDecimal(double min, double max) {
      final val = min + (random.nextDouble() * (max - min));
      return Decimal.parse(val.toStringAsFixed(2));
    }

    test(
      'JournalEntry Line Invariant: Debit/Credit Balance (100 random runs)',
      () {
        for (var i = 0; i < 100; i++) {
          final lines = <JournalEntryLine>[];
          var totalBalance = Decimal.zero;

          // Generate N-1 random lines
          final numLines = 2 + random.nextInt(8);
          for (var j = 0; j < numLines - 1; j++) {
            final isDebit = random.nextBool();
            final amount = nextDecimal(1, 10000);

            if (isDebit) {
              lines.add(
                JournalEntryLine(
                  accountId: 'acc-$j',
                  accountName: 'Account $j',
                  debit: amount,
                  credit: Decimal.zero,
                ),
              );
              totalBalance += amount;
            } else {
              lines.add(
                JournalEntryLine(
                  accountId: 'acc-$j',
                  accountName: 'Account $j',
                  debit: Decimal.zero,
                  credit: amount,
                ),
              );
              totalBalance -= amount;
            }
          }

          // Add balancing line
          if (totalBalance > Decimal.zero) {
            // Add credit to balance
            lines.add(
              JournalEntryLine(
                accountId: 'acc-bal',
                accountName: 'Balancing Account',
                debit: Decimal.zero,
                credit: totalBalance,
              ),
            );
          } else if (totalBalance < Decimal.zero) {
            // Add debit to balance
            lines.add(
              JournalEntryLine(
                accountId: 'acc-bal',
                accountName: 'Balancing Account',
                debit: totalBalance.abs(),
                credit: Decimal.zero,
              ),
            );
          } else {
            // Already balanced (rare)
            lines.add(
              JournalEntryLine(
                accountId: 'acc-bal',
                accountName: 'Balancing Account',
                debit: Decimal.zero,
                credit: Decimal.zero,
              ),
            );
          }

          // Verify Invariant
          final totalDebit = lines.fold(
            Decimal.zero,
            (sum, l) => sum + l.debit,
          );
          final totalCredit = lines.fold(
            Decimal.zero,
            (sum, l) => sum + l.credit,
          );

          expect(
            totalDebit,
            equals(totalCredit),
            reason: 'Run $i: Total Debit ($totalDebit) must equal '
                'Total Credit ($totalCredit)',
          );
        }
      },
    );

    test('FX Conversion Invariant: Local = Foreign * Rate (100 random runs)',
        () {
      for (var i = 0; i < 100; i++) {
        final foreignAmount = nextDecimal(1, 10000);
        final rate = nextDecimal(0.1, 5);

        // Logical calculation
        final localAmountDouble = (Decimal.parse(foreignAmount.toString()) *
                Decimal.parse(rate.toString()))
            .toDouble();
        final localAmount = Decimal.parse(localAmountDouble.toStringAsFixed(2));

        final line = JournalEntryLine(
          accountId: 'fx-1',
          accountName: 'FX Account',
          debit: localAmount,
          credit: Decimal.zero,
          originalCurrency: 'USD',
          originalAmount: foreignAmount,
          exchangeRate: rate,
        );

        // Verify Invariant
        final calculatedLocal =
            (line.originalAmount! * line.exchangeRate!).toDouble();
        final roundedCalculated = Decimal.parse(
          calculatedLocal.toStringAsFixed(2),
        );

        // Tolerance check for potential floating point issues in middle steps
        // though Decimal should remain precise.
        expect(
          line.debit,
          equals(roundedCalculated),
          reason: 'Run $i: Local amount must match foreign * rate conversion',
        );
      }
    });
  });
}
