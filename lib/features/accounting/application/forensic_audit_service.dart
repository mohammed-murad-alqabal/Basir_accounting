import 'dart:ui';

import 'package:basir_accounting_system/core/providers.dart';
// ignore_for_file: lines_longer_than_80_chars
import 'package:basir_accounting_system/features/accounting/domain/entities/accounting_agent.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/journal_entry.dart'
    as domain_je;
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:basir_accounting_system/src/rust/api/auditor.dart'
    as rust_auditor;
import 'package:basir_accounting_system/src/rust/api/ledger.dart'
    as rust_ledger;
import 'package:decimal/decimal.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'forensic_audit_service.g.dart';

/// Represents the result of a forensic audit examination.
class AuditResult {
  /// Creates an audit result with a success flag and message.
  const AuditResult({
    required this.isSuccess,
    required this.message,
    this.findings = const [],
  });

  /// Indicates if the audit check passed successfully.
  final bool isSuccess;

  /// Human-readable summary of the audit outcome.
  final String message;

  /// Detailed findings or anomalies discovered during the audit.
  final List<String> findings;
}

/// [ForensicAuditService]
///
/// Specialized service for deep transactional analysis and corruption detection.
/// Leverages the Rust-based `self_healing` auditor for performance-critical tasks.
@Riverpod(keepAlive: true)
class ForensicAuditService extends _$ForensicAuditService
    implements AccountingAgent {
  @override
  void build() {}

  @override
  String get agentId => 'agent-3-forensic';

  @override
  AgentAuthority get authority => AgentAuthority.high;

  @override
  Future<AgentResult> process(AccountingContext context) async {
    final entry = context.proposedJournalEntry;

    // 1. Structural balance check (CP-001)
    if (!entry.isBalanced) {
      return AgentResult(
        agentId: agentId,
        isAllowed: false,
        rationale: 'agentRationaleForensicUnbalanced',
        confidenceScore: 1,
      );
    }

    // 2. High-value transaction detection (CP-009)
    // Threshold: 100,000 SAR for high forensic scrutiny
    if (entry.totalDebit > Decimal.fromInt(100000)) {
      return AgentResult(
        agentId: agentId,
        isAllowed: true,
        rationale: 'agentRationaleForensicHighValue',
        confidenceScore: 0.85,
      );
    }

    final suggestedAdjustments = <String, dynamic>{};

    // 3. Sharia Compliance Guard (CP-012)
    // Flags transactions with explicit prohibited terms (Riba/Usury)
    final prohibitedTerms = ['interest', 'riba', 'usury', 'fayda'];
    final descriptionLower = entry.description.toLowerCase();
    if (prohibitedTerms.any(descriptionLower.contains)) {
      return AgentResult(
        agentId: agentId,
        isAllowed: false,
        rationale: 'agentRationaleForensicShariaViolation',
        confidenceScore: 0.99,
      );
    }

    // 4. ZATCA identity check for posted invoice entries (CP-014).
    if (entry.sourceDocument == 'invoice' &&
        entry.status == domain_je.JournalEntryStatus.posted) {
      final invoice = await ref
          .read(invoiceRepositoryProvider)
          .getInvoiceById(entry.sourceId);
      if (invoice == null ||
          invoice.zatcaUuid == null ||
          invoice.zatcaUuid!.isEmpty ||
          invoice.zatcaHash == null ||
          invoice.zatcaHash!.isEmpty) {
        return AgentResult(
          agentId: agentId,
          isAllowed: false,
          rationale: 'Missing ZATCA Phase 2 cryptographic identity.',
          confidenceScore: 0.99,
        );
      }
    }

    // 5. Sequence integrity check (CP-011).
    final existingEntries =
        await ref.read(accountingRepositoryProvider).getJournalEntries();
    final sequenceGap = _sequenceGapRationale(entry, existingEntries);
    if (sequenceGap != null) {
      return AgentResult(
        agentId: agentId,
        isAllowed: true,
        rationale: sequenceGap,
        confidenceScore: 0.9,
      );
    }

    // 6. Operational-hours anomaly detection (CP-015).
    if (entry.date.hour < 6 || entry.date.hour >= 22) {
      final hour = entry.date.hour.toString().padLeft(2, '0');
      return AgentResult(
        agentId: agentId,
        isAllowed: true,
        rationale: 'Entry recorded during non-standard hours: $hour:00.',
        confidenceScore: 0.85,
      );
    }

    return AgentResult(
      agentId: agentId,
      isAllowed: true,
      rationale: 'agentRationaleForensicBalanced',
      confidenceScore: 0.95,
      suggestedAdjustments:
          suggestedAdjustments.isNotEmpty ? suggestedAdjustments : null,
    );
  }

  String? _sequenceGapRationale(
    domain_je.JournalEntry proposedEntry,
    List<domain_je.JournalEntry> existingEntries,
  ) {
    final proposedReference = _referenceParts(proposedEntry.referenceNumber);
    if (proposedReference == null) return null;

    final priorReferences = existingEntries
        .map((entry) => _referenceParts(entry.referenceNumber))
        .whereType<_ReferenceParts>()
        .where(
          (reference) =>
              reference.prefix == proposedReference.prefix &&
              reference.number < proposedReference.number,
        )
        .toList();
    if (priorReferences.isEmpty) return null;

    priorReferences.sort((left, right) => right.number.compareTo(left.number));
    final previous = priorReferences.first;
    final expectedNumber = previous.number + 1;
    if (proposedReference.number == expectedNumber) return null;

    final expectedReference = '${proposedReference.prefix}'
        '${expectedNumber.toString().padLeft(proposedReference.width, '0')}';
    final previousReference = '${previous.prefix}'
        '${previous.number.toString().padLeft(previous.width, '0')}';
    return 'Gap detected: expected $expectedReference between '
        '$previousReference and ${proposedEntry.referenceNumber}.';
  }

  _ReferenceParts? _referenceParts(String referenceNumber) {
    final match = RegExp(r'^(.*?)(\d+)$').firstMatch(referenceNumber);
    if (match == null) return null;
    final numberText = match.group(2)!;
    final number = int.tryParse(numberText);
    if (number == null) return null;
    return _ReferenceParts(
      prefix: match.group(1)!,
      number: number,
      width: numberText.length,
    );
  }

  /// Scans a sequence of journal entries for structural anomalies or tampering.
  ///
  /// Uses the Rust auditor for high-performance sequence verification.
  Future<AuditResult> auditSequence(
    List<domain_je.JournalEntry> entries, {
    String locale = 'en',
  }) async {
    final l10n = lookupAppLocalizations(Locale(locale));
    final entryDtos = entries.map(_toEntryDto).toList();

    try {
      final anomalies = rust_auditor.scanSequence(
        prefix: 'JE',
        entries: entryDtos,
      );

      if (anomalies.isEmpty) {
        return AuditResult(
          isSuccess: true,
          message: l10n.msgForensicSequenceClean,
        );
      }

      final findings = anomalies
          .map(
            (a) => a.when(
              sequenceGap: (expected, found) =>
                  'Sequence gap: Expected $expected but found $found.',
              reconciliationMismatch: (accountId, bookBalance, physicalCount) =>
                  'Reconciliation mismatch in account $accountId: Book $bookBalance vs Count $physicalCount.',
              orphanedDraft: (entryId, date) =>
                  'Orphaned draft entry #$entryId dated $date.',
            ),
          )
          .toList();

      return AuditResult(
        isSuccess: false,
        message: l10n.msgForensicRisksDetected,
        findings: findings,
      );
    } on Exception catch (e) {
      return AuditResult(
        isSuccess: false,
        message: l10n.msgForensicEngineError,
        findings: [e.toString()],
      );
    }
  }

  /// Performs a thorough scrutiny of the entire historical ledger.
  ///
  /// Verifies hash chain integrity (Standard Reference: CP-011).
  Future<AuditResult> scrutinizeHistoricalLedger({String locale = 'en'}) async {
    final l10n = lookupAppLocalizations(Locale(locale));
    final repository = ref.read(accountingRepositoryProvider);
    final entries = await repository.getJournalEntries();

    final issues = <String>[];
    final sortedEntries = entries.toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    for (final entry in sortedEntries) {
      if (!entry.isBalanced) {
        issues.add(l10n.errForensicImbalance(entry.referenceNumber));
      }

      // Verify mathematical identity
      final calculatedSubtotal = entry.lines.fold(
        Decimal.zero,
        (sum, l) => sum + l.debit,
      );
      if (calculatedSubtotal != entry.totalDebit) {
        issues.add(l10n.errForensicDiscrepancy(entry.referenceNumber));
      }
    }

    for (var i = 1; i < sortedEntries.length; i++) {
      final current = sortedEntries[i];
      final previous = sortedEntries[i - 1];
      if (current.previousHash != null &&
          current.previousHash != previous.hash) {
        issues.add(
          l10n.errForensicHashBreach(
            previous.referenceNumber,
            current.referenceNumber,
          ),
        );
      }
    }

    return AuditResult(
      isSuccess: issues.isEmpty,
      message: issues.isEmpty
          ? l10n.msgForensicLedgerClean
          : l10n.msgForensicLedgerAnomalies,
      findings: issues,
    );
  }

  rust_ledger.EntryDto _toEntryDto(domain_je.JournalEntry entry) =>
      rust_ledger.EntryDto(
        entryId: entry.id,
        entryNumber: entry.referenceNumber,
        description: entry.description,
        date: entry.date.toIso8601String(),
        standardRef: entry.standards.standardReference,
        lines: entry.lines.map((l) {
          final isDebit = l.debit > Decimal.zero;
          final amount = (isDebit ? l.debit : l.credit).toString();
          return rust_ledger.LineDto(
            accountId: l.accountId,
            amount: amount,
            isDebit: isDebit,
            description: l.description ?? '',
          );
        }).toList(),
      );
}

class _ReferenceParts {
  const _ReferenceParts({
    required this.prefix,
    required this.number,
    required this.width,
  });

  final String prefix;
  final int number;
  final int width;
}
