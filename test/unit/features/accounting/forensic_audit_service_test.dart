// ignore_for_file: lines_longer_than_80_chars
import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/accounting/application/forensic_audit_service.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/accounting_agent.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/journal_entry.dart';
import 'package:basir_accounting_system/features/accounting/domain/repositories/accounting_repository.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice.dart';
import 'package:basir_accounting_system/features/invoices/domain/repositories/invoice_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAccountingRepository extends Mock implements AccountingRepository {}

class MockInvoiceRepository extends Mock implements InvoiceRepository {}

class MockInvoice extends Mock implements Invoice {}

void main() {
  late ForensicAuditService service;
  late MockAccountingRepository mockRepository;
  late MockInvoiceRepository mockInvoiceRepository;
  late ProviderContainer container;

  setUp(() {
    mockRepository = MockAccountingRepository();
    mockInvoiceRepository = MockInvoiceRepository();
    container = ProviderContainer(
      overrides: [
        accountingRepositoryProvider.overrideWithValue(mockRepository),
        invoiceRepositoryProvider.overrideWith((ref) => mockInvoiceRepository),
      ],
    );
    service = container.read(forensicAuditServiceProvider.notifier);
  });

  tearDown(() {
    container.dispose();
  });

  group('ForensicAuditService Anomaly Detection', () {
    test('should flag time-of-day anomaly (night shift 23:30)', () async {
      final nightTime = DateTime(2024, 1, 1, 23, 30); // 11:30 PM
      final entry = JournalEntry(
        id: 'test-1',
        referenceNumber: 'JE-001',
        date: nightTime,
        temporal: TemporalJustification(
          transactionDate: nightTime,
          effectiveDate: nightTime,
          recordingDate: nightTime,
        ),
        standards: const StandardsJustification(
          standardReference: 'IFRS',
          recognitionBasis: 'Accrual',
        ),
        description: 'Night entry',
        status: JournalEntryStatus.draft,
        sourceDocument: 'manual',
        sourceId: 'test',
        createdBy: 'test-user',
        createdAt: nightTime,
        updatedAt: nightTime,
        lines: const [],
      );

      when(() => mockRepository.getJournalEntries())
          .thenAnswer((_) async => []);

      final context = AccountingContext(
        proposedJournalEntry: entry,
        transactionType: 'manual',
        locale: 'en',
      );

      final result = await service.process(context);

      expect(result.rationale, contains('non-standard hours'));
      expect(result.rationale, contains('23:00'));
    });

    test('should flag time-of-day anomaly (early morning 04:00)', () async {
      final morningTime = DateTime(2024, 1, 1, 4); // 4:00 AM
      final entry = JournalEntry(
        id: 'test-1',
        referenceNumber: 'JE-001',
        date: morningTime,
        temporal: TemporalJustification(
          transactionDate: morningTime,
          effectiveDate: morningTime,
          recordingDate: morningTime,
        ),
        standards: const StandardsJustification(
          standardReference: 'IFRS',
          recognitionBasis: 'Accrual',
        ),
        description: 'Early morning entry',
        status: JournalEntryStatus.draft,
        sourceDocument: 'manual',
        sourceId: 'test',
        createdBy: 'test-user',
        createdAt: morningTime,
        updatedAt: morningTime,
        lines: const [],
      );

      when(() => mockRepository.getJournalEntries())
          .thenAnswer((_) async => []);

      final context = AccountingContext(
        proposedJournalEntry: entry,
        transactionType: 'manual',
        locale: 'en',
      );

      final result = await service.process(context);

      expect(result.rationale, contains('non-standard hours'));
      expect(result.rationale, contains('04:00'));
    });

    test('should flag reference sequence gap', () async {
      final now = DateTime.now();
      final lastEntry = JournalEntry(
        id: 'prev',
        referenceNumber: 'JE-001',
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
        description: 'Previous',
        status: JournalEntryStatus.posted,
        sourceDocument: 'manual',
        sourceId: 'test',
        createdBy: 'test-user',
        createdAt: now,
        updatedAt: now,
        lines: const [],
      );

      final currentEntry = lastEntry.copyWith(
        id: 'curr',
        referenceNumber: 'JE-003', // Gap: JE-002 is missing
      );

      when(() => mockRepository.getJournalEntries())
          .thenAnswer((_) async => [lastEntry]);

      final context = AccountingContext(
        proposedJournalEntry: currentEntry,
        transactionType: 'manual',
        locale: 'en',
      );

      final result = await service.process(context);

      expect(result.rationale, contains('Gap detected'));
      expect(result.rationale, contains('JE-001'));
      expect(result.rationale, contains('JE-003'));
    });

    test('should NOT flag if sequence is continuous', () async {
      final now = DateTime.now();
      final lastEntry = JournalEntry(
        id: 'prev',
        referenceNumber: 'JE-001',
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
        description: 'Previous',
        status: JournalEntryStatus.posted,
        sourceDocument: 'manual',
        sourceId: 'test',
        createdBy: 'test-user',
        createdAt: now,
        updatedAt: now,
        lines: const [],
      );

      final currentEntry = lastEntry.copyWith(
        id: 'curr',
        referenceNumber: 'JE-002', // Sequential
      );

      when(() => mockRepository.getJournalEntries())
          .thenAnswer((_) async => [lastEntry]);

      final context = AccountingContext(
        proposedJournalEntry: currentEntry,
        transactionType: 'manual',
        locale: 'en',
      );

      final result = await service.process(context);

      expect(result.rationale, isNot(contains('Gap detected')));
    });

    test(
        'should flag gap even with different prefixes correctly (only same prefix matches)',
        () async {
      final now = DateTime.now();
      final otherPrefixEntry = JournalEntry(
        id: 'other',
        referenceNumber: 'SIM-INV-001',
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
        description: 'Other',
        status: JournalEntryStatus.posted,
        sourceDocument: 'manual',
        sourceId: 'test',
        createdBy: 'test-user',
        createdAt: now,
        updatedAt: now,
        lines: const [],
      );

      final lastJeEntry = otherPrefixEntry.copyWith(
        id: 'prev-je',
        referenceNumber: 'JE-001',
      );

      final currentEntry = lastJeEntry.copyWith(
        id: 'curr',
        referenceNumber: 'JE-003',
      );

      // Entries should be checked in reverse, so lastJeEntry is the neighbor
      when(() => mockRepository.getJournalEntries())
          .thenAnswer((_) async => [otherPrefixEntry, lastJeEntry]);

      final context = AccountingContext(
        proposedJournalEntry: currentEntry,
        transactionType: 'manual',
        locale: 'en',
      );

      final result = await service.process(context);

      expect(result.rationale, contains('Gap detected'));
      expect(result.rationale, contains('JE-001'));
      expect(result.rationale, contains('JE-003'));
      expect(result.rationale, isNot(contains('SIM-INV-001')));
    });

    test('should flag missing ZATCA identity for posted invoices', () async {
      final now = DateTime.now();
      final entry = JournalEntry(
        id: 'je-inv-1',
        referenceNumber: 'JE-001',
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
        description: 'Invoice entry',
        status: JournalEntryStatus.posted,
        sourceDocument: 'invoice',
        sourceId: 'inv-1',
        createdBy: 'test-user',
        createdAt: now,
        updatedAt: now,
        lines: const [],
      );

      final mockInvoice = MockInvoice();
      when(() => mockInvoice.zatcaUuid).thenReturn(null);
      when(() => mockInvoice.zatcaHash).thenReturn(null);

      when(() => mockRepository.getJournalEntries())
          .thenAnswer((_) async => []);
      when(() => mockInvoiceRepository.getInvoiceById('inv-1'))
          .thenAnswer((_) async => mockInvoice);

      final context = AccountingContext(
        proposedJournalEntry: entry,
        transactionType: 'manual',
        locale: 'en',
      );

      final result = await service.process(context);

      expect(
        result.rationale,
        contains('ZATCA Phase 2 cryptographic identity'),
      );
    });

    test('should NOT flag if ZATCA identity is present', () async {
      final now = DateTime.now();
      final entry = JournalEntry(
        id: 'je-inv-1',
        referenceNumber: 'JE-001',
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
        description: 'Invoice entry',
        status: JournalEntryStatus.posted,
        sourceDocument: 'invoice',
        sourceId: 'inv-1',
        createdBy: 'test-user',
        createdAt: now,
        updatedAt: now,
        lines: const [],
      );

      final mockInvoice = MockInvoice();
      when(() => mockInvoice.zatcaUuid).thenReturn('uuid-123');
      when(() => mockInvoice.zatcaHash).thenReturn('hash-456');

      when(() => mockRepository.getJournalEntries())
          .thenAnswer((_) async => []);
      when(() => mockInvoiceRepository.getInvoiceById('inv-1'))
          .thenAnswer((_) async => mockInvoice);

      final context = AccountingContext(
        proposedJournalEntry: entry,
        transactionType: 'manual',
        locale: 'en',
      );

      final result = await service.process(context);

      expect(
        result.rationale,
        isNot(contains('ZATCA Phase 2 cryptographic identity')),
      );
    });
  });
}
