import 'package:basir_accounting_system/core/theme/border_contrast_design.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:flutter/material.dart';

/// حقل إدخال نصي موحد (Unified App Text Field)
///
/// حقل نصي متقدم يتبع Design Tokens
/// مع دعم كامل لـ RTL والتحقق من الصحة
///
/// Features:
/// - استخدام InputColors و AppTypography.tokens
/// - دعم RTL ذكي
/// - إخفاء/إظهار كلمة المرور مدمج
/// - امتثال WCAG (Touch target ≥ 44px)
///
/// Example:
/// ```dart
/// AppTextField(
///   label: 'الاسم الكامل',
///   hint: 'أدخل اسمك',
///   onChanged: (v) => print(v),
/// )
/// ```
class AppTextField extends StatefulWidget {
  /// إنشاء حقل إدخال نصي
  const AppTextField({
    required this.label,
    super.key,
    this.hint,
    this.controller,
    this.validator,
    this.keyboardType = <credential-fixture>,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
    this.maxLines = 1,
    this.minLines,
    this.onChanged,
    this.textInputAction,
    this.isEnabled = true,
    this.initialValue,
  });

  /// القيمة الأولية
  final String? initialValue;

  /// تسمية الحقل
  final String label;

  /// نص توضيحي
  final String? hint;

  /// متحكم النص
  final TextEditingController? controller;

  /// دالة التحقق
  final String? Function(String?)? validator;

  /// نوع لوحة المفاتيح
  final TextInputType keyboardType;

  /// إخفاء النص
  final bool obscureText;

  /// أيقونة النهاية
  final Widget? suffixIcon;

  /// أيقونة البداية
  final Widget? prefixIcon;

  /// الحد الأقصى للأسطر
  final int? maxLines;

  /// الحد الأدنى للأسطر
  final int? minLines;

  /// دالة التغيير
  final ValueChanged<String>? onChanged;

  /// إجراء الإدخال
  final TextInputAction? textInputAction;

  /// حالة التفعيل
  final bool isEnabled;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscureText;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return Focus(
      onFocusChange: (focused) => setState(() => _isFocused = focused),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ExcludeSemantics(
            child: Padding(
              padding: const EdgeInsets.only(bottom: Spacing.xs),
              child: Text(
                widget.label,
                style: AppTextStyles.labelLarge.copyWith(
                  color: widget.isEnabled
                      ? (_isFocused
                          ? BorderContrastDesign.getBorderFocused(brightness)
                          : InputColors.label)
                      : AppColors.textDisabled,
                  fontWeight: FontWeights.semiBold,
                ),
              ),
            ),
          ),
          Semantics(
            label: widget.label,
            child: TextFormField(
              controller: widget.controller,
              initialValue: widget.initialValue,
              validator: widget.validator,
              keyboardType: <credential-fixture>,
              obscureText: _obscureText,
              maxLines: widget.obscureText ? 1 : widget.maxLines,
              minLines: widget.minLines,
              onChanged: widget.onChanged,
              textInputAction: widget.textInputAction,
              enabled: widget.isEnabled,
              style: AppTextStyles.bodyLarge.copyWith(
                color: widget.isEnabled
                    ? InputColors.text
                    : AppColors.textDisabled,
              ),
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: AppTextStyles.bodyMedium.copyWith(
                  color: InputColors.placeholder,
                ),
                prefixIcon: widget.prefixIcon != null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.sm,
                        ),
                        child: widget.prefixIcon,
                      )
                    : null,
                suffixIcon: widget.obscureText
                    ? IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          size: IconSizes.md,
                          color: InputColors.label,
                        ),
                        onPressed: () =>
                            setState(() => _obscureText = !_obscureText),
                        constraints: const BoxConstraints(
                          minWidth: TouchTargets.minimum,
                          minHeight: TouchTargets.minimum,
                        ),
                        padding: EdgeInsets.zero,
                      )
                    : widget.suffixIcon,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: Spacing.md,
                  vertical: Spacing.md,
                ),
                filled: true,
                fillColor: widget.isEnabled
                    ? InputColors.background
                    : AppColors.surfaceVariant,
                border: BorderContrastDesign.buildEnhancedInputBorder(
                  color: BorderContrastDesign.getBorderNormal(brightness),
                ),
                enabledBorder: BorderContrastDesign.buildEnhancedInputBorder(
                  color: BorderContrastDesign.getBorderNormal(brightness),
                ),
                focusedBorder: BorderContrastDesign.buildEnhancedInputBorder(
                  color: BorderContrastDesign.getBorderFocused(brightness),
                  width: BorderContrastDesign.borderWidthFocused,
                ),
                errorBorder: BorderContrastDesign.buildEnhancedInputBorder(
                  color: BorderContrastDesign.getBorderError(brightness),
                ),
                focusedErrorBorder:
                    BorderContrastDesign.buildEnhancedInputBorder(
                  color: BorderContrastDesign.getBorderError(brightness),
                  width: BorderContrastDesign.borderWidthError,
                ),
                disabledBorder: BorderContrastDesign.buildEnhancedInputBorder(
                  color: AppColors.borderLight,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// حقل إدخال مخصص للبحث (Unified App Search Field)
class AppSearchField extends StatefulWidget {
  /// إنشاء حقل بحث
  const AppSearchField({
    super.key,
    this.controller,
    this.onChanged,
    this.hint = 'ابحث هنا...',
    this.onClear,
  });

  /// متحكم النص
  final TextEditingController? controller;

  /// دالة التغيير
  final ValueChanged<String>? onChanged;

  /// نص توضيحي
  final String? hint;

  /// دالة المسح
  final VoidCallback? onClear;

  @override
  State<AppSearchField> createState() => _AppSearchFieldState();
}

class _AppSearchFieldState extends State<AppSearchField> {
  late TextEditingController _controller;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _hasText = _controller.text.isNotEmpty;
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onTextChanged() =>
      setState(() => _hasText = _controller.text.isNotEmpty);

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return TextField(
      controller: _controller,
      onChanged: widget.onChanged,
      style: AppTextStyles.bodyLarge,
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
        prefixIcon: const Icon(
          Icons.search,
          size: IconSizes.sm,
          color: AppColors.textSecondary,
        ),
        suffixIcon: _hasText
            ? IconButton(
                icon: const Icon(
                  Icons.clear,
                  size: IconSizes.md,
                  color: AppColors.textSecondary,
                ),
                onPressed: () {
                  _controller.clear();
                  widget.onClear?.call();
                  widget.onChanged?.call('');
                },
                constraints: const BoxConstraints(
                  minWidth: TouchTargets.minimum,
                  minHeight: TouchTargets.minimum,
                ),
                padding: EdgeInsets.zero,
              )
            : null,
        filled: true,
        fillColor: AppColors.surface,
        border: BorderContrastDesign.buildEnhancedInputBorder(
          color: BorderContrastDesign.getBorderNormal(brightness),
          radius: Radii.borderRadiusFull,
        ),
        enabledBorder: BorderContrastDesign.buildEnhancedInputBorder(
          color: BorderContrastDesign.getBorderNormal(brightness),
          radius: Radii.borderRadiusFull,
        ),
        focusedBorder: BorderContrastDesign.buildEnhancedInputBorder(
          color: BorderContrastDesign.getBorderFocused(brightness),
          width: BorderContrastDesign.borderWidthFocused,
          radius: Radii.borderRadiusFull,
        ),
      ),
    );
  }
}
