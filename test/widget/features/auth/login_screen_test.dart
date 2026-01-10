/// اختبارات LoginScreen
// ignore_for_file: lines_longer_than_80_chars
library;

import 'package:basir_app/core/providers.dart';
import 'package:basir_app/features/auth/application/auth_service.dart';
import 'package:basir_app/features/auth/presentation/screens/login_screen.dart';
import 'package:basir_app/l10n/app_localizations.dart';
import 'package:basir_app/shared/widgets/index.dart';
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
          overrides: overrides,
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
          (widget) =>
              widget is AppEnhancedButton &&
              widget.type == AppEnhancedButtonType.primary,
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
          (widget) =>
              widget is AppEnhancedButton &&
              widget.type == AppEnhancedButtonType.secondary,
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
          (widget) =>
              widget is AppEnhancedButton &&
              widget.type == AppEnhancedButtonType.primary,
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
  });
}
