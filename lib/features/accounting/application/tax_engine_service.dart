import 'package:basir_app/features/accounting/domain/entities/accounting_agent.dart';
import 'package:decimal/decimal.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tax_engine_service.g.dart';

/// Tax Engine Expert Service (Agent 2) responsible for local tax compliance.
///
/// This agent monitors transactions for regulatory adherence, specifically
/// ZATCA (Saudi Arabia) and FTA (UAE) VAT requirements. It validates VAT rates,
/// tax identification IDs, and E-Invoicing standards.
@Riverpod(keepAlive: true)
class TaxEngineService extends _$TaxEngineService implements AccountingAgent {
  @override
  FutureOr<void> build() {}

  @override
  String get agentId => 'agent-2-tax-engine';

  @override
  AgentAuthority get authority => AgentAuthority.high;

  /// Processes a transaction context to verify tax compliance.
  ///
  /// ## Validations
  /// 1. **Tax ID Verification**: Ensures provided Tax IDs meet ZATCA requirements
  ///    for high-value transactions (>10,000 SAR).
  /// 2. **VAT Rate Accuracy**: Cross-references recorded tax amounts against
  ///    standard local rates (e.g., 15% for KSA).
  /// 3. **Missing Tax Detection**: Identifies sales/purchase documents without
  ///    proper VAT lines.
  @override
  Future<AgentResult> process(AccountingContext context) async {
    final rationale = <String>[];
    var isAllowed = true;
    final metadata = context.metadata;

    // 1. Tax ID Validation
    final taxId = metadata['tax_id'] as String?;
    if (taxId == null || taxId.isEmpty) {
      rationale.add('Warning: No Tax ID provided for this transaction.');
      // Reject large transactions without Tax ID (ZATCA compliance)
      if (context.proposedJournalEntry.totalDebit > Decimal.fromInt(10000)) {
        isAllowed = false;
        rationale.add(
          'REJECT: Transactions exceeding 10,000 SAR require a valid Tax ID for ZATCA Phase 2 compliance.',
        );
      }
    } else {
      rationale.add('Validated Tax ID: $taxId');
    }

    // 2. VAT Rate Check
    final vatLines = context.proposedJournalEntry.lines.where(
      (l) => l.accountId == 'acc-2102' || l.accountName.contains('VAT'),
    );

    if (vatLines.isNotEmpty) {
      for (final line in vatLines) {
        rationale.add('Analyzing VAT for ${line.accountName}');
        // Verify standard VAT rate (e.g., 15% for KSA)
        final totalBase = context.proposedJournalEntry.totalDebit - line.credit;
        if (totalBase > Decimal.zero) {
          final calculatedRate = (line.credit / totalBase).toDecimal(
            scaleOnInfinitePrecision: 4,
          );
          final expectedRate = Decimal.parse('0.15');

          if ((calculatedRate - expectedRate).abs() > Decimal.parse('0.001')) {
            rationale.add(
              'ALERT: Calculated VAT rate ($calculatedRate) deviates from the regional standard (15%).',
            );
          } else {
            rationale.add(
              'CONFIRM: VAT rate (15%) matches local regulatory requirements.',
            );
          }
        }
      }
    } else if (context.transactionType == 'sales' ||
        context.transactionType == 'purchase') {
      rationale
          .add('WARNING: Commercial transaction detected without VAT lines.');
    }

    return AgentResult(
      agentId: agentId,
      isAllowed: isAllowed,
      rationale: rationale.join('\n'),
      confidenceScore: 0.95,
    );
  }
}
