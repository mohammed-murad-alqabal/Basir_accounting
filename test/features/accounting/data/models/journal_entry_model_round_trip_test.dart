import 'dart:io';

import 'package:basir_accounting_system/core/models/sync_status.dart';
import 'package:basir_accounting_system/features/accounting/data/models/journal_entry_model.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/journal_entry.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';

void main() {
  late Directory temporaryDirectory;
  late Isar isar;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
  });

  setUp(() async {
    temporaryDirectory = Directory.systemTemp.createTempSync();
    isar = await Isar.open(
      [JournalEntryModelSchema],
      directory: temporaryDirectory.path,
    );
  });

  tearDown(() async {
    await isar.close();
    if (temporaryDirectory.existsSync()) {
      temporaryDirectory.deleteSync(recursive: true);
    }
  });

  group('JournalEntryModel round-trip', () {
    test('preserves the complete Dart persistence contract through Isar',
        () async {
      final source = _entryFixture();

      await isar.writeTxn(() async {
        await isar.journalEntryModels.put(
          JournalEntryModel.fromEntity(source),
        );
      });

      final stored = await isar.journalEntryModels
          .filter()
          .idEqualTo(source.id)
          .findFirst();

      expect(stored, isNotNull);
      final restored = stored!.toEntity();

      expect(restored, source);
      expect(restored.lines.first.debit.toString(), '123456789.123456789');
      expect(restored.lines.first.exchangeRate.toString(), '3.7500000001');
      expect(
        restored.lines.first.originalAmount.toString(),
        '329218106.788065842',
      );
      expect(restored.auditLogs, hasLength(1));
      expect(restored.auditLogs.single.actor, 'user-001');
      expect(restored.syncStatus, SyncStatus.pendingPush);
    });

    test('rejects invalid stored decimal text instead of substituting zero',
        () {
      final invalidLine = JournalEntryLineModel()
        ..accountId = 'account-001'
        ..accountName = 'Cash'
        ..debit = 'not-a-decimal'
        ..credit = '0';

      expect(invalidLine.toEntity, throwsFormatException);
    });
  });
}

JournalEntry _entryFixture() {
  final timestamp = DateTime.utc(2026, 8, 13, 12, 30);
  return JournalEntry(
    id: 'entry-001',
    referenceNumber: 'JE-2026-0001',
    date: timestamp,
    temporal: TemporalJustification(
      transactionDate: timestamp,
      effectiveDate: timestamp,
      recordingDate: timestamp,
    ),
    standards: const StandardsJustification(
      standardReference: 'IAS 21.21',
      recognitionBasis: 'Accrual',
      measurementBasis: 'Historical cost',
    ),
    description: 'Multi-currency round-trip fixture',
    status: JournalEntryStatus.posted,
    lines: [
      JournalEntryLine(
        accountId: 'account-001',
        accountName: 'Cash',
        debit: Decimal.parse('123456789.123456789'),
        credit: Decimal.zero,
        description: 'Debit leg',
        sourceDocumentRef: 'INV-001',
        costCenterId: 'CC-001',
        originalCurrency: 'USD',
        exchangeRate: Decimal.parse('3.7500000001'),
        originalAmount: Decimal.parse('329218106.788065842'),
      ),
      JournalEntryLine(
        accountId: 'account-002',
        accountName: 'Revenue',
        debit: Decimal.zero,
        credit: Decimal.parse('123456789.123456789'),
        description: 'Credit leg',
        sourceDocumentRef: 'INV-001',
        costCenterId: 'CC-001',
        originalCurrency: 'USD',
        exchangeRate: Decimal.parse('3.7500000001'),
        originalAmount: Decimal.parse('329218106.788065842'),
      ),
    ],
    sourceDocument: 'sales_invoice',
    sourceId: 'invoice-001',
    createdBy: 'user-001',
    createdAt: timestamp,
    updatedAt: timestamp,
    hash: 'hash-001',
    previousHash: 'hash-000',
    postedAt: timestamp,
    userId: 'tenant-001',
    warehouseId: 'warehouse-001',
    auditLogs: [
      AuditLogEntry(
        timestamp: timestamp,
        action: 'JOURNAL_POSTED',
        rationale: 'Round-trip evidence',
        actor: 'user-001',
      ),
    ],
    syncStatus: SyncStatus.pendingPush,
    serverUpdatedAt: timestamp,
  );
}
