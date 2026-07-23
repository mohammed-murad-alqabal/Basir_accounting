import 'package:basir_accounting_system/core/extensions/context_extensions.dart';
import 'package:basir_accounting_system/core/theme/services/icon_customization_service.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/features/customers/domain/entities/customer.dart';
import 'package:basir_accounting_system/features/customers/presentation/providers/customer_provider.dart';
import 'package:basir_accounting_system/features/customers/presentation/screens/customer_form_screen.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' as intl;

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

    return GlassScaffold(
      title: context.l10n.customerDetailsTitle,
      actions: [
        IconButton(
          icon: Icon(appIcons.edit),
          tooltip: context.l10n.tooltipEditCustomer,
          onPressed: () => _editCustomer(context),
        ),
        IconButton(
          icon: Icon(appIcons.delete, color: AppColors.error),
          tooltip: context.l10n.actionDeleteCustomer,
          onPressed: () => _deleteCustomer(context, ref),
        ),
      ],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // صورة العميل
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                child: Text(
                  customer.name(isArabic: context.isArabic).isNotEmpty
                      ? customer.name(isArabic: context.isArabic)[0]
                      : '؟',
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: Spacing.lg),

            // اسم العميل
            Center(
              child: Text(
                customer.name(isArabic: context.isArabic),
                style: AppTextStyles.titleLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: Spacing.xl),

            // معلومات الاتصال
            _buildSectionTitle(context.l10n.sectionContactInfo),
            const SizedBox(height: Spacing.md),
            if (customer.email != null) ...[
              _buildInfoCard(
                icon: appIcons.email,
                label: context.l10n.labelEmail,
                value: customer.email!,
              ),
              const SizedBox(height: Spacing.sm),
            ],
            if (customer.phone != null) ...[
              _buildInfoCard(
                icon: appIcons.phone,
                label: context.l10n.labelPhone,
                value: customer.phone!,
              ),
              const SizedBox(height: Spacing.sm),
            ],
            if (customer.address != null) ...[
              _buildInfoCard(
                icon: appIcons.location,
                label: context.l10n.labelAddress,
                value: customer.address!,
              ),
              const SizedBox(height: Spacing.sm),
            ],

            // ملاحظات
            if (customer.notes != null) ...[
              const SizedBox(height: Spacing.lg),
              _buildSectionTitle(context.l10n.labelNotes),
              const SizedBox(height: Spacing.md),
              AppCard(
                child: Padding(
                  padding: const EdgeInsets.all(Spacing.md),
                  child: Text(
                    customer.notes!,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ],

            // معلومات إضافية
            const SizedBox(height: Spacing.lg),
            _buildSectionTitle(context.l10n.sectionAdditionalInfo),
            const SizedBox(height: Spacing.md),
            _buildInfoCard(
              icon: appIcons.calendar,
              label: context.l10n.labelCreatedDate,
              value: _formatDate(customer.createdAt),
            ),
            const SizedBox(height: Spacing.sm),
            _buildInfoCard(
              icon: appIcons.update,
              label: context.l10n.labelLastUpdated,
              value: _formatDate(customer.updatedAt),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) => Text(
        title,
        style: AppTextStyles.titleMedium.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      );

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
  }) =>
      Semantics(
        label: '$label: $value',
        child: AppCard(
          child: Padding(
            padding: const EdgeInsets.all(Spacing.md),
            child: Row(
              children: [
                Icon(icon, color: AppColors.primary, size: 24),
                const SizedBox(width: Spacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        value,
                        style: AppTextStyles.bodyMedium.copyWith(
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
        ),
      );

  String _formatDate(DateTime date) =>
      intl.DateFormat('yyyy/MM/dd').format(date);

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
    final confirmed = await AppDialog.showConfirmation(
      context,
      title: context.l10n.actionDeleteCustomer,
      message: context.l10n.msgConfirmDeleteCustomer(
        customer.name(isArabic: context.isArabic),
      ),
      confirmLabel: context.l10n.btnDelete,
      cancelLabel: context.l10n.dialogCancel,
      confirmIsDestructive: true,
    );

    if (!confirmed || !context.mounted) return;

    try {
      final result = await ref.read(deleteCustomerProvider(customer.id).future);

      if (!context.mounted) return;

      if (result) {
        AppSnackbar.showSuccess(context, context.l10n.msgCustomerDeleted);
        Navigator.pop(context, true);
      } else {
        AppSnackbar.showError(context, context.l10n.errCustomerDelete);
      }
    } on Exception catch (e) {
      if (!context.mounted) return;
      AppSnackbar.showError(context, context.l10n.errGeneric(e.toString()));
    }
  }
}
