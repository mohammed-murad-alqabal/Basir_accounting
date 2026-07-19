import 'package:basir_accounting_system/features/accounting/domain/entities/financial_report.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// A reusable widget to display a [FinancialReport].
class FinancialStatementView extends StatelessWidget {
  /// Creates a report view for the given [report].
  const FinancialStatementView({
    required this.report,
    super.key,
  });

  /// The financial report instance to render.
  final FinancialReport report;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  report.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  '${DateFormat.yMMMd().format(report.fromDate)} - '
                  '${DateFormat.yMMMd().format(report.toDate)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(bottom: 24),
              itemCount: report.lines.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final line = report.lines[index];
                return _FinancialReportLineTile(line: line);
              },
            ),
          ),
        ],
      );
}

class _FinancialReportLineTile extends StatelessWidget {
  const _FinancialReportLineTile({
    required this.line,
  });

  final FinancialReportLine line;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isBold = line.isTitle || line.isTotal;

    return Container(
      color: line.isTitle
          ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3)
          : null,
      child: Padding(
        padding: EdgeInsetsDirectional.only(
          start: 16.0 + (line.indentLevel * 24.0),
          end: 16,
          top: 12,
          bottom: 12,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                line.label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            if (!line.isTitle || line.isTotal)
              Text(
                NumberFormat.currency(symbol: '').format(
                  line.amount.toDouble(),
                ),
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  fontFamily: 'RobotoMono', // Better for alignment
                ),
              ),
          ],
        ),
      ),
    );
  }
}
