import 'package:basir_accounting_system/features/accounting/domain/entities/issb_ontology.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/journal_entry.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'accounting_agent.freezed.dart';

/// Hierarchy of decision-making authority for cognitive accounting agents.
enum AgentAuthority {
  /// Highest Tier: Aggregates and reconciles decisions from all other agents.
  orchestrator,

  /// High Tier: Authorized to block transactions based on strict standard
  /// violations.
  high,

  /// Medium Tier: Provides strategic advice and threshold warnings.
  medium,

  /// Low Tier: Monitoring and observation only.
  low,
}

/// The result of an agentic examination of a proposed financial transaction.
@freezed
class AgentResult with _$AgentResult {
  /// Creates an agent processing result.
  const factory AgentResult({
    /// Unique identifier of the processing agent (e.g., "agent-3-forensic").
    required String agentId,

    /// Final accounting verdict: true if compliant, false if rejected.
    required bool isAllowed,

    /// Deep scientific or regulatory rationale explaining the decision.
    required String rationale,

    /// Statistical confidence in the outcome (0.0 to 1.0).
    required double confidenceScore,

    /// Optional AI-driven modifications to improve entry accuracy or
    /// compliance.
    Map<String, dynamic>? suggestedAdjustments,
  }) = _AgentResult;
}

/// Comprehensive context provided to agents during the orchestration flow.
@freezed
class AccountingContext with _$AccountingContext {
  /// Creates an accounting context.
  const factory AccountingContext({
    /// The unposted journal entry currently under review.
    required JournalEntry proposedJournalEntry,

    /// Abstract nature of the transaction (e.g., "sales", "payroll").
    required String transactionType,

    /// The user's current locale for providing localized reasoning.
    @Default('ar') String locale,

    /// If true, the agent must verify climate/social disclosure compliance.
    @Default(false) bool isSustainabilityRequired,

    /// Collection of attached ISSB quantitative measures.
    List<SustainabilityMetric>? sustainabilityMetrics,

    /// Extended operational or regulatory metadata.
    @Default({}) Map<String, dynamic> metadata,
  }) = _AccountingContext;
}

/// Core interface for Basir's "Cognitive Hexagon" AI agents.
///
/// Every specialized agent must implement this interface to participate in
/// the multi-stage consensus for financial data integrity.
abstract class AccountingAgent {
  /// Unique identifier within the agentic registry.
  String get agentId;

  /// Defined rank in the consensus protocol.
  AgentAuthority get authority;

  /// Statutorily and scientifically analyzes the [context] to return a verdict.
  ///
  /// Must provide a detailed [AgentResult.rationale] citing relevant standards.
  Future<AgentResult> process(AccountingContext context);
}
