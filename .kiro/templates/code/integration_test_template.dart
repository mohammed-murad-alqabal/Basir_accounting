/// Integration test template
///
/// Usage: Replace [Feature] with your feature name
///
/// Example:
/// ```dart
/// void main() {
///   IntegrationTestWidgetsFlutterBinding.ensureInitialized();
///   group('Customer Journey', () { ... });
/// }
/// ```

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('[Feature] Journey', () {
    testWidgets('should complete full flow', (tester) async {
      // Arrange
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();

      // Act 1 - Navigate
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Act 2 - Fill form
      await tester.enterText(
        find.byKey(const Key('name_field')),
        'Test Name',
      );

      // Act 3 - Submit
      await tester.tap(find.byKey(const Key('submit_button')));
      await tester.pumpAndSettle();

      // Assert - Success message
      expect(find.text('Success'), findsOneWidget);

      // Assert - Item in list
      expect(find.text('Test Name'), findsOneWidget);
    });

    testWidgets('should handle errors', (tester) async {
      // Arrange
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();

      // Act - Submit empty form
      await tester.tap(find.byKey(const Key('submit_button')));
      await tester.pumpAndSettle();

      // Assert - Error message
      expect(find.text('Error'), findsOneWidget);
    });
  });
}
