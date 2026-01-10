import 'package:basir_app/core/providers.dart';
import 'package:basir_app/core/providers/supabase_auth_provider.dart';
import 'package:basir_app/features/accounting/application/orchestrator_service.dart';
import 'package:basir_app/features/accounting/domain/entities/account.dart';
import 'package:basir_app/features/accounting/domain/entities/accounting_agent.dart';
import 'package:basir_app/features/accounting/domain/entities/journal_entry.dart';
import 'package:basir_app/features/accounting/domain/repositories/accounting_repository.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class MockAccountingRepository implements AccountingRepository {
  @override
  Future<List<JournalEntry>> getJournalEntries() async => [];
  @override
  Future<List<Account>> getAccounts() async => [];
  @override
  Future<Account?> getAccountById(String id) async => null;
  @override
  Future<void> addAccount(Account account) async {}
  @override
  Future<void> updateAccount(Account account) async {}
  @override
  Future<Decimal> getAccountBalance(String accountId) async => Decimal.zero;
  @override
  Future<void> addJournalEntry(JournalEntry entry) async {}
}

void main() {
  group('OrchestratorService Tests', () {
    test('Orchestrator should approve valid IFRS 18 transaction', () async {
      final container = ProviderContainer(
        overrides: [
          accountingRepositoryProvider.overrideWithValue(
            MockAccountingRepository(),
          ),
          currentUserProvider.overrideWith((ref) => null),
        ],
      );
      final orchestrator = container.read(orchestratorServiceProvider.notifier);

      final mockEntry = JournalEntry(
        id: 'test-je',
        referenceNumber: 'JE-TEST-001',
        date: DateTime.now(),
        temporal: TemporalJustification(
          transactionDate: DateTime.now(),
          effectiveDate: DateTime.now(),
          recordingDate: DateTime.now(),
        ),
        standards: const StandardsJustification(
          standardReference: 'IFRS 18',
          recognitionBasis: 'Accrual',
          measurementBasis: 'Historical Cost',
        ),
        description: 'Test Sales',
        status: JournalEntryStatus.posted,
        lines: [
          JournalEntryLine(
            accountId: 'acc-1201',
            accountName: 'Customers',
            debit: Decimal.parse('115'),
            credit: Decimal.zero,
          ),
          JournalEntryLine(
            accountId: 'acc-4101',
            accountName: 'Sales Revenue',
            credit: Decimal.parse('100'),
            debit: Decimal.zero,
          ),
          JournalEntryLine(
            accountId: 'acc-2105',
            accountName: 'VAT Payable',
            credit: Decimal.parse('15'),
            debit: Decimal.zero,
          ),
        ],
        sourceDocument: 'manual',
        sourceId: 'none',
        createdAt: DateTime.now(),
        createdBy: 'tester',
        updatedAt: DateTime.now(),
        postedAt: DateTime.now(),
      );

      final context = AccountingContext(
        proposedJournalEntry: mockEntry,
        transactionType: 'sales',
      );

      final result = await orchestrator.orchestrate(context);

      expect(result.isApproved, isTrue);
      expect(
        result.explanation.contains(
          'Basir Cognitive Hexagon: Final Consensus Report',
        ),
        true,
      );
      expect(
        result.explanation,
        contains('Confirmed: Account correctly mapped to Operating category'),
      );
      expect(result.explanation, contains('Validating IFRS 18 Category'));
    });

    test(
        'Orchestrator should reject when ISSB metrics are missing '
        'for required transactions', () async {
      final container = ProviderContainer(
        overrides: [
          accountingRepositoryProvider.overrideWithValue(
            MockAccountingRepository(),
          ),
          currentUserProvider.overrideWith((ref) => null),
        ],
      );
      final orchestrator = container.read(orchestratorServiceProvider.notifier);

      final mockEntry = JournalEntry(
        id: 'test-je-env',
        referenceNumber: 'JE-ENV-001',
        date: DateTime.now(),
        temporal: TemporalJustification(
          transactionDate: DateTime.now(),
          effectiveDate: DateTime.now(),
          recordingDate: DateTime.now(),
        ),
        standards: const StandardsJustification(
          standardReference: 'ISSB S1',
          recognitionBasis: 'Accrual',
          measurementBasis: 'Historical Cost',
        ),
        description: 'Environmental Impact Transaction',
        status: JournalEntryStatus.posted,
        lines: [
          JournalEntryLine(
            accountId: 'acc-1102',
            accountName: 'Bank',
            credit: Decimal.parse('1000000'),
            debit: Decimal.zero,
          ),
          JournalEntryLine(
            accountId: 'acc-5101',
            accountName: 'Industrial Expenses',
            debit: Decimal.parse('1000000'),
            credit: Decimal.zero,
          ),
        ],
        sourceDocument: 'manual',
        sourceId: 'none',
        createdAt: DateTime.now(),
        createdBy: 'tester',
        updatedAt: DateTime.now(),
        postedAt: DateTime.now(),
      );

      final context = AccountingContext(
        proposedJournalEntry: mockEntry,
        transactionType: 'industrial_expense',
        isSustainabilityRequired: true,
        sustainabilityMetrics: [], // Missing required metrics
      );

      final result = await orchestrator.orchestrate(context);

      expect(result.isApproved, isFalse);
      expect(
        result.explanation,
        contains('REJECTION: ISSB compliance requires sustainability metrics'),
      );
    });
  });
}
