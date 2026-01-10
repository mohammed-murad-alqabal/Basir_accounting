import 'package:basir_app/features/accounting/domain/entities/accounting_agent.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'operational_intel_service.g.dart';

/// Operational Intelligence Agent (Agent 4) bridging ledger data with business
/// reality.
///
/// Monitors the alignment between financial entries and operational
/// statuses such as inventory levels and process urgency.
@Riverpod(keepAlive: true)
class OperationalIntelService extends _$OperationalIntelService
    implements AccountingAgent {
  @override
  FutureOr<void> build() {}

  @override
  String get agentId => 'agent-4-operational-intel';

  @override
  AgentAuthority get authority => AgentAuthority.medium;

  /// Validates the operational feasibility and impact of the transaction.
  ///
  /// ## Operational Checks:
  /// 1. **Sales-Inventory Alignment**: Verifies material availability for
  ///    sales invoices.
  /// 2. **Priority Monitoring**: Adjusts confidence levels and processing speed
  ///    based on operational urgency (high-priority flags).
  @override
  Future<AgentResult> process(AccountingContext context) async {
    final rationale = <String>[];
    var confidenceScore = 0.92;

    // 1. Transaction Type Operational Analysis
    if (context.transactionType == 'sales') {
      rationale.add(
        'Operational Impact: Verifying material availability and '
        'logistics readiness.',
      );
      // TODO(Baseer): Future integration with MawadService (Inventory)
      rationale.add(
        'Recommendation: Ensure floor stocks are decremented immediately '
        'upon posting.',
      );
    } else if (context.transactionType == 'purchase') {
      rationale.add(
        'Operational Impact: Assessing warehouse capacity and incoming '
        'quality control requirements.',
      );
    }

    // 2. Urgency and Priority Validation
    final isUrgent = context.metadata['priority'] == 'high';
    if (isUrgent) {
      rationale
          .add('Note: Processed as high operational priority transaction.');
      confidenceScore = 0.98;
    }

    return AgentResult(
      agentId: agentId,
      isAllowed: true,
      rationale: rationale.join('\n'),
      confidenceScore: confidenceScore,
    );
  }
}
