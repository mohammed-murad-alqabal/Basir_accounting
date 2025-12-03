import 'package:basser_app/core/theme.dart';
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
///   onTap: () => print('تم النقر'),
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
          child: Padding(
            padding: padding ?? EdgeInsets.zero,
            child: child,
          ),
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
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: AppTypography.titleSmall,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          subtitle!,
                          style: const TextStyle(
                            fontSize: AppTypography.bodySmall,
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: AppSpacing.md),
                  Text(
                    trailing!,
                    style: const TextStyle(
                      fontSize: AppTypography.bodyMedium,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
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
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // الصف الأول: التسمية والأيقونة
              SizedBox(
                height: 14, // ارتفاع ثابت للصف الأول
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        label,
                        style: const TextStyle(
                          fontSize: 9,
                          color: AppColors.textSecondary,
                          height: 1.1,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(icon, color: iconColor, size: 14),
                  ],
                ),
              ),
              const SizedBox(height: 2),
              // الصف الثاني: القيمة
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      height: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
