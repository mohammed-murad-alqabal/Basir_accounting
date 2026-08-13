// ignore_for_file: lines_longer_than_80_chars
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/features/invoices/presentation/providers/invoice_provider.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:basir_accounting_system/shared/widgets/invoice_list_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// ودجت يلتقط آخر قيمة للمزود المحدد ويُسلّمها لدالة الاستدعاء.
class _ValueCapture<T> extends ConsumerWidget {
  const _ValueCapture({
    required this.value,
    required this.onCapture,
    required this.child,
  });

  final ProviderListenable<T> value;
  final void Function(T value) onCapture;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final latest = ref.watch(value);
    onCapture(latest);
    return child;
  }
}

/// غلّافة اختبارية توفر ProviderScope وترجمة المشروع الأصلية.
Widget buildTestApp({
  String locale = 'en',
  int? totalMatches,
}) =>
    ProviderScope(
      child: MaterialApp(
        locale: Locale(locale),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Scaffold(
          body: InvoiceListToolbar(totalMatches: totalMatches),
        ),
      ),
    );

void main() {
  group('InvoiceListToolbar', () {
    testWidgets('renders search text field and sort menu', (tester) async {
      await tester.pumpWidget(buildTestApp());

      expect(find.byType(TextField), findsOneWidget);
      expect(find.byType(PopupMenuButton<String>), findsOneWidget);

      // حقل البحث يعرّض تلميح الدلالة (accessibility) — فحص عقدة الدلالة
      // الخاصة بتكوين الحقل (InputDecorator) التي تحمل التسمية/التلميح.
      // فحص عقدة EditableText الداخلية التي تحمل hintText كتسمية دلالية
      final editableFinder = find.byType(EditableText);
      final editableSemantics = tester.getSemantics(editableFinder);
      final hasAccessibleHint =
          <credential-fixture>().contains('search invoices') ||
              editableSemantics.hint.toLowerCase().contains('search invoices');
      expect(hasAccessibleHint, isTrue);
    });

    testWidgets('typing in search field updates invoiceSearchProvider state',
        (tester) async {
      String? observedQuery;
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            locale: const Locale('en'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: _ValueCapture(
              value: invoiceSearchProvider,
              onCapture: (value) => observedQuery = value,
              child: const Scaffold(
                body: InvoiceListToolbar(),
              ),
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'INV-123');
      await tester.pump();

      expect(observedQuery, 'INV-123');
    });

    testWidgets('pressing clear button resets search query and removes counter',
        (tester) async {
      await tester.pumpWidget(buildTestApp(totalMatches: 3));

      await tester.enterText(find.byType(TextField), 'INV');
      await tester.pump();
      expect(find.text('3 results'), findsOneWidget);

      // زر المسح يظهر فقط عند وجود استعلام نشط
      await tester.tap(find.byIcon(Icons.cancel));
      await tester.pump();
      expect(find.byIcon(Icons.cancel), findsNothing);
      expect(find.text('3 results'), findsNothing);
    });

    testWidgets('results counter shows only while a search query is active',
        (tester) async {
      await tester.pumpWidget(buildTestApp(totalMatches: 7));

      // لا يوجد استعلام نشط؛ العدّاد مخفي
      expect(find.text('7 results'), findsNothing);

      await tester.enterText(find.byType(TextField), 'INV');
      await tester.pump();
      expect(find.text('7 results'), findsOneWidget);
    });

    testWidgets('zero matches shows the localized no-results message',
        (tester) async {
      // ضبط استعلام نشط أولًا ثم إعادة بناء الشريط مع صفر مطابقات
      // داخل نفس الحاوية لتبقى حالة البحث محفوظة.
      String? observed;
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            locale: const Locale('en'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: _ValueCapture(
              value: invoiceSearchProvider,
              onCapture: (value) => observed = value,
              child: _ValueCapture(
                value: invoiceSortProvider,
                onCapture: (value) {},
                child: const Scaffold(
                  body: InvoiceListToolbar(totalMatches: 1),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'INV');
      await tester.pump();

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            locale: const Locale('en'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: _ValueCapture(
              value: invoiceSearchProvider,
              onCapture: (value) => observed = value,
              child: _ValueCapture(
                value: invoiceSortProvider,
                onCapture: (value) {},
                child: const Scaffold(
                  body: InvoiceListToolbar(totalMatches: 0),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      // الاستعلام يبقى نشطًا بعد إعادة البناء
      expect(observed, 'INV');
      expect(find.text('No invoices match your search'), findsOneWidget);
    });

    testWidgets('selecting a sort option updates invoiceSortProvider',
        (tester) async {
      String? observedSort;
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            locale: const Locale('en'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: _ValueCapture(
              value: invoiceSortProvider,
              onCapture: (value) => observedSort = value,
              child: const Scaffold(
                body: InvoiceListToolbar(),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(PopupMenuButton<String>));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Customer name'));
      await tester.pumpAndSettle();

      expect(observedSort, 'customer');
    });

    testWidgets('clear button meets minimum touch target of 44px',
        (tester) async {
      await tester.pumpWidget(buildTestApp(totalMatches: 2));

      await tester.enterText(find.byType(TextField), 'INV');
      await tester.pump();

      // القياس يجب أن يشمل منطقة اللمس الفعلية لزر المسح
      // (التي تشمل padding الداخلي) وليس أيقونته الداخلية (20px) فقط.
      final clearArea = tester.getSize(find.byIcon(Icons.cancel));
      final clearBox = tester.renderObject<RenderBox>(
        find.ancestor(
          of: find.byIcon(Icons.cancel),
          matching: find.byType(IconButton),
        ),
      );
      final effectiveWidth = clearArea.width > clearBox.size.width
          ? clearArea.width
          : clearBox.size.width;
      final effectiveHeight = clearArea.height > clearBox.size.height
          ? clearArea.height
          : clearBox.size.height;
      expect(effectiveWidth, greaterThanOrEqualTo(TouchTargets.minimum));
      expect(effectiveHeight, greaterThanOrEqualTo(TouchTargets.minimum));
    });

    testWidgets('sort menu meets minimum touch target of 44px', (tester) async {
      await tester.pumpWidget(buildTestApp());

      // قياس الزر الداخلي لقائمة الفرز (PopupMenuButton)
      final popupFinder = find.byType(PopupMenuButton<String>);
      final renderBox = tester.renderObject<RenderBox>(popupFinder);
      expect(renderBox.size.height, greaterThanOrEqualTo(44.0));
    });

    testWidgets('RTL layout mirrors search field when language is Arabic',
        (tester) async {
      await tester.pumpWidget(buildTestApp(locale: 'ar'));

      final directionality = tester.widget<Directionality>(
        find.byType(Directionality).last,
      );
      expect(directionality.textDirection, TextDirection.rtl);
    });
  });
}
