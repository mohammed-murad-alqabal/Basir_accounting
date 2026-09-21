import 'package:basir_accounting_system/core/assets/app_logo.dart';
import 'package:basir_accounting_system/core/extensions/context_extensions.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/features/forensics/presentation/widgets/integrity_pulse_widget.dart';
import 'package:basir_accounting_system/shared/widgets/app_card.dart';
import 'package:flutter/material.dart';

/// رأس لوحة التحكم المطور (Basir Premium Header)

class DashboardBasirHeader extends StatelessWidget {
  const DashboardBasirHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Text(
            'القائمة الرئيسية',
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.9,
          children: [
            _buildGridItem(context, 'العملاء', Icons.people_alt_outlined, Colors.blue, '/customers'),
            _buildGridItem(context, 'الموردون', Icons.storefront_outlined, Colors.orange, '/vendors'),
            _buildGridItem(context, 'الفواتير', Icons.receipt_long_outlined, Colors.green, '/invoices'),
            _buildGridItem(context, 'المخزون', Icons.inventory_2_outlined, Colors.purple, '/inventory'),
            _buildGridItem(context, 'التقارير', Icons.analytics_outlined, Colors.red, '/reports'),
            _buildGridItem(context, 'الإعدادات', Icons.settings_outlined, Colors.blueGrey, '/settings'),
          ],
        ),
      ],
    );
  }

  Widget _buildGridItem(BuildContext context, String title, IconData icon, Color color, String route) {
    return InkWell(
      onTap: () {
        // We use push replacement or push based on architecture, we'll use pushNamed
        Navigator.of(context).pushNamed(route);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: color.withValues(alpha: 0.1)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 28, color: color),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}


/// بطاقة إحصائية زجاجية (Glassmorphic Stat Card)
class GlassStatCard extends StatelessWidget {
  /// إنشاء بطاقة إحصائية زجاجية
  const GlassStatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    super.key,
    this.onTap,
  });

  /// عنوان الإحصائية
  final String label;

  /// قيمة الإحصائية
  final String value;

  /// أيقونة الإحصائية
  final IconData icon;

  /// لون السمة (Theme Color)
  final Color color;

  /// دالة عند النقر
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    label: '$label: $value',
    button: onTap != null,
    child: AppCard(
      onTap: onTap,
      statusColor: color.withValues(alpha: 0.7),
      backgroundColor: AppColors.surface.withValues(alpha: 0.7),
      padding: const EdgeInsets.all(Spacing.md),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(Spacing.xs),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: IconSizes.md),
          ),
          const SizedBox(height: Spacing.xs),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: AppTextStyles.headlineSmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeights.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
