import 'package:basir_app/core/providers.dart';
import 'package:basir_app/features/reports/presentation/widgets/report_filter_widget.dart';
import 'package:basir_app/features/reports/presentation/widgets/report_line_item.dart';
import 'package:basir_app/shared/widgets/index.dart';
import 'package:basir_app/src/rust/api/reports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

/// Available financial report types.
enum FinancialReportType {
  /// Income Statement (Profit & Loss)
  incomeStatement,

  /// Balance Sheet (Statement of Financial Position)
  balanceSheet,

  /// Statement of Cash Flows
  cashFlow,
}

/// A generic screen to display various financial reports.
class FinancialReportScreen extends ConsumerStatefulWidget {
  /// Creates a financial report screen.
  const FinancialReportScreen({required this.reportType, super.key});

  /// The type of report to display.
  final FinancialReportType reportType;

  @override
  ConsumerState<FinancialReportScreen> createState() =>
      _FinancialReportScreenState();
}

class _FinancialReportScreenState extends ConsumerState<FinancialReportScreen> {
  late DateTime _fromDate;
  late DateTime _toDate;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    // Default to current year YTD
    _fromDate = DateTime(now.year);
    _toDate = now;
  }

  String get _title {
    switch (widget.reportType) {
      case FinancialReportType.incomeStatement:
        return 'قائمة الدخل';
      case FinancialReportType.balanceSheet:
        return 'المركز المالي'; // Statement of Financial Position
      case FinancialReportType.cashFlow:
        return 'التدفقات النقدية';
    }
  }

  // Balance sheet is "As Of", others are periods.
  bool get _isPointInTime =>
      widget.reportType == FinancialReportType.balanceSheet;

  @override
  Widget build(BuildContext context) {
    // Determine which API to call
    final reportAsync = ref.watch(
      _financialReportProvider(
        (
          type: widget.reportType,
          fromDate: DateFormat('yyyy-MM-dd').format(_fromDate),
          toDate: DateFormat('yyyy-MM-dd').format(_toDate),
        ),
      ),
    );

    return Scaffold(
      appBar: AppAppBar(
        title: _title,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // TODO(m): Export functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('سيتم تفعيل التصدير قريباً')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          ReportFilterWidget(
            fromDate: _fromDate,
            toDate: _toDate,
            showFromDate: !_isPointInTime,
            onFromDateChanged: (val) => setState(() => _fromDate = val),
            onToDateChanged: (val) => setState(() => _toDate = val),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: reportAsync.when(
              loading: () => const Center(child: AppLoadingIndicator()),
              error: (err, stack) => AppErrorWidget(
                message: err.toString(),
                onRetry: () => ref.refresh(
                  _financialReportProvider(
                    (
                      type: widget.reportType,
                      fromDate: DateFormat('yyyy-MM-dd').format(_fromDate),
                      toDate: DateFormat('yyyy-MM-dd').format(_toDate),
                    ),
                  ).future,
                ),
              ),
              data: _buildReportContent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportContent(FinancialReportDto report) =>
      SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: AppCard(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Internal Title from Report
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  report.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Text(
                  _isPointInTime
                      ? 'كما في: ${report.toDate}'
                      : 'عن الفترة من ${report.fromDate} إلى ${report.toDate}',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ),
              const Divider(height: 24),
              // Lines
              ...report.lines.map((line) => ReportLineItem(line: line)),
            ],
          ),
        ),
      );
}

// Internal provider for fetching generic reports
final _financialReportProvider = FutureProvider.autoDispose.family<
    FinancialReportDto,
    ({
      FinancialReportType type,
      String fromDate,
      String toDate
    })>((ref, params) {
  final service = ref.watch(nativeReportingServiceProvider);
  switch (params.type) {
    case FinancialReportType.incomeStatement:
      return service.generateIncomeStatement(
        fromDate: params.fromDate,
        toDate: params.toDate,
      );
    case FinancialReportType.balanceSheet:
      // For BS, 'toDate' is the 'As Of' date.
      return service.generateBalanceSheet(asOfDate: params.toDate);
    case FinancialReportType.cashFlow:
      return service.generateCashFlowStatement(
        fromDate: params.fromDate,
        toDate: params.toDate,
      );
  }
});
