// ignore_for_file: avoid_redundant_argument_values, lines_longer_than_80_chars

import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/accounting/application/accounting_service.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/financial_year.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/journal_entry.dart';
import 'package:basir_accounting_system/features/accounting/domain/repositories/accounting_repository.dart';
import 'package:basir_accounting_system/features/accounting/domain/repositories/financial_year_repository.dart';
import 'package:basir_accounting_system/features/accounting/domain/validation/journal_entry_validation_exception.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAccountingRepository extends Mock implements AccountingRepository {}

/// In-memory stub for the financial year repository.
///
/// Returns an open (never-closed) financial year that covers any
/// posting date, so `FinancialYearService.canPostToDate` resolves to
/// `true` without needing to mock the generated `AsyncNotifier`
/// provider directly (mocks cannot satisfy Riverpod's private
/// `_setElement` lifecycle call).
class InMemoryFinancialYearRepository implements FinancialYearRepository {
  @override
  Future<FinancialYear?> getCurrentFinancialYear() async {
    final years = await getAllFinancialYears();
    return years.isNotEmpty ? years.first : null;
  }

  @override
  Future<FinancialYear?> getFinancialYearByDate(DateTime date) async {
    final years = await getAllFinancialYears();
    return years.firstWhere(
      (y) => y.startDate.isBefore(date) && y.endDate.isAfter(date),
      orElse: () => years.first,
    );
  }

  @override
  Future<List<FinancialYear>> getAllFinancialYears() async {
    final now = DateTime.now();
    return [
      FinancialYear(
        id: 'fy-${now.year}',
        name: 'FY ${now.year}',
        startDate: DateTime(now.year, 1, 1),
        endDate: DateTime(now.year, 12, 31),
        isClosed: false,
        lockedPeriodIds: const [],
      ),
    ];
  }

  @override
  Future<void> saveFinancialYear(FinancialYear year) async {}

  @override
  Future<void> closeFinancialYear(String id, String userId) async {}

  @override
  Future<bool> isPeriodOpen(DateTime date) async => true;
}

void main() {
  late MockAccountingRepository mockRepository;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(
      JournalEntry(
        id: '',
        referenceNumber: '',
        date: DateTime.now(),
        temporal: TemporalJustification(
          transactionDate: DateTime.now(),
          effectiveDate: DateTime.now(),
          recordingDate: DateTime.now(),
        ),
        standards: const StandardsJustification(
          standardReference: '',
          recognitionBasis: '',
        ),
        description: '',
        status: JournalEntryStatus.draft,
        sourceDocument: '',
        sourceId: '',
        createdBy: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        lines: const [],
      ),
    );
  });

  setUp(() {
    mockRepository = MockAccountingRepository();

    container = ProviderContainer(
      overrides: [
        accountingRepositoryProvider.overrideWithValue(mockRepository),
        financialYearRepositoryProvider.overrideWithValue(
          InMemoryFinancialYearRepository(),
        ),
      ],
    );
  });

  tearDown(() => container.dispose());

  group('AccountingService.postJournalEntry Bypass Logging', () {
    test('should record AuditLogEntry when bypassCognitive is true', () async {
      final now = DateTime.now();
      final entry = JournalEntry(
        id: 'test-bypass',
        referenceNumber: 'JE-BYPASS',
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
        description: 'Bypass test',
        status: JournalEntryStatus.draft,
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
            description: 'D',
          ),
          JournalEntryLine(
            accountId: 'acc-2',
            accountName: 'Exp',
            debit: Decimal.zero,
            credit: Decimal.parse('100'),
            description: 'C',
          ),
        ],
      );

      when(() => mockRepository.addJournalEntry(any()))
          .thenAnswer((_) async => {});

      final service = container.read(accountingServiceProvider.notifier);

      await service.postJournalEntry(entry, bypassCognitive: true);

      // Verify repository call captured the modified entry with logs
      final capturedEntry =
          verify(() => mockRepository.addJournalEntry(captureAny()))
              .captured
              .first as JournalEntry;

      expect(capturedEntry.auditLogs, isNotEmpty);
      expect(capturedEntry.auditLogs.first.action, equals('COGNITIVE_BYPASS'));
      expect(capturedEntry.auditLogs.first.actor, equals('system'));
      expect(
        capturedEntry.auditLogs.first.rationale,
        contains('Consensus bypassed'),
      );
    });

    test('rejects an invalid entry before repository persistence', () async {
      final now = DateTime.now();
      final entry = JournalEntry(
        id: 'test-invalid-boundary',
        referenceNumber: 'JE-INVALID',
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
        description: 'Invalid entry boundary test',
        status: JournalEntryStatus.draft,
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
            credit: Decimal.parse('100'),
          ),
          JournalEntryLine(
            accountId: 'acc-2',
            accountName: 'Revenue',
            debit: Decimal.zero,
            credit: Decimal.parse('100'),
          ),
        ],
      );
      final service = container.read(accountingServiceProvider.notifier);

      await expectLater(
        service.postJournalEntry(entry, bypassCognitive: true),
        throwsA(isA<JournalEntryValidationException>()),
      );
      verifyNever(() => mockRepository.addJournalEntry(any()));
    });
  });
}
