// ignore_for_file: lines_longer_than_80_chars
import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/accounting/application/forensic_audit_service.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/accounting_agent.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/journal_entry.dart';
import 'package:basir_accounting_system/features/accounting/domain/repositories/accounting_repository.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAccountingRepository extends Mock implements AccountingRepository {}

void main() {
  late ForensicAuditService service;
  late MockAccountingRepository mockRepository;
  late ProviderContainer container;

  setUp(() {
    mockRepository = MockAccountingRepository();
    when(() => mockRepository.getJournalEntries()).thenAnswer((_) async => []);
    container = ProviderContainer(
      overrides: [
        accountingRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
    service = container.read(forensicAuditServiceProvider.notifier);
  });

  tearDown(() {
    container.dispose();
  });

  JournalEntry makeEntry({
    String id = 'je-1',
    String referenceNumber = 'JE-001',
    List<JournalEntryLine> lines = const [],
    JournalEntryStatus status = JournalEntryStatus.draft,
    String description = 'Normal transaction',
    String sourceDocument = 'manual',
    String sourceId = 'test',
    DateTime? date,
  }) {
    final now = date ?? DateTime.now();
    return JournalEntry(
      id: id,
      referenceNumber: referenceNumber,
      date: now,
      temporal: TemporalJustification(
        transactionDate: now,
        effectiveDate: now,
        recordingDate: now,
      ),
      standards: const StandardsJustification(
        standardReference: 'IFRS',
        recognitionBasis: 'Accrual',
        measurementBasis: 'Historical Cost',
      ),
      description: description,
      status: status,
      lines: lines,
      sourceDocument: sourceDocument,
      sourceId: sourceId,
      createdBy: 'test-user',
      createdAt: now,
      updatedAt: now,
      postedAt: status == JournalEntryStatus.posted ? now : null,
    );
  }

  group('ForensicAuditService Process Contract', () {
    test('agent id and authority are correctly declared', () {
      expect(service.agentId, 'agent-3-forensic');
      expect(service.authority, AgentAuthority.high);
    });

    test('should REJECT an unbalanced journal entry (CP-001 structural check)',
        () async {
      final entry = makeEntry(
        lines: [
          JournalEntryLine(
            accountId: 'acc-1',
            accountName: 'Cash',
            debit: Decimal.parse('1000'),
            credit: Decimal.zero,
          ),
          JournalEntryLine(
            accountId: 'acc-2',
            accountName: 'Sales',
            debit: Decimal.zero,
            credit: Decimal.parse('500'),
          ),
        ],
      );

      final result = await service.process(
        AccountingContext(
          proposedJournalEntry: entry,
          transactionType: 'manual',
        ),
      );

      expect(result.isAllowed, false);
      expect(result.rationale, 'agentRationaleForensicUnbalanced');
      expect(result.confidenceScore, 1);
    });

    test('should REJECT transactions with prohibited Sharia terms (CP-012)',
        () async {
      final entry = makeEntry(description: 'Interest-bearing loan payment');

      final result = await service.process(
        AccountingContext(
          proposedJournalEntry: entry,
          transactionType: 'manual',
        ),
      );

      expect(result.isAllowed, false);
      expect(result.rationale, 'agentRationaleForensicShariaViolation');
      expect(result.confidenceScore, 0.99);
    });

    test('should REJECT when description contains "riba"', () async {
      final entry = makeEntry(description: 'Riba settlement adjustment');

      final result = await service.process(
        AccountingContext(
          proposedJournalEntry: entry,
          transactionType: 'manual',
        ),
      );

      expect(result.isAllowed, false);
      expect(result.rationale, 'agentRationaleForensicShariaViolation');
    });

    test(
        'should ALLOW a high-value transaction (above 100,000 SAR) with '
        'high-value rationale (CP-009)', () async {
      final entry = makeEntry(
        lines: [
          JournalEntryLine(
            accountId: 'acc-1',
            accountName: 'Machines',
            debit: Decimal.parse('150000'),
            credit: Decimal.zero,
          ),
          JournalEntryLine(
            accountId: 'acc-2',
            accountName: 'Cash',
            debit: Decimal.zero,
            credit: Decimal.parse('150000'),
          ),
        ],
      );

      final result = await service.process(
        AccountingContext(
          proposedJournalEntry: entry,
          transactionType: 'manual',
        ),
      );

      expect(result.isAllowed, true);
      expect(result.rationale, 'agentRationaleForensicHighValue');
      expect(result.confidenceScore, 0.85);
    });

    test('should ALLOW a balanced standard entry with balanced rationale',
        () async {
      final entry = makeEntry(
        lines: [
          JournalEntryLine(
            accountId: 'acc-1',
            accountName: 'Accounts Receivable',
            debit: Decimal.parse('1150'),
            credit: Decimal.zero,
          ),
          JournalEntryLine(
            accountId: 'acc-2',
            accountName: 'Sales',
            debit: Decimal.zero,
            credit: Decimal.parse('1000'),
          ),
          JournalEntryLine(
            accountId: 'acc-3',
            accountName: 'VAT Output',
            debit: Decimal.zero,
            credit: Decimal.parse('150'),
          ),
        ],
      );

      final result = await service.process(
        AccountingContext(
          proposedJournalEntry: entry,
          transactionType: 'manual',
        ),
      );

      expect(result.isAllowed, true);
      expect(result.rationale, 'agentRationaleForensicBalanced');
      expect(result.confidenceScore, 0.95);
    });
  });
}
