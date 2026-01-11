import 'package:basir_accounting_system/core/extensions/context_extensions.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/features/vendors/domain/entities/vendor.dart';
import 'package:basir_accounting_system/features/vendors/presentation/providers/vendor_provider.dart';
import 'package:basir_accounting_system/features/vendors/presentation/screens/vendor_form_screen.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// شاشة تفاصيل المورد (Vendor Details Screen)
class VendorDetailsScreen extends ConsumerWidget {
  /// إنشاء شاشة تفاصيل المورد
  const VendorDetailsScreen({required this.vendor, super.key});

  /// المورد المراد عرض تفاصيله
  final Vendor vendor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizedName = vendor.name(isArabic: context.isArabic);

    return Scaffold(
      appBar: AppAppBar(
        title: localizedName,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _editVendor(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _confirmDelete(context, ref),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(Spacing.lg),
        children: [
          // رأس الصفحة مع الأيقونة والاسم
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                  child: Text(
                    localizedName.isNotEmpty ? localizedName[0] : '؟',
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: Spacing.md),
                Text(
                  localizedName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (vendor.email != null) ...[
                  const SizedBox(height: Spacing.xs),
                  Text(
                    vendor.email!,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: Spacing.xl),

          // معلومات المورد
          AppCard(
            padding: const EdgeInsets.all(Spacing.lg),
            child: Column(
              children: [
                _buildInfoRow(
                  context,
                  Icons.business,
                  context.l10n.labelNameAr,
                  vendor.nameAr,
                ),
                const Divider(),
                _buildInfoRow(
                  context,
                  Icons.business_outlined,
                  context.l10n.labelNameEn,
                  vendor.nameEn,
                ),
                if (vendor.phone != null) ...[
                  const Divider(),
                  _buildInfoRow(
                    context,
                    Icons.phone,
                    context.l10n.labelPhone,
                    vendor.phone!,
                  ),
                ],
                if (vendor.address != null) ...[
                  const Divider(),
                  _buildInfoRow(
                    context,
                    Icons.location_on,
                    context.l10n.labelAddress,
                    vendor.address!,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: Spacing.xs),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 20),
            const SizedBox(width: Spacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Future<void> _editVendor(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute<bool>(
        builder: (context) => VendorFormScreen(vendor: vendor),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.actionDeleteVendor),
        content: Text(
          context.l10n.msgConfirmDeleteVendor(
            vendor.name(isArabic: context.isArabic),
          ),
        ),
        actions: [
          AppEnhancedButton(
            label: context.l10n.dialogCancel,
            onPressed: () => Navigator.pop(context, false),
            type: AppEnhancedButtonType.text,
          ),
          AppEnhancedButton(
            label: context.l10n.dialogDelete,
            onPressed: () => Navigator.pop(context, true),
            type: AppEnhancedButtonType.danger,
          ),
        ],
      ),
    );

    if (confirmed ?? false) {
      await ref.read(vendorsProvider.notifier).deleteVendor(vendor.id);
      if (context.mounted) Navigator.pop(context);
    }
  }
}
