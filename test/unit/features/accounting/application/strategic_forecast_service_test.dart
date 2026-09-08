import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/accounting/application/strategic_forecast_service.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/journal_entry.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/strategic_outlook.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mock_accounting_repository.dart';

JournalEntryLine _line({
  required String accountId,
  required Decimal debit,
  required Decimal credit,
}) =>
    JournalEntryLine(
      accountId: accountId,
      accountName: accountId,
      debit: debit,
      credit: credit,
    );

JournalEntry _entry({
  required String id,
  required DateTime date,
  required List<JournalEntryLine> lines,
}) =>
    JournalEntry(
      id: id,
      referenceNumber: 'JE-$id',
      date: date,
      temporal: TemporalJustification(
        transactionDate: date,
        effectiveDate: date,
        recordingDate: date,
      ),
      standards: const StandardsJustification(standardReference: 'IFRS 18'),
      description: 'Strategic forecast fixture',
      status: JournalEntryStatus.posted,
      lines: lines,
      sourceDocument: 'test',
      sourceId: id,
      createdBy: 'tester',
      createdAt: date,
      updatedAt: date,
    );

void main() {
  group('StrategicForecastNotifier', () {
    late MockAccountingRepository repository;
    late ProviderContainer container;

    setUp(() {
      repository = MockAccountingRepository();
      container = ProviderContainer(
        overrides: [
          accountingRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);
    });

    test('returns an empty outlook when there is no ledger history', () async {
      when(() => repository.getJournalEntries()).thenAnswer((_) async => []);

      final outlook =
          await container.read(strategicForecastNotifierProvider.future);

      expect(outlook.pnlForecast, isEmpty);
      expect(outlook.cashFlowForecast, isEmpty);
      expect(outlook.insights, isEmpty);
      expect(outlook.confidenceScore, 0.85);
    });

    test('groups monthly P&L and projects revenue, expense, and growth insight',
        () async {
      when(() => repository.getJournalEntries()).thenAnswer(
        (_) async => [
          _entry(
            id: 'jan',
            date: DateTime(2026, 1, 15),
            lines: [
              _line(
                accountId: 'acc-1101',
                debit: Decimal.fromInt(60),
                credit: Decimal.zero,
              ),
              _line(
                accountId: 'acc-5101',
                debit: Decimal.fromInt(40),
                credit: Decimal.zero,
              ),
              _line(
                accountId: 'acc-4101',
                debit: Decimal.zero,
                credit: Decimal.fromInt(100),
              ),
            ],
          ),
          _entry(
            id: 'feb',
            date: DateTime(2026, 2, 15),
            lines: [
              _line(
                accountId: 'acc-1101',
                debit: Decimal.fromInt(100),
                credit: Decimal.zero,
              ),
              _line(
                accountId: 'acc-5101',
                debit: Decimal.fromInt(100),
                credit: Decimal.zero,
              ),
              _line(
                accountId: 'acc-4101',
                debit: Decimal.zero,
                credit: Decimal.fromInt(200),
              ),
            ],
          ),
        ],
      );

      final outlook =
          await container.read(strategicForecastNotifierProvider.future);
      final firstForecast = outlook.pnlForecast.first;

      expect(outlook.pnlForecast, hasLength(6));
      expect(firstForecast.period, DateTime(2026, 3));
      expect(firstForecast.revenue, Decimal.fromInt(250));
      expect(firstForecast.expense, Decimal.fromInt(102));
      expect(firstForecast.netIncome, Decimal.fromInt(148));
      expect(
        outlook.insights.map((insight) => insight.impact),
        contains(InsightImpact.positive),
      );
    });

    test('raises a liquidity insight when forecast cash outflow exceeds inflow',
        () async {
      when(() => repository.getJournalEntries()).thenAnswer(
        (_) async => [
          _entry(
            id: 'expense-only',
            date: DateTime(2026, 1, 15),
            lines: [
              _line(
                accountId: 'acc-5101',
                debit: Decimal.fromInt(100),
                credit: Decimal.zero,
              ),
              _line(
                accountId: 'acc-1101',
                debit: Decimal.zero,
                credit: Decimal.fromInt(100),
              ),
            ],
          ),
        ],
      );

      final outlook =
          await container.read(strategicForecastNotifierProvider.future);

      expect(outlook.pnlForecast.first.cashInflow, Decimal.zero);
      expect(outlook.pnlForecast.first.cashOutflow, Decimal.fromInt(102));
      expect(
        outlook.insights.map((insight) => insight.impact),
        contains(InsightImpact.negative),
      );
    });
  });
}
