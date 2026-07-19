// ignore_for_file: lines_longer_than_80_chars
import 'package:basir_accounting_system/features/accounting/application/financial_reporting_service.dart';
import 'package:decimal/decimal.dart';

/// Mock implementation of FinancialReportingService for testing
class MockFinancialReportingService {
  /// Mock revenue trend data
  Future<Map<DateTime, Decimal>> getRevenueTrend() async {
    // Return mock data for the last 7 days
    final now = DateTime.now();
    return {
      for (var i = 6; i >= 0; i--)
        DateTime(now.year, now.month, now.day - i):
            Decimal.fromInt(1000 + i * 200),
    };
  }

  /// Mock expense composition data
  Future<Map<String, Decimal>> getExpenseComposition() async => {
        'Office Supplies': Decimal.fromInt(500),
        'Marketing': Decimal.fromInt(800),
        'Utilities': Decimal.fromInt(300),
        'Other': Decimal.fromInt(200),
      };

  /// Mock trial balance data
  Future<List<AccountBalanceReport>> getTrialBalance() async => [];

  /// Mock income statement data
  Future<Map<String, dynamic>> getIncomeStatement({
    DateTime? from,
    DateTime? to,
  }) async =>
      {
        'totalRevenue': Decimal.fromInt(5000),
        'totalExpenses': Decimal.fromInt(3000),
        'netIncome': Decimal.fromInt(2000),
        'revenueDetails': <String, Decimal>{},
        'expenseDetails': <String, Decimal>{},
      };
}

/// Mock FinancialReportingService AsyncNotifier for testing
class MockFinancialReportingServiceNotifier extends FinancialReportingService {
  final MockFinancialReportingService _mockService =
      MockFinancialReportingService();

  @override
  Future<Map<DateTime, Decimal>> getRevenueTrend() =>
      _mockService.getRevenueTrend();

  @override
  Future<Map<String, Decimal>> getExpenseComposition() =>
      _mockService.getExpenseComposition();

  @override
  Future<List<AccountBalanceReport>> getTrialBalance() =>
      _mockService.getTrialBalance();

  @override
  Future<Map<String, dynamic>> getIncomeStatement({
    DateTime? from,
    DateTime? to,
  }) =>
      _mockService.getIncomeStatement(from: from, to: to);
}
