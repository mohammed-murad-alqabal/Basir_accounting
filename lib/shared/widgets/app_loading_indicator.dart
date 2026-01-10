import 'package:flutter/material.dart';

/// مؤشر تحميل موحد للتطبيق
///
/// يوفر تجربة تحميل بريميوم ومتسقة عبر جميع الشاشات
class AppLoadingIndicator extends StatelessWidget {
  /// إنشاء مؤشر تحميل
  const AppLoadingIndicator({
    this.color,
    this.size = 24,
    this.strokeWidth = 3,
    super.key,
  });

  /// لون المؤشر (اختياري)
  final Color? color;

  /// حجم المؤشر
  final double size;

  /// سمك الخط
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? Theme.of(context).colorScheme.primary;

    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: strokeWidth,
          valueColor: AlwaysStoppedAnimation<Color>(effectiveColor),
          strokeCap: StrokeCap.round,
        ),
      ),
    );
  }
}

/// غلاف تحميل لكامل الصفحة
class AppLoadingScreen extends StatelessWidget {
  /// إنشاء غلاف تحميل لكامل الصفحة
  const AppLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: AppLoadingIndicator(size: 40));
}
