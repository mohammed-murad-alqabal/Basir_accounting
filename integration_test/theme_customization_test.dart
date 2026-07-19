import 'package:basir_accounting_system/core/theme/tokens/app_icons.dart';
import 'package:basir_accounting_system/features/settings/presentation/screens/appearance_settings_screen.dart';
import 'package:basir_accounting_system/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Theme Customization Integration Tests', () {
    testWidgets('should allow changing primary color', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // --- 1. Handle Navigation to Settings ---

      // Check if we are on Login Screen
      final guestButton = find.text('الدخول كضيف');
      if (guestButton.evaluate().isNotEmpty) {
        // We are on Login Screen
        await tester.tap(guestButton);
        await tester.pumpAndSettle();
      }

      // Check if we are on Dashboard (we should be now)
      expect(find.text('لوحة التحكم'), findsOneWidget);

      // Tap on Settings Tab (Index 3)
      // Finding by Icon might be tricky if AppIcons are dynamic,
      // but label 'الإعدادات' should appear
      final settingsTab = find.text('الإعدادات');
      await tester.tap(settingsTab);
      await tester.pumpAndSettle();

      // Verify we are on Settings Screen
      expect(find.text('المظهر والتخصيص'), findsOneWidget);

      // Tap on Appearance Settings
      final appearanceTile = find.text('إعدادات المظهر');
      await tester.tap(appearanceTile);
      await tester.pumpAndSettle();

      // Verify Appearance Screen
      expect(find.byType(AppearanceSettingsScreen), findsOneWidget);

      // --- 2. Scenario A: Color Customization ---
      final colorTile = find.text('لون التطبيق');
      expect(colorTile, findsOneWidget);
      await tester.tap(colorTile);
      await tester.pumpAndSettle();

      // Picker Dialog should be open
      expect(find.text('اختر لونك المفضل'), findsOneWidget);
      // Close it for now (tap outside or cancel/ok if available)
      // Since it's a dialog, tapping 'إلغاء' or 'موافق' if they exist.
      // FlexColorPicker usually has actions. Use 'إلغاء' or escape.
      final cancelText = find.text('إلغاء');
      if (cancelText.evaluate().isNotEmpty) {
        await tester.tap(cancelText);
      } else {
        // Press escape/back
        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      }
      await tester.pumpAndSettle();

      // --- 3. Scenario B: Font Customization ---
      final fontTile = find.text('نوع الخط');
      expect(fontTile, findsOneWidget); // Ensure visible

      // Change Font Family
      // Finds the dropdown by the current value text or just by type
      final fontDropdown = find.descendant(
        of: find.widgetWithText(ListTile, 'نوع الخط'),
        matching: find.byType(DropdownButton<String>),
      );
      await tester.tap(fontDropdown);
      await tester.pumpAndSettle();

      // Select 'Roboto'
      final robotoItem = find.text('Roboto').last;
      await tester.tap(robotoItem);
      await tester.pumpAndSettle();

      // Change Text Scale (Slider)
      final slider = find.byType(Slider);
      await tester.drag(slider, const Offset(50, 0)); // Drag right
      await tester.pumpAndSettle();

      // --- 4. Scenario C: Icon Customization ---
      // Scroll to ensure visibility? ListView usually handles this.

      final iconTile = find.text('نمط الأيقونات');

      // Ensure visible (scroll if needed)
      await tester.scrollUntilVisible(iconTile, 100);
      await tester.pumpAndSettle();

      final iconDropdown = find.descendant(
        of: find.widgetWithText(ListTile, 'نمط الأيقونات'),
        matching: find.byType(DropdownButton<IconPack>),
      );
      await tester.tap(iconDropdown);
      await tester.pumpAndSettle();

      // Select Cupertino
      final cupertinoItem = find.text('Cupertino (iOS)').last;
      await tester.tap(cupertinoItem);
      await tester.pumpAndSettle();

      // Verification: Check if some icon changed visually?
      // For integration, ensuring selection happened is good.
      // Check subtitle update.

      // Subtitle updates to 'Cupertino'
      expect(find.text('Cupertino'), findsOneWidget);
    });
  });
}
