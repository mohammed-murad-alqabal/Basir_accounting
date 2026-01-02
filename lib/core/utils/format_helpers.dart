import 'package:basir_app/core/providers/calendar_provider.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';

/// مساعد التنسيق (Format Helper)
///
/// يوفر دوال لتنسيق التواريخ، الأرقام، والعملات بناءً على اللغة الحالية.
class FormatHelpers {
  /// منع إنشاء كائن من هذا الكلاس
  FormatHelpers._();

  /// تنسيق التاريخ (Date)
  ///
  /// [date]: التاريخ المراد تنسيقه
  /// [locale]: رمز اللغة (مثل 'ar' أو 'en')
  /// [pattern]: نمط التنسيق (اختياري، الافتراضي 'yMMMd')
  static String formatDate(
    DateTime date, {
    String locale = 'ar',
    String? pattern = 'yMMMd',
    CalendarType calendarType = CalendarType.gregorian,
  }) {
    if (calendarType == CalendarType.hijri) {
      final hijriDate = HijriCalendar.fromDate(date);
      // ضبط اللغة للمكتبة
      HijriCalendar.setLocal(locale.startsWith('ar') ? 'ar' : 'en');
      return hijriDate.fullDate();
    }

    // Try to use the requested locale, fallback to English if it fails
    try {
      return DateFormat(pattern, locale).format(date);
    } on Exception {
      // If locale data is not available, fallback to English
      try {
        return DateFormat(pattern, 'en').format(date);
      } on Exception {
        // Last resort: basic formatting
        return date.toString().split(' ')[0];
      }
    }
  }

  /// تنسيق التاريخ والوقت (Date & Time)
  ///
  /// [date]: التاريخ والوقت
  /// [locale]: رمز اللغة
  static String formatDateTime(DateTime date, {String locale = 'ar'}) {
    try {
      return DateFormat.yMMMd(locale).add_jm().format(date);
    } on Exception {
      // Fallback to English if locale is not available
      return DateFormat.yMMMd('en').add_jm().format(date);
    }
  }

  /// تنسيق الأرقام (Numbers)
  ///
  /// [number]: الرقم المراد تنسيقه
  /// [locale]: رمز اللغة
  static String formatNumber(num number, {String locale = 'ar'}) {
    try {
      return NumberFormat.decimalPattern(locale).format(number);
    } on Exception {
      // Fallback to English if locale is not available
      return NumberFormat.decimalPattern('en').format(number);
    }
  }

  /// تنسيق العملة (Currency)
  ///
  /// [amount]: المبلغ
  /// [currencyCode]: رمز العملة (مثل 'SAR', 'USD')
  /// [locale]: رمز اللغة
  ///
  /// ملاحظة: إذا كانت العملة SAR واللغة العربية، سيتم استخدام التنسيق المحلي
  static String formatCurrency(
    num amount, {
    String currencyCode = 'SAR',
    String locale = 'ar',
  }) {
    try {
      return NumberFormat.currency(
        locale: locale,
        symbol: currencyCode == 'SAR' && locale.startsWith('ar') ? 'ر.س' : null,
        name: currencyCode,
      ).format(amount);
    } on Exception {
      // Fallback to English if locale is not available
      return NumberFormat.currency(
        locale: 'en',
        symbol: currencyCode == 'SAR' ? 'SAR' : null,
        name: currencyCode,
      ).format(amount);
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
