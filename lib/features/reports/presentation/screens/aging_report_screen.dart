import 'package:basir_app/core/providers.dart';
import 'package:basir_app/core/utils/format_helpers.dart';
import 'package:basir_app/features/reports/presentation/widgets/report_filter_widget.dart';
import 'package:basir_app/shared/widgets/index.dart';
import 'package:basir_app/src/rust/api/reports.dart';
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

  String get _title => widget.reportType == AgingReportType.receivables
      ? 'أعمار ذمم العملاء'
      : 'أعمار ذمم الموردين';

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
        title: _title,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // TODO(m): Export aging report
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
      return const Center(child: Text('لا توجد بيانات لهذه الفترة'));
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
              columns: const [
                DataColumn(label: Text('الطرف')),
                DataColumn(label: Text('الحالي'), numeric: true),
                DataColumn(label: Text('1-30'), numeric: true),
                DataColumn(label: Text('31-60'), numeric: true),
                DataColumn(label: Text('61-90'), numeric: true),
                DataColumn(label: Text('> 90'), numeric: true),
                DataColumn(label: Text('الإجمالي'), numeric: true),
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
