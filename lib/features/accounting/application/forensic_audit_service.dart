import 'package:basir_app/core/providers.dart';
import 'package:basir_app/features/accounting/domain/entities/account.dart';
import 'package:basir_app/features/accounting/domain/entities/accounting_agent.dart';
import 'package:basir_app/features/accounting/domain/entities/journal_entry.dart';
import 'package:basir_app/features/accounting/domain/repositories/accounting_repository.dart';
import 'package:decimal/decimal.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'forensic_audit_service.g.dart';

/// Represents the result of a forensic audit examination.
class AuditResult {
  const AuditResult({
    required this.isSuccess,
    required this.message,
    this.findings = const [],
  });

  /// Indicates if the audit check passed successfully.
  final bool isSuccess;

  /// Human-readable summary of the audit outcome.
  final String message;

  /// Detailed findings or discrepancies identified during the audit.
  final List<String> findings;
}

/// Forensic Audit Expert Service (Agent 3) for data integrity and fraud detection.
///
/// This agent monitors ledger activities for unauthorized changes,
/// unusual transaction patterns, and structural imbalances. It serves
/// as a critical layer of defense for financial accuracy.
@riverpod
class ForensicAuditService extends _$ForensicAuditService
    implements AccountingAgent {
  AccountingRepository get _repository =>
      ref.read(accountingRepositoryProvider);

  @override
  void build() {}

  @override
  String get agentId => 'agent-3-forensic-audit';

  @override
  AgentAuthority get authority => AgentAuthority.medium;

  /// Real-time processing of proposed transactions for forensic anomalies.
  ///
  /// ## Checks:
  /// 1. **Balance Verification**: Recomputes Debit vs Credit totals for exact parity.
  /// 2. **Threshold Monitoring**: Flags unusually large transactions exceeding SAR 1M.
  /// 3. **Duplicate Detection**: Prevents reuse of existing Reference Numbers.
  @override
  Future<AgentResult> process(AccountingContext context) async {
    final rationale = <String>[];
    var isAllowed = true;

    // 1. Verify Entry Balance
    if (!context.proposedJournalEntry.isBalanced) {
      isAllowed = false;
      rationale.add('REJECTION: Proposed journal entry is not balanced.');
    } else {
      rationale.add('Check PASSED: Journal entry is balanced.');
    }

    // 2. Anomaly Detection (Threshold: SAR 1,000,000)
    final threshold = Decimal.fromInt(1000000);
    if (context.proposedJournalEntry.totalDebit > threshold) {
      rationale.add(
        'WARNING: Unusually high transaction amount detected '
        '(${context.proposedJournalEntry.totalDebit}). Administrative review recommended.',
      );
    }

    // 3. Duplicate Reference Check
    final entries = await _repository.getJournalEntries();
    final isDuplicate = entries.any(
      (e) => e.referenceNumber == context.proposedJournalEntry.referenceNumber,
    );
    if (isDuplicate) {
      isAllowed = false;
      rationale.add(
        'REJECTION: Duplicate reference number '
        '(${context.proposedJournalEntry.referenceNumber}) detected in history.',
      );
    }

    return AgentResult(
      agentId: agentId,
      isAllowed: isAllowed,
      rationale: rationale.join('\n'),
      confidenceScore: 1,
    );
  }

  /// Verifies balance parity across the entire historical journal.
  /// (Implementation of FR-ACC-002)
  Future<AuditResult> verifyAllEntriesBalanced() async {
    final entries = await _repository.getJournalEntries();
    final unbalanced = <String>[];

    for (final entry in entries) {
      if (!entry.isBalanced) {
        unbalanced.add('Entry #${entry.referenceNumber} is unbalanced.');
      }
    }

    if (unbalanced.isEmpty) {
      return const AuditResult(
        isSuccess: true,
        message: 'All ledger entries verified as balanced.',
      );
    }

    return AuditResult(
      isSuccess: false,
      message: 'Unbalanced entries identified!',
      findings: unbalanced,
    );
  }

  /// Performs deep integrity check between account balances and transaction totals.
  ///
  /// Recomputes theoretical balances for every account by aggregating all
  /// posted journal lines and compares them against current stored values.
  Future<AuditResult> verifyBalancesIntegrity() async {
    final accounts = await _repository.getAccounts();
    final entries = await _repository.getJournalEntries();
    final discrepancies = <String>[];

    for (final account in accounts) {
      if (account.isParent) continue;

      var calculatedBalance = Decimal.zero;
      for (final entry in entries) {
        if (entry.status != JournalEntryStatus.posted) continue;

        for (final line in entry.lines) {
          if (line.accountId == account.id) {
            calculatedBalance += line.debit - line.credit;
          }
        }
      }

      final absoluteCalculated = account.nature == AccountNature.debit
          ? calculatedBalance
          : -calculatedBalance;

      final storedBalance = await _repository.getAccountBalance(account.id);

      if (absoluteCalculated != storedBalance) {
        discrepancies.add(
          'Account ${account.nameEn}: Stored balance ($storedBalance) mismatch '
          'against computed total ($absoluteCalculated)',
        );
      }
    }

    if (discrepancies.isEmpty) {
      return const AuditResult(
        isSuccess: true,
        message:
            'Data integrity verified: Account balances match transaction history.',
      );
    }

    return AuditResult(
      isSuccess: false,
      message: 'Integrity discrepancies identified!',
      findings: discrepancies,
    );
  }

  /// Scans for suspicious financial patterns or statistical anomalies.
  Future<AuditResult> detectAnomalies() async {
    final entries = await _repository.getJournalEntries();
    final findings = <String>[];

    // Check for high-value transactions
    final threshold = Decimal.fromInt(1000000);

    for (final entry in entries) {
      if (entry.totalDebit > threshold) {
        findings.add(
          'High-value Transaction Alert: Entry #${entry.referenceNumber} '
          'amounting to ${entry.totalDebit}.',
        );
      }
    }

    return AuditResult(
      isSuccess: findings.isEmpty,
      message: findings.isEmpty
          ? 'No suspicious patterns identified.'
          : 'Forensic alerts require administrative review.',
      findings: findings,
    );
  }
}
