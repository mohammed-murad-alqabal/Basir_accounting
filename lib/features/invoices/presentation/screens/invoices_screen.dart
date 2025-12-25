import 'package:basser_app/core/assets/app_illustrations.dart';
import 'package:basser_app/core/theme/tokens/index.dart';
import 'package:basser_app/core/widgets/index.dart';
import 'package:basser_app/features/invoices/domain/entities/invoice.dart';
import 'package:basser_app/features/invoices/presentation/providers/invoice_provider.dart';
import 'package:basser_app/features/invoices/presentation/screens/invoice_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// شاشة قائمة الفواتير (Invoices Screen)
class InvoicesScreen extends ConsumerStatefulWidget {
  /// إنشاء شاشة الفواتير
  const InvoicesScreen({super.key});

  @override
  ConsumerState<InvoicesScreen> createState() => _InvoicesScreenState();
}

class _InvoicesScreenState extends ConsumerState<InvoicesScreen> {
  String _selectedFilter = 'الكل';

  @override
  Widget build(BuildContext context) {
    final invoicesAsync = ref.watch(filteredInvoicesProvider);
    final statsAsync = ref.watch(invoiceStatisticsProvider);

    return Scaffold(
      appBar: AppAppBar(
        title: 'الفواتير',
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _createNewInvoice,
            tooltip: 'إضافة فاتورة',
          ),
          IconButton(
            icon: const Icon(Icons.picture_as_pdf_outlined),
            onPressed: _exportInvoice,
            tooltip: 'تصدير الكل',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildStatsHeader(statsAsync),
          _buildFilterBar(),
          Expanded(
            child: invoicesAsync.when(
              data: _buildInvoicesList,
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stack) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(Spacing.xl),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const ErrorIllustration(size: 80),
                      const SizedBox(height: Spacing.lg),
                      const Text(
                        'حدث خطأ أثناء تحميل الفواتير',
                        style: TextStyle(
                          fontSize: FontSizes.bodyLarge,
                          color: SemanticColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: Spacing.xl),
                      AppEnhancedButton(
                        text: 'إعادة المحاولة',
                        onPressed: () {
                          ref.invalidate(invoicesProvider);
                        },
                        icon: Icons.refresh,
                        style: AppEnhancedButtonStyle.secondary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewInvoice,
        backgroundColor: SemanticColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildStatsHeader(AsyncValue<InvoiceStatistics> statsAsync) =>
      Container(
        padding: const EdgeInsets.all(Spacing.lg),
        color: SemanticColors.surface,
        child: statsAsync.when(
          data: (stats) => Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'الإجمالي',
                  '${stats.totalInvoices}',
                  SemanticColors.primary,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'المدفوعة',
                  '${stats.paidInvoices}',
                  SemanticColors.success,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'المتأخرة',
                  '${stats.overdueInvoices}',
                  SemanticColors.error,
                ),
              ),
            ],
          ),
          loading: () => const LinearProgressIndicator(),
          error: (_, __) => const SizedBox.shrink(),
        ),
      );

  Widget _buildStatItem(String label, String value, Color color) => Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: FontSizes.titleLarge,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: FontSizes.bodySmall,
              color: SemanticColors.textHint,
            ),
          ),
        ],
      );

  Widget _buildFilterBar() => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.lg,
          vertical: Spacing.sm,
        ),
        child: Row(
          children: [
            _buildFilterChip('الكل', 'الكل'),
            _buildFilterChip('مسودة', 'draft'),
            _buildFilterChip('مُصدرة', 'issued'),
            _buildFilterChip('مدفوعة', 'paid'),
            _buildFilterChip('مستحقة', 'overdue'),
          ],
        ),
      );

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;
    return Padding(
      padding: const EdgeInsets.only(left: Spacing.sm),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() => _selectedFilter = value);
          ref.read(invoiceFilterProvider.notifier).state = value;
        },
        backgroundColor: SemanticColors.surface,
        selectedColor: SemanticColors.primary.withValues(alpha: 0.2),
        labelStyle: TextStyle(
          color:
              isSelected ? SemanticColors.primary : SemanticColors.textPrimary,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildInvoicesList(List<Invoice> invoices) {
    if (invoices.isEmpty) {
      return const Center(
        child: EmptyStateIllustration(),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
      itemCount: invoices.length,
      itemBuilder: (context, index) {
        final invoice = invoices[index];
        final statusColor = _getStatusColor(invoice.status);
        final dateStr = invoice.issuedDate.toLocal().toString().split(' ')[0];
        return AppListCard(
          title: 'فاتورة ${invoice.id}',
          subtitle: '${invoice.customerName} - $dateStr',
          trailing: '${invoice.grandTotal.toStringAsFixed(2)} ر.س',
          leading: Container(
            padding: const EdgeInsets.all(Spacing.sm),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(Radii.sm),
            ),
            child: Icon(
              _getStatusIcon(invoice.status),
              color: statusColor,
              size: 20,
            ),
          ),
          onTap: () {
            // TODO(dev): فتح تفاصيل الفاتورة
          },
          onLongPress: () => _showInvoiceActions(invoice),
        );
      },
    );
  }

  // وظيفة تصدير الفاتورة
  Future<void> _exportInvoice() async {
    if (!mounted) return;
    // منطق التصدير...
  }

  Future<void> _createNewInvoice() async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute<void>(builder: (context) => const InvoiceFormScreen()),
    );
  }

  void _showInvoiceActions(Invoice invoice) {
    // عرض خيارات الفاتورة (حذف، تعديل، تكرار)
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'paid':
        return SemanticColors.success;
      case 'overdue':
        return SemanticColors.error;
      case 'issued':
        return SemanticColors.info;
      default:
        return SemanticColors.textHint;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'paid':
        return Icons.check_circle;
      case 'overdue':
        return Icons.error_outline;
      case 'issued':
        return Icons.send_outlined;
      default:
        return Icons.edit_outlined;
    }
  }
}
