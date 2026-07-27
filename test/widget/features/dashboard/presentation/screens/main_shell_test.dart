import 'package:basir_accounting_system/core/theme/app_theme.dart';
import 'package:basir_accounting_system/core/theme/services/icon_customization_service.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/features/dashboard/presentation/screens/main_shell.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:flutter/material.dart' hide Durations;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('MainShell - Navigation Structure', () {
    late ProviderContainer container;

    const testScreens = <Widget>[
      SizedBox.expand(key: <credential-fixture>('screen-home')),
      SizedBox.expand(key: <credential-fixture>('screen-invoices')),
      SizedBox.expand(key: <credential-fixture>('screen-vendors')),
      SizedBox.expand(key: <credential-fixture>('screen-customers')),
      SizedBox.expand(key: <credential-fixture>('screen-inventory')),
      SizedBox.expand(key: <credential-fixture>('screen-assets')),
      SizedBox.expand(key: <credential-fixture>('screen-settings')),
    ];

    const navIcons = <IconData>[
      Icons.home_outlined,
      Icons.receipt_long_outlined,
      Icons.business_center,
      Icons.people_outline,
      Icons.inventory_2,
      Icons.account_balance_wallet_outlined,
      Icons.settings_outlined,
    ];

    const navLabelsAr = <String>[
      'الرئيسية',
      'الفواتير',
      'الموردون',
      'العملاء',
      'المخزون',
      'الأصول الثابتة',
      'الإعدادات',
    ];

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

    Widget createTestWidget({
      Locale locale = const Locale('ar'),
      ThemeMode mode = ThemeMode.light,
    }) =>
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: mode == ThemeMode.light ? AppTheme.lightTheme : AppTheme.darkTheme,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            locale: locale,
            home: const MainShell(screens: testScreens),
          ),
        );

    testWidgets('should render all 7 navigation icons', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      for (final icon in navIcons) {
        expect(find.byIcon(icon), findsOneWidget);
      }
    });

    testWidgets('should render all 7 Arabic labels', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      for (final label in navLabelsAr) {
        expect(find.text(label), findsOneWidget);
      }
    });

    testWidgets('all nav icons should be 24px (IconSizes.md)', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      for (final icon in navIcons) {
        final iconWidget = tester.widget<Icon>(find.byIcon(icon));
        expect(iconWidget.size, IconSizes.md);
        expect(IconSizes.md, 24);
      }
    });

    testWidgets('all nav items should have 48px minimum touch target', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final navItemBoxes = find.descendant(
        of: find.byType(Row),
        matching: find.byWidgetPredicate(
          (w) =>
              w is SizedBox &&
              w.width == TouchTargets.minimum &&
              w.height == kBottomNavigationBarHeight,
        ),
      );

      expect(navItemBoxes, findsNWidgets(7));
      expect(TouchTargets.minimum, 48);
    });

    testWidgets('bottom nav bar should have SizedBox with correct height', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final navBarBox = find.byWidgetPredicate(
        (w) => w is SizedBox && w.height == kBottomNavigationBarHeight && w.width == null,
      );
      expect(navBarBox, findsWidgets);
      final boxes = find.descendant(
        of: find.byType(SafeArea),
        matching: find.byWidgetPredicate(
          (w) => w is SizedBox && w.height == kBottomNavigationBarHeight,
        ),
      );
      expect(boxes.evaluate().isNotEmpty, true);
    });

    testWidgets('bottom nav bar should have SafeArea with top: false', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final safeArea = tester.widget<SafeArea>(
        find.descendant(
          of: find.byType(DecoratedBox),
          matching: find.byType(SafeArea),
        ),
      );
      expect(safeArea.top, false);
    });

    testWidgets('bottom nav bar should have top divider border', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final decoratedBox = tester.widget<DecoratedBox>(
        find.byWidgetPredicate(
          (w) =>
              w is DecoratedBox &&
              w.decoration is BoxDecoration &&
              (w.decoration as BoxDecoration).border != null &&
              (w.decoration as BoxDecoration).color == AppColors.surface,
        ),
      );
      final boxDeco = decoratedBox.decoration as BoxDecoration;
      expect(boxDeco.border?.top.width, BorderWidths.thin);
    });
  });

  group('MainShell - Selection & Navigation', () {
    late ProviderContainer container;

    const testScreens = <Widget>[
      SizedBox.expand(key: <credential-fixture>('screen-home')),
      SizedBox.expand(key: <credential-fixture>('screen-invoices')),
      SizedBox.expand(key: <credential-fixture>('screen-vendors')),
      SizedBox.expand(key: <credential-fixture>('screen-customers')),
      SizedBox.expand(key: <credential-fixture>('screen-inventory')),
      SizedBox.expand(key: <credential-fixture>('screen-assets')),
      SizedBox.expand(key: <credential-fixture>('screen-settings')),
    ];

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

    Widget createTestWidget({Locale locale = const Locale('ar')}) => UncontrolledProviderScope(
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
            locale: locale,
            home: const MainShell(screens: testScreens),
          ),
        );

    testWidgets('initial index should be 0 (home selected)', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final homeIcon = tester.widget<Icon>(find.byIcon(Icons.home_outlined));
      expect(homeIcon.color, AppColors.primary);

      final invoicesIcon = tester.widget<Icon>(find.byIcon(Icons.receipt_long_outlined));
      expect(invoicesIcon.color, AppColors.textSecondary);
    });

    testWidgets('tapping nav item should switch screen content', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('screen-home')), findsOneWidget);

      await tester.tap(find.byIcon(Icons.receipt_long_outlined));
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('screen-invoices')), findsOneWidget);
    });

    testWidgets('selected item should use primary color for icon', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.people_outline));
      await tester.pumpAndSettle();

      final customersIcon = tester.widget<Icon>(find.byIcon(Icons.people_outline));
      expect(customersIcon.color, AppColors.primary);

      final homeIcon = tester.widget<Icon>(find.byIcon(Icons.home_outlined));
      expect(homeIcon.color, AppColors.textSecondary);
    });

    testWidgets('selected item should use primary color for label', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.inventory_2));
      await tester.pumpAndSettle();

      final invLabelFinder = find.text('المخزون');
      final invText = tester.widget<AnimatedDefaultTextStyle>(
        find
            .ancestor(
              of: invLabelFinder,
              matching: find.byType(AnimatedDefaultTextStyle),
            )
            .first,
      );
      expect(invText.style.color, AppColors.primary);
      expect(invText.style.fontWeight, FontWeights.bold);
    });

    testWidgets('unselected item should use textSecondary color and medium', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final settingsLabelFinder = find.text('الإعدادات');
      final settingsText = tester.widget<AnimatedDefaultTextStyle>(
        find
            .ancestor(
              of: settingsLabelFinder,
              matching: find.byType(AnimatedDefaultTextStyle),
            )
            .first,
      );
      expect(settingsText.style.color, AppColors.textSecondary);
      expect(settingsText.style.fontWeight, FontWeights.medium);
    });

    testWidgets('selected item AnimatedContainer should have primaryLight background',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final homeIconAncestors = find.ancestor(
        of: find.byIcon(Icons.home_outlined),
        matching: find.byType(AnimatedContainer),
      );
      final animatedContainer = tester.widget<AnimatedContainer>(homeIconAncestors.first);
      final deco = animatedContainer.decoration! as BoxDecoration;
      expect(deco.color, AppColors.primaryLight);
      expect(deco.borderRadius, BorderRadius.circular(Radii.sm));
    });

    testWidgets('unselected AnimatedContainer should have transparent color', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final iconAncestors = find.ancestor(
        of: find.byIcon(Icons.settings_outlined),
        matching: find.byType(AnimatedContainer),
      );
      final animatedContainer = tester.widget<AnimatedContainer>(iconAncestors.first);
      final deco = animatedContainer.decoration! as BoxDecoration;
      expect(deco.color, Colors.transparent);
    });

    testWidgets('tapping already selected item should not reset', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.home_outlined));
      await tester.pumpAndSettle();

      final homeIcon = tester.widget<Icon>(find.byIcon(Icons.home_outlined));
      expect(homeIcon.color, AppColors.primary);
    });

    testWidgets('should navigate through all 7 screens sequentially', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      const navIcons = <IconData>[
        Icons.home_outlined,
        Icons.receipt_long_outlined,
        Icons.business_center,
        Icons.people_outline,
        Icons.inventory_2,
        Icons.account_balance_wallet_outlined,
        Icons.settings_outlined,
      ];
      const screenKeys = <String>[
        'screen-home',
        'screen-invoices',
        'screen-vendors',
        'screen-customers',
        'screen-inventory',
        'screen-assets',
        'screen-settings',
      ];

      for (var i = 0; i < navIcons.length; i++) {
        await tester.tap(find.byIcon(navIcons[i]));
        await tester.pumpAndSettle();

        expect(find.byKey(ValueKey(screenKeys[i])), findsOneWidget);

        final icon = tester.widget<Icon>(find.byIcon(navIcons[i]));
        expect(icon.color, AppColors.primary);
      }
    });
  });

  group('MainShell - Semantics', () {
    late ProviderContainer container;

    const testScreens = <Widget>[
      SizedBox.expand(key: <credential-fixture>('s1')),
      SizedBox.expand(key: <credential-fixture>('s2')),
      SizedBox.expand(key: <credential-fixture>('s3')),
      SizedBox.expand(key: <credential-fixture>('s4')),
      SizedBox.expand(key: <credential-fixture>('s5')),
      SizedBox.expand(key: <credential-fixture>('s6')),
      SizedBox.expand(key: <credential-fixture>('s7')),
    ];

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

    Widget createTestWidget({Locale locale = const Locale('ar')}) => UncontrolledProviderScope(
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
            locale: locale,
            home: const MainShell(screens: testScreens),
          ),
        );

    testWidgets('home nav item should have correct semantics when selected', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final semanticsData = tester.getSemantics(find.byIcon(Icons.home_outlined));
      expect(semanticsData.label, contains('الصفحة الرئيسية'));
    });

    testWidgets('settings nav item should have correct semantics label', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final semanticsData = tester.getSemantics(find.byIcon(Icons.settings_outlined));
      expect(semanticsData.label, contains('الإعدادات'));
    });

    testWidgets('all 7 nav items should have Semantics wrapper', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      const navIconsSemantic = <(IconData, String)>[
        (Icons.home_outlined, 'الصفحة الرئيسية'),
        (Icons.receipt_long_outlined, 'الفواتير'),
        (Icons.business_center, 'الموردون'),
        (Icons.people_outline, 'العملاء'),
        (Icons.inventory_2, 'المخزون'),
        (Icons.account_balance_wallet_outlined, 'الأصول'),
        (Icons.settings_outlined, 'الإعدادات'),
      ];

      for (final (iconData, expectedLabel) in navIconsSemantic) {
        final semanticsData = tester.getSemantics(find.byIcon(iconData));
        expect(semanticsData.label, contains(expectedLabel));
      }
    });
  });
}
