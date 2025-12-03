import 'package:basser_app/core/theme/app_colors.dart';
import 'package:basser_app/core/theme/app_dimensions.dart';
import 'package:basser_app/core/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppPrimaryButton', () {
    testWidgets('should display label correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppPrimaryButton(
              label: 'حفظ',
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('حفظ'), findsOneWidget);
    });

    testWidgets('should call onPressed when tapped', (tester) async {
      var pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppPrimaryButton(
              label: 'حفظ',
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(AppPrimaryButton));
      await tester.pumpAndSettle();

      expect(pressed, isTrue);
    });

    testWidgets('should be disabled when onPressed is null', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppPrimaryButton(
              label: 'حفظ',
              onPressed: null,
            ),
          ),
        ),
      );

      final button = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );

      expect(button.onPressed, isNull);
    });

    testWidgets('should show loading indicator when isLoading is true',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppPrimaryButton(
              label: 'حفظ',
              onPressed: () {},
              isLoading: true,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('حفظ'), findsNothing);
    });

    testWidgets('should be disabled when isLoading is true', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppPrimaryButton(
              label: 'حفظ',
              onPressed: () {},
              isLoading: true,
            ),
          ),
        ),
      );

      final button = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );

      expect(button.onPressed, isNull);
    });

    testWidgets('should display icon when provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppPrimaryButton(
              label: 'حفظ',
              onPressed: () {},
              icon: Icons.save,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.save), findsOneWidget);
      expect(find.text('حفظ'), findsOneWidget);
    });

    testWidgets('should have minimum touch target size', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppPrimaryButton(
              label: 'حفظ',
              onPressed: () {},
            ),
          ),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(
        find.ancestor(
          of: find.byType(ElevatedButton),
          matching: find.byType(SizedBox),
        ),
      );

      expect(sizedBox.height, equals(AppDimensions.buttonHeightLg));
    });

    testWidgets('should use custom width when provided', (tester) async {
      const customWidth = 200.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppPrimaryButton(
              label: 'حفظ',
              onPressed: () {},
              width: customWidth,
            ),
          ),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(
        find.ancestor(
          of: find.byType(ElevatedButton),
          matching: find.byType(SizedBox),
        ),
      );

      expect(sizedBox.width, equals(customWidth));
    });

    testWidgets('should use custom height when provided', (tester) async {
      const customHeight = 56.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppPrimaryButton(
              label: 'حفظ',
              onPressed: () {},
              height: customHeight,
            ),
          ),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(
        find.ancestor(
          of: find.byType(ElevatedButton),
          matching: find.byType(SizedBox),
        ),
      );

      expect(sizedBox.height, equals(customHeight));
    });

    testWidgets('should have correct colors', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppPrimaryButton(
              label: 'حفظ',
              onPressed: () {},
            ),
          ),
        ),
      );

      final button = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );

      final style = button.style!;
      expect(
        style.backgroundColor?.resolve({}),
        equals(AppColors.primary),
      );
      expect(
        style.foregroundColor?.resolve({}),
        equals(AppColors.onPrimary),
      );
    });

    testWidgets('should have correct disabled colors', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppPrimaryButton(
              label: 'حفظ',
              onPressed: null,
            ),
          ),
        ),
      );

      final button = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );

      final style = button.style!;
      expect(
        style.backgroundColor?.resolve({WidgetState.disabled}),
        equals(AppColors.surface),
      );
      expect(
        style.foregroundColor?.resolve({WidgetState.disabled}),
        equals(AppColors.textDisabled),
      );
    });
  });

  group('AppSecondaryButton', () {
    testWidgets('should display label correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppSecondaryButton(
              label: 'إلغاء',
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('إلغاء'), findsOneWidget);
    });

    testWidgets('should call onPressed when tapped', (tester) async {
      var pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppSecondaryButton(
              label: 'إلغاء',
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(AppSecondaryButton));
      await tester.pumpAndSettle();

      expect(pressed, isTrue);
    });

    testWidgets('should be disabled when onPressed is null', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppSecondaryButton(
              label: 'إلغاء',
              onPressed: null,
            ),
          ),
        ),
      );

      final button = tester.widget<OutlinedButton>(
        find.byType(OutlinedButton),
      );

      expect(button.onPressed, isNull);
    });

    testWidgets('should show loading indicator when isLoading is true',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppSecondaryButton(
              label: 'إلغاء',
              onPressed: () {},
              isLoading: true,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('إلغاء'), findsNothing);
    });

    testWidgets('should display icon when provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppSecondaryButton(
              label: 'إلغاء',
              onPressed: () {},
              icon: Icons.close,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.close), findsOneWidget);
      expect(find.text('إلغاء'), findsOneWidget);
    });

    testWidgets('should have correct border', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppSecondaryButton(
              label: 'إلغاء',
              onPressed: () {},
            ),
          ),
        ),
      );

      final button = tester.widget<OutlinedButton>(
        find.byType(OutlinedButton),
      );

      final style = button.style!;
      final side = style.side?.resolve({});

      expect(side?.color, equals(AppColors.primary));
      expect(side?.width, equals(1.5));
    });

    testWidgets('should have correct disabled border', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppSecondaryButton(
              label: 'إلغاء',
              onPressed: null,
            ),
          ),
        ),
      );

      final button = tester.widget<OutlinedButton>(
        find.byType(OutlinedButton),
      );

      final style = button.style!;
      final side = style.side?.resolve({WidgetState.disabled});

      expect(side?.color, equals(AppColors.textDisabled));
    });
  });

  group('AppTextButton', () {
    testWidgets('should display label correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppTextButton(
              label: 'نسيت كلمة المرور؟',
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('نسيت كلمة المرور؟'), findsOneWidget);
    });

    testWidgets('should call onPressed when tapped', (tester) async {
      var pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppTextButton(
              label: 'نسيت كلمة المرور؟',
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(AppTextButton));
      await tester.pumpAndSettle();

      expect(pressed, isTrue);
    });

    testWidgets('should be disabled when onPressed is null', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppTextButton(
              label: 'نسيت كلمة المرور؟',
              onPressed: null,
            ),
          ),
        ),
      );

      final button = tester.widget<TextButton>(
        find.byType(TextButton),
      );

      expect(button.onPressed, isNull);
    });

    testWidgets('should display icon when provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppTextButton(
              label: 'نسيت كلمة المرور؟',
              onPressed: () {},
              icon: Icons.help,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.help), findsOneWidget);
      expect(find.text('نسيت كلمة المرور؟'), findsOneWidget);
    });

    testWidgets('should use custom color when provided', (tester) async {
      const customColor = Colors.red;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppTextButton(
              label: 'نسيت كلمة المرور؟',
              onPressed: () {},
              color: customColor,
            ),
          ),
        ),
      );

      final button = tester.widget<TextButton>(
        find.byType(TextButton),
      );

      final style = button.style!;
      expect(
        style.foregroundColor?.resolve({}),
        equals(customColor),
      );
    });

    testWidgets('should use default color when not provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppTextButton(
              label: 'نسيت كلمة المرور؟',
              onPressed: () {},
            ),
          ),
        ),
      );

      final button = tester.widget<TextButton>(
        find.byType(TextButton),
      );

      final style = button.style!;
      expect(
        style.foregroundColor?.resolve({}),
        equals(AppColors.primary),
      );
    });
  });
}
