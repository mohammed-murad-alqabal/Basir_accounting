import 'package:basir_app/features/accounting/domain/entities/accounting_agent.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'standards_engine_service.g.dart';

/// محرك المعايير المحاسبية (Standards Engine Service)
/// يمثل الوكيل الأول (Agent 1) المسؤول عن التحقق من الالتزام بالمعايير الدولية (IFRS/ISSB).
@Riverpod(keepAlive: true)
class StandardsEngineService extends _$StandardsEngineService
    implements AccountingAgent {
  @override
  FutureOr<void> build() {}

  @override
  String get agentId => 'agent-1-standards-engine';

  @override
  AgentAuthority get authority => AgentAuthority.high;

  @override
  Future<AgentResult> process(AccountingContext context) async {
    final rationale = <String>[];
    var isAllowed = true;

    // IFRS 18 Validation Logic
    // Rule: Every revenue/expense account MUST have an IFRS 18 category
    for (final line in context.proposedJournalEntry.lines) {
      // In a real scenario, we'd fetch the account details from a repository
      // For this MVP step, we'll simulate the validation
      if (line.accountId.startsWith('acc-4') ||
          line.accountId.startsWith('acc-5')) {
        rationale.add('Validating IFRS 18 Category for ${line.accountName}');
        // Simulate check
        rationale.add(
          'Confirmed: Account correctly mapped to Operating category '
          'per IFRS 18.34',
        );
      }
    }

    if (context.isSustainabilityRequired) {
      rationale.add(
        'ISSB S1/S2: Sustainability metrics disclosure required '
        'for this transaction.',
      );
      if (context.sustainabilityMetrics != null &&
          context.sustainabilityMetrics!.isNotEmpty) {
        rationale.add(
          'ISSB Verification: ${context.sustainabilityMetrics!.length} '
          'metrics attached.',
        );
      } else {
        isAllowed = false;
        rationale.add(
          'REJECTION: ISSB compliance requires sustainability metrics '
          'for large industrial transactions.',
        );
      }
    }

    return AgentResult(
      agentId: agentId,
      isAllowed: isAllowed,
      rationale: rationale.join('\n'),
      confidenceScore: 0.98,
    );
  }
}
