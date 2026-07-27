/// اختبارات LoginScreen
// ignore_for_file: lines_longer_than_80_chars
library;

import 'package:basir_accounting_system/core/assets/app_logo.dart';
import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/features/auth/application/auth_service.dart';
import 'package:basir_accounting_system/features/auth/domain/models/auth_models.dart';
import 'package:basir_accounting_system/features/auth/presentation/screens/login_screen.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthService extends Mock implements AuthService {}

class FakeRoute extends Fake implements Route<dynamic> {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeRoute());
  });

  group('LoginScreen', () {
    Widget createTestWidget({
      required List<Override> overrides,
      NavigatorObserver? observer,
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
          child: MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('ar'),
            home: const LoginScreen(),
            routes: {
              '/dashboard': (_) => const Scaffold(body: Text('Dashboard')),
            },
            navigatorObservers: observer != null ? [observer] : [],
          ),
        );

    late AppLocalizations l10n;
    late MockAuthService mockAuthService;

    setUp(() {
      mockAuthService = <credential-fixture>();
      when(
        () => mockAuthService.login(any(), any()),
      ).thenAnswer((_) async => true);
      when(() => mockAuthService.loginAsGuest()).thenAnswer((_) async {});
      when(
        () => mockAuthService.setKeepLoggedIn(
          keepLoggedIn: any(named: 'keepLoggedIn'),
        ),
      ).thenAnswer((_) async {});
    });

    Future<void> setUpWidgets(WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          overrides: [authServiceProvider.overrideWithValue(mockAuthService)],
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      l10n = AppLocalizations.of(tester.element(find.byType(LoginScreen)));
    }

    group('Display Tests', () {
      testWidgets('should display login form', (tester) async {
        await setUpWidgets(tester);
        expect(find.byType(LoginScreen), findsOneWidget);
        expect(find.byType(Form), findsOneWidget);
      });
    });

    group('Interaction Tests', () {
      testWidgets('should navigate to dashboard after successful login', (
        tester,
      ) async {
        await setUpWidgets(tester);

        await tester.enterText(find.byType(AppTextField).first, 'testuser');
        await tester.enterText(find.byType(AppTextField).last, 'password123');
        await tester.pump();

        final loginButton = find.byWidgetPredicate(
          (widget) => widget is AppEnhancedButton && widget.type == AppEnhancedButtonType.primary,
        );
        await tester.ensureVisible(loginButton);
        await tester.tap(loginButton);

        var navigated = false;
        for (var i = 0; i < 60; i++) {
          await tester.pump(const Duration(milliseconds: 50));
          if (find.text('Dashboard').evaluate().isNotEmpty) {
            navigated = true;
            break;
          }
        }
        expect(
          navigated,
          isTrue,
          reason: 'Successful login did not navigate to Dashboard',
        );
      });

      testWidgets(
          'should navigate to dashboard '
          'after guest login', (tester) async {
        await setUpWidgets(tester);

        final guestButton = find.byWidgetPredicate(
          (widget) => widget is AppEnhancedButton && widget.type == AppEnhancedButtonType.secondary,
        );
        await tester.ensureVisible(guestButton);
        await tester.tap(guestButton);

        // Use a more careful pumping sequence to avoid "Future already
        // completed"
        await tester.pump(); // Start logic
        await tester.pump(
          const Duration(milliseconds: 50),
        ); // AuthService completes
        await tester.pump(); // SnackBar shows
        await tester.pump(
          const Duration(milliseconds: 50),
        ); // Navigation starts

        var navigated = false;
        for (var i = 0; i < 60; i++) {
          await tester.pump(const Duration(milliseconds: 50));
          if (find.text('Dashboard').evaluate().isNotEmpty) {
            navigated = true;
            break;
          }
        }
        expect(navigated, isTrue);
      });
    });

    group('Error Handling', () {
      testWidgets('should show error on login failure', (tester) async {
        when(
          () => mockAuthService.login(any(), any()),
        ).thenAnswer((_) async => false);
        await setUpWidgets(tester);

        await tester.enterText(find.byType(AppTextField).first, 'user');
        await tester.enterText(find.byType(AppTextField).last, 'pass');
        await tester.pump();

        final loginButton = find.byWidgetPredicate(
          (widget) => widget is AppEnhancedButton && widget.type == AppEnhancedButtonType.primary,
        );
        await tester.ensureVisible(loginButton);
        await tester.tap(loginButton);

        await tester.pump(); // Action
        await tester.pump(const Duration(milliseconds: 100)); // Result

        // Wait for SnackBar
        var foundError = false;
        for (var i = 0; i < 20; i++) {
          await tester.pump(const Duration(milliseconds: 50));
          if (find.textContaining(l10n.errLoginFailed).evaluate().isNotEmpty) {
            foundError = true;
            break;
          }
        }
        expect(foundError, isTrue);
      });
    });

    group('LoginScreen - UI/UX Improvements (Task 17)', () {
      testWidgets('should use GlassScaffold as root container', (tester) async {
        await setUpWidgets(tester);
        final glassScaffoldFinder = find.descendant(
          of: find.byElementPredicate(
            (element) => element.widget is LoginScreen,
          ),
          matching: find.byType(GlassScaffold),
        );
        expect(glassScaffoldFinder, findsOneWidget);
        expect(find.byType(GlassScaffold), findsOneWidget);
      });

      testWidgets('should use AppTextField with icons using IconSizes', (
        tester,
      ) async {
        await setUpWidgets(tester);
        final textFields = find.byType(AppTextField);
        expect(textFields, findsNWidgets(2));

        for (final textFieldFinder in textFields.evaluate()) {
          final textFieldWidget = tester.widget<AppTextField>(
            find.byWidget(textFieldFinder.widget),
          );
          expect(textFieldWidget.prefixIcon, isNotNull);
          final prefixIcon = textFieldWidget.prefixIcon! as Icon;
          expect(
            [
              IconSizes.xs,
              IconSizes.sm,
              IconSizes.md,
              IconSizes.lg,
              IconSizes.xl,
            ].contains(prefixIcon.size),
            isTrue,
            reason: 'Icon size should be one of IconSizes values, got ${prefixIcon.size}',
          );
        }
      });

      testWidgets('should use AppEnhancedButton for login and guest buttons', (
        tester,
      ) async {
        await setUpWidgets(tester);
        final primaryButtonFinder = find.byWidgetPredicate(
          (widget) => widget is AppEnhancedButton && widget.type == AppEnhancedButtonType.primary,
        );
        final secondaryButtonFinder = find.byWidgetPredicate(
          (widget) => widget is AppEnhancedButton && widget.type == AppEnhancedButtonType.secondary,
        );
        expect(primaryButtonFinder, findsOneWidget);
        expect(secondaryButtonFinder, findsOneWidget);

        final primaryButton = tester.widget<AppEnhancedButton>(
          primaryButtonFinder,
        );
        final secondaryButton = tester.widget<AppEnhancedButton>(
          secondaryButtonFinder,
        );
        expect(primaryButton.label, l10n.loginTitle);
        expect(secondaryButton.label, l10n.loginGuest);
      });

      testWidgets('should have Form with GlobalKey for validation', (
        tester,
      ) async {
        await setUpWidgets(tester);
        final formFinder = find.descendant(
          of: find.byType(LoginScreen),
          matching: find.byType(Form),
        );
        expect(formFinder, findsOneWidget);
        final formWidget = tester.widget<Form>(formFinder);
        expect(formWidget.key, isNotNull);
        expect(formWidget.key, isA<GlobalKey<FormState>>());

        final loginButton = find.byWidgetPredicate(
          (widget) => widget is AppEnhancedButton && widget.type == AppEnhancedButtonType.primary,
        );
        await tester.ensureVisible(loginButton);
        await tester.tap(loginButton);
        await tester.pump();
        expect(find.text(l10n.errEmptyField), findsNWidgets(2));
      });

      testWidgets('should have Remember Me Checkbox with Text beside it', (
        tester,
      ) async {
        await setUpWidgets(tester);
        final checkboxFinder = find.descendant(
          of: find.byType(LoginScreen),
          matching: find.byType(Checkbox),
        );
        expect(checkboxFinder, findsOneWidget);

        final checkbox = tester.widget<Checkbox>(checkboxFinder);
        expect(checkbox.value, isTrue);

        final rememberMeTextFinder = find.text(l10n.labelRememberMe);
        expect(rememberMeTextFinder, findsOneWidget);

        final checkboxOffset = tester.getCenter(checkboxFinder);
        final textOffset = tester.getCenter(rememberMeTextFinder);
        expect(
          (checkboxOffset.dy - textOffset.dy).abs() < 50,
          isTrue,
          reason: 'Checkbox and RememberMe text should be on the same row',
        );
      });

      testWidgets('should have TextButton for Forgot Password', (
        tester,
      ) async {
        await setUpWidgets(tester);
        final forgotPasswordTextFinder = find.text(l10n.forgotPassword);
        expect(forgotPasswordTextFinder, findsOneWidget);

        final textButtonFinder = find.ancestor(
          of: forgotPasswordTextFinder,
          matching: find.byType(TextButton),
        );
        expect(textButtonFinder, findsOneWidget);
      });

      testWidgets('should have AppLogo (BasirLogo) in screen header', (
        tester,
      ) async {
        await setUpWidgets(tester);
        final logoFinder = find.descendant(
          of: find.byType(LoginScreen),
          matching: find.byType(BasirLogo),
        );
        expect(logoFinder, findsOneWidget);

        final loginScreenTop = tester.getTopLeft(find.byType(LoginScreen));
        final logoTop = tester.getTopLeft(logoFinder);
        expect(
          (logoTop.dy - loginScreenTop.dy) < 300,
          isTrue,
          reason: 'Logo should be in the header (top portion of the screen)',
        );
      });

      testWidgets('should show error messages via AppSnackbar on login failure', (
        tester,
      ) async {
        when(
          () => mockAuthService.login(any(), any()),
        ).thenAnswer((_) async => false);
        await setUpWidgets(tester);

        await tester.enterText(find.byType(AppTextField).first, 'wronguser');
        await tester.enterText(find.byType(AppTextField).last, 'wrongpass');
        await tester.pump();

        final loginButton = find.byWidgetPredicate(
          (widget) => widget is AppEnhancedButton && widget.type == AppEnhancedButtonType.primary,
        );
        await tester.ensureVisible(loginButton);
        await tester.tap(loginButton);

        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        var foundSnackbar = false;
        var foundErrorText = false;
        for (var i = 0; i < 40; i++) {
          await tester.pump(const Duration(milliseconds: 50));
          if (find.byType(SnackBar).evaluate().isNotEmpty) {
            foundSnackbar = true;
          }
          if (find.textContaining(l10n.errLoginFailed).evaluate().isNotEmpty) {
            foundErrorText = true;
          }
          if (foundSnackbar && foundErrorText) break;
        }
        expect(foundSnackbar, isTrue, reason: 'SnackBar should appear');
        expect(foundErrorText, isTrue, reason: 'Error message should be shown');
      });
    });
  });
}
