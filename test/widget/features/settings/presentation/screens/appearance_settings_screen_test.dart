import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/core/theme/app_theme.dart';
import 'package:basir_accounting_system/core/theme/services/appearance_service.dart';
import 'package:basir_accounting_system/core/theme/tokens/app_icons.dart';
import 'package:basir_accounting_system/features/settings/presentation/screens/appearance_settings_screen.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('AppearanceSettingsScreen', () {
    late ProviderContainer container;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      container = ProviderContainer(
        overrides: [
          appIconsProvider.overrideWithValue(const MaterialAppIcons()),
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
            home: const AppearanceSettingsScreen(),
          ),
        );

    Future<AppLocalizations> pumpScreen(WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();
      return AppLocalizations.of(
        tester.element(find.byType(AppearanceSettingsScreen)),
      );
    }

    testWidgets('يعرض أقسام المظهر وضوابط الوصول', (tester) async {
      final l10n = await pumpScreen(tester);

      expect(find.byType(GlassScaffold), findsOneWidget);
      expect(find.text(l10n.appearanceSettingsTitle), findsOneWidget);
      expect(find.text(l10n.sectionMode), findsOneWidget);
      expect(find.text(l10n.sectionStyle), findsOneWidget);
      expect(find.text(l10n.sectionAccessibility), findsOneWidget);
      expect(find.text(l10n.sectionCalendar), findsOneWidget);
      expect(find.text(l10n.highContrast), findsOneWidget);
      expect(find.text(l10n.reduceMotion), findsOneWidget);
      expect(find.byType(SegmentedButton<ThemeMode>), findsOneWidget);
      expect(find.byType(SegmentedButton<CalendarType>), findsOneWidget);
    });

    testWidgets('يحدّث وضع السمة عند اختيار النمط الداكن', (tester) async {
      final l10n = await pumpScreen(tester);

      await tester.tap(find.text(l10n.modeDark));
      await tester.pumpAndSettle();

      expect(container.read(themeProvider).value, ThemeMode.dark);
    });

    testWidgets('يحدّث نوع التقويم عند اختيار التقويم الهجري', (tester) async {
      final l10n = await pumpScreen(tester);

      await tester.tap(find.text(l10n.calendarHijri));
      await tester.pumpAndSettle();

      expect(container.read(calendarProvider).value, CalendarType.hijri);
    });

    testWidgets('يحدّث خياري التباين والحركة', (tester) async {
      final l10n = await pumpScreen(tester);

      await tester.tap(find.text(l10n.highContrast));
      await tester.tap(find.text(l10n.reduceMotion));
      await tester.pumpAndSettle();

      final appearance = container.read(appearanceServiceProvider).value;
      expect(appearance?.highContrast, isTrue);
      expect(appearance?.reduceMotion, isTrue);
    });

    testWidgets('يعرض حوار تأكيد الاستعادة ويمكن إلغاؤه', (tester) async {
      final l10n = await pumpScreen(tester);

      await tester.tap(
        find.widgetWithText(AppEnhancedButton, l10n.btnRestoreDefault),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text(l10n.msgResetConfirmation), findsOneWidget);

      await tester.tap(find.widgetWithText(TextButton, l10n.dialogCancel));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('يستعيد تفضيلات إمكانية الوصول بعد تأكيد الاستعادة', (
      tester,
    ) async {
      final l10n = await pumpScreen(tester);

      await tester.tap(find.text(l10n.highContrast));
      await tester.tap(find.text(l10n.reduceMotion));
      await tester.pumpAndSettle();
      expect(
        container.read(appearanceServiceProvider).requireValue.highContrast,
        isTrue,
      );
      expect(
        container.read(appearanceServiceProvider).requireValue.reduceMotion,
        isTrue,
      );

      await tester.tap(
        find.widgetWithText(AppEnhancedButton, l10n.btnRestoreDefault),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(TextButton, l10n.btnRestoreDefault));
      await tester.pumpAndSettle();

      final appearance = container.read(appearanceServiceProvider).requireValue;
      expect(find.byType(AlertDialog), findsNothing);
      expect(appearance.highContrast, isFalse);
      expect(appearance.reduceMotion, isFalse);
    });
  });
}
