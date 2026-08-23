import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/core/theme/app_theme.dart';
import 'package:basir_accounting_system/core/theme/tokens/app_icons.dart';
import 'package:basir_accounting_system/features/auth/presentation/screens/login_screen.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:basir_accounting_system/shared/widgets/app_enhanced_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../../mocks/app_mocks.mocks.dart';

void main() {
  Widget buildApp(MockAuthService authService) => ProviderScope(
        overrides: [
          authServiceProvider.overrideWithValue(authService),
          appIconsProvider.overrideWithValue(const MaterialAppIcons()),
        ],
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('ar'),
          routes: {
            '/dashboard': (_) => const Scaffold(
                  body: Text('dashboard-route'),
                ),
          },
          home: const Directionality(
            textDirection: TextDirection.rtl,
            child: LoginScreen(),
          ),
        ),
      );

  testWidgets('ينفذ تسجيل الدخول وينقل المستخدم إلى لوحة التحكم',
      (tester) async {
    final authService = MockAuthService();
    when(authService.login('demo', 'secret')).thenAnswer((_) async => true);
    when(authService.setKeepLoggedIn(keepLoggedIn: anyNamed('keepLoggedIn')))
        .thenAnswer((_) async {});

    await tester.pumpWidget(buildApp(authService));
    await tester.pumpAndSettle();

    final fields = find.byType(TextField);
    expect(fields, findsNWidgets(2));
    await tester.enterText(fields.at(0), 'demo');
    await tester.enterText(fields.at(1), 'secret');

    final loginButton = find.byType(AppEnhancedButton).first;
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    expect(find.text('dashboard-route'), findsOneWidget);
    verify(authService.login('demo', 'secret')).called(1);
    verify(authService.setKeepLoggedIn(keepLoggedIn: true)).called(1);
  });
}
