import 'dart:async';

import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/auth/presentation/screens/guest_upgrade_screen.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:basir_accounting_system/shared/widgets/app_enhanced_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../helpers/auth_test_helper.dart';

void main() {
  late MockAuthServiceTestHelper mockAuthService;

  setUp(() {
    mockAuthService = <credential-fixture>();
  });

  Widget createSubject() => ProviderScope(
        overrides: [authServiceProvider.overrideWithValue(mockAuthService)],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('ar'),
          home: const Scaffold(body: Text('Home')),
          onGenerateRoute: (settings) {
            if (settings.name == '/upgrade') {
              return MaterialPageRoute(
                builder: (context) => const GuestUpgradeScreen(),
              );
            }
            return null;
          },
        ),
      );

  group('GuestUpgradeScreen', () {
    testWidgets('renders all form fields and button', (tester) async {
      await tester.pumpWidget(createSubject());
      await tester.tap(find.text('Home'));
      final context = tester.element(find.text('Home'));
      unawaited(Navigator.of(context).pushNamed('/upgrade'));
      await tester.pumpAndSettle();

      final l10n = AppLocalizations.of(context);
      expect(find.text(l10n.actionUpgradeAccount), findsWidgets);
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.byType(Icon), findsWidgets);
    });

    testWidgets('shows validation errors when fields are empty', (
      tester,
    ) async {
      await tester.pumpWidget(createSubject());
      final context = tester.element(find.text('Home'));
      unawaited(Navigator.of(context).pushNamed('/upgrade'));
      await tester.pumpAndSettle();

      // Use localized text - find button specifically (not AppBar title)
      final l10n = AppLocalizations.of(context);
      final buttonFinder = find.descendant(
        of: find.byWidgetPredicate(
          (widget) =>
              widget is AppEnhancedButton &&
              widget.type == AppEnhancedButtonType.primary,
        ),
        matching: find.text(l10n.actionUpgradeAccount),
      );
      await tester.tap(buttonFinder);
      await tester.pump();

      expect(find.text(l10n.errEmptyField), findsNWidgets(2));
    });

    testWidgets('calls convertGuestToUser when form is valid', (tester) async {
      await tester.pumpWidget(createSubject());
      final context = tester.element(find.text('Home'));
      unawaited(Navigator.of(context).pushNamed('/upgrade'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(0), 'newuser');
      await tester.enterText(find.byType(TextFormField).at(1), 'password123');

      // Use localized text - find button specifically (not AppBar title)
      final l10n = AppLocalizations.of(context);
      final buttonFinder = find.descendant(
        of: find.byWidgetPredicate(
          (widget) =>
              widget is AppEnhancedButton &&
              widget.type == AppEnhancedButtonType.primary,
        ),
        matching: find.text(l10n.actionUpgradeAccount),
      );
      await tester.tap(buttonFinder);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(mockAuthService.convertCalled, isTrue);
      expect(mockAuthService.lastUsername, 'newuser');
      expect(mockAuthService.lastPassword, 'password123');
    });
  });
}
