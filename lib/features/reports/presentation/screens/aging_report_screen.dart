// ignore_for_file: lines_longer_than_80_chars
import 'package:basir_accounting_system/core/extensions/context_extensions.dart';
import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/core/utils/format_helpers.dart';
import 'package:basir_accounting_system/features/reports/presentation/widgets/report_filter_widget.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:basir_accounting_system/src/rust/api/reports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

/// Types of aging reports.
enum AgingReportType {
  /// Accounts Receivable (Customers)
  receivables,

  /// Accounts Payable (Vendors)
  payables,
}

/// Screen to display aging analysis for receivables or payables.
class AgingReportScreen extends ConsumerStatefulWidget {
  /// Creates an aging report screen.
  const AgingReportScreen({required this.reportType, super.key});

  /// The category of accounts to analyze.
  final AgingReportType reportType;

  @override
  ConsumerState<AgingReportScreen> createState() => _AgingReportScreenState();
}

class _AgingReportScreenState extends ConsumerState<AgingReportScreen> {
  DateTime _asOfDate = DateTime.now();

  String _getTitle(BuildContext context) =>
      widget.reportType == AgingReportType.receivables
          ? context.l10n.receivablesAgingTitle
          : context.l10n.payablesAgingTitle;

  @override
  Widget build(BuildContext context) {
    final reportAsync = ref.watch(
      _agingReportProvider(
        (
          type: widget.reportType,
          asOfDate: DateFormat('yyyy-MM-dd').format(_asOfDate),
        ),
      ),
    );

    return Scaffold(
      appBar: AppAppBar(
        title: _getTitle(context),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(context.l10n.msgExportComingSoon)),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          ReportFilterWidget(
            toDate: _asOfDate,
            showFromDate: false,
            onToDateChanged: (val) => setState(() => _asOfDate = val),
            onFromDateChanged: (_) {},
          ),
          const SizedBox(height: 8),
          Expanded(
            child: reportAsync.when(
              loading: () => const Center(child: AppLoadingIndicator()),
              error: (err, stack) => AppErrorWidget(
                message: err.toString(),
                onRetry: () => ref.refresh(
                  _agingReportProvider(
                    (
                      type: widget.reportType,
                      asOfDate: DateFormat('yyyy-MM-dd').format(_asOfDate),
                    ),
                  ).future,
                ),
              ),
              data: (lines) => _buildReportContent(context, lines),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportContent(
    BuildContext context,
    List<AgingReportLineDto> lines,
  ) {
    if (lines.isEmpty) {
      return Center(child: Text(context.l10n.noDataMessage));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: AppCard(
            padding: EdgeInsets.zero,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(Colors.grey.shade100),
              columns: [
                DataColumn(label: Text(context.l10n.labelPartner)),
                DataColumn(
                  label: Text(context.l10n.periodCurrent),
                  numeric: true,
                ),
                DataColumn(label: Text(context.l10n.period1_30), numeric: true),
                DataColumn(
                  label: Text(context.l10n.period31_60),
                  numeric: true,
                ),
                DataColumn(
                  label: Text(context.l10n.period61_90),
                  numeric: true,
                ),
                DataColumn(
                  label: Text(context.l10n.periodOver90),
                  numeric: true,
                ),
                DataColumn(label: Text(context.l10n.labelTotal), numeric: true),
              ],
              rows: lines
                  .map(
                    (line) => DataRow(
                      cells: [
                        DataCell(Text(line.partnerName)),
                        DataCell(Text(_format(line.currentAmount))),
                        DataCell(Text(_format(line.period130))),
                        DataCell(Text(_format(line.period3160))),
                        DataCell(Text(_format(line.period6190))),
                        DataCell(Text(_format(line.periodOver90))),
                        DataCell(
                          Text(
                            _format(line.totalAmount),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }

  String _format(String amount) =>
      FormatHelpers.formatCurrency(double.tryParse(amount) ?? 0);
}

// Internal provider for aging data
final _agingReportProvider = FutureProvider.autoDispose.family<
    List<AgingReportLineDto>,
    ({AgingReportType type, String asOfDate})>((ref, params) {
  final service = ref.watch(nativeReportingServiceProvider);
  if (params.type == AgingReportType.receivables) {
    return service.getReceivablesAging(asOfDate: params.asOfDate);
  } else {
    return service.getPayablesAging(asOfDate: params.asOfDate);
  }
});
