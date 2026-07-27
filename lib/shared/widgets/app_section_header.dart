import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:flutter/material.dart';

/// ترويسة قسم قياسية (Standard Section Header)
///
/// تضمن اتساق العناوين في جميع الشاشات مع أيقونة اختيارية
class AppSectionHeader extends StatelessWidget {
  /// إنشاء ترويسة قسم
  const AppSectionHeader({
    required this.title,
    this.icon,
    this.color,
    super.key,
  });

  /// عنوان القسم
  final String title;

  /// أيقونة اختيارية
  final IconData? icon;

  /// لون العنوان والأيقونة
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final themeColor = color ?? Theme.of(context).colorScheme.primary;

    return Semantics(
      header: true,
      label: title,
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: IconSizes.md, color: themeColor),
            const SizedBox(width: Spacing.xs),
          ],
          Text(
            title,
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeights.bold,
              color: color ?? AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
