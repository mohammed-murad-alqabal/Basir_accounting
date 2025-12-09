/// Test Utils - أدوات مساعدة إضافية للاختبارات
///
/// يوفر هذا الملف أدوات مساعدة إضافية مثل matchers مخصصة
/// ودوال للتحقق من القيم.
library;

import 'package:flutter_test/flutter_test.dart';

/// أدوات مساعدة للاختبارات
class TestUtils {
  /// التحقق من أن قيمتين متساويتان تقريباً (للأرقام العشرية)
  ///
  /// مفيد عند مقارنة أرقام عشرية قد تحتوي على أخطاء تقريب.
  ///
  /// مثال:
  /// ```dart
  /// expect(TestUtils.approximatelyEqual(1.0000001, 1.0), isTrue);
  /// ```
  static bool approximatelyEqual(
    double a,
    double b, {
    double epsilon = 0.001,
  }) => (a - b).abs() < epsilon;

  /// Matcher للتحقق من أن رقم عشري يساوي قيمة تقريباً
  ///
  /// مثال:
  /// ```dart
  /// expect(1.0000001, approximatelyEquals(1.0));
  /// ```
  static Matcher approximatelyEquals(double value, {double epsilon = 0.001}) =>
      predicate<double>(
        (actual) => approximatelyEqual(actual, value, epsilon: epsilon),
        'approximately equals $value',
      );

  /// التحقق من أن تاريخين متساويان (بدون الوقت)
  ///
  /// يقارن التواريخ بدون النظر إلى الوقت.
  ///
  /// مثال:
  /// ```dart
  /// final date1 = DateTime(2025, 12, 1, 10, 30);
  /// final date2 = DateTime(2025, 12, 1, 15, 45);
  /// expect(TestUtils.isSameDate(date1, date2), isTrue);
  /// ```
  static bool isSameDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  /// Matcher للتحقق من أن تاريخين متساويان (بدون الوقت)
  ///
  /// مثال:
  /// ```dart
  /// final expected = DateTime(2025, 12, 1);
  /// expect(DateTime(2025, 12, 1, 10, 30), isSameDateAs(expected));
  /// ```
  static Matcher isSameDateAs(DateTime date) => predicate<DateTime>(
    (actual) => isSameDate(actual, date),
    'is same date as ${date.year}-${date.month}-${date.day}',
  );

  /// انتظار حتى يتم تنفيذ جميع العمليات الغير متزامنة
  ///
  /// مفيد في الاختبارات عند الحاجة للانتظار حتى تكتمل جميع
  /// العمليات الغير متزامنة.
  ///
  /// مثال:
  /// ```dart
  /// await TestUtils.waitForAsync();
  /// ```
  static Future<void> waitForAsync() async {
    await Future<void>.delayed(Duration.zero);
  }

  /// انتظار لمدة محددة (للاختبارات فقط)
  ///
  /// استخدم بحذر - يفضل استخدام waitForAsync() بدلاً منها.
  ///
  /// مثال:
  /// ```dart
  /// await TestUtils.wait(milliseconds: 100);
  /// ```
  static Future<void> wait({int milliseconds = 100}) async {
    await Future<void>.delayed(Duration(milliseconds: milliseconds));
  }

  /// التحقق من أن قائمة تحتوي على عناصر بترتيب معين
  ///
  /// مثال:
  /// ```dart
  /// final list = [1, 2, 3, 4, 5];
  /// expect(TestUtils.isOrdered(list), isTrue);
  /// ```
  static bool isOrdered<T extends Comparable<T>>(
    List<T> list, {
    bool ascending = true,
  }) {
    for (var i = 0; i < list.length - 1; i++) {
      final comparison = list[i].compareTo(list[i + 1]);
      if (ascending && comparison > 0) return false;
      if (!ascending && comparison < 0) return false;
    }
    return true;
  }

  /// Matcher للتحقق من أن قائمة مرتبة
  ///
  /// مثال:
  /// ```dart
  /// expect([1, 2, 3], TestUtils.isOrderedAscending);
  /// expect([3, 2, 1], TestUtils.isOrderedDescending);
  /// ```
  static Matcher get isOrderedAscending => predicate<List<num>>(
    (list) => isOrdered<num>(list),
    'is ordered ascending',
  );

  static Matcher get isOrderedDescending => predicate<List<num>>(
    (list) => isOrdered<num>(list, ascending: false),
    'is ordered descending',
  );

  /// التحقق من أن نص يحتوي على جميع الكلمات المحددة
  ///
  /// مثال:
  /// ```dart
  /// final text = 'مرحباً بك في تطبيق بصير';
  /// expect(TestUtils.containsAllWords(text, ['مرحباً', 'بصير']), isTrue);
  /// ```
  static bool containsAllWords(String text, List<String> words) =>
      words.every((word) => text.contains(word));

  /// Matcher للتحقق من أن نص يحتوي على جميع الكلمات
  ///
  /// مثال:
  /// ```dart
  /// expect('مرحباً بك في بصير', containsWords(['مرحباً', 'بصير']));
  /// ```
  static Matcher containsWords(List<String> words) => predicate<String>(
    (text) => TestUtils.containsAllWords(text, words),
    'contains all words: ${words.join(", ")}',
  );
}
