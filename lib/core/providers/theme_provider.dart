import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// مزود حالة الثيم (Theme Controller)
///
/// يدير حالة الثيم (فاتح/داكن) ويحفظها في SharedPreferences
/// يستخدم AsyncNotifier لضمان تحميل التفضيلات قبل عرض التطبيق
class ThemeController extends AsyncNotifier<ThemeMode> {
  static const String _themeModeKey = '<credential-fixture>';

  @override
  Future<ThemeMode> build() async => _loadThemeMode();

  /// تحميل وضع الثيم المحفوظ
  Future<ThemeMode> _loadThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedMode = prefs.getString(_themeModeKey);

      if (savedMode != null) {
        return ThemeMode.values.firstWhere(
          (mode) => mode.toString() == savedMode,
          orElse: () => ThemeMode.system,
        );
      }
    } on Object catch (e) {
      debugPrint('Error loading theme mode: $e');
    }
    // الوضع الافتراضي
    return ThemeMode.system;
  }

  /// تبديل بين الوضع الفاتح والداكن
  Future<void> toggleTheme() async {
    final currentMode = state.value ?? ThemeMode.light;
    final newMode =
        currentMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await setThemeMode(newMode);
  }

  /// تعيين وضع الثيم
  Future<void> setThemeMode(ThemeMode mode) async {
    state = AsyncValue.data(mode);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeModeKey, mode.toString());
    } on Object catch (e) {
      debugPrint('Error saving theme mode: $e');
    }
  }

  /// التحقق من الوضع الداكن
  bool get isDarkMode => state.value == ThemeMode.dark;
}

/// مزود الثيم
final themeProvider =
    AsyncNotifierProvider<ThemeController, ThemeMode>(ThemeController.new);

/// مزود مساعد للتحقق من الوضع الداكن
final isDarkModeProvider = Provider<bool>((ref) {
  final themeMode = ref.watch(themeProvider).valueOrNull ?? ThemeMode.system;
  if (themeMode == ThemeMode.system) {
    return WidgetsBinding.instance.platformDispatcher.platformBrightness ==
        Brightness.dark;
  }
  return themeMode == ThemeMode.dark;
});
