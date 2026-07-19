import 'package:flutter/material.dart';

/// Represents the real-time integrity status of the General Ledger.
enum IntegrityStatus {
  /// The ledger is perfectly consistent and the hash chain is intact.
  healthy,

  /// Minor anomalies detected that can be self-healed (e.g., rounding).
  needsHeal,

  /// Significant integrity breach detected
  /// (e.g., hash mismatch, unauthorized edit).
  compromised,
}

/// Detailed health information about the ledger.
class LedgerHealth {
  /// Creates a [LedgerHealth] status object.
  const LedgerHealth({
    required this.status,
    required this.lastVerification,
    required this.verifiedCount,
    required this.errorCount,
    this.anomalousEntryIds = const [],
    this.message,
  });

  /// The current integrity status of the ledger.
  final IntegrityStatus status;

  /// The timestamp of the last verification run.
  final DateTime lastVerification;

  /// The total number of entries verified.
  final int verifiedCount;

  /// The number of integrity errors found.
  final int errorCount;

  /// A list of IDs for entries identified as anomalous.
  final List<String> anomalousEntryIds;

  /// An optional message providing more details about the health status.
  final String? message;

  /// Creates a copy of [LedgerHealth] with modified fields.
  LedgerHealth copyWith({
    IntegrityStatus? status,
    DateTime? lastVerification,
    int? verifiedCount,
    int? errorCount,
    List<String>? anomalousEntryIds,
    String? message,
  }) =>
      LedgerHealth(
        status: status ?? this.status,
        lastVerification: lastVerification ?? this.lastVerification,
        verifiedCount: verifiedCount ?? this.verifiedCount,
        errorCount: errorCount ?? this.errorCount,
        anomalousEntryIds: anomalousEntryIds ?? this.anomalousEntryIds,
        message: message ?? this.message,
      );

  /// Returns a color representation of the health status.
  Color get color {
    switch (status) {
      case IntegrityStatus.healthy:
        return Colors.green;
      case IntegrityStatus.needsHeal:
        return Colors.orange;
      case IntegrityStatus.compromised:
        return Colors.red;
    }
  }
}
