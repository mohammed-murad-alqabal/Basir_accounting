/// اختبارات AppTextField
library;

import 'package:basir_app/core/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppTextField', () {
    testWidgets('should display label', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AppTextField(label: 'اسم المستخدم')),
        ),
      );

      expect(find.text('اسم المستخدم'), findsOneWidget);
    });

    testWidgets('should display hint', (tester) async {
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

    testWidgets('should show/hide password', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppTextField(label: 'كلمة المرور', obscureText: true),
          ),
        ),
      );

      // يجب أن يكون النص مخفياً في البداية
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.obscureText, true);

      // النقر على أيقونة الإظهار/الإخفاء
      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pumpAndSettle();

      // يجب أن يكون النص ظاهراً الآن
      final textFieldAfter = tester.widget<TextField>(find.byType(TextField));
      expect(textFieldAfter.obscureText, false);
    });

    testWidgets('should call onChanged', (tester) async {
      String? changedValue;

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

      await tester.enterText(find.byType(TextField), 'أحمد');
      expect(changedValue, 'أحمد');
    });

    testWidgets('should validate input', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              child: AppTextField(
                label: 'البريد الإلكتروني',
                validator: (value) => value?.isEmpty ?? true ? 'مطلوب' : null,
              ),
            ),
          ),
        ),
      );

      // التحقق من الصحة بدون إدخال
      final formState = tester.state<FormState>(find.byType(Form));
      expect(formState.validate(), false);
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

    testWidgets('should display suffix icon', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppTextField(label: 'البحث', suffixIcon: Icon(Icons.search)),
          ),
        ),
      );

      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('should support multiline', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AppTextField(label: 'الملاحظات', maxLines: 3)),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.maxLines, 3);
    });
  });

  group('AppSearchField', () {
    testWidgets('should display search icon', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: AppSearchField())),
      );

      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('should display hint', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AppSearchField(hint: 'ابحث عن عميل...')),
        ),
      );

      expect(find.text('ابحث عن عميل...'), findsOneWidget);
    });

    testWidgets('should call onChanged', (tester) async {
      String? changedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppSearchField(onChanged: (value) => changedValue = value),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'أحمد');
      expect(changedValue, 'أحمد');
    });

    testWidgets('should show clear button when text is not empty', (
      tester,
    ) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: AppSearchField(controller: controller)),
        ),
      );

      // لا يوجد زر مسح في البداية
      expect(find.byIcon(Icons.clear), findsNothing);

      // إدخال نص عبر TextField
      await tester.enterText(find.byType(TextField), 'أحمد');
      await tester.pumpAndSettle();

      // يجب أن يظهر زر المسح
      expect(find.byIcon(Icons.clear), findsOneWidget);
    });

    testWidgets('should call onClear', (tester) async {
      final controller = TextEditingController(text: 'أحمد');
      var cleared = false;

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

      await tester.tap(find.byIcon(Icons.clear));
      expect(cleared, true);
    });
  });
}
