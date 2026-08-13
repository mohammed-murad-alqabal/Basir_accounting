import 'package:isar/isar.dart';

part 'ledger_outbox_model.g.dart';

/// Durable local command queue for ledger posts that failed before a server
/// receipt was received. It deliberately stores a command, never a local
/// substitute for a posted ledger fact.
@collection
class LedgerOutboxModel {
  LedgerOutboxModel();

  Id? isarId;

  /// Deterministic Postgres operation UUID. Duplicate enqueue is idempotent.
  @Index(unique: true, replace: true)
  late String operationId;

  /// Local journal identifier used to reconstruct the original command.
  @Index()
  late String localEntryId;

  /// JSON-encoded journal-entry command. It is not rendered as a ledger fact.
  late String payload;

  late DateTime createdAt;
  late int attemptCount;
  DateTime? lastAttemptAt;
  String? lastError;
}
