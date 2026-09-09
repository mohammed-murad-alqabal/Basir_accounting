import 'package:basir_accounting_system/src/rust/api/reports.dart' as rust;
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
    Map<String, String>? fairValuationUpdates,
  }) =>
      rust.generateBalanceSheet(
        asOfDate: asOfDate,
        fairValuationUpdates: fairValuationUpdates,
      );

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

/// خدمة جلب التقارير المالية من المحرك الأساسي (Rust).
///
/// تلتف الخدمة حول مكالمات Rust الأصلية، وتحويل الاستثناءات المنخفضة المستوى
/// إلى استثناءات واضحة المعنى يمكن للمستودع أو طبقة العرض التعامل معها.
class ReportingService {
  /// Creates a reporting service.
  ReportingService({
    NativeReportingApi? api,
  }) : _api = api ?? NativeReportingApi();

  final NativeReportingApi _api;

  /// تحويل استثناءات Rust/المنصة إلى نص واضح مع الاحتفاظ بالسياق.
  Never _wrapError(String operation, Object e) {
    final details = switch (e) {
      // ignore: avoid_dynamic_calls
      _ when e.toString().startsWith('FFI') =>
        'خطأ في المنصة الأصلية (Rust FFI): ${e.toString().split('\n').first}',
      _ => e.toString(),
    };
    throw Exception('فشل $operation — $details');
  }

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
      _wrapError('إنشاء ميزان المراجعة عند $asOfDate', e);
    }
  }

  /// Drill down into account entries.
  Future<List<rust.DrillDownEntryDto>> getAccountEntries({
    required String accountId,
    required String periodEnd,
    String? periodStart,
  }) async {
    try {
      return await _api.getAccountEntries(
        accountId: accountId,
        periodStart: periodStart,
        periodEnd: periodEnd,
      );
    } catch (e) {
      _wrapError(
        'جلب سجلات الحساب $accountId',
        e,
      );
    }
  }

  /// Generate an Income Statement.
  Future<rust.FinancialReportDto> generateIncomeStatement({
    required String fromDate,
    required String toDate,
  }) async {
    try {
      return await _api.generateIncomeStatement(
        fromDate: fromDate,
        toDate: toDate,
      );
    } catch (e) {
      _wrapError(
        'إنشاء قائمة الدخل ($fromDate — $toDate)',
        e,
      );
    }
  }

  /// Generate a Balance Sheet.
  Future<rust.FinancialReportDto> generateBalanceSheet({
    required String asOfDate,
    Map<String, String>? fairValuationUpdates,
  }) async {
    try {
      return await _api.generateBalanceSheet(
        asOfDate: asOfDate,
        fairValuationUpdates: fairValuationUpdates,
      );
    } catch (e) {
      _wrapError('إنشاء الميزانية العمومية عند $asOfDate', e);
    }
  }

  /// Generate a Statement of Cash Flows.
  Future<rust.FinancialReportDto> generateCashFlowStatement({
    required String fromDate,
    required String toDate,
  }) async {
    try {
      return await _api.generateCashFlowStatement(
        fromDate: fromDate,
        toDate: toDate,
      );
    } catch (e) {
      _wrapError(
        'إنشاء قائمة التدفقات النقدية ($fromDate — $toDate)',
        e,
      );
    }
  }

  /// Generate Accounts Receivable Aging Report.
  Future<List<rust.AgingReportLineDto>> getReceivablesAging({
    required String asOfDate,
  }) async {
    try {
      return await _api.getReceivablesAging(asOfDate: asOfDate);
    } catch (e) {
      _wrapError('إنشاء تقرير عمر الذمم المدينة عند $asOfDate', e);
    }
  }

  /// Generate Accounts Payable Aging Report.
  Future<List<rust.AgingReportLineDto>> getPayablesAging({
    required String asOfDate,
  }) async {
    try {
      return await _api.getPayablesAging(asOfDate: asOfDate);
    } catch (e) {
      _wrapError('إنشاء تقرير عمر الذمم الدائنة عند $asOfDate', e);
    }
  }

  /// Generate Zakah Statement.
  Future<rust.FinancialReportDto> generateZakahStatement({
    required String asOfDate,
    required rust.ZakahCalendarDto calendar,
  }) async {
    try {
      return await _api.generateZakahStatement(
        asOfDate: asOfDate,
        calendar: calendar,
      );
    } catch (e) {
      _wrapError('إنشاء قائمة الزكاة عند $asOfDate', e);
    }
  }
}

/// Provider for the [ReportingService].
final nativeReportingServiceProvider = Provider<ReportingService>(
  (ref) => ReportingService(),
);
