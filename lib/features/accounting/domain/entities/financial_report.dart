import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'financial_report.freezed.dart';

/// بند في تقرير مالي
@freezed
class FinancialReportLine with _$FinancialReportLine {
  const factory FinancialReportLine({
    required String label,
    required Decimal amount,
    @Default(false) bool isTitle,
    @Default(false) bool isTotal,
    @Default(0) int indentLevel,
  }) = _FinancialReportLine;
}

/// تقرير مالي (ميزانية، قائمة دخل، إلخ)
@freezed
class FinancialReport with _$FinancialReport {
  const factory FinancialReport({
    required String title,
    required DateTime fromDate,
    required DateTime toDate,
    required List<FinancialReportLine> lines,
    required DateTime generatedAt,
  }) = _FinancialReport;
}

/// ميزان المراجعة (Trial Balance)
@freezed
class TrialBalanceLine with _$TrialBalanceLine {
  const factory TrialBalanceLine({
    required String accountCode,
    required String accountName,
    required Decimal debitBalance,
    required Decimal creditBalance,
  }) = _TrialBalanceLine;
}

@freezed
class TrialBalance with _$TrialBalance {
  const factory TrialBalance({
    required DateTime date,
    required List<TrialBalanceLine> lines,
    required Decimal totalDebit,
    required Decimal totalCredit,
  }) = _TrialBalance;
}
