import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Theme state controller for application-wide theme management.
///
/// Manages the theme mode (light/dark/system) with automatic persistence
/// to [SharedPreferences]. Uses [AsyncNotifier] to ensure preferences are
/// loaded before the application renders.
///
/// ## Features
/// - Persists user preference across app restarts
/// - Supports system theme following
/// - Provides toggle functionality for quick switching
///
/// ## Usage
/// ```dart
/// // Watch current theme
/// final themeMode = ref.watch(themeProvider).value;
///
/// // Toggle theme
/// ref.read(themeProvider.notifier).toggleTheme();
///
/// // Set specific mode
/// ref.read(themeProvider.notifier).setThemeMode(ThemeMode.dark);
/// ```
class ThemeController extends AsyncNotifier<ThemeMode> {
  static const String _themeModeKey = 'theme_mode';

  @override
  Future<ThemeMode> build() async => _loadThemeMode();

  /// Loads the persisted theme mode from storage.
  ///
  /// Returns [ThemeMode.system] if no preference is saved or on error.
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
    return ThemeMode.system;
  }

  /// Toggles between light and dark theme modes.
  ///
  /// If currently in system mode, switches to dark mode first.
  Future<void> toggleTheme() async {
    final currentMode = state.value ?? ThemeMode.light;
    final newMode =
        currentMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await setThemeMode(newMode);
  }

  /// Sets the application theme mode and persists it.
  ///
  /// [mode] - The desired [ThemeMode] to apply.
  Future<void> setThemeMode(ThemeMode mode) async {
    state = AsyncValue.data(mode);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeModeKey, mode.toString());
    } on Object catch (e) {
      debugPrint('Error saving theme mode: $e');
    }
  }

  /// Returns `true` if dark mode is currently active.
  bool get isDarkMode => state.value == ThemeMode.dark;
}

/// Primary theme state provider.
///
/// Exposes the current [ThemeMode] and [ThemeController] for state management.
final themeProvider = AsyncNotifierProvider<ThemeController, ThemeMode>(
  ThemeController.new,
);

/// Convenience provider for checking dark mode status.
///
/// Resolves system theme to actual brightness when [ThemeMode.system] is
/// active.
final isDarkModeProvider = Provider<bool>((ref) {
  final themeMode = ref.watch(themeProvider).value ?? ThemeMode.system;
  if (themeMode == ThemeMode.system) {
    return WidgetsBinding.instance.platformDispatcher.platformBrightness ==
        Brightness.dark;
  }
  return themeMode == ThemeMode.dark;
});
