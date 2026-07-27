import 'package:basir_accounting_system/core/assets/app_illustrations.dart';
import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/features/auth/domain/models/auth_models.dart';
import 'package:basir_accounting_system/features/customers/domain/entities/customer.dart';
import 'package:basir_accounting_system/features/customers/presentation/providers/customer_provider.dart';
import 'package:basir_accounting_system/features/customers/presentation/screens/customers_screen.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../fixtures/customer_fixtures.dart';

void main() {
  Widget createTestWidget({
    required List<Override> overrides,
  }) =>
      ProviderScope(
        overrides: [
          appIconsProvider.overrideWithValue(const MaterialAppIcons()),
          currentUserProfileProvider.overrideWith(
            (ref) => const BasirUser(
              id: 'test-user',
              email: 'test@example.com',
              displayName: 'Test User',
              role: UserRole.accountant,
              permissions: Permission.viewFinancials,
            ),
          ),
          ...overrides,
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
      );

  group('CustomersScreen - Display', () {
    testWidgets('should display app bar with title', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          overrides: [
            customersProvider.overrideWith(
              (ref) async => CustomerFixtures.allCustomers,
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('العملاء'), findsOneWidget);
    });

    testWidgets('should display empty state when no customers', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          overrides: [
            customersProvider.overrideWith((ref) async => <Customer>[]),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('قاعدة بيانات العملاء جاهزة'), findsOneWidget);
      expect(find.text('ابدأ بإضافة أول شريك نجاح لك'), findsOneWidget);
      expect(find.byType(EmptyStateIllustration), findsOneWidget);
    });

    testWidgets('should display loading indicator when loading', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          overrides: [
            customersProvider.overrideWith((ref) async {
              await Future<void>.delayed(const Duration(milliseconds: 100));
              return CustomerFixtures.allCustomers;
            }),
          ],
        ),
      );
      await tester.pump(const Duration(milliseconds: 10));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pumpAndSettle();
    });

    testWidgets('should display list of customers when data is available', (
      tester,
    ) async {
      final customers = CustomerFixtures.allCustomers;
      await tester.pumpWidget(
        createTestWidget(
          overrides: [
            customersProvider.overrideWith((ref) async => customers),
          ],
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text(CustomerFixtures.customer1.nameAr), findsOneWidget);
    });
  });

  group('CustomersScreen - UI/UX Improvements (Task 17)', () {
    testWidgets('uses GlassScaffold as root layout container', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          overrides: [
            customersProvider.overrideWith(
              (ref) async => CustomerFixtures.allCustomers,
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(GlassScaffold), findsOneWidget);
    });

    testWidgets('add button icon uses IconSizes.md (24px) - WCAG standard', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          overrides: [
            customersProvider.overrideWith(
              (ref) async => CustomerFixtures.allCustomers,
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      final addIconFinder = find.descendant(
        of: find.ancestor(
          of: find.byTooltip('إضافة عميل جديد'),
          matching: find.byType(IconButton),
        ),
        matching: find.byType(Icon),
      );
      final addIcon = tester.widget<Icon>(addIconFinder);
      expect(addIcon.size, IconSizes.md);
    });

    testWidgets(
        'add button has BoxConstraints minWidth/minHeight = TouchTargets.minimum (48px)',
        (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          overrides: [
            customersProvider.overrideWith(
              (ref) async => CustomerFixtures.allCustomers,
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      final addButton = tester.widget<IconButton>(
        find.ancestor(
          of: find.byTooltip('إضافة عميل جديد'),
          matching: find.byType(IconButton),
        ),
      );
      expect(addButton.constraints?.minWidth, TouchTargets.minimum);
      expect(addButton.constraints?.minHeight, TouchTargets.minimum);
    });

    testWidgets('add button uses EdgeInsets.zero for padding', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          overrides: [
            customersProvider.overrideWith(
              (ref) async => CustomerFixtures.allCustomers,
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      final addButton = tester.widget<IconButton>(
        find.ancestor(
          of: find.byTooltip('إضافة عميل جديد'),
          matching: find.byType(IconButton),
        ),
      );
      expect(addButton.padding, EdgeInsets.zero);
    });

    testWidgets('add button has Arabic tooltip for accessibility', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          overrides: [
            customersProvider.overrideWith(
              (ref) async => CustomerFixtures.allCustomers,
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byTooltip('إضافة عميل جديد'), findsOneWidget);
    });

    testWidgets('customer cards use AppListCard component', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          overrides: [
            customersProvider.overrideWith(
              (ref) async => CustomerFixtures.allCustomers,
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(AppListCard), findsWidgets);
    });

    testWidgets('customer cards have Semantics wrapper with button:true', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          overrides: [
            customersProvider.overrideWith(
              (ref) async => CustomerFixtures.allCustomers,
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      final allSemantics = tester.widgetList<Semantics>(
        find.descendant(
          of: find.byType(ListView),
          matching: find.byType(Semantics),
        ),
      );
      final hasButtonSemantics = allSemantics.any(
        (s) => s.properties.button ?? false,
      );
      expect(hasButtonSemantics, isTrue);
    });

    testWidgets('search field uses AppSearchField component', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          overrides: [
            customersProvider.overrideWith(
              (ref) async => CustomerFixtures.allCustomers,
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(AppSearchField), findsOneWidget);
    });
  });

  group('CustomersScreen - Interactions', () {
    testWidgets('should handle tap on add button', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          overrides: [
            customersProvider.overrideWith(
              (ref) async => CustomerFixtures.allCustomers,
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();
      final addButton = find.ancestor(
        of: find.byTooltip('إضافة عميل جديد'),
        matching: find.byType(IconButton),
      );
      expect(addButton, findsOneWidget);
      await tester.tap(addButton);
      await tester.pump();
      expect(addButton, findsOneWidget);
    });
  });
}
