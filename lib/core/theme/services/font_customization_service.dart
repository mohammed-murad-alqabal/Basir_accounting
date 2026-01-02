import 'package:basir_app/core/theme/services/theme_storage_utils.dart';
import 'package:basir_app/core/theme/tokens/index.dart';
import 'package:basir_app/features/auth/presentation/providers/current_user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// حالة تخصيص الخطوط
class FontCustomizationState {
  /// إنشاء حالة تخصيص الخطوط
  const FontCustomizationState({
    required this.fontFamily,
    required this.textScaleFactor,
  });

  /// عائلة الخط المختارة
  final String fontFamily;

  /// معامل تكبير النص
  final double textScaleFactor;

  /// نسخ الحالة مع تعديلات محددة
  FontCustomizationState copyWith({
    String? fontFamily,
    double? textScaleFactor,
  }) =>
      FontCustomizationState(
        fontFamily: fontFamily ?? this.fontFamily,
        textScaleFactor: textScaleFactor ?? this.textScaleFactor,
      );
}

/// خدمة تخصيص الخطوط والأحجام
///
/// تدير حالة الخطوط والأحجام المخصصة من قبل المستخدم وتحفظها في التخزين المحلي.
/// تدعم تعدد المستخدمين عبر [currentUserProvider].
class FontCustomizationService extends AsyncNotifier<FontCustomizationState> {
  static const String _fontFamilyKey = 'custom_font_family';
  static const String _textScaleKey = 'custom_text_scale';

  @override
  Future<FontCustomizationState> build() async {
    // إعادة البناء عند تغيير المستخدم
    final userState = ref.watch(currentUserProvider);
    return _loadSettings(userState.value);
  }

  /// الحصول على المفتاح المناسب للمستخدم
  String _getStorageKey(String baseKey, String? username) =>
      ThemeStorageUtils.getUserSpecificKey(baseKey, username);

  Future<FontCustomizationState> _loadSettings(String? username) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final familyKey = _getStorageKey(_fontFamilyKey, username);
      final scaleKey = _getStorageKey(_textScaleKey, username);

      final fontFamily = prefs.getString(familyKey) ?? FontFamilies.arabic;
      final textScale = prefs.getDouble(scaleKey) ?? 1.0;

      return FontCustomizationState(
        fontFamily: fontFamily,
        textScaleFactor: textScale,
      );
    } on Object catch (e) {
      debugPrint('Error loading font settings: $e');
      return const FontCustomizationState(
        fontFamily: FontFamilies.arabic,
        textScaleFactor: 1,
      );
    }
  }

  /// تغيير نوع الخط
  Future<void> setFontFamily(String fontFamily) async {
    final currentState = state.value;
    if (currentState == null) return;

    state = AsyncValue.data(currentState.copyWith(fontFamily: fontFamily));
    try {
      final prefs = await SharedPreferences.getInstance();
      final username = ref.read(currentUserProvider).value;
      final key = _getStorageKey(_fontFamilyKey, username);
      await prefs.setString(key, fontFamily);
    } on Object catch (e) {
      debugPrint('Error saving font family: $e');
    }
  }

  /// تغيير حجم الخط (Scale)
  Future<void> setTextScale(double scale) async {
    final currentState = state.value;
    if (currentState == null) return;

    // تحديد الحدود (0.8x إلى 1.4x)
    final clampedScale = scale.clamp(0.8, 1.4);

    state = AsyncValue.data(
      currentState.copyWith(textScaleFactor: clampedScale),
    );
    try {
      final prefs = await SharedPreferences.getInstance();
      final username = ref.read(currentUserProvider).value;
      final key = _getStorageKey(_textScaleKey, username);
      await prefs.setDouble(key, clampedScale);
    } on Object catch (e) {
      debugPrint('Error saving text scale: $e');
    }
  }

  /// استعادة الافتراضي
  Future<void> resetToDefault() async {
    state = const AsyncValue.data(
      FontCustomizationState(
        fontFamily: FontFamilies.arabic,
        textScaleFactor: 1,
      ),
    );
    try {
      final prefs = await SharedPreferences.getInstance();
      final username = ref.read(currentUserProvider).value;
      await prefs.remove(_getStorageKey(_fontFamilyKey, username));
      await prefs.remove(_getStorageKey(_textScaleKey, username));
    } on Object catch (e) {
      debugPrint('Error removing font settings: $e');
    }
  }
}

/// موفر خدمة تخصيص الخطوط
final fontCustomizationProvider =
    AsyncNotifierProvider<FontCustomizationService, FontCustomizationState>(
  FontCustomizationService.new,
);
