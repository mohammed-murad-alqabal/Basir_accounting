import 'package:basser_app/core/theme/app_animations.dart';
import 'package:basser_app/core/theme/app_colors.dart';
import 'package:basser_app/core/theme/app_dimensions.dart';
import 'package:basser_app/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

/// زر أساسي مملوء بالألوان الأساسية
///
/// زر مرتفع (Elevated) بتصميم Material Design محسّن
/// يستخدم للإجراءات الأساسية والمهمة في التطبيق
///
/// Features:
/// - ✅ مساحة نقر لا تقل عن 48x48px (WCAG 2.1 Level AA)
/// - ✅ تباين لا يقل عن 4.5:1 للنص (WCAG 2.1 Level AA)
/// - ✅ حالات hover و focus و active واضحة
/// - ✅ ripple effect عند الضغط
/// - ✅ حالة معطلة واضحة بصرياً
/// - ✅ حركات انتقالية سلسة
/// - ✅ حالة تحميل مع مؤشر دائري
///
/// Example:
/// ```dart
/// AppPrimaryButton(
///   label: 'حفظ',
///   onPressed: () => saveData(),
///   isLoading: isProcessing,
/// )
/// ```
class AppPrimaryButton extends StatefulWidget {
  /// إنشاء زر أساسي
  ///
  /// Parameters:
  /// - [label]: نص الزر (مطلوب)
  /// - [onPressed]: دالة يتم استدعاؤها عند الضغط (null = معطل)
  /// - [isLoading]: حالة التحميل، يعرض مؤشر دائري (افتراضي: false)
  /// - [width]: عرض الزر (اختياري، افتراضي: double.infinity)
  /// - [height]: ارتفاع الزر (افتراضي: 48px)
  /// - [icon]: أيقونة اختيارية تظهر قبل النص
  const AppPrimaryButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.isLoading = false,
    this.width,
    this.height,
    this.icon,
  });

  /// نص الزر المعروض
  final String label;

  /// دالة يتم استدعاؤها عند الضغط على الزر
  /// null = الزر معطل
  final VoidCallback? onPressed;

  /// حالة التحميل - يعرض مؤشر دائري عند true
  final bool isLoading;

  /// عرض الزر (اختياري، افتراضي: double.infinity)
  final double? width;

  /// ارتفاع الزر (افتراضي: 48px)
  final double? height;

  /// أيقونة اختيارية تظهر قبل النص
  final IconData? icon;

  @override
  State<AppPrimaryButton> createState() => _AppPrimaryButtonState();
}

class _AppPrimaryButtonState extends State<AppPrimaryButton> {
  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onPressed == null || widget.isLoading;

