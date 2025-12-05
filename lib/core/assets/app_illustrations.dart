/// رسومات توضيحية مخصصة لتطبيق بصير
///
/// يحتوي على widgets مخصصة لعرض رسومات توضيحية
/// في الشاشات الفارغة والحالات الخاصة
library;

import 'package:flutter/material.dart';

/// رسم توضيحي لحالة "لا توجد بيانات"
class EmptyStateIllustration extends StatelessWidget {
  /// إنشاء رسم توضيحي لحالة فارغة
  ///
  /// [size] حجم الرسم (افتراضي: 200)
  /// [color] لون الرسم (افتراضي: رمادي)
  const EmptyStateIllustration({
    super.key,
    this.size = 200,
    this.color = const Color(0xFF9CA3AF),
  });

  /// حجم الرسم
  final double size;

  /// لون الرسم
  final Color color;

  @override
  Widget build(BuildContext context) => CustomPaint(
        size: Size(size, size),
        painter: _EmptyStatePainter(color: color),
      );
}

/// رسام حالة فارغة
class _EmptyStatePainter extends CustomPainter {
  _EmptyStatePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.02
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..color = color.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;

    // رسم مجلد فارغ
    final folderPath = Path()
      ..moveTo(size.width * 0.2, size.height * 0.4)
      ..lineTo(size.width * 0.35, size.height * 0.3)
      ..lineTo(size.width * 0.8, size.height * 0.3)
      ..lineTo(size.width * 0.8, size.height * 0.7)
      ..lineTo(size.width * 0.2, size.height * 0.7)
      ..close();

    canvas
      ..drawPath(folderPath, fillPaint)
      ..drawPath(folderPath, paint);

    // رسم علامة استفهام في المنتصف
    final textPainter = TextPainter(
      text: TextSpan(
        text: '؟',
        style: TextStyle(
          fontSize: size.width * 0.2,
          color: color.withValues(alpha: 0.5),
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.rtl,
    )..layout();

    textPainter.paint(
      canvas,
      Offset(
        size.width * 0.5 - textPainter.width / 2,
        size.height * 0.45 - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// رسم توضيحي للنجاح
class SuccessIllustration extends StatelessWidget {
  /// إنشاء رسم توضيحي للنجاح
  ///
  /// [size] حجم الرسم (افتراضي: 150)
  /// [color] لون الرسم (افتراضي: أخضر)
  const SuccessIllustration({
    super.key,
    this.size = 150,
    this.color = const Color(0xFF2E7D32),
  });

  /// حجم الرسم
  final double size;

  /// لون الرسم
  final Color color;

  @override
  Widget build(BuildContext context) => CustomPaint(
        size: Size(size, size),
        painter: _SuccessPainter(color: color),
      );
}

/// رسام النجاح
class _SuccessPainter extends CustomPainter {
  _SuccessPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.05
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..color = color.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;

    // رسم دائرة
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.4;

    canvas
      ..drawCircle(center, radius, fillPaint)
      ..drawCircle(center, radius, paint);

    // رسم علامة صح
    final checkPath = Path()
      ..moveTo(size.width * 0.3, size.height * 0.5)
      ..lineTo(size.width * 0.45, size.height * 0.65)
      ..lineTo(size.width * 0.7, size.height * 0.35);

    canvas.drawPath(checkPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// رسم توضيحي للخطأ
class ErrorIllustration extends StatelessWidget {
  /// إنشاء رسم توضيحي للخطأ
  ///
  /// [size] حجم الرسم (افتراضي: 150)
  /// [color] لون الرسم (افتراضي: أحمر)
  const ErrorIllustration({
    super.key,
    this.size = 150,
    this.color = const Color(0xFFC62828),
  });

  /// حجم الرسم
  final double size;

  /// لون الرسم
  final Color color;

  @override
  Widget build(BuildContext context) => CustomPaint(
        size: Size(size, size),
        painter: _ErrorPainter(color: color),
      );
}

/// رسام الخطأ
class _ErrorPainter extends CustomPainter {
  _ErrorPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.05
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..color = color.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;

    // رسم دائرة
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.4;

    canvas
      ..drawCircle(center, radius, fillPaint)
      ..drawCircle(center, radius, paint);

    // رسم علامة X
    canvas
      ..drawLine(
        Offset(size.width * 0.35, size.height * 0.35),
        Offset(size.width * 0.65, size.height * 0.65),
        paint,
      )
      ..drawLine(
        Offset(size.width * 0.65, size.height * 0.35),
        Offset(size.width * 0.35, size.height * 0.65),
        paint,
      );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
