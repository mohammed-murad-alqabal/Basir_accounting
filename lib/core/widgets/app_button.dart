import 'package:basser_app/core/theme.dart';
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
  /// - [onPressed]: دالة يتم استدعاؤها عند الضغط (مطلوب)
  /// - [isLoading]: حالة التحميل، يعرض مؤشر دائري (افتراضي: false)
  /// - [width]: عرض الزر (اختياري)
  /// - [height]: ارتفاع الزر (افتراضي: 48)
  const AppPrimaryButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.isLoading = false,
    this.width,
    this.height,
  });

  /// نص الزر المعروض
  final String label;

  /// دالة يتم استدعاؤها عند الضغط على الزر
  final VoidCallback onPressed;

  /// حالة التحميل - يعرض مؤشر دائري عند true
  final bool isLoading;

  /// عرض الزر (اختياري)
  final double? width;

  /// ارتفاع الزر (افتراضي: 48)
  final double? height;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: width,
        height: height ?? 48,
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          child: isLoading
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(label),
        ),
      );
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
  /// - [onPressed]: دالة يتم استدعاؤها عند الضغط (مطلوب)
  /// - [isLoading]: حالة التحميل، يعرض مؤشر دائري (افتراضي: false)
  /// - [width]: عرض الزر (اختياري)
  /// - [height]: ارتفاع الزر (افتراضي: 48)
  const AppSecondaryButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.isLoading = false,
    this.width,
    this.height,
  });

  /// نص الزر المعروض
  final String label;

  /// دالة يتم استدعاؤها عند الضغط على الزر
  final VoidCallback onPressed;

  /// حالة التحميل - يعرض مؤشر دائري عند true
  final bool isLoading;

  /// عرض الزر (اختياري)
  final double? width;

  /// ارتفاع الزر (افتراضي: 48)
  final double? height;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: width,
        height: height ?? 48,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          child: isLoading
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                )
              : Text(label),
        ),
      );
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
/// - وزن خط متوسط (500)
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
  /// - [onPressed]: دالة يتم استدعاؤها عند الضغط (مطلوب)
  /// - [color]: لون النص (افتراضي: AppColors.primary)
  /// - [fontSize]: حجم الخط (افتراضي: AppTypography.bodyMedium)
  const AppTextButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.color = AppColors.primary,
    this.fontSize = AppTypography.bodyMedium,
  });

  /// نص الزر المعروض
  final String label;

  /// دالة يتم استدعاؤها عند الضغط على الزر
  final VoidCallback onPressed;

  /// لون النص (افتراضي: AppColors.primary)
  final Color? color;

  /// حجم الخط (افتراضي: AppTypography.bodyMedium)
  final double? fontSize;

  @override
  Widget build(BuildContext context) => TextButton(
        onPressed: onPressed,
        child: Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
}
