/// شعار تطبيق بصير المخصص
///
/// يحتوي على widget مخصص لعرض شعار التطبيق
/// بدلاً من استخدام Material Icons
library;

import 'package:flutter/material.dart';

/// شعار تطبيق بصير
///
/// widget مخصص يعرض شعار التطبيق بتصميم احترافي
/// يمثل فاتورة مع علامة صح (✓) للدلالة على الدقة والاحترافية
class BasserLogo extends StatelessWidget {
  /// إنشاء شعار بصير
  ///
  /// [size] حجم الشعار (افتراضي: 80)
  /// [color] لون الشعار (افتراضي: أبيض)
  const BasserLogo({super.key, this.size = 80, this.color = Colors.white});

  /// حجم الشعار
  final double size;

  /// لون الشعار
  final Color color;

  @override
  Widget build(BuildContext context) => CustomPaint(
        size: Size(size, size),
        painter: _BasserLogoPainter(color: color),
      );
}

/// رسام شعار بصير المخصص
class _BasserLogoPainter extends CustomPainter {
  _BasserLogoPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.04
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // رسم الفاتورة (مستطيل مع حواف مدورة)
    final invoiceRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.15,
        size.height * 0.1,
        size.width * 0.7,
        size.height * 0.8,
      ),
      Radius.circular(size.width * 0.05),
    );
    canvas.drawRRect(
      invoiceRect,
      paint,
    );

    // رسم خطوط الفاتورة (3 خطوط أفقية)
    final lineY1 = size.height * 0.3;
    final lineY2 = size.height * 0.45;
    final lineY3 = size.height * 0.6;
    final lineStartX = size.width * 0.25;
    final lineEndX = size.width * 0.75;

    canvas
      ..drawLine(Offset(lineStartX, lineY1), Offset(lineEndX, lineY1), paint)
      ..drawLine(
        Offset(lineStartX, lineY2),
        Offset(lineEndX * 0.9, lineY2),
        paint,
      )
      ..drawLine(
        Offset(lineStartX, lineY3),
        Offset(lineEndX * 0.8, lineY3),
        paint,
      );

    // رسم علامة الصح (✓) في الزاوية السفلية اليمنى
    final checkPath = Path()
      ..moveTo(size.width * 0.65, size.height * 0.75)
      ..lineTo(size.width * 0.7, size.height * 0.8)
      ..lineTo(
        size.width * 0.8,
        size.height * 0.65,
      );

    canvas.drawPath(
      checkPath,
      paint,
    );

    // رسم دائرة خلف علامة الصح
    canvas.drawCircle(
      Offset(size.width * 0.725, size.height * 0.725),
      size.width * 0.12,
      fillPaint,
    );

    // إعادة رسم علامة الصح بلون معاكس
    final checkPaintWhite = Paint()
      ..color = color == Colors.white ? const Color(0xFF0056B3) : Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.05
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(
      checkPath,
      checkPaintWhite,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// أيقونة بصير المبسطة
///
/// نسخة مبسطة من الشعار للاستخدام في الأماكن الصغيرة
class BasserIcon extends StatelessWidget {
  /// إنشاء أيقونة بصير
  ///
  /// [size] حجم الأيقونة (افتراضي: 24)
  /// [color] لون الأيقونة (افتراضي: أبيض)
  const BasserIcon({super.key, this.size = 24, this.color = Colors.white});

  /// حجم الأيقونة
  final double size;

  /// لون الأيقونة
  final Color color;

  @override
  Widget build(BuildContext context) => CustomPaint(
        size: Size(size, size),
        painter: _BasserIconPainter(color: color),
      );
}

/// رسام أيقونة بصير المبسطة
class _BasserIconPainter extends CustomPainter {
  _BasserIconPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.08
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // رسم مستطيل مبسط (الفاتورة)
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.1,
        size.height * 0.1,
        size.width * 0.8,
        size.height * 0.8,
      ),
      Radius.circular(size.width * 0.1),
    );
    canvas.drawRRect(
      rect,
      paint,
    );

    // رسم علامة الصح
    final checkPath = Path()
      ..moveTo(size.width * 0.3, size.height * 0.5)
      ..lineTo(size.width * 0.45, size.height * 0.65)
      ..lineTo(
        size.width * 0.7,
        size.height * 0.35,
      );

    canvas.drawPath(
      checkPath,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
