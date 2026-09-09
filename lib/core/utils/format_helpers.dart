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
  /// يعيد نصاً مثل "منذ 3 ساعات" أو "Yesterday" / "2y 5m"
  static String formatRelativeTime(DateTime date, {String locale = 'ar'}) {
    final now = DateTime.now();
    final difference = now.difference(date);
    final absSecs = difference.inSeconds.abs();

    // تحديد إذا كان التاريخ في المستقبل أم الماضي
    final isFuture = difference.isNegative;

    if (locale.startsWith('ar')) {
      // ===== النسخة العربية: مراعاة التفرد والجمع والمثنى =====
      String arRelative(
        int value,
        String singular,
        String dual,
        String plural,
      ) {
        final prefix = isFuture ? 'بعد ' : 'منذ ';
        if (value == 0) return 'الآن';
        if (value == 1) return '$prefix$singular';
        if (value == 2) return '$prefix$dual';
        if (value <= 10) return '$prefix$value $plural';
        return '$prefix$value $singular';
      }

      if (absSecs < 60) {
        return isFuture ? 'بعد لحظات' : 'الآن';
      } else if (absSecs < 3600) {
        return arRelative(
          difference.inMinutes.abs(),
          'دقيقة',
          'دقيقتان',
          'دقائق',
        );
      } else if (absSecs < 86400) {
        return arRelative(
          difference.inHours.abs(),
          'ساعة',
          'ساعتان',
          'ساعات',
        );
      } else if (absSecs < 604800) {
        return arRelative(
          difference.inDays.abs(),
          'يوم',
          'يومان',
          'أيام',
        );
      } else if (absSecs < 2592000) {
        // أقل من 30 يوماً → أسابيع
        final weeks = (difference.inDays.abs() / 7).floor();
        return arRelative(weeks, 'أسبوع', 'أسبوعان', 'أسابيع');
      } else if (absSecs < 31536000) {
        // أقل من سنة → أشهر
        final months = (difference.inDays.abs() / 30).floor();
        return arRelative(months, 'شهر', 'شهران', 'أشهر');
      } else {
        // سنة أو أكثر
        final years = (difference.inDays.abs() / 365).floor();
        return arRelative(years, 'سنة', 'سنتان', 'سنوات');
      }
    } else {
      // ===== النسخة الإنجليزية =====
      if (absSecs < 60) {
        return isFuture ? 'In a moment' : 'Just now';
      } else if (absSecs < 3600) {
        final mins = difference.inMinutes.abs();
        return isFuture ? 'In ${mins}m' : '${mins}m ago';
      } else if (absSecs < 86400) {
        final hrs = difference.inHours.abs();
        return isFuture ? 'In ${hrs}h' : '${hrs}h ago';
      } else if (absSecs < 604800) {
        final days = difference.inDays.abs();
        return isFuture ? 'In ${days}d' : '${days}d ago';
      } else if (absSecs < 2592000) {
        final weeks = (difference.inDays.abs() / 7).floor();
        return isFuture ? 'In ${weeks}w' : '${weeks}w ago';
      } else if (absSecs < 31536000) {
        final months = (difference.inDays.abs() / 30).floor();
        return isFuture ? 'In ${months}mo' : '${months}mo ago';
      } else {
        final years = (difference.inDays.abs() / 365).floor();
        return isFuture ? 'In ${years}y' : '${years}y ago';
      }
    }
  }
}
