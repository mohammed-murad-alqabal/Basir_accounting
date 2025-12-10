import 'package:basser_app/core/theme.dart';
import 'package:flutter/material.dart';

/// حقل إدخال نصي مخصص مع دعم RTL
///
/// حقل نصي متقدم يدعم اللغة العربية والإنجليزية
/// مع ميزات إضافية مثل إخفاء/إظهار كلمة المرور
///
/// Features:
/// - دعم كامل لـ RTL (من اليمين لليسار)
/// - إخفاء/إظهار كلمة المرور تلقائياً
/// - تسمية واضحة فوق الحقل
/// - تحقق من الصحة (Validation)
/// - أيقونات قابلة للتخصيص
/// - أنواع لوحة مفاتيح متعددة
///
/// Example:
/// ```dart
/// AppTextField(
///   label: 'البريد الإلكتروني',
///   hint: 'أدخل بريدك الإلكتروني',
///   keyboardType: <credential-fixture>,
///   validator: (value) => value?.isEmpty ?? true ? 'مطلوب' : null,
/// )
/// ```
class AppTextField extends StatefulWidget {
  /// إنشاء حقل إدخال نصي
  ///
  /// Parameters:
  /// - [label]: تسمية الحقل (مطلوب)
  /// - [hint]: نص توضيحي داخل الحقل (اختياري)
  /// - [controller]: متحكم النص (اختياري)
  /// - [validator]: دالة التحقق من الصحة (اختياري)
  /// - [keyboardType]: نوع لوحة المفاتيح (افتراضي: text)
  /// - [obscureText]: إخفاء النص (للكلمات السرية) (افتراضي: false)
  /// - [suffixIcon]: أيقونة في نهاية الحقل (اختياري)
  /// - [prefixIcon]: أيقونة في بداية الحقل (اختياري)
  /// - [maxLines]: الحد الأقصى للأسطر (افتراضي: 1)
  /// - [minLines]: الحد الأدنى للأسطر (اختياري)
  /// - [onChanged]: دالة تُستدعى عند تغيير النص (اختياري)
  /// - [textInputAction]: إجراء زر الإدخال (اختياري)
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
  });

  /// تسمية الحقل المعروضة فوقه
  final String label;

  /// نص توضيحي يظهر داخل الحقل عندما يكون فارغاً
  final String? hint;

  /// متحكم النص للتحكم في قيمة الحقل
  final TextEditingController? controller;

  /// دالة التحقق من صحة المدخلات
  /// تُرجع رسالة خطأ أو null إذا كانت القيمة صحيحة
  final String? Function(String?)? validator;

  /// نوع لوحة المفاتيح المعروضة
  final TextInputType keyboardType;

  /// إخفاء النص (يُستخدم لكلمات المرور)
  /// يضيف زر إظهار/إخفاء تلقائياً
  final bool obscureText;

  /// أيقونة في نهاية الحقل (يمين في LTR، يسار في RTL)
  final Widget? suffixIcon;

  /// أيقونة في بداية الحقل (يسار في LTR، يمين في RTL)
  final Widget? prefixIcon;

  /// الحد الأقصى لعدد الأسطر
  final int? maxLines;

  /// الحد الأدنى لعدد الأسطر
  final int? minLines;

  /// دالة تُستدعى عند تغيير قيمة الحقل
  final ValueChanged<String>? onChanged;

  /// إجراء زر الإدخال في لوحة المفاتيح
  final TextInputAction? textInputAction;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: const TextStyle(
              fontSize: AppTypography.labelLarge,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextFormField(
            controller: widget.controller,
            validator: widget.validator,
            keyboardType: <credential-fixture>,
            obscureText: _obscureText,
            maxLines: _obscureText ? 1 : widget.maxLines,
            minLines: widget.minLines,
            onChanged: widget.onChanged,
            textInputAction: widget.textInputAction,
            textDirection: _getTextDirection(context),
            decoration: InputDecoration(
              hintText: widget.hint,
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.obscureText
                  ? GestureDetector(
                      onTap: () {
                        setState(() => _obscureText = !_obscureText);
                      },
                      child: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.textSecondary,
                      ),
                    )
                  : widget.suffixIcon,
            ),
          ),
        ],
      );

  TextDirection _getTextDirection(BuildContext context) {
    final isArabic = Directionality.of(context) == TextDirection.rtl;
    return isArabic ? TextDirection.rtl : TextDirection.ltr;
  }
}

/// حقل إدخال مخصص للبحث
///
/// حقل بحث بسيط مع أيقونة بحث وزر مسح
///
/// Features:
/// - أيقونة بحث في البداية
/// - زر مسح يظهر عند وجود نص
/// - تصميم مخصص للبحث
/// - حواف دائرية كبيرة
///
/// Example:
/// ```dart
/// AppSearchField(
///   hint: 'ابحث عن عميل...',
///   onChanged: (value) => searchCustomers(value),
///   onClear: () => clearSearch(),
/// )
/// ```
class AppSearchField extends StatefulWidget {
  /// إنشاء حقل بحث
  ///
  /// Parameters:
  /// - [controller]: متحكم النص (اختياري)
  /// - [onChanged]: دالة تُستدعى عند تغيير النص (اختياري)
  /// - [hint]: نص توضيحي (افتراضي: 'ابحث هنا...')
  /// - [onClear]: دالة تُستدعى عند الضغط على زر المسح (اختياري)
  const AppSearchField({
    super.key,
    this.controller,
    this.onChanged,
    this.hint = 'ابحث هنا...',
    this.onClear,
  });

  /// متحكم النص للتحكم في قيمة الحقل
  final TextEditingController? controller;

  /// دالة تُستدعى عند تغيير قيمة الحقل
  final ValueChanged<String>? onChanged;

  /// نص توضيحي يظهر داخل الحقل
  final String? hint;

  /// دالة تُستدعى عند الضغط على زر المسح
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

  void _onTextChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
  }

  void _handleClear() {
    _controller.clear();
    widget.onClear?.call();
    widget.onChanged?.call('');
  }

  @override
  Widget build(BuildContext context) => TextField(
        controller: _controller,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          hintText: widget.hint,
          prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
          suffixIcon: _hasText
              ? GestureDetector(
                  onTap: _handleClear,
                  child:
                      const Icon(Icons.clear, color: AppColors.textSecondary),
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.lg),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.lg),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.lg),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
        ),
      );
}
