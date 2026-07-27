import 'package:basir_accounting_system/features/accounting/application/tax_engine_service.dart';
import 'package:basir_accounting_system/features/reports/application/report_pdf_service.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

/// شاشة تقرير الضريبة الذكي (Smart Tax Report)
class SmartTaxReportScreen extends ConsumerWidget {
  /// Standard constructor for the smart tax report screen.
  const SmartTaxReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Assuming we can access the notifier to call the method.
    // In a real app, this should probably be a separate provider or cached.
    final vatReturnFuture =
        ref.read(taxEngineServiceProvider.notifier).calculateVatReturn();

    return GlassScaffold(
      title: 'تقرير الضريبة الذكي (Smart VAT Return)',
      body: FutureBuilder<VatReturnStatement>(
        future: vatReturnFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final returnData = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, returnData),
                const SizedBox(height: 24),
                _buildSummaryCard(context, returnData),
                const SizedBox(height: 24),
                _buildSectionTitle(context, 'المبيعات (Output Tax)'),
                const SizedBox(height: 8),
                _buildDetailTable(context, [
                  _RowData(
                    'المبيعات الخاضعة للنسبة الأساسية',
                    returnData.standardSalesBase,
                    returnData.standardSalesTax,
                  ),
                  _RowData(
                    'المبيعات الصفرية',
                    returnData.zeroRatedSales,
                    Decimal.zero,
                  ),
                  _RowData(
                    'المبيعات المعفاة',
                    returnData.exemptSales,
                    Decimal.zero,
                  ),
                ]),
                const SizedBox(height: 24),
                _buildSectionTitle(context, 'المشتريات (Input Tax)'),
                const SizedBox(height: 8),
                _buildDetailTable(context, [
                  _RowData(
                    'المشتريات الخاضعة للنسبة الأساسية',
                    returnData.standardPurchasesBase,
                    returnData.standardPurchasesTax,
                  ),
                ]),
                const SizedBox(height: 32),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      try {
                        await ref
                            .read(reportPdfServiceProvider.notifier)
                            .shareVatReturnPdf(returnData);
                      } on Exception catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error exporting PDF: $e')),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text('تصدير التقرير (PDF Export)'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, VatReturnStatement data) {
    final dateFormat = DateFormat('yyyy-MM-dd');
    return Card(
      child: ListTile(
        leading: const Icon(Icons.calendar_today, size: 32),
        title: const Text('الفترة الضريبية'),
        subtitle: Text(
          '${dateFormat.format(data.periodStart)}  إلى  '
          '${dateFormat.format(data.periodEnd)}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    VatReturnStatement data,
  ) =>
      Card(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Text('صافي الضريبة المستحقة'),
              const SizedBox(height: 8),
              Text(
                '${data.netVatDue.toStringAsFixed(2)} SAR',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
              ),
            ],
          ),
        ),
      );

  Widget _buildSectionTitle(BuildContext context, String title) => Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      );

  Widget _buildDetailTable(BuildContext context, List<_RowData> rows) => Table(
        border: TableBorder.all(
          color: Theme.of(context).dividerColor,
          borderRadius: BorderRadius.circular(8),
        ),
        columnWidths: const {
          0: FlexColumnWidth(3),
          1: FlexColumnWidth(2),
          2: FlexColumnWidth(2),
        },
        children: [
          TableRow(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
            children: const [
              Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  'الوصف',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  'المبلغ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  'الضريبة',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          ...rows.map(
            (row) => TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(row.description),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(row.baseAmount.toStringAsFixed(2)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(row.taxAmount.toStringAsFixed(2)),
                ),
              ],
            ),
          ),
        ],
      );
}

class _RowData {
  const _RowData(this.description, this.baseAmount, this.taxAmount);
  final String description;
  final Decimal baseAmount;
  final Decimal taxAmount;
}
