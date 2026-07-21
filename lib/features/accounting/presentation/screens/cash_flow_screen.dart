import 'dart:typed_data';

import 'package:basir_accounting_system/core/extensions/context_extensions.dart';
import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/features/accounting/application/reporting_service.dart';
import 'package:basir_accounting_system/features/reports/application/report_export_service.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' as intl;

/// Screen presenting the Statement of Cash Flows (Direct Method).
///
/// Categorizes cash inflows and outflows into Operating, Investing,
/// and Financing activities to reveal the entity's actual liquidity
/// movements and cash-generating capacity.
class CashFlowScreen extends ConsumerWidget {
  /// Creates the cash flow statement screen.
  const CashFlowScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cashFlowAsync =
        ref.watch(reportingServiceProvider.notifier).getCashFlowStatement();

    return GlassScaffold(
      title: context.l10n.cashFlowTitle,
      actions: [
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: () => _showExportOptions(context, ref),
          tooltip: context.l10n.btnExport,
        ),
      ],
      body: FutureBuilder<Map<String, Decimal>>(
        future: cashFlowAsync,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: AppLoadingIndicator());
          }
          if (snapshot.hasError) {
            return AppErrorWidget(
              message: snapshot.error.toString(),
              onRetry: () => ref.invalidate(reportingServiceProvider),
            );
          }

          final data = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(Spacing.md),
            children: [
              _buildSection(context.l10n.labelOperating, [
                _buildRow('Operating Receipts', data['operatingReceipts']!),
                _buildRow('Operating Payments', -data['operatingPayments']!),
                _buildTotalRow(
                  'Net Cash from Operating Activities',
                  data['netOperating']!,
                ),
              ]),
              const SizedBox(height: Spacing.lg),
              _buildSection(context.l10n.labelInvesting, [
                _buildTotalRow(
                  'Net Cash from Investing Activities',
                  data['investing']!,
                ),
              ]),
              const SizedBox(height: Spacing.lg),
              _buildSection(context.l10n.labelFinancing, [
                _buildTotalRow(
                  'Net Cash from Financing Activities',
                  data['financing']!,
                ),
              ]),
              const Divider(height: Spacing.xl),
              _buildTotalRow(
                context.l10n.labelNetCashFlow,
                data['netChange']!,
                isMain: true,
              ),
            ],
          );
        },
      ),
    );
  }

  /// Displays the modal for choosing the export format (PDF/CSV).
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

  /// Triggers the actual statutory export generation and sharing workflow.
  Future<void> _exportReport(
    BuildContext context,
    WidgetRef ref, {
    required bool asPdf,
  }) async {
    try {
      final dataMap = await ref
          .read(reportingServiceProvider.notifier)
          .getCashFlowStatement();
      if (!context.mounted) return;

      final exportService = ref.read(reportExportServiceProvider.notifier);

      final headers = [context.l10n.labelAccount, context.l10n.labelTotal];
      final data = [
        [context.l10n.labelOperating, dataMap['netOperating'].toString()],
        [context.l10n.labelInvesting, dataMap['investing'].toString()],
        [context.l10n.labelFinancing, dataMap['financing'].toString()],
        [context.l10n.labelNetCashFlow, dataMap['netChange'].toString()],
      ];

      if (asPdf) {
        await exportService.shareTablePdf(
          title: context.l10n.cashFlowTitle,
          headers: headers,
          data: data,
          subtitle: intl.DateFormat('yyyy-MM-dd').format(DateTime.now()),
        );
      } else {
        final csv = exportService.generateTableCsv(
          headers: headers,
          data: data,
        );
        final sharingService = ref.read(sharingServiceProvider);
        await sharingService.shareFile(
          bytes: Uint8List.fromList(csv.codeUnits),
          fileName: 'Cash_Flow.csv',
          subject: context.l10n.cashFlowTitle,
        );
      }
    } on Exception catch (_) {
      if (!context.mounted) return;
      AppSnackbar.showError(context, context.l10n.errorExportingReport);
    }
  }

  /// Renders a thematic section for a specific cash flow activity category.
  Widget _buildSection(String title, List<Widget> children) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: Spacing.sm),
          AppCard(
            padding: const EdgeInsets.all(Spacing.md),
            child: Column(children: children),
          ),
        ],
      );

  Widget _buildRow(String label, Decimal value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text(
              '$value',
              style: TextStyle(
                color: value < Decimal.zero ? AppColors.error : null,
              ),
            ),
          ],
        ),
      );

  Widget _buildTotalRow(String label, Decimal value, {bool isMain = false}) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: isMain ? 18 : null,
              ),
            ),
            Text(
              '$value',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: isMain ? 18 : null,
                color:
                    value < Decimal.zero ? AppColors.error : AppColors.success,
              ),
            ),
          ],
        ),
      );
}
