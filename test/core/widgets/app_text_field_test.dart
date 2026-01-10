import 'package:basir_app/core/theme/app_theme.dart';
import 'package:basir_app/shared/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppTextField Accessibility', () {
    testWidgets('Text field exposes label to semantics', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: AppTextField(label: 'User Name', hint: 'Enter name'),
          ),
        ),
      );

      // Find the TextFormField that AppTextField wraps
      final textFieldFinder = find.byType(TextFormField);
      expect(textFieldFinder, findsOneWidget);

      // Check semantics
      // We expect the node to have the label "User Name"
      // or at least have a semantic configuration that includes it.

      // Note: Since the label is a separate Text widget in the
      // current implementation, the TextField itself might NOT have
      // the label "User Name". This test reveals the current state.

      final semantics = tester.getSemantics(textFieldFinder);
      // We check if the label is part of the implementation
      // Currently, it likely isn't linked.

      // Verification: Check if label is linked via input decoration
      // or wrapping Semantics
      expect(semantics.label, contains('User Name'));
    });
  });
}
