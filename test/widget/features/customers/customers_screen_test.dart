import 'package:basser_app/core/assets/app_illustrations.dart';
import 'package:basser_app/features/customers/domain/entities/customer.dart';
import 'package:basser_app/features/customers/presentation/providers/customer_provider.dart';
import 'package:basser_app/features/customers/presentation/screens/customers_screen.dart';
import 'package:basser_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../fixtures/customer_fixtures.dart';

void main() {
  group('CustomersScreen - Display', () {
    testWidgets('should display app bar with title', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            customersProvider.overrideWith(
              (ref) async => CustomerFixtures.allCustomers,
            ),
          ],
          child: const MaterialApp(
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale('ar'),
            home: CustomersScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('العملاء'), findsOneWidget);
    });

    testWidgets('should display empty state when no customers', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            customersProvider.overrideWith((ref) async => <Customer>[]),
          ],
          child: const MaterialApp(
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale('ar'),
            home: CustomersScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert Mastery Strings
      expect(find.text('قاعدة بيانات العملاء جاهزة'), findsOneWidget);
      expect(find.text('ابدأ بإضافة أول شريك نجاح لك'), findsOneWidget);
      expect(find.byType(EmptyStateIllustration), findsOneWidget);
    });

    testWidgets('should display loading indicator when loading',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            customersProvider.overrideWith((ref) async {
              await Future<void>.delayed(const Duration(milliseconds: 100));
              return CustomerFixtures.allCustomers;
            }),
          ],
          child: const MaterialApp(
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale('ar'),
            home: CustomersScreen(),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 10));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pumpAndSettle();
    });

    testWidgets('should display list of customers when data is available',
        (tester) async {
      final customers = CustomerFixtures.allCustomers;
      await tester.pumpWidget(
        ProviderScope(
          overrides: [customersProvider.overrideWith((ref) async => customers)],
          child: const MaterialApp(
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale('ar'),
            home: CustomersScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text(CustomerFixtures.customer1.name), findsOneWidget);
    });
  });

  group('CustomersScreen - Interactions', () {
    testWidgets('should handle tap on add button', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            customersProvider.overrideWith(
              (ref) async => CustomerFixtures.allCustomers,
            ),
          ],
          child: const MaterialApp(
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale('ar'),
            home: CustomersScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.add_rounded));
      await tester.pump();
      expect(find.byIcon(Icons.add_rounded), findsOneWidget);
    });
  });
}
