import 'package:basser_app/core/theme.dart';
import 'package:basser_app/core/widgets/responsive_text.dart';
import 'package:flutter/material.dart';

/// زر أساسي مملوء بالألوان الأساسية
///
/// زر مرتفع (Elevated) بتصميم Material Design
/// يستخدم للإجراءات الأساسية والمهمة في التطبيق
///
/// Features:
/// - لون خلفية أساسي
/// - حالة تحميل مع مؤشر دائري
/// - أبعاد قابلة للتخصيص
/// - يتم تعطيله تلقائياً أثناء التحميل
///
/// Example:
/// ```dart
/// AppPrimaryButton(
///   label: 'حفظ',
///   onPressed: () => saveData(),
///   isLoading: isProcessing,
/// )
/// ```
class AppPrimaryButton extends StatelessWidget {
  /// إنشاء زر أساسي
  ///
  /// Parameters:
  /// - [label]: نص الزر (مطلوب)
  /// - [onPressed]: دالة يتم استدعاؤها عند الضغط (يمكن أن تكون null للتعطيل)
  /// - [isLoading]: حالة التحميل، يعرض مؤشر دائري (افتراضي: false)
  /// - [width]: عرض الزر (اختياري)
  /// - [height]: ارتفاع الزر (افتراضي: 48)
  const AppPrimaryButton({
    required this.label,
    this.onPressed,
    super.key,
    this.isLoading = false,
    this.width,
    this.height,
  });

  /// نص الزر المعروض
  final String label;

  /// دالة يتم استدعاؤها عند الضغط على الزر (null للتعطيل)
  final VoidCallback? onPressed;

  /// حالة التحميل - يعرض مؤشر دائري عند true
  final bool isLoading;

  /// عرض الزر (اختياري)
  final double? width;

  /// ارتفاع الزر (افتراضي: 48)
  final double? height;

  @override
  Widget build(BuildContext context) {
    // إزالة SizedBox الخارجي لإعطاء النص مساحة كافية
    final button = ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(width ?? 88, height ?? 52), // زيادة الحد الأدنى
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md + 4, // زيادة padding العمودي
        ),
        textStyle: const TextStyle(
          fontSize: AppTypography.bodyLarge,
          fontWeight: FontWeight.w600,
          height: 1.5, // زيادة line-height
        ),
      ),
      child: isLoading
          ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : ResponsiveText(
              label,
              maxLines: 2, // السماح بسطرين
              overflow: TextOverflow.visible, // عدم قص النص
              textAlign: TextAlign.center,
            ),
    );

    // استخدام width فقط إذا تم تحديده
    if (width != null) {
      return SizedBox(
        width: width,
        child: button,
      );
    }
    return button;
  }
}

/// زر ثانوي بحد فقط
///
/// زر محدد (Outlined) بتصميم Material Design
/// يستخدم للإجراءات الثانوية والأقل أهمية
///
/// Features:
/// - حد بلون أساسي بدون خلفية
/// - حالة تحميل مع مؤشر دائري
/// - أبعاد قابلة للتخصيص
/// - يتم تعطيله تلقائياً أثناء التحميل
///
/// Example:
/// ```dart
/// AppSecondaryButton(
///   label: 'إلغاء',
///   onPressed: () => Navigator.pop(context),
/// )
/// ```
class AppSecondaryButton extends StatelessWidget {
  /// إنشاء زر ثانوي
  ///
  /// Parameters:
  /// - [label]: نص الزر (مطلوب)
  /// - [onPressed]: دالة يتم استدعاؤها عند الضغط (يمكن أن تكون null للتعطيل)
  /// - [isLoading]: حالة التحميل، يعرض مؤشر دائري (افتراضي: false)
  /// - [width]: عرض الزر (اختياري)
  /// - [height]: ارتفاع الزر (افتراضي: 48)
  const AppSecondaryButton({
    required this.label,
    this.onPressed,
    super.key,
    this.isLoading = false,
    this.width,
    this.height,
  });

  /// نص الزر المعروض
  final String label;

  /// دالة يتم استدعاؤها عند الضغط على الزر (null للتعطيل)
  final VoidCallback? onPressed;

  /// حالة التحميل - يعرض مؤشر دائري عند true
  final bool isLoading;

  /// عرض الزر (اختياري)
  final double? width;

  /// ارتفاع الزر (افتراضي: 48)
  final double? height;

  @override
  Widget build(BuildContext context) {
    // إزالة SizedBox الخارجي لإعطاء النص مساحة كافية
    final button = OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: Size(width ?? 88, height ?? 52), // زيادة الحد الأدنى
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md + 4, // زيادة padding العمودي
        ),
        textStyle: const TextStyle(
          fontSize: AppTypography.bodyLarge,
          fontWeight: FontWeight.w600,
          height: 1.5, // زيادة line-height
        ),
      ),
      child: isLoading
          ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            )
          : ResponsiveText(
              label,
              maxLines: 2, // السماح بسطرين
              overflow: TextOverflow.visible, // عدم قص النص
              textAlign: TextAlign.center,
            ),
    );

    // استخدام width فقط إذا تم تحديده
    if (width != null) {
      return SizedBox(
        width: width,
        child: button,
      );
    }
    return button;
  }
}

/// زر نصي بسيط
///
/// زر نصي (Text Button) بتصميم Material Design
/// يستخدم للإجراءات الأقل أهمية أو الروابط
///
/// Features:
/// - نص فقط بدون خلفية أو حد
/// - لون قابل للتخصيص
/// - حجم خط قابل للتخصيص
/// - وزن خط نصف عريض (600) - محسّن للوضوح
///
/// Example:
/// ```dart
/// AppTextButton(
///   label: 'نسيت كلمة المرور؟',
///   onPressed: () => navigateToResetPassword(),
///   color: AppColors.secondary,
/// )
/// ```
class AppTextButton extends StatelessWidget {
  /// إنشاء زر نصي
  ///
  /// Parameters:
  /// - [label]: نص الزر (مطلوب)
  /// - [onPressed]: دالة يتم استدعاؤها عند الضغط (يمكن أن تكون null للتعطيل)
  /// - [color]: لون النص (افتراضي: AppColors.primary)
  /// - [fontSize]: حجم الخط (افتراضي: AppTypography.bodyLarge - محسّن)
  const AppTextButton({
    required this.label,
    this.onPressed,
    super.key,
    this.color = AppColors.primary,
    this.fontSize = AppTypography.bodyLarge,
  });

  /// نص الزر المعروض
  final String label;

  /// دالة يتم استدعاؤها عند الضغط على الزر (null للتعطيل)
  final VoidCallback? onPressed;

  /// لون النص (افتراضي: AppColors.primary)
  final Color? color;

  /// حجم الخط (افتراضي: AppTypography.bodyLarge - محسّن للوضوح)
  final double? fontSize;

  @override
  Widget build(BuildContext context) => TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm + 2, // زيادة padding
          ),
          textStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            height: 1.5, // زيادة line-height
          ),
        ),
        child: ResponsiveText(
          label,
          style: TextStyle(
            color: color,
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            height: 1.5, // زيادة line-height
          ),
          maxLines: 2, // السماح بسطرين
          overflow: TextOverflow.visible, // عدم قص النص
          textAlign: TextAlign.center,
        ),
      );
}
