/// اختبارات AppButton Widgets
///
/// يختبر جميع أنواع الأزرار في التطبيق
library;

import 'package:basser_app/core/theme.dart';
import 'package:basser_app/core/widgets/app_button.dart';
import 'package:basser_app/core/widgets/responsive_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppPrimaryButton', () {
    testWidgets('should display label text', (tester) async {
      // Arrange
      const label = 'حفظ';

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppPrimaryButton(label: label, onPressed: () {}),
          ),
        ),
      );

      // Assert
      expect(find.text(label), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should call onPressed when tapped', (tester) async {
      // Arrange
      var pressed = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppPrimaryButton(
              label: 'اضغط هنا',
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(AppPrimaryButton));
      await tester.pump();

      // Assert
      expect(pressed, isTrue);
    });

    testWidgets('should be disabled when isLoading is true', (tester) async {
      // Arrange
      var pressed = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppPrimaryButton(
              label: 'حفظ',
              onPressed: () => pressed = true,
              isLoading: true,
            ),
          ),
        ),
      );

      // Try to tap
      await tester.tap(find.byType(AppPrimaryButton));
      await tester.pump();

      // Assert
      expect(pressed, isFalse);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should show CircularProgressIndicator when loading', (
      tester,
    ) async {
      // Act
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

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('حفظ'), findsNothing);
    });

    testWidgets('should respect custom width', (tester) async {
      // Arrange
      const customWidth = 200.0;

      // Act
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

      // Assert
      final sizedBox = tester.widget<SizedBox>(
        find.ancestor(
          of: find.byType(ElevatedButton),
          matching: find.byType(SizedBox),
        ),
      );
      expect(sizedBox.width, customWidth);
    });

    testWidgets('should use default height of 52', (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppPrimaryButton(label: 'حفظ', onPressed: () {}),
          ),
        ),
      );

      // Assert
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final minimumSize = button.style?.minimumSize?.resolve({});
      expect(minimumSize?.height, 52.0);
    });

    testWidgets('should respect custom height', (tester) async {
      // Arrange
      const customHeight = 60.0;

      // Act
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

      // Assert
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final minimumSize = button.style?.minimumSize?.resolve({});
      expect(minimumSize?.height, customHeight);
    });
  });

  group('AppSecondaryButton', () {
    testWidgets('should display label text', (tester) async {
      // Arrange
      const label = 'إلغاء';

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppSecondaryButton(label: label, onPressed: () {}),
          ),
        ),
      );

      // Assert
      expect(find.text(label), findsOneWidget);
      expect(find.byType(OutlinedButton), findsOneWidget);
    });

    testWidgets('should call onPressed when tapped', (tester) async {
      // Arrange
      var pressed = false;

      // Act
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
      await tester.pump();

      // Assert
      expect(pressed, isTrue);
    });

    testWidgets('should be disabled when isLoading is true', (tester) async {
      // Arrange
      var pressed = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppSecondaryButton(
              label: 'إلغاء',
              onPressed: () => pressed = true,
              isLoading: true,
            ),
          ),
        ),
      );

      // Try to tap
      await tester.tap(find.byType(AppSecondaryButton));
      await tester.pump();

      // Assert
      expect(pressed, isFalse);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should show CircularProgressIndicator when loading', (
      tester,
    ) async {
      // Act
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

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('إلغاء'), findsNothing);
    });

    testWidgets('should respect custom dimensions', (tester) async {
      // Arrange
      const customWidth = 150.0;
      const customHeight = 50.0;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppSecondaryButton(
              label: 'إلغاء',
              onPressed: () {},
              width: customWidth,
              height: customHeight,
            ),
          ),
        ),
      );

      // Assert
      final button = tester.widget<OutlinedButton>(find.byType(OutlinedButton));
      final minimumSize = button.style?.minimumSize?.resolve({});
      expect(minimumSize?.width, customWidth);
      expect(minimumSize?.height, customHeight);
    });
  });

  group('AppTextButton', () {
    testWidgets('should display label text', (tester) async {
      // Arrange
      const label = 'نسيت كلمة المرور؟';

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppTextButton(label: label, onPressed: () {}),
          ),
        ),
      );

      // Assert
      expect(find.text(label), findsOneWidget);
      expect(find.byType(TextButton), findsOneWidget);
    });

    testWidgets('should call onPressed when tapped', (tester) async {
      // Arrange
      var pressed = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppTextButton(
              label: 'اضغط هنا',
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(AppTextButton));
      await tester.pump();

      // Assert
      expect(pressed, isTrue);
    });

    testWidgets('should use default primary color', (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppTextButton(label: 'نص', onPressed: () {}),
          ),
        ),
      );

      // Assert
      final textButton = tester.widget<TextButton>(find.byType(TextButton));
      final responsiveText = textButton.child! as ResponsiveText;
      expect(responsiveText.style?.color, AppColors.primary);
    });

    testWidgets('should respect custom color', (tester) async {
      // Arrange
      const customColor = Colors.red;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppTextButton(
              label: 'نص',
              onPressed: () {},
              color: customColor,
            ),
          ),
        ),
      );

      // Assert
      final textButton = tester.widget<TextButton>(find.byType(TextButton));
      final responsiveText = textButton.child! as ResponsiveText;
      expect(responsiveText.style?.color, customColor);
    });

    testWidgets('should use default font size', (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppTextButton(label: 'نص', onPressed: () {}),
          ),
        ),
      );

      // Assert
      final textButton = tester.widget<TextButton>(find.byType(TextButton));
      final responsiveText = textButton.child! as ResponsiveText;
      expect(responsiveText.style?.fontSize, AppTypography.bodyLarge);
    });

    testWidgets('should respect custom font size', (tester) async {
      // Arrange
      const customFontSize = 20.0;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppTextButton(
              label: 'نص',
              onPressed: () {},
              fontSize: customFontSize,
            ),
          ),
        ),
      );

      // Assert
      final textButton = tester.widget<TextButton>(find.byType(TextButton));
      final responsiveText = textButton.child! as ResponsiveText;
      expect(responsiveText.style?.fontSize, customFontSize);
    });

    testWidgets('should have medium font weight', (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppTextButton(label: 'نص', onPressed: () {}),
          ),
        ),
      );

      // Assert
      final textButton = tester.widget<TextButton>(find.byType(TextButton));
      final responsiveText = textButton.child! as ResponsiveText;
      expect(responsiveText.style?.fontWeight, FontWeight.w600);
    });
  });

  group('Button Interactions', () {
    testWidgets('should handle multiple button types together', (tester) async {
      // Arrange
      var primaryPressed = false;
      var secondaryPressed = false;
      var textPressed = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                AppPrimaryButton(
                  label: 'حفظ',
                  onPressed: () => primaryPressed = true,
                ),
                AppSecondaryButton(
                  label: 'إلغاء',
                  onPressed: () => secondaryPressed = true,
                ),
                AppTextButton(
                  label: 'تخطي',
                  onPressed: () => textPressed = true,
                ),
              ],
            ),
          ),
        ),
      );

      // Tap each button
      await tester.tap(find.byType(AppPrimaryButton));
      await tester.pump();
      await tester.tap(find.byType(AppSecondaryButton));
      await tester.pump();
      await tester.tap(find.byType(AppTextButton));
      await tester.pump();

      // Assert
      expect(primaryPressed, isTrue);
      expect(secondaryPressed, isTrue);
      expect(textPressed, isTrue);
    });

    testWidgets('should handle rapid taps correctly', (tester) async {
      // Arrange
      var tapCount = 0;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppPrimaryButton(label: 'اضغط', onPressed: () => tapCount++),
          ),
        ),
      );

      // Tap multiple times
      await tester.tap(find.byType(AppPrimaryButton));
      await tester.pump();
      await tester.tap(find.byType(AppPrimaryButton));
      await tester.pump();
      await tester.tap(find.byType(AppPrimaryButton));
      await tester.pump();

      // Assert
      expect(tapCount, 3);
    });
  });
}
