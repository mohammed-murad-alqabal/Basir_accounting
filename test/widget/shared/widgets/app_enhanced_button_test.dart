import 'package:basir_app/shared/widgets/app_enhanced_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppEnhancedButton Widget Tests', () {
    testWidgets('should render label correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppEnhancedButton(label: 'Test Button', onPressed: () {}),
          ),
        ),
      );

      expect(find.text('Test Button'), findsOneWidget);
    });

    testWidgets('should show loading indicator when isLoading is true', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppEnhancedButton(
              label: 'Loading...',
              onPressed: () {},
              isLoading: true,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading...'), findsNothing);
    });

    testWidgets('should render different types correctly', (tester) async {
      // Primary (with gradient)
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppEnhancedButton(label: 'Primary', onPressed: () {}),
          ),
        ),
      );
      var container = tester.widget<Container>(find.byType(Container).first);
      expect(container.decoration is BoxDecoration, isTrue);
      expect((container.decoration! as BoxDecoration).gradient, isNotNull);

      // Outlined (no gradient, has border)
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppEnhancedButton(
              label: 'Outlined',
              onPressed: () {},
              type: AppEnhancedButtonType.outlined,
            ),
          ),
        ),
      );
      container = tester.widget<Container>(find.byType(Container).first);
      expect((container.decoration! as BoxDecoration).gradient, isNull);
      expect((container.decoration! as BoxDecoration).border, isNotNull);
    });

    testWidgets('should respect custom height and width', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppEnhancedButton(
              label: 'Custom Size',
              onPressed: () {},
              width: 200,
              height: 60,
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(AppEnhancedButton),
              matching: find.byType(Container),
            )
            .first,
      );

      expect(container.constraints?.minHeight, 60);
      expect(container.constraints?.maxWidth, 200);
    });

    testWidgets('should handle long text with Flexible support', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 100,
              child: AppEnhancedButton(
                label: 'This is a long text',
                onPressed: () {},
                maxLines: 2,
              ),
            ),
          ),
        ),
      );

      expect(find.text('This is a long text'), findsOneWidget);
    });

    testWidgets('should call onPressed when tapped', (tester) async {
      var pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppEnhancedButton(
              label: 'Tap Me',
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Tap Me'));
      await tester.pumpAndSettle();

      expect(pressed, isTrue);
    });

    testWidgets('should handle various text scale factors', (tester) async {
      final scaleFactors = [0.8, 1.0, 1.5, 2.0];

      for (final scale in scaleFactors) {
        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              data: MediaQueryData(textScaler: TextScaler.linear(scale)),
              child: Scaffold(
                body: AppEnhancedButton(
                  label: 'Scaling Text',
                  onPressed: () {},
                ),
              ),
            ),
          ),
        );

        expect(find.text('Scaling Text'), findsOneWidget);
        await tester.pumpAndSettle();
      }
    });

    testWidgets('should handle rapid taps correctly', (tester) async {
      var tapCount = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppEnhancedButton(
              label: 'Tap Me',
              onPressed: () => tapCount++,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Tap Me'));
      await tester.pump();
      await tester.tap(find.text('Tap Me'));
      await tester.pump();
      await tester.tap(find.text('Tap Me'));
      await tester.pump();

      expect(tapCount, 3);
    });
  });
}
