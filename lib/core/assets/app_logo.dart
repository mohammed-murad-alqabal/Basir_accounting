import 'dart:async';

import 'package:basir_app/core/theme/tokens/index.dart';
import 'package:flutter/material.dart';

/// شعار بصير (Basir Logo)
///
/// يعرض شعار التطبيق المعتمد (صورة + نص اختياري).
class BasirLogo extends StatelessWidget {
  /// إنشاء الشعار
  const BasirLogo({super.key, this.size = 120, this.useText = false});

  /// حجم الشعار
  final double size;

  /// هل يظهر اسم التطبيق بجانب الشعار (اختياري)
  final bool useText;

  @override
  Widget build(BuildContext context) {
    // استخدام الصورة المعتمدة بدلاً من الرسم اليدوي
    final logoImage = Image.asset(
      'assets/images/basir_logo.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
    );

    if (useText) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          logoImage,
          const SizedBox(width: Spacing.md),
          Text(
            'بصير',
            style: TextStyle(
              fontSize: size * 0.35,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
              fontFamily: 'Cairo',
              letterSpacing: 1.2,
            ),
          ),
        ],
      );
    }
    return logoImage;
  }
}

/// أيقونة بصير المبسطة (Basir Icon)
class BasirIcon extends StatelessWidget {
  /// إنشاء أيقونة بصير
  const BasirIcon({super.key, this.size = 24});

  /// حجم الأيقونة
  final double size;

  @override
  Widget build(BuildContext context) => Image.asset(
        'assets/icons/app_icon.png',
        width: size,
        height: size,
        fit: BoxFit.contain,
      );
}

/// شعار بصير اللامع (Basir Shimmer Logo)
class BasirShimmerLogo extends StatefulWidget {
  /// إنشاء شعار بصير اللامع
  const BasirShimmerLogo({super.key, this.size = 100});

  /// حجم الشعار
  final double size;

  @override
  State<BasirShimmerLogo> createState() => _BasirShimmerLogoState();
}

// ignore: lines_longer_than_80_chars
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
          // ignore: lines_longer_than_80_chars
          shaderCallback: (bounds) =>
              _createGradient(bounds).createShader(bounds),
          blendMode: BlendMode.srcATop,
          child: BasirLogo(size: widget.size),
        ),
      );

  LinearGradient _createGradient(Rect bounds) => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: const [0.0, 0.5, 1.0],
        colors: [
          Colors.transparent,
          Colors.white.withValues(alpha: 0.3),
          Colors.transparent,
        ],
        transform: _SlidingGradientTransform(offset: _controller.value),
      );
}

class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform({required this.offset});

  final double offset;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) =>
      Matrix4.translationValues(bounds.width * (offset * 2 - 1), 0, 0);
}
