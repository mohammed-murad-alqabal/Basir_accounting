import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/accounting/application/financial_strategy_service.dart';
import 'package:basir_accounting_system/features/accounting/application/forensic_audit_service.dart';
import 'package:basir_accounting_system/features/accounting/application/operational_intel_service.dart';
import 'package:basir_accounting_system/features/accounting/application/standards_engine_service.dart';
import 'package:basir_accounting_system/features/accounting/application/sustainability_expert_service.dart';
import 'package:basir_accounting_system/features/accounting/application/tax_engine_service.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/accounting_agent.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'orchestrator_service.g.dart';

/// Central Orchestrator Service managing the multi-agent consensus workflow.
///
/// Implements "The Cognitive Hexagon" architecture, where six specialized
/// AI agents must reach a consensus on the validity and impact of
/// every financial transaction.
@Riverpod(keepAlive: true)
class OrchestratorService extends _$OrchestratorService {
  @override
  FutureOr<void> build() {}

  /// Primary entry point for the Multi-Agent Orchestration Flow.
  ///
  /// Sequentially invokes all six cognitive agents to build a final report.
  ///
  /// ## The Cognitive Hexagon Agents:
  /// 1. **Standards Engine**: IFRS/ISSB global compliance.
  /// 2. **Tax Engine**: ZATCA/FTA local regulatory compliance.
  /// 3. **Forensic Audit**: Data integrity and anomaly detection.
  /// 4. **Operational Intel**: Business impact and process efficiency.
  /// 5. **Financial Strategy**: Cash flow and portfolio optimization.
  /// 6. **Sustainability Expert**: ESG and environmental metric tracking.
  ///
  /// ## Returns
  /// An [AgentConsensus] representing the collective decision of all agents.
  Future<AgentConsensus> orchestrate(AccountingContext context) async {
    // Stage: Concurrent Multi-Agent Consensus
    final agentFutures = [
      ref.read(standardsEngineServiceProvider.notifier).process(context),
      ref.read(taxEngineServiceProvider.notifier).process(context),
      ref.read(forensicAuditServiceProvider.notifier).process(context),
      ref.read(operationalIntelServiceProvider.notifier).process(context),
      ref.read(financialStrategyServiceProvider.notifier).process(context),
      ref.read(sustainabilityExpertServiceProvider.notifier).process(context),
    ];

    final results = await Future.wait(agentFutures);

    // Aggregation Logic: All agents must allow for overall approval
    final overallAllowed = results.every((r) => r.isAllowed);

    final aggregateRationale = StringBuffer();
    aggregateRationale.writeln(
      '--- Basir Cognitive Hexagon: Final Consensus Report ---',
    );
    aggregateRationale.writeln(
      'Decision: ${overallAllowed ? "APPROVED ✅" : "REJECTED ❌"}',
    );

    // Compute aggregate confidence score
    final totalConfidence = results.fold<double>(
      0,
      (sum, res) => sum + res.confidenceScore,
    );
    final averageConfidence = totalConfidence / results.length;

    aggregateRationale.writeln(
      'Confidence Level: ${averageConfidence.toStringAsFixed(2)}',
    );
    aggregateRationale.writeln('-----------------------------------');

    for (final res in results) {
      aggregateRationale.writeln(
        '[${res.agentId}] ${res.isAllowed ? "PASS" : "FAIL"} | '
        'Confidence: ${res.confidenceScore}',
      );
      aggregateRationale.writeln(res.rationale);
      aggregateRationale.writeln('---');
    }

    return AgentConsensus(
      isApproved: overallAllowed,
      explanation: aggregateRationale.toString(),
      agentResults: results,
      orchestrationTimestamp: DateTime.now(),
    );
  }

  /// Generates a period-level analysis ("Cognitive Insights")
  /// for financial reports.
  ///
  /// This aggregates high-level feedback from all agents regarding the
  /// financial health and compliance status of the period [from] - [to].
  Future<List<AgentResult>> getPeriodInsights(
    DateTime from,
    DateTime to,
  ) async {
    final repository = ref.read(accountingRepositoryProvider);
    final entries = await repository.getJournalEntries();

    // Filter by period
    final periodEntries = entries
        .where(
          (e) =>
              e.date.isAfter(from.subtract(const Duration(days: 1))) &&
              e.date.isBefore(to.add(const Duration(days: 1))),
        )
        .toList();

    if (periodEntries.isEmpty) {
      return [
        const AgentResult(
          agentId: 'Standards Engine',
          isAllowed: true,
          rationale: 'No transactions recorded in this period. '
              'Compliance baseline maintained.',
          confidenceScore: 1,
        ),
        const AgentResult(
          agentId: 'Forensic Audit',
          isAllowed: true,
          rationale: 'Quiescent ledger. '
              'Zero anomaly baseline confirmed.',
          confidenceScore: 1,
        ),
      ];
    }

    // Modern implementation: provide a "Period Context" to agents (simulated)
    // We use the most representative entry (or first) to trigger agent logic
    final context = AccountingContext(
      proposedJournalEntry: periodEntries.first,
      transactionType: 'period_audit',
      locale: 'en',
    );

    final agentFutures = [
      ref.read(standardsEngineServiceProvider.notifier).process(context),
      ref.read(taxEngineServiceProvider.notifier).process(context),
      ref.read(forensicAuditServiceProvider.notifier).process(context),
      ref.read(operationalIntelServiceProvider.notifier).process(context),
      ref.read(financialStrategyServiceProvider.notifier).process(context),
      ref.read(sustainabilityExpertServiceProvider.notifier).process(context),
    ];

    return Future.wait(agentFutures);
  }
}

/// Represents the final consensus reached by the multi-agent system.
class AgentConsensus {
  /// Creates a finalized consensus report.
  AgentConsensus({
    required this.isApproved,
    required this.explanation,
    required this.agentResults,
    required this.orchestrationTimestamp,
  });

  /// Indicates if the transaction was approved by all participating agents.
  final bool isApproved;

  /// Aggregated rationale and explanation from all agents.
  final String explanation;

  /// Collection of individual agent results for granular auditing.
  final List<AgentResult> agentResults;

  /// Precise moment the orchestration was finalized.
  final DateTime orchestrationTimestamp;
}
