/// اختبارات AppTextField Widgets
///
/// يختبر جميع حقول الإدخال في التطبيق
library;

import 'package:basser_app/core/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppTextField', () {
    testWidgets('should display label', (tester) async {
      // Arrange
      const label = 'البريد الإلكتروني';

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppTextField(label: label),
          ),
        ),
      );

      // Assert
      expect(find.text(label), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('should accept text input', (tester) async {
      // Arrange
      final controller = TextEditingController();

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppTextField(
              label: 'الاسم',
              controller: controller,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'أحمد محمد');
      await tester.pump();

      // Assert
      expect(controller.text, 'أحمد محمد');
      expect(find.text('أحمد محمد'), findsOneWidget);
    });

    testWidgets('should call validator when validating', (tester) async {
      // Arrange
      var validatorCalled = false;
      String? validator(String? value) {
        validatorCalled = true;
        return value?.isEmpty ?? true ? 'مطلوب' : null;
      }

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              child: AppTextField(
                label: 'الاسم',
                validator: validator,
              ),
            ),
          ),
        ),
      );

      // Trigger validation
      tester.state<FormState>(find.byType(Form)).validate();
      await tester.pump();

      // Assert
      expect(validatorCalled, isTrue);
    });

    testWidgets('should show error message when validation fails',
        (tester) async {
      // Arrange
      const errorMessage = 'هذا الحقل مطلوب';

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              child: AppTextField(
                label: 'الاسم',
                validator: (value) =>
                    value?.isEmpty ?? true ? errorMessage : null,
              ),
            ),
          ),
        ),
      );

      // Trigger validation
      tester.state<FormState>(find.byType(Form)).validate();
      await tester.pump();

      // Assert
      expect(find.text(errorMessage), findsOneWidget);
    });

    testWidgets('should show visibility toggle for password field',
        (tester) async {
      // Act
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

      // Assert
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });

    testWidgets('should toggle password visibility when icon tapped',
        (tester) async {
      // Act
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

      // Initially shows visibility_off icon
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);

      // Tap visibility icon
      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pump();

      // Now shows visibility icon
      expect(find.byIcon(Icons.visibility), findsOneWidget);

      // Tap again to hide
      await tester.tap(find.byIcon(Icons.visibility));
      await tester.pump();

      // Back to visibility_off
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });

    testWidgets('should display prefix icon when provided', (tester) async {
      // Arrange
      const prefixIcon = Icon(Icons.email);

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppTextField(
              label: 'البريد',
              prefixIcon: prefixIcon,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.email), findsOneWidget);
    });

    testWidgets('should display suffix icon when provided and not password',
        (tester) async {
      // Arrange
      const suffixIcon = Icon(Icons.check);

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppTextField(
              label: 'الاسم',
              suffixIcon: suffixIcon,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('should call onChanged when text changes', (tester) async {
      // Arrange
      String? changedValue;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppTextField(
              label: 'الاسم',
              onChanged: (value) => changedValue = value,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'أحمد');
      await tester.pump();

      // Assert
      expect(changedValue, 'أحمد');
    });
  });

  group('AppSearchField', () {
    testWidgets('should display search icon', (tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppSearchField(),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('should accept text input', (tester) async {
      // Arrange
      final controller = TextEditingController();

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppSearchField(controller: controller),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'أحمد');
      await tester.pump();

      // Assert
      expect(controller.text, 'أحمد');
      expect(find.text('أحمد'), findsOneWidget);
    });

    testWidgets('should call onChanged when text changes', (tester) async {
      // Arrange
      String? changedValue;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppSearchField(
              onChanged: (value) => changedValue = value,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'بحث');
      await tester.pump();

      // Assert
      expect(changedValue, 'بحث');
    });

    testWidgets('should show clear button when text is not empty',
        (tester) async {
      // Arrange
      final controller = TextEditingController(text: 'نص');

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppSearchField(controller: controller),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.clear), findsOneWidget);
    });

    testWidgets('should call onClear when clear button tapped', (tester) async {
      // Arrange
      final controller = TextEditingController(text: 'نص');
      var clearCalled = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppSearchField(
              controller: controller,
              onClear: () => clearCalled = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.clear));
      await tester.pump();

      // Assert
      expect(clearCalled, isTrue);
    });
  });

  group('TextField Interactions', () {
    testWidgets('should handle multiple text fields together', (tester) async {
      // Arrange
      final nameController = TextEditingController();
      final emailController = TextEditingController();
      final searchController = TextEditingController();

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                AppTextField(
                  key: const Key('name'),
                  label: 'الاسم',
                  controller: nameController,
                ),
                AppTextField(
                  key: const Key('email'),
                  label: 'البريد',
                  controller: emailController,
                ),
                AppSearchField(
                  key: const Key('search'),
                  controller: searchController,
                ),
              ],
            ),
          ),
        ),
      );

      // Enter text in each field using keys
      await tester.enterText(
        find.descendant(
          of: find.byKey(const Key('name')),
          matching: find.byType(TextFormField),
        ),
        'أحمد',
      );
      await tester.enterText(
        find.descendant(
          of: find.byKey(const Key('email')),
          matching: find.byType(TextFormField),
        ),
        'ahmed@example.com',
      );
      await tester.enterText(
        find.descendant(
          of: find.byKey(const Key('search')),
          matching: find.byType(TextField),
        ),
        'بحث',
      );
      await tester.pump();

      // Assert
      expect(nameController.text, 'أحمد');
      expect(emailController.text, 'ahmed@example.com');
      expect(searchController.text, 'بحث');
    });

    testWidgets('should handle form validation for multiple fields',
        (tester) async {
      // Arrange
      final formKey = GlobalKey<FormState>();

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: Column(
                children: [
                  AppTextField(
                    label: 'الاسم',
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'الاسم مطلوب' : null,
                  ),
                  AppTextField(
                    label: 'البريد',
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'البريد مطلوب' : null,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Validate form
      final isValid = formKey.currentState!.validate();
      await tester.pump();

      // Assert
      expect(isValid, isFalse);
      expect(find.text('الاسم مطلوب'), findsOneWidget);
      expect(find.text('البريد مطلوب'), findsOneWidget);
    });
  });
}
