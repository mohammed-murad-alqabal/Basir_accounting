/// هيكل محرر الوثيقة المتجاوب لنظام بصير.
///
/// يعرض رأس المستند وبنوده وملخصه ضمن تخطيط موحد، فيما تبقى سياسات المجال
/// وعمليات الحفظ والترحيل في الطبقة المستدعية.
library;

import 'package:basir_accounting_system/core/domain/contracts/index.dart';
import 'package:basir_accounting_system/core/theme/tokens/spacing.dart';
import 'package:basir_accounting_system/shared/widgets/document_editor/summary_rail.dart';
import 'package:flutter/material.dart';

/// محرر وثيقة بثلاث مناطق في سطح المكتب وتسلسل رأسي مريح على الشاشات الضيقة.
class DocumentEditor extends StatelessWidget {
  /// ينشئ محررًا من رأس وبنود ومسودة وإجراءات صريحة.
  const DocumentEditor({
    required this.draft,
    required this.header,
    required this.lineItems,
    super.key,
    this.preview,
    this.onPreviewRequested,
    this.onSaveDraftRequested,
    this.onPostRequested,
    this.desktopBreakpoint = 960,
  });

  /// المسودة التي تزود لوحة الملخص بالإجماليات وحالة الجاهزية.
  final DocumentDraft draft;

  /// منطقة بيانات المستند (العميل، التاريخ، الفرع، الملاحظات).
  final Widget header;

  /// منطقة إدخال وعرض بنود المستند.
  final Widget lineItems;

  /// الأثر المتوقع الذي تنتجه خدمة المجال قبل الترحيل.
  final PostingPreview? preview;

  /// طلب معاينة الأثر من طبقة التطبيق.
  final VoidCallback? onPreviewRequested;

  /// حفظ المسودة بلا أثر محاسبي.
  final VoidCallback? onSaveDraftRequested;

  /// تأكيد الترحيل بعد معاينة صحيحة.
  final VoidCallback? onPostRequested;

  /// الحد الأدنى لعرض التخطيط ثلاثي المناطق.
  final double desktopBreakpoint;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final summary = SummaryRail(
            draft: draft,
            preview: preview,
            onPreviewRequested: onPreviewRequested,
            onSaveDraftRequested: onSaveDraftRequested,
            onPostRequested: onPostRequested,
          );
          final primaryContent = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              header,
              const SizedBox(height: Spacing.lg),
              lineItems,
            ],
          );

          if (constraints.maxWidth >= desktopBreakpoint) {
            return Row(
              key: const Key('documentEditorDesktopLayout'),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: primaryContent),
                const SizedBox(width: Spacing.lg),
                SizedBox(width: 320, child: summary),
              ],
            );
          }

          return SingleChildScrollView(
            child: Column(
              key: const Key('documentEditorCompactLayout'),
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                primaryContent,
                const SizedBox(height: Spacing.lg),
                summary,
              ],
            ),
          );
        },
      );
}
