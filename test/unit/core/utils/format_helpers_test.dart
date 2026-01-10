import 'package:basir_app/core/providers/calendar_provider.dart';
import 'package:basir_app/core/utils/format_helpers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('ar');
    await initializeDateFormatting('en');
  });

  group('FormatHelpers Tests', () {
    final testDate = DateTime(2023, 10, 27); // A fixed date for consistency

    group('Date Formatting', () {
      test('formatDate should return correct Gregorian format by default', () {
        final formatted = FormatHelpers.formatDate(testDate, locale: 'en');
        expect(formatted, contains('Oct 27, 2023'));
      });

      test('formatDate should return correct Gregorian format in Arabic', () {
        final formatted = FormatHelpers.formatDate(testDate);
        // Accept both Western and Eastern Arabic numerals
        expect(formatted, anyOf(contains('2023'), contains('٢٠٢٣')));
        expect(formatted, contains('أكتوبر'));
      });

      test(
        'formatDate should return correct Hijri format (approximate check)',
        () {
          // Oct 27, 2023 is 12 Rabi' al-Thani 1445
          final formatted = FormatHelpers.formatDate(
            testDate,
            calendarType: CalendarType.hijri,
            locale: 'en',
          );
          expect(formatted, contains('1445'));
          expect(formatted, anyOf(contains('Rabi'), contains('Al-Akhar')));
        },
      );

      test('formatDate should return correct Hijri format in Arabic', () {
        final formatted = FormatHelpers.formatDate(
          testDate,
          calendarType: CalendarType.hijri,
        );
        expect(formatted, contains('١٤٤٥'));
        expect(formatted, anyOf(contains('ربيع'), contains('الثاني')));
      });

      test('formatDateTime should include time', () {
        final dateTime = DateTime(2023, 10, 27, 14, 30);
        final formatted = FormatHelpers.formatDateTime(dateTime, locale: 'en');
        expect(formatted, contains('2:30'));
        expect(formatted, contains('PM'));
      });
    });

    group('Currency Formatting', () {
      test('formatCurrency should use SAR for Arabic locale', () {
        final formatted = FormatHelpers.formatCurrency(1234.56);
        expect(formatted, contains('ر.س'));
      });

      test(
        'formatCurrency should use SAR for English locale in this project',
        () {
          final formatted = FormatHelpers.formatCurrency(1234.56, locale: 'en');
          expect(formatted, contains('SAR'));
        },
      );

      test('formatNumber should format with commas', () {
        final formatted = FormatHelpers.formatNumber(1234567.89, locale: 'en');
        expect(formatted, '1,234,567.89');
      });
    });

    group('Relative Time Styling', () {
      test('formatRelativeTime should return "Just now" for recent times', () {
        final now = DateTime.now();
        final formatted = FormatHelpers.formatRelativeTime(now, locale: 'en');
        expect(formatted, anyOf(contains('now'), contains('Just now')));
      });

      test('formatRelativeTime should return "منذ" for Arabic locale', () {
        final past = DateTime.now().subtract(const Duration(hours: 2));
        final formatted = FormatHelpers.formatRelativeTime(past);
        expect(formatted, contains('منذ'));
      });
    });
  });
}
