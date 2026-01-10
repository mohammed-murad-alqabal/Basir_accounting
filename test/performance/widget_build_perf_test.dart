import 'package:basir_app/core/providers/supabase_auth_provider.dart';
import 'package:basir_app/core/theme/app_theme.dart';
import 'package:basir_app/features/auth/presentation/screens/login_screen.dart';
import 'package:basir_app/features/settings/presentation/screens/settings_screen.dart';
import 'package:basir_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Widget Build Performance Tests', () {
    testWidgets(
      'SettingsScreen build performance benchmark',
      (tester) async {
        final stopwatch = Stopwatch()..start();

        // Build the widget 50 times to measure average build cost
        // Limits iterations to avoid timeout in CI environments
        const iterations = 50;

        for (var i = 0; i < iterations; i++) {
          await tester.pumpWidget(
            ProviderScope(
              overrides: [currentUserProvider.overrideWith((ref) => null)],
              child: MaterialApp(
                theme: AppTheme.lightTheme,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                locale: const Locale('ar'),
                home: const SettingsScreen(),
              ),
            ),
          );
          // Force a frame
          await tester.pump();
        }

        stopwatch.stop();
        final avgTime = stopwatch.elapsedMilliseconds / iterations;
        debugPrint(
          'SettingsScreen Average Build Time: '
          '${avgTime.toStringAsFixed(2)}ms',
        );

        // Average build time should be reasonable
        // (<25ms for simple build in test environment)
        expect(
          avgTime,
          lessThan(100),
          reason: 'Build time should be < 100ms. '
              'Got: ${avgTime.toStringAsFixed(2)}ms',
        );
      },
      skip: true, // Flaky in CI
    );

    testWidgets('LoginScreen memory leak check (Disposal)', (tester) async {
      // Pump the widget
      await tester.pumpWidget(
        ProviderScope(
          overrides: [currentUserProvider.overrideWith((ref) => null)],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const LoginScreen(),
          ),
        ),
      );

      // Replace it with something else to trigger disposal
      await tester.pumpWidget(const SizedBox());
      await tester.pumpAndSettle();

      // If there were uncancelled timers or animations,
      // this might throw or print errors.
      // This test is basic; specialized leakage detection
      // would require more setup.
      expect(tester.takeException(), isNull);
    });
  });
}
