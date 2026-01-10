import 'package:basir_app/core/providers.dart';
import 'package:basir_app/core/theme/app_theme.dart';
import 'package:basir_app/core/theme/tokens/app_icons.dart';
import 'package:basir_app/features/settings/presentation/screens/settings_screen.dart';
import 'package:basir_app/l10n/app_localizations.dart';
import 'package:basir_app/shared/widgets/index.dart';
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
          companySettingsProvider.overrideWith(
            (ref) => {
              'companyName': 'Test Company',
              'invoiceStyle': 'standard',
            },
          ),
          appIconsProvider.overrideWith((ref) => const MaterialAppIcons()),
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
        expect(find.byType(AppAppBar), findsOneWidget);
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
  });
}
