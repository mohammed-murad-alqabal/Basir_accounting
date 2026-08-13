// ignore_for_file: lines_longer_than_80_chars

import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/accounting/application/accounting_service.dart';
import 'package:basir_accounting_system/features/accounting/application/authoritative_ledger_gateway.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/financial_year.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/journal_entry.dart';
import 'package:basir_accounting_system/features/accounting/domain/repositories/accounting_repository.dart';
import 'package:basir_accounting_system/features/accounting/domain/repositories/financial_year_repository.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAccountingRepository extends Mock implements AccountingRepository {}

/// In-memory stub for the financial year repository.
///
/// Returns an open (never-closed) financial year that covers any posting date,
/// so `FinancialYearService.canPostToDate` resolves to `true` without needing
/// to mock the generated `AsyncNotifier` provider directly.
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
        startDate: DateTime(now.year),
        endDate: DateTime(now.year, 12, 31),
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

class TestAuthoritativeLedgerGateway implements AuthoritativeLedgerGateway {
  const TestAuthoritativeLedgerGateway();

  @override
  Future<LedgerPostReceipt> post(JournalEntry entry) async => LedgerPostReceipt(
        entryId: SupabaseLedgerGateway.operationIdFor(entry.id),
        entryHash: 'test-entry-hash-${entry.id}',
        previousHash: null,
        postedAt: DateTime.utc(2025),
        idempotentReplay: false,
      );
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
        authoritativeLedgerGatewayProvider.overrideWithValue(
          const TestAuthoritativeLedgerGateway(),
        ),
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
        status: JournalEntryStatus.posted,
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

      when(() => mockRepository.cacheAuthoritativeJournalEntry(any()))
          .thenAnswer((_) async => {});

      final service = container.read(accountingServiceProvider.notifier);

      await service.postJournalEntry(entry, bypassCognitive: true);

      // Verify server-confirmed cache captured the modified entry with logs.
      final capturedEntry = verify(
        () => mockRepository.cacheAuthoritativeJournalEntry(captureAny()),
      ).captured.first as JournalEntry;

      expect(capturedEntry.auditLogs, isNotEmpty);
      expect(capturedEntry.auditLogs.first.action, equals('COGNITIVE_BYPASS'));
      expect(capturedEntry.auditLogs.first.actor, equals('system'));
      expect(
        capturedEntry.auditLogs.first.rationale,
        contains('Consensus bypassed'),
      );
    });
  });
}
