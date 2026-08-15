import 'package:basir_accounting_system/core/theme/glass_theme.dart';
import 'package:basir_accounting_system/features/navigation/presentation/providers/omnibar_provider.dart';
import 'package:basir_accounting_system/features/navigation/presentation/widgets/omnibar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildHost({List<Override> overrides = const []}) => ProviderScope(
    overrides: overrides,
    child: MaterialApp(
      theme: ThemeData.light().copyWith(extensions: [GlassTheme.light()]),
      routes: {
        '/invoice-form': (_) => const Scaffold(body: Text('Invoice form route')),
        '/customer-form': (_) => const Scaffold(body: Text('Customer form route')),
        '/returns-and-damages':
            (_) => const Scaffold(body: Text('Returns route')),
        '/settings': (_) => const Scaffold(body: Text('Settings route')),
      },
      home: Builder(
        builder: (context) => Scaffold(
          body: Center(
            child: ElevatedButton(
              onPressed: () => showOmnibar<void>(context),
              child: const Text('Open omnibar'),
            ),
          ),
        ),
      ),
    ),
  );

  Future<void> openOmnibar(WidgetTester tester) async {
    await tester.tap(find.text('Open omnibar'));
    await tester.pumpAndSettle();
  }

  group('Omnibar', () {
    testWidgets('يفتح الاقتراحات ويوجه إلى إنشاء فاتورة', (tester) async {
      await tester.pumpWidget(buildHost());
      await openOmnibar(tester);

      expect(find.text('Suggestions'.toUpperCase()), findsOneWidget);
      expect(find.text('New Invoice'), findsOneWidget);
      expect(find.text('New Customer'), findsOneWidget);
      expect(find.text('Returns & Damages'), findsOneWidget);
      expect(find.text('ESC'), findsOneWidget);

      await tester.tap(find.text('New Invoice'));
      await tester.pumpAndSettle();

      expect(find.text('Invoice form route'), findsOneWidget);
    });

    testWidgets('يعرض نتيجة أمر البحث وينفذ مسارها', (tester) async {
      await tester.pumpWidget(
        buildHost(
          overrides: [
            omnibarSearchProvider('settings').overrideWithValue([
              OmnibarResult(
                title: 'إعدادات النظام',
                subtitle: 'تغيير تفضيلات العمل',
                type: OmnibarResultType.action,
                data: '/settings',
              ),
            ]),
          ],
        ),
      );
      await openOmnibar(tester);

      await tester.enterText(find.byType(TextField), 'settings');
      await tester.pumpAndSettle();

      expect(find.text('RESULTS FOR "SETTINGS"'), findsOneWidget);
      expect(find.text('إعدادات النظام'), findsOneWidget);
      expect(find.text('تغيير تفضيلات العمل'), findsOneWidget);

      await tester.tap(find.text('إعدادات النظام'));
      await tester.pumpAndSettle();

      expect(find.text('Settings route'), findsOneWidget);
    });

    testWidgets('يعرض حالة غياب النتائج للاستعلام المتجاوز', (tester) async {
      await tester.pumpWidget(
        buildHost(
          overrides: [
            omnibarSearchProvider('غير موجود').overrideWithValue([]),
          ],
        ),
      );
      await openOmnibar(tester);

      await tester.enterText(find.byType(TextField), 'غير موجود');
      await tester.pumpAndSettle();

      expect(find.text('RESULTS FOR "غير موجود"'), findsOneWidget);
      expect(find.text('No results found'), findsOneWidget);
    });
  });
}
