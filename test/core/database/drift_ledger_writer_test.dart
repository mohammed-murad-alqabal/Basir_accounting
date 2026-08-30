@TestOn('vm')
library;

import 'package:basir_accounting_system/core/database/drift/app_database.dart';
import 'package:basir_accounting_system/features/accounting/data/drift/drift_ledger_writer.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;
  late DriftLedgerWriter writer;
  final now = DateTime.utc(2026, 8, 27, 12);

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    writer = DriftLedgerWriter(database);
    await database.into(database.tenants).insert(
          TenantsCompanion.insert(
            id: 'tenant-1',
            legalName: 'Basir Test Company',
            baseCurrency: 'SAR',
            createdAt: now,
          ),
        );
    await database.into(database.fiscalPeriods).insert(
          FiscalPeriodsCompanion.insert(
            id: 'period-open',
            tenantId: 'tenant-1',
            code: '2026-01',
            startDate: DateTime.utc(2026),
            endDate: DateTime.utc(2026, 1, 31, 23, 59, 59),
            status: 'OPEN',
          ),
        );
    await database.into(database.accounts).insert(
          AccountsCompanion.insert(
            id: 'cash',
            tenantId: 'tenant-1',
            code: '1101',
            nameAr: 'النقدية',
            nameEn: 'Cash',
            type: 'ASSET',
            nature: 'DEBIT',
            createdAt: now,
            updatedAt: now,
          ),
        );
    await database.into(database.accounts).insert(
          AccountsCompanion.insert(
            id: 'revenue',
            tenantId: 'tenant-1',
            code: '4101',
            nameAr: 'الإيراد',
            nameEn: 'Revenue',
            type: 'REVENUE',
            nature: 'CREDIT',
            createdAt: now,
            updatedAt: now,
          ),
        );
  });

  tearDown(() async {
    await database.close();
  });

  DriftJournalCommand balancedCommand({
    String entryId = 'entry-1',
    String idempotencyKey = 'command-1',
    String periodId = 'period-open',
  }) =>
      DriftJournalCommand(
        tenantId: 'tenant-1',
        entryId: entryId,
        idempotencyKey: idempotencyKey,
        referenceNumber: 'JE-$entryId',
        fiscalPeriodId: periodId,
        sourceType: 'MANUAL',
        transactionDate: DateTime.utc(2026, 1, 10),
        effectiveDate: DateTime.utc(2026, 1, 10),
        recordingDate: now,
        createdBy: 'test-user',
        lines: const [
          DriftJournalLineInput(
            accountId: 'cash',
            debitMinor: 1000,
            creditMinor: 0,
            currencyCode: 'SAR',
          ),
          DriftJournalLineInput(
            accountId: 'revenue',
            debitMinor: 0,
            creditMinor: 1000,
            currencyCode: 'SAR',
          ),
        ],
      );

  test('posts a balanced journal atomically with receipt and outbox', () async {
    final receipt = await writer.post(balancedCommand());

    expect(receipt.entryId, 'entry-1');
    expect(await database.select(database.journalEntries).get(), hasLength(1));
    expect(await database.select(database.journalLines).get(), hasLength(2));
    expect(await database.select(database.postingReceipts).get(), hasLength(1));
    final outbox = await database.select(database.outboxEvents).get();
    expect(outbox, hasLength(1));
    expect(outbox.single.state, 'PENDING');
  });

  test(
      'replaying the same command returns the same receipt without duplication',
      () async {
    final command = balancedCommand();
    final first = await writer.post(command);
    final second = await writer.post(command);

    expect(second.receiptId, first.receiptId);
    expect(await database.select(database.journalEntries).get(), hasLength(1));
    expect(await database.select(database.postingReceipts).get(), hasLength(1));
    expect(await database.select(database.outboxEvents).get(), hasLength(1));
  });

  test('rejects an unbalanced journal before opening a write transaction',
      () async {
    final command = balancedCommand().copyWith(
      lines: const [
        DriftJournalLineInput(
          accountId: 'cash',
          debitMinor: 1001,
          creditMinor: 0,
          currencyCode: 'SAR',
        ),
        DriftJournalLineInput(
          accountId: 'revenue',
          debitMinor: 0,
          creditMinor: 1000,
          currencyCode: 'SAR',
        ),
      ],
    );

    await expectLater(
      writer.post(command),
      throwsA(
        predicate<DriftLedgerException>(
          (error) => error.message == 'JOURNAL_NOT_BALANCED',
        ),
      ),
    );
    expect(await database.select(database.journalEntries).get(), isEmpty);
  });

  test('rejects a closed fiscal period', () async {
    await database.into(database.fiscalPeriods).insert(
          FiscalPeriodsCompanion.insert(
            id: 'period-closed',
            tenantId: 'tenant-1',
            code: '2025-12',
            startDate: DateTime.utc(2025, 12),
            endDate: DateTime.utc(2025, 12, 31, 23, 59, 59),
            status: 'CLOSED',
            closedAt: Value(now),
            closedBy: const Value('controller'),
          ),
        );

    await expectLater(
      writer.post(balancedCommand(periodId: 'period-closed')),
      throwsA(
        predicate<DriftLedgerException>(
          (error) => error.message == 'FISCAL_PERIOD_NOT_OPEN',
        ),
      ),
    );
  });

  test('rejects an account from another tenant scope', () async {
    await database.into(database.tenants).insert(
          TenantsCompanion.insert(
            id: 'tenant-2',
            legalName: 'Other Company',
            baseCurrency: 'SAR',
            createdAt: now,
          ),
        );
    await database.into(database.accounts).insert(
          AccountsCompanion.insert(
            id: 'other-cash',
            tenantId: 'tenant-2',
            code: '1101',
            nameAr: 'نقدية أخرى',
            nameEn: 'Other Cash',
            type: 'ASSET',
            nature: 'DEBIT',
            createdAt: now,
            updatedAt: now,
          ),
        );

    final command = balancedCommand().copyWith(
      lines: const [
        DriftJournalLineInput(
          accountId: 'other-cash',
          debitMinor: 1000,
          creditMinor: 0,
          currencyCode: 'SAR',
        ),
        DriftJournalLineInput(
          accountId: 'revenue',
          debitMinor: 0,
          creditMinor: 1000,
          currencyCode: 'SAR',
        ),
      ],
    );

    await expectLater(
      writer.post(command),
      throwsA(
        predicate<DriftLedgerException>(
          (error) => error.message == 'ACCOUNT_NOT_FOUND_OR_WRONG_TENANT',
        ),
      ),
    );
  });
}
