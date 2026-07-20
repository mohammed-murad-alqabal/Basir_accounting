import 'package:basir_accounting_system/core/theme/app_state_colors.dart';
import 'package:basir_accounting_system/core/theme/disabled_state_design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DisabledStateDesign', () {
    testWidgets('buildDisabledIndicator shows child with correct opacity',
        (tester) async {
      const testChild = Text('Test');
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DisabledStateDesign.buildDisabledIndicator(child: testChild),
          ),
        ),
      );

      expect(find.text('Test'), findsOneWidget);

      // Check that there's an Opacity widget with the correct opacity
      final opacityWidgets = tester.widgetList<Opacity>(find.byType(Opacity));
      var found = false;
      for (final widget in opacityWidgets) {
        if (widget.opacity == AppStateColors.disabledOpacity) {
          found = true;
          break;
        }
      }
      expect(found, isTrue);
    });

    testWidgets('buildDisabledTooltip has correct message', (tester) async {
      const testChild = Text('Test');
      const testMessage = 'Disabled for testing';
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DisabledStateDesign.buildDisabledTooltip(
              child: testChild,
              message: testMessage,
            ),
          ),
        ),
      );

      expect(find.text('Test'), findsOneWidget);

      // Check that there's a Tooltip with the correct message
      final tooltipWidgets = tester.widgetList<Tooltip>(find.byType(Tooltip));
      var found = false;
      for (final widget in tooltipWidgets) {
        if (widget.message == testMessage) {
          found = true;
          break;
        }
      }
      expect(found, isTrue);
    });
  });
}
