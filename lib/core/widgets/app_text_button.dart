import 'package:basser_app/core/widgets/app_enhanced_button.dart';
import 'package:flutter/material.dart';

/// زر نصي للتطبيق.
///
/// يستخدم هذا المكون AppEnhancedButton مع النمط النصي.
/// مناسب للروابط والإجراءات الأقل أهمية مثل 'إنشاء حساب' و 'نسيت كلمة المرور'.
///
/// مثال:
/// ```dart
/// AppTextButton(
///   text: 'إنشاء حساب جديد',
///   onPressed: () => _createAccount(),
///   icon: Icons.person_add,
/// )
/// ```
class AppTextButton extends StatelessWidget {
  /// ينشئ زر نصي جديد.
  const AppTextButton({
    required this.text,
    this.onPressed,
    super.key,
    this.icon,
    this.size = AppEnhancedButtonSize.medium,
    this.maxLines,
    this.tooltip,
    this.semanticLabel,
  });

  /// نص الزر
  final String text;

  /// دالة الضغط
  final VoidCallback? onPressed;

  /// أيقونة اختيارية
  final IconData? icon;

  /// حجم الزر
  final AppEnhancedButtonSize size;

  /// عدد الأسطر الأقصى للنص
  final int? maxLines;

  /// نص التلميح
  final String? tooltip;

  /// تسمية إمكانية الوصول
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) => AppEnhancedButton(
        text: text,
        onPressed: onPressed,
        style: AppEnhancedButtonStyle.text,
        size: size,
        icon: icon,
        maxLines: maxLines,
        tooltip: tooltip,
        semanticLabel: semanticLabel,
      );
}
