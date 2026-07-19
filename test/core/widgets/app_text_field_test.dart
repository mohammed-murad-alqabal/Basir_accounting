import 'package:basir_accounting_system/core/theme/app_theme.dart';
import 'package:basir_accounting_system/shared/widgets/app_text_field.dart';
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

      // Check semantics - verify label is accessible
      final semantics = tester.getSemantics(textFieldFinder);
      expect(semantics.label, contains('User Name'));
    });
  });
}
