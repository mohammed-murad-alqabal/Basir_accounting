import 'package:basir_app/core/theme/app_font_metrics.dart';
import 'package:basir_app/core/theme/font_manager.dart';
import 'package:basir_app/core/widgets/overflow_detector.dart';
import 'package:flutter/material.dart';

/// زر محسّن يحل مشكلة قص واختفاء النصوص.
///
/// يطبق هذا الزر جميع الحلول المطلوبة لمنع قص النصوص:
/// - تخطيط مرن (Flexible/Expanded)
/// - حساب padding ديناميكي حسب textScaleFactor
/// - معالجة RTL الصحيحة
/// - دعم الأيقونات مع النص
/// - line-height ≥ 1.3 لخط Cairo
/// - fontFamilyFallback آمن
/// - كشف overflow في وضع التطوير
///
/// مثال:
/// ```dart
/// AppEnhancedButton(
///   text: 'إضافة عميل جديد',
///   onPressed: () => _addCustomer(),
///   icon: Icons.add,
/// )
/// ```
class AppEnhancedButton extends StatelessWidget {
  /// ينشئ زر محسّن جديد.
  const AppEnhancedButton({
    required this.text,
    required this.onPressed,
    super.key,
    this.icon,
    this.style = AppEnhancedButtonStyle.primary,
    this.size = AppEnhancedButtonSize.medium,
    this.isLoading = false,
    this.isEnabled = true,
    this.maxLines,
    this.textAlign,
    this.tooltip,
    this.semanticLabel,
  });

  /// نص الزر
  final String text;

  /// دالة الضغط
  final VoidCallback? onPressed;

  /// أيقونة اختيارية
  final IconData? icon;

  /// نمط الزر
  final AppEnhancedButtonStyle style;

  /// حجم الزر
  final AppEnhancedButtonSize size;

  /// هل الزر في حالة تحميل
  final bool isLoading;

  /// هل الزر مفعل
  final bool isEnabled;

  /// عدد الأسطر الأقصى للنص
  final int? maxLines;

  /// محاذاة النص
  final TextAlign? textAlign;

  /// نص tooltip
  final String? tooltip;

  /// تسمية للوصول (accessibility)
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(
      context,
    );
    final mediaQuery = MediaQuery.of(
      context,
    );
    final textScaleFactor = mediaQuery.textScaler.scale(
      1,
    );

    // حساب المقاييس المطلوبة
    final fontSize = _getFontSize();
    final fontMetrics = FontMetricsHelper.getCairoMetrics(
      fontSize,
    );
    final padding = fontMetrics.calculatePadding(
      textScaleFactor: textScaleFactor,
      minVerticalPadding: _getMinVerticalPadding(),
      horizontalPadding: _getHorizontalPadding(),
    );
    final minHeight = fontMetrics.calculateMinButtonHeight(
      textScaleFactor: textScaleFactor,
      minHeight: _getMinHeight(),
    );

    // إنشاء TextStyle آمن
    final textStyle = _createSafeTextStyle(
      theme,
      fontSize,
    );

    // بناء محتوى الزر
    var buttonContent = _buildButtonContent(
      textStyle: textStyle,
      textScaleFactor: textScaleFactor,
    );

    // تطبيق OverflowDetector في وضع التطوير
    buttonContent = OverflowDetector(
      name: 'AppEnhancedButton($text)',
      child: buttonContent,
    );

    // بناء الزر النهائي
    var button = _buildButton(
      context: context,
      content: buttonContent,
      padding: padding,
      minHeight: minHeight,
    );

    // إضافة tooltip إذا كان متوفراً
    if (tooltip != null) {
      button = Tooltip(
        message: tooltip,
        child: button,
      );
    }

