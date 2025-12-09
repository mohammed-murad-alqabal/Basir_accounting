import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// مزود حالة الثيم (Theme Provider)
///
/// يدير حالة الثيم (فاتح/داكن) ويحفظها في التخزين الآمن
class ThemeNotifier extends StateNotifier<ThemeMode> {
  /// إنشاء مزود الثيم
  ThemeNotifier(this._storage) : super(ThemeMode.light) {
    _init();
  }

  final FlutterSecureStorage _storage;
  static const String _themeModeKey = 'theme_mode';

  /// تهيئة المزود وتحميل الثيم
  void _init() {
    // تحميل الثيم بدون انتظار (fire and forget)
    unawaited(_loadThemeMode());
  }

  /// تحميل وضع الثيم المحفوظ
  Future<void> _loadThemeMode() async {
    try {
      final savedMode = await _storage.read(key: _themeModeKey);
      if (savedMode != null) {
        state = ThemeMode.values.firstWhere(
          (mode) => mode.toString() == savedMode,
          orElse: () => ThemeMode.light,
        );
      }
    } on Exception catch (e) {
      debugPrint('Error loading theme mode: $e');
      state = ThemeMode.light;
    }
  }

  /// تبديل بين الوضع الفاتح والداكن
  Future<void> toggleTheme() async {
    final newMode = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await setThemeMode(newMode);
  }

  /// تعيين وضع الثيم
  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    try {
      await _storage.write(key: _themeModeKey, value: mode.toString());
    } on Exception catch (e) {
      debugPrint('Error saving theme mode: $e');
    }
  }

  /// التحقق من الوضع الداكن
  bool get isDarkMode => state == ThemeMode.dark;

  /// التحقق من الوضع الفاتح
  bool get isLightMode => state == ThemeMode.light;
}

/// مزود الثيم
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>(
  (ref) => ThemeNotifier(const FlutterSecureStorage()),
);

/// مزود للتحقق من الوضع الداكن
final isDarkModeProvider = Provider<bool>((ref) {
  final themeMode = ref.watch(themeProvider);
  return themeMode == ThemeMode.dark;
});
