import 'package:basir_accounting_system/core/theme/selected_state_design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SelectedStateDesign', () {
    test('buildSelectedBoxDecoration returns correct decoration', () {
      final decoration = SelectedStateDesign.buildSelectedBoxDecoration();
      expect(decoration.color, isNotNull);
      expect(decoration.border, isNotNull);
      expect(decoration.borderRadius, isNotNull);
    });

    testWidgets('buildSelectedListTile renders correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SelectedStateDesign.buildSelectedListTile(
              title: const Text('Selected Item'),
              subtitle: const Text('Subtitle'),
              leading: const Icon(Icons.star),
            ),
          ),
        ),
      );

      expect(find.text('Selected Item'), findsOneWidget);
      expect(find.text('Subtitle'), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets(
        'buildSelectedListTile hides checkmark when showCheckmark is false',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SelectedStateDesign.buildSelectedListTile(
              title: const Text('Selected Item'),
              showCheckmark: false,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.check_circle), findsNothing);
    });
  });
}
