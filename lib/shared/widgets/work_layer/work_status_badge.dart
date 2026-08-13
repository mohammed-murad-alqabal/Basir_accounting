/// شارة حالة الوثيقة الموحدة لنظام بصير المحاسبي.
///
/// تعرض الحالة كنص عربي/إنجليزي مرافق لأيقونة ودلالة لونية؛
/// لا يجوز عرض حالة بلون وحده وفق مخطط UI/UX التنفيذي (القسم 6).
///
/// المرجع: مكونات قابلة لإعادة الاستخدام — القسم 7.
library;


import 'package:flutter/material.dart';
import 'package:basir_accounting_system/core/domain/contracts/index.dart';
import 'package:basir_accounting_system/core/theme/tokens/app_colors.dart';
import 'package:basir_accounting_system/core/theme/tokens/app_text_styles.dart';
import 'package:basir_accounting_system/core/theme/tokens/font_weights.dart';
import 'package:basir_accounting_system/core/theme/tokens/radii.dart';
import 'package:basir_accounting_system/core/theme/tokens/spacing.dart';
import 'package:basir_accounting_system/core/theme/tokens/icon_sizes.dart';

/// شارة حالة الوثيقة: نص + رمز + لون دلالي.
///
/// تستخدم داخل الجداول وبطاقات الوثائق وسجلات التدقيق، ويمكن تخصيص
/// الحالة أو النص والعرض اليدوي عبر [status] أو [label]/[backgroundColor].
class WorkStatusBadge extends StatelessWidget {
  /// يبني شارة بحالة موحدة، أو يدويًا عبر [label]/[backgroundColor]/[icon].
  const WorkStatusBadge({
    super.key,
    this.status,
    this.label,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.compact = false,
  }) : assert(
          status != null || (label != null && backgroundColor != null),
          'يجب تحديد الحالة الموحدة أو نص الشارة مع لونها.',
        );

  /// الحالة الموحدة للوثيقة (تُشتق منها النصوص والألوان والأيقونات).
  final DocumentStatus? status;

  /// نص الشارة اليدوي عند عدم استخدام الحالة الموحدة.
  final String? label;

  /// لون الخلفية اليدوي.
  final Color? backgroundColor;

  /// لون النص اليدوي.
  final Color? textColor;

  /// الأيقونة اليدوية.
  final IconData? icon;

  /// حجم مضغوط للعرض داخل الجداول الكثيفة.
  final bool compact;

  /// نص العرض النهائي وفق لغة سياق العرض الحالي.
  String _labelOf(BuildContext context) =>
      label ?? (status?.localizedLabelOf(context) ?? '');

  /// لون الخلفية النهائي.
  Color get _resolvedBackground =>
      backgroundColor ?? (status?.semanticColor ?? AppColors.textDisabled);

  /// أيقونة العرض النهائية.
  IconData get _resolvedIcon =>
      icon ?? (status?.semanticIcon ?? Icons.help_outline);

  @override
  Widget build(BuildContext context) {
    final padding = compact
        ? const EdgeInsets.symmetric(
            horizontal: Spacing.sm, vertical: Spacing.xs)
        : const EdgeInsets.symmetric(
            horizontal: Spacing.md, vertical: Spacing.sm);
    final iconSize = compact ? IconSizes.sm : IconSizes.md;
    final fontSize =
        compact ? AppTextStyles.labelSmallSize : AppTextStyles.labelMediumSize;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: _resolvedBackground,
        borderRadius: Radii.borderRadiusFull,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_resolvedIcon, size: iconSize, color: AppColors.textOnDark),
          const SizedBox(width: Spacing.xs),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.center,
              child: Text(
                _labelOf(context),
                style: AppTextStyles.bodySmall.copyWith(
                  fontSize: fontSize,
                  fontWeight: FontWeights.medium,
                  color: textColor ?? AppColors.textOnDark,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
