import 'package:basser_app/core/providers.dart';
import 'package:basser_app/core/theme.dart';
import 'package:basser_app/core/widgets/index.dart';
import 'package:basser_app/features/invoices/domain/entities/invoice.dart';
import 'package:basser_app/features/invoices/presentation/providers/invoice_provider.dart';
import 'package:basser_app/features/invoices/presentation/screens/invoice_form_screen.dart';
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
            icon: const Icon(Icons.picture_as_pdf, size: 26),
            tooltip: 'تصدير PDF',
            onPressed: _exportInvoice,
          ),
          IconButton(
            icon: const Icon(Icons.add, size: 26),
            tooltip: 'إضافة فاتورة جديدة',
            onPressed: _addInvoice,
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
                  onChanged: (value) {
                    ref.read(invoiceSearchProvider.notifier).state = value;
                  },
                  onClear: () {
                    _searchController.clear();
                    ref.read(invoiceSearchProvider.notifier).state = '';
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                // فلاتر الحالة
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('الكل', 'الكل'),
                      _buildFilterChip('مدفوعة', 'paid'),
                      _buildFilterChip('مرسلة', 'issued'),
                      _buildFilterChip('متأخرة', 'overdue'),
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
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 80,
                        color: AppColors.error,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      const Text(
                        'خطأ في تحميل الفواتير',
                        style: TextStyle(
                          fontSize: AppTypography.headlineSmall,
                          fontWeight: FontWeight.bold,
                          color: AppColors.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      const Text(
                        'يرجى التحقق من الاتصال والمحاولة مرة أخرى',
                        style: TextStyle(
                          fontSize: AppTypography.bodyLarge,
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      AppPrimaryButton(
                        label: 'إعادة المحاولة',
                        onPressed: () {
                          ref.invalidate(invoicesProvider);
                        },
                        width: 200,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;
    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.sm),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() => _selectedFilter = value);
          ref.read(invoiceFilterProvider.notifier).state = value;
        },
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.primary.withValues(alpha: 0.2),
        labelStyle: TextStyle(
          color: isSelected ? AppColors.primary : AppColors.textSecondary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          fontSize: AppTypography.bodyMedium,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
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
              size: 80,
              color: AppColors.textSecondary.withValues(alpha: 0.3),
            ),
            const SizedBox(height: AppSpacing.lg),
            const Text(
              'لا توجد فواتير',
              style: TextStyle(
                fontSize: AppTypography.bodyLarge,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            const Text(
              'اضغط على + لإضافة فاتورة جديدة',
              style: TextStyle(
                fontSize: AppTypography.bodyMedium,
                color: AppColors.textHint,
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
              _editInvoice(invoice);
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
              _deleteInvoice(invoice);
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

  Future<void> _addInvoice() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => const InvoiceFormScreen(),
      ),
    );

    if (result ?? false) {
      ref.invalidate(invoicesProvider);
    }
  }

  Future<void> _editInvoice(Invoice invoice) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => InvoiceFormScreen(invoice: invoice),
      ),
    );

    if (result ?? false) {
      ref.invalidate(invoicesProvider);
    }
  }

  Future<void> _deleteInvoice(Invoice invoice) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف الفاتورة'),
        content: Text('هل أنت متأكد من حذف الفاتورة "${invoice.id}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: const Text('حذف'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
      final result = await ref.read(deleteInvoiceProvider(invoice.id).future);

      if (!mounted) return;

      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم حذف الفاتورة بنجاح'),
            backgroundColor: AppColors.secondary,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('فشل حذف الفاتورة'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } on Exception catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('حدث خطأ: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}
