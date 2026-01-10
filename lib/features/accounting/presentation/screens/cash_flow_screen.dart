import 'dart:typed_data';

import 'package:basir_app/core/extensions/context_extensions.dart';
import 'package:basir_app/core/providers.dart';
import 'package:basir_app/features/accounting/application/reporting_service.dart';
import 'package:basir_app/features/reports/application/report_export_service.dart';
import 'package:basir_app/shared/widgets/index.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' as intl;

/// شاشة قائمة التدفقات النقدية (Cash Flow Statement Screen)
/// تعرض التدفقات النقدية الداخلة والخارجة مقسمة حسب الأنشطة
/// (تشغيلية، استثمارية، تمويلية).
class CashFlowScreen extends ConsumerWidget {
  /// إنشاء شاشة قائمة التدفقات النقدية.
  const CashFlowScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cashFlowAsync =
        ref.watch(reportingServiceProvider.notifier).getCashFlowStatement();

    return Scaffold(
      appBar: AppAppBar(
        title: context.l10n.cashFlowTitle,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _showExportOptions(context, ref),
            tooltip: context.l10n.btnExport,
          ),
        ],
      ),
      body: FutureBuilder<Map<String, Decimal>>(
        future: cashFlowAsync,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final data = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildSection(context.l10n.labelOperating, [
                _buildRow('المقبوضات التشغيلية', data['operatingReceipts']!),
                _buildRow('المدفوعات التشغيلية', -data['operatingPayments']!),
                _buildTotalRow(
                  'صافي التدفقات من الأنشطة التشغيلية',
                  data['netOperating']!,
                ),
              ]),
              const SizedBox(height: 24),
              _buildSection(context.l10n.labelInvesting, [
                _buildTotalRow(
                  'صافي التدفقات من الأنشطة الاستثمارية',
                  data['investing']!,
                ),
              ]),
              const SizedBox(height: 24),
              _buildSection(context.l10n.labelFinancing, [
                _buildTotalRow(
                  'صافي التدفقات من الأنشطة التمويلية',
                  data['financing']!,
                ),
              ]),
              const Divider(height: 48),
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
    } on Exception catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Widget _buildSection(String title, List<Widget> children) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          AppCard(
            padding: const EdgeInsets.all(12),
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
              style: TextStyle(color: value < Decimal.zero ? Colors.red : null),
            ),
          ],
        ),
      );

  Widget _buildTotalRow(String label, Decimal value, {bool isMain = false}) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
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
                color: value < Decimal.zero ? Colors.red : Colors.green,
              ),
            ),
          ],
        ),
      );
}
