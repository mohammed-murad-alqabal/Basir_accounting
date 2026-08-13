/// اختبارات طبقة العمل المشتركة: شارة الحالة، جدول العمل، شريط التصفية،
/// السجل الزمني للتدقيق — وفق المخطط التنفيذي (الأقسام 6 و7).
///
/// التغطية: RTL/EN، الاستجابة للعرض، الفرز والاختيار، الإعلانات الصوتية.
library;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:basir_accounting_system/core/domain/contracts/index.dart';
import 'package:basir_accounting_system/core/theme/tokens/app_colors.dart';
import 'package:basir_accounting_system/shared/widgets/work_layer/index.dart';

/// يغلف ودجت الطبقة بسياق تعريب واتجاه RTL/EN وRiverpod.
Widget _wrap({
  required Widget child,
  required bool rtl,
  required Size surfaceSize,
}) {
  return MaterialApp(
    locale: rtl ? const Locale('ar') : const Locale('en'),
    supportedLocales: const [Locale('ar'), Locale('en')],
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    home: MediaQuery(
      data: MediaQueryData(size: surfaceSize),
      child: Directionality(
        textDirection: rtl ? TextDirection.rtl : TextDirection.ltr,
        child: Scaffold(body: child),
      ),
    ),
  );
}

void _setTestSurfaceSize(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void main() {
  group('WorkStatusBadge', () {
    testWidgets('تعرض الحالة الموحدة بنص وأيقونة ولون دلالي', (tester) async {
      _setTestSurfaceSize(tester, const Size(800, 600));
      await tester.pumpWidget(_wrap(
          child: const WorkStatusBadge(status: DocumentStatus.posted),
          rtl: true,
          surfaceSize: const Size(800, 600)));

      expect(find.text('مرحّلة'), findsOneWidget);
      final badge =
          tester.widget<WorkStatusBadge>(find.byType(WorkStatusBadge));
      expect(badge.status, DocumentStatus.posted);
      expect(badge.status?.semanticColor, AppColors.success);
    });

    testWidgets('تدعم العرض اليدوي عبر label وbackgroundColor', (tester) async {
      _setTestSurfaceSize(tester, const Size(800, 600));
      await tester.pumpWidget(
        _wrap(
          child: const WorkStatusBadge(
            label: 'حالة يدوية',
            backgroundColor: AppColors.primary,
            icon: Icons.info,
          ),
          rtl: true,
          surfaceSize: const Size(800, 600),
        ),
      );
      expect(find.text('حالة يدوية'), findsOneWidget);
    });

    testWidgets('الوضع المضغوط يخفض حجم النص والأيقونة', (tester) async {
      _setTestSurfaceSize(tester, const Size(800, 600));
      await tester.pumpWidget(
        _wrap(
          child: const WorkStatusBadge(
              status: DocumentStatus.draft, compact: true),
          rtl: true,
          surfaceSize: const Size(800, 600),
        ),
      );
      final badge =
          tester.widget<WorkStatusBadge>(find.byType(WorkStatusBadge));
      expect(badge.compact, isTrue);
      expect(find.byType(FittedBox), findsOneWidget);
    });

    testWidgets('تتطلب الحالة أو (label مع اللون) في وضع التصميم',
        (tester) async {
      _setTestSurfaceSize(tester, const Size(800, 600));
      expect(
        () => WorkStatusBadge(label: 'بدون لون', backgroundColor: null),
        throwsAssertionError,
      );
    });
  });

  group('WorkDataGrid', () {
    final columnText = WorkDataGridColumn<String>(
        key: 'name', label: 'الاسم', builder: (e) => Text(e));
    final columnNumber = WorkDataGridColumn<String>(
        key: 'amount',
        label: 'المبلغ',
        format: DataGridCellFormat.number,
        builder: (e) => Text('100'));

    testWidgets('تعرض الأعمدة والصفوف', (tester) async {
      _setTestSurfaceSize(tester, const Size(800, 600));
      final entities = [
        const WorkDataGridEntity(id: 'R1', entity: 'صف واحد'),
        const WorkDataGridEntity(id: 'R2', entity: 'صف اثنان'),
      ];
      await tester.pumpWidget(
        _wrap(
          child: WorkDataGrid<String>(columns: [columnText], entities: []),
          rtl: true,
          surfaceSize: const Size(800, 600),
        ),
      );
      await tester.pumpWidget(
        _wrap(
          child:
              WorkDataGrid<String>(columns: [columnText], entities: entities),
          rtl: true,
          surfaceSize: const Size(800, 600),
        ),
      );
      expect(find.text('الاسم'), findsOneWidget);
      expect(find.text('صف واحد'), findsOneWidget);
      expect(find.text('صف اثنان'), findsOneWidget);
    });

    testWidgets('تعرض حالة الفراغ عند غياب الصفوف', (tester) async {
      _setTestSurfaceSize(tester, const Size(800, 600));
      await tester.pumpWidget(
        _wrap(
          child: WorkDataGrid<String>(columns: [columnText], entities: []),
          rtl: true,
          surfaceSize: const Size(800, 600),
        ),
      );
      expect(find.text('لا توجد سجلات.'), findsOneWidget);
    });

    testWidgets('تستدعي onSelect عند النقر على صف', (tester) async {
      _setTestSurfaceSize(tester, const Size(800, 600));
      WorkDataGridEntity<String>? tapped;
      final entities = [const WorkDataGridEntity(id: 'R1', entity: 'صف واحد')];
      await tester.pumpWidget(
        _wrap(
          child: WorkDataGrid<String>(
            columns: [columnText],
            entities: entities,
            onSelect: (entity) => tapped = entity,
          ),
          rtl: true,
          surfaceSize: const Size(800, 600),
        ),
      );
      await tester.tap(find.text('صف واحد'));
      expect(tapped?.id, 'R1');
    });

    testWidgets('تستدعي onSort عند النقر على رأس عمود قابل للفرز',
        (tester) async {
      _setTestSurfaceSize(tester, const Size(800, 600));
      (String, bool)? sorted;
      await tester.pumpWidget(
        _wrap(
          child: WorkDataGrid<String>(
            columns: [columnText],
            entities: const [],
            onSort: (value) => sorted = value,
          ),
          rtl: true,
          surfaceSize: const Size(800, 600),
        ),
      );
      await tester.tap(find.text('الاسم'));
      expect(sorted, equals(('name', true)));
    });

    testWidgets('تعرض مؤشر الفرز للعمود النشط', (tester) async {
      _setTestSurfaceSize(tester, const Size(800, 600));
      await tester.pumpWidget(
        _wrap(
          child: WorkDataGrid<String>(
            columns: [columnText],
            entities: [],
            sortKey: 'name',
            sortAscending: true,
          ),
          rtl: true,
          surfaceSize: const Size(800, 600),
        ),
      );
      expect(find.byIcon(Icons.keyboard_arrow_up), findsOneWidget);
    });

    testWidgets('تعرض عمود الاختيار عند طلب showSelection', (tester) async {
      _setTestSurfaceSize(tester, const Size(800, 600));
      final entities = [const WorkDataGridEntity(id: 'R1', entity: 'صف واحد')];
      await tester.pumpWidget(
        _wrap(
          child: WorkDataGrid<String>(
            columns: [columnText],
            entities: entities,
            showSelection: true,
          ),
          rtl: true,
          surfaceSize: const Size(800, 600),
        ),
      );
      expect(find.byType(Checkbox), findsOneWidget);
    });

    testWidgets('الأرقام تتحاذى يمينًا في RTL ويسارًا في LTR', (tester) async {
      _setTestSurfaceSize(tester, const Size(800, 600));
      await tester.pumpWidget(
        _wrap(
          child: WorkDataGrid<String>(
            columns: [columnNumber],
            entities: [],
          ),
          rtl: true,
          surfaceSize: const Size(800, 600),
        ),
      );
      // الأعمدة العددية تتحاذى نهاية الاتجاه (يمين في RTL).
      // Row الأول هو صف الرأس الرئيسي؛ عمود 'المبلغ' يتحاذى عبر صفوف
      // العمود الفرعية داخل خلاياه.
      final rows = tester
          .widgetList<Row>(find.descendant(
            of: find.byType(WorkDataGrid<String>).first,
            matching: find.byType(Row),
          ))
          .toList(growable: false);
      expect(rows.skip(1).first.mainAxisAlignment, MainAxisAlignment.end);
    });
  });

  group('WorkFilterBar', () {
    final options = [
      const WorkFilterOption(id: 'all', status: DocumentStatus.draft),
      const WorkFilterOption(id: 'posted', status: DocumentStatus.posted),
    ];

    testWidgets('تعرض خيارات الفلتر كنصوص عند العرض الواسع', (tester) async {
      _setTestSurfaceSize(tester, const Size(800, 600));
      await tester.pumpWidget(
        _wrap(
          child: WorkFilterBar(
            options: options,
            selectedOptionId: 'posted',
            narrowBreakpoint: 600,
          ),
          rtl: true,
          surfaceSize: const Size(800, 600),
        ),
      );
      expect(find.text('مسودة'), findsOneWidget);
      expect(find.text('مرحّلة'), findsOneWidget);
      expect(find.byType(FilterChip), findsNWidgets(2));
    });

    testWidgets('تستدعي onSelectOption عند اختيار فلتر', (tester) async {
      _setTestSurfaceSize(tester, const Size(800, 600));
      String? selected;
      await tester.pumpWidget(
        _wrap(
          child: WorkFilterBar(
            options: options,
            onSelectOption: (id) => selected = id,
            narrowBreakpoint: 600,
          ),
          rtl: true,
          surfaceSize: const Size(800, 600),
        ),
      );
      await tester.tap(find.text('مسودة'));
      await tester.pumpAndSettle();
      expect(selected, 'all');
    });

    testWidgets('تستدعي onSearchChanged عند الكتابة', (tester) async {
      _setTestSurfaceSize(tester, const Size(800, 600));
      String? query;
      await tester.pumpWidget(
        _wrap(
          child: WorkFilterBar(
            options: options,
            onSearchChanged: (text) => query = text,
            narrowBreakpoint: 600,
          ),
          rtl: true,
          surfaceSize: const Size(800, 600),
        ),
      );
      await tester.enterText(find.byType(TextField), 'فاتورة 1');
      expect(query, 'فاتورة 1');
    });

    testWidgets('تعرض زر التصدير عند توفير onExportRequested', (tester) async {
      _setTestSurfaceSize(tester, const Size(800, 600));
      var exported = false;
      await tester.pumpWidget(
        _wrap(
          child: WorkFilterBar(
            options: options,
            onExportRequested: () => exported = true,
            narrowBreakpoint: 600,
          ),
          rtl: true,
          surfaceSize: const Size(800, 600),
        ),
      );
      await tester.tap(find.byIcon(Icons.download_rounded));
      expect(exported, isTrue);
    });

    testWidgets('تطوي النصوص إلى أيقونات عند العرض الضيق', (tester) async {
      _setTestSurfaceSize(tester, const Size(480, 800));
      await tester.pumpWidget(
        _wrap(
          child: WorkFilterBar(
            options: options,
            narrowBreakpoint: 600,
          ),
          rtl: true,
          surfaceSize: const Size(480, 800),
        ),
      );
      // عند ضيق العرض تُعرض الأيقونات بدل النصوص داخل الشرائح.
      final chips = tester.widgetList<FilterChip>(find.byType(FilterChip));
      expect(chips.length, 2);
      final chip = chips.first.label;
      expect(chip, isA<Icon>());
    });
  });

  group('WorkAuditTimeline', () {
    final entries = [
      AuditEntry(
        type: AuditEventType.created,
        operatorName: 'أحمد المحاسب',
        occurredAt: DateTime(2026, 1, 1),
      ),
      AuditEntry(
        type: AuditEventType.posted,
        operatorName: 'سارة المدققة',
        occurredAt: DateTime(2026, 1, 2),
        reason: 'تم الترحيل بعد الاعتماد',
        referenceId: 'INV-42',
      ),
    ];

    testWidgets('تعرض الأحداث مرتبة من الأحدث إلى الأقدم', (tester) async {
      _setTestSurfaceSize(tester, const Size(800, 600));
      final items =
          entries.map((e) => WorkAuditTimelineItem(entry: e)).toList();
      await tester.pumpWidget(
        _wrap(
          child: WorkAuditTimeline(items: items),
          rtl: true,
          surfaceSize: const Size(800, 600),
        ),
      );
      // الترحيل (الأحدث) يظهر قبل الإنشاء في الترتيب البصري.
      final postedFinder = find.text('سارة المدققة');
      final createdFinder = find.text('أحمد المحاسب');
      final postedIndex = tester.getTopLeft(postedFinder).dy;
      final createdIndex = tester.getTopLeft(createdFinder).dy;
      expect(postedIndex, lessThan(createdIndex));
    });

    testWidgets('تعرض التفسير والوثيقة المرتبطة عند توفرهما', (tester) async {
      _setTestSurfaceSize(tester, const Size(800, 600));
      final items =
          entries.map((e) => WorkAuditTimelineItem(entry: e)).toList();
      await tester.pumpWidget(
        _wrap(
          child: WorkAuditTimeline(items: items),
          rtl: true,
          surfaceSize: const Size(800, 600),
        ),
      );
      expect(find.text('تم الترحيل بعد الاعتماد'), findsOneWidget);
      expect(find.textContaining('الوثيقة المرتبطة'), findsOneWidget);
    });

    testWidgets('تستدعي onReferenceTap عند النقر على الوثيقة المرتبطة',
        (tester) async {
      _setTestSurfaceSize(tester, const Size(800, 600));
      var tapped = false;
      final items = entries
          .map((e) => WorkAuditTimelineItem(
              entry: e, onReferenceTap: () => tapped = true))
          .toList();
      await tester.pumpWidget(
        _wrap(
          child: WorkAuditTimeline(items: items),
          rtl: true,
          surfaceSize: const Size(800, 600),
        ),
      );
      await tester.tap(find.textContaining('الوثيقة المرتبطة'));
      expect(tapped, isTrue);
    });

    testWidgets('تعرض حالة الفراغ عند غياب الأحداث', (tester) async {
      _setTestSurfaceSize(tester, const Size(800, 600));
      await tester.pumpWidget(
        _wrap(
          child: const WorkAuditTimeline(items: []),
          rtl: true,
          surfaceSize: const Size(800, 600),
        ),
      );
      expect(find.text('لا توجد أحداث للتدقيق.'), findsOneWidget);
    });

    testWidgets('تعرض عنوان السجل عند توفيره', (tester) async {
      _setTestSurfaceSize(tester, const Size(800, 600));
      await tester.pumpWidget(
        _wrap(
          child: const WorkAuditTimeline(items: [], title: 'سجل التدقيق'),
          rtl: true,
          surfaceSize: const Size(800, 600),
        ),
      );
      expect(find.text('سجل التدقيق'), findsOneWidget);
    });
  });

  group('Work layer — EN locale', () {
    testWidgets('WorkStatusBadge تُظهر "Posted" في الإنجليزية', (tester) async {
      await tester.pumpWidget(
        _wrap(
          child: const WorkStatusBadge(status: DocumentStatus.posted),
          rtl: false,
          surfaceSize: const Size(800, 600),
        ),
      );
      expect(find.text('Posted'), findsOneWidget);
      expect(find.text('مرحّلة'), findsNothing);
    });

    testWidgets('WorkStatusBadge تُظهر "Draft" و"Cancelled" بالإنجليزية',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          child: const WorkStatusBadge(status: DocumentStatus.cancelled),
          rtl: false,
          surfaceSize: const Size(800, 600),
        ),
      );
      expect(find.text('Cancelled'), findsOneWidget);
    });

    testWidgets('WorkDataGrid تُظهر "No records." وحالة الفرز بالإنجليزية',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          child: WorkDataGrid<Map<String, Object>>(
            columns: [
              WorkDataGridColumn<Map<String, Object>>(
                key: 'amount',
                label: 'Amount',
                format: DataGridCellFormat.number,
                flex: 1,
                sortable: true,
                builder: (e) => Text(e['amount'].toString()),
              ),
            ],
            entities: const [],
          ),
          rtl: false,
          surfaceSize: const Size(800, 600),
        ),
      );
      expect(find.text('No records found.'), findsOneWidget);
    });

    testWidgets('WorkFilterBar تُظهر بحث وتصدير بالإنجليزية', (tester) async {
      _setTestSurfaceSize(tester, const Size(800, 600));
      await tester.pumpWidget(
        _wrap(
          child: WorkFilterBar(
            options: [
              WorkFilterOption(status: DocumentStatus.draft, id: 'draft')
            ],
            selectedOptionId: 'draft',
            narrowBreakpoint: 600,
          ),
          rtl: false,
          surfaceSize: const Size(800, 600),
        ),
      );
      expect(find.text('Draft'), findsOneWidget);
      expect(find.byType(FilterChip), findsOneWidget);
    });

    testWidgets('WorkAuditTimeline تُظهر أحداث التدقيق بالإنجليزية',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          child: WorkAuditTimeline(
            items: [
              WorkAuditTimelineItem(
                entry: AuditEntry(
                  type: AuditEventType.created,
                  operatorName: 'Alice',
                  occurredAt: DateTime(2026, 8, 13, 10, 0, 0),
                ),
              ),
            ],
          ),
          rtl: false,
          surfaceSize: const Size(800, 600),
        ),
      );
      // ترجمة الحدث «أنشأ» في الإنجليزية.
      expect(find.byType(WorkAuditTimeline), findsOneWidget);
      expect(find.text('Created'), findsOneWidget);
    });
  });
}
