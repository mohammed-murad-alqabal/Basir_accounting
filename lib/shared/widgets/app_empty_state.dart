import 'package:basir_app/core/assets/app_illustrations.dart';
import 'package:basir_app/core/theme/tokens/index.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// ودجت الحالة الفارغة (Empty State Widget)
///
/// يعرض رسالة توضيحية عندما لا توجد بيانات، مع دعم للرسوم المتحركة (Lottie).
class AppEmptyState extends StatelessWidget {
  /// إنشاء حالة فارغة
  const AppEmptyState({
    required this.title,
    super.key,
    this.description,
    this.icon,
    this.lottieAsset,
    this.actionLabel,
    this.onActionPressed,
  });

  /// العنوان الرئيسي
  final String title;

  /// الوصف التفصيلي (اختياري)
  final String? description;

  /// الأيقونة (إذا لم يتوفر Lottie)
  final IconData? icon;

  /// مسار ملف Lottie (اختياري)
  final String? lottieAsset;

  /// نص الزر (اختياري)
  final String? actionLabel;

  /// الإجراء عند الضغط على الزر
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(Spacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildIllustration(),
              const SizedBox(height: Spacing.lg),
              Text(
                title,
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeights.bold,
                ),
                textAlign: TextAlign.center,
              ),
              if (description != null) ...[
                const SizedBox(height: Spacing.sm),
                Text(
                  description!,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              if (actionLabel != null && onActionPressed != null) ...[
                const SizedBox(height: Spacing.xl),
                ElevatedButton(
                  onPressed: onActionPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.xl,
                      vertical: Spacing.md,
                    ),
                    shape: const RoundedRectangleBorder(
                      borderRadius: Radii.borderRadiusMd,
                    ),
                  ),
                  child: Text(actionLabel!),
                ),
              ],
            ],
          ),
        ),
      );

  Widget _buildIllustration() {
    if (lottieAsset != null) {
      return Lottie.asset(
        lottieAsset!,
        width: 200,
        height: 200,
        repeat: true,
      );
    }

    if (icon != null) {
      return Icon(
        icon,
        size: 80,
        color: AppColors.textHint.withValues(alpha: 0.5),
      );
    }

    return const EmptyStateIllustration(size: 150);
  }
}
