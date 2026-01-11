/// Test Helpers - دوال مساعدة للاختبارات
///
/// يوفر هذا الملف دوال مساعدة لإنشاء وإدارة موارد الاختبار
/// مثل قاعدة البيانات والـ Providers.
///
/// Enhanced for workspace-transformation project
library;

import 'dart:io';

import 'package:basir_accounting_system/features/customers/data/models/customer_model.dart';
import 'package:basir_accounting_system/features/invoices/data/models/invoice_model.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice_status.dart';
import 'package:basir_accounting_system/features/settings/data/models/business_settings_model.dart';
import 'package:basir_accounting_system/features/settings/data/models/profile_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path/path.dart' as path;

/// دوال مساعدة للاختبارات
class TestHelpers {
  /// إنشاء Isar instance للاختبار في الذاكرة
  ///
  /// يُنشئ قاعدة بيانات Isar في الذاكرة لاستخدامها في الاختبارات.
  /// كل اختبار يحصل على قاعدة بيانات منفصلة باستخدام timestamp فريد.
  ///
  /// Enhanced features:
  /// - Automatic Isar core initialization
  /// - Unique database names per test
  /// - Memory-based for faster tests
  /// - Proper error handling
  ///
  /// مثال:
  /// ```dart
  /// final isar = await TestHelpers.createTestIsar();
  /// // استخدام isar في الاختبار
  /// await TestHelpers.cleanupTestIsar(isar);
  /// ```
  static Future<Isar> createTestIsar({
    String? customName,
    bool useMemory = true,
  }) async {
    try {
      // تهيئة Isar Core للاختبارات مع تحميل تلقائي
      await Isar.initializeIsarCore(download: true);

      final dbName =
          customName ?? 'test_${DateTime.now().millisecondsSinceEpoch}';

      return Isar.open(
        [
          CustomerModelSchema,
          InvoiceModelSchema,
          ProfileModelSchema,
          BusinessSettingsModelSchema,
        ],
        directory: useMemory ? '' : _getTestDirectory(),
        name: dbName,
      );
    } catch (e) {
      throw Exception('Failed to create test Isar instance: $e');
    }
  }

  /// الحصول على مجلد الاختبارات المؤقت
  static String _getTestDirectory() {
    final tempDir = Directory.systemTemp;
    final testDir = Directory(path.join(tempDir.path, 'basir_test_db'));
    if (!testDir.existsSync()) {
      testDir.createSync(recursive: true);
    }
    return testDir.path;
  }

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
  static ProviderContainer createTestContainer({List<Override>? overrides}) =>
      ProviderContainer(overrides: overrides ?? []);

  /// تنظيف ProviderContainer بعد الاختبار
  ///
  /// يُغلق الـ container ويحرر الموارد.
  static void cleanupTestContainer(ProviderContainer container) {
    container.dispose();
  }

  /// إنشاء بيانات اختبار للعملاء
  ///
  /// يُنشئ قائمة من العملاء للاستخدام في الاختبارات.
  static List<CustomerModel> createTestCustomers({int count = 3}) =>
      List.generate(
        count,
        (index) => CustomerModel()
          ..customerId = 'customer_${index + 1}'
          ..nameAr = 'عميل ${index + 1}'
          ..nameEn = 'Customer ${index + 1}'
          ..email = 'customer${index + 1}@example.com'
          ..phone = '05${(index + 1).toString().padLeft(8, '0')}'
          ..address = 'عنوان العميل ${index + 1}'
          ..createdAt = DateTime.now().subtract(Duration(days: index))
          ..updatedAt = DateTime.now().subtract(Duration(days: index)),
      );

  /// إنشاء بيانات اختبار للفواتير
  ///
  /// يُنشئ قائمة من الفواتير للاستخدام في الاختبارات.
  static List<InvoiceModel> createTestInvoices({int count = 3}) =>
      List.generate(
        count,
        (index) => InvoiceModel()
          ..invoiceId = 'invoice_${index + 1}'
          ..customerId = 'customer_${index + 1}'
          ..customerName = 'عميل ${index + 1}'
          ..taxRate = 0.15
          ..status = index == 0 ? InvoiceStatus.draft : InvoiceStatus.sent
          ..issuedDate = DateTime.now().subtract(Duration(days: index))
          ..dueDate = DateTime.now().add(Duration(days: 30 - index))
          ..createdAt = DateTime.now().subtract(Duration(days: index))
          ..updatedAt = DateTime.now().subtract(Duration(days: index)),
      );

  /// تنظيف مجلد الاختبارات المؤقت
  ///
  /// يحذف جميع ملفات قاعدة البيانات المؤقتة.
  static Future<void> cleanupTestDirectory() async {
    try {
      final testDir = Directory(_getTestDirectory());
      if (testDir.existsSync()) {
        await testDir.delete(recursive: true);
      }
    } on FileSystemException catch (_) {
      // تجاهل الأخطاء في التنظيف
    }
  }

  /// قياس أداء الاختبار
  ///
  /// يقيس الوقت المستغرق لتنفيذ دالة معينة.
  static Future<T> measurePerformance<T>(
    String testName,
    Future<T> Function() test,
  ) async {
    final stopwatch = Stopwatch()..start();
    try {
      final result = await test();
      stopwatch.stop();
      debugPrint('⏱️  $testName took ${stopwatch.elapsedMilliseconds}ms');
      return result;
    } catch (e) {
      stopwatch.stop();
      debugPrint(
        '❌ $testName failed after ${stopwatch.elapsedMilliseconds}ms: $e',
      );
      rethrow;
    }
  }
}
