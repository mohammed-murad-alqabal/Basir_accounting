import 'package:flutter/material.dart';

/// Extension for Glassmorphism Design Tokens
/// Source: artistic_vision_blueprint.md
class GlassTheme extends ThemeExtension<GlassTheme> {
  const GlassTheme({
    required this.glassColor,
    required this.glassBorder,
    required this.blurSigma,
    required this.primaryGradient,
    required this.surfaceOpacity,
  });

  factory GlassTheme.light() => const GlassTheme(
        glassColor: Colors.white,
        glassBorder: Color(0xFFE5E7EB), // Gray 200
        blurSigma: 16,
        primaryGradient: LinearGradient(
          colors: [Color(0xFF006D77), Color(0xFF83C5BE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        surfaceOpacity: 0.75,
      );

  factory GlassTheme.dark() => const GlassTheme(
        glassColor: Color(0xFF111827), // Gray 900
        glassBorder: Color(0xFF374151), // Gray 700
        blurSigma: 24,
        primaryGradient: LinearGradient(
          colors: [
            Color(0xFF0F766E),
            Color(0xFF2DD4BF)
          ], // Teal 700 -> Teal 400
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        surfaceOpacity: 0.65,
      );

  final Color glassColor;
  final Color glassBorder;
  final double blurSigma;
  final LinearGradient primaryGradient;
  final double surfaceOpacity;

  @override
  GlassTheme copyWith({
    Color? glassColor,
    Color? glassBorder,
    double? blurSigma,
    LinearGradient? primaryGradient,
    double? surfaceOpacity,
  }) =>
      GlassTheme(
        glassColor: glassColor ?? this.glassColor,
        glassBorder: glassBorder ?? this.glassBorder,
        blurSigma: blurSigma ?? this.blurSigma,
        primaryGradient: primaryGradient ?? this.primaryGradient,
        surfaceOpacity: surfaceOpacity ?? this.surfaceOpacity,
      );

  @override
  GlassTheme lerp(ThemeExtension<GlassTheme>? other, double t) {
    if (other is! GlassTheme) return this;
    return GlassTheme(
      glassColor: Color.lerp(glassColor, other.glassColor, t)!,
      glassBorder: Color.lerp(glassBorder, other.glassBorder, t)!,
      blurSigma: blurSigma + (other.blurSigma - blurSigma) * t,
      primaryGradient:
          LinearGradient.lerp(primaryGradient, other.primaryGradient, t)!,
      surfaceOpacity:
          surfaceOpacity + (other.surfaceOpacity - surfaceOpacity) * t,
    );
  }
}

// Global Design Constants
class GlassMetrics {
  static const double borderRadius = 20;
  static const double borderStart = 1;
  static const Duration animationDuration = Duration(milliseconds: 600);
  static const Curve animationCurve = Curves.easeOutQuart; // Spring-like
}
