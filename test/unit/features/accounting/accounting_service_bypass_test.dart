// ignore_for_file: lines_longer_than_80_chars
import 'dart:async';

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

class TestFinancialYearService extends FinancialYearService {
  TestFinancialYearService({required this.canPost});

  final bool canPost;

  @override
  FutureOr<void> build() {}

  @override
  Future<bool> canPostToDate(DateTime date) async => canPost;
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
        financialYearServiceProvider.overrideWith(
          () => TestFinancialYearService(canPost: true),
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

      when(() => mockRepository.addJournalEntry(any())).thenAnswer((_) async => {});

      final service = container.read(accountingServiceProvider.notifier);

      await service.postJournalEntry(entry, bypassCognitive: true);

      // Verify repository call captured the modified entry with logs
      final capturedEntry =
          verify(() => mockRepository.addJournalEntry(captureAny())).captured.first as JournalEntry;

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
