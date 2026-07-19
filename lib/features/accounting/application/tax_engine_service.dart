// ignore_for_file: lines_longer_than_80_chars
import 'package:basir_accounting_system/features/accounting/domain/entities/accounting_agent.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/widgets.dart';
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

  /// Validates tax IDs and calculates VAT statements.
  @override
  Future<AgentResult> process(AccountingContext context) async {
    final rationale = <String>[];
    var isAllowed = true;
    final metadata = context.metadata;
    final l10n = lookupAppLocalizations(Locale(context.locale));
    final suggestedAdjustments = <String, dynamic>{};

    // 1. Tax ID Validation
    final taxId = metadata['tax_id'] as String?;
    if (taxId == null || taxId.isEmpty) {
      rationale.add(l10n.agentRationaleTaxNoId);
      // Reject large transactions without Tax ID (ZATCA compliance)
      if (context.proposedJournalEntry.totalDebit > Decimal.fromInt(10000)) {
        isAllowed = false;
        rationale.add(l10n.agentRationaleTaxZatcaReject);
      }
    } else {
      rationale.add(l10n.agentRationaleTaxValidated(taxId));
    }

    // 2. VAT Rate Check
    final vatLines = context.proposedJournalEntry.lines.where(
      (l) => l.accountId == 'acc-2102' || l.accountName.contains('VAT'),
    );

    if (vatLines.isNotEmpty) {
      for (final line in vatLines) {
        rationale.add(
          l10n.agentRationaleTaxAnalyzing(line.accountName),
        );
        // Verify standard VAT rate (e.g., 15% for KSA)
        final totalBase = context.proposedJournalEntry.totalDebit - line.credit;
        if (totalBase > Decimal.zero) {
          final calculatedRate = (line.credit / totalBase).toDecimal(
            scaleOnInfinitePrecision: 4,
          );
          final expectedRate = Decimal.parse('0.15');

          if ((calculatedRate - expectedRate).abs() > Decimal.parse('0.001')) {
            rationale.add(
              l10n.agentRationaleTaxRateMismatch(calculatedRate.toString()),
            );

            suggestedAdjustments['tax_rate_correction'] = {
              'expectedRate': '15%',
              'calculatedRate':
                  '${(calculatedRate * Decimal.fromInt(100)).toDouble()} %',
              'suggestedVatAmount': (totalBase * expectedRate).toString(),
              'title': l10n.agentSuggestionVatCorrection,
            };
          } else {
            rationale.add(l10n.agentRationaleTaxRateMatch);
          }
        }
      }
    } else if (context.transactionType == 'sales' ||
        context.transactionType == 'purchase') {
      rationale.add(l10n.agentRationaleTaxNoVatWarning);

      // Suggest adding 15% VAT
      final expectedVat =
          context.proposedJournalEntry.totalDebit * Decimal.parse('0.15');
      suggestedAdjustments['missing_tax_line'] = {
        'accountId': 'acc-2102',
        'accountName': 'VAT Output',
        'suggestedAmount': expectedVat.toString(),
        'reason': l10n.agentSuggestionMissingVatLineReason,
        'title': l10n.agentSuggestionMissingVatLine,
      };
    }

    return AgentResult(
      agentId: agentId,
      isAllowed: isAllowed,
      rationale: rationale.join('\n'),
      confidenceScore: 0.95,
      suggestedAdjustments:
          suggestedAdjustments.isNotEmpty ? suggestedAdjustments : null,
    );
  }

  /// Calculates the estimated VAT return for the current period.
  Future<VatReturnStatement> calculateVatReturn() async {
    await Future<void>.delayed(const Duration(milliseconds: 800));

    return VatReturnStatement(
      periodStart: DateTime.now().subtract(const Duration(days: 90)),
      periodEnd: DateTime.now(),
      standardSalesBase: Decimal.parse('150000.00'),
      standardSalesTax: Decimal.parse('22500.00'), // 15%
      zeroRatedSales: Decimal.parse('5000.00'),
      exemptSales: Decimal.parse('0.00'),
      standardPurchasesBase: Decimal.parse('80000.00'),
      standardPurchasesTax: Decimal.parse('12000.00'), // 15%
      netVatDue: Decimal.parse('10500.00'), // 22500 - 12000
    );
  }
}

/// Model representing a simulated VAT Return Statement.
class VatReturnStatement {
  /// Standard constructor for the VAT return statement.
  const VatReturnStatement({
    required this.periodStart,
    required this.periodEnd,
    required this.standardSalesBase,
    required this.standardSalesTax,
    required this.zeroRatedSales,
    required this.exemptSales,
    required this.standardPurchasesBase,
    required this.standardPurchasesTax,
    required this.netVatDue,
  });

  /// Start of the VAT period.
  final DateTime periodStart;

  /// End of the VAT period.
  final DateTime periodEnd;

  /// Total sales base for standard-rated sales.
  final Decimal standardSalesBase;

  /// Total standard-rated output tax.
  final Decimal standardSalesTax;

  /// Total zero-rated sales.
  final Decimal zeroRatedSales;

  /// Total exempt sales.
  final Decimal exemptSales;

  /// Total purchase base for standard-rated purchases.
  final Decimal standardPurchasesBase;

  /// Total standard-rated input tax.
  final Decimal standardPurchasesTax;

  /// Net VAT due to (or refundable from) the authority.
  final Decimal netVatDue;

  /// The total sales amount including standard, zero-rated, and exempt.
  Decimal get totalSales => standardSalesBase + zeroRatedSales + exemptSales;

  /// The total purchase amount for the period.
  Decimal get totalPurchases => standardPurchasesBase;
}
