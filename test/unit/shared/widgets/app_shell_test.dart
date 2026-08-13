import 'package:basir_accounting_system/core/theme/services/icon_customization_service.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:basir_accounting_system/shared/widgets/app_shell.dart';
import 'package:basir_accounting_system/shared/widgets/basir_sidebar.dart';
import 'package:basir_accounting_system/shared/widgets/basir_topbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// أداة بناء ودجت اختباري بمحيط ProviderScope وتهيئة l10n
Widget buildShell({
  Widget? child,
  double width = 1280,
  String locale = 'ar',
  bool rtl = true,
  bool sidebarCollapsedDefault = false,

  /// مفتاح فريد لإجبار Riverpod على إعادة إنشاء ProviderContainer عند إعادة
  /// البناء (pumpWidget جديد بقيم overrides مختلفة)
  Key? providerKey,
}) {
  return MaterialApp(
    locale: Locale(locale),
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [Locale('ar'), Locale('en')],
    home: Directionality(
      textDirection: rtl ? TextDirection.rtl : TextDirection.ltr,
      child: ProviderScope(
        key: <credential-fixture> ?? UniqueKey(),
        overrides: [
          appIconsProvider.overrideWith((ref) => const MaterialAppIcons()),
          // يجب إبقاء نفس عدد الـ overrides في كل إعادة بناء (riverpod لا يسمح بتغيير العدد)
          sidebarCollapsedProvider
              .overrideWith((ref) => sidebarCollapsedDefault),
        ],
        child: MediaQuery(
          data: MediaQueryData(size: Size(width, 800)),
          child: Scaffold(body: child ?? const BasirAppShell()),
        ),
      ),
    ),
  );
}

/// يضبط حجم سطح الاختبار الفعلي قبل pumpWidget (MediaQueryData وحده لا يحدد قيود السطح)
void setTestSurfaceSize(WidgetTester tester, double width) {
  tester.view.physicalSize = Size(width, 800);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
}

