import 'package:basir_app/features/accounting/domain/entities/accounting_agent.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sustainability_expert_service.g.dart';

/// Sustainability Expert Agent (Agent 6) for ESG and ISSB compliance.
///
/// Responsible for ensuring that transactions requiring environmental
/// or social disclosures comply with International Sustainability Standards
/// Board (ISSB) S1 and S2 mandates.
@Riverpod(keepAlive: true)
class SustainabilityExpertService extends _$SustainabilityExpertService implements AccountingAgent {
  @override
  FutureOr<void> build() {}

  @override
  String get agentId => 'agent-6-sustainability-expert';

  @override
  AgentAuthority get authority => AgentAuthority.medium;

  /// Validates the presence of sustainability metrics for mandatory disclosures.
  ///
  /// ## Compliance Checks:
  /// - **ISSB S2 Readiness**: For high-impact industries, verifies that carbon
  ///   emission or resource usage metrics are attached to the financial record.
  @override
  Future<AgentResult> process(AccountingContext context) async {
    final rationale = <String>[];
    var isAllowed = true;

    if (context.isSustainabilityRequired) {
      rationale.add(
        'ISSB Analysis: This transaction is flagged for mandatory environmental/social disclosure.',
      );

      if (context.sustainabilityMetrics == null || context.sustainabilityMetrics!.isEmpty) {
        isAllowed = false;
        rationale.add(
          'CRITICAL REJECTION: ISSB S2 standards require carbon footprint metrics '
          'for this industry-specific transaction.',
        );
      } else {
        rationale.add(
          'SUCCESS: Integrated ${context.sustainabilityMetrics!.length} compliant sustainability metrics.',
        );
      }
    } else {
      rationale.add(
        'Sustainability Assessment: No specific ISSB disclosures required for this transaction tier.',
      );
    }

    return AgentResult(
      agentId: agentId,
      isAllowed: isAllowed,
      rationale: rationale.join('\n'),
      confidenceScore: 0.96,
    );
  }
}
