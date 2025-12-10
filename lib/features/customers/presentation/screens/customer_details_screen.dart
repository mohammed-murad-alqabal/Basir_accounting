import 'package:basser_app/core/theme.dart';
import 'package:basser_app/core/widgets/index.dart';
import 'package:basser_app/features/customers/domain/entities/customer.dart';
import 'package:basser_app/features/customers/presentation/providers/customer_provider.dart';
import 'package:basser_app/features/customers/presentation/screens/customer_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// شاشة تفاصيل العميل
///
/// تعرض جميع معلومات العميل مع خيارات التعديل والحذف.
class CustomerDetailsScreen extends ConsumerWidget {
  /// إنشاء شاشة تفاصيل العميل
  const CustomerDetailsScreen({required this.customer, super.key});

  /// العميل المراد عرض تفاصيله
  final Customer customer;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppAppBar(
          title: 'تفاصيل العميل',
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: 'تعديل العميل',
              onPressed: () => _editCustomer(context),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: AppColors.error),
              tooltip: 'حذف العميل',
              onPressed: () => _deleteCustomer(context, ref),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // صورة العميل
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                  child: Text(
                    customer.name.isNotEmpty ? customer.name[0] : '؟',
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // اسم العميل
              Center(
                child: Text(
                  customer.name,
                  style: const TextStyle(
                    fontSize: AppTypography.titleLarge,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // معلومات الاتصال
              _buildSectionTitle('معلومات الاتصال'),
              const SizedBox(height: AppSpacing.md),
              if (customer.email != null) ...[
                _buildInfoCard(
                  icon: Icons.email,
                  label: 'البريد الإلكتروني',
                  value: customer.email!,
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
              if (customer.phone != null) ...[
                _buildInfoCard(
                  icon: Icons.phone,
                  label: 'رقم الهاتف',
                  value: customer.phone!,
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
              if (customer.address != null) ...[
                _buildInfoCard(
                  icon: Icons.location_on,
                  label: 'العنوان',
                  value: customer.address!,
                ),
                const SizedBox(height: AppSpacing.sm),
              ],

              // ملاحظات
              if (customer.notes != null) ...[
                const SizedBox(height: AppSpacing.lg),
                _buildSectionTitle('ملاحظات'),
                const SizedBox(height: AppSpacing.md),
                AppCard(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Text(
                      customer.notes!,
                      style: const TextStyle(
                        fontSize: AppTypography.bodyMedium,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ],

              // معلومات إضافية
              const SizedBox(height: AppSpacing.lg),
              _buildSectionTitle('معلومات إضافية'),
              const SizedBox(height: AppSpacing.md),
              _buildInfoCard(
                icon: Icons.calendar_today,
                label: 'تاريخ الإضافة',
                value: _formatDate(customer.createdAt),
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildInfoCard(
                icon: Icons.update,
                label: 'آخر تحديث',
                value: _formatDate(customer.updatedAt),
              ),
            ],
          ),
        ),
      );

  Widget _buildSectionTitle(String title) => Text(
        title,
        style: const TextStyle(
          fontSize: AppTypography.titleMedium,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      );

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
  }) =>
      AppCard(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 24),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: AppTypography.bodySmall,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: AppTypography.bodyMedium,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';

  Future<void> _editCustomer(BuildContext context) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => CustomerFormScreen(customer: customer),
      ),
    );

    if (!context.mounted) return;
    if (result ?? false) {
      Navigator.pop(context, true);
    }
  }

  Future<void> _deleteCustomer(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف العميل'),
        content: Text('هل أنت متأكد من حذف العميل "${customer.name}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('حذف'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    try {
      final result = await ref.read(deleteCustomerProvider(customer.id).future);

      if (!context.mounted) return;

      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم حذف العميل بنجاح'),
            backgroundColor: AppColors.secondary,
          ),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('فشل حذف العميل'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } on Exception catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('حدث خطأ: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}
