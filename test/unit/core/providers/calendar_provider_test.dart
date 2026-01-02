import 'package:basir_app/core/providers/calendar_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('CalendarProvider Tests', () {
    late ProviderContainer container;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state should be Gregorian by default', () async {
      final calendarType = await container.read(calendarProvider.future);
      expect(calendarType, CalendarType.gregorian);
    });

    test('setCalendarType should update state and persist value', () async {
      // Set to Hijri
      await container
          .read(calendarProvider.notifier)
          .setCalendarType(CalendarType.hijri);

      var calendarType = await container.read(calendarProvider.future);
      expect(calendarType, CalendarType.hijri);

      // Verify persistence
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('app_calendar_type'), 'hijri');

      // Set back to Gregorian
      await container
          .read(calendarProvider.notifier)
          .setCalendarType(CalendarType.gregorian);

      calendarType = await container.read(calendarProvider.future);
      expect(calendarType, CalendarType.gregorian);
      expect(prefs.getString('app_calendar_type'), 'gregorian');
    });

    test('toggleCalendar should switch between Gregorian and Hijri', () async {
      // Start with default (Gregorian)
      await container.read(calendarProvider.future);

      // Toggle to Hijri
      await container.read(calendarProvider.notifier).toggleCalendar();
      var calendarType = await container.read(calendarProvider.future);
      expect(calendarType, CalendarType.hijri);

      // Toggle back to Gregorian
      await container.read(calendarProvider.notifier).toggleCalendar();
      calendarType = await container.read(calendarProvider.future);
      expect(calendarType, CalendarType.gregorian);
    });

    test('should load persisted value from SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({
        'app_calendar_type': 'hijri',
      });

      // Create new container after setting mock values
      final newContainer = ProviderContainer();
      addTearDown(newContainer.dispose);

      final calendarType = await newContainer.read(calendarProvider.future);
      expect(calendarType, CalendarType.hijri);
    });
  });
}
