import 'package:basir_accounting_system/features/accounting/domain/entities/accounting_agent.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';
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

  /// Validates the presence of sustainability metrics for mandatory
  /// disclosures.
  ///
  /// ## Compliance Checks:
  /// - **ISSB S2 Readiness**: For high-impact industries, verifies that carbon
  ///   emission or resource usage metrics are attached to the financial record.
  @override
  Future<AgentResult> process(AccountingContext context) async {
    final rationale = <String>[];
    var isAllowed = true;
    final l10n = lookupAppLocalizations(
      Locale(context.locale),
    );

    // Active Detection Logic: Check if account names trigger
    // sustainability review
    final sustainabilityKeywords = [
      'Fuel',
      'Electricity',
      'Water',
      'Waste',
      'Energy',
      'Gasoline',
      'Diesel',
      'بنزين',
      'ديزل',
      'وقود',
      'كهرباء',
      'مياه',
    ];

    final hasRelevantAccount = context.proposedJournalEntry.lines.any(
      (line) => sustainabilityKeywords.any(
        (kw) => line.accountName.toLowerCase().contains(kw.toLowerCase()),
      ),
    );

    if (context.isSustainabilityRequired || hasRelevantAccount) {
      if (hasRelevantAccount && !context.isSustainabilityRequired) {
        rationale.add(
          'Automated environmental impact detection triggered: '
          'Account names align with ISSB S2 disclosure requirements.',
        );
      }
      rationale.add(l10n.agentRationaleSustainabilityFlagged);

      if (context.sustainabilityMetrics == null || context.sustainabilityMetrics!.isEmpty) {
        isAllowed = false;
        rationale.add(l10n.agentRationaleSustainabilityReject);
      } else {
        rationale.add(
          l10n.agentRationaleSustainabilitySuccess(
            context.sustainabilityMetrics!.length,
          ),
        );
      }
    } else {
      rationale.add(l10n.agentRationaleSustainabilityNotRequired);
    }

    return AgentResult(
      agentId: agentId,
      isAllowed: isAllowed,
      rationale: rationale.join('\n'),
      confidenceScore: 0.96,
    );
  }
}
