import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/core/providers/supabase_auth_provider.dart';
import 'package:basir_accounting_system/features/accounting/application/orchestrator_service.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/account.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/accounting_agent.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/journal_entry.dart';
import 'package:basir_accounting_system/features/accounting/domain/repositories/accounting_repository.dart';
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
  group('Multi-Agent Cognitive Consensus Verification', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer(
        overrides: [
          accountingRepositoryProvider.overrideWithValue(
            MockAccountingRepository(),
          ),
          currentUserProvider.overrideWith((ref) => null),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    testWidgets('Consensus Test 1: Valid Sales Invoice with Tax',
        (tester) async {
      final orchestrator = container.read(orchestratorServiceProvider.notifier);

      final entry = JournalEntry(
        id: 'je-001',
        referenceNumber: 'JE-SALES-001',
        date: DateTime.now(),
        temporal: TemporalJustification(
          transactionDate: DateTime.now(),
          effectiveDate: DateTime.now(),
          recordingDate: DateTime.now(),
        ),
        standards: const StandardsJustification(
          standardReference: 'IFRS 15', // Revenue from Contracts with Customers
          recognitionBasis: 'Accrual',
          measurementBasis: 'Transaction Price',
        ),
        description: 'Elite Professional Consulting Services',
        status: JournalEntryStatus.posted,
        lines: [
          JournalEntryLine(
            accountId: 'acc-1201', // AR
            accountName: 'Accounts Receivable',
            debit: Decimal.parse('1150'),
            credit: Decimal.zero,
          ),
          JournalEntryLine(
            accountId: 'acc-4101', // Sales (acc-4 branch)
            accountName: 'Professional Sales',
            credit: Decimal.parse('1000'),
            debit: Decimal.zero,
          ),
          JournalEntryLine(
            accountId: 'acc-2102', // VAT Payable
            accountName: 'VAT Output',
            credit: Decimal.parse('150'),
            debit: Decimal.zero,
          ),
        ],
        sourceDocument: 'sales_invoice',
        sourceId: 'inv-001',
        createdBy: 'user-001',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        postedAt: DateTime.now(),
      );

      final context = AccountingContext(
        proposedJournalEntry: entry,
        transactionType: 'sales',
        locale: 'en',
        metadata: {
          'tax_id': '310123456700003', // Valid ZATCA style tax ID
          'priority': 'high',
        },
      );

      final consensus = await orchestrator.orchestrate(context);

      expect(consensus.isApproved, true);
      expect(consensus.agentResults.length, 6);
      expect(consensus.explanation.contains('agent-1-standards-engine'), true);
      expect(consensus.explanation.contains('agent-2-tax-engine'), true);
      expect(consensus.explanation.contains('agent-3-forensic'), true);
      expect(consensus.explanation.contains('agent-4-operational-intel'), true);
      expect(
        consensus.explanation.contains('agent-5-financial-strategy'),
        true,
      );
      expect(
        consensus.explanation.contains('agent-6-sustainability-expert'),
        true,
      );
    });

    testWidgets(
      'Consensus Test 2: Rejection on Missing Tax ID for Large Transaction',
      (tester) async {
        final orchestrator = container.read(
          orchestratorServiceProvider.notifier,
        );

        final entry = JournalEntry(
          id: 'je-002',
          referenceNumber: 'JE-BIG-001',
          date: DateTime.now(),
          temporal: TemporalJustification(
            transactionDate: DateTime.now(),
            effectiveDate: DateTime.now(),
            recordingDate: DateTime.now(),
          ),
          standards: const StandardsJustification(
            standardReference: 'IAS 16', // Property, Plant and Equipment
            recognitionBasis: 'Accrual',
            measurementBasis: 'Historical Cost',
          ),
          description: 'Large Asset Purchase',
          status: JournalEntryStatus.posted,
          lines: [
            JournalEntryLine(
              accountId: 'acc-1501', // Fixed Assets
              accountName: 'Machines',
              debit: Decimal.parse('50000'),
              credit: Decimal.zero,
            ),
            JournalEntryLine(
              accountId: 'acc-1101', // Cash
              accountName: 'Main Cash',
              credit: Decimal.parse('50000'),
              debit: Decimal.zero,
            ),
          ],
          sourceDocument: 'manual',
          sourceId: 'm-001',
          createdBy: 'user-001',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          postedAt: DateTime.now(),
        );

        final context = AccountingContext(
          proposedJournalEntry: entry,
          transactionType: 'purchase',
          locale: 'en',
          metadata: {
            'tax_id': '', // MISSING TAX ID
          },
        );

        final consensus = await orchestrator.orchestrate(context);

        // Should be false because Agent 2 rejects > 10,000 without tax_id
        expect(consensus.isApproved, false);
        expect(
          consensus.explanation.contains(
            'REJECT: Transactions exceeding 10,000 SAR require a valid Tax '
            'ID for ZATCA Phase 2 compliance.',
          ),
          true,
        );
      },
    );
  });
}
