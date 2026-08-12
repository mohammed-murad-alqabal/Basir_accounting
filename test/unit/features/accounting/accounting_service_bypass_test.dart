// ignore_for_file: lines_longer_than_80_chars
import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/accounting/application/accounting_service.dart';
import 'package:basir_accounting_system/features/accounting/application/financial_year_service.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/journal_entry.dart';
import 'package:basir_accounting_system/features/accounting/domain/repositories/accounting_repository.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAccountingRepository extends Mock implements AccountingRepository {}

class MockFinancialYearService extends Mock implements FinancialYearService {}

void main() {
  late MockAccountingRepository mockRepository;
  late MockFinancialYearService mockFinancialYearService;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(_entry(status: JournalEntryStatus.draft));
  });

  setUp(() {
    mockRepository = MockAccountingRepository();
    mockFinancialYearService = MockFinancialYearService();
    container = ProviderContainer(
      overrides: [
        accountingRepositoryProvider.overrideWithValue(mockRepository),
        financialYearServiceProvider
            .overrideWith(() => mockFinancialYearService),
      ],
    );
  });

  tearDown(() => container.dispose());

  group('AccountingService ledger boundaries', () {
    test('saves a balanced draft through the dedicated draft path', () async {
      final draft = _entry(status: JournalEntryStatus.draft);
      when(() => mockRepository.addJournalEntry(any()))
          .thenAnswer((_) async {});

      final service = container.read(accountingServiceProvider.notifier);
      await service.saveJournalEntryDraft(draft);

      verify(() => mockRepository.addJournalEntry(draft)).called(1);
      verifyNever(() => mockFinancialYearService.canPostToDate(any()));
    });

    test('rejects a draft supplied to the final posting path', () async {
      final draft = _entry(status: JournalEntryStatus.draft);
      final service = container.read(accountingServiceProvider.notifier);

      await expectLater(
        service.postJournalEntry(draft),
        throwsA(isA<ArgumentError>()),
      );

      verifyNever(() => mockRepository.addJournalEntry(any()));
      verifyNever(() => mockFinancialYearService.canPostToDate(any()));
    });
  });
}

JournalEntry _entry({required JournalEntryStatus status}) {
  final now = DateTime.utc(2026, 1);
  return JournalEntry(
    id: 'test-entry-${status.name}',
    referenceNumber: 'JE-${status.name}',
    date: now,
    temporal: TemporalJustification(
      transactionDate: now,
      effectiveDate: now,
      recordingDate: now,
    ),
    standards: const StandardsJustification(
      standardReference: 'IFRS',
      recognitionBasis: 'Accrual',
    ),
    description: 'Ledger boundary test',
    status: status,
    sourceDocument: 'manual',
    sourceId: 'test',
    createdBy: 'test-user',
    createdAt: now,
    updatedAt: now,
    lines: [
      JournalEntryLine(
        accountId: 'acc-1',
        accountName: 'Cash',
        debit: Decimal.parse('100'),
        credit: Decimal.zero,
      ),
      JournalEntryLine(
        accountId: 'acc-2',
        accountName: 'Expense',
        debit: Decimal.zero,
        credit: Decimal.parse('100'),
      ),
    ],
  );
}