    return SizedBox(
      width: widget.width ?? double.infinity,
      height: widget.height ?? AppDimensions.buttonHeightLg,
      child: ElevatedButton(
        onPressed: isDisabled ? null : widget.onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          disabledBackgroundColor: AppColors.surface,
          disabledForegroundColor: AppColors.textDisabled,
          elevation: 2,
          shadowColor: AppColors.shadow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          minimumSize: const Size(
            AppDimensions.minTouchTarget,
            AppDimensions.minTouchTarget,
          ),
          tapTargetSize: MaterialTapTargetSize.padded,
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith<Color?>(
            (states) {
              if (states.contains(WidgetState.pressed)) {
                return AppColors.onPrimary.withValues(alpha: 0.2);
              }
              if (states.contains(WidgetState.hovered)) {
                return AppColors.onPrimary.withValues(alpha: 0.1);
              }
              if (states.contains(WidgetState.focused)) {
                return AppColors.onPrimary.withValues(alpha: 0.1);
              }
              return null;
            },
          ),
        ),
        onLongPress: isDisabled ? null : () {},
        child: AnimatedSwitcher(
          duration: AppAnimations.durationFast,
          child: widget.isLoading
              ? const SizedBox(
                  height: AppDimensions.iconMd,
                  width: AppDimensions.iconMd,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.onPrimary,
                    ),
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.icon != null) ...[
                      Icon(
                        widget.icon,
                        size: AppDimensions.iconMd,
                      ),
                      const SizedBox(width: AppDimensions.spacingXs),
                    ],
                    Flexible(
                      child: Text(
                        widget.label,
                        style: const TextStyle(
                          fontSize: AppTextStyles.labelLarge,
                          fontWeight: AppTextStyles.medium,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

/// زر ثانوي بحد فقط
///
/// زر محدد (Outlined) بتصميم Material Design محسّن
/// يستخدم للإجراءات الثانوية والأقل أهمية
///
/// Features:
/// - ✅ مساحة نقر لا تقل عن 48x48px (WCAG 2.1 Level AA)
/// - ✅ تباين لا يقل عن 4.5:1 للنص (WCAG 2.1 Level AA)
/// - ✅ حد واضح بلون أساسي
/// - ✅ حالات hover و focus و active واضحة
/// - ✅ ripple effect عند الضغط
/// - ✅ حالة معطلة واضحة بصرياً
/// - ✅ حركات انتقالية سلسة
///
/// Example:
/// ```dart
/// AppSecondaryButton(
///   label: 'إلغاء',
///   onPressed: () => Navigator.pop(context),
/// )
/// ```
class AppSecondaryButton extends StatefulWidget {
  /// إنشاء زر ثانوي
  ///
  /// Parameters:
  /// - [label]: نص الزر (مطلوب)
  /// - [onPressed]: دالة يتم استدعاؤها عند الضغط (null = معطل)
  /// - [isLoading]: حالة التحميل، يعرض مؤشر دائري (افتراضي: false)
  /// - [width]: عرض الزر (اختياري، افتراضي: double.infinity)
  /// - [height]: ارتفاع الزر (افتراضي: 48px)
  /// - [icon]: أيقونة اختيارية تظهر قبل النص
  const AppSecondaryButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.isLoading = false,
    this.width,
    this.height,
    this.icon,
  });

  /// نص الزر المعروض
  final String label;

  /// دالة يتم استدعاؤها عند الضغط على الزر
  /// null = الزر معطل
  final VoidCallback? onPressed;

  /// حالة التحميل - يعرض مؤشر دائري عند true
  final bool isLoading;

  /// عرض الزر (اختياري، افتراضي: double.infinity)
  final double? width;

  /// ارتفاع الزر (افتراضي: 48px)
  final double? height;

  /// أيقونة اختيارية تظهر قبل النص
  final IconData? icon;

  @override
  State<AppSecondaryButton> createState() => _AppSecondaryButtonState();
}

class _AppSecondaryButtonState extends State<AppSecondaryButton> {
  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onPressed == null || widget.isLoading;

    return SizedBox(
      width: widget.width ?? double.infinity,
      height: widget.height ?? AppDimensions.buttonHeightLg,
      child: OutlinedButton(
        onPressed: isDisabled ? null : widget.onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          disabledForegroundColor: AppColors.textDisabled,
          side: BorderSide(
            color: isDisabled ? AppColors.textDisabled : AppColors.primary,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          minimumSize: const Size(
            AppDimensions.minTouchTarget,
            AppDimensions.minTouchTarget,
          ),
          tapTargetSize: MaterialTapTargetSize.padded,
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith<Color?>(
            (states) {
              if (states.contains(WidgetState.pressed)) {
                return AppColors.primary.withValues(alpha: 0.2);
              }
              if (states.contains(WidgetState.hovered)) {
                return AppColors.primary.withValues(alpha: 0.1);
              }
              if (states.contains(WidgetState.focused)) {
                return AppColors.primary.withValues(alpha: 0.1);
              }
              return null;
            },
          ),
        ),
        onLongPress: isDisabled ? null : () {},
        child: AnimatedSwitcher(
          duration: AppAnimations.durationFast,
          child: widget.isLoading
              ? const SizedBox(
                  height: AppDimensions.iconMd,
                  width: AppDimensions.iconMd,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.icon != null) ...[
                      Icon(
                        widget.icon,
                        size: AppDimensions.iconMd,
                      ),
                      const SizedBox(width: AppDimensions.spacingXs),
                    ],
                    Flexible(
                      child: Text(
                        widget.label,
                        style: TextStyle(
                          fontSize: AppTextStyles.labelLarge,
                          fontWeight: AppTextStyles.medium,
                          color: isDisabled
                              ? AppColors.textDisabled
                              : AppColors.primary,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

/// زر نصي بسيط
///
/// زر نصي (Text Button) بتصميم Material Design محسّن
/// يستخدم للإجراءات الأقل أهمية أو الروابط
///
/// Features:
/// - ✅ مساحة نقر لا تقل عن 48x48px (WCAG 2.1 Level AA)
/// - ✅ تباين لا يقل عن 4.5:1 للنص (WCAG 2.1 Level AA)
/// - ✅ حالات hover و focus و active واضحة
/// - ✅ ripple effect عند الضغط
/// - ✅ حالة معطلة واضحة بصرياً
/// - ✅ حركات انتقالية سلسة
///
/// Example:
/// ```dart
/// AppTextButton(
///   label: 'نسيت كلمة المرور؟',
///   onPressed: () => navigateToResetPassword(),
/// )
/// ```
class AppTextButton extends StatefulWidget {
  /// إنشاء زر نصي
  ///
  /// Parameters:
  /// - [label]: نص الزر (مطلوب)
  /// - [onPressed]: دالة يتم استدعاؤها عند الضغط (null = معطل)
  /// - [color]: لون النص (افتراضي: AppColors.primary)
  /// - [icon]: أيقونة اختيارية تظهر قبل النص
  const AppTextButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.color,
    this.icon,
  });

  /// نص الزر المعروض
  final String label;

  /// دالة يتم استدعاؤها عند الضغط على الزر
  /// null = الزر معطل
  final VoidCallback? onPressed;

  /// لون النص (افتراضي: AppColors.primary)
  final Color? color;

  /// أيقونة اختيارية تظهر قبل النص
  final IconData? icon;

  @override
  State<AppTextButton> createState() => _AppTextButtonState();
}

class _AppTextButtonState extends State<AppTextButton> {
  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onPressed == null;
    final textColor = widget.color ?? AppColors.primary;

    return TextButton(
      onPressed: widget.onPressed,
      style: TextButton.styleFrom(
        foregroundColor: textColor,
        disabledForegroundColor: AppColors.textDisabled,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        minimumSize: const Size(
          AppDimensions.minTouchTarget,
          AppDimensions.minTouchTarget,
        ),
        tapTargetSize: MaterialTapTargetSize.padded,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
      ).copyWith(
        overlayColor: WidgetStateProperty.resolveWith<Color?>(
          (states) {
            if (states.contains(WidgetState.pressed)) {
              return textColor.withValues(alpha: 0.2);
            }
            if (states.contains(WidgetState.hovered)) {
              return textColor.withValues(alpha: 0.1);
            }
            if (states.contains(WidgetState.focused)) {
              return textColor.withValues(alpha: 0.1);
            }
            return null;
          },
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.icon != null) ...[
            Icon(
              widget.icon,
              size: AppDimensions.iconMd,
            ),
            const SizedBox(width: AppDimensions.spacingXs),
          ],
          Flexible(
            child: Text(
              widget.label,
              style: TextStyle(
                fontSize: AppTextStyles.labelLarge,
                fontWeight: AppTextStyles.medium,
                color: isDisabled ? AppColors.textDisabled : textColor,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
