import 'package:basser_app/core/assets/app_logo.dart';
import 'package:basser_app/core/theme/tokens/index.dart';
import 'package:flutter/material.dart';

/// رأس لوحة التحكم المطور (Mastery Premium Header)
class DashboardMasteryHeader extends StatelessWidget {
  /// إنشاء رأس لوحة التحكم
  const DashboardMasteryHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Spacing.xl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryColor,
            primaryColor.withValues(alpha: 0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(Radii.lg),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: const Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'نظام بصير المطور',
                  style: TextStyle(
                    color: Color(0xFFFFD700),
                    fontSize: FontSizes.labelSmall,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: Spacing.xs),
                Text(
                  'أهلاً بك في فضاء الإتقان',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: FontSizes.headlineSmall,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: Spacing.xs),
                Text(
                  'بصير يراقب نمو أعمالك بدقة (Φ)',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: FontSizes.bodySmall,
                  ),
                ),
              ],
            ),
          ),
          BasserShimmerLogo(size: 60),
        ],
      ),
    );
  }
}

/// بطاقة إحصائية زجاجية (Glassmorphic Stat Card)
class GlassStatCard extends StatelessWidget {
  /// إنشاء بطاقة إحصائية زجاجية
  const GlassStatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    super.key,
  });

  /// عنوان الإحصائية
  final String label;

  /// قيمة الإحصائية
  final String value;

  /// أيقونة الإحصائية
  final IconData icon;

  /// لون السمة (Theme Color)
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: SemanticColors.surface.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(Radii.md),
          border: Border.all(
            color: color.withValues(alpha: 0.2),
            width: 1.5,
          ),
        ),
        padding: const EdgeInsets.all(Spacing.md),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(Spacing.xs),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: Spacing.xs),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  style: const TextStyle(
                    color: SemanticColors.textSecondary,
                    fontSize: 11,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 2),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  value,
                  style: const TextStyle(
                    color: SemanticColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
