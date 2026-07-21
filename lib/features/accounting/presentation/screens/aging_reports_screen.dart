// ignore_for_file: lines_longer_than_80_chars
import 'dart:typed_data';
import 'dart:ui';

import 'package:basir_accounting_system/core/extensions/context_extensions.dart';
import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/features/accounting/application/accounts_payable_service.dart';
import 'package:basir_accounting_system/features/accounting/application/accounts_receivable_service.dart';
import 'package:basir_accounting_system/features/reports/application/report_export_service.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Screen for analyzing the age of outstanding debts and liabilities.
///
/// Categorizes Accounts Receivable and Accounts Payable into time buckets
/// (e.g., 1-30 days, 31-60 days) to assess credit risk and liquidity.
class AgingReportsScreen extends ConsumerWidget {
  /// Creates the aging reports screen.
  const AgingReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => DefaultTabController(
        length: 2,
        child: Scaffold(
          extendBodyBehindAppBar: true,
          extendBody: true,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(
              context.l10n.agingReportsTitle,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            elevation: 0,
            flexibleSpace: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
            ),
            bottom: TabBar(
              tabs: [
                Tab(text: context.l10n.receivablesAgingLabel),
                Tab(text: context.l10n.payablesAgingLabel),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () => _showExportOptions(context, ref),
                tooltip: context.l10n.btnExport,
              ),
            ],
          ),
          body: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(-0.8, -0.8),
                    radius: 1.5,
                    colors: [
                      Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.15),
                      Theme.of(context).scaffoldBackgroundColor,
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0.8, 0.8),
                    radius: 1.5,
                    colors: [
                      Theme.of(context)
                          .colorScheme
                          .secondary
                          .withValues(alpha: 0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              const SafeArea(
                bottom: false,
                child: TabBarView(
                  children: [_ReceivableAgingTab(), _PayableAgingTab()],
                ),
              ),
            ],
          ),
        ),
      );

  /// Displays a modal with data export format options (PDF, CSV).
  Future<void> _showExportOptions(BuildContext context, WidgetRef ref) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.picture_as_pdf),
              title: Text(context.l10n.labelExportPdf),
              onTap: () async {
                Navigator.pop(context);
                await _exportReport(context, ref, asPdf: true);
              },
            ),
            ListTile(
              leading: const Icon(Icons.table_chart),
              title: Text(context.l10n.labelExportCsv),
              onTap: () async {
                Navigator.pop(context);
                await _exportReport(context, ref, asPdf: false);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Triggers the actual export generation and sharing workflow.
  Future<void> _exportReport(
    BuildContext context,
    WidgetRef ref, {
    required bool asPdf,
  }) async {
    try {
      final exportService = ref.read(reportExportServiceProvider.notifier);
      final receivables = await ref
          .read(accountsReceivableServiceProvider.notifier)
          .getReceivablesAging();
      final payables = await ref
          .read(accountsPayableServiceProvider.notifier)
          .getPayablesAging();
      if (!context.mounted) return;

      final headers = [
        context.l10n.labelAccount,
        context.l10n.periodCurrent,
        '1-30',
        '31-60',
        '61-90',
        '>90',
        context.l10n.labelTotal,
      ];

      final data = <List<String>>[];
      data.add(['--- RECEIVABLES ---', '', '', '', '', '', '']);
      for (final r in receivables) {
        data.add([
          r.name(isArabic: context.isArabic),
          r.current.toString(),
          r.period1_30.toString(),
          r.period31_60.toString(),
          r.period61_90.toString(),
          r.periodOver90.toString(),
          r.totalBalance.toString(),
        ]);
      }
      data.add(['', '', '', '', '', '', '']);
      data.add(['--- PAYABLES ---', '', '', '', '', '', '']);
      for (final p in payables) {
        data.add([
          p.name(isArabic: context.isArabic),
          p.current.toString(),
          p.period1_30.toString(),
          p.period31_60.toString(),
          '0',
          p.periodOver90.toString(),
          p.totalBalance.toString(),
        ]);
      }

      if (asPdf) {
        await exportService.shareTablePdf(
          title: context.l10n.agingReportsTitle,
          headers: headers,
          data: data,
        );
      } else {
        final csv = exportService.generateTableCsv(
          headers: headers,
          data: data,
        );
        final sharingService = ref.read(sharingServiceProvider);
        await sharingService.shareFile(
          bytes: Uint8List.fromList(csv.codeUnits),
          fileName: 'Aging_Report.csv',
          subject: context.l10n.agingReportsTitle,
        );
      }
    } on Exception catch (_) {
      if (!context.mounted) return;
      AppSnackbar.showError(context, context.l10n.errorExportingReport);
    }
  }
}

/// Tab view for Accounts Receivable (AR) aging analysis.
class _ReceivableAgingTab extends ConsumerWidget {
  const _ReceivableAgingTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final agingAsync = ref
        .watch(accountsReceivableServiceProvider.notifier)
        .getReceivablesAging();

    return FutureBuilder<List<CustomerAging>>(
      future: agingAsync,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: AppLoadingIndicator());
        }
        if (snapshot.hasError) {
          return AppErrorWidget(
            message: snapshot.error.toString(),
            onRetry: () => ref.invalidate(accountsReceivableServiceProvider),
          );
        }

        final reports = snapshot.data!;
        if (reports.isEmpty) {
          return AppEmptyState(
            icon: Icons.description_outlined,
            title: context.l10n.noDataMessage,
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(Spacing.md),
          itemCount: reports.length,
          itemBuilder: (context, index) {
            final report = reports[index];
            return AppCard(
              margin: const EdgeInsets.only(bottom: Spacing.sm),
              padding: const EdgeInsets.all(Spacing.md),
              onTap: () => Navigator.pushNamed(
                context,
                '/entity-transactions',
                arguments: {
                  'entityId': report.customerId,
                  'entityName': report.name(isArabic: context.isArabic),
                  'isCustomer': true,
                },
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    report.name(isArabic: context.isArabic),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const Divider(),
                  _buildAgingRow(context.l10n.periodCurrent, report.current),
                  _buildAgingRow(context.l10n.period1_30, report.period1_30),
                  _buildAgingRow(context.l10n.period31_60, report.period31_60),
                  _buildAgingRow(context.l10n.period61_90, report.period61_90),
                  _buildAgingRow(
                    context.l10n.periodOver90,
                    report.periodOver90,
                  ),
                  const Divider(),
                  _buildAgingRow(
                    context.l10n.labelTotal,
                    report.totalBalance,
                    isTotal: true,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  /// Builds a horizontal key-value row for an aging period.
  Widget _buildAgingRow(
    String label,
    dynamic value, {
    bool isTotal = false,
  }) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style:
                  isTotal ? const TextStyle(fontWeight: FontWeight.bold) : null,
            ),
            Text(
              '$value ر.س',
              style:
                  isTotal ? const TextStyle(fontWeight: FontWeight.bold) : null,
            ),
          ],
        ),
      );
}

/// Tab view for Accounts Payable (AP) aging analysis.
class _PayableAgingTab extends ConsumerWidget {
  const _PayableAgingTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final agingAsync =
        ref.watch(accountsPayableServiceProvider.notifier).getPayablesAging();

    return FutureBuilder<List<SupplierAging>>(
      future: agingAsync,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: AppLoadingIndicator());
        }
        if (snapshot.hasError) {
          return AppErrorWidget(
            message: snapshot.error.toString(),
            onRetry: () => ref.invalidate(accountsPayableServiceProvider),
          );
        }

        final reports = snapshot.data!;
        if (reports.isEmpty) {
          return AppEmptyState(
            icon: Icons.description_outlined,
            title: context.l10n.noDataMessage,
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(Spacing.md),
          itemCount: reports.length,
          itemBuilder: (context, index) {
            final report = reports[index];
            return AppCard(
              margin: const EdgeInsets.only(bottom: Spacing.sm),
              padding: const EdgeInsets.all(Spacing.md),
              onTap: () => Navigator.pushNamed(
                context,
                '/entity-transactions',
                arguments: {
                  'entityId': report.supplierId,
                  'entityName': report.name(isArabic: context.isArabic),
                  'isCustomer': false,
                },
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    report.name(isArabic: context.isArabic),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const Divider(),
                  _buildAgingRow(context.l10n.periodCurrent, report.current),
                  _buildAgingRow(context.l10n.period1_30, report.period1_30),
                  _buildAgingRow(context.l10n.period31_60, report.period31_60),
                  _buildAgingRow(
                    context.l10n.periodOver90,
                    report.periodOver90,
                  ),
                  const Divider(),
                  _buildAgingRow(
                    context.l10n.labelTotal,
                    report.totalBalance,
                    isTotal: true,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  /// Builds a horizontal key-value row for an aging period.
  Widget _buildAgingRow(
    String label,
    dynamic value, {
    bool isTotal = false,
  }) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style:
                  isTotal ? const TextStyle(fontWeight: FontWeight.bold) : null,
            ),
            Text(
              '$value ر.س',
              style:
                  isTotal ? const TextStyle(fontWeight: FontWeight.bold) : null,
            ),
          ],
        ),
      );
}
