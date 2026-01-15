import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/core/theme/tokens/app_icons.dart';
import 'package:basir_accounting_system/features/auth/domain/models/auth_models.dart';
import 'package:basir_accounting_system/features/customers/presentation/screens/customer_form_screen.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../fixtures/customer_fixtures.dart';

void main() {
  group('CustomerFormScreen Tests', () {
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
  });
}
