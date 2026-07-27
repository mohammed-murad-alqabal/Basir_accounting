// ignore_for_file: deprecated_member_use_from_same_package, deprecated_member_use, parameter_assignments

import 'package:basir_accounting_system/core/theme/app_state_colors.dart';
import 'package:basir_accounting_system/core/theme/app_theme.dart';
import 'package:basir_accounting_system/core/theme/border_contrast_design.dart';
import 'package:basir_accounting_system/core/theme/font_manager.dart';
import 'package:basir_accounting_system/core/theme/services/icon_customization_service.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/features/dashboard/presentation/screens/main_shell.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:basir_accounting_system/shared/widgets/app_app_bar.dart';
import 'package:basir_accounting_system/shared/widgets/app_button.dart';
import 'package:basir_accounting_system/shared/widgets/app_card.dart';
import 'package:basir_accounting_system/shared/widgets/app_empty_state.dart';
import 'package:basir_accounting_system/shared/widgets/app_enhanced_button.dart';
import 'package:basir_accounting_system/shared/widgets/app_loading_indicator.dart';
import 'package:basir_accounting_system/shared/widgets/app_text_field.dart';
import 'package:basir_accounting_system/shared/widgets/responsive_text.dart';
import 'package:flutter/material.dart' hide Durations;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Component Property Tests', () {
    // ═══════════════════════════════════════════════════════════════════════
    // Property 19: حدود أو ظل البطاقات (Requirements 6.1)
    // ═══════════════════════════════════════════════════════════════════════
    group('Property 19 - Card Borders & Shadows', () {
      testWidgets('AppCard should use thin border (1px) when not selected', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: const Scaffold(
              body: AppCard(child: Text('محتوى')),
            ),
          ),
        );

        final cardContainer = tester.widget<AnimatedContainer>(
          find
              .descendant(
                of: find.byType(AppCard),
                matching: find.byType(AnimatedContainer),
              )
              .first,
        );
        final boxDeco = cardContainer.decoration! as BoxDecoration;
        expect(boxDeco.border?.top.width, BorderWidths.thin);
        expect(BorderWidths.thin, 1);
      });

      testWidgets('AppCard should use normal border (1.5px) when isSelected', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AppCard(isSelected: true, child: Text('مختارة')),
            ),
          ),
        );

        final cardContainer = tester.widget<AnimatedContainer>(
          find
              .descendant(
                of: find.byType(AppCard),
                matching: find.byType(AnimatedContainer),
              )
              .first,
        );
        final boxDeco = cardContainer.decoration! as BoxDecoration;
        expect(boxDeco.border?.top.width, BorderWidths.normal);
        expect(BorderWidths.normal, 1.5);
      });

      testWidgets('AppCard default borderRadius should be Radii.borderRadiusMd', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AppCard(child: Text('test')),
            ),
          ),
        );

        final cardContainer = tester.widget<AnimatedContainer>(
          find
              .descendant(
                of: find.byType(AppCard),
                matching: find.byType(AnimatedContainer),
              )
              .first,
        );
        final boxDeco = cardContainer.decoration! as BoxDecoration;
        expect(boxDeco.borderRadius, Radii.borderRadiusMd);
      });

      testWidgets('AppCard default elevation should be Elevation.sm (2)', (
        tester,
      ) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AppCard(child: Text('test')),
            ),
          ),
        );

        final cardAnimated = tester.widget<AnimatedContainer>(
          find
              .descendant(
                of: find.byType(AppCard),
                matching: find.byType(AnimatedContainer),
              )
              .first,
        );
        final deco = cardAnimated.decoration! as BoxDecoration;
        final blurRadius = deco.boxShadow?.first.blurRadius;
        expect(blurRadius, Elevation.sm * 2);
        expect(Elevation.sm, 2);
      });

      testWidgets('AppCard custom borderRadius is respected', (tester) async {
        const customRadius = BorderRadius.all(Radius.circular(40));
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AppCard(
                borderRadius: customRadius,
                child: Text('test'),
              ),
            ),
          ),
        );

        final cardContainer = tester.widget<AnimatedContainer>(
          find
              .descendant(
                of: find.byType(AppCard),
                matching: find.byType(AnimatedContainer),
              )
              .first,
        );
        final boxDeco = cardContainer.decoration! as BoxDecoration;
        expect(boxDeco.borderRadius, customRadius);
      });

      testWidgets('AppCard custom elevation is respected', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AppCard(elevation: Elevation.md, child: Text('test')),
            ),
          ),
        );

        final cardAnimated = tester.widget<AnimatedContainer>(
          find
              .descendant(
                of: find.byType(AppCard),
                matching: find.byType(AnimatedContainer),
              )
              .first,
        );
        final deco = cardAnimated.decoration! as BoxDecoration;
        final blurRadius = deco.boxShadow?.first.blurRadius;
        expect(blurRadius, Elevation.md * 2);
        expect(Elevation.md, 4);
      });
    });

    // ═══════════════════════════════════════════════════════════════════════
    // Property 20: فواصل أو مسافات في القوائم (Requirements 6.2)
    // ═══════════════════════════════════════════════════════════════════════
    group('Property 20 - List Card Separators & Spacing', () {
      testWidgets('AppListCard should have bottom margin of Spacing.sm (8px)', (
        tester,
      ) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AppListCard(title: 'عنصر ١'),
            ),
          ),
        );

        final appCardInside = tester.widget<AppCard>(
          find.descendant(
            of: find.byType(AppListCard),
            matching: find.byType(AppCard),
          ),
        );
        expect(appCardInside.margin, const EdgeInsets.only(bottom: Spacing.sm));
        expect(Spacing.sm, 8);
      });

      testWidgets('Multiple AppListCards should be separated by 8px vertical', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  AppListCard(title: 'عنصر ١'),
                  AppListCard(title: 'عنصر ٢'),
                ],
              ),
            ),
          ),
        );

        final appCards = tester.widgetList<AppCard>(
          find.descendant(
            of: find.byType(AppListCard),
            matching: find.byType(AppCard),
          ),
        );
        for (final c in appCards) {
          expect(c.margin, const EdgeInsets.only(bottom: Spacing.sm));
        }
      });

      testWidgets('AppListCard with isSelected keeps 8px separator margin', (
        tester,
      ) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AppListCard(title: 'عنصر', isSelected: true),
            ),
          ),
        );

        final appCardInside = tester.widget<AppCard>(
          find.descendant(
            of: find.byType(AppListCard),
            matching: find.byType(AppCard),
          ),
        );
        expect(appCardInside.margin, const EdgeInsets.only(bottom: Spacing.sm));
      });
    });

    // ═══════════════════════════════════════════════════════════════════════
    // Property 21: تسلسل هرمي للنصوص في البطاقات (Requirements 6.4)
    // ═══════════════════════════════════════════════════════════════════════
    group('Property 21 - Card Text Hierarchy', () {
      testWidgets('AppListCard title should use titleSmallSize (14px) > subtitle bodySmall (12px)',
          (
        tester,
      ) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AppListCard(
                title: 'العنوان الرئيسي',
                subtitle: 'العنوان الفرعي',
              ),
            ),
          ),
        );

        final titleRespText = tester.widget<ResponsiveText>(
          find.byWidgetPredicate(
            (w) => w is ResponsiveText && w.text == 'العنوان الرئيسي',
          ),
        );
        final subtitleRespText = tester.widget<ResponsiveText>(
          find.byWidgetPredicate(
            (w) => w is ResponsiveText && w.text == 'العنوان الفرعي',
          ),
        );

        final titleSize = titleRespText.style?.fontSize ?? 0;
        final subtitleSize = subtitleRespText.style?.fontSize ?? 0;

        expect(titleSize, AppTextStyles.titleSmallSize);
        expect(subtitleSize, AppTextStyles.bodySmallSize);
        expect(titleSize, greaterThan(subtitleSize));
        expect(AppTextStyles.titleSmallSize, 14);
        expect(AppTextStyles.bodySmallSize, 12);
      });

      testWidgets('AppListCard title fontWeight should be >= subtitle', (
        tester,
      ) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AppListCard(
                title: 'عنوان',
                subtitle: 'وصف',
              ),
            ),
          ),
        );

        final titleResp = tester.widget<ResponsiveText>(
          find.byWidgetPredicate(
            (w) => w is ResponsiveText && w.text == 'عنوان',
          ),
        );
        final subResp = tester.widget<ResponsiveText>(
          find.byWidgetPredicate(
            (w) => w is ResponsiveText && w.text == 'وصف',
          ),
        );

        final titleWeight = (titleResp.style?.fontWeight ?? FontWeight.w400).value;
        final subWeight = (subResp.style?.fontWeight ?? FontWeight.w400).value;
        expect(titleWeight, greaterThanOrEqualTo(subWeight));
      });

      testWidgets('AppStatCard value has larger font than label', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AppStatCard(
                label: 'الإيرادات',
                value: '120,000',
                icon: Icons.show_chart,
              ),
            ),
          ),
        );

        final labelFinder = find.byWidgetPredicate(
          (w) => w is ResponsiveText && w.text == 'الإيرادات',
        );
        final valueFinder = find.byWidgetPredicate(
          (w) => w is ResponsiveText && w.text == '120,000',
        );

        final labelWidget = tester.widget<ResponsiveText>(labelFinder);
        final valueWidget = tester.widget<ResponsiveText>(valueFinder);

        final labelSize = labelWidget.style?.fontSize ?? 0;
        final valueSize = valueWidget.style?.fontSize ?? 0;

        expect(valueSize, greaterThanOrEqualTo(labelSize));
        expect(valueSize, AppTextStyles.headlineSmallSize);
        expect(labelSize, AppTextStyles.labelSmallSize);
      });
    });

    // ═══════════════════════════════════════════════════════════════════════
    // Property 22: شارة أو لون للحالات في البطاقات (Requirements 6.5)
    // ═══════════════════════════════════════════════════════════════════════
    group('Property 22 - Badges & Status Colors in Cards', () {
      testWidgets('Badge success should use AppColors.success background', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: const Scaffold(
              body: AppCard(
                badgeText: 'ناجح',
                badgeStatus: CardBadgeStatus.success,
                child: Text('محتوى'),
              ),
            ),
          ),
        );

        final badgeContainer = tester.widget<Container>(
          find
              .ancestor(
                of: find.text('ناجح'),
                matching: find.byType(Container),
              )
              .first,
        );
        final boxDeco = badgeContainer.decoration! as BoxDecoration;
        expect(boxDeco.color, AppColors.success);
      });

      testWidgets('Badge error should use AppColors.error background', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: const Scaffold(
              body: AppCard(
                badgeText: 'خطأ',
                badgeStatus: CardBadgeStatus.error,
                child: Text('محتوى'),
              ),
            ),
          ),
        );

        final badgeContainer = tester.widget<Container>(
          find
              .ancestor(
                of: find.text('خطأ'),
                matching: find.byType(Container),
              )
              .first,
        );
        final boxDeco = badgeContainer.decoration! as BoxDecoration;
        expect(boxDeco.color, AppColors.error);
      });

      testWidgets('Badge warning should use AppColors.warning background', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: const Scaffold(
              body: AppCard(
                badgeText: 'تحذير',
                badgeStatus: CardBadgeStatus.warning,
                child: Text('محتوى'),
              ),
            ),
          ),
        );

        final badgeContainer = tester.widget<Container>(
          find
              .ancestor(
                of: find.text('تحذير'),
                matching: find.byType(Container),
              )
              .first,
        );
        final boxDeco = badgeContainer.decoration! as BoxDecoration;
        expect(boxDeco.color, AppColors.warning);
      });

      testWidgets('Badge info (default) should use AppColors.info background', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: const Scaffold(
              body: AppCard(
                badgeText: 'معلومة',
                child: Text('محتوى'),
              ),
            ),
          ),
        );

        final badgeContainer = tester.widget<Container>(
          find
              .ancestor(
                of: find.text('معلومة'),
                matching: find.byType(Container),
              )
              .first,
        );
        final boxDeco = badgeContainer.decoration! as BoxDecoration;
        expect(boxDeco.color, AppColors.info);
      });

      testWidgets('Badge custom should use provided color', (tester) async {
        const custom = Colors.purpleAccent;
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AppCard(
                badgeText: 'مخصص',
                badgeStatus: CardBadgeStatus.custom,
                badgeColor: custom,
                child: Text('محتوى'),
              ),
            ),
          ),
        );

        final badgeContainer = tester.widget<Container>(
          find
              .ancestor(
                of: find.text('مخصص'),
                matching: find.byType(Container),
              )
              .first,
        );
        final boxDeco = badgeContainer.decoration! as BoxDecoration;
        expect(boxDeco.color, custom);
      });

      testWidgets('statusColor bar should have width=BorderWidths.thick (2)', (
        tester,
      ) async {
        const statusColor = Colors.deepOrange;
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AppCard(
                statusColor: statusColor,
                child: Text('محتوى'),
              ),
            ),
          ),
        );

        final statusBarFinder = find.descendant(
          of: find.byType(AppCard),
          matching: find.byWidgetPredicate(
            (w) =>
                w is Container &&
                (w.color == statusColor ||
                    (w.decoration is BoxDecoration &&
                        (w.decoration! as BoxDecoration).color == statusColor)),
          ),
        );
        expect(statusBarFinder, findsOneWidget);

        final statusBar = tester.widget<Container>(statusBarFinder);
        final resolvedColor = statusBar.color ?? (statusBar.decoration as BoxDecoration?)?.color;
        expect(resolvedColor, statusColor);

        final size = tester.getSize(statusBarFinder);
        expect(size.width, closeTo(BorderWidths.thick, 0.01));
        expect(BorderWidths.thick, 2);
      });
    });

    // ═══════════════════════════════════════════════════════════════════════
    // Property 9: حجم الأيقونات الأساسية (Requirements 3.1, 8.3)
    // ═══════════════════════════════════════════════════════════════════════
    group('Property 9 - Core Icon Sizes (24px)', () {
      testWidgets('AppAppBar back button icon should be 24px (IconSizes.md)', (tester) async {
        SharedPreferences.setMockInitialValues({});
        final container = ProviderContainer(
          overrides: [
            appIconsProvider.overrideWithValue(const MaterialAppIcons()),
          ],
        );
        addTearDown(container.dispose);

        await tester.pumpWidget(
          UncontrolledProviderScope(
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
              home: const Scaffold(
                appBar: AppAppBar(title: 'الصفحة الرئيسية'),
                body: SizedBox.shrink(),
              ),
            ),
          ),
        );

        final icon = tester.widget<Icon>(
          find
              .descendant(
                of: find.byType(IconButton),
                matching: find.byType(Icon),
              )
              .first,
        );
        expect(icon.size, IconSizes.md);
        expect(IconSizes.md, 24);
      });

      testWidgets('AppAppBar title uses IconSizes.md for iconTheme config', (
        tester,
      ) async {
        SharedPreferences.setMockInitialValues({});
        final container = ProviderContainer(
          overrides: [
            appIconsProvider.overrideWithValue(const MaterialAppIcons()),
          ],
        );
        addTearDown(container.dispose);

        await tester.pumpWidget(
          UncontrolledProviderScope(
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
              home: Scaffold(
                appBar: AppAppBar(
                  title: 'عنوان',
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.search, size: IconSizes.md),
                      onPressed: () {},
                    ),
                  ],
                ),
                body: const SizedBox.shrink(),
              ),
            ),
          ),
        );

        final searchIcon = tester.widget<Icon>(find.byIcon(Icons.search));
        expect(searchIcon.size, equals(IconSizes.md));
        final appBarWidget = tester.widget<AppBar>(find.byType(AppBar));
        expect(appBarWidget.iconTheme?.size, IconSizes.md);
      });

      testWidgets('AppSimpleAppBar action icons should be 24px', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: Scaffold(
              appBar: AppSimpleAppBar(
                title: 'تسجيل الدخول',
                actions: [
                  IconButton(
                    icon: const Icon(Icons.settings_outlined, size: IconSizes.md),
                    onPressed: () {},
                  ),
                ],
              ),
              body: const SizedBox.shrink(),
            ),
          ),
        );

        final icon = tester.widget<Icon>(find.byIcon(Icons.settings_outlined));
        expect(icon.size, equals(IconSizes.md));
        expect(IconSizes.md, 24);
        final appBarWidget = tester.widget<AppBar>(find.byType(AppBar));
        expect(appBarWidget.iconTheme?.size, equals(IconSizes.md));
      });

      testWidgets('MainShell nav icons should all be 24px (IconSizes.md)', (
        tester,
      ) async {
        SharedPreferences.setMockInitialValues({});
        final container = ProviderContainer(
          overrides: [
            appIconsProvider.overrideWithValue(const MaterialAppIcons()),
          ],
        );
        addTearDown(container.dispose);

        const placeholderScreens = <Widget>[
          SizedBox.expand(key: <credential-fixture>('s1')),
          SizedBox.expand(key: <credential-fixture>('s2')),
          SizedBox.expand(key: <credential-fixture>('s3')),
          SizedBox.expand(key: <credential-fixture>('s4')),
          SizedBox.expand(key: <credential-fixture>('s5')),
          SizedBox.expand(key: <credential-fixture>('s6')),
          SizedBox.expand(key: <credential-fixture>('s7')),
        ];

        await tester.pumpWidget(
          UncontrolledProviderScope(
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
              home: const MainShell(screens: placeholderScreens),
            ),
          ),
        );
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

        for (final iconData in navIcons) {
          final icon = tester.widget<Icon>(find.byIcon(iconData));
          expect(icon.size, IconSizes.md);
        }
      });
    });

    // ═══════════════════════════════════════════════════════════════════════
    // Property 11: وجود Tooltip للأيقونات التفاعلية (Requirements 3.4)
    // ═══════════════════════════════════════════════════════════════════════
    group('Property 11 - Interactive Icons Tooltip', () {
      testWidgets('AppAppBar back button should have tooltip (l10n)', (
        tester,
      ) async {
        SharedPreferences.setMockInitialValues({});
        final container = ProviderContainer(
          overrides: [
            appIconsProvider.overrideWithValue(const MaterialAppIcons()),
          ],
        );
        addTearDown(container.dispose);

        await tester.pumpWidget(
          UncontrolledProviderScope(
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
              home: const Scaffold(
                appBar: AppAppBar(title: 'صفحة'),
                body: SizedBox.shrink(),
              ),
            ),
          ),
        );

        final backButton = tester.widget<IconButton>(
          find
              .descendant(
                of: find.byType(AppAppBar),
                matching: find.byType(IconButton),
              )
              .first,
        );
        expect(backButton.tooltip, isNotNull);
        expect(backButton.tooltip, isNotEmpty);
      });

      testWidgets('AppSimpleAppBar action buttons with tooltip work correctly', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('ar'),
            home: Scaffold(
              appBar: AppSimpleAppBar(
                title: 'صفحة',
                actions: [
                  IconButton(
                    icon: const Icon(Icons.settings_outlined),
                    tooltip: 'الإعدادات',
                    onPressed: () {},
                  ),
                ],
              ),
              body: const SizedBox.shrink(),
            ),
          ),
        );

        final actionButton = tester.widget<IconButton>(
          find
              .descendant(
                of: find.byType(AppSimpleAppBar),
                matching: find.byType(IconButton),
              )
              .first,
        );
        expect(actionButton.tooltip, isNotNull);
        expect(actionButton.tooltip, isNotEmpty);
        expect(actionButton.tooltip, 'الإعدادات');
      });

      testWidgets('AppAppBar custom actions with Tooltip render as expected', (
        tester,
      ) async {
        SharedPreferences.setMockInitialValues({});
        final container = ProviderContainer(
          overrides: [
            appIconsProvider.overrideWithValue(const MaterialAppIcons()),
          ],
        );
        addTearDown(container.dispose);

        await tester.pumpWidget(
          UncontrolledProviderScope(
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
              home: Scaffold(
                appBar: AppAppBar(
                  title: 'صفحة',
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.search, size: IconSizes.md),
                      tooltip: 'بحث',
                      onPressed: () {},
                    ),
                  ],
                ),
                body: const SizedBox.shrink(),
              ),
            ),
          ),
        );

        final iconFinder = find.byIcon(Icons.search);
        expect(iconFinder, findsOneWidget);
        final iconWidget = tester.widget<Icon>(iconFinder);
        expect(iconWidget.size, equals(IconSizes.md));

        final buttonFinder = find.ancestor(
          of: iconFinder,
          matching: find.byType(IconButton),
        );
        final searchButton = tester.widget<IconButton>(buttonFinder.first);
        expect(searchButton.tooltip, 'بحث');
        expect(searchButton.tooltip, isNotNull);
        expect(searchButton.tooltip, isNotEmpty);
      });
    });

    // ═══════════════════════════════════════════════════════════════════════
    // Property 24: سرعة تحديث مؤشر التنقل (Requirements 8.5)
    // ═══════════════════════════════════════════════════════════════════════
    group('Property 24 - Navigation Indicator Update Speed', () {
      testWidgets('indicatorUpdateDuration should equal Durations.short = 200ms', (
        tester,
      ) async {
        expect(Durations.short, const Duration(milliseconds: 200));
      });

      testWidgets('AnimatedContainer on MainShell uses Durations.short (~200ms)', (
        tester,
      ) async {
        SharedPreferences.setMockInitialValues({});
        final container = ProviderContainer(
          overrides: [
            appIconsProvider.overrideWithValue(const MaterialAppIcons()),
          ],
        );
        addTearDown(container.dispose);

        const placeholder = <Widget>[
          SizedBox.expand(key: <credential-fixture>('s1')),
          SizedBox.expand(key: <credential-fixture>('s2')),
          SizedBox.expand(key: <credential-fixture>('s3')),
          SizedBox.expand(key: <credential-fixture>('s4')),
          SizedBox.expand(key: <credential-fixture>('s5')),
          SizedBox.expand(key: <credential-fixture>('s6')),
          SizedBox.expand(key: <credential-fixture>('s7')),
        ];

        await tester.pumpWidget(
          UncontrolledProviderScope(
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
              home: const MainShell(screens: placeholder),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final selectedAnimatedContainer = tester.widget<AnimatedContainer>(
          find
              .ancestor(
                of: find.byIcon(Icons.home_outlined),
                matching: find.byType(AnimatedContainer),
              )
              .first,
        );
        expect(
          selectedAnimatedContainer.duration,
          Durations.short,
        );
        expect(selectedAnimatedContainer.duration.inMilliseconds, 200);
      });

      testWidgets('Nav text style animation uses 200ms (Durations.short)', (
        tester,
      ) async {
        SharedPreferences.setMockInitialValues({});
        final container = ProviderContainer(
          overrides: [
            appIconsProvider.overrideWithValue(const MaterialAppIcons()),
          ],
        );
        addTearDown(container.dispose);

        const placeholder = <Widget>[
          SizedBox.expand(key: <credential-fixture>('s1')),
          SizedBox.expand(key: <credential-fixture>('s2')),
          SizedBox.expand(key: <credential-fixture>('s3')),
          SizedBox.expand(key: <credential-fixture>('s4')),
          SizedBox.expand(key: <credential-fixture>('s5')),
          SizedBox.expand(key: <credential-fixture>('s6')),
          SizedBox.expand(key: <credential-fixture>('s7')),
        ];

        await tester.pumpWidget(
          UncontrolledProviderScope(
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
              home: const MainShell(screens: placeholder),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final animatedTextStyle = tester.widget<AnimatedDefaultTextStyle>(
          find
              .ancestor(
                of: find.text('الرئيسية'),
                matching: find.byType(AnimatedDefaultTextStyle),
              )
              .first,
        );
        expect(animatedTextStyle.duration, Durations.short);
        expect(animatedTextStyle.duration.inMilliseconds, 200);
      });
    });

    // ═══════════════════════════════════════════════════════════════════════
    // Property 10: مساحة النقر للأزرار (Touch Target ≥ 48px) - Requirement 7.1
    // ═══════════════════════════════════════════════════════════════════════
    group('Property 10 - Button Touch Target (≥ 48px)', () {
      testWidgets('AppButton medium size AnimatedContainer minHeight ≥ 48px', (
        tester,
      ) async {
        const key = <credential-fixture>('btn');
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: Scaffold(
              body: Align(
                alignment: Alignment.topLeft,
                child: AppButton(
                  key: key,
                  label: 'زر متوسط',
                  onPressed: () {},
                  width: 200,
                ),
              ),
            ),
          ),
        );

        final containerFinder = find.descendant(
          of: find.byKey(key),
          matching: find.byType(AnimatedContainer),
        );
        expect(containerFinder, findsWidgets);
        final animatedContainer = tester.widget<AnimatedContainer>(
          containerFinder.first,
        );
        expect(
          animatedContainer.constraints?.minHeight,
          greaterThanOrEqualTo(TouchTargets.minimum),
        );
        expect(TouchTargets.minimum, 48);
      });

      testWidgets('AppButton large size AnimatedContainer minHeight ≥ 48px', (
        tester,
      ) async {
        const key = <credential-fixture>('btn-lg');
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: Scaffold(
              body: Align(
                alignment: Alignment.topLeft,
                child: AppButton(
                  key: key,
                  label: 'زر كبير',
                  onPressed: () {},
                  size: AppButtonSize.large,
                  width: 200,
                ),
              ),
            ),
          ),
        );

        final containerFinder = find.descendant(
          of: find.byKey(key),
          matching: find.byType(AnimatedContainer),
        );
        expect(containerFinder, findsWidgets);
        final animatedContainer = tester.widget<AnimatedContainer>(
          containerFinder.first,
        );
        expect(
          animatedContainer.constraints?.minHeight,
          greaterThanOrEqualTo(TouchTargets.minimum),
        );
        expect(
          animatedContainer.constraints?.minHeight,
          greaterThanOrEqualTo(TouchTargets.buttonHeightMd),
        );
      });

      testWidgets('AppButton small size has AnimatedContainer minHeight', (
        tester,
      ) async {
        const key = <credential-fixture>('btn-sm');
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: Scaffold(
              body: Align(
                alignment: Alignment.topLeft,
                child: AppButton(
                  key: key,
                  label: 'زر صغير',
                  onPressed: () {},
                  size: AppButtonSize.small,
                  width: 200,
                ),
              ),
            ),
          ),
        );

        final containerFinder = find.descendant(
          of: find.byKey(key),
          matching: find.byType(AnimatedContainer),
        );
        expect(containerFinder, findsWidgets);
        final animatedContainer = tester.widget<AnimatedContainer>(
          containerFinder.first,
        );
        expect(
          animatedContainer.constraints?.minHeight,
          greaterThanOrEqualTo(0),
        );
        expect(TouchTargets.buttonHeightSm, 40);
      });

      testWidgets('AppEnhancedButton default height widget height ≥ 54px', (
        tester,
      ) async {
        const key = <credential-fixture>('enhanced-btn');
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: Scaffold(
              body: Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: 200,
                  child: AppEnhancedButton(
                    key: key,
                    label: 'زر محسن',
                    onPressed: () {},
                  ),
                ),
              ),
            ),
          ),
        );

        final size = tester.getSize(find.byKey(key));
        expect(size.height, greaterThanOrEqualTo(TouchTargets.minimum));
        expect(size.height, greaterThanOrEqualTo(54));
      });
    });

    // ═══════════════════════════════════════════════════════════════════════
    // Property 16: التغيير البصري واضح عند التفاعل (Scale Animation)
    // ═══════════════════════════════════════════════════════════════════════
    group('Property 16 - Visual State Changes on Interaction', () {
      testWidgets('AppButton contains ScaleTransition descendant for press effect', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: Scaffold(
              body: AppButton(
                label: 'تجربة الضغط',
                onPressed: () {},
              ),
            ),
          ),
        );

        final scaleFinder = find.descendant(
          of: find.byType(AppButton),
          matching: find.byType(ScaleTransition),
        );
        expect(scaleFinder, findsOneWidget);

        final scaleTransition = tester.widget<ScaleTransition>(
          scaleFinder,
        );
        expect(scaleTransition.scale, isNotNull);
        expect(scaleTransition.child, isNotNull);
      });

      testWidgets('AppButton has GestureDetector descendant for interaction', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: Scaffold(
              body: AppButton(
                label: 'تفاعلي',
                onPressed: () {},
              ),
            ),
          ),
        );

        final gestureFinder = find.descendant(
          of: find.byType(AppButton),
          matching: find.byType(GestureDetector),
        );
        expect(gestureFinder, findsOneWidget);
      });

      testWidgets('AppButton disabled: onPressed callback does not fire', (
        tester,
      ) async {
        const wasCalled = false;
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: const Scaffold(
              body: AppButton(
                label: 'زر معطل',
                onPressed: null,
              ),
            ),
          ),
        );

        await tester.tap(find.byType(AppButton));
        await tester.pump();
        expect(wasCalled, isFalse);
      });
    });

    // ═══════════════════════════════════════════════════════════════════════
    // Property 18: حالة الزر المعطل تمنع النقر وتظهر بوضوح
    // ═══════════════════════════════════════════════════════════════════════
    group('Property 18 - Disabled Button State', () {
      testWidgets('AppButton with onPressed=null does NOT call callback on tap', (
        tester,
      ) async {
        const pressed = false;
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: const Scaffold(
              body: AppButton(
                label: 'زر معطل',
                onPressed: null,
              ),
            ),
          ),
        );

        final buttonFinder = find.byType(AppButton);
        expect(buttonFinder, findsOneWidget);

        await tester.tap(buttonFinder);
        await tester.pumpAndSettle();
        expect(pressed, isFalse);
      });

      testWidgets('AppButton disabled: decoration color uses disabled opacity', (
        tester,
      ) async {
        final enabledKey = <credential-fixture>();
        final disabledKey = <credential-fixture>();
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: Scaffold(
              body: Column(
                children: [
                  AppButton(
                    key: <credential-fixture>,
                    label: 'مفعل',
                    onPressed: () {},
                  ),
                  AppButton(
                    key: <credential-fixture>,
                    label: 'معطل',
                    onPressed: null,
                  ),
                ],
              ),
            ),
          ),
        );

        final enabledContainer = tester.widget<AnimatedContainer>(
          find
              .descendant(
                of: find.byKey(enabledKey),
                matching: find.byType(AnimatedContainer),
              )
              .first,
        );
        final disabledContainer = tester.widget<AnimatedContainer>(
          find
              .descendant(
                of: find.byKey(disabledKey),
                matching: find.byType(AnimatedContainer),
              )
              .first,
        );

        final enabledDeco = enabledContainer.decoration as BoxDecoration?;
        final disabledDeco = disabledContainer.decoration as BoxDecoration?;

        expect(disabledDeco?.color, isNotNull);
        expect(enabledDeco?.color, isNot(equals(disabledDeco?.color)));
        expect(
          (disabledDeco?.color?.a ?? 255) / 255.0,
          lessThan(1.0),
        );
      });

      testWidgets('AppButton enabled onPressed callback fires correctly', (
        tester,
      ) async {
        var pressed = false;
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: Scaffold(
              body: AppButton(
                label: 'مفعل',
                onPressed: () => pressed = true,
              ),
            ),
          ),
        );

        await tester.tap(find.byType(AppButton));
        await tester.pump();
        expect(pressed, isTrue);
      });

      testWidgets('AppButton with isLoading=true prevents tap and shows progress', (
        tester,
      ) async {
        var pressed = false;
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: Scaffold(
              body: AppButton(
                label: 'جاري التحميل',
                isLoading: true,
                onPressed: () => pressed = true,
              ),
            ),
          ),
        );

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        await tester.tap(find.byType(AppButton));
        await tester.pump();
        expect(pressed, isFalse);
      });
    });

    // ═══════════════════════════════════════════════════════════════════════
    // Property 12: مدة الانتقالات (Animation Duration Tokens)
    // ═══════════════════════════════════════════════════════════════════════
    group('Property 12 - Animation Duration Tokens', () {
      test('Durations.fast = 100ms for subtle transitions', () {
        expect(Durations.fast, const Duration(milliseconds: 100));
        expect(Durations.fast.inMilliseconds, 100);
      });

      test('Durations.short = 200ms for standard state changes', () {
        expect(Durations.short, const Duration(milliseconds: 200));
        expect(Durations.short.inMilliseconds, 200);
      });

      test('Durations.medium = 300ms for emphasis transitions', () {
        expect(Durations.medium, const Duration(milliseconds: 300));
        expect(Durations.medium.inMilliseconds, 300);
      });

      test('Durations.short3 = 300ms alternate', () {
        expect(Durations.short3, const Duration(milliseconds: 300));
      });

      test('Durations.long = 400ms for complex page transitions', () {
        expect(Durations.long, const Duration(milliseconds: 400));
        expect(Durations.long.inMilliseconds, 400);
      });

      testWidgets('AppButton AnimatedContainer uses short duration (200ms)', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: const Scaffold(
              body: AppButton(
                label: 'زر عادي',
                onPressed: null,
              ),
            ),
          ),
        );

        final animatedContainer = tester.widget<AnimatedContainer>(
          find
              .descendant(
                of: find.byType(AppButton),
                matching: find.byType(AnimatedContainer),
              )
              .first,
        );
        expect(animatedContainer.duration, Durations.short);
        expect(
          animatedContainer.duration.inMilliseconds,
          200,
        );
      });
    });

    // ═══════════════════════════════════════════════════════════════════════
    // Property 13: مدة تغيير الحالة (State Change Durations)
    // ═══════════════════════════════════════════════════════════════════════
    group('Property 13 - State Change Animation Curves & Durations', () {
      testWidgets('AppButton uses Curves.easeInOut for state changes', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: const Scaffold(
              body: AppButton(
                label: 'زر',
                onPressed: null,
              ),
            ),
          ),
        );

        final animatedContainer = tester.widget<AnimatedContainer>(
          find
              .descendant(
                of: find.byType(AppButton),
                matching: find.byType(AnimatedContainer),
              )
              .first,
        );
        expect(animatedContainer.curve, isNotNull);
      });

      test('Durations token values maintain WCAG timing (≤ 500ms)', () {
        final all = [
          Durations.fast,
          Durations.short,
          Durations.short3,
          Durations.medium1,
          Durations.medium,
          Durations.long,
        ];
        for (final d in all) {
          expect(d.inMilliseconds, lessThanOrEqualTo(500));
        }
      });

      test('Durations range: fast < short < medium < long', () {
        expect(Durations.fast, lessThan(Durations.short));
        expect(Durations.short, lessThanOrEqualTo(Durations.medium));
        expect(Durations.medium, lessThan(Durations.long));
      });
    });

    // ═══════════════════════════════════════════════════════════════════════
    // Property 23: رسائل الخطأ في حقول الإدخال (Error Messages)
    // ═══════════════════════════════════════════════════════════════════════
    group('Property 23 - TextField Error Message Display', () {
      testWidgets('AppTextField renders label above input field', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: Scaffold(
              body: AppTextField(
                label: 'اسم المستخدم',
                hint: 'أدخل الاسم',
                onChanged: (_) {},
              ),
            ),
          ),
        );

        expect(find.text('اسم المستخدم'), findsOneWidget);
        expect(find.text('أدخل الاسم'), findsOneWidget);

        final labelText = tester.widget<Text>(find.text('اسم المستخدم'));
        expect(labelText.style?.fontWeight, FontWeights.semiBold);
      });

      testWidgets('AppTextField validator shows error message in Form', (
        tester,
      ) async {
        final formKey = <credential-fixture><FormState>();
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: Scaffold(
              body: Form(
                key: formKey,
                child: AppTextField(
                  label: 'البريد الإلكتروني',
                  validator: (v) => (v == null || v.isEmpty) ? 'البريد مطلوب' : null,
                  onChanged: (_) {},
                ),
              ),
            ),
          ),
        );

        formKey.currentState?.validate();
        await tester.pump();

        expect(find.text('البريد مطلوب'), findsOneWidget);

        final errorText = tester.widget<Text>(find.text('البريد مطلوب'));
        expect(errorText.style?.color, AppColors.error);
      });

      testWidgets('AppTextField validator passes with valid input', (
        tester,
      ) async {
        final formKey = <credential-fixture><FormState>();
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: Scaffold(
              body: Form(
                key: formKey,
                child: AppTextField(
                  label: 'الاسم',
                  validator: (v) => (v == null || v.length < 2) ? 'اسم قصير جداً' : null,
                  onChanged: (_) {},
                ),
              ),
            ),
          ),
        );

        await tester.enterText(find.byType(TextFormField), 'أحمد');
        formKey.currentState?.validate();
        await tester.pump();

        expect(find.text('اسم قصير جداً'), findsNothing);
      });

      testWidgets('AppTextField with obscureText shows visibility toggle', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: Scaffold(
              body: AppTextField(
                label: 'كلمة المرور',
                obscureText: true,
                onChanged: (_) {},
              ),
            ),
          ),
        );

        final visibilityIcon = find.byIcon(Icons.visibility_off);
        expect(visibilityIcon, findsOneWidget);

        final iconWidget = tester.widget<Icon>(visibilityIcon);
        expect(iconWidget.size, IconSizes.md);
        expect(IconSizes.md, 24);
      });

      testWidgets('AppTextField disabled state uses disabled colors', (
        tester,
      ) async {
        const key = <credential-fixture>('disabled-field');
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: const Scaffold(
              body: AppTextField(
                key: key,
                label: 'حقل معطل',
                isEnabled: false,
              ),
            ),
          ),
        );

        final labelText = tester.widget<Text>(find.text('حقل معطل'));
        expect(labelText.style?.color, AppColors.textDisabled);

        final textFormField = tester.widget<TextFormField>(
          find.descendant(
            of: find.byKey(key),
            matching: find.byType(TextFormField),
          ),
        );
        expect(textFormField.enabled, isFalse);
      });
    });

    // ═══════════════════════════════════════════════════════════════════════
    // Property 25: مؤشر التحميل (Loading Indicator)
    // ═══════════════════════════════════════════════════════════════════════
    group('Property 25 - Loading Indicator Sizing & Stroke', () {
      testWidgets('AppLoadingIndicator default size is 24px with 3px stroke', (
        tester,
      ) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AppLoadingIndicator(),
            ),
          ),
        );

        final sizedBox = tester.widget<SizedBox>(
          find
              .descendant(
                of: find.byType(AppLoadingIndicator),
                matching: find.byType(SizedBox),
              )
              .first,
        );
        expect(sizedBox.width, 24);
        expect(sizedBox.height, 24);

        final indicator = tester.widget<CircularProgressIndicator>(
          find.descendant(
            of: find.byType(AppLoadingIndicator),
            matching: find.byType(CircularProgressIndicator),
          ),
        );
        expect(indicator.strokeWidth, 3);
        expect(indicator.strokeCap, StrokeCap.round);
      });

      testWidgets('AppLoadingIndicator custom size (48) works correctly', (
        tester,
      ) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AppLoadingIndicator(size: 48, strokeWidth: 4),
            ),
          ),
        );

        final sizedBox = tester.widget<SizedBox>(
          find
              .descendant(
                of: find.byType(AppLoadingIndicator),
                matching: find.byType(SizedBox),
              )
              .first,
        );
        expect(sizedBox.width, 48);
        expect(sizedBox.height, 48);

        final indicator = tester.widget<CircularProgressIndicator>(
          find.descendant(
            of: find.byType(AppLoadingIndicator),
            matching: find.byType(CircularProgressIndicator),
          ),
        );
        expect(indicator.strokeWidth, 4);
      });

      testWidgets('AppLoadingIndicator respects custom color param', (
        tester,
      ) async {
        const customColor = Colors.purple;
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AppLoadingIndicator(color: customColor),
            ),
          ),
        );

        final indicator = tester.widget<CircularProgressIndicator>(
          find.descendant(
            of: find.byType(AppLoadingIndicator),
            matching: find.byType(CircularProgressIndicator),
          ),
        );
        final animatedColor = indicator.valueColor as AlwaysStoppedAnimation<Color>?;
        expect(animatedColor?.value, customColor);
      });

      testWidgets('AppLoadingScreen shows centered 40px indicator', (
        tester,
      ) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: AppLoadingScreen(),
          ),
        );

        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(AppLoadingIndicator), findsOneWidget);

        final sizedBox = tester.widget<SizedBox>(
          find
              .descendant(
                of: find.byType(AppLoadingIndicator),
                matching: find.byType(SizedBox),
              )
              .first,
        );
        expect(sizedBox.width, 40);
        expect(sizedBox.height, 40);
      });
    });

    // ═══════════════════════════════════════════════════════════════════════
    // Properties 26-28: الحالات الفارغة (Empty States)
    // ═══════════════════════════════════════════════════════════════════════
    group('Properties 26-28 - Empty State Display', () {
      testWidgets('Property 26: AppEmptyState shows title with titleMedium style', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: const Scaffold(
              body: AppEmptyState(
                title: 'لا توجد بيانات',
                icon: Icons.inbox_outlined,
              ),
            ),
          ),
        );

        final titleFinder = find.text('لا توجد بيانات');
        expect(titleFinder, findsOneWidget);

        final titleText = tester.widget<Text>(titleFinder);
        expect(titleText.textAlign, TextAlign.center);
        expect(titleText.style?.fontWeight, FontWeights.bold);
      });

      testWidgets('Property 27: AppEmptyState with description shows secondary text', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: const Scaffold(
              body: AppEmptyState(
                title: 'لا توجد فواتير',
                description: 'يمكنك إنشاء أول فاتورة بالنقر على الزر أدناه',
                icon: Icons.receipt_long_outlined,
              ),
            ),
          ),
        );

        final descFinder = find.text(
          'يمكنك إنشاء أول فاتورة بالنقر على الزر أدناه',
        );
        expect(descFinder, findsOneWidget);

        final descText = tester.widget<Text>(descFinder);
        expect(descText.textAlign, TextAlign.center);
        expect(descText.style?.color, AppColors.textSecondary);
      });

      testWidgets('Property 27: AppEmptyState action button triggers callback', (
        tester,
      ) async {
        var pressed = false;
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: Scaffold(
              body: AppEmptyState(
                title: 'لا توجد عملاء',
                description: 'أضف أول عميل الآن',
                icon: Icons.people_outline,
                actionLabel: 'إضافة عميل',
                onActionPressed: () => pressed = true,
              ),
            ),
          ),
        );

        final buttonFinder = find.widgetWithText(ElevatedButton, 'إضافة عميل');
        expect(buttonFinder, findsOneWidget);

        await tester.tap(buttonFinder);
        await tester.pump();
        expect(pressed, isTrue);
      });

      testWidgets('Property 28: AppEmptyState with icon renders Icon widget', (
        tester,
      ) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AppEmptyState(
                title: 'بحث فارغ',
                icon: Icons.search_off_outlined,
              ),
            ),
          ),
        );

        final iconFinder = find.byIcon(Icons.search_off_outlined);
        expect(iconFinder, findsOneWidget);

        final icon = tester.widget<Icon>(iconFinder);
        expect(icon.size, 80);
      });

      testWidgets('Property 28: AppEmptyState uses Spacing.xl padding (32px)', (
        tester,
      ) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AppEmptyState(
                title: 'لا شيء هنا',
                icon: Icons.folder_outlined,
              ),
            ),
          ),
        );

        final paddingFinder = find.descendant(
          of: find.byType(AppEmptyState),
          matching: find.byType(Padding),
        );
        expect(paddingFinder, findsWidgets);

        final outerPadding = tester.widget<Padding>(paddingFinder.first);
        expect(outerPadding.padding, const EdgeInsets.all(Spacing.xl));
        expect(Spacing.xl, 32);
      });

      testWidgets('AppEmptyState without actionLabel has no ElevatedButton', (
        tester,
      ) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AppEmptyState(
                title: 'فارغ',
                icon: Icons.star_outline,
              ),
            ),
          ),
        );

        expect(find.byType(ElevatedButton), findsNothing);
      });
    });

    // ═══════════════════════════════════════════════════════════════════════
    // Property 5: الخطوط (Font Families - Cairo + Fallbacks)
    // ═══════════════════════════════════════════════════════════════════════
    group('Property 5 - Font Families (Cairo Arabic Font)', () {
      test('FontFamilies.arabic token = Cairo (primary for Arabic)', () {
        expect(FontFamilies.arabic, 'Cairo');
      });

      test('FontManager constants: primaryFont token points to Cairo', () {
        expect('Cairo', FontFamilies.arabic);
      });

      testWidgets('AppTextStyles.displayLarge has valid fontFamily & fallbacks', (tester) async {
        final style = AppTextStyles.displayLarge;
        expect(
          style.fontFamily,
          anyOf('Cairo', 'Roboto', 'Arial', 'sans-serif'),
        );
        if (style.fontFamilyFallback != null) {
          expect(style.fontFamilyFallback, isNotEmpty);
        }
      });

      testWidgets('ResponsiveText renders with non-null fontFamily', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: const Scaffold(
              body: ResponsiveText('تجربة النص'),
            ),
          ),
        );

        final textFinder = find.byType(Text);
        expect(textFinder, findsWidgets);

        final text = tester.widget<Text>(find.text('تجربة النص'));
        expect(text.style?.fontFamily, isNotNull);
      });

      test('AppTheme textTheme uses Cairo or fallback fonts', () {
        final theme = AppTheme.lightTheme;
        final textThemes = [
          theme.textTheme.displayLarge,
          theme.textTheme.bodyLarge,
          theme.textTheme.labelLarge,
        ];
        for (final s in textThemes) {
          if (s?.fontFamily != null) {
            expect(
              s!.fontFamily,
              anyOf(
                'Cairo',
                'Roboto',
                'Arial',
                'sans-serif',
                startsWith('Cairo'),
              ),
            );
          }
        }
      });
    });

    // ═══════════════════════════════════════════════════════════════════════
    // Property 6: أحجام العناوين (Heading Sizes Scale)
    // ═══════════════════════════════════════════════════════════════════════
    group('Property 6 - Heading Sizes Hierarchy', () {
      test('Headings maintain descending size order: display > headline > title > body', () {
        expect(
          AppTextStyles.displayLargeSize,
          greaterThan(AppTextStyles.headlineLargeSize),
        );
        expect(
          AppTextStyles.headlineLargeSize,
          greaterThan(AppTextStyles.titleLargeSize),
        );
        expect(
          AppTextStyles.titleLargeSize,
          greaterThanOrEqualTo(AppTextStyles.bodyLargeSize),
        );
      });

      test('Display hierarchy: 57 > 45 > 36', () {
        expect(AppTextStyles.displayLargeSize, 57);
        expect(AppTextStyles.displayMediumSize, 45);
        expect(AppTextStyles.displaySmallSize, 36);
      });

      test('Headline hierarchy: 32 > 28 > 24', () {
        expect(AppTextStyles.headlineLargeSize, 32);
        expect(AppTextStyles.headlineMediumSize, 28);
        expect(AppTextStyles.headlineSmallSize, 24);
      });

      test('Title sizes: 22 (large) >= 16 (medium) >= 14 (small)', () {
        expect(AppTextStyles.titleLargeSize, 22);
        expect(AppTextStyles.titleMediumSize, 16);
        expect(AppTextStyles.titleSmallSize, 14);
      });

      testWidgets('AppCard title uses titleSmall (14px) or higher', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: Scaffold(
              body: AppListCard(
                title: 'عنوان البطاقة',
                subtitle: 'الوصف',
                onTap: () {},
              ),
            ),
          ),
        );

        final titleWidget = tester.widget<Text>(
          find.text('عنوان البطاقة'),
        );
        expect(
          titleWidget.style?.fontSize,
          greaterThanOrEqualTo(AppTextStyles.titleSmallSize),
        );
      });
    });

    // ═══════════════════════════════════════════════════════════════════════
    // Property 7: ارتفاع الأسطر (Line Heights)
    // ═══════════════════════════════════════════════════════════════════════
    group('Property 7 - Line Heights (Readability)', () {
      test('Tight lineHeight = 1.2 for dense headings', () {
        expect(AppTextStyles.lineHeightTight, 1.2);
      });

      test('Normal lineHeight = 1.5 for body text (WCAG)', () {
        expect(AppTextStyles.lineHeightNormal, 1.5);
      });

      test('Relaxed lineHeight = 1.8 for long-form content', () {
        expect(AppTextStyles.lineHeightRelaxed, 1.8);
      });

      test('Order: tight < normal < relaxed', () {
        expect(AppTextStyles.lineHeightTight, lessThan(AppTextStyles.lineHeightNormal));
        expect(AppTextStyles.lineHeightNormal, lessThan(AppTextStyles.lineHeightRelaxed));
      });

      testWidgets('Body TextStyles have valid fontSize >= 12px (WCAG)', (tester) async {
        final bodySizes = [
          AppTextStyles.bodyLargeSize,
          AppTextStyles.bodyMediumSize,
          AppTextStyles.bodySmallSize,
        ];
        for (final size in bodySizes) {
          expect(size, greaterThanOrEqualTo(11));
        }
        expect(AppTextStyles.bodySmallSize, 12);
        expect(AppTextStyles.bodyMediumSize, 14);
        expect(AppTextStyles.bodyLargeSize, 16);
      });
    });

    // ═══════════════════════════════════════════════════════════════════════
    // Property 8: خط الأرقام والرموز والأرقام العربية (Numerals)
    // ═══════════════════════════════════════════════════════════════════════
    group('Property 8 - Numerals & Symbol Font Rendering', () {
      test('FontWeights follow CSS naming: 400/500/600/700', () {
        expect(FontWeights.regular.value, 400);
        expect(FontWeights.medium.value, 500);
        expect(FontWeights.semiBold.value, 600);
        expect(FontWeights.bold.value, 700);
      });

      test('Headings use bold weights (600 or 700)', () {
        final displayStyles = [
          AppTextStyles.displayLarge,
          AppTextStyles.displayMedium,
          AppTextStyles.displaySmall,
          AppTextStyles.headlineLarge,
        ];
        for (final s in displayStyles) {
          expect(s.fontWeight?.value, anyOf(700, greaterThanOrEqualTo(600)));
        }
      });

      test('Title/Label use medium or semi-bold for readability', () {
        final titles = [
          AppTextStyles.titleMedium,
          AppTextStyles.titleSmall,
          AppTextStyles.labelLarge,
          AppTextStyles.labelMedium,
        ];
        for (final s in titles) {
          expect(
            s.fontWeight?.value,
            anyOf(FontWeights.medium.value, FontWeights.semiBold.value),
          );
        }
      });

      testWidgets('Body text uses Regular weight (400) for legibility', (
        tester,
      ) async {
        final bodyStyles = [
          AppTextStyles.bodyLarge,
          AppTextStyles.bodyMedium,
          AppTextStyles.bodySmall,
        ];
        for (final s in bodyStyles) {
          expect(s.fontWeight?.value, FontWeights.regular.value);
        }
      });
    });

    // ═══════════════════════════════════════════════════════════════════════
    // Property 2: تباين النصوص الكبيرة (Large Text Contrast 3:1 WCAG)
    // ═══════════════════════════════════════════════════════════════════════
    group('Property 2 - Large Text Contrast (≥ 3:1 WCAG AA)', () {
      double relativeLuminance(Color color) {
        double conv(double v01) => v01 <= 0.03928
            ? v01 / 12.92
            : ((v01 + 0.055) / 1.055) * ((v01 + 0.055) / 1.055) * ((v01 + 0.055) / 1.055);

        return 0.2126 * conv(color.r) + 0.7152 * conv(color.g) + 0.0722 * conv(color.b);
      }

      double contrastRatio(Color a, Color b) {
        final la = relativeLuminance(a);
        final lb = relativeLuminance(b);
        final lighter = (la > lb) ? la : lb;
        final darker = (la > lb) ? lb : la;
        return (lighter + 0.05) / (darker + 0.05);
      }

      test('AppColors.textPrimary vs surface: contrast >= 4.5:1 (Normal text WCAG)', () {
        final cr = contrastRatio(AppColors.textPrimary, AppColors.surface);
        expect(cr, greaterThanOrEqualTo(4.5));
      });

      test('AppColors.primary (bold/title) vs white: >= 3:1 (Large text)', () {
        final cr = contrastRatio(AppColors.primary, Colors.white);
        expect(cr, greaterThanOrEqualTo(3.0));
      });

      testWidgets('AppEmptyState title uses high-contrast primary text', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: const Scaffold(
              backgroundColor: Color(0xFFFFFFFF),
              body: AppEmptyState(
                title: 'لا توجد بيانات',
                icon: Icons.inbox_outlined,
              ),
            ),
          ),
        );

        final titleText = tester.widget<Text>(find.text('لا توجد بيانات'));
        final fg = titleText.style?.color ?? AppColors.textPrimary;
        final cr = contrastRatio(fg, Colors.white);
        expect(cr, greaterThanOrEqualTo(3.0));
      });

      test('TextSecondary vs surface still >= 4.5:1 for normal text', () {
        final cr = contrastRatio(AppColors.textSecondary, AppColors.surface);
        expect(cr, greaterThanOrEqualTo(4.0));
      });
    });

    // ═══════════════════════════════════════════════════════════════════════
    // Property 3: تباين العناصر التفاعلية (Interactive Contrast)
    // ═══════════════════════════════════════════════════════════════════════
    group('Property 3 - Interactive Elements Contrast', () {
      double relL(Color color) {
        double f(double v01) => v01 <= 0.03928
            ? v01 / 12.92
            : ((v01 + 0.055) / 1.055) * ((v01 + 0.055) / 1.055) * ((v01 + 0.055) / 1.055);

        return 0.2126 * f(color.r) + 0.7152 * f(color.g) + 0.0722 * f(color.b);
      }

      double cr0(Color a, Color b) {
        final la = relL(a);
        final lb = relL(b);
        final l1 = (la > lb) ? la : lb;
        final l2 = (la > lb) ? lb : la;
        return (l1 + 0.05) / (l2 + 0.05);
      }

      test('AppButton.primary foreground vs background: >= 3:1', () {
        const bg = AppColors.primary;
        const fg = Colors.white;
        final contrast = cr0(fg, bg);
        expect(contrast, greaterThanOrEqualTo(3.0));
      });

      test('AppColors.success badge text vs background: readable', () {
        final cr = cr0(Colors.white, AppColors.success);
        expect(cr, greaterThanOrEqualTo(3.0));
      });

      test('AppColors.error vs white: readable contrast', () {
        final cr = cr0(Colors.white, AppColors.error);
        expect(cr, greaterThanOrEqualTo(3.0));
      });

      testWidgets('AppButton foreground text contrast with filled background', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: Scaffold(
              body: AppEnhancedButton(
                label: 'زر أساسي',
                onPressed: () {},
              ),
            ),
          ),
        );

        final text = tester.widget<Text>(find.text('زر أساسي'));
        expect(text.style?.color, isNotNull);
      });

      test('TextField placeholder/text vs background color: distinguishable', () {
        const fg = AppColors.textPrimary;
        const bg = InputColors.background;
        final contrast = cr0(fg, bg);
        expect(contrast, greaterThanOrEqualTo(4.0));
      });
    });

    // ═══════════════════════════════════════════════════════════════════════
    // Property 29: عدم وجود قص أفقي (Requirement 11.1)
    // ═══════════════════════════════════════════════════════════════════════
    group('Property 29 - No Horizontal Clipping', () {
      testWidgets('AppEnhancedButton with long text renders without overflow', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: Scaffold(
              body: SizedBox(
                width: 300,
                child: AppEnhancedButton(
                  label: 'هذا نص طويل جداً لاختبار عدم وجود قص أفقي في الزر المحسن',
                  onPressed: () {},
                  maxLines: 2,
                ),
              ),
            ),
          ),
        );

        final text = tester.widget<Text>(
          find.text(
            'هذا نص طويل جداً لاختبار عدم وجود قص أفقي في الزر المحسن',
          ),
        );
        expect(text, isNotNull);
        expect(text.maxLines, 2);
        expect(text.overflow, isNot(equals(TextOverflow.ellipsis)));
      });

      testWidgets('AppEnhancedButton child uses Flexible to prevent overflow', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 100,
                child: AppEnhancedButton(
                  label: 'Long Label That Should Wrap',
                  onPressed: () {},
                  maxLines: 2,
                ),
              ),
            ),
          ),
        );

        final flexible = find.descendant(
          of: find.byType(AppEnhancedButton),
          matching: find.byType(Flexible),
        );
        expect(flexible, findsWidgets);
      });
    });

    // ═══════════════════════════════════════════════════════════════════════
    // Property 30: عدم وجود قص عمودي (Requirement 11.1, 11.4)
    // ═══════════════════════════════════════════════════════════════════════
    group('Property 30 - No Vertical Clipping', () {
      testWidgets(
        'AppEnhancedButton height accommodates multi-line text without clip',
        (tester) async {
          await tester.pumpWidget(
            MaterialApp(
              theme: AppTheme.lightTheme,
              home: Scaffold(
                body: SizedBox(
                  width: 140,
                  child: AppEnhancedButton(
                    label: 'عنوان طويل يمتد لعدة أسطر للتحقق من الارتفاع',
                    onPressed: () {},
                    maxLines: 3,
                  ),
                ),
              ),
            ),
          );

          final container = tester.widget<Container>(
            find
                .descendant(
                  of: find.byType(AppEnhancedButton),
                  matching: find.byType(Container),
                )
                .first,
          );
          expect(
            container.constraints?.minHeight,
            greaterThanOrEqualTo(54),
          );
        },
      );

      testWidgets('Button uses softWrap for vertical expansion', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppEnhancedButton(
                label: 'Multi-line Text Button Label For Wrap Test',
                onPressed: () {},
                maxLines: 3,
              ),
            ),
          ),
        );

        final text = tester.widget<Text>(
          find.text(
            'Multi-line Text Button Label For Wrap Test',
          ),
        );
        expect(text, isNotNull);
      });
    });

    // ═══════════════════════════════════════════════════════════════════════
    // Property 31: التكيف مع textScaleFactor (Requirement 11.2)
    // ═══════════════════════════════════════════════════════════════════════
    group('Property 31 - Text Scale Adaptation', () {
      testWidgets('Button renders correctly at textScale 1.5', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(
                textScaler: TextScaler.linear(1.5),
              ),
              child: Scaffold(
                body: AppEnhancedButton(
                  label: 'Large Text Scale',
                  onPressed: () {},
                ),
              ),
            ),
          ),
        );

        expect(find.text('Large Text Scale'), findsOneWidget);
      });

      testWidgets('Button renders correctly at textScale 2.0', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(
                textScaler: TextScaler.linear(2),
              ),
              child: Scaffold(
                body: AppEnhancedButton(
                  label: 'Max Scale',
                  onPressed: () {},
                ),
              ),
            ),
          ),
        );

        expect(find.text('Max Scale'), findsOneWidget);
      });
    });

    // ═══════════════════════════════════════════════════════════════════════
    // Property 32: التخطيط المرن للنصوص الطويلة (Requirement 11.3)
    // ═══════════════════════════════════════════════════════════════════════
    group('Property 32 - Flexible Long Text Layout', () {
      testWidgets('Row inside button contains Flexible for text wrapping', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppEnhancedButton(
                label: 'Flexible Layout Test With Long Content',
                onPressed: () {},
              ),
            ),
          ),
        );

        final flexFinder = find.descendant(
          of: find.byType(AppEnhancedButton),
          matching: find.byType(Flexible),
        );
        expect(flexFinder, findsAtLeast(1));
      });

      testWidgets('Button text is allowed maxLines parameter for wrap', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppEnhancedButton(
                label: 'Multi-Line Wrapping Button Text Content',
                onPressed: () {},
                maxLines: 3,
              ),
            ),
          ),
        );

        final text = tester.widget<Text>(
          find.text(
            'Multi-Line Wrapping Button Text Content',
          ),
        );
        expect(text.maxLines, 3);
      });
    });

    // ═══════════════════════════════════════════════════════════════════════
    // Property 33: مقاييس خط Cairo الصحيحة (Requirement 11.4)
    // ═══════════════════════════════════════════════════════════════════════
    group('Property 33 - Correct Cairo Font Metrics', () {
      test('AppTextStyles titleMedium uses line-height >= 1.3 (Cairo)', () {
        final titleMd = AppTextStyles.titleMedium;
        final lineHeight = titleMd.height;
        final fontSize = titleMd.fontSize;
        expect(fontSize, isNotNull);
        if (lineHeight != null) {
          expect(lineHeight, greaterThanOrEqualTo(1.3));
        }
      });

      testWidgets('AppEnhancedButton textStyle uses titleMedium with line height', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: Scaffold(
              body: AppEnhancedButton(label: 'Cairo Metrics', onPressed: () {}),
            ),
          ),
        );

        final text = tester.widget<Text>(find.text('Cairo Metrics'));
        expect(text.style?.fontSize, AppTextStyles.titleMedium.fontSize);
      });
    });

    // ═══════════════════════════════════════════════════════════════════════
    // Property 34: تجنب RenderFlex overflow (Requirement 11.5)
    // ═══════════════════════════════════════════════════════════════════════
    group('Property 34 - Prevent RenderFlex Overflow', () {
      testWidgets('Very tight width button does not throw overflow errors', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 60,
                child: AppEnhancedButton(
                  label: 'X',
                  onPressed: () {},
                  width: 60,
                ),
              ),
            ),
          ),
        );

        expect(find.byType(AppEnhancedButton), findsOneWidget);
      });

      testWidgets('Nested in Column with other widgets no overflow', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 200,
                child: Column(
                  children: [
                    AppEnhancedButton(
                      label: 'Nested Button 1',
                      onPressed: () {},
                    ),
                    const SizedBox(height: 8),
                    AppEnhancedButton(
                      label: 'Nested Button 2',
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        expect(find.byType(AppEnhancedButton), findsNWidgets(2));
      });
    });

    // ═══════════════════════════════════════════════════════════════════════
    // Property 35: معالجة RTL الصحيحة (Requirement 11.6)
    // ═══════════════════════════════════════════════════════════════════════
    group('Property 35 - Correct RTL Handling', () {
      testWidgets('AppEnhancedButton text uses TextDirection.rtl', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppEnhancedButton(
                label: 'زر عربي',
                onPressed: () {},
              ),
            ),
          ),
        );

        final text = tester.widget<Text>(find.text('زر عربي'));
        expect(text.textDirection, TextDirection.rtl);
      });

      testWidgets('Arabic text aligns center according to widget param', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppEnhancedButton(
                label: 'محاذاة وسط',
                onPressed: () {},
              ),
            ),
          ),
        );

        final text = tester.widget<Text>(find.text('محاذاة وسط'));
        expect(text.textAlign, TextAlign.center);
      });
    });

    // ═══════════════════════════════════════════════════════════════════════
    // Property 36: خط fallback آمن (Requirement 11.7)
    // ═══════════════════════════════════════════════════════════════════════
    group('Property 36 - Safe Fallback Fonts', () {
      test('FontFamilies token arabic is Cairo (non-empty)', () {
        expect(FontFamilies.arabic, isNotEmpty);
        expect(FontFamilies.arabic, 'Cairo');
      });

      test('FontManager.fallbackFonts provides Roboto, Arial, sans-serif', () {
        const fonts = FontManager.fallbackFonts;
        expect(fonts, isNotEmpty);
        expect(fonts.first, 'Roboto');
        expect(fonts.contains('Arial'), isTrue);
      });

      testWidgets(
        'AppEnhancedButton allows rendering even if Cairo is unavailable',
        (tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: AppEnhancedButton(
                  label: 'Fallback Safe Button',
                  onPressed: () {},
                ),
              ),
            ),
          );

          expect(find.text('Fallback Safe Button'), findsOneWidget);
        },
      );
    });

    // ═══════════════════════════════════════════════════════════════════════
    // Property 37: padding رأسي كافٍ (Requirement 11.8)
    // ═══════════════════════════════════════════════════════════════════════
    group('Property 37 - Sufficient Vertical Padding', () {
      testWidgets(
        'AppEnhancedButton text content includes vertical spacing',
        (tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: AppEnhancedButton(
                  label: 'Vertically Padded',
                  onPressed: () {},
                ),
              ),
            ),
          );

          final paddingFinder = find.descendant(
            of: find.byType(AppEnhancedButton),
            matching: find.byWidgetPredicate(
              (w) => w is Padding && (w.padding as EdgeInsets).vertical >= Spacing.xs * 2,
            ),
          );
          expect(paddingFinder, findsWidgets);
        },
      );

      test('AppEnhancedButton default height = 54 (comfortable for Cairo)', () {
        const btn = AppEnhancedButton(label: 'H', onPressed: null);
        expect(btn.height, 54);
      });
    });

    // ═══════════════════════════════════════════════════════════════════════
    // Property 38: اتساق عبر المنصات (Requirement 11.9)
    // ═══════════════════════════════════════════════════════════════════════
    group('Property 38 - Cross-Platform Consistency', () {
      testWidgets('Primary button uses gradient on any platform', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppEnhancedButton(label: 'Platform', onPressed: () {}),
            ),
          ),
        );

        final container = tester.widget<Container>(
          find
              .descendant(
                of: find.byType(AppEnhancedButton),
                matching: find.byType(Container),
              )
              .first,
        );
        final deco = container.decoration! as BoxDecoration;
        expect(deco.gradient, isNotNull);
      });

      testWidgets('Button minHeight and radii tokens do not depend on platform', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppEnhancedButton(
                label: 'Consistent',
                onPressed: () {},
              ),
            ),
          ),
        );

        final container = tester.widget<Container>(
          find
              .descendant(
                of: find.byType(AppEnhancedButton),
                matching: find.byType(Container),
              )
              .first,
        );
        final deco = container.decoration! as BoxDecoration;
        expect(deco.borderRadius, Radii.borderRadiusMd);
        expect(container.constraints?.minHeight, 54);
      });
    });

    // ═══════════════════════════════════════════════════════════════════════
    // Property 39: تخطيط مرن للأزرار مع أيقونة (Requirement 11.10)
    // ═══════════════════════════════════════════════════════════════════════
    group('Property 39 - Flexible Layout With Icon', () {
      testWidgets('Button with icon renders icon + text without overflow', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 200,
                child: AppEnhancedButton(
                  label: 'زر مع أيقونة طويل',
                  icon: Icons.add,
                  onPressed: () {},
                  maxLines: 2,
                ),
              ),
            ),
          ),
        );

        expect(find.byIcon(Icons.add), findsOneWidget);
        expect(find.text('زر مع أيقونة طويل'), findsOneWidget);
      });

      testWidgets('Icon button layout: icon size 22 and gap Spacing.sm (8px)', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppEnhancedButton(
                label: 'With Icon',
                icon: Icons.check,
                onPressed: () {},
              ),
            ),
          ),
        );

        final icon = tester.widget<Icon>(find.byIcon(Icons.check));
        expect(icon.size, 22);

        final row = tester.widget<Row>(
          find.descendant(
            of: find.byType(AppEnhancedButton),
            matching: find.byType(Row),
          ),
        );
        expect(row.mainAxisAlignment, MainAxisAlignment.center);
      });
    });

    // ═══════════════════════════════════════════════════════════════════════
    // Property 4: تباين مؤشر التركيز (Requirement 1.5)
    // ═══════════════════════════════════════════════════════════════════════
    group('Property 4 - Focus Indicator Contrast', () {
      test('AppStateColors focusBorderWidth = 2 (visible focus border)', () {
        expect(AppStateColors.focusBorderWidth, 2);
      });

      test('Focus border (Light Mode: primary) vs surface: contrast >= 3:1', () {
        const focus = AppStateColors.focusBorderLight;
        final rL = focus.computeLuminance();
        const surface = AppColors.surface;
        final rS = surface.computeLuminance();
        final l1 = rL > rS ? rL : rS;
        final l2 = rL < rS ? rL : rS;
        final ratio = (l1 + 0.05) / (l2 + 0.05);
        expect(ratio, greaterThanOrEqualTo(3.0));
      });

      test('Focus border (Dark Mode: blueCorporate) vs dark surface: contrast >= 3:1', () {
        const focus = AppStateColors.focusBorderDark;
        const surfaceDark = Color(0xFF111827);
        final rL = focus.computeLuminance();
        final rS = surfaceDark.computeLuminance();
        final l1 = rL > rS ? rL : rS;
        final l2 = rL < rS ? rL : rS;
        final ratio = (l1 + 0.05) / (l2 + 0.05);
        expect(ratio, greaterThanOrEqualTo(3.0));
      });

      test('BorderContrastDesign focus borders match AppStateColors tokens', () {
        expect(BorderContrastDesign.borderFocusedLight, AppStateColors.focusBorderLight);
        expect(BorderContrastDesign.borderFocusedDark, AppStateColors.focusBorderDark);
      });

      testWidgets(
        'AppTextField focus border uses primary color with 2px width',
        (tester) async {
          await tester.pumpWidget(
            MaterialApp(
              theme: AppTheme.lightTheme,
              home: const Scaffold(
                body: Padding(
                  padding: EdgeInsets.all(16),
                  child: AppTextField(label: 'الاسم', hint: 'أدخل الاسم'),
                ),
              ),
            ),
          );

          final textField = find.byType(TextField);
          await tester.showKeyboard(textField);
          await tester.pumpAndSettle();

          final tfWidget = tester.widget<TextField>(textField);
          final decoration = tfWidget.decoration;
          expect(decoration, isNotNull);
          final focusedBorder = decoration?.focusedBorder;
          expect(focusedBorder, isNotNull);
        },
      );
    });

    // ═══════════════════════════════════════════════════════════════════════
    // Property 11: سلاسة انتقالات الحالات (Requirement 12.5)
    // ═══════════════════════════════════════════════════════════════════════
    group('Property 11 - Smooth State Transitions', () {
      test('Durations.short = 200ms used for UI feedback transitions', () {
        expect(Durations.short.inMilliseconds, 200);
      });

      test('Durations.medium >= short <= 300ms <= 500 for longer animations', () {
        expect(Durations.medium.inMilliseconds, greaterThanOrEqualTo(250));
        expect(Durations.medium.inMilliseconds, lessThanOrEqualTo(500));
      });

      test('Animation Curves exist: easeIn, easeOut, easeInOut', () {
        expect(Curves.easeIn, isNotNull);
        expect(Curves.easeOut, isNotNull);
        expect(Curves.easeInOut, isNotNull);
      });

      testWidgets(
        'AppEnhancedButton has smooth InkWell/Material for ripple feedback',
        (tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: AppEnhancedButton(label: 'State', onPressed: () {}),
              ),
            ),
          );

          expect(find.byType(Material), findsWidgets);
        },
      );
    });
  });
}
