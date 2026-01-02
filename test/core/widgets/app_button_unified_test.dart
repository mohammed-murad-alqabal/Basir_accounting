// ignore_for_file: deprecated_member_use
import 'package:basir_app/core/theme/app_theme.dart';
import 'package:basir_app/core/theme/tokens/index.dart';
import 'package:basir_app/core/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppButton Unified', () {
    testWidgets('AppPrimaryButton uses correct background color from tokens',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: AppPrimaryButton(
              label: 'Primary',
              onPressed: () {},
            ),
          ),
        ),
      );

      final container =
          tester.widget<AnimatedContainer>(find.byType(AnimatedContainer));
      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.color, equals(ButtonColors.primaryBackground));
    });

    testWidgets('AppButton has Semantics', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: AppPrimaryButton(
              label: 'Accessible Button',
              onPressed: () {},
            ),
          ),
        ),
      );

      final semanticsHandle = tester.ensureSemantics();
      final semanticsNode = tester.getSemantics(
        find.descendant(
          of: find.byType(AppPrimaryButton),
          matching: find.byType(Semantics),
        ),
      );
      final semantics = semanticsNode.getSemanticsData();

      // Verify button has tap action
      expect(
        semantics.hasAction(SemanticsAction.tap),
        isTrue,
      );

      // Verify isButton flag (ignoring deprecation)
      expect(
        semantics.hasFlag(SemanticsFlag.isButton),
        isTrue,
      );
      expect(semantics.hasFlag(SemanticsFlag.isEnabled), isTrue);

      semanticsHandle.dispose();
    });

    testWidgets('AppButton disabled state has correct semantics',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: AppPrimaryButton(
              label: 'Disabled',
            ),
          ),
        ),
      );

      final semanticsHandle = tester.ensureSemantics();
      final semanticsNode = tester.getSemantics(find.byType(AppPrimaryButton));
      final semantics = semanticsNode.getSemanticsData();

      // Disabled button should NOT have tap action
      expect(semantics.hasAction(SemanticsAction.tap), isFalse);

      semanticsHandle.dispose();
    });

    testWidgets('AppButton shows loading indicator when isLoading is true',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: AppPrimaryButton(
              label: 'Loading',
              onPressed: () {},
              isLoading: true,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading'), findsNothing);

      // Verify semantics/loading logic (optional)
      // For now we check that it doesn't crash.
    });

    testWidgets('AppButton backward compatibility wrapper supports text param',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: AppPrimaryButton(
              // ignore: deprecated_member_use_from_same_package
              text: 'Legacy Text',
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Legacy Text'), findsOneWidget);
    });
  });
}
