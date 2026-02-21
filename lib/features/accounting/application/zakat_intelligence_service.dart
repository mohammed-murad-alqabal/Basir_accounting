// ignore_for_file: lines_longer_than_80_chars
import 'package:basir_accounting_system/features/accounting/application/financial_statement_service.dart';
import 'package:decimal/decimal.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'zakat_intelligence_service.g.dart';

/// Represents the Zakat calculation result.
class ZakatCalculationResult {
  /// Creates a Zakat calculation result.
  const ZakatCalculationResult({
    required this.zakatBase,
    required this.zakatAmount,
    required this.components,
  });

  /// The total zakatable base (net zakatable assets).
  final Decimal zakatBase;

  /// The calculated Zakat amount (2.5% of [zakatBase]).
  final Decimal zakatAmount;

  /// Breakdown of the calculation components.
  final Map<String, Decimal> components;
}

/// Service responsible for Zakat Intelligence and Compliance.
///
/// Handles the automated calculation of Zakat Al-Maal according to
/// simplified KSA standards (Net Assets / Equity Method approximation).
@riverpod
class ZakatIntelligenceService extends _$ZakatIntelligenceService {
  @override
  FutureOr<void> build() {
    // No initialization logic needed for now.
  }

  /// Calculates Zakat Al-Maal for a given period.
  ///
  /// Uses a strict 2.5% rate on the Zakatable Base.
  /// Current Implementation uses the "Net Working Capital" method as a proxy:
  /// (Current Assets - Current Liabilities) approx = Net Zakatable Assets.
  ///
  /// "Sources of Funds" method (Equity + Long Term Liabilities - Fixed
  /// Assets).
  Future<ZakatCalculationResult> calculateZakat({
    required DateTime asOfDate,
  }) async {
    final reportService = ref.read(financialStatementServiceProvider.notifier);

    // We generate a Balance Sheet effectively "as of" the given date.
    // In a real scenario, we might want a specific period range.
    final balanceSheet = await reportService.generateBalanceSheet(asOfDate);

    // Extract key figures using standard account codes or report structure.
    // Note: This relies on the Balance Sheet structure defined in
    // FinancialStatementService.

    var currentAssets = Decimal.zero;
    var currentLiabilities = Decimal.zero;

    // Iterate through lines to find Current Assets and Current Liabilities.
    // This is a heuristic match based on standard naming/IDs.
    // Ideally, we'd use tags or specific account references.
    for (final line in balanceSheet.lines) {
      if (line.label.contains('Current Assets') ||
          line.label.contains('الأصول المتداولة')) {
        currentAssets = line.amount;
      }
      if (line.label.contains('Current Liabilities') ||
          line.label.contains('الخصوم المتداولة')) {
        currentLiabilities = line.amount;
      }
    }

    // Zakatable Base = Net Working Capital (simplified)
    // Adjusted for Zakat rules (e.g. strict lunar year vs gregorian).
    // Here we assume standard 2.5%.
    final zakatBase = currentAssets - currentLiabilities;

    // Zakat is not negative; if liabilities > assets for this calc, base is 0.
    final finalBase = zakatBase < Decimal.zero ? Decimal.zero : zakatBase;

    final rate = Decimal.parse('0.025');
    final zakatAmount = finalBase * rate;

    return ZakatCalculationResult(
      zakatBase: finalBase,
      zakatAmount: zakatAmount,
      components: {
        'Current Assets': currentAssets,
        'Current Liabilities': currentLiabilities,
        'Net Zakatable Base': finalBase,
      },
    );
  }

  /// Validates a Journal Entry for basic Sharia compliance flags.
  ///
  /// Returns a list of warning messages if any non-compliant patterns are
  /// found.
  /// found.
  /// found.
  /// Example: Explicit interest keywords.
  List<String> auditEntryForShariaCompliance(dynamic entry) {
    // This expects a JournalEntry entity or similar.
    // Since we don't have the entity in scope for this method signature
    // generically,
    // we'll assume it handles description/account checks.
    final warnings = <String>[];

    // Placeholder logic - to be deepened with actual Entity introspection.
    // if (entry.description.toLowerCase().contains('interest') ||
    //     entry.description.toLowerCase().contains('riba')) {
    //   warnings.add('Potential Riba detected in entry description.');
    // }

    return warnings;
  }
}
