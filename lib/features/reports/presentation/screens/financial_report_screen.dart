// ignore_for_file: lines_longer_than_80_chars
import 'package:basir_accounting_system/core/extensions/context_extensions.dart';
import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/accounting/application/orchestrator_service.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/accounting_agent.dart';
import 'package:basir_accounting_system/features/reports/presentation/widgets/report_filter_widget.dart';
import 'package:basir_accounting_system/features/reports/presentation/widgets/report_line_item.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:basir_accounting_system/src/rust/api/reports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';

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
  bool _useFairValue = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    // Default to current year YTD
    _fromDate = DateTime(now.year);
    _toDate = now;
  }

  String _getTitle(BuildContext context) {
    switch (widget.reportType) {
      case FinancialReportType.incomeStatement:
        return context.l10n.incomeStatementTitle;
      case FinancialReportType.balanceSheet:
        return context.l10n.balanceSheetTitle;
      case FinancialReportType.cashFlow:
        return context.l10n.cashFlowTitle;
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
          useFairValue: _useFairValue,
        ),
      ),
    );

    return GlassScaffold(
      title: _getTitle(context),
      actions: [
        if (reportAsync.hasValue)
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: context.l10n.actionShare,
            onPressed: () async {
              final pdfService =
                  ref.read(pdfGenerationServiceProvider.notifier);
              final pdfBytes =
                  await pdfService.generateReportPdf(reportAsync.value!);

              await Printing.sharePdf(
                bytes: pdfBytes,
                filename: '${reportAsync.value!.title}.pdf',
              );
            },
          ),
      ],
      body: Column(
        children: [
          ReportFilterWidget(
            fromDate: _fromDate,
            toDate: _toDate,
            showFromDate: !_isPointInTime,
            onFromDateChanged: (val) => setState(() => _fromDate = val),
            onToDateChanged: (val) => setState(() => _toDate = val),
          ),
          if (widget.reportType == FinancialReportType.balanceSheet)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SwitchListTile.adaptive(
                title: Text(context.l10n.labelFairValueAdjustment),
                subtitle: Text(context.l10n.subtitleFairValueAdjustment),
                value: _useFairValue,
                onChanged: (val) => setState(() => _useFairValue = val),
                activeTrackColor: Theme.of(context).primaryColor,
              ),
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
                      useFairValue: _useFairValue,
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
        child: GlassCard(
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

              const SizedBox(height: 32),
              const Divider(),
              const SizedBox(height: 16),

              // Cognitive Insights Section
              Text(
                'Cognitive Hexagon Insights',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
              ),
              const SizedBox(height: 8),
              FutureBuilder<List<AgentResult>>(
                future: ref
                    .read(orchestratorServiceProvider.notifier)
                    .getPeriodInsights(_fromDate, _toDate),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: LinearProgressIndicator()),
                    );
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading insights: ${snapshot.error}');
                  }

                  final insights = snapshot.data ?? [];
                  if (insights.isEmpty) {
                    return const Text('No insights available for this period.');
                  }

                  return Column(
                    children: insights
                        .map(
                          (agentResult) => ListTile(
                            leading: const Icon(Icons.psychology,
                                color: Colors.purple),
                            title: Text(agentResult.agentId),
                            subtitle: Text(agentResult.rationale),
                            dense: true,
                            trailing: agentResult.isAllowed
                                ? const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  )
                                : const Icon(Icons.warning,
                                    color: Colors.orange),
                          ),
                        )
                        .toList(),
                  );
                },
              ),
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
      String toDate,
      bool useFairValue,
    })>((ref, params) async {
  final service = ref.watch(nativeReportingServiceProvider);
  final fairValueService = ref.watch(fairValuationServiceProvider);

  switch (params.type) {
    case FinancialReportType.incomeStatement:
      return service.generateIncomeStatement(
        fromDate: params.fromDate,
        toDate: params.toDate,
      );
    case FinancialReportType.balanceSheet:
      // For BS, 'toDate' is the 'As Of' date.
      Map<String, String>? updates;
      if (params.useFairValue) {
        final asOfDate = DateTime.parse(params.toDate);
        final adjustments =
            await fairValueService.getFairValueAdjustments(asOfDate);
        if (adjustments.isNotEmpty) {
          updates = adjustments.map((k, v) => MapEntry(k, v.toString()));
        }
      }
      return service.generateBalanceSheet(
        asOfDate: params.toDate,
        fairValuationUpdates: updates,
      );
    case FinancialReportType.cashFlow:
      return service.generateCashFlowStatement(
        fromDate: params.fromDate,
        toDate: params.toDate,
      );
  }
});
