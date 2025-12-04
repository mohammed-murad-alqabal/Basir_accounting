/// اختبارات AppCard Widgets
///
/// يختبر جميع أنواع البطاقات في التطبيق
library;

import 'package:basser_app/core/theme.dart';
import 'package:basser_app/core/widgets/app_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppCard', () {
    testWidgets('should display child widget', (tester) async {
      // Arrange
      const childText = 'محتوى البطاقة';

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppCard(
              child: Text(childText),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(childText), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('should call onTap when tapped', (tester) async {
      // Arrange
      var tapped = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppCard(
              onTap: () => tapped = true,
              child: const Text('اضغط هنا'),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(AppCard));
      await tester.pump();

      // Assert
      expect(tapped, isTrue);
    });

    testWidgets('should not call onTap when onTap is null', (tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppCard(
              child: Text('بطاقة'),
            ),
          ),
        ),
      );

      // Should not throw
      await tester.tap(find.byType(AppCard));
      await tester.pump();

      // Assert - no exception thrown
      expect(find.byType(AppCard), findsOneWidget);
    });

    testWidgets('should use default padding', (tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppCard(
              child: Text('محتوى'),
            ),
          ),
        ),
      );

      // Assert
      final paddings = tester.widgetList<Padding>(
        find.descendant(
          of: find.byType(Card),
          matching: find.byType(Padding),
        ),
      );
      // Find the padding that wraps the child
      final padding = paddings.firstWhere(
        (p) => p.padding == const EdgeInsets.all(AppSpacing.md),
      );
      expect(padding.padding, const EdgeInsets.all(AppSpacing.md));
    });

    testWidgets('should respect custom padding', (tester) async {
      // Arrange
      const customPadding = EdgeInsets.all(20);

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppCard(
              padding: customPadding,
              child: Text('محتوى'),
            ),
          ),
        ),
      );

      // Assert
      final paddings = tester.widgetList<Padding>(
        find.descendant(
          of: find.byType(Card),
          matching: find.byType(Padding),
        ),
      );
      // Find the padding that wraps the child
      final padding = paddings.firstWhere(
        (p) => p.padding == customPadding,
      );
      expect(padding.padding, customPadding);
    });

    testWidgets('should use default background color', (tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppCard(
              child: Text('محتوى'),
            ),
          ),
        ),
      );

      // Assert
      final card = tester.widget<Card>(find.byType(Card));
      expect(card.color, AppColors.surface);
    });

    testWidgets('should respect custom background color', (tester) async {
      // Arrange
      const customColor = Colors.blue;

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppCard(
              backgroundColor: customColor,
              child: Text('محتوى'),
            ),
          ),
        ),
      );

      // Assert
      final card = tester.widget<Card>(find.byType(Card));
      expect(card.color, customColor);
    });

    testWidgets('should use default elevation', (tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppCard(
              child: Text('محتوى'),
            ),
          ),
        ),
      );

      // Assert
      final card = tester.widget<Card>(find.byType(Card));
      expect(card.elevation, 0);
    });

    testWidgets('should respect custom elevation', (tester) async {
      // Arrange
      const customElevation = 4.0;

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppCard(
              elevation: customElevation,
              child: Text('محتوى'),
            ),
          ),
        ),
      );

      // Assert
      final card = tester.widget<Card>(find.byType(Card));
      expect(card.elevation, customElevation);
    });
  });

  group('AppListCard', () {
    testWidgets('should display title', (tester) async {
      // Arrange
      const title = 'أحمد محمد';

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppListCard(title: title),
          ),
        ),
      );

      // Assert
      expect(find.text(title), findsOneWidget);
    });

    testWidgets('should display subtitle when provided', (tester) async {
      // Arrange
      const title = 'أحمد محمد';
      const subtitle = '0501234567';

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppListCard(
              title: title,
              subtitle: subtitle,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(title), findsOneWidget);
      expect(find.text(subtitle), findsOneWidget);
    });

    testWidgets('should not display subtitle when null', (tester) async {
      // Arrange
      const title = 'أحمد محمد';

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppListCard(title: title),
          ),
        ),
      );

      // Assert
      expect(find.text(title), findsOneWidget);
      // Only one Text widget (title)
      expect(
        find.descendant(
          of: find.byType(AppListCard),
          matching: find.byType(Text),
        ),
        findsOneWidget,
      );
    });

    testWidgets('should display trailing when provided', (tester) async {
      // Arrange
      const title = 'أحمد محمد';
      const trailing = '5 فواتير';

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppListCard(
              title: title,
              trailing: trailing,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(title), findsOneWidget);
      expect(find.text(trailing), findsOneWidget);
    });

    testWidgets('should display leading widget when provided', (tester) async {
      // Arrange
      const title = 'أحمد محمد';
      const leadingIcon = Icon(Icons.person);

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppListCard(
              title: title,
              leading: leadingIcon,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(title), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('should call onTap when tapped', (tester) async {
      // Arrange
      var tapped = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppListCard(
              title: 'عنوان',
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(AppListCard));
      await tester.pump();

      // Assert
      expect(tapped, isTrue);
    });

    testWidgets('should call onLongPress when long pressed', (tester) async {
      // Arrange
      var longPressed = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppListCard(
              title: 'عنوان',
              onLongPress: () => longPressed = true,
            ),
          ),
        ),
      );

      await tester.longPress(find.byType(AppListCard));
      await tester.pump();

      // Assert
      expect(longPressed, isTrue);
    });

    testWidgets('should display all components together', (tester) async {
      // Arrange
      const title = 'أحمد محمد';
      const subtitle = '0501234567';
      const trailing = '5 فواتير';
      const leadingIcon = Icon(Icons.person);

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppListCard(
              title: title,
              subtitle: subtitle,
              trailing: trailing,
              leading: leadingIcon,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(title), findsOneWidget);
      expect(find.text(subtitle), findsOneWidget);
      expect(find.text(trailing), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
    });
  });

  group('AppStatCard', () {
    testWidgets('should display label and value', (tester) async {
      // Arrange
      const label = 'إجمالي الفواتير';
      const value = '150';

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppStatCard(
              label: label,
              value: value,
              icon: Icons.receipt,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(label), findsOneWidget);
      expect(find.text(value), findsOneWidget);
    });

    testWidgets('should display icon', (tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppStatCard(
              label: 'الفواتير',
              value: '100',
              icon: Icons.receipt,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.receipt), findsOneWidget);
    });

    testWidgets('should use default icon color', (tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppStatCard(
              label: 'الفواتير',
              value: '100',
              icon: Icons.receipt,
            ),
          ),
        ),
      );

      // Assert
      final icon = tester.widget<Icon>(find.byIcon(Icons.receipt));
      expect(icon.color, AppColors.primary);
    });

    testWidgets('should respect custom icon color', (tester) async {
      // Arrange
      const customColor = Colors.green;

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppStatCard(
              label: 'الفواتير',
              value: '100',
              icon: Icons.receipt,
              iconColor: customColor,
            ),
          ),
        ),
      );

      // Assert
      final icon = tester.widget<Icon>(find.byIcon(Icons.receipt));
      expect(icon.color, customColor);
    });

    testWidgets('should use default background color', (tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppStatCard(
              label: 'الفواتير',
              value: '100',
              icon: Icons.receipt,
            ),
          ),
        ),
      );

      // Assert
      final card = tester.widget<Card>(
        find.descendant(
          of: find.byType(AppStatCard),
          matching: find.byType(Card),
        ),
      );
      expect(card.color, AppColors.surface);
    });

    testWidgets('should respect custom background color', (tester) async {
      // Arrange
      const customColor = Colors.lightBlue;

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppStatCard(
              label: 'الفواتير',
              value: '100',
              icon: Icons.receipt,
              backgroundColor: customColor,
            ),
          ),
        ),
      );

      // Assert
      final card = tester.widget<Card>(
        find.descendant(
          of: find.byType(AppStatCard),
          matching: find.byType(Card),
        ),
      );
      expect(card.color, customColor);
    });

    testWidgets('should display large value text', (tester) async {
      // Arrange
      const value = '1,234';

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppStatCard(
              label: 'المبلغ',
              value: value,
              icon: Icons.attach_money,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(value), findsOneWidget);
      final valueText = tester.widget<Text>(
        find.text(value),
      );
      expect(valueText.style?.fontSize, 20);
      expect(valueText.style?.fontWeight, FontWeight.bold);
    });
  });

  group('Card Interactions', () {
    testWidgets('should handle multiple cards together', (tester) async {
      // Arrange
      var card1Tapped = false;
      var card2Tapped = false;
      var card3LongPressed = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                AppCard(
                  onTap: () => card1Tapped = true,
                  child: const Text('بطاقة 1'),
                ),
                AppListCard(
                  title: 'بطاقة 2',
                  onTap: () => card2Tapped = true,
                  onLongPress: () => card3LongPressed = true,
                ),
                const AppStatCard(
                  label: 'إحصائية',
                  value: '100',
                  icon: Icons.star,
                ),
              ],
            ),
          ),
        ),
      );

      // Tap cards
      await tester.tap(find.byType(AppCard));
      await tester.pump();
      await tester.tap(find.byType(AppListCard));
      await tester.pump();
      await tester.longPress(find.byType(AppListCard));
      await tester.pump();

      // Assert
      expect(card1Tapped, isTrue);
      expect(card2Tapped, isTrue);
      expect(card3LongPressed, isTrue);
      expect(find.byType(AppStatCard), findsOneWidget);
    });
  });
}
