import 'package:basser_app/core/theme/services/icon_customization_service.dart';
import 'package:basser_app/core/theme/tokens/index.dart';
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
  Widget build(BuildContext context, WidgetRef ref) {
    final appIcons = ref.watch(appIconsProvider);

    return Scaffold(
      backgroundColor: SemanticColors.background,
      appBar: AppAppBar(
        title: 'تفاصيل العميل',
        actions: [
          IconButton(
            icon: Icon(appIcons.edit),
            tooltip: 'تعديل العميل',
            onPressed: () => _editCustomer(context),
          ),
          IconButton(
            icon: Icon(appIcons.delete, color: SemanticColors.error),
            tooltip: 'حذف العميل',
            onPressed: () => _deleteCustomer(context, ref),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // صورة العميل
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: SemanticColors.primary.withValues(alpha: 0.2),
                child: Text(
                  customer.name.isNotEmpty ? customer.name[0] : '؟',
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: SemanticColors.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: Spacing.lg),

            // اسم العميل
            Center(
              child: Text(
                customer.name,
                style: const TextStyle(
                  fontSize: FontSizes.titleLarge,
                  fontWeight: FontWeight.bold,
                  color: SemanticColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: Spacing.xl),

            // معلومات الاتصال
            _buildSectionTitle('معلومات الاتصال'),
            const SizedBox(height: Spacing.md),
            if (customer.email != null) ...[
              _buildInfoCard(
                icon: appIcons.email,
                label: 'البريد الإلكتروني',
                value: customer.email!,
              ),
              const SizedBox(height: Spacing.sm),
            ],
            if (customer.phone != null) ...[
              _buildInfoCard(
                icon: appIcons.phone,
                label: 'رقم الهاتف',
                value: customer.phone!,
              ),
              const SizedBox(height: Spacing.sm),
            ],
            if (customer.address != null) ...[
              _buildInfoCard(
                icon: appIcons.location,
                label: 'العنوان',
                value: customer.address!,
              ),
              const SizedBox(height: Spacing.sm),
            ],

            // ملاحظات
            if (customer.notes != null) ...[
              const SizedBox(height: Spacing.lg),
              _buildSectionTitle('ملاحظات'),
              const SizedBox(height: Spacing.md),
              AppCard(
                child: Padding(
                  padding: const EdgeInsets.all(Spacing.md),
                  child: Text(
                    customer.notes!,
                    style: const TextStyle(
                      fontSize: FontSizes.bodyMedium,
                      color: SemanticColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ],

            // معلومات إضافية
            const SizedBox(height: Spacing.lg),
            _buildSectionTitle('معلومات إضافية'),
            const SizedBox(height: Spacing.md),
            _buildInfoCard(
              icon: appIcons.calendar,
              label: 'تاريخ الإضافة',
              value: _formatDate(customer.createdAt),
            ),
            const SizedBox(height: Spacing.sm),
            _buildInfoCard(
              icon: appIcons.update,
              label: 'آخر تحديث',
              value: _formatDate(customer.updatedAt),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) => Text(
        title,
        style: const TextStyle(
          fontSize: FontSizes.titleMedium,
          fontWeight: FontWeight.w600,
          color: SemanticColors.textPrimary,
        ),
      );

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
  }) =>
      AppCard(
        child: Padding(
          padding: const EdgeInsets.all(Spacing.md),
          child: Row(
            children: [
              Icon(icon, color: SemanticColors.primary, size: 24),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: FontSizes.bodySmall,
                        color: SemanticColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: FontSizes.bodyMedium,
                        color: SemanticColors.textPrimary,
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
      Navigator.pop(
        context,
        true,
      );
    }
  }

  Future<void> _deleteCustomer(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف العميل'),
        content: Text('هل أنت متأكد من حذف العميل ${customer.name}؟'),
        actions: [
          AppEnhancedButton(
            text: 'إلغاء',
            onPressed: () => Navigator.pop(context, false),
            style: AppEnhancedButtonStyle.text,
            size: AppEnhancedButtonSize.small,
          ),
          AppEnhancedButton(
            text: 'حذف',
            onPressed: () => Navigator.pop(context, true),
            style: AppEnhancedButtonStyle.text,
            size: AppEnhancedButtonSize.small,
            // TODO(enhancement): Add error color support to AppEnhancedButton
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    try {
      final result = await ref.read(
        deleteCustomerProvider(customer.id).future,
      );

      if (!context.mounted) return;

      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم حذف العميل بنجاح'),
            backgroundColor: SemanticColors.secondary,
          ),
        );
        Navigator.pop(
          context,
          true,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('فشل حذف العميل'),
            backgroundColor: SemanticColors.error,
          ),
        );
      }
    } on Exception catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('حدث خطأ: $e'),
          backgroundColor: SemanticColors.error,
        ),
      );
    }
  }
}
