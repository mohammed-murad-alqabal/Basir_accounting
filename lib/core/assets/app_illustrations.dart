import 'package:basir_app/core/theme/tokens/index.dart';
import 'package:flutter/material.dart';

/// رسم توضيحي للحالة الفارغة بنظام Professional 2.0
class EmptyStateIllustration extends StatelessWidget {
  /// إنشاء رسم توضيحي للحالة الفارغة
  const EmptyStateIllustration({
    super.key,
    this.size = 250,
    this.isCustomers = false,
  });

  /// حجم الرسم التوضيحي
  final double size;

  /// هل الرسم لمستخدمي قاعدة البيانات
  final bool isCustomers;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: size,
              height: size,
              child: CustomPaint(
                painter: _Professional2IllustrationPainter(
                  isCustomers: isCustomers,
                  themeColor: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: Spacing.xl),
            Text(
              isCustomers
                  ? 'قاعدة بيانات العملاء جاهزة'
                  : 'سجل الفواتير الذكي منظم',
              style: const TextStyle(
                fontSize: AppTypography.titleMedium,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Spacing.xs),
            Text(
              isCustomers
                  ? 'ابدأ بإضافة أول شريك نجاح لك'
                  : 'فاتورتك الأولى بانتظارك',
              style: const TextStyle(
                fontSize: AppTypography.bodyMedium,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
}

/// رسم توضيحي للأونبوردينج بنظام Professional 2.0
class OnboardingIllustration extends StatelessWidget {
  /// إنشاء رسم توضيحي للأونبوردينج
  const OnboardingIllustration({
    required this.index,
    super.key,
    this.size = 300,
  });

  /// مؤشر شريحة العرض (Slide Index)
  final int index;

  /// حجم الرسم التوضيحي
  final double size;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: _Professional2IllustrationPainter(
            index: index,
            isOnboarding: true,
            themeColor: index == 0 ? AppColors.primary : AppColors.secondary,
          ),
        ),
      );
}

/// رسم توضيحي لحالة الخطأ بنظام Professional 2.0
class ErrorIllustration extends StatelessWidget {
  /// إنشاء رسم توضيحي لحالة الخطأ
  const ErrorIllustration({super.key, this.size = 150});

  /// حجم الرسم التوضيحي
  final double size;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: _Professional2IllustrationPainter(
            isError: true,
            themeColor: AppColors.error,
          ),
        ),
      );
}

/// رسم توضيحي لحالة النجاح بنظام Professional 2.0
class SuccessIllustration extends StatelessWidget {
  /// إنشاء رسم توضيحي لحالة النجاح
  const SuccessIllustration({super.key, this.size = 150});

  /// حجم الرسم التوضيحي
  final double size;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: _Professional2IllustrationPainter(
            isSuccess: true,
            themeColor: AppColors.success,
          ),
        ),
      );
}

class _Professional2IllustrationPainter extends CustomPainter {
  _Professional2IllustrationPainter({
    required this.themeColor,
    this.isCustomers = false,
    this.index = 0,
    this.isOnboarding = false,
    this.isError = false,
    this.isSuccess = false,
  });

  /// لون الثيم المطبق (Primary/Secondary)
  final Color themeColor;

  /// هل الرسم يمثل حالة خطأ
  final bool isError;

  /// هل الرسم يمثل حالة نجاح
  final bool isSuccess;

  /// هل الرسم لمستخدمي قاعدة البيانات
  final bool isCustomers;

  /// مؤشر شريحة العرض
  final int index;

  /// هل الرسم للاستخدام في الأونبوردينج
  final bool isOnboarding;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final drawRadius = size.width * 0.4;

    // 1. نظام الشبكة اللامتناهي (Infinite Data Lattice)
    final gridPaint = Paint()
      ..color = themeColor.withValues(alpha: 0.03)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (var i = 0; i <= 10; i++) {
      canvas.drawLine(
        Offset(0, size.height * (i / 10)),
        Offset(size.width, size.height * (i / 10)),
        gridPaint,
      );
      canvas.drawLine(
        Offset(size.width * (i / 10), 0),
        Offset(size.width * (i / 10), size.height),
        gridPaint,
      );
    }

