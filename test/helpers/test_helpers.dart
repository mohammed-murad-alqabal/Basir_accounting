/// دوال مساعدة للاختبارات
///
/// يوفر هذا الملف مجموعة من الدوال المساعدة لتسهيل كتابة الاختبارات
/// في تطبيق بصير.
library;

import 'package:basser_app/features/customers/data/models/customer_model.dart';
import 'package:basser_app/features/invoices/data/models/invoice_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

/// فئة تحتوي على دوال مساعدة للاختبارات
class TestHelpers {
  /// إنشاء Isar instance للاختبار في الذاكرة
  ///
  /// يُستخدم هذا لإنشاء قاعدة بيانات مؤقتة في الذاكرة للاختبارات.
  /// القاعدة تُحذف تلقائياً بعد إغلاقها.
  ///
  /// مثال:
  /// ```dart
  /// final isar = await TestHelpers.createTestIsar();
  /// // استخدام isar في الاختبارات
  /// await TestHelpers.cleanupTestIsar(isar);
  /// ```
  static Future<Isar> createTestIsar() async => Isar.open(
        [CustomerModelSchema, InvoiceModelSchema],
        directory: '',
        name: 'test_${DateTime.now().millisecondsSinceEpoch}',
      );

  /// تنظيف قاعدة البيانات بعد الاختبار
  ///
  /// يُستخدم هذا لإغلاق وحذف قاعدة البيانات المؤقتة بعد انتهاء الاختبار.
  ///
  /// [isar] قاعدة البيانات المراد تنظيفها
  ///
  /// مثال:
  /// ```dart
  /// await TestHelpers.cleanupTestIsar(isar);
  /// ```
  static Future<void> cleanupTestIsar(Isar isar) async {
    await isar.close(deleteFromDisk: true);
  }

  /// إنشاء ProviderContainer للاختبار
  ///
  /// يُستخدم هذا لإنشاء container لاختبار Riverpod providers.
  ///
  /// [overrides] قائمة بالـ overrides للـ providers (اختياري)
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
  /// يُستخدم هذا لإغلاق الـ container وتحرير الموارد.
  ///
  /// [container] الـ container المراد تنظيفه
  static void cleanupTestContainer(ProviderContainer container) {
    container.dispose();
  }
}
