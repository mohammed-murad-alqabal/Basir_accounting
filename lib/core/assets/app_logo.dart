import 'dart:async';

import 'package:basser_app/core/theme/tokens/index.dart';
import 'package:flutter/material.dart';

/// شعار بصير المطور بنظام Mastery 2.0
///
/// يعتمد على الهندسة الرياضية والنسبة الذهبية (1.618) للتوازن المثالي.
/// الشعار يمثل "عدسة البصيرة التقنية" والنمو المالي الرقمي.
class BasirLogo extends StatelessWidget {
  /// إنشاء شعار بصير
  const BasirLogo({
    super.key,
    this.size = 120,
    this.useText = false,
  });

  /// حجم الشعار
  final double size;

  /// هل يظهر اسم التطبيق بجانب الشعار (اختياري)
  final bool useText;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    if (useText) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLogo(primaryColor),
          const SizedBox(
              width: 16), // Using fixed spacing instead of Spacing.md
          Text(
            'بصير',
            style: TextStyle(
              fontSize: size * 0.35,
              fontWeight: FontWeight.bold,
              color: primaryColor,
              fontFamily: 'Cairo',
              letterSpacing: 1.2,
            ),
          ),
        ],
      );
    }
    return _buildLogo(primaryColor);
  }

  Widget _buildLogo(Color primaryColor) => SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: _BasirMastery2Painter(primaryColor: primaryColor),
        ),
      );
}

class _BasirMastery2Painter extends CustomPainter {
  _BasirMastery2Painter({required this.primaryColor});

  final Color primaryColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final baseRadius = size.width * 0.45;

    // استخدام النسبة الذهبية للفصل بين العناصر
    const goldenRatio = 1.61803398875;
    final lensRadius = baseRadius / goldenRatio;
    final coreRadius = lensRadius / goldenRatio;

    // 1. رسم التوهج الخلفي (Environmental Ambience)
    final ambientPaint = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20)
      ..color = primaryColor.withValues(alpha: 0.15);
    canvas.drawCircle(center, baseRadius, ambientPaint);

    // 2. الهيكل الخارجي (Institutional Foundation)
    final ringPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          primaryColor.withValues(alpha: 0.9),
          primaryColor,
          primaryColor.withValues(alpha: 0.8),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: baseRadius));

    canvas.drawCircle(center, baseRadius, ringPaint);

    // 3. حلقات البيانات الذهبية (Golden insight Rings)
    final orbitPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = const Color(0xFFFFD700).withValues(alpha: 0.4); // Gold Accent

    for (var i = 1; i <= 3; i++) {
      final r = lensRadius + (i * (baseRadius - lensRadius) / 4);
      canvas.drawCircle(center, r, orbitPaint);
    }

    // 4. عدسة البصيرة المركزية (Glassmorphic Core Lens)
    // طبقة الزجاج
    final glassPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withValues(alpha: 0.4),
          Colors.white.withValues(alpha: 0.1),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: lensRadius));

    canvas.drawCircle(center, lensRadius, glassPaint);

    // حدود العدسة المتألقة
    final edgePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..shader = const LinearGradient(
        colors: [Color(0xFFFFD700), Colors.white, Color(0xFFFFD700)],
      ).createShader(Rect.fromCircle(center: center, radius: lensRadius));
    canvas.drawCircle(center, lensRadius, edgePaint);

    // 5. مسار النمو المالي (Growth Trajectory)
    final growthPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.06
      ..strokeCap = StrokeCap.round
      ..shader = LinearGradient(
        colors: [
          Colors.white.withValues(alpha: 0.9),
          const Color(0xFFFFD700).withValues(alpha: 0.8),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final growthPath = Path()
      ..moveTo(center.dx - coreRadius * 1.2, center.dy + coreRadius * 0.5)
      ..lineTo(center.dx - coreRadius * 0.3, center.dy - coreRadius * 0.2)
      ..lineTo(center.dx + coreRadius * 0.3, center.dy + coreRadius * 0.3)
      ..lineTo(center.dx + coreRadius * 1.5, center.dy - coreRadius * 1.0);

    // إضافة ظل للمسار
    canvas.drawPath(
      growthPath,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = growthPaint.strokeWidth
        ..strokeCap = StrokeCap.round
        ..color = Colors.black.withValues(alpha: 0.2)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );

    canvas.drawPath(growthPath, growthPaint);

    // 6. مؤشر الارتفاع (The Pinnacle Spark)
    final sparkPaint = Paint()
      ..color = Colors.white
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawCircle(
      Offset(center.dx + coreRadius * 1.5, center.dy - coreRadius * 1.0),
      4,
      sparkPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// أيقونة بصير المبسطة (Mastery 2.0 Icon)
class BasirIcon extends StatelessWidget {
  /// إنشاء أيقونة بصير
  const BasirIcon({super.key, this.size = 24});

  /// حجم الأيقونة
  final double size;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _BasirMastery2Painter(primaryColor: primaryColor),
      ),
    );
  }
}

/// شعار بصير مع تأثير "اللمعان المؤسسي" (Institutional Shimmer)
class BasirShimmerLogo extends StatefulWidget {
  /// إنشاء شعار بصير اللامع
  const BasirShimmerLogo({super.key, this.size = 100});

  /// حجم الشعار
  final double size;

  @override
  State<BasirShimmerLogo> createState() => _BasirShimmerLogoState();
}

class _BasirShimmerLogoState extends State<BasirShimmerLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    unawaited(_controller.repeat());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0.0, 0.5, 1.0],
            colors: [
              Colors.transparent,
              Colors.white.withValues(alpha: 0.3),
              Colors.transparent,
            ],
            transform: _SlidingGradientTransform(offset: _controller.value),
          ).createShader(bounds),
          blendMode: BlendMode.srcATop,
          child: BasirLogo(size: widget.size),
        ),
      );
}

class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform({required this.offset});

  final double offset;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) =>
      Matrix4.translationValues(bounds.width * (offset * 2 - 1), 0, 0);
}
