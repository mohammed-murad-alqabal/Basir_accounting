import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// حالة إعدادات المظهر المتقدمة
class AppearanceState {
  /// إنشاء حالة إعدادات المظهر
  const AppearanceState({
    required this.highContrast,
    required this.reduceMotion,
  });

  /// تفعيل التباين العالي
  final bool highContrast;

  /// تفعيل تقليل الحركة
  final bool reduceMotion;

  /// نسخ الحالة مع تعديلات محددة
  AppearanceState copyWith({
    bool? highContrast,
    bool? reduceMotion,
  }) =>
      AppearanceState(
        highContrast: highContrast ?? this.highContrast,
        reduceMotion: reduceMotion ?? this.reduceMotion,
      );
}

/// خدمة إدارة إعدادات المظهر (التباين العالي، تقليل الحركة)
class AppearanceService extends AsyncNotifier<AppearanceState> {
  static const String _highContrastKey = '<credential-fixture>';
  static const String _reduceMotionKey = '<credential-fixture>';

  @override
  Future<AppearanceState> build() async => _loadSettings();

  Future<AppearanceState> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final highContrast = prefs.getBool(_highContrastKey) ?? false;
      final reduceMotion = prefs.getBool(_reduceMotionKey) ?? false;

      return AppearanceState(
        highContrast: highContrast,
        reduceMotion: reduceMotion,
      );
    } on Object catch (e) {
      debugPrint('Error loading appearance settings: $e');
      return const AppearanceState(highContrast: false, reduceMotion: false);
    }
  }

  /// تفعيل/تعطيل التباين العالي
  Future<void> setHighContrast({required bool enabled}) async {
    final currentState = state.value;
    if (currentState == null) return;

    state = AsyncValue.data(currentState.copyWith(highContrast: enabled));
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_highContrastKey, enabled);
    } on Object catch (e) {
      debugPrint('Error saving high contrast setting: $e');
    }
  }

  /// تفعيل/تعطيل تقليل الحركة
  Future<void> setReduceMotion({required bool enabled}) async {
    final currentState = state.value;
    if (currentState == null) return;

    state = AsyncValue.data(currentState.copyWith(reduceMotion: enabled));
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_reduceMotionKey, enabled);
    } on Object catch (e) {
      debugPrint('Error saving reduce motion setting: $e');
    }
  }

  /// استعادة الإعدادات الافتراضية
  Future<void> resetToDefault() async {
    state = const AsyncValue.data(
      AppearanceState(highContrast: false, reduceMotion: false),
    );
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_highContrastKey);
      await prefs.remove(_reduceMotionKey);
    } on Object catch (e) {
      debugPrint('Error resetting appearance settings: $e');
    }
  }
}

/// موفر خدمة المظهر
// ignore: lines_longer_than_80_chars
final appearanceServiceProvider =
    AsyncNotifierProvider<AppearanceService, AppearanceState>(
  AppearanceService.new,
);
