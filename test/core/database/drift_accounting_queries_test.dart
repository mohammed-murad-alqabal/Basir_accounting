@TestOn('vm')
library;

import 'package:basir_accounting_system/core/database/drift/app_database.dart';
import 'package:basir_accounting_system/features/accounting/data/drift/drift_accounting_queries.dart';
import 'package:basir_accounting_system/features/accounting/data/drift/drift_ledger_writer.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;
  late DriftLedgerWriter writer;
  late DriftAccountingQueries queries;
  final now = DateTime.utc(2026, 8, 27, 12);

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    writer = DriftLedgerWriter(database);
    queries = DriftAccountingQueries(database);
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

  test('returns only posted facts grouped by account and currency', () async {
    await writer.post(
      DriftJournalCommand(
        tenantId: 'tenant-1',
        entryId: 'entry-1',
        idempotencyKey: 'command-1',
        referenceNumber: 'JE-entry-1',
        fiscalPeriodId: 'period-open',
        sourceType: 'MANUAL',
        transactionDate: DateTime.utc(2026, 1, 10),
        effectiveDate: DateTime.utc(2026, 1, 10),
        recordingDate: now,
        createdBy: 'test-user',
        lines: const [
          DriftJournalLineInput(
            accountId: 'cash',
            debitMinor: 1500,
            creditMinor: 0,
            currencyCode: 'SAR',
          ),
          DriftJournalLineInput(
            accountId: 'revenue',
            debitMinor: 0,
            creditMinor: 1500,
            currencyCode: 'SAR',
          ),
        ],
      ),
    );

    final rows = await queries.trialBalance(
      tenantId: 'tenant-1',
      fiscalPeriodId: 'period-open',
    );

    expect(rows, hasLength(2));
    expect(rows.first.totalDebitMinor + rows.last.totalDebitMinor, 1500);
    expect(rows.first.totalCreditMinor + rows.last.totalCreditMinor, 1500);
    expect(
      await queries.countPostedEntries(
        tenantId: 'tenant-1',
        fiscalPeriodId: 'period-open',
      ),
      1,
    );
  });
}
