import 'dart:convert';

import 'package:basir_accounting_system/core/models/sync_status.dart';
import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/accounting/application/authoritative_ledger_gateway.dart';
import 'package:basir_accounting_system/features/accounting/data/models/ledger_outbox_model.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/journal_entry.dart';
import 'package:basir_accounting_system/features/accounting/domain/repositories/accounting_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

/// Signals that an otherwise valid command was saved for retry but has no
/// authoritative receipt yet. Callers must not treat this as a posted fact.
class LedgerPostQueuedException implements Exception {
  const LedgerPostQueuedException(this.operationId, this.cause);

  final String operationId;
  final Object cause;

  @override
  String toString() => 'LEDGER_POST_QUEUED: $operationId; cause=$cause';
}

/// Persists and flushes ledger commands for transport-only failures.
///
/// Server validation, authorization and accounting failures propagate to the
/// caller and are never queued, because retrying them would conceal a rejected
/// business event.
class LedgerOutboxService {
  LedgerOutboxService({
    required Isar isar,
    required AuthoritativeLedgerGateway gateway,
    required AccountingRepository repository,
  })  : _isar = isar,
        _gateway = gateway,
        _repository = repository;

  final Isar _isar;
  final AuthoritativeLedgerGateway _gateway;
  final AccountingRepository _repository;

  /// Posts now and caches the receipt; queues only a transport failure.
  Future<void> postOrEnqueue(JournalEntry entry) async {
    try {
      final receipt = await _gateway.post(entry);
      await _cacheReceipt(entry, receipt);
    } on LedgerTransportException catch (error) {
      final operationId = SupabaseLedgerGateway.operationIdFor(entry.id);
      await enqueue(entry, error);
      throw LedgerPostQueuedException(operationId, error);
    }
  }

  /// Replays pending commands in creation order. A transport failure leaves the
  /// current and later commands untouched; a server rejection is retained with
  /// an error marker and then surfaced to the caller.
  Future<void> flush() async {
    final pending =
        await _isar.ledgerOutboxModels.where().sortByCreatedAt().findAll();
    for (final command in pending) {
      final entry = JournalEntry.fromJson(
        jsonDecode(command.payload) as Map<String, dynamic>,
      );
      try {
        final receipt = await _gateway.post(entry);
        await _cacheReceipt(entry, receipt);
        await _isar
            .writeTxn(() => _isar.ledgerOutboxModels.delete(command.isarId!));
      } on LedgerTransportException catch (error) {
        await _recordAttempt(command, error);
        break;
      } on Object catch (error) {
        await _recordAttempt(command, error);
        rethrow;
      }
    }
  }

  /// Persists a transport-failed command for a later replay.
  ///
  /// This API is intentionally typed to [LedgerTransportException] so callers
  /// cannot enqueue a rejected authoritative response by accident.
  Future<void> enqueue(
    JournalEntry entry,
    LedgerTransportException error,
  ) async {
    final operationId = SupabaseLedgerGateway.operationIdFor(entry.id);
    final existing = await _isar.ledgerOutboxModels
        .filter()
        .operationIdEqualTo(operationId)
        .findFirst();
    if (existing != null) {
      await _recordAttempt(existing, error);
      return;
    }

    final command = LedgerOutboxModel()
      ..operationId = operationId
      ..localEntryId = entry.id
      ..payload = jsonEncode(entry.toJson())
      ..createdAt = DateTime.now().toUtc()
      ..attemptCount = 1
      ..lastAttemptAt = DateTime.now().toUtc()
      ..lastError = error.toString();
    await _isar.writeTxn(() => _isar.ledgerOutboxModels.put(command));
  }

  Future<void> _recordAttempt(LedgerOutboxModel command, Object error) async {
    command
      ..attemptCount += 1
      ..lastAttemptAt = DateTime.now().toUtc()
      ..lastError = error.toString();
    await _isar.writeTxn(() => _isar.ledgerOutboxModels.put(command));
  }

  Future<void> _cacheReceipt(
    JournalEntry entry,
    LedgerPostReceipt receipt,
  ) =>
      _repository.cacheAuthoritativeJournalEntry(
        entry.copyWith(
          authoritativeEntryId: receipt.entryId,
          hash: receipt.entryHash,
          previousHash: receipt.previousHash,
          postedAt: receipt.postedAt,
          updatedAt: receipt.postedAt,
          serverUpdatedAt: receipt.postedAt,
          syncStatus: SyncStatus.synced,
          status: JournalEntryStatus.posted,
        ),
      );
}

final ledgerOutboxServiceProvider = Provider<LedgerOutboxService>((ref) {
  final isar = ref.watch(isarProvider).value;
  if (isar == null) throw StateError('Isar is not initialized');
  return LedgerOutboxService(
    isar: isar,
    gateway: ref.watch(authoritativeLedgerGatewayProvider),
    repository: ref.watch(accountingRepositoryProvider),
  );
});
