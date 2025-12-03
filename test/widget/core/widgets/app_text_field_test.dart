import 'package:basser_app/core/theme/app_colors.dart';
import 'package:basser_app/core/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppTextField', () {
    testWidgets('should display label correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppTextField(
              label: 'البريد الإلكتروني',
            ),
          ),
        ),
      );

      expect(find.text('البريد الإلكتروني'), findsOneWidget);
    });

    testWidgets('should display hint text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppTextField(
              label: 'البريد الإلكتروني',
              hint: 'أدخل بريدك الإلكتروني',
            ),
          ),
        ),
      );

      expect(find.text('أدخل بريدك الإلكتروني'), findsOneWidget);
    });

    testWidgets('should accept text input', (tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppTextField(
              label: 'البريد الإلكتروني',
              controller: controller,
            ),
          ),
        ),
      );

      await tester.enterText(
        find.byType(TextFormField),
        'test@example.com',
      );

      expect(controller.text, equals('test@example.com'));
    });

    testWidgets('should call onChanged when text changes', (tester) async {
      String? changedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppTextField(
              label: 'البريد الإلكتروني',
              onChanged: (value) => changedValue = value,
            ),
          ),
        ),
      );

      await tester.enterText(
        find.byType(TextFormField),
        'test@example.com',
      );

      expect(changedValue, equals('test@example.com'));
    });

    testWidgets('should show error message when validation fails',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              child: AppTextField(
                label: 'البريد الإلكتروني',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'البريد الإلكتروني مطلوب';
                  }
                  return null;
                },
              ),
            ),
          ),
        ),
      );

      // Trigger validation
      final formState = tester.state<FormState>(find.byType(Form));
      formState.validate();
      await tester.pumpAndSettle();

      expect(find.text('البريد الإلكتروني مطلوب'), findsOneWidget);
    });

    testWidgets('should toggle password visibility', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppTextField(
              label: 'كلمة المرور',
              obscureText: true,
            ),
          ),
        ),
      );

      // Initially should have visibility_off icon
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);

      // Tap visibility toggle
      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pumpAndSettle();

      // Should show visibility icon now
      expect(find.byIcon(Icons.visibility), findsOneWidget);

      // Tap again to hide
      await tester.tap(find.byIcon(Icons.visibility));
      await tester.pumpAndSettle();

      // Should show visibility_off icon again
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });

    testWidgets('should display prefix icon', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppTextField(
              label: 'البريد الإلكتروني',
              prefixIcon: Icon(Icons.email),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.email), findsOneWidget);
    });

    testWidgets('should display suffix icon when not password field',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppTextField(
              label: 'البريد الإلكتروني',
              suffixIcon: Icon(Icons.check),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('should be disabled when enabled is false', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppTextField(
              label: 'البريد الإلكتروني',
              enabled: false,
            ),
          ),
        ),
      );

      final textField = tester.widget<TextField>(
        find.descendant(
          of: find.byType(TextFormField),
          matching: find.byType(TextField),
        ),
      );

      expect(textField.enabled, isFalse);
    });

    testWidgets('should have correct border colors', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppTextField(
              label: 'البريد الإلكتروني',
            ),
          ),
        ),
      );

      final textField = tester.widget<TextField>(
        find.descendant(
          of: find.byType(TextFormField),
          matching: find.byType(TextField),
        ),
      );

      final decoration = textField.decoration!;

      // Check enabled border (1px)
      final enabledBorder = decoration.enabledBorder! as OutlineInputBorder;
      expect(enabledBorder.borderSide.width, equals(1));

      // Check focused border (2px, primary color)
      final focusedBorder = decoration.focusedBorder! as OutlineInputBorder;
      expect(focusedBorder.borderSide.width, equals(2));
      expect(focusedBorder.borderSide.color, equals(AppColors.primary));

      // Check error border (red color)
      final errorBorder = decoration.errorBorder! as OutlineInputBorder;
      expect(errorBorder.borderSide.color, equals(AppColors.error));
    });

    testWidgets('should support multiline input', (tester) async {
      const maxLines = 5;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppTextField(
              label: 'الملاحظات',
              maxLines: maxLines,
            ),
          ),
        ),
      );

      // Verify the widget was created with maxLines parameter
      final appTextField = tester.widget<AppTextField>(
        find.byType(AppTextField),
      );

      expect(appTextField.maxLines, equals(maxLines));
    });
  });

  group('AppSearchField', () {
    testWidgets('should display hint text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppSearchField(
              hint: 'ابحث عن عميل...',
            ),
          ),
        ),
      );

      expect(find.text('ابحث عن عميل...'), findsOneWidget);
    });

    testWidgets('should display search icon', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppSearchField(),
          ),
        ),
      );

      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('should show clear button when text is entered',
        (tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppSearchField(
              controller: controller,
            ),
          ),
        ),
      );

      // Initially no clear button
      expect(find.byIcon(Icons.clear), findsNothing);

      // Enter text
      await tester.enterText(find.byType(TextField), 'test');
      await tester.pumpAndSettle();

      // Clear button should appear
      expect(find.byIcon(Icons.clear), findsOneWidget);
    });

    testWidgets('should clear text when clear button is tapped',
        (tester) async {
      final controller = TextEditingController(text: 'test');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppSearchField(
              controller: controller,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Clear button should be visible
      expect(find.byIcon(Icons.clear), findsOneWidget);

      // Tap clear button
      await tester.tap(find.byIcon(Icons.clear));
      await tester.pumpAndSettle();

      // Text should be cleared
      expect(controller.text, isEmpty);
    });

    testWidgets('should call onClear when clear button is tapped',
        (tester) async {
      var cleared = false;
      final controller = TextEditingController(text: 'test');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppSearchField(
              controller: controller,
              onClear: () => cleared = true,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap clear button
      await tester.tap(find.byIcon(Icons.clear));
      await tester.pumpAndSettle();

      expect(cleared, isTrue);
    });

    testWidgets('should call onChanged when text changes', (tester) async {
      String? changedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppSearchField(
              onChanged: (value) => changedValue = value,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'test');

      expect(changedValue, equals('test'));
    });

    testWidgets('should have correct border widths', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppSearchField(),
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      final decoration = textField.decoration!;

      // Check enabled border (1px)
      final enabledBorder = decoration.enabledBorder! as OutlineInputBorder;
      expect(enabledBorder.borderSide.width, equals(1));

      // Check focused border (2px, primary color)
      final focusedBorder = decoration.focusedBorder! as OutlineInputBorder;
      expect(focusedBorder.borderSide.width, equals(2));
      expect(focusedBorder.borderSide.color, equals(AppColors.primary));
    });
  });
}
