@TestOn('vm')
library;

import 'package:basir_accounting_system/core/database/drift/app_database.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;
  final now = DateTime.utc(2026, 8, 27, 12);

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  Future<void> seedTenantAndPeriod() async {
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
            id: 'period-2026-01',
            tenantId: 'tenant-1',
            code: '2026-01',
            startDate: DateTime.utc(2026),
            endDate: DateTime.utc(2026, 1, 31, 23, 59, 59),
            status: 'OPEN',
          ),
        );
  }

  test('scopes account code uniqueness by tenant', () async {
    await seedTenantAndPeriod();

    final account = AccountsCompanion.insert(
      id: 'account-1',
      tenantId: 'tenant-1',
      code: '1101',
      nameAr: 'النقدية',
      nameEn: 'Cash',
      type: 'ASSET',
      nature: 'DEBIT',
      createdAt: now,
      updatedAt: now,
    );
    await database.into(database.accounts).insert(account);

    expect(
      () => database.into(database.accounts).insert(
            account.copyWith(id: const Value('account-2')),
          ),
      throwsA(isA<Exception>()),
    );
  });

  test('rejects a journal line with both debit and credit', () async {
    await seedTenantAndPeriod();
    await database.into(database.accounts).insert(
          AccountsCompanion.insert(
            id: 'account-1',
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
    await database.into(database.journalEntries).insert(
          JournalEntriesCompanion.insert(
            id: 'entry-1',
            tenantId: 'tenant-1',
            fiscalPeriodId: 'period-2026-01',
            referenceNumber: 'JE-1',
            sourceType: 'MANUAL',
            status: 'DRAFT',
            transactionDate: DateTime.utc(2026, 1, 10),
            effectiveDate: DateTime.utc(2026, 1, 10),
            recordingDate: now,
            createdBy: 'test',
            createdAt: now,
            updatedAt: now,
            rowVersion: '1',
          ),
        );

    expect(
      () => database.into(database.journalLines).insert(
            JournalLinesCompanion.insert(
              id: 'line-1',
              entryId: 'entry-1',
              lineNumber: 1,
              accountId: 'account-1',
              debitMinor: const Value(100),
              creditMinor: const Value(100),
              currencyCode: 'SAR',
            ),
          ),
      throwsA(isA<Exception>()),
    );
  });

  test('prevents mutation of material posted-entry fields', () async {
    await seedTenantAndPeriod();
    await database.into(database.journalEntries).insert(
          JournalEntriesCompanion.insert(
            id: 'entry-1',
            tenantId: 'tenant-1',
            fiscalPeriodId: 'period-2026-01',
            referenceNumber: 'JE-1',
            sourceType: 'MANUAL',
            status: 'POSTED',
            transactionDate: DateTime.utc(2026, 1, 10),
            effectiveDate: DateTime.utc(2026, 1, 10),
            recordingDate: now,
            postedAt: Value(now),
            createdBy: 'test',
            createdAt: now,
            updatedAt: now,
            rowVersion: '1',
          ),
        );

    expect(
      () => (database.update(database.journalEntries)
            ..where((row) => row.id.equals('entry-1')))
          .write(const JournalEntriesCompanion(referenceNumber: Value('JE-2'))),
      throwsA(isA<Exception>()),
    );
  });

  test('enforces one idempotency key per tenant', () async {
    await seedTenantAndPeriod();
    final key = IdempotencyKeysCompanion.insert(
      id: 'idem-1',
      tenantId: 'tenant-1',
      key: 'command-1',
      commandType: 'POST_JOURNAL',
      commandHash: 'hash-1',
      state: 'APPLIED',
      createdAt: now,
    );
    await database.into(database.idempotencyKeys).insert(key);

    expect(
      () => database.into(database.idempotencyKeys).insert(
            key.copyWith(id: const Value('idem-2')),
          ),
      throwsA(isA<Exception>()),
    );
  });
}
