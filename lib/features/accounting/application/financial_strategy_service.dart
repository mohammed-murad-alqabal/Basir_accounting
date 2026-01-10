import 'package:basir_app/features/accounting/domain/entities/accounting_agent.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'financial_strategy_service.g.dart';

/// Financial Strategy Agent (Agent 5) for long-term planning and liquidity analysis.
///
/// Responsible for assessing the strategic impact of transactions on
/// cash flow, investment capacity, and overall financial health.
@Riverpod(keepAlive: true)
class FinancialStrategyService extends _$FinancialStrategyService implements AccountingAgent {
  @override
  FutureOr<void> build() {}

  @override
  String get agentId => 'agent-5-financial-strategy';

  @override
  AgentAuthority get authority => AgentAuthority.medium;

  /// Evaluates the strategic impact of the proposed transaction.
  ///
  /// ## Strategy Analysis:
  /// 1. **Liquidity Impact**: Monitors Cash/Bank accounts (acc-11 branch) for
  ///    significant outflows and warns if future obligations might be at risk.
  /// 2. **Profitability Trend**: Analyzes how sales or expense transactions
  ///    influence key metrics like ROA (Return on Assets).
  @override
  Future<AgentResult> process(AccountingContext context) async {
    final rationale = <String>[];

    // 1. Liquidity Impact Analysis
    final cashImpactLines = context.proposedJournalEntry.lines.where(
      (l) => l.accountId.startsWith('acc-11'),
    );

    if (cashImpactLines.isNotEmpty) {
      for (final line in cashImpactLines) {
        if (line.credit > line.debit) {
          rationale.add(
            'Strategy Analysis: This entry represents a cash outflow of ${line.credit}.',
          );
          rationale.add(
            'Recommendation: Review cash flow projections for the coming week '
            'to ensure sufficient liquidity for other obligations.',
          );
        } else {
          rationale.add(
            'Strategy Analysis: Liquidity enhancement of ${line.debit} supports '
            'short-term investment capacity.',
          );
        }
      }
    }

    // 2. Profitability & Business Type Analysis
    if (context.transactionType == 'sales') {
      rationale.add(
        'Strategic Insight: Increased sales volume positively impacts '
        'Return on Assets (ROA) and net margin targets.',
      );
    }

    return AgentResult(
      agentId: agentId,
      isAllowed: true, // Strategy agent usually advises rather than blocks
      rationale: rationale.join('\n'),
      confidenceScore: 0.88,
    );
  }
}