    // إضافة Semantics للوصول
    return Semantics(
      label: semanticLabel ?? text,
      button: true,
      enabled: _isButtonEnabled(),
      child: button,
    );
  }

  /// يبني محتوى الزر (نص + أيقونة).
  Widget _buildButtonContent({
    required TextStyle textStyle,
    required double textScaleFactor,
  }) {
    // إذا كان في حالة تحميل
    if (isLoading) {
      return _buildLoadingContent(
        textStyle,
      );
    }

    // إذا كان هناك أيقونة
    if (icon != null) {
      return _buildIconTextContent(
        textStyle,
        textScaleFactor,
      );
    }

    // نص فقط
    return _buildTextOnlyContent(
      textStyle,
    );
  }

  /// يبني محتوى التحميل.
  Widget _buildLoadingContent(TextStyle textStyle) {
    final iconSize = _getIconSize();

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: iconSize,
          height: iconSize,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              textStyle.color ?? Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: _buildText(textStyle, 'جاري التحميل...'),
        ),
      ],
    );
  }

  /// يبني محتوى الأيقونة والنص.
  Widget _buildIconTextContent(TextStyle textStyle, double textScaleFactor) {
    final iconSize = _getIconSize() * textScaleFactor;

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: iconSize,
          color: textStyle.color,
        ),
        const SizedBox(width: 8),
        Flexible(
          child: _buildText(textStyle, text),
        ),
      ],
    );
  }

  /// يبني محتوى النص فقط.
  Widget _buildTextOnlyContent(TextStyle textStyle) => _buildText(
        textStyle,
        text,
      );

  /// يبني widget النص مع المعالجة الصحيحة.
  Widget _buildText(TextStyle textStyle, String displayText) => Text(
        displayText,
        style: textStyle,
        maxLines: maxLines,
        softWrap: true,
        overflow: TextOverflow.visible,
        textAlign: textAlign ?? TextAlign.center,
        textDirection: TextDirection.rtl,
      );

  /// يبني الزر النهائي.
  Widget _buildButton({
    required BuildContext context,
    required Widget content,
    required EdgeInsets padding,
    required double minHeight,
  }) {
    final buttonStyle = _createButtonStyle(
      context,
      padding,
      minHeight,
    );

    return ElevatedButton(
      onPressed: _isButtonEnabled() ? onPressed : null,
      style: buttonStyle,
      child: content,
    );
  }

  /// ينشئ ButtonStyle للزر.
  ButtonStyle _createButtonStyle(
    BuildContext context,
    EdgeInsets padding,
    double minHeight,
  ) {
    final theme = Theme.of(
      context,
    );
    final colorScheme = theme.colorScheme;

    // ألوان حسب النمط
    Color backgroundColor;
    Color foregroundColor;
    Color? borderColor;

    switch (style) {
      case AppEnhancedButtonStyle.primary:
        backgroundColor = colorScheme.primary;
        foregroundColor = colorScheme.onPrimary;
        borderColor = null;
      case AppEnhancedButtonStyle.secondary:
        backgroundColor = colorScheme.surface;
        foregroundColor = colorScheme.onSurface;
        borderColor = colorScheme.outline;
      case AppEnhancedButtonStyle.outlined:
        backgroundColor = Colors.transparent;
        foregroundColor = colorScheme.primary;
        borderColor = colorScheme.primary;
      case AppEnhancedButtonStyle.text:
        backgroundColor = Colors.transparent;
        foregroundColor = colorScheme.primary;
        borderColor = null;
      case AppEnhancedButtonStyle.destructive:
        backgroundColor = colorScheme.error;
        foregroundColor = colorScheme.onError;
        borderColor = null;
    }

    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      padding: padding,
      minimumSize: Size(0, minHeight),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: borderColor != null
            ? BorderSide(color: borderColor)
            : BorderSide.none,
      ),
      elevation: style == AppEnhancedButtonStyle.text ? 0 : null,
      animationDuration: const Duration(milliseconds: 200),
    );
  }

  /// ينشئ TextStyle آمن للنص.
  TextStyle _createSafeTextStyle(ThemeData theme, double fontSize) =>
      FontManager.createSafeTextStyle(
        fontSize: fontSize,
        fontWeight: _getFontWeight(),
        color: _getTextColor(theme),
      );

  /// يحصل على حجم الخط حسب حجم الزر.
  double _getFontSize() {
    switch (size) {
      case AppEnhancedButtonSize.small:
        return 14;
      case AppEnhancedButtonSize.medium:
        return 16;
      case AppEnhancedButtonSize.large:
        return 18;
    }
  }

  /// يحصل على وزن الخط.
  FontWeight _getFontWeight() => FontWeight.w600; // SemiBold للوضوح

  /// يحصل على لون النص.
  Color? _getTextColor(ThemeData theme) => null; // يحدد من ButtonStyle

  /// يحصل على الحد الأدنى للـ padding الرأسي.
  double _getMinVerticalPadding() {
    switch (size) {
      case AppEnhancedButtonSize.small:
        return 8;
      case AppEnhancedButtonSize.medium:
        return 12;
      case AppEnhancedButtonSize.large:
        return 16;
    }
  }

  /// يحصل على الـ padding الأفقي.
  double _getHorizontalPadding() {
    switch (size) {
      case AppEnhancedButtonSize.small:
        return 12;
      case AppEnhancedButtonSize.medium:
        return 16;
      case AppEnhancedButtonSize.large:
        return 20;
    }
  }

  /// يحصل على الحد الأدنى للارتفاع.
  double _getMinHeight() {
    switch (size) {
      case AppEnhancedButtonSize.small:
        return 36;
      case AppEnhancedButtonSize.medium:
        return 48;
      case AppEnhancedButtonSize.large:
        return 56;
    }
  }

  /// يحصل على حجم الأيقونة.
  double _getIconSize() {
    switch (size) {
      case AppEnhancedButtonSize.small:
        return 18;
      case AppEnhancedButtonSize.medium:
        return 24;
      case AppEnhancedButtonSize.large:
        return 28;
    }
  }

  /// يتحقق من أن الزر مفعل.
  bool _isButtonEnabled() => isEnabled && !isLoading && onPressed != null;
}

