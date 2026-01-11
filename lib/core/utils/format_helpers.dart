import 'package:basir_accounting_system/core/providers/calendar_provider.dart';
import 'package:decimal/decimal.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';

/// ***
/// Cognitive Foundation: FormatHelpers
///
/// Multi-standard formatting engine for institutional data representation.
/// Supports localized dates (Gregorian/Hijri), high-precision numbers,
/// and institutional currency formatting.
/// ***
class FormatHelpers {
  FormatHelpers._();

  /// Formats institutional timestamps with Gregorian and Hijri support.
  static String formatDate(
    DateTime date, {
    String locale = 'ar',
    String? pattern = 'yMMMd',
    CalendarType calendarType = CalendarType.gregorian,
  }) {
    if (calendarType == CalendarType.hijri) {
      final hijriDate = HijriCalendar.fromDate(date);
      HijriCalendar.setLocal(locale.startsWith('ar') ? 'ar' : 'en');
      return hijriDate.fullDate();
    }

    try {
      return DateFormat(pattern, locale).format(date);
    } on Exception {
      try {
        return DateFormat(pattern, 'en').format(date);
      } on Exception {
        return date.toString().split(' ')[0];
      }
    }
  }

  /// Formats combined date-time instances for institutional audit logs.
  static String formatDateTime(DateTime date, {String locale = 'ar'}) {
    try {
      return DateFormat.yMMMd(locale).add_jm().format(date);
    } on Exception {
      return DateFormat.yMMMd('en').add_jm().format(date);
    }
  }

  /// Formats high-precision numbers with localized patterns.
  /// Accepts [num] or [Decimal].
  static String formatNumber(Object number, {String locale = 'ar'}) {
    final val = number is Decimal ? number.toDouble() : number as num;
    try {
      return NumberFormat.decimalPattern(locale).format(val);
    } on Exception {
      return NumberFormat.decimalPattern('en').format(val);
    }
  }

  /// Formats institutional currency (e.g., SAR) with precision safeguards.
  /// Accepts [num] or [Decimal].
  static String formatCurrency(
    Object amount, {
    String currencyCode = 'SAR',
    String locale = 'ar',
  }) {
    final val = amount is Decimal ? amount.toDouble() : amount as num;
    try {
      return NumberFormat.currency(
        locale: locale,
        symbol: currencyCode == 'SAR' && locale.startsWith('ar') ? 'ر.س' : null,
        name: currencyCode,
      ).format(val);
    } on Exception {
      return NumberFormat.currency(
        locale: 'en',
        symbol: currencyCode == 'SAR' ? 'SAR' : null,
        name: currencyCode,
      ).format(val);
    }
  }

  /// تنسيق الوقت النسبي (Relative Time)
  ///
  /// [date]: التاريخ
  /// [locale]: رمز اللغة
  ///
  /// يعيد نصاً مثل "منذ 3 ساعات" أو "Yesterday"
  static String formatRelativeTime(DateTime date, {String locale = 'ar'}) {
    final now = DateTime.now();
    final difference = now.difference(date);

    // TODO(m): يمكن تحسين هذا باستخدام مكتبات متخصصة مثل timeago
    // حالياً نستخدم تنفيذ بسيط للعربية والإنجليزية

    if (locale.startsWith('ar')) {
      if (difference.inSeconds < 60) {
        return 'الآن';
      } else if (difference.inMinutes < 60) {
        return 'منذ ${difference.inMinutes} دقيقة';
      } else if (difference.inHours < 24) {
        return 'منذ ${difference.inHours} ساعة';
      } else if (difference.inDays < 7) {
        return 'منذ ${difference.inDays} يوم';
      } else {
        return formatDate(date, locale: locale);
      }
    } else {
      if (difference.inSeconds < 60) {
        return 'Just now';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays}d ago';
      } else {
        return formatDate(date, locale: locale);
      }
    }
  }
}
