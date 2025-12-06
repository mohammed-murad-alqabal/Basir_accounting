import 'package:basser_app/core/theme/app_colors.dart';
import 'package:basser_app/core/theme/app_font_metrics.dart';
import 'package:flutter/material.dart';

/// زر محسّن يحل مشكلة قص واختفاء النصوص
///
/// يستخدم تخطيط مرن (Flexible/Expanded) ويحسب padding ديناميكياً
/// لضمان عرض النص بالكامل بدون قص في جميع الحالات.
///
/// **الميزات:**
/// - تخطيط مرن يتكيف مع طول النص
/// - حساب padding ديناميكي حسب textScaleFactor
/// - معالجة RTL صحيحة
/// - دعم الأيقونات مع النص
/// - line-height مناسب لخط Cairo (≥ 1.3)
/// - خط fallback آمن (Cairo → Roboto → Arial)
/// - لا قص للنص (overflow: visible)
///
/// **مثال:**
/// ```dart
/// AppEnhancedButton(
///   text: 'تسجيل الدخول',
///   onPressed: () {},
///   type: AppEnhancedButtonType.primary,
/// )
/// ```
class AppEnhancedButton extends StatelessWidget {
  /// ينشئ زر محسّن جديد.
  ///
  /// [text] نص الزر المطلوب عرضه.
  /// [onPressed] الدالة التي يتم استدعاؤها عند الضغط على الزر.
  /// [type] نوع الزر (primary, secondary, text).
  /// [icon] أيقونة اختيارية تظهر قبل النص.
  /// [iconSize] حجم الأيقونة (افتراضي: 20).
  /// [iconSpacing] المسافة بين الأيقونة والنص (افتراضي: 8).
  const AppEnhancedButton({
    required this.text,
    required this.onPressed,
    super.key,
    this.type = AppEnhancedButtonType.primary,
    this.icon,
    this.iconSize = 20,
    this.iconSpacing = 8,
    this.isLoading = false,
    this.width,
    this.minHeight,
  });

  /// نص الزر
  final String text;

  /// دالة يتم استدعاؤها عند الضغط على الزر
  final VoidCallback? onPressed;

  /// نوع الزر (primary, secondary, text)
  final AppEnhancedButtonType type;

  /// أيقونة اختيارية تظهر قبل النص
  final IconData? icon;

  /// حجم الأيقونة (افتراضي: 20)
  final double iconSize;

  /// المسافة بين الأيقونة والنص (افتراضي: 8)
  final double iconSpacing;

  /// هل الزر في حالة تحميل؟
  final bool isLoading;

  /// عرض الزر (null = يتكيف مع المحتوى)
  final double? width;

  /// ارتفاع الزر الأدنى (افتراضي: يُحسب تلقائياً)
  final double? minHeight;