/// أنماط الزر المحسّن.
enum AppEnhancedButtonStyle {
  /// زر أساسي (خلفية ملونة)
  primary,

  /// زر ثانوي (خلفية ملونة مختلفة)
  secondary,

  /// زر بحدود (خلفية شفافة مع حدود)
  outlined,

  /// زر نصي (بدون خلفية أو حدود)
  text,

  /// زر مدمر/خطير (للإجراءات الخطيرة مثل الحذف)
  destructive,
}

/// أحجام الزر المحسّن.
enum AppEnhancedButtonSize {
  /// حجم صغير
  small,

  /// حجم متوسط (افتراضي)
  medium,

  /// حجم كبير
  large,
}

/// مساعدات لإنشاء أزرار محسّنة شائعة.
class AppEnhancedButtonHelper {
  AppEnhancedButtonHelper._();

  /// ينشئ زر 'إضافة' محسّن.
  static AppEnhancedButton add({
    required String text,
    required String tooltip,
    required VoidCallback onPressed,
    AppEnhancedButtonSize size = AppEnhancedButtonSize.medium,
    bool isLoading = false,
  }) =>
      AppEnhancedButton(
        text: text,
        onPressed: onPressed,
        icon: Icons.add,
        size: size,
        isLoading: isLoading,
        tooltip: tooltip,
      );

  /// ينشئ زر 'حفظ' محسّن.
  static AppEnhancedButton save({
    required String text,
    required String tooltip,
    required VoidCallback onPressed,
    AppEnhancedButtonSize size = AppEnhancedButtonSize.medium,
    bool isLoading = false,
  }) =>
      AppEnhancedButton(
        text: text,
        onPressed: onPressed,
        icon: Icons.save,
        size: size,
        isLoading: isLoading,
        tooltip: tooltip,
      );

  /// ينشئ زر 'إلغاء' محسّن.
  static AppEnhancedButton cancel({
    required String text,
    required String tooltip,
    required VoidCallback onPressed,
    AppEnhancedButtonSize size = AppEnhancedButtonSize.medium,
  }) =>
      AppEnhancedButton(
        text: text,
        onPressed: onPressed,
        style: AppEnhancedButtonStyle.outlined,
        size: size,
        tooltip: tooltip,
      );

  /// ينشئ زر 'حذف' محسّن.
  static AppEnhancedButton delete({
    required String text,
    required String tooltip,
    required VoidCallback onPressed,
    AppEnhancedButtonSize size = AppEnhancedButtonSize.medium,
    bool isLoading = false,
  }) =>
      AppEnhancedButton(
        text: text,
        onPressed: onPressed,
        icon: Icons.delete,
        style: AppEnhancedButtonStyle.destructive,
        size: size,
        isLoading: isLoading,
        tooltip: tooltip,
      );

  /// ينشئ زر 'تعديل' محسّن.
  static AppEnhancedButton edit({
    required String text,
    required String tooltip,
    required VoidCallback onPressed,
    AppEnhancedButtonSize size = AppEnhancedButtonSize.medium,
  }) =>
      AppEnhancedButton(
        text: text,
        onPressed: onPressed,
        icon: Icons.edit,
        style: AppEnhancedButtonStyle.secondary,
        size: size,
        tooltip: tooltip,
      );

  /// ينشئ زر 'بحث' محسّن.
  static AppEnhancedButton search({
    required String text,
    required String tooltip,
    required VoidCallback onPressed,
    AppEnhancedButtonSize size = AppEnhancedButtonSize.medium,
  }) =>
      AppEnhancedButton(
        text: text,
        onPressed: onPressed,
        icon: Icons.search,
        style: AppEnhancedButtonStyle.outlined,
        size: size,
        tooltip: tooltip,
      );
}
