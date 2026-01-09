import 'package:basir_app/core/providers.dart';
import 'package:basir_app/core/utils/format_helpers.dart';
import 'package:basir_app/features/reports/presentation/widgets/report_filter_widget.dart';
import 'package:basir_app/shared/widgets/index.dart';
import 'package:basir_app/src/rust/api/reports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

/// Screen for displaying the Trial Balance report.
class TrialBalanceScreen extends ConsumerStatefulWidget {
  /// Creates a new Trial Balance screen.
  const TrialBalanceScreen({super.key});

  @override
  ConsumerState<TrialBalanceScreen> createState() => _TrialBalanceScreenState();
}

class _TrialBalanceScreenState extends ConsumerState<TrialBalanceScreen> {
  // Only 'As Of' date is strictly required for pure TB,
  // but if we support movements, we need period.
  // Native API: <credential-fixture>(asOfDate, periodStart?)
  DateTime _asOfDate = DateTime.now();
  DateTime? _periodStart;

  @override
  Widget build(BuildContext context) {
    final reportAsync = ref.watch(
      _trialBalanceProvider(
        (
          asOfDate: DateFormat('yyyy-MM-dd').format(_asOfDate),
          periodStart: _periodStart != null
              ? DateFormat('yyyy-MM-dd').format(_periodStart!)
              : null,
        ),
      ),
    );

    return Scaffold(
      appBar: const AppAppBar(
        title: 'ميزان المراجعة', // Trial Balance
      ),
      body: Column(
        children: [
          ReportFilterWidget(
            toDate: _asOfDate, // "As Of"
            showFromDate: false,
            onToDateChanged: (val) => setState(() => _asOfDate = val),
            onFromDateChanged: (val) {}, // Not used if showFromDate is false
          ),
          const SizedBox(height: 8),
          Expanded(
            child: reportAsync.when(
              loading: () => const Center(child: AppLoadingIndicator()),
              error: (err, stack) => AppErrorWidget(
                message: err.toString(),
                onRetry: () => ref.refresh(
                  _trialBalanceProvider(
                    (
                      asOfDate: DateFormat('yyyy-MM-dd').format(_asOfDate),
                      periodStart: null,
                    ),
                  ).future,
                ),
              ),
              data: (report) => _buildReportContent(context, report),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportContent(BuildContext context, TrialBalanceDto report) =>
      SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: AppCard(
          child: Column(
            children: [
              // Status Header
              Container(
                padding: const EdgeInsets.all(12),
                color: report.isBalanced
                    ? Colors.green.withOpacity(0.1)
                    : Colors.red.withOpacity(0.1),
                child: Row(
                  children: [
                    Icon(
                      report.isBalanced ? Icons.check_circle : Icons.warning,
                      color: report.isBalanced ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      report.isBalanced
                          ? 'الميزان متزن (Balanced)'
                          : 'الميزان غير متزن! يرجى المراجعة.',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: report.isBalanced ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              // Table
              Table(
                columnWidths: const {
                  0: FlexColumnWidth(), // Code
                  1: FlexColumnWidth(3), // Name
                  2: FlexColumnWidth(1.5), // Debit
                  3: FlexColumnWidth(1.5), // Credit
                },
                border: TableBorder(
                  horizontalInside: BorderSide(color: Colors.grey.shade200),
                ),
                children: [
                  TableRow(
                    decoration: BoxDecoration(color: Colors.grey.shade100),
                    children: const [
                      _HeaderCell('رقم الحساب'),
                      _HeaderCell('اسم الحساب'),
                      _HeaderCell('مدين'),
                      _HeaderCell('دائن'),
                    ],
                  ),
                  ...report.lines.map(
                    (line) => TableRow(
                      children: [
                        _ContentCell(line.accountCode),
                        _ContentCell(line.accountName, align: TextAlign.start),
                        _ContentCell(
                          FormatHelpers.formatCurrency(
                            double.parse(line.debitBalance),
                          ),
                        ),
                        _ContentCell(
                          FormatHelpers.formatCurrency(
                            double.parse(line.creditBalance),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Totals
                  TableRow(
                    decoration: BoxDecoration(color: Colors.grey.shade50),
                    children: [
                      const SizedBox(),
                      const _ContentCell('الإجمالي', isBold: true),
                      _ContentCell(
                        FormatHelpers.formatCurrency(
                          double.parse(report.totalDebits),
                        ),
                        isBold: true,
                      ),
                      _ContentCell(
                        FormatHelpers.formatCurrency(
                          double.parse(report.totalCredits),
                        ),
                        isBold: true,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      );
}

class _ContentCell extends StatelessWidget {
  const _ContentCell(
    this.text, {
    this.isBold = false,
    this.align = TextAlign.center,
  });
  final String text;
  final bool isBold;
  final TextAlign align;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
          textAlign: align,
        ),
      );
}

// Internal provider for fetching TB data
final _trialBalanceProvider = FutureProvider.autoDispose
    .family<TrialBalanceDto, ({String asOfDate, String? periodStart})>(
  (ref, params) {
    final service = ref.watch(nativeReportingServiceProvider);
    return service.generateTrialBalance(
      asOfDate: params.asOfDate,
      periodStart: params.periodStart,
    );
  },
);
