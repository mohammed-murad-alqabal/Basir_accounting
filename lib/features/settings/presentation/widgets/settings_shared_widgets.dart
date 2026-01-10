import 'package:basir_app/core/theme/tokens/index.dart';
import 'package:flutter/material.dart';

/// عنوان قسم الإعدادات
class SettingsSectionHeader extends StatelessWidget {
  /// إنشاء عنوان قسم الإعدادات
  const SettingsSectionHeader({required this.title, super.key, this.icon});

  /// عنوان القسم
  final String title;

  /// أيقونة اختيارية بجانب العنوان
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.sm),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: theme.colorScheme.primary),
            const SizedBox(width: Spacing.xs),
          ],
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

/// بطاقة مجموعة الإعدادات
class SettingsGroupCard extends StatelessWidget {
  /// إنشاء بطاقة مجموعة الإعدادات
  const SettingsGroupCard({required this.children, super.key});

  /// قائمة العناصر (Tiles) داخل المجموعة
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Radii.md),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            children[i],
            if (i < children.length - 1) const Divider(height: 1),
          ],
        ],
      ),
    );
  }
}
