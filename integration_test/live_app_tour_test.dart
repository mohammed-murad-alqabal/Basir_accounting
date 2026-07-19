import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockito/mockito.dart';

import '../test/mocks/app_mocks.mocks.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('مشهد جولة في النظام الحي', (tester) async {
    // إعداد الـ Mocks
    final mockAuth = MockAuthService();
    final mockCustomerRepo = MockCustomerRepository();
    final mockInvoiceRepo = MockInvoiceRepository();

    // إعداد السلوك الافتراضي لـ Mocks
    when(mockAuth.isLoggedIn()).thenAnswer((_) async => true);
    when(mockAuth.hasAccount()).thenAnswer((_) async => true);
    when(mockAuth.isGuest()).thenAnswer((_) async => false);
    when(mockAuth.shouldKeepLoggedIn()).thenAnswer((_) async => true);
    when(mockCustomerRepo.getAllCustomers()).thenAnswer((_) async => []);
    when(mockInvoiceRepo.getAllInvoices()).thenAnswer((_) async => []);
    when(mockAuth.onAuthStateChange).thenAnswer((_) => Stream.value(null));

    // تشغيل التطبيق مع الـ Mocks
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authServiceProvider.overrideWithValue(mockAuth),
          customerRepositoryProvider.overrideWithValue(mockCustomerRepo),
          invoiceRepositoryProvider.overrideWithValue(mockInvoiceRepo),
        ],
        child: const BasirApp(),
      ),
    );

    await tester.pumpAndSettle();

    // 1. التحقق من الشاشة الرئيسية (Dashboard)
    debugPrint('Checking Dashboard Basir Elements...');
    expect(find.text('المبيعات الكلية'), findsOneWidget);
    expect(find.text('المتأخرة'), findsOneWidget);
    expect(find.text('الإجراءات المالية السريعة'), findsOneWidget);

    // 2. التنقل إلى شاشة العملاء
    debugPrint('Navigating to Customers...');
    await tester.tap(
      find.descendant(
        of: find.byType(BottomNavigationBar),
        matching: find.text('العملاء'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('العملاء'), findsAtLeastNWidgets(1));

    // 3. التحقق من الحالة الفارغة للعملاء (Basir Illustration)
    expect(find.text('قاعدة بيانات العملاء جاهزة'), findsOneWidget);

    // 4. العودة للرئيسية
    debugPrint('Going back to Dashboard...');
    await tester.tap(
      find.descendant(
        of: find.byType(BottomNavigationBar),
        matching: find.text('الرئيسية'),
      ),
    );
    await tester.pumpAndSettle();

    // 5. التنقل إلى الفواتير
    debugPrint('Navigating to Invoices...');
    await tester.tap(
      find.descendant(
        of: find.byType(BottomNavigationBar),
        matching: find.text('الفواتير'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('الفواتير'), findsAtLeastNWidgets(1));

    // 6. التحقق من الحالة الفارغة للفواتير
    expect(find.text('سجل الفواتير الذكي منظم'), findsOneWidget);

    // 7. العودة للرئيسية
    debugPrint('Going back to Dashboard...');
    await tester.tap(
      find.descendant(
        of: find.byType(BottomNavigationBar),
        matching: find.text('الرئيسية'),
      ),
    );
    await tester.pumpAndSettle();

    // 8. التنقل إلى الإعدادات
    debugPrint('Navigating to Settings...');
    await tester.tap(find.byIcon(Icons.settings_rounded));
    await tester.pumpAndSettle();
    expect(find.text('الإعدادات'), findsAtLeastNWidgets(1));

    // 9. العودة للرئيسية
    debugPrint('Verifying back navigation from Settings...');
    await tester.tap(
      find.descendant(
        of: find.byType(BottomNavigationBar),
        matching: find.text('الرئيسية'),
      ),
    );
    await tester.pumpAndSettle();

    debugPrint('System Tour Completed Successfully!');
  });
}
