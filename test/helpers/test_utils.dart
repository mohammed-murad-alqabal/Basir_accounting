/// أدوات مساعدة إضافية للاختبارات
///
/// يوفر هذا الملف مجموعة من الأدوات المساعدة الإضافية
/// لتسهيل كتابة الاختبارات.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// فئة تحتوي على أدوات مساعدة للاختبارات
class TestUtils {
  /// إنشاء MaterialApp بسيط للاختبارات
  ///
  /// يُستخدم هذا لتغليف widget في MaterialApp للاختبار.
  ///
  /// [child] الـ widget المراد اختباره
  /// [locale] اللغة (اختياري، القيمة الافتراضية: العربية)
  ///
  /// مثال:
  /// ```dart
  /// await tester.pumpWidget(
  ///   TestUtils.wrapWithMaterialApp(
  ///     child: MyWidget(),
  ///   ),
  /// );
  /// ```
  static Widget wrapWithMaterialApp({
    required Widget child,
    Locale locale = const Locale('ar', 'SA'),
  }) =>
      MaterialApp(
        locale: locale,
        home: Scaffold(
          body: child,
        ),
      );

  /// الانتظار حتى تكتمل جميع الـ animations
  ///
  /// يُستخدم هذا بعد pumpWidget للتأكد من اكتمال جميع الـ animations.
  ///
  /// [tester] الـ WidgetTester
  /// [duration] المدة القصوى للانتظار (اختياري)
  ///
  /// مثال:
  /// ```dart
  /// await tester.pumpWidget(widget);
  /// await TestUtils.pumpAndSettle(tester);
  /// ```
  static Future<void> pumpAndSettle(
    WidgetTester tester, {
    Duration duration = const Duration(seconds: 10),
  }) async {
    await tester.pumpAndSettle(duration);
  }

  /// البحث عن widget بالنص
  ///
  /// يُستخدم هذا للبحث عن widget يحتوي على نص معين.
  ///
  /// [text] النص المراد البحث عنه
  ///
  /// Returns Finder للـ widget
  ///
  /// مثال:
  /// ```dart
  /// expect(TestUtils.findByText('مرحباً'), findsOneWidget);
  /// ```
  static Finder findByText(String text) => find.text(text);

  /// البحث عن widget بالنوع
  ///
  /// يُستخدم هذا للبحث عن widget من نوع معين.
  ///
  /// [T] نوع الـ widget
  ///
  /// Returns Finder للـ widget
  ///
  /// مثال:
  /// ```dart
  /// expect(TestUtils.findByType<ElevatedButton>(), findsOneWidget);
  /// ```
  static Finder findByType<T>() => find.byType(T);

  /// البحث عن widget بالـ Key
  ///
  /// يُستخدم هذا للبحث عن widget بـ key معين.
  ///
  /// [key] الـ key المراد البحث عنه
  ///
  /// Returns Finder للـ widget
  ///
  /// مثال:
  /// ```dart
  /// expect(TestUtils.findByKey(Key('my-widget')), findsOneWidget);
  /// ```
  static Finder findByKey(Key key) => find.byKey(key);

  /// الضغط على widget
  ///
  /// يُستخدم هذا للضغط على widget.
  ///
  /// [tester] الـ WidgetTester
  /// [finder] الـ Finder للـ widget
  ///
  /// مثال:
  /// ```dart
  /// await TestUtils.tap(tester, find.text('اضغط هنا'));
  /// ```
  static Future<void> tap(WidgetTester tester, Finder finder) async {
    await tester.tap(finder);
    await tester.pump();
  }

  /// إدخال نص في TextField
  ///
  /// يُستخدم هذا لإدخال نص في TextField.
  ///
  /// [tester] الـ WidgetTester
  /// [finder] الـ Finder للـ TextField
  /// [text] النص المراد إدخاله
  ///
  /// مثال:
  /// ```dart
  /// await TestUtils.enterText(
  ///   tester,
  ///   find.byType(TextField),
  ///   'نص الاختبار',
  /// );
  /// ```
  static Future<void> enterText(
    WidgetTester tester,
    Finder finder,
    String text,
  ) async {
    await tester.enterText(finder, text);
    await tester.pump();
  }

  /// التحقق من وجود widget
  ///
  /// يُستخدم هذا للتحقق من وجود widget.
  ///
  /// [finder] الـ Finder للـ widget
  ///
  /// Returns true إذا كان الـ widget موجود
  ///
  /// مثال:
  /// ```dart
  /// final exists = TestUtils.widgetExists(find.text('مرحباً'));
  /// ```
  static bool widgetExists(Finder finder) => finder.evaluate().isNotEmpty;

  /// الانتظار لمدة معينة
  ///
  /// يُستخدم هذا للانتظار لمدة معينة في الاختبار.
  ///
  /// [tester] الـ WidgetTester
  /// [duration] المدة
  ///
  /// مثال:
  /// ```dart
  /// await TestUtils.wait(tester, Duration(seconds: 1));
  /// ```
  static Future<void> wait(
    WidgetTester tester,
    Duration duration,
  ) async {
    await tester.pump(duration);
  }
}
