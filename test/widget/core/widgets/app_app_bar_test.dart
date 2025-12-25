import 'package:basser_app/core/theme/app_theme.dart';
import 'package:basser_app/core/widgets/app_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppAppBar', () {
    testWidgets('should display title correctly', (tester) async {
      // Arrange
      const title = 'العملاء';

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(appBar: AppAppBar(title: title)),
        ),
      );

      // Assert
      expect(find.text(title), findsOneWidget);
    });

    testWidgets('should show back button by default', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(appBar: AppAppBar(title: 'Test')),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('should hide back button when showBackButton is false', (
      tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            appBar: AppAppBar(title: 'Test', showBackButton: false),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.arrow_back), findsNothing);
    });

    testWidgets('should call Navigator.pop when back button is pressed', (
      tester,
    ) async {
      // Arrange
      var navigatorPopped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              appBar: const AppAppBar(title: 'Test'),
              body: ElevatedButton(
                onPressed: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => Scaffold(
                        appBar: AppAppBar(
                          title: 'Second Screen',
                          onBackPressed: () {
                            navigatorPopped = true;
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ),
                  );
                },
                child: const Text('Navigate'),
              ),
            ),
          ),
        ),
      );

      // Navigate to second screen
      await tester.tap(find.text('Navigate'));
      await tester.pumpAndSettle();

      // Act - Tap back button
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Assert
      expect(navigatorPopped, isTrue);
      expect(find.text('Second Screen'), findsNothing);
    });

    testWidgets('should display actions when provided', (tester) async {
      // Arrange
      var actionPressed = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppAppBar(
              title: 'Test',
              actions: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    actionPressed = true;
                  },
                ),
                IconButton(icon: const Icon(Icons.search), onPressed: () {}),
              ],
            ),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);

      // Test action button press
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      expect(actionPressed, isTrue);
    });

    testWidgets('should use custom colors when provided', (tester) async {
      // Arrange
      const customBgColor = Colors.blue;
      const customFgColor = Colors.white;

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            appBar: AppAppBar(
              title: 'Test',
              backgroundColor: customBgColor,
              foregroundColor: customFgColor,
            ),
          ),
        ),
      );

      // Assert
      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.backgroundColor, customBgColor);
      expect(appBar.foregroundColor, customFgColor);
    });

    testWidgets('should use default colors when not provided', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(appBar: AppAppBar(title: 'Test')),
        ),
      );

      // Assert
      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.backgroundColor, AppTheme.lightTheme.colorScheme.surface);
      expect(appBar.foregroundColor, AppTheme.lightTheme.colorScheme.onSurface);
    });

    testWidgets('should have elevation of 0', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(appBar: AppAppBar(title: 'Test')),
        ),
      );

      // Assert
      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.elevation, 0);
    });

    testWidgets('should center title', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(appBar: AppAppBar(title: 'Test')),
        ),
      );

      // Assert
      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.centerTitle, isTrue);
    });

    testWidgets('should have correct preferred size', (tester) async {
      // Arrange
      const appBar = AppAppBar(title: 'Test');

      // Assert
      expect(appBar.preferredSize, const Size.fromHeight(kToolbarHeight + 1.0));
    });
  });

  group('AppSimpleAppBar', () {
    testWidgets('should display title correctly', (tester) async {
      // Arrange
      const title = 'لوحة التحكم';

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(appBar: AppSimpleAppBar(title: title)),
        ),
      );

      // Assert
      expect(find.text(title), findsOneWidget);
    });

    testWidgets('should not show back button', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(appBar: AppSimpleAppBar(title: 'Test')),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.arrow_back), findsNothing);
    });

    testWidgets('should display actions when provided', (tester) async {
      // Arrange
      var actionPressed = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppSimpleAppBar(
              title: 'Test',
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    actionPressed = true;
                  },
                ),
              ],
            ),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.settings), findsOneWidget);

      // Test action button press
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pump();
      expect(actionPressed, isTrue);
    });

    testWidgets('should use custom colors when provided', (tester) async {
      // Arrange
      const customBgColor = Colors.green;
      const customFgColor = Colors.black;

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            appBar: AppSimpleAppBar(
              title: 'Test',
              backgroundColor: customBgColor,
              foregroundColor: customFgColor,
            ),
          ),
        ),
      );

      // Assert
      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.backgroundColor, customBgColor);
      expect(appBar.foregroundColor, customFgColor);
    });

    testWidgets('should use default colors when not provided', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(appBar: AppSimpleAppBar(title: 'Test')),
        ),
      );

      // Assert
      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.backgroundColor, AppTheme.lightTheme.colorScheme.surface);
      expect(appBar.foregroundColor, AppTheme.lightTheme.colorScheme.onSurface);
    });

    testWidgets('should have elevation of 0', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(appBar: AppSimpleAppBar(title: 'Test')),
        ),
      );

      // Assert
      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.elevation, 0);
    });

    testWidgets('should center title', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(appBar: AppSimpleAppBar(title: 'Test')),
        ),
      );

      // Assert
      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.centerTitle, isTrue);
    });

    testWidgets('should not automatically imply leading', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(appBar: AppSimpleAppBar(title: 'Test')),
        ),
      );

      // Assert
      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.automaticallyImplyLeading, isFalse);
    });

    testWidgets('should have correct preferred size', (tester) async {
      // Arrange
      const appBar = AppSimpleAppBar(title: 'Test');

      // Assert
      expect(appBar.preferredSize, const Size.fromHeight(kToolbarHeight + 1.0));
    });
  });
}
