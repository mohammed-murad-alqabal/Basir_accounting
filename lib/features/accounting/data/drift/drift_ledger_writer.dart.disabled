import 'dart:convert';

import 'package:basir_accounting_system/core/database/drift/app_database.dart';
import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';

class DriftJournalLineInput {
  const DriftJournalLineInput({
    required this.accountId,
    required this.debitMinor,
    required this.creditMinor,
    required this.currencyCode,
  });

  final String accountId;
  final int debitMinor;
  final int creditMinor;
  final String currencyCode;
}

class DriftJournalCommand {
  const DriftJournalCommand({
    required this.tenantId,
    required this.entryId,
    required this.idempotencyKey,
    required this.referenceNumber,
    required this.fiscalPeriodId,
    required this.sourceType,
    required this.transactionDate,
    required this.effectiveDate,
    required this.recordingDate,
    required this.createdBy,
    required this.lines,
    this.sourceId,
    this.writerEpoch = 'drift-foundation-1',
  });

  final String tenantId;
  final String entryId;
  final String idempotencyKey;
  final String referenceNumber;
  final String fiscalPeriodId;
  final String sourceType;
  final String? sourceId;
  final DateTime transactionDate;
  final DateTime effectiveDate;
  final DateTime recordingDate;
  final String createdBy;
  final List<DriftJournalLineInput> lines;
  final String writerEpoch;

  DriftJournalCommand copyWith({
    String? fiscalPeriodId,
    List<DriftJournalLineInput>? lines,
  }) =>
      DriftJournalCommand(
        tenantId: tenantId,
        entryId: entryId,
        idempotencyKey: idempotencyKey,
        referenceNumber: referenceNumber,
        fiscalPeriodId: fiscalPeriodId ?? this.fiscalPeriodId,
        sourceType: sourceType,
        sourceId: sourceId,
        transactionDate: transactionDate,
        effectiveDate: effectiveDate,
        recordingDate: recordingDate,
        createdBy: createdBy,
        lines: lines ?? this.lines,
        writerEpoch: writerEpoch,
      );
}

class DriftPostingReceipt {
  const DriftPostingReceipt({
    required this.receiptId,
    required this.entryId,
    required this.commandHash,
  });

  final String receiptId;
  final String entryId;
  final String commandHash;
}

class DriftLedgerException implements Exception {
  const DriftLedgerException(this.message);

  final String message;

  @override
  String toString() => 'DriftLedgerException: $message';
}

/// A staged, storage-specific ledger writer.
///
/// This writer is deliberately not wired into the existing Isar repository.
/// It provides a safe seam for parity and canary testing before any authority
/// switch is considered.
class DriftLedgerWriter {
  DriftLedgerWriter(this.database);

  final AppDatabase database;

