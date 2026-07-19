import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Supported calendar systems for date display.
///
/// The application supports dual calendar display for regional compatibility.
enum CalendarType {
  /// Gregorian (Western) calendar system.
  gregorian,

  /// Hijri (Islamic) calendar system.
  hijri,
}

/// Storage key for calendar type preference.
const String _calendarKey = '<credential-fixture>';

/// Calendar state controller for date system preferences.
///
/// Manages the preferred calendar type (Gregorian/Hijri) with automatic
/// persistence to [SharedPreferences].
///
/// ## Features
/// - Persists calendar preference across sessions
/// - Defaults to Gregorian calendar
/// - Provides toggle functionality for quick switching
///
/// ## Usage
/// ```dart
/// // Watch current calendar type
/// final calendarType = ref.watch(calendarProvider).value;
///
/// // Toggle calendar system
/// await ref.read(calendarProvider.notifier).toggleCalendar();
///
/// // Set specific calendar
///   await ref.read(calendarProvider.notifier)
///       .setCalendarType(CalendarType.hijri);
/// ```
class CalendarNotifier extends AsyncNotifier<CalendarType> {
  @override
  Future<CalendarType> build() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_calendarKey);
    return CalendarType.values.firstWhere(
      (e) => e.name == saved,
      orElse: () => CalendarType.gregorian,
    );
  }

  /// Sets the calendar type and persists the preference.
  ///
  /// [type] - The desired [CalendarType] to apply.
  Future<void> setCalendarType(CalendarType type) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_calendarKey, type.name);
      return type;
    });
  }

  /// Toggles between Hijri and Gregorian calendar systems.
  Future<void> toggleCalendar() async {
    final calendarType = state.value ?? CalendarType.gregorian;
    final newType = calendarType == CalendarType.hijri
        ? CalendarType.gregorian
        : CalendarType.hijri;
    await setCalendarType(newType);
  }
}

/// Primary calendar state provider.
///
/// Exposes the current [CalendarType] and [CalendarNotifier] for state
/// management.
final calendarProvider = AsyncNotifierProvider<CalendarNotifier, CalendarType>(
  CalendarNotifier.new,
);
