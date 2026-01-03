import 'dart:typed_data';

import 'package:basir_app/core/extensions/context_extensions.dart';
import 'package:basir_app/core/providers.dart';
import 'package:basir_app/features/accounting/application/accounts_payable_service.dart';
import 'package:basir_app/features/accounting/application/accounts_receivable_service.dart';
import 'package:basir_app/features/reports/application/report_export_service.dart';
import 'package:basir_app/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// شاشة تقارير تعمير الديون (Aging Reports Screen)
class AgingReportsScreen extends ConsumerWidget {
  /// Creates the aging reports screen.
  const AgingReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppAppBar(
            title: context.l10n.agingReportsTitle,
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
          body: const TabBarView(
            children: [
              _ReceivableAgingTab(),
              _PayableAgingTab(),
            ],
          ),
        ),
      );

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
          r.customerName,
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
          p.supplierName,
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
        final csv =
            exportService.generateTableCsv(headers: headers, data: data);
        final sharingService = ref.read(sharingServiceProvider);
        await sharingService.shareFile(
          bytes: Uint8List.fromList(csv.codeUnits),
          fileName: 'Aging_Report.csv',
          subject: context.l10n.agingReportsTitle,
        );
      }
    } on Exception catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}

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
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final reports = snapshot.data!;
        if (reports.isEmpty) {
          return Center(child: Text(context.l10n.noDataMessage));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: reports.length,
          itemBuilder: (context, index) {
            final report = reports[index];
            return AppCard(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    report.customerName,
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

  Widget _buildAgingRow(String label, dynamic value, {bool isTotal = false}) =>
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
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final reports = snapshot.data!;
        if (reports.isEmpty) {
          return Center(child: Text(context.l10n.noDataMessage));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: reports.length,
          itemBuilder: (context, index) {
            final report = reports[index];
            return AppCard(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    report.supplierName,
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

  Widget _buildAgingRow(String label, dynamic value, {bool isTotal = false}) =>
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
