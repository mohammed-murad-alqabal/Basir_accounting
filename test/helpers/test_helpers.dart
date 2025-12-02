/// Test Helpers - دوال مساعدة للاختبارات
///
/// يوفر هذا الملف دوال مساعدة لإنشاء وإدارة موارد الاختبار
/// مثل قاعدة البيانات والـ Providers.
library;

import 'package:basser_app/features/customers/data/models/customer_model.dart';
import 'package:basser_app/features/invoices/data/models/invoice_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

/// دوال مساعدة للاختبارات
class TestHelpers {
  /// إنشاء Isar instance للاختبار في الذاكرة
  ///
  /// يُنشئ قاعدة بيانات Isar في الذاكرة لاستخدامها في الاختبارات.
  /// كل اختبار يحصل على قاعدة بيانات منفصلة باستخدام timestamp فريد.
  ///
  /// مثال:
  /// ```dart
  /// final isar = await TestHelpers.createTestIsar();
  /// // استخدام isar في الاختبار
  /// await TestHelpers.cleanupTestIsar(isar);
  /// ```
  static Future<Isar> createTestIsar() async => Isar.open(
        [CustomerModelSchema, InvoiceModelSchema],
        directory: '',
        name: 'test_${DateTime.now().millisecondsSinceEpoch}',
      );

  /// تنظيف قاعدة البيانات بعد الاختبار
  ///
  /// يُغلق قاعدة البيانات ويحذفها من القرص.
  /// يجب استدعاء هذه الدالة في tearDown لكل اختبار.
  ///
  /// مثال:
  /// ```dart
  /// tearDown(() async {
  ///   await TestHelpers.cleanupTestIsar(isar);
  /// });
  /// ```
  static Future<void> cleanupTestIsar(Isar isar) async {
    await isar.close(deleteFromDisk: true);
  }

  /// إنشاء ProviderContainer للاختبار
  ///
  /// يُنشئ container لاختبار Riverpod providers مع إمكانية
  /// override للـ providers.
  ///
  /// مثال:
  /// ```dart
  /// final container = TestHelpers.createTestContainer(
  ///   overrides: [
  ///     customerRepositoryProvider.overrideWithValue(mockRepository),
  ///   ],
  /// );
  /// ```
  static ProviderContainer createTestContainer({
    List<Override>? overrides,
  }) =>
      ProviderContainer(
        overrides: overrides ?? [],
      );

  /// تنظيف ProviderContainer بعد الاختبار
  ///
  /// يُغلق الـ container ويحرر الموارد.
  static void cleanupTestContainer(ProviderContainer container) {
    container.dispose();
  }
}
