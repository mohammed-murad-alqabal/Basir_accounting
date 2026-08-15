import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/core/theme/tokens/app_icons.dart';
import 'package:basir_accounting_system/features/auth/domain/models/auth_models.dart';
import 'package:basir_accounting_system/features/customers/domain/entities/customer.dart';
import 'package:basir_accounting_system/features/customers/presentation/screens/customer_form_screen.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../fixtures/customer_fixtures.dart';
import '../../../mocks/mock_customer_repository.dart';

void main() {
  group('CustomerFormScreen Tests', () {
    Widget createTestWidget({
      required MockCustomerRepository repository,
      Customer? customer,
    }) => ProviderScope(
      overrides: [
        appIconsProvider.overrideWithValue(const MaterialAppIcons()),
        currentUserProfileProvider.overrideWith(
          (ref) => const BasirUser(
            id: 'test-user',
            email: 'test@example.com',
            displayName: 'Test User',
            role: UserRole.admin,
          ),
        ),
        customerRepositoryProvider.overrideWithValue(repository),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('ar'),
        home: CustomerFormScreen(customer: customer),
      ),
    );

    testWidgets('should display add customer title when customer is null', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appIconsProvider.overrideWithValue(const MaterialAppIcons()),
            currentUserProfileProvider.overrideWith(
              (ref) => const BasirUser(
                id: 'test-user',
                email: 'test@example.com',
                displayName: 'Test User',
                role: UserRole.admin,
              ),
            ),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale('ar'),
            home: CustomerFormScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('إضافة عميل جديد'), findsAtLeastNWidgets(1));
    });

    testWidgets(
      'should display edit customer title when customer is provided',
      (tester) async {
        final customer = CustomerFixtures.customer1;
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              appIconsProvider.overrideWithValue(const MaterialAppIcons()),
              currentUserProfileProvider.overrideWith(
                (ref) => const BasirUser(
                  id: 'test-user',
                  email: 'test@example.com',
                  displayName: 'Test User',
                  role: UserRole.admin,
                ),
              ),
            ],
            child: MaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: const Locale('ar'),
              home: CustomerFormScreen(customer: customer),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('تعديل العميل'), findsAtLeastNWidgets(1));
      },
    );

    testWidgets('يحفظ عميلاً جديداً بعد إدخال بيانات محاسبية صحيحة', (
      tester,
    ) async {
      final repository = MockCustomerRepository(customers: []);
      await tester.pumpWidget(createTestWidget(repository: repository));
      await tester.pumpAndSettle();

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'مؤسسة بصير');
      await tester.enterText(fields.at(1), 'Basir Establishment');
      await tester.enterText(fields.at(2), 'billing@basir.sa');
      await tester.enterText(fields.at(3), '0501234567');
      await tester.enterText(fields.at(6), '1250.50');

      final saveAction = find.byType(AppEnhancedButton).last;
      await tester.ensureVisible(saveAction);
      await tester.tap(saveAction);
      await tester.pumpAndSettle();

      final customers = await repository.getAllCustomers();
      expect(customers, hasLength(1));
      expect(customers.single.nameAr, 'مؤسسة بصير');
      expect(customers.single.nameEn, 'Basir Establishment');
      expect(customers.single.email, 'billing@basir.sa');
      expect(customers.single.phone, '0501234567');
      expect(customers.single.creditLimit, 1250.50);
    });

    testWidgets('يحدّث بيانات العميل القائم عبر مسار التعديل', (tester) async {
      final originalCustomer = CustomerFixtures.customer1;
      final repository = MockCustomerRepository(customers: [originalCustomer]);
      await tester.pumpWidget(
        createTestWidget(customer: originalCustomer, repository: repository),
      );
      await tester.pumpAndSettle();

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(3), '0507654321');
      final saveAction = find.byType(AppEnhancedButton).last;
      await tester.ensureVisible(saveAction);
      await tester.tap(saveAction);
      await tester.pumpAndSettle();

      final updatedCustomer = await repository.getCustomerById(originalCustomer.id);
      expect(updatedCustomer, isNotNull);
      expect(updatedCustomer!.phone, '0507654321');
      expect(updatedCustomer.nameAr, originalCustomer.nameAr);
    });

    testWidgets('يرفض حفظ العميل عند إدخال بريد إلكتروني غير صالح', (
      tester,
    ) async {
      final repository = MockCustomerRepository(customers: []);
      await tester.pumpWidget(createTestWidget(repository: repository));
      await tester.pumpAndSettle();

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'عميل الاختبار');
      await tester.enterText(fields.at(1), 'Test Customer');
      await tester.enterText(fields.at(2), 'not-an-email');

      final saveAction = find.byType(AppEnhancedButton).last;
      await tester.ensureVisible(saveAction);
      await tester.tap(saveAction);
      await tester.pumpAndSettle();

      expect(repository.isEmpty, isTrue);
      expect(find.text('البريد الإلكتروني غير صحيح'), findsOneWidget);
    });
  });
}
