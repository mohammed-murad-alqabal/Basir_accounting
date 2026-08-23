import 'package:basir_accounting_system/core/domain/contracts/document_draft.dart';
import 'package:basir_accounting_system/core/domain/contracts/posting_preview.dart';
import 'package:basir_accounting_system/core/theme/app_theme.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:basir_accounting_system/shared/widgets/document_editor/document_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders desktop and compact invoice editor layouts',
      (tester) async {
    final draft = _createSaveableDraft();

    await tester.binding.setSurfaceSize(const Size(1280, 900));
    await tester.pumpWidget(
      _testApp(
        draft: draft,
        onSaveDraftRequested: () {},
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('documentEditorDesktopLayout')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('documentEditorCompactLayout')),
      findsNothing,
    );
    expect(
      find.byKey(const Key('summaryRailPreviewAction')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('summaryRailSaveDraftAction')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('summaryRailPostAction')),
      findsOneWidget,
    );

    await tester.binding.setSurfaceSize(const Size(390, 844));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('documentEditorCompactLayout')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('documentEditorDesktopLayout')),
      findsNothing,
    );
  });

  testWidgets('compact editor does not overflow at phone viewport',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    await tester.pumpWidget(
      _testApp(
        draft: _createSaveableDraft(),
        onSaveDraftRequested: () {},
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(
      find.byKey(const Key('documentEditorCompactLayout')),
      findsOneWidget,
    );
  });

  testWidgets('keeps posting disabled until a preview exists', (tester) async {
    final draft = _createSaveableDraft();
    var previewRequests = 0;
    var saveRequests = 0;
    var postRequests = 0;

    await tester.binding.setSurfaceSize(const Size(390, 844));
    await tester.pumpWidget(
      _testApp(
        draft: draft,
        onPreviewRequested: () => previewRequests++,
        onSaveDraftRequested: () => saveRequests++,
        onPostRequested: () => postRequests++,
      ),
    );
    await tester.pumpAndSettle();

    final postButton = tester.widget<FilledButton>(
      find.byKey(const Key('summaryRailPostAction')),
    );
    expect(postButton.onPressed, isNull);

    await tester.ensureVisible(
      find.byKey(const Key('summaryRailPreviewAction')),
    );
    await tester.tap(find.byKey(const Key('summaryRailPreviewAction')));
    await tester.ensureVisible(
      find.byKey(const Key('summaryRailSaveDraftAction')),
    );
    await tester.tap(find.byKey(const Key('summaryRailSaveDraftAction')));
    await tester.pump();

    expect(previewRequests, 1);
    expect(saveRequests, 1);
    expect(postRequests, 0);
  });

  testWidgets('enables posting only after a valid preview is supplied',
      (tester) async {
    final draft = _createSaveableDraft();
    var postRequests = 0;

    await tester.binding.setSurfaceSize(const Size(390, 1400));
    await tester.pumpWidget(
      _testApp(
        draft: draft,
        preview: _createPreview(draft),
        onPostRequested: () => postRequests++,
      ),
    );
    await tester.pumpAndSettle();

    final postButton = tester.widget<FilledButton>(
      find.byKey(const Key('summaryRailPostAction')),
    );
    expect(postButton.onPressed, isNotNull);

    await tester.ensureVisible(
      find.byKey(const Key('summaryRailPostAction')),
    );
    await tester.tap(find.byKey(const Key('summaryRailPostAction')));
    expect(postRequests, 1);
  });
}

Widget _testApp({
  required DocumentDraft draft,
  PostingPreview? preview,
  VoidCallback? onPreviewRequested,
  VoidCallback? onSaveDraftRequested,
  VoidCallback? onPostRequested,
}) =>
    MaterialApp(
      theme: AppTheme.lightTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('ar'),
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: DocumentEditor(
            draft: draft,
            preview: preview,
            header: const SizedBox(
              height: 180,
              child: Text('بيانات الفاتورة'),
            ),
            lineItems: const SizedBox(
              height: 280,
              child: Text('بنود الفاتورة'),
            ),
            onPreviewRequested: onPreviewRequested,
            onSaveDraftRequested: onSaveDraftRequested,
            onPostRequested: onPostRequested,
          ),
        ),
      ),
    );

DocumentDraft _createSaveableDraft() => DocumentDraft(
      id: 'uiux-invoice-draft',
      documentType: 'sales_invoice',
      currencyCode: 'SAR',
      lines: const [
        DraftLineItem(
          id: 'line-1',
          description: 'صنف تجريبي',
          quantity: 2,
          unitPrice: 100,
        ),
      ],
    );

PostingPreview _createPreview(DocumentDraft draft) => PostingPreview(
      documentId: draft.id,
      lines: const [],
    );
