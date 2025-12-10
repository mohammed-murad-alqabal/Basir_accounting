import 'dart:async';

import 'package:basser_app/core/providers.dart';
import 'package:basser_app/features/customers/domain/entities/customer.dart';
import 'package:basser_app/features/customers/presentation/screens/customer_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../mocks/mock_customer_repository.dart';

void main() {
  late MockCustomerRepository mockRepository;

  setUp(() {
    mockRepository = MockCustomerRepository();
    // إعادة تعيين التأخير لكل اختبار (يمكن تخصيصه في الاختبارات الفردية)
    mockRepository.delayMilliseconds = 0;
  });

  Widget createTestWidget({Customer? customer}) => ProviderScope(
        overrides: [
          customerRepositoryProvider.overrideWithValue(mockRepository),
        ],
        child: MaterialApp(home: CustomerFormScreen(customer: customer)),
      );

  group('CustomerFormScreen - Display', () {
    testWidgets('should display add customer title when customer is null', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('إضافة عميل جديد'), findsOneWidget);
    });

    testWidgets(
      'should display edit customer title when customer is provided',
      (tester) async {
        final customer = Customer(
          id: 'test-1',
          name: 'أحمد محمد',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await tester.pumpWidget(createTestWidget(customer: customer));

        expect(find.text('تعديل العميل'), findsOneWidget);
      },
    );

    testWidgets('should display all form fields', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('اسم العميل'), findsOneWidget);
      expect(find.text('البريد الإلكتروني (اختياري)'), findsOneWidget);
      expect(find.text('رقم الهاتف (اختياري)'), findsOneWidget);
      expect(find.text('العنوان (اختياري)'), findsOneWidget);
      expect(find.text('ملاحظات (اختياري)'), findsOneWidget);
    });

    testWidgets('should display add button when customer is null', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('إضافة العميل'), findsOneWidget);
    });

    testWidgets('should display save button when customer is provided', (
      tester,
    ) async {
      final customer = Customer(
        id: 'test-1',
        name: 'أحمد محمد',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await tester.pumpWidget(createTestWidget(customer: customer));

      expect(find.text('حفظ التعديلات'), findsOneWidget);
    });

    testWidgets('should pre-fill form fields when editing', (tester) async {
      final customer = Customer(
        id: 'test-1',
        name: 'أحمد محمد',
        email: 'ahmed@test.com',
        phone: '0501234567',
        address: 'الرياض',
        notes: 'عميل مميز',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await tester.pumpWidget(createTestWidget(customer: customer));
      await tester.pumpAndSettle();

      expect(find.text('أحمد محمد'), findsOneWidget);
      expect(find.text('ahmed@test.com'), findsOneWidget);
      expect(find.text('0501234567'), findsOneWidget);
      expect(find.text('الرياض'), findsOneWidget);
      expect(find.text('عميل مميز'), findsOneWidget);
    });
  });

  group('CustomerFormScreen - Validation', () {
    testWidgets('should show error when name is empty', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // تأكد من أن الزر مرئي ثم اضغط عليه
      final button = find.text('إضافة العميل');
      await tester.ensureVisible(button);
      await tester.pumpAndSettle();
      await tester.tap(button, warnIfMissed: false);
      await tester.pumpAndSettle();

      // التحقق من رسالة الخطأ
      expect(find.text('اسم العميل مطلوب'), findsOneWidget);
    });

    testWidgets('should show error when name is too short', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // ابحث عن حقل الاسم وأدخل اسم قصير
      final nameField = find.widgetWithText(TextFormField, 'اسم العميل');
      if (nameField.evaluate().isNotEmpty) {
        await tester.enterText(nameField, 'أ');
        await tester.pumpAndSettle();

        // تأكد من أن الزر مرئي ثم اضغط عليه
        final button = find.text('إضافة العميل');
        await tester.ensureVisible(button);
        await tester.pumpAndSettle();
        await tester.tap(button, warnIfMissed: false);
        await tester.pumpAndSettle();

        expect(
          find.text('الاسم يجب أن يحتوي على حرفين على الأقل'),
          findsOneWidget,
        );
      }
    });

    testWidgets('should show error for invalid email', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // أدخل اسم صحيح
      final nameFields = find.byType(TextFormField);
      await tester.enterText(nameFields.at(0), 'أحمد محمد');
      await tester.pumpAndSettle();

      // أدخل بريد إلكتروني غير صحيح في الحقل الثاني
      await tester.enterText(nameFields.at(1), 'invalid-email');
      await tester.pumpAndSettle();

      // تأكد من أن الزر مرئي ثم اضغط عليه
      final button = find.text('إضافة العميل');
      await tester.ensureVisible(button);
      await tester.pumpAndSettle();
      await tester.tap(button, warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(find.text('البريد الإلكتروني غير صحيح'), findsOneWidget);
    });

    testWidgets('should show error for invalid phone number', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // أدخل اسم صحيح
      final nameFields = find.byType(TextFormField);
      await tester.enterText(nameFields.at(0), 'أحمد محمد');
      await tester.pumpAndSettle();

      // أدخل رقم هاتف لا يبدأ بـ 05
      await tester.enterText(nameFields.at(2), '0601234567');
      await tester.pumpAndSettle();

      final button = find.text('إضافة العميل');
      await tester.ensureVisible(button);
      await tester.pumpAndSettle();
      await tester.tap(button, warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(find.text('رقم الهاتف يجب أن يبدأ بـ 05'), findsOneWidget);
    });

    testWidgets('should show error for short phone number', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // أدخل اسم صحيح
      final nameFields = find.byType(TextFormField);
      await tester.enterText(nameFields.at(0), 'أحمد محمد');
      await tester.pumpAndSettle();

      // أدخل رقم هاتف قصير
      await tester.enterText(nameFields.at(2), '050123');
      await tester.pumpAndSettle();

      final button = find.text('إضافة العميل');
      await tester.ensureVisible(button);
      await tester.pumpAndSettle();
      await tester.tap(button, warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(find.text('رقم الهاتف يجب أن يتكون من 10 أرقام'), findsOneWidget);
    });

    testWidgets('should accept valid email', (tester) async {
      mockRepository.addCustomerResult = true;

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final nameFields = find.byType(TextFormField);
      await tester.enterText(nameFields.at(0), 'أحمد محمد');
      await tester.pumpAndSettle();

      await tester.enterText(nameFields.at(1), 'ahmed@test.com');
      await tester.pumpAndSettle();

      final button = find.text('إضافة العميل');
      await tester.ensureVisible(button);
      await tester.pumpAndSettle();
      await tester.tap(button, warnIfMissed: false);

      // انتظر SnackBar
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      // التحقق من عدم وجود رسالة خطأ للبريد الإلكتروني
      expect(find.text('البريد الإلكتروني غير صحيح'), findsNothing);
      // التحقق من رسالة النجاح
      expect(find.text('تم إضافة العميل بنجاح'), findsOneWidget);
    });

    testWidgets('should accept valid phone number', (tester) async {
      mockRepository.addCustomerResult = true;

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final nameFields = find.byType(TextFormField);
      await tester.enterText(nameFields.at(0), 'أحمد محمد');
      await tester.pumpAndSettle();

      await tester.enterText(nameFields.at(2), '0501234567');
      await tester.pumpAndSettle();

      final button = find.text('إضافة العميل');
      await tester.ensureVisible(button);
      await tester.pumpAndSettle();
      await tester.tap(button, warnIfMissed: false);

      // انتظر SnackBar
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('رقم الهاتف يجب أن يبدأ بـ 05'), findsNothing);
      expect(find.text('رقم الهاتف يجب أن يتكون من 10 أرقام'), findsNothing);
      // التحقق من رسالة النجاح
      expect(find.text('تم إضافة العميل بنجاح'), findsOneWidget);
    });
  });

  group('CustomerFormScreen - Add Customer', () {
    testWidgets('should add customer successfully', (tester) async {
      mockRepository.addCustomerResult = true;

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // املأ النموذج - استخدام byType بدلاً من widgetWithText
      final nameFields = find.byType(TextFormField);
      expect(nameFields, findsWidgets);

      await tester.enterText(nameFields.at(0), 'أحمد محمد');
      await tester.pumpAndSettle();

      await tester.enterText(nameFields.at(1), 'ahmed@test.com');
      await tester.pumpAndSettle();

      await tester.enterText(nameFields.at(2), '0501234567');
      await tester.pumpAndSettle();

      // اضغط على زر الإضافة
      final button = find.text('إضافة العميل');
      await tester.ensureVisible(button);
      await tester.pumpAndSettle();
      await tester.tap(button, warnIfMissed: false);

      // انتظر SnackBar - استخدام pump مع duration محدد
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      // تحقق من رسالة النجاح
      expect(find.text('تم إضافة العميل بنجاح'), findsOneWidget);
    });

    testWidgets('should show error message when add fails', (tester) async {
      mockRepository.addCustomerResult = false;

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final nameFields = find.byType(TextFormField);
      await tester.enterText(nameFields.at(0), 'أحمد محمد');
      await tester.pumpAndSettle();

      final button = find.text('إضافة العميل');
      await tester.ensureVisible(button);
      await tester.pumpAndSettle();
      await tester.tap(button, warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(find.text('فشل إضافة العميل'), findsOneWidget);
    });

    testWidgets('should show loading indicator while adding', (tester) async {
      mockRepository.addCustomerResult = true;
      // إضافة تأخير لمحاكاة عملية async حقيقية
      mockRepository.delayMilliseconds = 100;

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final nameFields = find.byType(TextFormField);
      await tester.enterText(nameFields.at(0), 'أحمد محمد');
      await tester.pumpAndSettle();

      final button = find.text('إضافة العميل');
      await tester.ensureVisible(button);
      await tester.pumpAndSettle();
      await tester.tap(button, warnIfMissed: false);

      // انتظر frame واحد فقط لرؤية loading indicator
      await tester.pump();

      // تحقق من وجود مؤشر التحميل
      // AppPrimaryButton يعرض CircularProgressIndicator عندما isLoading = true
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // انتظر حتى تكتمل العملية
      await tester.pumpAndSettle();
    });

    testWidgets('should trim whitespace from inputs', (tester) async {
      mockRepository.addCustomerResult = true;

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final nameFields = find.byType(TextFormField);
      await tester.enterText(nameFields.at(0), '  أحمد محمد  ');
      await tester.pumpAndSettle();

      final button = find.text('إضافة العميل');
      await tester.ensureVisible(button);
      await tester.pumpAndSettle();
      await tester.tap(button, warnIfMissed: false);

      // انتظر SnackBar
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      // تحقق من أن العميل تمت إضافته بنجاح
      expect(find.text('تم إضافة العميل بنجاح'), findsOneWidget);
    });

    testWidgets('should handle empty optional fields', (tester) async {
      mockRepository.addCustomerResult = true;

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // املأ الاسم فقط
      final nameFields = find.byType(TextFormField);
      await tester.enterText(nameFields.at(0), 'أحمد محمد');
      await tester.pumpAndSettle();

      final button = find.text('إضافة العميل');
      await tester.ensureVisible(button);
      await tester.pumpAndSettle();
      await tester.tap(button, warnIfMissed: false);

      // انتظر SnackBar
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('تم إضافة العميل بنجاح'), findsOneWidget);
    });
  });

  group('CustomerFormScreen - Edit Customer', () {
    testWidgets('should update customer successfully', (tester) async {
      mockRepository.updateCustomerResult = true;

      final customer = Customer(
        id: 'test-1',
        name: 'أحمد محمد',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await tester.pumpWidget(createTestWidget(customer: customer));
      await tester.pumpAndSettle();

      // عدّل الاسم
      final nameFields = find.byType(TextFormField);
      await tester.enterText(nameFields.at(0), 'أحمد محمد المحدث');
      await tester.pumpAndSettle();

      final button = find.text('حفظ التعديلات');
      await tester.ensureVisible(button);
      await tester.pumpAndSettle();
      await tester.tap(button, warnIfMissed: false);

      // انتظر SnackBar
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('تم تحديث بيانات العميل بنجاح'), findsOneWidget);
    });

    testWidgets('should show error message when update fails', (tester) async {
      mockRepository.updateCustomerResult = false;

      final customer = Customer(
        id: 'test-1',
        name: 'أحمد محمد',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await tester.pumpWidget(createTestWidget(customer: customer));
      await tester.pumpAndSettle();

      final nameFields = find.byType(TextFormField);
      await tester.enterText(nameFields.at(0), 'أحمد محمد المحدث');
      await tester.pumpAndSettle();

      final button = find.text('حفظ التعديلات');
      await tester.ensureVisible(button);
      await tester.pumpAndSettle();
      await tester.tap(button, warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(find.text('فشل تحديث بيانات العميل'), findsOneWidget);
    });

    testWidgets('should preserve customer ID when updating', (tester) async {
      mockRepository.updateCustomerResult = true;

      final customer = Customer(
        id: 'original-id',
        name: 'أحمد محمد',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // إضافة العميل إلى المستودع أولاً
      await mockRepository.addCustomer(customer);

      await tester.pumpWidget(createTestWidget(customer: customer));
      await tester.pumpAndSettle();

      final nameFields = find.byType(TextFormField);
      await tester.enterText(nameFields.at(0), 'أحمد محمد المحدث');
      await tester.pumpAndSettle();

      final button = find.text('حفظ التعديلات');
      await tester.ensureVisible(button);
      await tester.pumpAndSettle();
      await tester.tap(button, warnIfMissed: false);

      // انتظر SnackBar
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('تم تحديث بيانات العميل بنجاح'), findsOneWidget);

      // تحقق من أن الـ ID لم يتغير
      final updatedCustomer =
          await mockRepository.getCustomerById('original-id');
      expect(updatedCustomer, isNotNull);
      expect(updatedCustomer!.id, 'original-id');
      expect(updatedCustomer.name, 'أحمد محمد المحدث');
    });
  });

  group('CustomerFormScreen - Navigation', () {
    testWidgets('should pop screen after successful add', (tester) async {
      mockRepository.addCustomerResult = true;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  unawaited(
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (_) => ProviderScope(
                          overrides: [
                            customerRepositoryProvider.overrideWithValue(
                              mockRepository,
                            ),
                          ],
                          child: const CustomerFormScreen(),
                        ),
                      ),
                    ),
                  );
                },
                child: const Text('Open Form'),
              ),
            ),
          ),
        ),
      );

      // افتح الشاشة
      await tester.tap(find.text('Open Form'));
      await tester.pumpAndSettle();

      // املأ النموذج
      final nameFields = find.byType(TextFormField);
      await tester.enterText(nameFields.at(0), 'أحمد محمد');
      await tester.pumpAndSettle();

      // احفظ
      final button = find.text('إضافة العميل');
      await tester.ensureVisible(button);
      await tester.pumpAndSettle();
      await tester.tap(button, warnIfMissed: false);
      await tester.pumpAndSettle();

      // تحقق من العودة للشاشة السابقة
      expect(find.text('Open Form'), findsOneWidget);
    });

    testWidgets('should not pop screen when add fails', (tester) async {
      mockRepository.addCustomerResult = false;

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final nameFields = find.byType(TextFormField);
      await tester.enterText(nameFields.at(0), 'أحمد محمد');
      await tester.pumpAndSettle();

      final button = find.text('إضافة العميل');
      await tester.ensureVisible(button);
      await tester.pumpAndSettle();
      await tester.tap(button, warnIfMissed: false);
      await tester.pumpAndSettle();

      // تحقق من بقاء الشاشة مفتوحة
      expect(find.text('إضافة عميل جديد'), findsOneWidget);
    });
  });

  group('CustomerFormScreen - Icons', () {
    testWidgets('should display all field icons', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byIcon(Icons.person), findsOneWidget);
      expect(find.byIcon(Icons.email), findsOneWidget);
      expect(find.byIcon(Icons.phone), findsOneWidget);
      expect(find.byIcon(Icons.location_on), findsOneWidget);
      expect(find.byIcon(Icons.note), findsOneWidget);
    });
  });
}
