/// اختبارات محرر الوثيقة المشترك: RTL/LTR، الملخص، المعاينة، والإجراءات.
library;

import 'package:basir_accounting_system/core/domain/contracts/index.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:basir_accounting_system/shared/widgets/document_editor/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap({required Widget child, required Locale locale}) => MaterialApp(
      locale: locale,
      supportedLocales: const [Locale('ar'), Locale('en')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Scaffold(body: child),
    );

final _draft = DocumentDraft(
  id: 'draft-1',
  documentType: 'sales_invoice',
  currencyCode: 'SAR',
  updatedAt: DateTime(2026, 8, 13),
  lines: const [
    DraftLineItem(
      id: 'line-1',
      description: 'خدمة استشارية',
      quantity: 2,
      unitPrice: 100,
    ),
  ],
);

const _preview = PostingPreview(
  documentId: 'draft-1',
  requiresAdditionalApproval: true,
  approvalReason: 'تجاوز الحد الائتماني',
  lines: [
    PostingImpactLine(
      kind: PostingImpactKind.ledgerEntry,
      direction: PostingDirection.debit,
      description: 'ذمم العملاء',
      amount: 230,
    ),
    PostingImpactLine(
      kind: PostingImpactKind.taxLiability,
      direction: PostingDirection.credit,
      description: 'ضريبة القيمة المضافة',
      amount: 30,
    ),
  ],
);

void main() {
  group('SummaryRail', () {
    testWidgets('يعرض إجماليات المسودة وإجراء طلب المعاينة بالعربية',
        (tester) async {
      var previewRequests = 0;
      await tester.pumpWidget(
        _wrap(
          locale: const Locale('ar'),
          child: SummaryRail(
            draft: _draft,
            onPreviewRequested: () => previewRequests += 1,
          ),
        ),
      );

      expect(find.text('ملخص المستند'), findsOneWidget);
      expect(find.text('230.00 SAR'), findsOneWidget);
      expect(find.byKey(const Key('summaryRailPreviewAction')), findsOneWidget);
      await tester.tap(find.byKey(const Key('summaryRailPreviewAction')));
      expect(previewRequests, 1);
    });

    testWidgets('يعرض أثر الترحيل والتحذير ويتيح التأكيد عند وجود المعاينة',
        (tester) async {
      var postRequests = 0;
      await tester.pumpWidget(
        _wrap(
          locale: const Locale('ar'),
          child: SummaryRail(
            draft: _draft,
            preview: _preview,
            onPostRequested: () => postRequests += 1,
          ),
        ),
      );

      expect(find.text('معاينة الأثر'), findsOneWidget);
      expect(find.text('تجاوز الحد الائتماني'), findsOneWidget);
      expect(find.textContaining('ذمم العملاء'), findsOneWidget);
      expect(find.byKey(const Key('summaryRailPostAction')), findsOneWidget);
      await tester.tap(find.byKey(const Key('summaryRailPostAction')));
      expect(postRequests, 1);
    });

    testWidgets('يعطل إجراء الترحيل قبل معاينة أثر صحيحة', (tester) async {
      await tester.pumpWidget(
        _wrap(
          locale: const Locale('ar'),
          child: SummaryRail(draft: _draft),
        ),
      );

      final action = tester.widget<FilledButton>(
        find.byKey(const Key('summaryRailPostAction')),
      );
      expect(action.onPressed, isNull);
    });
  });

  group('DocumentEditor', () {
    testWidgets('يبني مناطق الرأس والبنود والملخص على سطح المكتب',
        (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        _wrap(
          locale: const Locale('ar'),
          child: DocumentEditor(
            draft: _draft,
            header: const Text('بيانات الفاتورة'),
            lineItems: const Text('بنود البيع'),
          ),
        ),
      );

      expect(find.text('بيانات الفاتورة'), findsOneWidget);
      expect(find.text('بنود البيع'), findsOneWidget);
      expect(find.byType(SummaryRail), findsOneWidget);
      expect(
        find.byKey(const Key('documentEditorDesktopLayout')),
        findsOneWidget,
      );
    });

    testWidgets('يعرض نصوصه بالإنجليزية في واجهة LTR', (tester) async {
      await tester.pumpWidget(
        _wrap(
          locale: const Locale('en'),
          child: DocumentEditor(
            draft: _draft,
            header: const Text('Invoice details'),
            lineItems: const Text('Sales lines'),
          ),
        ),
      );

      expect(find.text('Document summary'), findsOneWidget);
      expect(find.text('Request preview'), findsOneWidget);
    });
  });

  group('EntityPicker', () {
    testWidgets('يعرض الخيار المحدد ولا يسمح باختيار كيان غير مؤهل',
        (tester) async {
      String? selected;
      await tester.pumpWidget(
        _wrap(
          locale: const Locale('ar'),
          child: EntityPicker(
            label: 'العميل',
            hint: 'اختر العميل',
            selectedId: 'customer-1',
            options: const [
              EntityPickerOption(id: 'customer-1', label: 'شركة بصير'),
              EntityPickerOption(
                id: 'customer-2',
                label: 'عميل موقوف',
                enabled: false,
                disabledReason: 'الحساب موقوف',
              ),
            ],
            onChanged: (option) => selected = option?.id,
          ),
        ),
      );

      expect(find.text('شركة بصير'), findsOneWidget);
      await tester.tap(find.byKey(const Key('entityPickerInput')));
      await tester.pumpAndSettle();
      expect(find.text('الحساب موقوف'), findsOneWidget);
      await tester.tap(find.text('شركة بصير').last);
      expect(selected, 'customer-1');
    });
  });
}
