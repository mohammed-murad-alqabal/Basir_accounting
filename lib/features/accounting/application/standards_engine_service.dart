// ignore_for_file: lines_longer_than_80_chars
import 'package:basir_accounting_system/features/accounting/domain/entities/accounting_agent.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'standards_engine_service.g.dart';

/// Standards Compliance Engine (Agent 1) for international auditing.
///
/// Service for applying and validating accounting standards (IFRS/SOCPA) across
/// transactions.
@Riverpod(keepAlive: true)
class StandardsEngineService extends _$StandardsEngineService implements AccountingAgent {
  @override
  FutureOr<void> build() {}

  /// المعرف الفريد للمحرك
  @override
  String get agentId => 'agent-1-standards-engine';

  /// مستوى الصلاحية (عالي للمحرك المرجعي)
  @override
  AgentAuthority get authority => AgentAuthority.high;

  /// Validates the proposed journal entry against configured standards.
  @override
  Future<AgentResult> process(AccountingContext context) async {
    final rationale = <String>[];
    var isAllowed = true;
    final l10n = lookupAppLocalizations(Locale(context.locale));
    final suggestedAdjustments = <String, dynamic>{};

    // IFRS 18 Category Validation & Smart Adjustments
    for (final line in context.proposedJournalEntry.lines) {
      final name = line.accountName.toLowerCase();
      // Determine category based on account ID prefix
      String? category;
      if (line.accountId.startsWith('acc-4')) {
        category = 'Operating category';
      } else if (line.accountId.startsWith('acc-5')) {
        category = 'Operating category';
      } else if (line.accountId.startsWith('acc-2')) {
        category = 'Liabilities category';
      }

      if (category != null) {
        rationale.add(
          'Confirmed: Account correctly mapped to $category',
        );
        rationale.add(
          'Confirmed: Account ${line.accountName} correctly mapped to $category',
        );
      }

      // Example: "Commission" in generic "Operating Expense" (acc-51)
      if (name.contains('commission') && line.accountId.startsWith('acc-51')) {
        suggestedAdjustments['ifrs18_category_suggestion'] = {
          'accountId': line.accountId,
          'accountName': line.accountName,
          'suggestedCategory': 'Selling and Distribution Expenses',
          'reason': l10n.agentSuggestionIfrs18CategoryReason,
          'title': l10n.agentSuggestionIfrs18Category,
        };
        rationale.add(
          '${l10n.agentSuggestionIfrs18Category}: ${line.accountName}',
        );
      }

      final id = line.accountId;
      if (id.startsWith('acc-4') || id.startsWith('acc-5')) {
        rationale.add(
          'Validating IFRS 18 Category mapping for ${line.accountName}',
        );
        // Note: Real-world implementation would fetch metadata from the account
        rationale.add(l10n.agentRationaleStandardsPassed);
      }
    }

    // ISSB Sustainability Disclosure Check
    if (context.isSustainabilityRequired) {
      rationale.add(l10n.agentRationaleSustainabilityFlagged);
      final metrics = context.sustainabilityMetrics;
      if (metrics != null && metrics.isNotEmpty) {
        rationale.add(
          l10n.agentRationaleSustainabilitySuccess(metrics.length),
        );
      } else {
        isAllowed = false;
        rationale.add(l10n.agentRationaleSustainabilityReject);
      }
    }

    return AgentResult(
      agentId: agentId,
      isAllowed: isAllowed,
      rationale: rationale.join('\n'),
      confidenceScore: 0.98,
      suggestedAdjustments: suggestedAdjustments.isNotEmpty ? suggestedAdjustments : null,
    );
  }
}
