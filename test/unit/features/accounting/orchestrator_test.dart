import 'package:basir_app/features/accounting/application/orchestrator_service.dart';
import 'package:basir_app/features/accounting/domain/entities/accounting_agent.dart';
import 'package:basir_app/features/accounting/domain/entities/journal_entry.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OrchestratorService Tests', () {
    test('Orchestrator should approve valid IFRS 18 transaction', () async {
      final container = ProviderContainer();
      final orchestrator = container.read(orchestratorServiceProvider.notifier);

      final mockEntry = JournalEntry(
        id: 'test-je',
        referenceNumber: 'JE-TEST-001',
        date: DateTime.now(),
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
        contains(
          'Confirmed: Account correctly mapped to Operating category',
        ),
      );
    });

    test(
        'Orchestrator should reject when ISSB metrics are missing '
        'for required transactions', () async {
      final container = ProviderContainer();
      final orchestrator = container.read(orchestratorServiceProvider.notifier);

      final mockEntry = JournalEntry(
        id: 'test-je-env',
        referenceNumber: 'JE-ENV-001',
        date: DateTime.now(),
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
        contains(
          'REJECTION: ISSB compliance requires sustainability metrics',
        ),
      );
    });
  });
}
