/// Golden Test Helper - مساعد اختبارات Golden Files
///
/// المشروع: بصير MVP
/// المؤلف: فريق وكلاء تطوير مشروع بصير
///
/// يوفر دوال مساعدة لإنشاء وإدارة Golden File Tests
/// مع دعم كامل للعربية وRTL layout
library;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// مساعد اختبارات Golden Files
class GoldenTestHelper {
  /// إنشاء MaterialApp للاختبارات مع دعم العربية
  static Widget createGoldenTestApp({
    required Widget child,
    ThemeData? theme,
    Locale locale = const Locale('ar', 'SA'),
    TextDirection textDirection = TextDirection.rtl,
    ProviderContainer? container,
  }) {
    Widget app = MaterialApp(
      theme: theme ?? _createTestTheme(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', 'SA'),
        Locale('en', 'US'),
      ],
      locale: locale,
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: textDirection,
        child: Scaffold(
          body: child,
        ),
      ),
    );

    // إضافة ProviderScope إذا تم توفير container
    if (container != null) {
      app = UncontrolledProviderScope(
        container: container,
        child: app,
      );
    }

    return app;
  }

  /// إنشاء theme للاختبارات
  static ThemeData _createTestTheme() => ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto', // استخدام خط ثابت للاختبارات
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          headlineLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          titleMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          titleSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          bodyLarge: TextStyle(fontSize: 16),
          bodyMedium: TextStyle(fontSize: 14),
          bodySmall: TextStyle(fontSize: 12),
          labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          labelSmall: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
        ),
      );

  /// تشغيل golden test مع إعدادات مختلفة
  static Future<void> runGoldenTest({
    required WidgetTester tester,
    required Widget widget,
    required String goldenFileName,
    Size? size,
    List<Locale>? locales,
    List<ThemeData>? themes,
    ProviderContainer? container,
  }) async {
    // الإعدادات الافتراضية
    final testLocales = locales ?? [const Locale('ar', 'SA')];
    final testThemes = themes ?? [_createTestTheme()];
    final testSize = size ?? const Size(400, 600);

    // تعيين حجم الشاشة
    await tester.binding.setSurfaceSize(testSize);

    var testIndex = 0;
    for (final locale in testLocales) {
      for (final theme in testThemes) {
        final textDirection =
            locale.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr;

        // إنشاء التطبيق للاختبار
        final testApp = createGoldenTestApp(
          child: widget,
          theme: theme,
          locale: locale,
          textDirection: textDirection,
          container: container,
        );

        // رسم الـ widget
        await tester.pumpWidget(testApp);
        await tester.pumpAndSettle();

        // إنشاء اسم الملف
        final fileName = testIndex == 0
            ? goldenFileName
            : '${goldenFileName}_${locale.languageCode}_theme$testIndex';

        // مقارنة مع golden file
        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile('golden/$fileName.png'),
        );

        testIndex++;
      }
    }
  }

  /// اختبار widget في أحجام شاشات مختلفة
  static Future<void> runMultiSizeGoldenTest({
    required WidgetTester tester,
    required Widget widget,
    required String goldenFileName,
    List<Size>? sizes,
    ProviderContainer? container,
  }) async {
    final testSizes = sizes ??
        [
          const Size(320, 568), // iPhone SE
          const Size(375, 667), // iPhone 8
          const Size(414, 896), // iPhone 11 Pro Max
          const Size(360, 640), // Android Medium
          const Size(411, 731), // Android Large
        ];

    for (var i = 0; i < testSizes.length; i++) {
      final size = testSizes[i];
      await tester.binding.setSurfaceSize(size);

      final testApp = createGoldenTestApp(
        child: widget,
        container: container,
      );

      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      final fileName =
          '${goldenFileName}_${size.width.toInt()}x${size.height.toInt()}';

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('golden/$fileName.png'),
      );
    }
  }

  /// اختبار حالات مختلفة للـ widget
  static Future<void> runStateGoldenTest({
    required WidgetTester tester,
    required Map<String, Widget> states,
    required String baseGoldenFileName,
    Size? size,
    ProviderContainer? container,
  }) async {
    final testSize = size ?? const Size(400, 600);
    await tester.binding.setSurfaceSize(testSize);

    for (final entry in states.entries) {
      final stateName = entry.key;
      final widget = entry.value;

      final testApp = createGoldenTestApp(
        child: widget,
        container: container,
      );

      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      final fileName = '${baseGoldenFileName}_$stateName';

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('golden/$fileName.png'),
      );
    }
  }

  /// إنشاء بيانات اختبار للعملاء
  static Map<String, dynamic> createTestCustomerData({
    String id = 'test-customer-1',
    String name = 'عميل تجريبي',
    String email = 'test@example.com',
    String phone = '0501234567',
    String address = 'الرياض، المملكة العربية السعودية',
  }) =>
      {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'address': address,
        'createdAt': DateTime(2024),
        'updatedAt': DateTime(2024),
      };

  /// إنشاء بيانات اختبار للفواتير
  static Map<String, dynamic> createTestInvoiceData({
    String id = 'test-invoice-1',
    String customerId = 'test-customer-1',
    String customerName = 'عميل تجريبي',
    String invoiceNumber = 'INV-001',
    double amount = 1000.0,
    double tax = 150.0,
    double total = 1150.0,
    String status = 'مرسلة',
  }) =>
      {
        'id': id,
        'customerId': customerId,
        'customerName': customerName,
        'invoiceNumber': invoiceNumber,
        'amount': amount,
        'tax': tax,
        'total': total,
        'status': status,
        'createdAt': DateTime(2024),
        'updatedAt': DateTime(2024),
      };

  /// تنظيف بعد الاختبارات
  static Future<void> cleanup(WidgetTester tester) async {
    // إعادة تعيين حجم الشاشة للافتراضي
    await tester.binding.setSurfaceSize(null);
  }

  /// إعدادات خاصة لاختبار الـ animations
  static Future<void> disableAnimations(WidgetTester tester) async {
    // تعطيل الـ animations للحصول على نتائج ثابتة
    await tester.binding.setSurfaceSize(const Size(400, 600));
    tester.view.physicalSize = const Size(400, 600);
    tester.view.devicePixelRatio = 1.0;
  }

  /// إعادة تفعيل الـ animations
  static void enableAnimations(WidgetTester tester) {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  }
}

/// Extension لتسهيل استخدام Golden Tests
extension GoldenTestExtension on WidgetTester {
  /// تشغيل golden test سريع
  Future<void> goldenTest(
    Widget widget,
    String fileName, {
    Size? size,
    ProviderContainer? container,
  }) async {
    await GoldenTestHelper.runGoldenTest(
      tester: this,
      widget: widget,
      goldenFileName: fileName,
      size: size,
      container: container,
    );
  }

  /// تشغيل golden test متعدد الأحجام
  Future<void> multiSizeGoldenTest(
    Widget widget,
    String fileName, {
    List<Size>? sizes,
    ProviderContainer? container,
  }) async {
    await GoldenTestHelper.runMultiSizeGoldenTest(
      tester: this,
      widget: widget,
      goldenFileName: fileName,
      sizes: sizes,
      container: container,
    );
  }

  /// تشغيل golden test متعدد الحالات
  Future<void> stateGoldenTest(
    Map<String, Widget> states,
    String baseFileName, {
    Size? size,
    ProviderContainer? container,
  }) async {
    await GoldenTestHelper.runStateGoldenTest(
      tester: this,
      states: states,
      baseGoldenFileName: baseFileName,
      size: size,
      container: container,
    );
  }
}
