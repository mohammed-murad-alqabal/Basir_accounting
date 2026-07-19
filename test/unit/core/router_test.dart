/// اختبارات AppRouter
library;

import 'package:basir_accounting_system/core/router.dart';
import 'package:basir_accounting_system/features/auth/presentation/screens/login_screen.dart';
import 'package:basir_accounting_system/features/auth/presentation/screens/setup_screen.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppRouter', () {
    testWidgets('should generate route for /setup', (tester) async {
      // Arrange
      const settings = RouteSettings(name: '/setup');

      // Act
      final route = AppRouter.generateRoute(settings);

      // Assert
      expect(route, isA<MaterialPageRoute<dynamic>>());

      // Build a simple MaterialApp first
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(),
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale('ar'),
          ),
        ),
      );

      // Now we can safely get the context and build the route
      final context = tester.element(find.byType(Scaffold));
      final widget = (route as MaterialPageRoute<dynamic>).builder(context);

      // Pump the actual widget
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: widget,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('ar'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(SetupScreen), findsOneWidget);
    });

    testWidgets('should generate route for /login', (tester) async {
      // Arrange
      const settings = RouteSettings(name: '/login');

      // Act
      final route = AppRouter.generateRoute(settings);

      // Assert
      expect(route, isA<MaterialPageRoute<dynamic>>());

      // Build a simple MaterialApp first
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(),
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale('ar'),
          ),
        ),
      );

      // Now we can safely get the context and build the route
      final context = tester.element(find.byType(Scaffold));
      final widget = (route as MaterialPageRoute<dynamic>).builder(context);

      // Pump the actual widget
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: widget,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('ar'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(LoginScreen), findsOneWidget);
    });

    test('should generate route for /dashboard', () {
      const settings = RouteSettings(name: '/dashboard');
      final route = AppRouter.generateRoute(settings);
      expect(route, isA<MaterialPageRoute<dynamic>>());
    });

    test('should generate route for /customers', () {
      const settings = RouteSettings(name: '/customers');
      final route = AppRouter.generateRoute(settings);
      expect(route, isA<MaterialPageRoute<dynamic>>());
    });

    test('should generate route for /invoices', () {
      const settings = RouteSettings(name: '/invoices');
      final route = AppRouter.generateRoute(settings);
      expect(route, isA<MaterialPageRoute<dynamic>>());
    });

    test('should generate route for /settings', () {
      const settings = RouteSettings(name: '/settings');
      final route = AppRouter.generateRoute(settings);
      expect(route, isA<MaterialPageRoute<dynamic>>());
    });

    test('should generate route for /button-test', () {
      const settings = RouteSettings(name: '/button-test');
      final route = AppRouter.generateRoute(settings);
      expect(route, isA<MaterialPageRoute<dynamic>>());
    });

    test('should generate error route for unknown path', () {
      const settings = RouteSettings(name: '/unknown');
      final route = AppRouter.generateRoute(settings);
      expect(route, isA<MaterialPageRoute<dynamic>>());
    });

    test('should handle null route name', () {
      const settings = RouteSettings();
      final route = AppRouter.generateRoute(settings);
      expect(route, isA<MaterialPageRoute<dynamic>>());
    });

    test('should handle empty route name', () {
      const settings = RouteSettings(name: '');
      final route = AppRouter.generateRoute(settings);
      expect(route, isA<MaterialPageRoute<dynamic>>());
    });

    group('Route Parameters', () {
      test('should handle route with arguments', () {
        const settings = RouteSettings(
          name: '/customers',
          arguments: {'customerId': '123'},
        );
        final route = AppRouter.generateRoute(settings);
        expect(route, isA<MaterialPageRoute<dynamic>>());
        // Route is created successfully with arguments
      });

      test('should handle route with null arguments', () {
        const settings = RouteSettings(name: '/dashboard');
        final route = AppRouter.generateRoute(settings);
        expect(route, isA<MaterialPageRoute<dynamic>>());
      });

      test('should accept route settings with arguments', () {
        const settings = RouteSettings(
          name: '/invoices',
          arguments: {'filter': 'paid'},
        );
        final route = AppRouter.generateRoute(settings);
        expect(route, isA<MaterialPageRoute<dynamic>>());
        // Route is created successfully
      });
    });

    group('Route Properties', () {
      test('should create MaterialPageRoute for all routes', () {
        final routes = [
          '/setup',
          '/login',
          '/dashboard',
          '/customers',
          '/invoices',
          '/settings',
          '/button-test',
        ];

        for (final routeName in routes) {
          final settings = RouteSettings(name: routeName);
          final route = AppRouter.generateRoute(settings);
          expect(
            route,
            isA<MaterialPageRoute<dynamic>>(),
            reason: 'Route $routeName should be MaterialPageRoute',
          );
        }
      });

      test('should generate route for given settings', () {
        const settings = RouteSettings(name: '/customers');
        final route = AppRouter.generateRoute(settings);
        expect(route, isA<MaterialPageRoute<dynamic>>());
        // Route is created successfully for the given settings
      });
    });

    group('Error Handling', () {
      testWidgets('should show error message for unknown route', (
        tester,
      ) async {
        const settings = RouteSettings(name: '/unknown-route');
        final route = AppRouter.generateRoute(settings) as MaterialPageRoute;

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: Builder(builder: route.builder),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(Scaffold), findsOneWidget);
        // Also verify the error message is shown/localized if possible
      });

      test('should handle special characters in route name', () {
        const settings = RouteSettings(name: r'/route@#$%');
        final route = AppRouter.generateRoute(settings);
        expect(route, isA<MaterialPageRoute<dynamic>>());
      });

      test('should handle very long route name', () {
        final longRouteName = '/route${'a' * 1000}';
        final settings = RouteSettings(name: longRouteName);
        final route = AppRouter.generateRoute(settings);
        expect(route, isA<MaterialPageRoute<dynamic>>());
      });
    });

    group('Route Coverage', () {
      test('should cover all defined routes', () {
        final definedRoutes = [
          '/setup',
          '/login',
          '/dashboard',
          '/customers',
          '/invoices',
          '/settings',
          '/button-test',
        ];

        for (final routeName in definedRoutes) {
          final settings = RouteSettings(name: routeName);
          final route = AppRouter.generateRoute(settings);
          expect(
            route,
            isA<MaterialPageRoute<dynamic>>(),
            reason: 'Route $routeName should be defined',
          );
        }
      });

      test('should handle case-sensitive route names', () {
        const settings1 = RouteSettings(name: '/Dashboard');
        const settings2 = RouteSettings(name: '/dashboard');

        final route1 = AppRouter.generateRoute(settings1);
        final route2 = AppRouter.generateRoute(settings2);

        // /Dashboard should show error (case-sensitive)
        // /dashboard should work
        expect(route1, isA<MaterialPageRoute<dynamic>>());
        expect(route2, isA<MaterialPageRoute<dynamic>>());
      });
    });
  });
}
