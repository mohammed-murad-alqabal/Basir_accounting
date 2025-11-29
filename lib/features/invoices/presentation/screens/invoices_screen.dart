import 'package:basser_app/core/providers.dart';
import 'package:basser_app/core/theme.dart';
import 'package:basser_app/core/widgets/index.dart';
import 'package:basser_app/features/invoices/domain/entities/invoice.dart';
import 'package:basser_app/features/invoices/presentation/providers/invoice_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// شاشة إدارة الفواتير (Invoices Screen)
///
/// تعرض قائمة الفواتير وتسمح بإضافة وتعديل وحذف الفواتير
class InvoicesScreen extends ConsumerStatefulWidget {
  /// إنشاء شاشة الفواتير
  const InvoicesScreen({super.key});

  @override
  ConsumerState<InvoicesScreen> createState() => _InvoicesScreenState();
}

class _InvoicesScreenState extends ConsumerState<InvoicesScreen> {
  final _searchController = TextEditingController();
  String _selectedFilter = 'الكل';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final invoicesAsync = ref.watch(filteredInvoicesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(
        title: 'الفواتير',
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: _exportInvoice,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO(dev): فتح شاشة إضافة فاتورة جديدة
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // حقل البحث والفلاتر
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSearchField(
                  controller: _searchController,
                  hint: 'ابحث عن فاتورة...',
                  onClear: _searchController.clear,
                ),
                const SizedBox(height: AppSpacing.md),
                // فلاتر الحالة
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('الكل'),
                      _buildFilterChip('paid'),
                      _buildFilterChip('issued'),
                      _buildFilterChip('overdue'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // قائمة الفواتير
          Expanded(
            child: invoicesAsync.when(
              data: _buildInvoicesList,
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stack) => Center(
                child: Text('خطأ في تحميل الفواتير: $error'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() => _selectedFilter = label);
          ref.read(invoiceFilterProvider.notifier).state = label;
        },
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.primary.withValues(alpha: 0.2),
        labelStyle: TextStyle(
          color: isSelected ? AppColors.primary : AppColors.textSecondary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildInvoicesList(List<Invoice> invoices) {
    if (invoices.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long,
              size: 64,
              color: AppColors.textSecondary.withValues(alpha: 0.3),
            ),
            const SizedBox(height: AppSpacing.lg),
            const Text(
              'لا توجد فواتير',
              style: TextStyle(
                fontSize: AppTypography.bodyLarge,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
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
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppBorderRadius.sm),
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

    final invoicesAsync = ref.read(filteredInvoicesProvider);
    final pdfService = ref.read(pdfServiceProvider);
    final customerRepo = ref.read(customerRepositoryProvider);

    invoicesAsync.whenData((invoices) async {
      if (!mounted) return;

      if (invoices.isNotEmpty) {
        final invoiceToExport = invoices.first;
        final customer =
            await customerRepo.getCustomerById(invoiceToExport.customerId);

        if (!mounted) return;

        if (customer != null) {
          try {
            await pdfService.printInvoice(invoiceToExport, customer);
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تم تصدير الفاتورة بنجاح.')),
            );
          } on Exception catch (e) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('خطأ في التصدير: $e')),
            );
          }
        } else {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('خطأ: لم يتم العثور على بيانات العميل.'),
            ),
          );
        }
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('لا توجد فواتير لتصديرها.')),
        );
      }
    });
  }

  // وظيفة عرض خيارات الفاتورة (حذف، تعديل، تصدير)
  Future<void> _showInvoiceActions(Invoice invoice) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('تعديل الفاتورة'),
            onTap: () {
              Navigator.pop(context);
              // TODO(dev): فتح شاشة تعديل الفاتورة
            },
          ),
          ListTile(
            leading: const Icon(Icons.picture_as_pdf),
            title: const Text('تصدير PDF'),
            onTap: () async {
              Navigator.pop(context);
              await _exportInvoice();
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: AppColors.error),
            title: const Text(
              'حذف الفاتورة',
              style: TextStyle(color: AppColors.error),
            ),
            onTap: () {
              Navigator.pop(context);
              // TODO(team): تفعيل وظيفة الحذف - Issue #005
            },
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'paid':
        return AppColors.secondary;
      case 'issued':
        return Colors.orange;
      case 'overdue':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'paid':
        return Icons.check_circle;
      case 'issued':
        return Icons.schedule;
      case 'overdue':
        return Icons.error;
      default:
        return Icons.help;
    }
  }
}
