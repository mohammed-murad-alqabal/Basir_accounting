import 'package:basser_app/core/theme/app_colors.dart';
import 'package:basser_app/core/widgets/app_enhanced_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppEnhancedButton Widget Tests', () {
    testWidgets('should render primary button with text', (tester) async {
      // Arrange
      const buttonText = 'تسجيل الدخول';
      var pressed = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppEnhancedButton(
              text: buttonText,
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(buttonText), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);

      // Test onPressed
      await tester.tap(find.byType(AppEnhancedButton));
      expect(pressed, isTrue);
    });

    testWidgets('should render secondary button with correct style',
        (tester) async {
      // Arrange
      const buttonText = 'إلغاء';

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppEnhancedButton(
              text: buttonText,
              onPressed: () {},
              type: AppEnhancedButtonType.secondary,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(buttonText), findsOneWidget);

      final button = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );
      expect(button.style?.backgroundColor?.resolve({}), AppColors.secondary);
    });

    testWidgets('should render text button with correct style', (tester) async {
      // Arrange
      const buttonText = 'تخطي';

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppEnhancedButton(
              text: buttonText,
              onPressed: () {},
              type: AppEnhancedButtonType.text,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(buttonText), findsOneWidget);

      final button = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );
      expect(
        button.style?.backgroundColor?.resolve({}),
        Colors.transparent,
      );
    });

    testWidgets('should render button with icon', (tester) async {
      // Arrange
      const buttonText = 'إضافة';
      const iconData = Icons.add;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppEnhancedButton(
              text: buttonText,
              onPressed: () {},
              icon: iconData,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(buttonText), findsOneWidget);
      expect(find.byIcon(iconData), findsOneWidget);
      expect(find.byType(Row), findsOneWidget);
    });

    testWidgets('should show loading indicator when isLoading is true',
        (tester) async {
      // Arrange
      const buttonText = 'تحميل';

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppEnhancedButton(
              text: buttonText,
              onPressed: () {},
              isLoading: true,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text(buttonText), findsNothing);
    });

    testWidgets('should disable button when onPressed is null', (tester) async {
      // Arrange
      const buttonText = 'معطل';

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppEnhancedButton(
              text: buttonText,
              onPressed: null,
            ),
          ),
        ),
      );

      // Assert
      final button = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );
      expect(button.onPressed, isNull);
    });

    testWidgets('should disable button when isLoading is true', (tester) async {
      // Arrange
      const buttonText = 'تحميل';
      var pressed = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppEnhancedButton(
              text: buttonText,
              onPressed: () => pressed = true,
              isLoading: true,
            ),
          ),
        ),
      );

      // Assert
      final button = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );
      expect(button.onPressed, isNull);

      // Try to tap (should not work)
      await tester.tap(find.byType(AppEnhancedButton));
      expect(pressed, isFalse);
    });

    testWidgets('should handle long text without overflow', (tester) async {
      // Arrange
      const longText = 'هذا نص طويل جداً جداً جداً يجب أن يظهر بالكامل بدون قص';

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 200, // عرض محدود
              child: AppEnhancedButton(
                text: longText,
                onPressed: () {},
              ),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(longText), findsOneWidget);
      expect(tester.takeException(), isNull); // لا يوجد overflow exception
    });

    testWidgets('should adapt to textScaleFactor', (tester) async {
      // Arrange
      const buttonText = 'اختبار';

      // Act - textScaleFactor = 1.0
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.noScaling),
            child: Scaffold(
              body: AppEnhancedButton(
                text: buttonText,
                onPressed: () {},
              ),
            ),
          ),
        ),
      );

      final size1 = tester.getSize(find.byType(AppEnhancedButton));

      // Act - textScaleFactor = 2.0
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(2)),
            child: Scaffold(
              body: AppEnhancedButton(
                text: buttonText,
                onPressed: () {},
              ),
            ),
          ),
        ),
      );

      final size2 = tester.getSize(find.byType(AppEnhancedButton));

      // Assert - الزر يجب أن يكون أكبر مع textScaleFactor أكبر
      expect(size2.height, greaterThan(size1.height));
    });

    testWidgets('should use custom width when provided', (tester) async {
      // Arrange
      const buttonText = 'عرض مخصص';
      const customWidth = 300.0;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppEnhancedButton(
              text: buttonText,
              onPressed: () {},
              width: customWidth,
            ),
          ),
        ),
      );

      // Assert
      final size = tester.getSize(find.byType(AppEnhancedButton));
      expect(size.width, customWidth);
    });

    testWidgets('should use custom minHeight when provided', (tester) async {
      // Arrange
      const buttonText = 'ارتفاع مخصص';
      const customMinHeight = 60.0;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppEnhancedButton(
              text: buttonText,
              onPressed: () {},
              minHeight: customMinHeight,
            ),
          ),
        ),
      );

      // Assert
      final size = tester.getSize(find.byType(AppEnhancedButton));
      expect(size.height, greaterThanOrEqualTo(customMinHeight));
    });

    testWidgets('should handle RTL text direction correctly', (tester) async {
      // Arrange
      const buttonText = 'نص عربي';

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppEnhancedButton(
              text: buttonText,
              onPressed: () {},
            ),
          ),
        ),
      );

      // Assert
      final textWidget = tester.widget<Text>(find.text(buttonText));
      expect(textWidget.textDirection, TextDirection.rtl);
      expect(textWidget.textAlign, TextAlign.center);
    });

    testWidgets('should use correct font family with fallback', (tester) async {
      // Arrange
      const buttonText = 'خط Cairo';

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppEnhancedButton(
              text: buttonText,
              onPressed: () {},
            ),
          ),
        ),
      );

      // Assert
      final textWidget = tester.widget<Text>(find.text(buttonText));
      expect(textWidget.style?.fontFamily, 'Cairo');
      expect(
        textWidget.style?.fontFamilyFallback,
        containsAll(['Roboto', 'Arial']),
      );
    });

    testWidgets('should have correct text overflow settings', (tester) async {
      // Arrange
      const buttonText = 'نص طويل';

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppEnhancedButton(
              text: buttonText,
              onPressed: () {},
            ),
          ),
        ),
      );

      // Assert
      final textWidget = tester.widget<Text>(find.text(buttonText));
      expect(textWidget.softWrap, isTrue);
      expect(textWidget.overflow, TextOverflow.visible);
      expect(textWidget.maxLines, isNull);
    });

    testWidgets('should have correct font weight', (tester) async {
      // Arrange
      const buttonText = 'وزن الخط';

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppEnhancedButton(
              text: buttonText,
              onPressed: () {},
            ),
          ),
        ),
      );

      // Assert
      final textWidget = tester.widget<Text>(find.text(buttonText));
      expect(textWidget.style?.fontWeight, FontWeight.w600);
    });

    testWidgets('should use Flexible for text when icon is present',
        (tester) async {
      // Arrange
      const buttonText = 'نص مع أيقونة';
      const iconData = Icons.check;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppEnhancedButton(
              text: buttonText,
              onPressed: () {},
              icon: iconData,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(Flexible), findsOneWidget);
      expect(find.byType(Row), findsOneWidget);

      // التحقق من أن النص داخل Flexible
      final flexible = tester.widget<Flexible>(find.byType(Flexible));
      expect(flexible.child, isA<Text>());
    });

    testWidgets('should have correct icon size and spacing', (tester) async {
      // Arrange
      const buttonText = 'أيقونة';
      const iconData = Icons.star;
      const customIconSize = 24.0;
      const customIconSpacing = 12.0;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppEnhancedButton(
              text: buttonText,
              onPressed: () {},
              icon: iconData,
              iconSize: customIconSize,
              iconSpacing: customIconSpacing,
            ),
          ),
        ),
      );

      // Assert
      final iconWidget = tester.widget<Icon>(find.byIcon(iconData));
      expect(iconWidget.size, customIconSize);

      // التحقق من المسافة بين الأيقونة والنص
      final row = tester.widget<Row>(find.byType(Row));
      final sizedBox = row.children[1] as SizedBox;
      expect(sizedBox.width, customIconSpacing);
    });
  });
}
