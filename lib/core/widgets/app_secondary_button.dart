import 'package:basser_app/core/widgets/app_enhanced_button.dart';
import 'package:flutter/material.dart';

/// زر ثانوي للتطبيق.
///
/// يستخدم هذا المكون AppEnhancedButton مع النمط الثانوي.
/// مناسب للإجراءات الثانوية مثل الإلغاء والعودة والخيارات الإضافية.
///
/// مثال:
/// ```dart
/// AppSecondaryButton(
///   text: 'إلغاء',
///   onPressed: () => Navigator.pop(context),
///   icon: Icons.cancel,
/// )
/// ```
class AppSecondaryButton extends StatelessWidget {
  /// ينشئ زر ثانوي جديد.
  const AppSecondaryButton({
    required this.text,
    this.onPressed,
    super.key,
    this.isLoading = false,
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

  /// حالة التحميل
  final bool isLoading;

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
        style: AppEnhancedButtonStyle.secondary,
        size: size,
        isLoading: isLoading,
        icon: icon,
        maxLines: maxLines,
        tooltip: tooltip,
        semanticLabel: semanticLabel,
      );
}
