import 'package:basir_accounting_system/features/settings/presentation/screens/print_settings_screen.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildScreen() => const MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: Locale('ar'),
    home: PrintSettingsScreen(),
  );

  group('PrintSettingsScreen', () {
    testWidgets('يحدث خيارات الطباعة ثم يحفظ الإعدادات', (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      expect(find.text('A4 Invoice'), findsOneWidget);
      expect(find.text('Bluetooth Receipt (Thermal)'), findsOneWidget);
      expect(find.text('80 mm'), findsOneWidget);

      await tester.tap(find.text('Bluetooth Receipt (Thermal)'));
      await tester.pump();

      final bluetoothRadio = tester.widget<Radio<String>>(
        find.byWidgetPredicate(
          (widget) =>
              widget is Radio<String> && widget.value == 'Bluetooth',
        ),
      );
      // ignore: deprecated_member_use
      expect(bluetoothRadio.groupValue, 'Bluetooth');

      await tester.tap(find.text('58 mm'));
      await tester.pump();
      final smallPaperRadio = tester.widget<Radio<String>>(
        find.byWidgetPredicate(
          (widget) => widget is Radio<String> && widget.value == '58mm',
        ),
      );
      // ignore: deprecated_member_use
      expect(smallPaperRadio.groupValue, '58mm');

      await tester.ensureVisible(find.byType(Slider));
      await tester.drag(find.byType(Slider), const Offset(110, 0));
      await tester.pump();
      expect(find.text('20'), findsNothing);

      await tester.ensureVisible(find.byType(Switch));
      await tester.tap(find.byType(Switch));
      await tester.pump();
      expect(tester.widget<Switch>(find.byType(Switch)).value, isTrue);

      final addButtons = find.byIcon(Icons.add_circle_outline);
      await tester.tap(addButtons.last);
      await tester.pump();
      expect(find.text('2'), findsOneWidget);

      await tester.ensureVisible(find.byIcon(Icons.save_outlined));
      await tester.tap(find.byIcon(Icons.save_outlined));
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('يحافظ العداد على الصفر عند محاولة إنقاصه', (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      final removeButtons = find.byIcon(Icons.remove_circle_outline);
      await tester.ensureVisible(removeButtons.first);
      for (var i = 0; i < 8; i++) {
        await tester.tap(removeButtons.first);
        await tester.pump();
      }

      expect(find.text('0'), findsOneWidget);
    });
  });
}
