// ignore_for_file: lines_longer_than_80_chars
import 'dart:io';

import 'package:basir_accounting_system/core/extensions/context_extensions.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/features/accounting/application/financial_statement_service.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/financial_report.dart';
import 'package:basir_accounting_system/features/accounting/presentation/screens/journal_entries_screen.dart';
import 'package:basir_accounting_system/features/reports/application/forensic_export_service.dart';
import 'package:basir_accounting_system/features/reports/presentation/widgets/comparative_analysis_chart.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' as intl;
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart'; // For PDF sharing
import 'package:share_plus/share_plus.dart';

/// Screen for displaying the Statement of Profit or Loss (Income Statement).
///
/// categorizing performance into Operating, Investing, and Financing
/// activities.
class IncomeStatementScreen extends ConsumerWidget {
  /// Creates the income statement screen.
  const IncomeStatementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final fromDate = DateTime(now.year, now.month);
    final toDate = now;

    final incomeStatementAsync = ref
        .watch(financialStatementServiceProvider.notifier)
        .generateIncomeStatement(fromDate, toDate);

    final currencyFormatter = intl.NumberFormat.currency(
      symbol: '',
      decimalDigits: 2,
    );

    return Scaffold(
      appBar: AppAppBar(
        title: '${context.l10n.incomeStatementTitle} (IFRS 18)',
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _exportReport(context, ref),
            tooltip: context.l10n.actionShare,
          ),
        ],
      ),
      body: FutureBuilder<FinancialReport>(
        future: incomeStatementAsync,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: AppLoadingIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final report = snapshot.data;
          final lines = report?.lines ?? [];

          return ListView(
            padding: const EdgeInsets.all(Spacing.md),
            children: [
              const ComparativeAnalysisChart(
                title: 'Operating Performance (Current vs Prior)',
                labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
                currentData: [45000, 52000, 48000, 61000, 55000, 72000],
                priorData: [38000, 41000, 42000, 45000, 48000, 50000],
              ),
              const SizedBox(height: Spacing.lg),
              ...lines.map(
                (line) => _buildLineItem(
                  context,
                  line,
                  currencyFormatter,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLineItem(
    BuildContext context,
    FinancialReportLine line,
    intl.NumberFormat currencyFormatter,
  ) {
    if (line.isTitle) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
        child: Text(
          line.label,
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.only(
        left: line.indentLevel * Spacing.md,
        right: Spacing.sm,
        top: Spacing.xs,
        bottom: Spacing.xs,
      ),
      child: InkWell(
        onTap: line.accountId != null
            ? () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => JournalEntriesScreen(
                      accountId: line.accountId,
                    ),
                  ),
                );
              }
            : null,
        borderRadius: Radii.borderRadiusSm,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              line.label,
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: line.isTotal ? FontWeight.bold : FontWeight.normal,
                color: line.accountId != null ? AppColors.primary : null,
              ),
            ),
            Text(
              currencyFormatter.format(line.amount.toDouble()),
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.bold,
                color: line.amount >= Decimal.zero
                    ? AppColors.success
                    : AppColors.error,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Exports the income statement in statutory formats.
  Future<void> _exportReport(BuildContext context, WidgetRef ref) async {
    final now = DateTime.now();
    final fromDate = DateTime(now.year, now.month);
    final toDate = now;

    final report = await ref
        .read(financialStatementServiceProvider.notifier)
        .generateIncomeStatement(fromDate, toDate);

    if (context.mounted) {
      await showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (ctx) => GlassCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading:
                    const Icon(Icons.picture_as_pdf, color: AppColors.error),
                title: const Text('Export as Signed PDF'),
                subtitle: const Text('With cryptographic forensic seal'),
                onTap: () async {
                  Navigator.pop(ctx);
                  await _generateAndSharePdf(context, ref, report);
                },
              ),
              ListTile(
                leading:
                    const Icon(Icons.table_chart, color: AppColors.success),
                title: const Text('Export as Excel'),
                subtitle: const Text('With detailed audit trail metadata'),
                onTap: () async {
                  Navigator.pop(ctx);
                  await _generateAndShareExcel(context, ref, report);
                },
              ),
            ],
          ),
        ),
      );
    }
  }

  Future<void> _generateAndSharePdf(
    BuildContext context,
    WidgetRef ref,
    FinancialReport report,
  ) async {
    try {
      final exportService = ref.read(forensicExportServiceProvider);
      final data = _mapReportToExportData(report);
      final pdfBytes = await exportService.exportToPdf(data);

      await Printing.sharePdf(
        bytes: pdfBytes,
        filename:
            'Income_Statement_${intl.DateFormat('yyyyMMdd').format(DateTime.now())}.pdf',
      );
    } on Exception catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export Failed: $e')),
        );
      }
    }
  }

  Future<void> _generateAndShareExcel(
    BuildContext context,
    WidgetRef ref,
    FinancialReport report,
  ) async {
    try {
      final exportService = ref.read(forensicExportServiceProvider);
      final data = _mapReportToExportData(report);
      final excelBytes = await exportService.exportToExcel(data);

      // Save to temporary file using dart:io
      final directory = await getTemporaryDirectory();
      final fileName =
          'Income_Statement_${intl.DateFormat('yyyyMMdd').format(DateTime.now())}.xlsx';
      final ioFile = File('${directory.path}/$fileName');
      await ioFile.writeAsBytes(excelBytes);

      // Share the file
      if (context.mounted) {
        final box = context.findRenderObject() as RenderBox?;
        // ignore: deprecated_member_use
        await Share.shareXFiles(
          [XFile(ioFile.path)],
          text: 'Income Statement (Forensic Export)',
          sharePositionOrigin:
              box != null ? box.localToGlobal(Offset.zero) & box.size : null,
        );
      }
    } on Exception catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export Failed: $e')),
        );
      }
    }
  }

  ReportData _mapReportToExportData(FinancialReport report) => ReportData(
        title: report.title,
        subtitle:
            'Period: ${intl.DateFormat.yMMMd().format(report.fromDate)} - ${intl.DateFormat.yMMMd().format(report.toDate)}',
        headers: ['Account / Line Item', 'Amount'],
        rows: report.lines
            .map(
              (line) => [
                '  ' * line.indentLevel + line.label,
                line.amount.toStringAsFixed(2),
              ],
            )
            .toList(),
        metadata: {
          'Report Type': 'Income Statement (IFRS 18)',
          'Currency': 'SAR',
        },
      );
}
