import 'package:freezed_annotation/freezed_annotation.dart';

part 'integrity_pulse.freezed.dart';

@freezed

/// Represents the state of the system's forensic health.
class IntegrityPulse with _$IntegrityPulse {
  /// Creates an [IntegrityPulse].
  const factory IntegrityPulse({
    /// Whether the system state is healthy.
    required bool isHealthy,

    /// Hash of the last verified entry.
    required String lastVerifiedHash,

    /// Timestamp of the last successful verification.
    required DateTime lastVerifiedAt,

    /// Total number of blocks scanned in the last audit.
    required int totalBlocksScanned,

    /// Overall health percentage of the ledger.
    required double healthPercentage,
  }) = _IntegrityPulse;
}

@freezed

/// A single verifiable block in the historical ledger.
class LedgerBlock with _$LedgerBlock {
  /// Creates a [LedgerBlock].
  const factory LedgerBlock({
    /// Unique identifier of the journal entry.
    required String entryId,

    /// Reference number of the transaction.
    required String referenceNumber,

    /// Date of the transaction.
    required DateTime date,

    /// Hash of the current block.
    required String? hash,

    /// Hash of the preceding block.
    required String? previousHash,

    /// Whether the block signature is verified.
    required bool isVerified,

    /// Signature of the agent that verified the block.
    required String agentSignature,
  }) = _LedgerBlock;
}
