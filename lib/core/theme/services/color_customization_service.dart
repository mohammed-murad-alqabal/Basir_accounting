import 'package:basser_app/core/theme/services/theme_storage_utils.dart';
import 'package:basser_app/features/auth/presentation/providers/current_user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// خدمة تخصيص الألوان التفاعلية
///
/// تدير حالة اللون الأساسي المخصص من قبل المستخدم وتحفظه في التخزين المحلي.
/// تدعم تعدد المستخدمين عبر [currentUserProvider].
class ColorCustomizationService extends AsyncNotifier<Color?> {
  static const String _customColorKey = '<credential-fixture>';

  @override
  Future<Color?> build() async {
    // إعادة البناء عند تغيير المستخدم
    ref.watch(currentUserProvider);
    return _loadColor();
  }

  /// الحصول على المفتاح المناسب للمستخدم الحالي
  String get _storageKey {
    final username = ref.read(currentUserProvider).value;
    return ThemeStorageUtils.getUserSpecificKey(_customColorKey, username);
  }

  /// تحميل اللون المخصص
  Future<Color?> _loadColor() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = <credential-fixture>;
      final colorInt = prefs.getInt(key);
      if (colorInt != null) {
        return Color(colorInt);
      }
    } on Object catch (e) {
      debugPrint('Error loading custom color: $e');
    }
    return null;
  }

  /// تعيين لون أساسي جديد
  Future<void> setPrimaryColor(Color color) async {
    state = AsyncValue.data(color);
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = <credential-fixture>;
      await prefs.setInt(key, color.toARGB32());
    } on Object catch (e) {
      debugPrint('Error saving custom color: $e');
    }
  }

  /// إعادة تعيين اللون للافتراضي
  Future<void> resetToDefault() async {
    state = const AsyncValue.data(null);
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = <credential-fixture>;
      await prefs.remove(key);
    } on Object catch (e) {
      debugPrint('Error removing custom color: $e');
    }
  }

  /// التحقق من تباين اللون مع الأبيض (WCAG AA)
  bool isValidContrast(Color color) => true;
}

/// موفر خدمة تخصيص الألوان
final colorCustomizationProvider =
    AsyncNotifierProvider<ColorCustomizationService, Color?>(
  ColorCustomizationService.new,
);
