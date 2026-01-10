import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'financial_report.freezed.dart';

/// Single granular line within a financial statement or report.
@freezed
class FinancialReportLine with _$FinancialReportLine {
  /// Creates a financial report line.
  const factory FinancialReportLine({
    /// Descriptive text for the line (e.g., "Gross Revenue", "Depreciation").
    required String label,

    /// The numerical value as a high-precision [Decimal].
    required Decimal amount,

    /// If true, this line serves as a header or section title.
    @Default(false) bool isTitle,

    /// If true, this line represents a subtotal or grand total.
    @Default(false) bool isTotal,

    /// Visual depth level for hierarchical presentation (0 = root).
    @Default(0) int indentLevel,
  }) = _FinancialReportLine;
}

/// Generalized container for various financial statements.
@freezed
class FinancialReport with _$FinancialReport {
  /// Creates a financial report container.
  const factory FinancialReport({
    /// Report name (e.g., "Statutory Balance Sheet").
    required String title,

    /// Start of the reporting period.
    required DateTime fromDate,

    /// End of the reporting period.
    required DateTime toDate,

    /// Ordered sequence of report lines.
    required List<FinancialReportLine> lines,

    /// System timestamp of report generation.
    required DateTime generatedAt,
  }) = _FinancialReport;
}

/// Simplified line model for Trial Balance reporting.
@freezed
class TrialBalanceLine with _$TrialBalanceLine {
  /// Creates a trial balance line.
  const factory TrialBalanceLine({
    /// Unique accounting code string.
    required String accountCode,

    /// Localized account name.
    required String accountName,

    /// Period-to-date Debit total.
    required Decimal debitBalance,

    /// Period-to-date Credit total.
    required Decimal creditBalance,
  }) = _TrialBalanceLine;
}

/// Consolidated state of the ledger at a specific point in time.
@freezed
class TrialBalance with _$TrialBalance {
  /// Creates a trial balance snapshot.
  const factory TrialBalance({
    /// The specific date the snapshot was taken.
    required DateTime date,

    /// Collection of account-level balances.
    required List<TrialBalanceLine> lines,

    /// Grand sum of all Debit balances (must match totalCredit).
    required Decimal totalDebit,

    /// Grand sum of all Credit balances (must match totalDebit).
    required Decimal totalCredit,
  }) = _TrialBalance;
}
