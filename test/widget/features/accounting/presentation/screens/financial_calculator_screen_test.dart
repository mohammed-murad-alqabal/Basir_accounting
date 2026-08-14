import 'package:basir_accounting_system/features/accounting/presentation/screens/financial_calculator_screen.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpCalculator(WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      const MaterialApp(
        locale: Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: FinancialCalculatorScreen(),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> tapKey(WidgetTester tester, String label) async {
    await tester.tap(find.text(label).last);
    await tester.pump();
  }

  group('FinancialCalculatorScreen', () {
    testWidgets('evaluates input, clears state, and reports invalid formulas',
        (tester) async {
      await pumpCalculator(tester);

      await tapKey(tester, '1');
      await tapKey(tester, '+');
      await tapKey(tester, '2');
      await tapKey(tester, '=');

      expect(find.text('1+2'), findsOneWidget);
      expect(find.text('3.0'), findsOneWidget);

      await tapKey(tester, 'C');
      expect(find.text('1+2'), findsNothing);
      expect(find.text('3.0'), findsNothing);

      await tapKey(tester, '(');
      await tapKey(tester, '=');
      expect(find.text('Error'), findsOneWidget);
    });

    testWidgets('converts a calculated result to USD when currency mode is on',
        (tester) async {
      await pumpCalculator(tester);

      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      await tapKey(tester, '7');
      await tapKey(tester, '+');
      await tapKey(tester, '0');
      await tapKey(tester, '.');
      await tapKey(tester, '5');
      await tapKey(tester, '=');

      expect(find.text('7.50 SAR ≈ 2.00 USD'), findsOneWidget);
    });

    testWidgets('calculates percentages and restores a selected history entry',
        (tester) async {
      await pumpCalculator(tester);

      await tapKey(tester, '5');
      await tapKey(tester, '0');
      await tapKey(tester, '%');

      expect(find.text('0.5'), findsOneWidget);
      expect(find.byIcon(Icons.history), findsOneWidget);

      await tester.tap(find.byIcon(Icons.history));
      await tester.pumpAndSettle();
      expect(find.text('50/100 = 0.5'), findsOneWidget);

      await tester.tap(find.text('50/100 = 0.5'));
      await tester.pumpAndSettle();
      expect(find.text('50/100'), findsOneWidget);
      expect(find.text('0.5'), findsOneWidget);
    });
  });
}
