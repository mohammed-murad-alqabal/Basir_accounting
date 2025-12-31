import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// نوع التقويم (Calendar Type)
/// أنواع التقاويم المدعومة
enum CalendarType {
  /// التقويم الميلادي
  gregorian,

  /// التقويم الهجري
  hijri,
}

/// مفتاح تخزين نوع التقويم في SharedPreferences
const String _calendarKey = 'app_calendar_type';

/// موفر حالة التقويم المفضل للمستخدم
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

  /// تغيير نوع التقويم
  Future<void> setCalendarType(CalendarType type) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_calendarKey, type.name);
      return type;
    });
  }

  /// التبديل بين الهجري والميلادي
  Future<void> toggleCalendar() async {
    final calendarType = state.valueOrNull ?? CalendarType.gregorian;
    final newType = calendarType == CalendarType.hijri
        ? CalendarType.gregorian
        : CalendarType.hijri;
    await setCalendarType(newType);
  }
}

/// مزود التقويم (Calendar Provider)
final calendarProvider =
    AsyncNotifierProvider<CalendarNotifier, CalendarType>(CalendarNotifier.new);
