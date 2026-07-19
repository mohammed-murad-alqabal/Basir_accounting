import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// ودجت الهيكل العظمي (Skeleton Widget)
///
/// يستخدم لعرض حالة التحميل (Loading State) بشكل احترافي باستخدام Shimmer.
class AppSkeleton extends StatelessWidget {
  /// إنشاء هيكل عظمي مستطيل أو دائري
  const AppSkeleton({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.shape = BoxShape.rectangle,
  });

  /// إنشاء هيكل عظمي دائري
  const AppSkeleton.circle({super.key, double? size})
      : width = size,
        height = size,
        borderRadius = null,
        shape = BoxShape.circle;

  /// العرض
  final double? width;

  /// الارتفاع
  final double? height;

  /// تدوير الحواف (افتراضي: Radii.sm)
  final BorderRadius? borderRadius;

  /// شكل الهيكل (مستطيل أو دائري)
  final BoxShape shape;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final baseColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.grey[700]! : Colors.grey[100]!;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: baseColor,
          shape: shape,
          borderRadius: shape == BoxShape.circle
              ? null
              : (borderRadius ?? Radii.borderRadiusSm),
        ),
      ),
    );
  }
}

/// هيكل عظمي لبطاقة إحصائية
class AppStatSkeleton extends StatelessWidget {
  /// المنشئ
  const AppStatSkeleton({super.key});

  @override
  Widget build(BuildContext context) => Container(
        padding: Spacing.paddingSm,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: Radii.borderRadiusMd,
          border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppSkeleton.circle(size: 26),
            SizedBox(height: Spacing.xs),
            AppSkeleton(width: 60, height: 12),
            SizedBox(height: Spacing.xs),
            AppSkeleton(width: 80, height: 24),
          ],
        ),
      );
}

/// هيكل عظمي لبطاقة قائمة
class AppListSkeleton extends StatelessWidget {
  /// المنشئ
  const AppListSkeleton({super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: Spacing.sm),
        child: Container(
          padding: Spacing.paddingMd,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: Radii.borderRadiusMd,
            border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
          ),
          child: const Row(
            children: [
              AppSkeleton(
                width: 40,
                height: 40,
                borderRadius: Radii.borderRadiusSm,
              ),
              SizedBox(width: Spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppSkeleton(width: 120, height: 16),
                    SizedBox(height: Spacing.xs),
                    AppSkeleton(width: 180, height: 12),
                  ],
                ),
              ),
              SizedBox(width: Spacing.md),
              AppSkeleton(width: 60, height: 16),
            ],
          ),
        ),
      );
}
