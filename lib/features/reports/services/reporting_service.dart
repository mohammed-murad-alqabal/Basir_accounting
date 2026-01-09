import 'package:basir_app/src/rust/api/reports.dart' as rust;
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Wrapper for native reporting functions to allow mocking.
class NativeReportingApi {
  /// Generate a Trial Balance report.
  Future<rust.TrialBalanceDto> generateTrialBalance({
    required String asOfDate,
    String? periodStart,
  }) =>
      rust.generateTrialBalance(asOfDate: asOfDate, periodStart: periodStart);

  /// Drill down into account entries.
  Future<List<rust.DrillDownEntryDto>> getAccountEntries({
    required String accountId,
    required String periodEnd,
    String? periodStart,
  }) =>
      rust.getAccountEntries(
        accountId: accountId,
        periodStart: periodStart,
        periodEnd: periodEnd,
      );

  /// Generate an Income Statement.
  Future<rust.FinancialReportDto> generateIncomeStatement({
    required String fromDate,
    required String toDate,
  }) =>
      rust.generateIncomeStatement(fromDate: fromDate, toDate: toDate);

  /// Generate a Balance Sheet.
  Future<rust.FinancialReportDto> generateBalanceSheet({
    required String asOfDate,
  }) =>
      rust.generateBalanceSheet(asOfDate: asOfDate);

  /// Generate a Statement of Cash Flows.
  Future<rust.FinancialReportDto> generateCashFlowStatement({
    required String fromDate,
    required String toDate,
  }) =>
      rust.generateCashFlowStatement(fromDate: fromDate, toDate: toDate);

  /// Generate Accounts Receivable Aging Report.
  Future<List<rust.AgingReportLineDto>> getReceivablesAging({
    required String asOfDate,
  }) =>
      rust.getReceivablesAging(asOfDate: asOfDate);

  /// Generate Accounts Payable Aging Report.
  Future<List<rust.AgingReportLineDto>> getPayablesAging({
    required String asOfDate,
  }) =>
      rust.getPayablesAging(asOfDate: asOfDate);

  /// Generate Zakah Statement.
  Future<rust.FinancialReportDto> generateZakahStatement({
    required String asOfDate,
    required rust.ZakahCalendarDto calendar,
  }) =>
      rust.generateZakahStatement(asOfDate: asOfDate, calendar: calendar);
}

/// Service responsible for fetching financial reports from the native Rust core.
class ReportingService {
  /// Creates a reporting service.
  ReportingService({NativeReportingApi? api})
      : _api = api ?? NativeReportingApi();

  final NativeReportingApi _api;

  /// Generate a Trial Balance report.
  Future<rust.TrialBalanceDto> generateTrialBalance({
    required String asOfDate,
    String? periodStart,
  }) async {
    try {
      return await _api.generateTrialBalance(
        asOfDate: asOfDate,
        periodStart: periodStart,
      );
    } catch (e) {
      // TODO(m): improvements on error handling (e.g. converting to domain)
      rethrow;
    }
  }

  /// Drill down into account entries.
  Future<List<rust.DrillDownEntryDto>> getAccountEntries({
    required String accountId,
    required String periodEnd,
    String? periodStart,
  }) async =>
      _api.getAccountEntries(
        accountId: accountId,
        periodStart: periodStart,
        periodEnd: periodEnd,
      );

  /// Generate an Income Statement.
  Future<rust.FinancialReportDto> generateIncomeStatement({
    required String fromDate,
    required String toDate,
  }) async =>
      _api.generateIncomeStatement(
        fromDate: fromDate,
        toDate: toDate,
      );

  /// Generate a Balance Sheet.
  Future<rust.FinancialReportDto> generateBalanceSheet({
    required String asOfDate,
  }) async =>
      _api.generateBalanceSheet(
        asOfDate: asOfDate,
      );

  /// Generate a Statement of Cash Flows.
  Future<rust.FinancialReportDto> generateCashFlowStatement({
    required String fromDate,
    required String toDate,
  }) async =>
      _api.generateCashFlowStatement(
        fromDate: fromDate,
        toDate: toDate,
      );

  /// Generate Accounts Receivable Aging Report.
  Future<List<rust.AgingReportLineDto>> getReceivablesAging({
    required String asOfDate,
  }) async =>
      _api.getReceivablesAging(
        asOfDate: asOfDate,
      );

  /// Generate Accounts Payable Aging Report.
  Future<List<rust.AgingReportLineDto>> getPayablesAging({
    required String asOfDate,
  }) async =>
      _api.getPayablesAging(
        asOfDate: asOfDate,
      );

  /// Generate Zakah Statement.
  Future<rust.FinancialReportDto> generateZakahStatement({
    required String asOfDate,
    required rust.ZakahCalendarDto calendar,
  }) async =>
      _api.generateZakahStatement(
        asOfDate: asOfDate,
        calendar: calendar,
      );
}

/// Provider for the [ReportingService].
final nativeReportingServiceProvider =
    Provider<ReportingService>((ref) => ReportingService());