  Future<DriftPostingReceipt> post(DriftJournalCommand command) async {
    _validateCommand(command);
    final commandHash = _hashCommand(command);

    return database.transaction(() async {
      final existing = await (database.select(database.idempotencyKeys)
            ..where(
              (row) =>
                  row.tenantId.equals(command.tenantId) &
                  row.key.equals(command.idempotencyKey),
            ))
          .getSingleOrNull();

      if (existing != null) {
        if (existing.commandHash != commandHash) {
          throw const DriftLedgerException(
            'IDEMPOTENCY_KEY_REUSED_WITH_DIFFERENT_COMMAND',
          );
        }
        if (existing.receiptId == null) {
          throw const DriftLedgerException('IDEMPOTENCY_OPERATION_IN_PROGRESS');
        }
        final receipt = await (database.select(database.postingReceipts)
              ..where((row) => row.id.equals(existing.receiptId!)))
            .getSingleOrNull();
        if (receipt == null) {
          throw const DriftLedgerException('IDEMPOTENCY_RECEIPT_MISSING');
        }
        return DriftPostingReceipt(
          receiptId: receipt.id,
          entryId: receipt.entryId,
          commandHash: receipt.commandHash,
        );
      }

      final period = await (database.select(database.fiscalPeriods)
            ..where(
              (row) =>
                  row.id.equals(command.fiscalPeriodId) &
                  row.tenantId.equals(command.tenantId),
            ))
          .getSingleOrNull();
      if (period == null) {
        throw const DriftLedgerException('FISCAL_PERIOD_NOT_FOUND');
      }
      if (period.status != 'OPEN') {
        throw const DriftLedgerException('FISCAL_PERIOD_NOT_OPEN');
      }

      for (final line in command.lines) {
        final account = await (database.select(database.accounts)
              ..where(
                (row) =>
                    row.id.equals(line.accountId) &
                    row.tenantId.equals(command.tenantId),
              ))
            .getSingleOrNull();
        if (account == null) {
          throw const DriftLedgerException('ACCOUNT_NOT_FOUND_OR_WRONG_TENANT');
        }
        if (!account.isActive || !account.isPostingAllowed) {
          throw const DriftLedgerException('ACCOUNT_NOT_POSTABLE');
        }
      }

      await database.into(database.idempotencyKeys).insert(
            IdempotencyKeysCompanion.insert(
              id: 'idem-${command.idempotencyKey}',
              tenantId: command.tenantId,
              key: command.idempotencyKey,
              commandType: 'POST_JOURNAL',
              commandHash: commandHash,
              state: 'ACCEPTED',
              createdAt: command.recordingDate,
            ),
          );

      await database.into(database.journalEntries).insert(
            JournalEntriesCompanion.insert(
              id: command.entryId,
              tenantId: command.tenantId,
              fiscalPeriodId: command.fiscalPeriodId,
              referenceNumber: command.referenceNumber,
              sourceType: command.sourceType,
              sourceId: Value(command.sourceId),
              status: 'POSTED',
              transactionDate: command.transactionDate,
              effectiveDate: command.effectiveDate,
              recordingDate: command.recordingDate,
              postedAt: Value(command.recordingDate),
              createdBy: command.createdBy,
              createdAt: command.recordingDate,
              updatedAt: command.recordingDate,
              rowVersion: commandHash,
            ),
          );

      for (var index = 0; index < command.lines.length; index++) {
        final line = command.lines[index];
        await database.into(database.journalLines).insert(
              JournalLinesCompanion.insert(
                id: '${command.entryId}-line-${index + 1}',
                entryId: command.entryId,
                lineNumber: index + 1,
                accountId: line.accountId,
                debitMinor: Value(line.debitMinor),
                creditMinor: Value(line.creditMinor),
                currencyCode: line.currencyCode,
              ),
            );
      }

      final receiptId = 'receipt-${command.entryId}';
      await database.into(database.postingReceipts).insert(
            PostingReceiptsCompanion.insert(
              id: receiptId,
              tenantId: command.tenantId,
              entryId: command.entryId,
              idempotencyKeyId: 'idem-${command.idempotencyKey}',
              writerEpoch: command.writerEpoch,
              commandHash: commandHash,
              acceptedAt: command.recordingDate,
            ),
          );

      final nextSequence = await _nextOutboxSequence(command.tenantId);
      await database.into(database.outboxEvents).insert(
            OutboxEventsCompanion.insert(
              id: 'outbox-$receiptId',
              tenantId: command.tenantId,
              sequence: nextSequence,
              aggregateType: 'JOURNAL_ENTRY',
              aggregateId: command.entryId,
              eventType: 'JOURNAL_POSTED',
              payloadJson: jsonEncode({
                'entry_id': command.entryId,
                'tenant_id': command.tenantId,
                'receipt_id': receiptId,
              }),
              payloadHash: commandHash,
              state: 'PENDING',
              createdAt: command.recordingDate,
            ),
          );

      await (database.update(database.idempotencyKeys)
            ..where((row) => row.id.equals('idem-${command.idempotencyKey}')))
          .write(
        IdempotencyKeysCompanion(
          state: const Value('APPLIED'),
          receiptId: Value(receiptId),
          completedAt: Value(command.recordingDate),
        ),
      );

      return DriftPostingReceipt(
        receiptId: receiptId,
        entryId: command.entryId,
        commandHash: commandHash,
      );
    });
  }

  Future<int> _nextOutboxSequence(String tenantId) async {
    final rows = await (database.select(database.outboxEvents)
          ..where((row) => row.tenantId.equals(tenantId))
          ..orderBy([(row) => OrderingTerm.desc(row.sequence)])
          ..limit(1))
        .get();
    return rows.isEmpty ? 1 : rows.single.sequence + 1;
  }

  static void _validateCommand(DriftJournalCommand command) {
    if (command.tenantId.trim().isEmpty ||
        command.entryId.trim().isEmpty ||
        command.idempotencyKey.trim().isEmpty) {
      throw const DriftLedgerException('COMMAND_IDENTITY_REQUIRED');
    }
    if (command.lines.isEmpty) {
      throw const DriftLedgerException('JOURNAL_REQUIRES_LINES');
    }

    var debit = 0;
    var credit = 0;
    for (final line in command.lines) {
      if (line.debitMinor < 0 || line.creditMinor < 0) {
        throw const DriftLedgerException('NEGATIVE_AMOUNT_NOT_ALLOWED');
      }
      if ((line.debitMinor > 0) == (line.creditMinor > 0)) {
        throw const DriftLedgerException('LINE_MUST_HAVE_ONE_SIDE');
      }
      debit += line.debitMinor;
      credit += line.creditMinor;
    }
    if (debit == 0 || debit != credit) {
      throw const DriftLedgerException('JOURNAL_NOT_BALANCED');
    }
  }

  static String _hashCommand(DriftJournalCommand command) {
    final canonical = <String>[
      command.tenantId,
      command.entryId,
      command.idempotencyKey,
      command.referenceNumber,
      command.fiscalPeriodId,
      command.sourceType,
      command.sourceId ?? '',
      ...command.lines.map(
        (line) =>
            '${line.accountId}:${line.debitMinor}:${line.creditMinor}:${line.currencyCode}',
      ),
    ].join('|');
    return sha256.convert(utf8.encode(canonical)).toString();
  }
}