    // 2. الهالة المحيطة (Professional Aura)
    final auraPaint = Paint()
      ..shader = RadialGradient(
        colors: [themeColor.withValues(alpha: 0.1), Colors.transparent],
      ).createShader(Rect.fromCircle(center: center, radius: size.width / 2));
    canvas.drawCircle(center, size.width / 2, auraPaint);

    if (isOnboarding) {
      _paintOnboarding(canvas, size, center, drawRadius);
    } else if (isError) {
      _paintStatus(canvas, center, drawRadius, Icons.error_outline_rounded);
    } else if (isSuccess) {
      _paintStatus(
        canvas,
        center,
        drawRadius,
        Icons.check_circle_outline_rounded,
      );
    } else {
      _paintEmptyState(canvas, size, center, drawRadius);
    }
  }

  void _paintStatus(
    Canvas canvas,
    Offset center,
    double radius,
    IconData icon,
  ) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontSize: radius * 1.5,
          fontFamily: icon.fontFamily,
          package: icon.fontPackage,
          color: themeColor,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      center - Offset(textPainter.width / 2, textPainter.height / 2),
    );
  }

  void _paintEmptyState(
    Canvas canvas,
    Size size,
    Offset center,
    double radius,
  ) {
    final mainPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [themeColor, themeColor.withValues(alpha: 0.6)],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    if (isCustomers) {
      // تمثيل هندسي للعملاء (User Node)
      canvas.drawCircle(
        Offset(center.dx, center.dy - radius * 0.2),
        radius * 0.3,
        mainPaint,
      );
      final path = Path()
        ..moveTo(center.dx - radius * 0.6, center.dy + radius * 0.5)
        ..quadraticBezierTo(
          center.dx,
          center.dy - radius * 0.1,
          center.dx + radius * 0.6,
          center.dy + radius * 0.5,
        )
        ..lineTo(center.dx + radius * 0.6, center.dy + radius * 0.7)
        ..lineTo(center.dx - radius * 0.6, center.dy + radius * 0.7)
        ..close();
      canvas.drawPath(path, mainPaint);
    } else {
      // تمثيل هندسي للفاتورة (Ledger Document)
      final rect = Rect.fromCenter(
        center: center,
        width: radius * 0.8,
        height: radius * 1.1,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(Radii.md)),
        mainPaint,
      );

      final linePaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.5)
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round;

      for (var i = 0; i < 3; i++) {
        canvas.drawLine(
          Offset(
            center.dx - radius * 0.25,
            center.dy - radius * 0.2 + (i * 15),
          ),
          Offset(
            center.dx + radius * 0.25,
            center.dy - radius * 0.2 + (i * 15),
          ),
          linePaint,
        );
      }
    }
  }

  void _paintOnboarding(
    Canvas canvas,
    Size size,
    Offset center,
    double radius,
  ) {
    if (index == 0) {
      // Slide 1: تنظيم (Structure) - استخدام مكعبات البيانات
      for (var i = 0; i < 3; i++) {
        final rect = Rect.fromLTWH(
          center.dx - radius * 0.4 + (i * 20),
          center.dy - radius * 0.4 + (i * 20),
          radius * 0.6,
          radius * 0.6,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, const Radius.circular(Radii.sm)),
          Paint()..color = themeColor.withValues(alpha: 1.0 - (i * 0.3)),
        );
      }
    } else {
      // Slide 2: فوترة (Flow) - استخدام تمثيل تدفق الأموال
      final path = Path()
        ..moveTo(center.dx - radius, center.dy + radius * 0.3)
        ..cubicTo(
          center.dx - radius * 0.5,
          center.dy - radius * 0.8,
          center.dx + radius * 0.5,
          center.dy + radius * 0.8,
          center.dx + radius,
          center.dy - radius * 0.3,
        );
      canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 10
          ..strokeCap = StrokeCap.round
          ..shader = LinearGradient(
            colors: [themeColor, Colors.white],
          ).createShader(Rect.fromCircle(center: center, radius: radius)),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
