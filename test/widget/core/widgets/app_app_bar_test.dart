/// اختبارات AppAppBar Widgets
///
/// يختبر جميع أشرطة التطبيق في التطبيق
library;

import 'package:basser_app/core/theme.dart';
import 'package:basser_app/core/widgets/app_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppAppBar', () {
    testWidgets('should display title', (tester) async {
      // Arrange
      const title = 'العملاء';

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            appBar: AppAppBar(title: title),
          ),
        ),
      );

      // Assert
      expect(find.text(title), findsOneWidget);
    });

    testWidgets('should show back button by default', (tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            appBar: AppAppBar(title: 'العنوان'),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('should hide back button when showBackButton is false',
        (tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            appBar: AppAppBar(
              title: 'العنوان',
              showBackButton: false,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.arrow_back), findsNothing);
    });

    testWidgets('should call Navigator.pop when back button pressed',
        (tester) async {
      // Arrange
      var popped = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => Scaffold(
                        appBar: AppAppBar(
                          title: 'الصفحة الثانية',
                          onBackPressed: () {
                            popped = true;
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                  );
                },
                child: const Text('اذهب'),
              ),
            ),
          ),
        ),
      );

      // Navigate to second page
      await tester.tap(find.text('اذهب'));
      await tester.pumpAndSettle();

      // Tap back button
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Assert
      expect(popped, isTrue);
    });

    testWidgets('should display actions when provided', (tester) async {
      // Arrange
      const actionIcon = Icons.add;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppAppBar(
              title: 'العنوان',
              actions: [
                IconButton(
                  icon: const Icon(actionIcon),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(actionIcon), findsOneWidget);
    });

    testWidgets('should display multiple actions', (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppAppBar(
              title: 'العنوان',
              actions: [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.more_vert), findsOneWidget);
    });

    testWidgets('should call action onPressed when tapped', (tester) async {
      // Arrange
      var actionPressed = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppAppBar(
              title: 'العنوان',
              actions: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => actionPressed = true,
                ),
              ],
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      // Assert
      expect(actionPressed, isTrue);
    });

    testWidgets('should use default background color', (tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            appBar: AppAppBar(title: 'العنوان'),
          ),
        ),
      );

      // Assert
      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.backgroundColor, AppColors.surface);
    });

    testWidgets('should respect custom background color', (tester) async {
      // Arrange
      const customColor = Colors.blue;

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            appBar: AppAppBar(
              title: 'العنوان',
              backgroundColor: customColor,
            ),
          ),
        ),
      );

      // Assert
      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.backgroundColor, customColor);
    });

    testWidgets('should use default foreground color', (tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            appBar: AppAppBar(title: 'العنوان'),
          ),
        ),
      );

      // Assert
      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.foregroundColor, AppColors.textPrimary);
    });

    testWidgets('should have zero elevation', (tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            appBar: AppAppBar(title: 'العنوان'),
          ),
        ),
      );

      // Assert
      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.elevation, 0);
    });

    testWidgets('should center title', (tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            appBar: AppAppBar(title: 'العنوان'),
          ),
        ),
      );

      // Assert
      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.centerTitle, isTrue);
    });
  });

  group('AppSimpleAppBar', () {
    testWidgets('should display title', (tester) async {
      // Arrange
      const title = 'لوحة التحكم';

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            appBar: AppSimpleAppBar(title: title),
          ),
        ),
      );

      // Assert
      expect(find.text(title), findsOneWidget);
    });

    testWidgets('should not show back button', (tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            appBar: AppSimpleAppBar(title: 'العنوان'),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.arrow_back), findsNothing);
    });

    testWidgets('should display actions when provided', (tester) async {
      // Arrange
      const actionIcon = Icons.settings;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppSimpleAppBar(
              title: 'العنوان',
              actions: [
                IconButton(
                  icon: const Icon(actionIcon),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(actionIcon), findsOneWidget);
    });

    testWidgets('should display multiple actions', (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppSimpleAppBar(
              title: 'العنوان',
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.notifications), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('should call action onPressed when tapped', (tester) async {
      // Arrange
      var actionPressed = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppSimpleAppBar(
              title: 'العنوان',
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () => actionPressed = true,
                ),
              ],
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.settings));
      await tester.pump();

      // Assert
      expect(actionPressed, isTrue);
    });

    testWidgets('should use default background color', (tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            appBar: AppSimpleAppBar(title: 'العنوان'),
          ),
        ),
      );

      // Assert
      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.backgroundColor, AppColors.surface);
    });

    testWidgets('should respect custom background color', (tester) async {
      // Arrange
      const customColor = Colors.green;

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            appBar: AppSimpleAppBar(
              title: 'العنوان',
              backgroundColor: customColor,
            ),
          ),
        ),
      );

      // Assert
      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.backgroundColor, customColor);
    });

    testWidgets('should have zero elevation', (tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            appBar: AppSimpleAppBar(title: 'العنوان'),
          ),
        ),
      );

      // Assert
      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.elevation, 0);
    });

    testWidgets('should center title', (tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            appBar: AppSimpleAppBar(title: 'العنوان'),
          ),
        ),
      );

      // Assert
      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.centerTitle, isTrue);
    });

    testWidgets('should not automatically imply leading', (tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            appBar: AppSimpleAppBar(title: 'العنوان'),
          ),
        ),
      );

      // Assert
      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.automaticallyImplyLeading, isFalse);
    });
  });

  group('AppBar Interactions', () {
    testWidgets('should handle both AppBar types together', (tester) async {
      // Arrange
      var action1Pressed = false;
      var action2Pressed = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              appBar: AppSimpleAppBar(
                title: 'الرئيسية',
                actions: [
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => action1Pressed = true,
                  ),
                ],
              ),
              body: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => Scaffold(
                        appBar: AppAppBar(
                          title: 'الصفحة الثانية',
                          actions: [
                            IconButton(
                              icon: const Icon(Icons.save),
                              onPressed: () => action2Pressed = true,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                child: const Text('اذهب'),
              ),
            ),
          ),
        ),
      );

      // Test first AppBar
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      expect(action1Pressed, isTrue);

      // Navigate to second page
      await tester.tap(find.text('اذهب'));
      await tester.pumpAndSettle();

      // Test second AppBar
      await tester.tap(find.byIcon(Icons.save));
      await tester.pump();
      expect(action2Pressed, isTrue);

      // Test back button
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });
  });
}