void main() {
  group('BasirAppShell responsive behavior', () {
    testWidgets('renders desktop layout at width >= 900', (tester) async {
      setTestSurfaceSize(tester, 1024);
      await tester.pumpWidget(buildShell(width: 1024));
      await tester.pumpAndSettle();

      expect(find.byType(BasirSidebar), findsOneWidget);
      expect(find.byType(BasirTopBar), findsOneWidget);
      expect(find.byType(BottomNavigationBar), findsNothing);
      expect(find.byType(BasirAppShell), findsOneWidget);
    });

    testWidgets('renders mobile layout below 900px', (tester) async {
      setTestSurfaceSize(tester, 600);
      await tester.pumpWidget(buildShell(width: 600));
      await tester.pumpAndSettle();

      expect(find.byType(BasirTopBar), findsOneWidget);
      // التصفح السفلي يُبنى يدويًا من بنود _MobileNavItem (8 بنود)
      expect(find.byType(BasirSidebar), findsNothing);
    });

    testWidgets('displays all 8 unit screens in desktop layout',
        (tester) async {
      setTestSurfaceSize(tester, 1280);
      await tester.pumpWidget(buildShell());
      await tester.pumpAndSettle();

      // IndexedStack يعرض كل الشاشات (مع إخفاء غير النشطة)
      expect(tester.widgetList<IndexedStack>(find.byType(IndexedStack)).length,
          greaterThanOrEqualTo(1));
      final stack =
          tester.widget<IndexedStack>(find.byType(IndexedStack).first);
      expect(stack.children.length, 8);
    });

    testWidgets('sidebar collapses to icon-only width when toggled',
        (tester) async {
      setTestSurfaceSize(tester, 1280);
      await tester.pumpWidget(buildShell());
      await tester.pumpAndSettle();

      // العرض الموسّع: الشريط الجانبي يشغل kSidebarExpandedWidth من إجمالي الصف
      final sidebarRenderBoxBefore =
          tester.renderObject<RenderBox>(find.byType(BasirSidebar)).size;
      expect(sidebarRenderBoxBefore.width, kSidebarExpandedWidth);

      await tester.pumpWidget(buildShell(
        width: 1280,
        sidebarCollapsedDefault: true,
        providerKey: const Key('collapsed'),
      ));
      await tester.pumpAndSettle();

      // العرض المطوي: أيقونات فقط
      final sidebarRenderBoxAfter =
          tester.renderObject<RenderBox>(find.byType(BasirSidebar)).size;
      expect(sidebarRenderBoxAfter.width, kSidebarCollapsedWidth);
    });

    testWidgets('toggle button announces its action for accessibility',
        (tester) async {
      setTestSurfaceSize(tester, 1280);
      await tester.pumpWidget(buildShell());
      await tester.pumpAndSettle();

      final toggleSemantics = find.descendant(
        of: find.byType(BasirSidebar),
        matching: find.bySemanticsLabel('طي/فتح شريط التنقل'),
      );
      expect(toggleSemantics, findsAtLeastNWidgets(1));
    });
  });

  group('BasirSidebar navigation items', () {
    testWidgets('renders 8 nav items with icons and labels', (tester) async {
      setTestSurfaceSize(tester, 1280);
      await tester.pumpWidget(buildShell());
      await tester.pumpAndSettle();

      // 8 بنود تنقل
      expect(
        find.descendant(
          of: find.byType(BasirSidebar),
          matching: find.byType(InkWell),
        ),
        findsNWidgets(8),
      );

      // التسميات العربية الفعلية من l10n
      expect(find.text('الرئيسية'), findsOneWidget);
      expect(find.text('الفواتير'), findsOneWidget);
      expect(find.text('الموردون'), findsOneWidget);
      expect(find.text('العملاء'), findsOneWidget);
      expect(find.text('المخزون'), findsOneWidget);
      expect(find.text('الأصول الثابتة'), findsOneWidget);
      expect(find.text('التقارير'), findsOneWidget);
      expect(find.text('الإعدادات'), findsOneWidget);
    });

    testWidgets('active item uses brand primary color for contrast',
        (tester) async {
      setTestSurfaceSize(tester, 1280);
      await tester.pumpWidget(buildShell());
      await tester.pumpAndSettle();

      // البند النشط (الأول) يحتوي خلفية primaryLight (لون فاتح من الهوية)
      final activeContainers = find.descendant(
        of: find.byType(BasirSidebar),
        matching: find.byWidgetPredicate(
          (widget) =>
              widget is AnimatedContainer &&
              (widget.decoration as BoxDecoration).color ==
                  AppColors.primaryLight,
        ),
      );
      expect(activeContainers, findsOneWidget);
    });

    testWidgets('highlights selected item semantically', (tester) async {
      setTestSurfaceSize(tester, 1280);
      await tester.pumpWidget(buildShell());
      await tester.pumpAndSettle();
      expect(
        find.descendant(
          of: find.byType(BasirSidebar),
          matching: find.byWidgetPredicate(
            (widget) =>
                widget is Semantics &&
                (widget.properties.selected ?? false) &&
                (widget.properties.label ?? '').contains('الرئيسية'),
          ),
        ),
        findsOneWidget,
      );
    });

    testWidgets('shows Basir brand header with system title', (tester) async {
      setTestSurfaceSize(tester, 1280);
      await tester.pumpWidget(buildShell());
      await tester.pumpAndSettle();

      expect(find.text('نظام بصير المحاسبي'), findsOneWidget);
      expect(find.byIcon(Icons.auto_awesome), findsOneWidget);
    });
  });

  group('BasirTopBar work context', () {
    testWidgets('displays org/branch/period context chips', (tester) async {
      setTestSurfaceSize(tester, 1280);
      await tester.pumpWidget(buildShell());
      await tester.pumpAndSettle();

      // الشرائح تعرض القيم الافتراضية (المؤسسة/الفرع/الفترة)
      expect(find.text('المؤسسة الافتراضية'), findsWidgets);
      expect(find.text('الفرع الرئيسي'), findsWidgets);
      expect(find.text('الفترة المالية الحالية'), findsWidgets);

      expect(find.byIcon(Icons.business_outlined), findsOneWidget);
      expect(find.byIcon(Icons.account_tree_outlined), findsOneWidget);
      expect(find.byIcon(Icons.calendar_month_outlined), findsOneWidget);
    });

    testWidgets('displays custom org/branch/period when provided',
        (tester) async {
      await tester.pumpWidget(buildShell(
        width: 1280,
        child: Builder(
          builder: (context) => BasirTopBar(
            appIcons: null,
            l10n: AppLocalizations.of(context),
            collapsed: false,
            orgName: 'شركة بصير للتجارة',
            branchName: 'فرع الرياض',
            periodName: 'الفترة 2026',
          ),
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('شركة بصير للتجارة'), findsOneWidget);
      expect(find.text('فرع الرياض'), findsOneWidget);
      expect(find.text('الفترة 2026'), findsOneWidget);
    });

    testWidgets('provides global search field placeholder', (tester) async {
      setTestSurfaceSize(tester, 1280);
      await tester.pumpWidget(buildShell());
      await tester.pumpAndSettle();

      expect(find.byType(BasirGlobalSearchField), findsOneWidget);
      expect(
          find.text('ابحث في الفواتير والعملاء والأصناف...'), findsOneWidget);
    });

    testWidgets('chips are announced for accessibility', (tester) async {
      setTestSurfaceSize(tester, 1280);
      await tester.pumpWidget(buildShell());
      await tester.pumpAndSettle();

      final semanticsHandle = tester.ensureSemantics();
      await tester.pumpAndSettle();

      expect(
        tester.takeException(),
        isNull,
      );

      final semantics = tester.getSemantics(find.byType(BasirTopBar).first);
      // Semantics الشرائح مدموجة مع الزر (button: true) ومحتواها النصي،
      // لذا تُجمع كل الـ labels المدموجة ثم يُتحقق من احتواء كل شريحة عنوانها
      final collectedLabels = <String>[];
      semantics.visitChildren((node) {
        final label = node.label;
        if (label.contains(':')) {
          collectedLabels.add(label);
        }
        return true;
      });
      expect(
        collectedLabels.any((l) => l.contains('المؤسسة: المؤسسة الافتراضية')),
        isTrue,
      );
      expect(
        collectedLabels.any((l) => l.contains('الفرع: الفرع الرئيسي')),
        isTrue,
      );
      expect(
        collectedLabels.any((l) => l.contains('الفترة المالية الحالية')),
        isTrue,
      );
      semanticsHandle.dispose();
    });
  });

  group('BasirAppShell localization', () {
    testWidgets('renders English labels in EN locale', (tester) async {
      setTestSurfaceSize(tester, 1280);
      await tester.pumpWidget(buildShell(width: 1280, locale: 'en'));
      await tester.pumpAndSettle();

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Invoices'), findsOneWidget);
      expect(find.text('Reports'), findsOneWidget);
      expect(find.text('Default Organization'), findsWidgets);
      expect(find.text('Search invoices, customers, items...'), findsOneWidget);
    });

    testWidgets('renders topbar in mobile layout too', (tester) async {
      setTestSurfaceSize(tester, 1280);
      setTestSurfaceSize(tester, 480);
      await tester.pumpWidget(buildShell(width: 480, locale: 'en'));
      await tester.pumpAndSettle();
      expect(find.byType(BasirTopBar), findsOneWidget);
      // في الشاشات الضيقة (<1048px) تُطوى نصوص الشرائح إلى الأيقونات فقط،
      // لذا نتحقق من الإعلان الصوتي (Semantics) بدلًا من النص المرئي
      expect(
        find.bySemanticsLabel('Branch: Main Branch'),
        findsWidgets,
      );
      expect(find.byType(BottomNavigationBar), findsNothing);
    });
  });

  group('navigation constants', () {
    test('sidebar constants match the executive blueprint grid', () {
      expect(kDesktopBreakpoint, 900);
      expect(kSidebarCollapsedWidth, 68);
      expect(kSidebarExpandedWidth, 232);
      expect(kTopBarHeight, 56);
      expect(basirSidebarItems.length, 8);
    });

    test('sidebar width helper responds to collapse state', () {
      expect(sidebarWidthOf(false), kSidebarExpandedWidth);
      expect(sidebarWidthOf(true), kSidebarCollapsedWidth);
    });
  });
}
