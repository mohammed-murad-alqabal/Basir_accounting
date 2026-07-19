// ignore_for_file: lines_longer_than_80_chars
import 'package:basir_accounting_system/core/models/sync_status.dart';
import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'journal_entry.freezed.dart';
part 'journal_entry.g.dart';

/// Operational lifecycle states of a Journal Entry.
enum JournalEntryStatus {
  /// Initial editable state for preparation.
  draft,

  /// Final immutable state. Once posted, modifications are strictly prohibited.
  /// (Standard Reference: FR-ACC-006)
  posted,

  /// Cancelled state with a corresponding reversing entry for audit integrity.
  voided,
}

/// Comprehensive temporal metadata for multi-perspective audit trails.
/// (Standard Reference: CP-008: Temporal Justification)
@freezed
class TemporalJustification with _$TemporalJustification {
  /// Creates a temporal justification record.
  const factory TemporalJustification({
    /// The actual date the business transaction occurred.
    required DateTime transactionDate,

    /// The date the entry influences the financial statements (Posting Date).
    required DateTime effectiveDate,

    /// The system-generated timestamp of the entry creation.
    required DateTime recordingDate,
  }) = _TemporalJustification;

  /// deserialization from JSON format.
  factory TemporalJustification.fromJson(Map<String, dynamic> json) =>
      _$TemporalJustificationFromJson(json);
}

/// Scientific and regulatory justification for financial recognition.
/// (Standard Reference: CP-002: Standards Reference Integrity)
@freezed
class StandardsJustification with _$StandardsJustification {
  /// Creates a regulatory standards justification.
  const factory StandardsJustification({
    /// Specific standard clause reference (e.g., "IFRS 15.35").
    required String standardReference,

    /// Logic for recognizing the transaction (e.g., "Cash Receipt", "Accrual").
    String? recognitionBasis,

    /// Value determination method (e.g., "Amortized Cost", "Fair Value").
    String? measurementBasis,
  }) = _StandardsJustification;

  /// deserialization from JSON format.
  factory StandardsJustification.fromJson(Map<String, dynamic> json) =>
      _$StandardsJustificationFromJson(json);
}

/// Internal audit log entry for system-level event tracking.
/// (Standard Reference: CP-011: Forensic Traceability)
@freezed
class AuditLogEntry with _$AuditLogEntry {
  /// Creates an audit log entry.
  const factory AuditLogEntry({
    /// Systematic timestamp of the event.
    required DateTime timestamp,

    /// Descriptive name of the action performed.
    required String action,

    /// Contextual explanation or justification for the recorded action.
    required String rationale,

    /// Entity responsible for the action (e.g., 'system', 'agent-ID', 'user-ID').
    required String actor,
  }) = _AuditLogEntry;

  /// deserialization from JSON format.
  factory AuditLogEntry.fromJson(Map<String, dynamic> json) =>
      _$AuditLogEntryFromJson(json);
}

/// Represents a single Debit or Credit line within a Journal Entry.
@freezed
class JournalEntryLine with _$JournalEntryLine {
  /// Creates a journal entry line.
  const factory JournalEntryLine({
    /// Reference to the target [Account] ID.
    required String accountId,

    /// Denormalized account name for high-performance listing and audit.
    required String accountName,

    /// Positive increase for Debit-nature accounts.
    required Decimal debit,

    /// Positive increase for Credit-nature accounts.
    required Decimal credit,

    /// Line-specific memo or explanation.
    String? description,

    /// Direct link to source documentation (e.g., Invoice #, Receipt ID).
    /// (Standard Reference: CP-009: Traceability)
    String? sourceDocumentRef,

    /// Cost center identifier for management accounting attribution.
    String? costCenterId,

    /// ISO currency code for multi-currency transactions.
    String? originalCurrency,

    /// Spot exchange rate at the time of recording.
    Decimal? exchangeRate,

    /// Original amount in the source currency before conversion.
    Decimal? originalAmount,
  }) = _JournalEntryLine;

  /// deserialization from JSON format.
  factory JournalEntryLine.fromJson(Map<String, dynamic> json) =>
      _$JournalEntryLineFromJson(json);
}

/// The core atomic financial record representing a balanced accounting\n/// transaction.
/// (Standard References: FR-ACC-001, FR-ACC-008)
@freezed
class JournalEntry with _$JournalEntry {
  /// Creates a central journal entry.
  const factory JournalEntry({
    /// Unique internal UUID for the entry.
    required String id,

    /// Human-readable unique serial number (e.g., "JE-2024-001").
    required String referenceNumber,

    /// Primary chronological date for the entry report.
    required DateTime date,

    /// Multi-dimensional temporal audit metadata.
    required TemporalJustification temporal,

    /// Explicit regulatory compliance references and justifications.
    required StandardsJustification standards,

    /// Concise summary of the transaction purpose.
    required String description,

    /// Active state of the entry (Draft/Posted/Voided).
    required JournalEntryStatus status,

    /// Immutable list of balanced [JournalEntryLine]s.
    required List<JournalEntryLine> lines,

    /// Categorization of the spawning source (e.g., "sales_invoice", "pos").
    required String sourceDocument,

    /// Unique identifier within the source module.
    required String sourceId,

    /// User ID of the originator.
    required String createdBy,

    /// Creation timestamp in UTC.
    required DateTime createdAt,

    /// Last modification timestamp in UTC.
    required DateTime updatedAt,

    /// Integrity verification fingerprint (Merkle-style link).
    /// (Standard Reference: CP-003: Immutability)
    String? hash,

    /// Fingerprint of the chronologically preceding entry in the ledger.
    String? previousHash,

    /// Final posting timestamp marking the end of the draft lifecycle.
    DateTime? postedAt,

    /// Tenant isolation identifier.
    String? userId,

    /// Warehouse scope identifier.
    String? warehouseId,

    /// Internal audit path for system and security tracking.
    @Default([]) List<AuditLogEntry> auditLogs,

    /// Local-to-Remote synchronization state.
    @Default(SyncStatus.synced) SyncStatus syncStatus,

    /// Most recent synchronization timestamp from the server.
    DateTime? serverUpdatedAt,

    /// Soft-deletion flag.
    @Default(false) bool isDeleted,
  }) = _JournalEntry;

  /// deserialization from JSON format.
  factory JournalEntry.fromJson(Map<String, dynamic> json) =>
      _$JournalEntryFromJson(json);

  const JournalEntry._();

  /// Aggregated total of all Debit lines.
  Decimal get totalDebit =>
      lines.fold(Decimal.zero, (sum, line) => sum + line.debit);

  /// Aggregated total of all Credit lines.
  Decimal get totalCredit =>
      lines.fold(Decimal.zero, (sum, line) => sum + line.credit);

  /// Mathematical verification of the accounting equation (Debits = Credits).
  /// (Standard Reference: FR-ACC-002)
  bool get isBalanced => totalDebit == totalCredit;
}
