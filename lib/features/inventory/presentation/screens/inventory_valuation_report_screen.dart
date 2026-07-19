import 'package:basir_accounting_system/core/extensions/context_extensions.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:basir_accounting_system/src/rust/api/inventory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// شاشة تقرير تقييم المخزون (Inventory Valuation Report Screen)
///
/// تعرض قائمة بالأصناف في المخزون مع كمياتها وقيمتها الإجمالية.
class InventoryValuationReportScreen extends ConsumerStatefulWidget {
  /// إنشاء شاشة تقرير تقييم المخزون
  const InventoryValuationReportScreen({super.key});

  @override
  ConsumerState<InventoryValuationReportScreen> createState() =>
      _InventoryValuationReportScreenState();
}

class _InventoryValuationReportScreenState
    extends ConsumerState<InventoryValuationReportScreen> {
  Future<InventoryValuationReportDto>? _reportFuture;

  @override
  void initState() {
    super.initState();
    _refreshReport();
  }

  void _refreshReport() {
    setState(() {
      _reportFuture = getValuationReport(
        asOf: DateTime.now().toIso8601String(),
      );
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppAppBar(
          title: 'تقرير تقييم المخزون',
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _refreshReport,
            ),
          ],
        ),
        body: FutureBuilder<InventoryValuationReportDto>(
          future: _reportFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text('خطأ في تحميل التقرير: ${snapshot.error}'),
              );
            }

            final report = snapshot.data;
            if (report == null || report.items.isEmpty) {
              return const Center(child: Text('لا توجد بيانات محزنة حالياً'));
            }

            return Column(
              children: [
                _buildSummaryCard(report),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(Spacing.md),
                    itemCount: report.items.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final item = report.items[index];
                      return _buildReportItem(item);
                    },
                  ),
                ),
              ],
            );
          },
        ),
      );

  Widget _buildSummaryCard(InventoryValuationReportDto report) => Container(
        padding: const EdgeInsets.all(Spacing.lg),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'إجمالي قيمة المخزون:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              '${report.totalValue} SAR',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      );

  Widget _buildReportItem(ValuationItemDto item) => Padding(
        padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.isArabic ? item.itemNameAr : item.itemNameEn,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '${item.totalValue} SAR',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: Spacing.xs),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'الكمية: ${item.quantity}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                Text(
                  'تكلفة الوحدة: ${item.unitCost}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      );
}
