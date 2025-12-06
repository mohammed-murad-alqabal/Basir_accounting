/// اختبارات LoginScreen
library;

import 'package:basser_app/core/constants.dart';
import 'package:basser_app/core/widgets/index.dart';
import 'package:basser_app/features/auth/presentation/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoginScreen', () {
    group('Display Tests', () {
      testWidgets('should display login form', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: LoginScreen(),
          ),
        );

        expect(find.byType(LoginScreen), findsOneWidget);
        expect(find.byType(Form), findsOneWidget);
      });

      testWidgets('should display logo and header', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: LoginScreen(),
          ),
        );

        // "تسجيل الدخول" appears twice: header + button
        expect(find.text('تسجيل الدخول'), findsNWidgets(2));
        expect(
          find.text('رحباً بك مجدداً! سجل دخولك للمتابعة'),
          findsOneWidget,
        );
      });

      testWidgets('should display username field', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: LoginScreen(),
          ),
        );

        expect(find.text('اسم المستخدم'), findsOneWidget);
        expect(find.text('أدخل اسم المستخدم'), findsOneWidget);
        expect(find.byIcon(Icons.person), findsOneWidget);
      });

      testWidgets('should display password field', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: LoginScreen(),
          ),
        );

        expect(find.text('كلمة المرور'), findsOneWidget);
        expect(find.text('أدخل كلمة المرور'), findsOneWidget);
        expect(find.byIcon(Icons.lock), findsOneWidget);
      });

      testWidgets('should display keep logged in checkbox', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: LoginScreen(),
          ),
        );

        expect(find.text('البقاء مسجلاً'), findsOneWidget);
        expect(find.byType(Checkbox), findsOneWidget);
      });

      testWidgets('should display login button', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: LoginScreen(),
          ),
        );

        expect(find.text('تسجيل الدخول'), findsNWidgets(2)); // Header + Button
        expect(find.byType(AppPrimaryButton), findsOneWidget);
      });

      testWidgets('should display guest login button', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: LoginScreen(),
          ),
        );

        expect(find.text('الدخول كضيف'), findsOneWidget);
        expect(find.byType(AppSecondaryButton), findsOneWidget);
      });

      testWidgets('should display create account link', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: LoginScreen(),
          ),
        );

        expect(find.text('ليس لديك حساب؟ '), findsOneWidget);
        expect(find.text('أنشئ حساباً الآن'), findsOneWidget);
        expect(find.byType(AppTextButton), findsOneWidget);
      });
    });

    group('Validation Tests', () {
      testWidgets('should show error when username is empty', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: LoginScreen(),
          ),
        );

        // Tap login button without entering username
        await tester.tap(find.text('تسجيل الدخول').last);
        await tester.pumpAndSettle();

        expect(find.text(AppMessages.emptyField), findsAtLeastNWidgets(1));
      });

      testWidgets('should show error when password is empty', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: LoginScreen(),
          ),
        );

        // Enter username but not password
        await tester.enterText(
          find.byType(AppTextField).first,
          'testuser',
        );

        // Tap login button
        await tester.tap(find.text('تسجيل الدخول').last);
        await tester.pumpAndSettle();

        expect(find.text(AppMessages.emptyField), findsOneWidget);
      });

      testWidgets('should show errors for both empty fields', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: LoginScreen(),
          ),
        );

        // Tap login button without entering anything
        await tester.tap(find.text('تسجيل الدخول').last);
        await tester.pumpAndSettle();

        // Should show 2 error messages (username + password)
        expect(find.text(AppMessages.emptyField), findsNWidgets(2));
      });

      testWidgets('should not show errors initially', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: LoginScreen(),
          ),
        );

        // No error messages should be visible initially
        expect(find.text(AppMessages.emptyField), findsNothing);
      });
    });

    group('Interaction Tests', () {
      testWidgets('should allow entering username', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: LoginScreen(),
          ),
        );

        await tester.enterText(
          find.byType(AppTextField).first,
          'testuser',
        );
        await tester.pump();

        expect(find.text('testuser'), findsOneWidget);
      });

      testWidgets('should allow entering password', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: LoginScreen(),
          ),
        );

        await tester.enterText(
          find.byType(AppTextField).last,
          'password123',
        );
        await tester.pump();

        // Password should be obscured, so we check the controller
        final textField = tester.widget<AppTextField>(
          find.byType(AppTextField).last,
        );
        expect(textField.obscureText, isTrue);
      });

      testWidgets('should toggle keep logged in checkbox', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: LoginScreen(),
          ),
        );

        // Initially checked
        var checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
        expect(checkbox.value, isTrue);

        // Tap to uncheck
        await tester.tap(find.byType(Checkbox));
        await tester.pump();

        checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
        expect(checkbox.value, isFalse);

        // Tap to check again
        await tester.tap(find.byType(Checkbox));
        await tester.pump();

        checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
        expect(checkbox.value, isTrue);
      });

      testWidgets('should have create account button', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: LoginScreen(),
          ),
        );

        // Should have create account button
        expect(find.text('أنشئ حساباً الآن'), findsOneWidget);
        expect(find.byType(AppTextButton), findsOneWidget);
      });

      testWidgets('should show loading state when logging in', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: const LoginScreen(),
            routes: {
              '/dashboard': (context) => const Scaffold(
                    body: Text('Dashboard'),
                  ),
            },
          ),
        );

        // Enter valid credentials
        await tester.enterText(
          find.byType(AppTextField).first,
          'testuser',
        );
        await tester.enterText(
          find.byType(AppTextField).last,
          'password123',
        );

        // Tap login button
        await tester.tap(find.text('تسجيل الدخول').last);
        await tester.pump();

        // Should show loading indicator
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('should navigate to dashboard after successful login',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: const LoginScreen(),
            routes: {
              '/dashboard': (context) => const Scaffold(
                    body: Text('Dashboard'),
                  ),
            },
          ),
        );

        // Enter valid credentials
        await tester.enterText(
          find.byType(AppTextField).first,
          'testuser',
        );
        await tester.enterText(
          find.byType(AppTextField).last,
          'password123',
        );

        // Tap login button
        await tester.tap(find.text('تسجيل الدخول').last);
        await tester.pumpAndSettle();

        // Should navigate to dashboard
        expect(find.text('Dashboard'), findsOneWidget);
      });

      testWidgets('should have guest login button', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: LoginScreen(),
          ),
        );

        // Should have guest login button
        expect(find.text('الدخول كضيف'), findsOneWidget);
        expect(find.byType(AppSecondaryButton), findsOneWidget);
      });
    });

    group('Form Behavior', () {
      testWidgets('should enable autovalidate after first submit',
          (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: LoginScreen(),
          ),
        );

        // Initially no errors
        expect(find.text(AppMessages.emptyField), findsNothing);

        // Tap login button (first submit)
        await tester.tap(find.text('تسجيل الدخول').last);
        await tester.pumpAndSettle();

        // Now errors should appear
        expect(find.text(AppMessages.emptyField), findsNWidgets(2));

        // Enter username
        await tester.enterText(
          find.byType(AppTextField).first,
          'testuser',
        );
        await tester.pump();

        // Error for username should disappear (autovalidate enabled)
        expect(find.text(AppMessages.emptyField), findsOneWidget);
      });

      testWidgets('should clear errors when fields are filled', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: LoginScreen(),
          ),
        );

        // Tap login button to show errors
        await tester.tap(find.text('تسجيل الدخول').last);
        await tester.pumpAndSettle();

        expect(find.text(AppMessages.emptyField), findsNWidgets(2));

        // Fill username
        await tester.enterText(
          find.byType(AppTextField).first,
          'testuser',
        );
        await tester.pump();

        // One error should remain (password)
        expect(find.text(AppMessages.emptyField), findsOneWidget);

        // Fill password
        await tester.enterText(
          find.byType(AppTextField).last,
          'password123',
        );
        await tester.pump();

        // All errors should be cleared
        expect(find.text(AppMessages.emptyField), findsNothing);
      });
    });

    group('UI Elements', () {
      testWidgets('should have scrollable content', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: LoginScreen(),
          ),
        );

        expect(find.byType(SingleChildScrollView), findsOneWidget);
      });

      testWidgets('should have safe area', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: LoginScreen(),
          ),
        );

        expect(find.byType(SafeArea), findsOneWidget);
      });

      testWidgets('should have proper spacing', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: LoginScreen(),
          ),
        );

        // Check for SizedBox widgets (spacing)
        expect(find.byType(SizedBox), findsWidgets);
      });
    });
  });
}
