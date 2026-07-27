import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/core/theme/app_theme.dart';
import 'package:basir_accounting_system/core/theme/tokens/app_icons.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/features/auth/domain/models/auth_models.dart';
import 'package:basir_accounting_system/features/settings/presentation/screens/settings_screen.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('SettingsScreen', () {
    late ProviderContainer container;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      container = ProviderContainer(
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
          companySettingsProvider.overrideWith(
            (ref) => {
              'companyName': 'Test Company',
              'invoiceStyle': 'standard',
            },
          ),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    Widget createTestWidget() => UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('ar'),
            home: const SettingsScreen(),
          ),
        );

    late AppLocalizations l10n;

    Future<void> setUpWidgets(WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();
      l10n = AppLocalizations.of(tester.element(find.byType(SettingsScreen)));
    }

    group('Basic Display', () {
      testWidgets('should display app bar with title', (tester) async {
        await setUpWidgets(tester);
        expect(find.widgetWithText(AppBar, l10n.settingsTitle), findsOneWidget);
      });

      testWidgets('should display all section titles', (tester) async {
        await setUpWidgets(tester);

        // This text appears twice: section title and company card subtitle
        expect(find.text(l10n.companySettingsTitle), findsNWidgets(2));
        expect(find.text(l10n.accountTitle), findsNWidgets(3));
        expect(find.text(l10n.notificationsTitle), findsOneWidget);
        expect(find.text(l10n.appearanceTitle), findsOneWidget);
        expect(find.text(l10n.helpTitle), findsOneWidget);
      });
    });

    group('SettingsScreen - UI/UX Improvements (Task 17)', () {
      testWidgets('should use GlassScaffold as root container', (tester) async {
        await setUpWidgets(tester);
        expect(find.byType(GlassScaffold), findsOneWidget);
      });

      testWidgets('should have settings buttons as ListTile with icons',
          (tester) async {
        await setUpWidgets(tester);

        final listTileFinder = find.descendant(
          of: find.byType(SettingsScreen),
          matching: find.byType(ListTile),
        );

        final listTiles = tester.widgetList<ListTile>(listTileFinder);
        expect(listTiles.length, greaterThan(0));

        for (final tile in listTiles) {
          final hasLeading = tile.leading != null;
          final isLeadingIcon = tile.leading is Icon;
          expect(
            hasLeading && isLeadingIcon,
            isTrue,
            reason: 'Each ListTile should have an Icon as leading widget',
          );
        }
      });

      testWidgets(
          'should have logout button as AppEnhancedButton with danger type',
          (tester) async {
        await setUpWidgets(tester);

        final logoutButtonFinder = find.widgetWithText(
          AppEnhancedButton,
          l10n.logoutLabel,
        );
        expect(logoutButtonFinder, findsOneWidget);

        final logoutButton =
            tester.widget<AppEnhancedButton>(logoutButtonFinder);
        expect(logoutButton.type, AppEnhancedButtonType.danger);
      });

      testWidgets('should have correct AppBar title using l10n',
          (tester) async {
        await setUpWidgets(tester);

        final glassScaffold = tester.widget<GlassScaffold>(
          find.byType(GlassScaffold),
        );
        expect(glassScaffold.title, l10n.settingsTitle);

        final appBarFinder = find.descendant(
          of: find.byType(GlassScaffold),
          matching: find.byType(AppBar),
        );
        expect(appBarFinder, findsOneWidget);

        final titleFinder = find.descendant(
          of: appBarFinder,
          matching: find.text(l10n.settingsTitle),
        );
        expect(titleFinder, findsOneWidget);
      });

      testWidgets('should have Semantics elements for important sections',
          (tester) async {
        await setUpWidgets(tester);

        final semanticsFinder = find.descendant(
          of: find.byType(SettingsScreen),
          matching: find.byType(Semantics),
        );
        expect(semanticsFinder, findsWidgets);

        final allSemantics = tester.widgetList<Semantics>(semanticsFinder);
        final appearanceSemanticsList = allSemantics.where(
          (s) => s.properties.label == l10n.appearanceSettingsTitle,
        );
        expect(appearanceSemanticsList, isNotEmpty);

        final appearanceSemantics = appearanceSemanticsList.first;
        expect(
          appearanceSemantics.properties.label,
          l10n.appearanceSettingsTitle,
        );
        expect(appearanceSemantics.properties.button, isTrue);
      });

      testWidgets('should use AppTextStyles for settings text display',
          (tester) async {
        await setUpWidgets(tester);

        final textFinder = find.descendant(
          of: find.byType(SettingsScreen),
          matching: find.byType(Text),
        );

        final texts = tester.widgetList<Text>(textFinder);
        expect(texts.length, greaterThan(0));

        final versionTextFinder = find.textContaining('(Platinum)');
        expect(versionTextFinder, findsOneWidget);

        final logoutButtonFinder = find.widgetWithText(
          AppEnhancedButton,
          l10n.logoutLabel,
        );
        expect(logoutButtonFinder, findsOneWidget);
      });

      testWidgets(
          'should display all settings sections (Company, Account, Notifications, Appearance, Help)',
          (tester) async {
        await setUpWidgets(tester);

        expect(
          find.text(l10n.companySettingsTitle),
          findsWidgets,
          reason: 'Company section should be visible',
        );

        expect(
          find.text(l10n.accountTitle),
          findsWidgets,
          reason: 'Account section should be visible',
        );

        expect(
          find.text(l10n.notificationsTitle),
          findsOneWidget,
          reason: 'Notifications section should be visible',
        );

        expect(
          find.text(l10n.appearanceTitle),
          findsOneWidget,
          reason: 'Appearance section should be visible',
        );

        expect(
          find.text(l10n.helpTitle),
          findsOneWidget,
          reason: 'Help section should be visible',
        );
      });
    });
  });
}
