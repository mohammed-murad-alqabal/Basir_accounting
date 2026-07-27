import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:basir_accounting_system/shared/widgets/app_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppAppBar', () {
    testWidgets('should display title correctly', (tester) async {
      const title = 'العملاء';

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appIconsProvider.overrideWithValue(const MaterialAppIcons()),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(appBar: AppAppBar(title: title)),
          ),
        ),
      );

      expect(find.text(title), findsOneWidget);
    });

    testWidgets('should show back button by default', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appIconsProvider.overrideWithValue(const MaterialAppIcons()),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(appBar: AppAppBar(title: 'Test')),
          ),
        ),
      );

      expect(find.byIcon(Icons.arrow_back_outlined), findsOneWidget);
    });

    testWidgets('should hide back button when showBackButton is false', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appIconsProvider.overrideWithValue(const MaterialAppIcons()),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              appBar: AppAppBar(title: 'Test', showBackButton: false),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.arrow_back_outlined), findsNothing);
    });

    testWidgets('should call Navigator.pop when back button is pressed', (
      tester,
    ) async {
      var navigatorPopped = false;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appIconsProvider.overrideWithValue(const MaterialAppIcons()),
          ],
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Builder(
              builder: (context) => Scaffold(
                appBar: const AppAppBar(title: 'Test'),
                body: ElevatedButton(
                  onPressed: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => Scaffold(
                          appBar: AppAppBar(
                            title: 'Second Screen',
                            onBackPressed: () {
                              navigatorPopped = true;
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ),
                    );
                  },
                  child: const Text('Navigate'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Navigate'));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.arrow_back_outlined));
      await tester.pumpAndSettle();

      expect(navigatorPopped, isTrue);
      expect(find.text('Second Screen'), findsNothing);
    });

    testWidgets('should display actions when provided', (tester) async {
      var actionPressed = false;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appIconsProvider.overrideWithValue(const MaterialAppIcons()),
          ],
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              appBar: AppAppBar(
                title: 'Test',
                actions: [
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      actionPressed = true;
                    },
                  ),
                  IconButton(icon: const Icon(Icons.search), onPressed: () {}),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);

      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      expect(actionPressed, isTrue);
    });

    testWidgets('should use custom colors when provided', (tester) async {
      const customBgColor = Colors.blue;
      const customFgColor = Colors.white;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appIconsProvider.overrideWithValue(const MaterialAppIcons()),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              appBar: AppAppBar(
                title: 'Test',
                backgroundColor: customBgColor,
                foregroundColor: customFgColor,
              ),
            ),
          ),
        ),
      );

      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.backgroundColor, customBgColor);
      expect(appBar.foregroundColor, customFgColor);
    });

    testWidgets('should use default colors when not provided', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appIconsProvider.overrideWithValue(const MaterialAppIcons()),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(appBar: AppAppBar(title: 'Test')),
          ),
        ),
      );

      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.backgroundColor, AppColors.surface);
      expect(appBar.foregroundColor, AppColors.textPrimary);
    });

    testWidgets('should have elevation of 0', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appIconsProvider.overrideWithValue(const MaterialAppIcons()),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(appBar: AppAppBar(title: 'Test')),
          ),
        ),
      );

      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.elevation, 0);
    });

    testWidgets('should center title', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appIconsProvider.overrideWithValue(const MaterialAppIcons()),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(appBar: AppAppBar(title: 'Test')),
          ),
        ),
      );

      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.centerTitle, isTrue);
    });

    testWidgets('should have correct preferred size', (tester) async {
      const appBar = AppAppBar(title: 'Test');

      expect(appBar.preferredSize, const Size.fromHeight(kToolbarHeight + 1.0));
    });

    testWidgets('back button should have 48x48px touch target', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appIconsProvider.overrideWithValue(const MaterialAppIcons()),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(appBar: AppAppBar(title: 'Test')),
          ),
        ),
      );

      final backButton = tester.widget<IconButton>(
        find.byWidgetPredicate(
          (w) => w is IconButton && w.icon is Icon,
        ),
      );
      expect(backButton.constraints?.minWidth, TouchTargets.minimum);
      expect(backButton.constraints?.minHeight, TouchTargets.minimum);
    });

    testWidgets('back button icon should be 24px', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appIconsProvider.overrideWithValue(const MaterialAppIcons()),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(appBar: AppAppBar(title: 'Test')),
          ),
        ),
      );

      final icon = tester.widget<Icon>(find.byIcon(Icons.arrow_back_outlined));
      expect(icon.size, IconSizes.md);
    });

    testWidgets('actions icon theme should use 24px size', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appIconsProvider.overrideWithValue(const MaterialAppIcons()),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              appBar: AppAppBar(
                title: 'Test',
                actions: [Icon(Icons.add)],
              ),
            ),
          ),
        ),
      );

      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.actionsIconTheme?.size, IconSizes.md);
      expect(appBar.iconTheme?.size, IconSizes.md);
    });

    testWidgets('should have bottom divider border', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appIconsProvider.overrideWithValue(const MaterialAppIcons()),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(appBar: AppAppBar(title: 'Test')),
          ),
        ),
      );

      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.bottom, isNotNull);
      expect(appBar.bottom!.preferredSize.height, BorderWidths.thin);
    });

    testWidgets('title should have semantics header', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appIconsProvider.overrideWithValue(const MaterialAppIcons()),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(appBar: AppAppBar(title: 'Test')),
          ),
        ),
      );

      final semanticsFinder = find.ancestor(
        of: find.text('Test'),
        matching: find.byWidgetPredicate((w) => w is Semantics),
      );
      expect(semanticsFinder, findsWidgets);
    });

    testWidgets('should respect titleSemanticLabel', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appIconsProvider.overrideWithValue(const MaterialAppIcons()),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              appBar: AppAppBar(
                title: 'العملاء',
                titleSemanticLabel: 'قائمة العملاء المسجلين',
              ),
            ),
          ),
        ),
      );

      final semanticsNode = tester.getSemantics(find.text('العملاء'));
      expect(semanticsNode.label, contains('قائمة العملاء المسجلين'));
    });
  });

  group('AppSimpleAppBar', () {
    testWidgets('should display title correctly', (tester) async {
      const title = 'لوحة التحكم';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(appBar: AppSimpleAppBar(title: title)),
        ),
      );

      expect(find.text(title), findsOneWidget);
    });

    testWidgets('should not show back button', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(appBar: AppSimpleAppBar(title: 'Test')),
        ),
      );

      expect(find.byIcon(Icons.arrow_back_outlined), findsNothing);
    });

    testWidgets('should display actions when provided', (tester) async {
      var actionPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppSimpleAppBar(
              title: 'Test',
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    actionPressed = true;
                  },
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.settings), findsOneWidget);

      await tester.tap(find.byIcon(Icons.settings));
      await tester.pump();
      expect(actionPressed, isTrue);
    });

    testWidgets('should use custom colors when provided', (tester) async {
      const customBgColor = Colors.green;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            appBar: AppSimpleAppBar(
              title: 'Test',
              backgroundColor: customBgColor,
            ),
          ),
        ),
      );

      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.backgroundColor, customBgColor);
      expect(appBar.foregroundColor, AppColors.textPrimary);
    });

    testWidgets('should use default colors when not provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(appBar: AppSimpleAppBar(title: 'Test')),
        ),
      );

      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.backgroundColor, AppColors.surface);
      expect(appBar.foregroundColor, AppColors.textPrimary);
    });

    testWidgets('should have elevation of 0', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(appBar: AppSimpleAppBar(title: 'Test')),
        ),
      );

      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.elevation, 0);
    });

    testWidgets('should center title', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(appBar: AppSimpleAppBar(title: 'Test')),
        ),
      );

      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.centerTitle, isTrue);
    });

    testWidgets('should not automatically imply leading', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(appBar: AppSimpleAppBar(title: 'Test')),
        ),
      );

      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.automaticallyImplyLeading, isFalse);
    });

    testWidgets('should have correct preferred size', (tester) async {
      const appBar = AppSimpleAppBar(title: 'Test');

      expect(appBar.preferredSize, const Size.fromHeight(kToolbarHeight + 1.0));
    });

    testWidgets('icon theme should use 24px size', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            appBar: AppSimpleAppBar(
              title: 'Test',
              actions: [Icon(Icons.settings)],
            ),
          ),
        ),
      );

      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.iconTheme?.size, IconSizes.md);
      expect(appBar.actionsIconTheme?.size, IconSizes.md);
    });

    testWidgets('should have bottom divider border', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(appBar: AppSimpleAppBar(title: 'Test')),
        ),
      );

      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.bottom, isNotNull);
      expect(appBar.bottom!.preferredSize.height, BorderWidths.thin);
    });

    testWidgets('title should have semantics header', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(appBar: AppSimpleAppBar(title: 'Test')),
        ),
      );

      final semanticsFinder = find.ancestor(
        of: find.text('Test'),
        matching: find.byWidgetPredicate((w) => w is Semantics),
      );
      expect(semanticsFinder, findsWidgets);
    });

    testWidgets('should respect titleSemanticLabel', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            appBar: AppSimpleAppBar(
              title: 'لوحة التحكم',
              titleSemanticLabel: 'شاشة لوحة التحكم الرئيسية',
            ),
          ),
        ),
      );

      final semanticsNode = tester.getSemantics(find.text('لوحة التحكم'));
      expect(semanticsNode.label, contains('شاشة لوحة التحكم الرئيسية'));
    });
  });
}
