import 'package:basser_app/core/theme.dart';
import 'package:basser_app/core/widgets/responsive_text.dart';
import 'package:flutter/material.dart';

/// بطاقة أساسية مخصصة
///
/// بطاقة بسيطة قابلة للتخصيص مع دعم النقر
///
/// Features:
/// - تصميم Material Design
/// - قابلة للنقر (اختياري)
/// - حشوة قابلة للتخصيص
/// - لون خلفية قابل للتخصيص
/// - ارتفاع (elevation) قابل للتخصيص
///
/// Example:
/// ```dart
/// AppCard(
///   child: Text('محتوى البطاقة'),
///   onTap: () => debugPrint('تم النقر'),
/// )
/// ```
class AppCard extends StatelessWidget {
  /// إنشاء بطاقة أساسية
  ///
  /// Parameters:
  /// - [child]: محتوى البطاقة (مطلوب)
  /// - [padding]: الحشوة الداخلية (افتراضي: AppSpacing.md)
  /// - [onTap]: دالة تُستدعى عند النقر (اختياري)
  /// - [backgroundColor]: لون الخلفية (افتراضي: AppColors.surface)
  /// - [elevation]: ارتفاع الظل (افتراضي: 0)
  const AppCard({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.onTap,
    this.backgroundColor = AppColors.surface,
    this.elevation = 0,
  });

  /// محتوى البطاقة
  final Widget child;

  /// الحشوة الداخلية للبطاقة
  final EdgeInsets? padding;

  /// دالة تُستدعى عند النقر على البطاقة
  final VoidCallback? onTap;

  /// لون خلفية البطاقة
  final Color? backgroundColor;

  /// ارتفاع ظل البطاقة
  final double? elevation;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Card(
          color: backgroundColor,
          elevation: elevation,
          child: Padding(padding: padding ?? EdgeInsets.zero, child: child),
        ),
      );
}

/// بطاقة قائمة للعملاء والفواتير
///
/// بطاقة مخصصة لعرض عناصر القوائم مثل العملاء والفواتير
///
/// Features:
/// - عنوان رئيسي وعنوان فرعي
/// - أيقونة في البداية (اختياري)
/// - نص في النهاية (اختياري)
/// - دعم النقر والنقر الطويل
/// - تصميم متسق مع Material Design
///
/// Example:
/// ```dart
/// AppListCard(
///   title: 'أحمد محمد',
///   subtitle: '0501234567',
///   trailing: '5 فواتير',
///   leading: Icon(Icons.person),
///   onTap: () => viewCustomer(),
/// )
/// ```
class AppListCard extends StatelessWidget {
  /// إنشاء بطاقة قائمة
  ///
  /// Parameters:
  /// - [title]: العنوان الرئيسي (مطلوب)
  /// - [subtitle]: العنوان الفرعي (اختياري)
  /// - [trailing]: نص في النهاية (اختياري)
  /// - [onTap]: دالة تُستدعى عند النقر (اختياري)
  /// - [onLongPress]: دالة تُستدعى عند النقر الطويل (اختياري)
  /// - [leading]: widget في البداية (اختياري)
  /// - [backgroundColor]: لون الخلفية (افتراضي: AppColors.surface)
  const AppListCard({
    required this.title,
    super.key,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.leading,
    this.backgroundColor = AppColors.surface,
  });

  /// العنوان الرئيسي للبطاقة
  final String title;

  /// العنوان الفرعي (يظهر أسفل العنوان الرئيسي)
  final String? subtitle;

  /// نص يظهر في نهاية البطاقة
  final String? trailing;

  /// دالة تُستدعى عند النقر على البطاقة
  final VoidCallback? onTap;

  /// دالة تُستدعى عند النقر الطويل على البطاقة
  final VoidCallback? onLongPress;

  /// widget يظهر في بداية البطاقة (عادة أيقونة)
  final Widget? leading;

  /// لون خلفية البطاقة
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Card(
          color: backgroundColor,
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                if (leading != null) ...[
                  leading!,
                  const SizedBox(width: AppSpacing.md),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ResponsiveText(
                        title,
                        style: const TextStyle(
                          fontSize: AppTypography.titleSmall,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: AppSpacing.xs),
                        ResponsiveText(
                          subtitle!,
                          style: const TextStyle(
                            fontSize: AppTypography.bodySmall,
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 2,
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: AppSpacing.md),
                  ResponsiveText(
                    trailing!,
                    style: const TextStyle(
                      fontSize: AppTypography.bodyMedium,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                    maxLines: 1,
                  ),
                ],
              ],
            ),
          ),
        ),
      );
}

/// بطاقة إحصائية
///
/// بطاقة مخصصة لعرض الإحصائيات والأرقام المهمة
///
/// Features:
/// - تسمية واضحة
/// - قيمة بخط كبير وبارز
/// - أيقونة توضيحية
/// - تصميم نظيف ومنظم
///
/// Example:
/// ```dart
/// AppStatCard(
///   label: 'إجمالي الفواتير',
///   value: '150',
///   icon: Icons.receipt,
///   iconColor: AppColors.primary,
/// )
/// ```
class AppStatCard extends StatelessWidget {
  /// إنشاء بطاقة إحصائية
  ///
  /// Parameters:
  /// - [label]: تسمية الإحصائية (مطلوب)
  /// - [value]: القيمة المعروضة (مطلوب)
  /// - [icon]: الأيقونة التوضيحية (مطلوب)
  /// - [iconColor]: لون الأيقونة (افتراضي: AppColors.primary)
  /// - [backgroundColor]: لون الخلفية (افتراضي: AppColors.surface)
  const AppStatCard({
    required this.label,
    required this.value,
    required this.icon,
    super.key,
    this.iconColor = AppColors.primary,
    this.backgroundColor = AppColors.surface,
  });

  /// تسمية الإحصائية
  final String label;

  /// القيمة المعروضة (رقم أو نص)
  final String value;

  /// الأيقونة التوضيحية
  final IconData icon;

  /// لون الأيقونة
  final Color? iconColor;

  /// لون خلفية البطاقة
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) => Card(
        color: backgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: iconColor, size: 26),
              const SizedBox(height: AppSpacing.xs),
              Flexible(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                    height: 1.1,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      height: 1.1,
                    ),
                    maxLines: 1,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