  @override
  Widget build(BuildContext context) {
    // الحصول على textScaler من MediaQuery
    final textScaler = MediaQuery.textScalerOf(context);
    final textScaleFactor = textScaler.scale(1);

    // الحصول على مقاييس الخط لـ Cairo
    final fontMetrics = AppFontMetrics.cairo(_getFontSize());

    // حساب الارتفاع الأدنى المطلوب
    final calculatedMinHeight = minHeight ??
        fontMetrics.calculateMinButtonHeight(
          textScaleFactor: textScaleFactor,
        );

    // حساب padding الرأسي
    final verticalPaddingEdgeInsets = fontMetrics.calculateVerticalPadding(
      textScaleFactor: textScaleFactor,
    );
    final verticalPadding = verticalPaddingEdgeInsets.top;

    // حساب padding الأفقي (أكبر قليلاً)
    final horizontalPadding = verticalPadding * 1.5;

    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: _getButtonStyle(
          context,
          calculatedMinHeight,
          verticalPadding,
          horizontalPadding,
        ),
        child: isLoading
            ? _buildLoadingIndicator()
            : _buildContent(context, fontMetrics),
      ),
    );
  }

  /// بناء محتوى الزر (أيقونة + نص)
  Widget _buildContent(BuildContext context, AppFontMetrics fontMetrics) {
    // إذا لم يكن هناك أيقونة، نعرض النص فقط
    if (icon == null) {
      return _buildText(context, fontMetrics);
    }

    // إذا كان هناك أيقونة، نستخدم Row مع Flexible
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: iconSize,
          color: _getIconColor(context),
        ),
        SizedBox(width: iconSpacing),
        Flexible(
          child: _buildText(context, fontMetrics),
        ),
      ],
    );
  }

  /// بناء widget النص
  Widget _buildText(BuildContext context, AppFontMetrics fontMetrics) => Text(
        text,
        textAlign: TextAlign.center,
        textDirection: TextDirection.rtl,
        style: fontMetrics.toTextStyle(
          fontWeight: FontWeight.w600,
          color: _getTextColor(context),
        ),
        // السماح بالتفاف النص على عدة أسطر
        softWrap: true,
        // عدم قص النص
        overflow: TextOverflow.visible,
      );

  /// بناء مؤشر التحميل
  Widget _buildLoadingIndicator() => SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            type == AppEnhancedButtonType.primary
                ? Colors.white
                : AppColors.primary,
          ),
        ),
      );

  /// الحصول على ButtonStyle حسب نوع الزر
  ButtonStyle _getButtonStyle(
    BuildContext context,
    double minHeight,
    double verticalPadding,
    double horizontalPadding,
  ) {
    switch (type) {
      case AppEnhancedButtonType.primary:
        return _getPrimaryButtonStyle(
          context,
          minHeight,
          verticalPadding,
          horizontalPadding,
        );
      case AppEnhancedButtonType.secondary:
        return _getSecondaryButtonStyle(
          context,
          minHeight,
          verticalPadding,
          horizontalPadding,
        );
      case AppEnhancedButtonType.text:
        return _getTextButtonStyle(
          context,
          minHeight,
          verticalPadding,
          horizontalPadding,
        );
    }
  }

  /// Primary button style
  ButtonStyle _getPrimaryButtonStyle(
    BuildContext context,
    double minHeight,
    double verticalPadding,
    double horizontalPadding,
  ) =>
      ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.5),
        disabledForegroundColor: AppColors.onPrimary.withValues(alpha: 0.5),
        minimumSize: Size(88, minHeight),
        padding: EdgeInsets.symmetric(
          vertical: verticalPadding,
          horizontal: horizontalPadding,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 2,
      );

  /// Secondary button style
  ButtonStyle _getSecondaryButtonStyle(
    BuildContext context,
    double minHeight,
    double verticalPadding,
    double horizontalPadding,
  ) =>
      ElevatedButton.styleFrom(
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.onSecondary,
        disabledBackgroundColor: AppColors.secondary.withValues(alpha: 0.5),
        disabledForegroundColor: AppColors.onSecondary.withValues(alpha: 0.5),
        minimumSize: Size(88, minHeight),
        padding: EdgeInsets.symmetric(
          vertical: verticalPadding,
          horizontal: horizontalPadding,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 1,
      );

  /// Text button style
  ButtonStyle _getTextButtonStyle(
    BuildContext context,
    double minHeight,
    double verticalPadding,
    double horizontalPadding,
  ) =>
      ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.primary,
        disabledForegroundColor: AppColors.primary.withValues(alpha: 0.5),
        minimumSize: Size(88, minHeight),
        padding: EdgeInsets.symmetric(
          vertical: verticalPadding,
          horizontal: horizontalPadding,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 0,
      );

  /// الحصول على حجم الخط حسب نوع الزر
  double _getFontSize() {
    switch (type) {
      case AppEnhancedButtonType.primary:
      case AppEnhancedButtonType.secondary:
        return 17;
      case AppEnhancedButtonType.text:
        return 16;
    }
  }

  /// الحصول على لون النص حسب نوع الزر
  Color _getTextColor(BuildContext context) {
    switch (type) {
      case AppEnhancedButtonType.primary:
        return AppColors.onPrimary;
      case AppEnhancedButtonType.secondary:
        return AppColors.onSecondary;
      case AppEnhancedButtonType.text:
        return AppColors.primary;
    }
  }

  /// الحصول على لون الأيقونة حسب نوع الزر
  Color _getIconColor(BuildContext context) => _getTextColor(context);
}

/// أنواع الأزرار المحسّنة
enum AppEnhancedButtonType {
  /// زر أساسي (خلفية ملونة)
  primary,

  /// زر ثانوي (خلفية فاتحة)
  secondary,

  /// زر نصي (بدون خلفية)
  text,
}
