import 'package:basir_accounting_system/core/theme/app_theme.dart';
import 'package:basir_accounting_system/features/settings/presentation/screens/tax_config_screen.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildSubject() => ProviderScope(
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('ar'),
          home: const TaxConfigScreen(),
        ),
      );

  group('TaxConfigScreen', () {
    testWidgets('يعرض تنبيه الامتثال وقيم الضريبة الافتراضية القابلة للتعديل',
        (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.byIcon(Icons.verified_user_outlined), findsOneWidget);
      expect(find.byType(SwitchListTile), findsNWidgets(2));
      expect(find.byType(TextField), findsNWidgets(4));
      expect(_fieldText(tester, 0), '300000000000003');
      expect(_fieldText(tester, 1), '15');

      await tester.enterText(find.byType(TextField).at(0), '310123456700003');
      await tester.enterText(find.byType(TextField).at(1), '5');
      expect(_fieldText(tester, 0), '310123456700003');
      expect(_fieldText(tester, 1), '5');
    });

    testWidgets('يبدّل خيارات الضريبة ويؤكد الحفظ للمستخدم', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      await tester.tap(find.byType(Switch).at(0));
      await tester.tap(find.byType(Switch).at(1));
      await tester.pump();
      expect(
        tester.widget<SwitchListTile>(find.byType(SwitchListTile).at(0)).value,
        isFalse,
      );
      expect(
        tester.widget<SwitchListTile>(find.byType(SwitchListTile).at(1)).value,
        isTrue,
      );

      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -600),
      );
      await tester.pump();
      await tester.tap(find.byIcon(Icons.save_outlined).last);
      await tester.pump();
      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}

String _fieldText(WidgetTester tester, int index) =>
    tester.widget<TextField>(find.byType(TextField).at(index)).controller!.text;
