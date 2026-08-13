/// خدمة معاينة أثر فاتورة البيع قبل الترحيل.
///
/// هذه الخدمة لا تحفظ أو ترحل شيئًا. وهي تحوّل عقد [DocumentDraft] إلى
/// [PostingPreview] يتوافق مع بنية قيد البيع الحالية: مدين ذمم، دائن إيراد،
/// ودائن ضريبة قيمة مضافة عند وجودها.
library;

import 'package:basir_accounting_system/core/domain/contracts/index.dart';

/// ينشئ معاينات الأثر لرحلة فاتورة البيع.
class InvoicePostingPreviewService {
  /// ينشئ خدمة معاينة عديمة الحالة قابلة لإعادة الاستخدام.
  const InvoicePostingPreviewService();

  /// رمز فشل مستخدم عندما لا تحتوي المسودة على بنود قابلة للترحيل.
  static const invalidDraftCode = 'invalid-sales-draft';

  /// رمز فشل مستخدم عندما يستدعي التدفق معاينته بنوع وثيقة غير مدعوم.
  static const unsupportedDocumentCode = 'unsupported-sales-document';

  /// ينشئ أثر فاتورة البيع دون كتابة أي قيد أو تغيير للمخزون.
  ///
  /// القرار النهائي للحسابات الفعلية، وفترة الترحيل المفتوحة، وسعر الصرف
  /// يبقى لخدمة المحاسبة عند التأكيد. الوصف هنا يوضح أثر القيد المتوقع الذي
  /// ستبنيه خدمة المحاسبة الحالية.
  OperationResult<PostingPreview> previewSalesDocument({
    required DocumentDraft draft,
    required String customerName,
  }) {
    if (draft.documentType != 'sales_invoice') {
      return const OperationResult.failure(message: unsupportedDocumentCode);
    }
    if (!draft.isSaveable) {
      return const OperationResult.failure(message: invalidDraftCode);
    }

    final lines = <PostingImpactLine>[
      PostingImpactLine(
        kind: PostingImpactKind.partnerBalance,
        direction: PostingDirection.debit,
        description: 'Receivable - $customerName',
        amount: draft.grandTotal,
        currencyCode: draft.currencyCode,
      ),
      PostingImpactLine(
        kind: PostingImpactKind.ledgerEntry,
        direction: PostingDirection.credit,
        description: 'Sales revenue',
        amount: draft.subTotal,
        currencyCode: draft.currencyCode,
      ),
      if (draft.taxTotal > 0)
        PostingImpactLine(
          kind: PostingImpactKind.taxLiability,
          direction: PostingDirection.credit,
          description: 'VAT liability',
          amount: draft.taxTotal,
          currencyCode: draft.currencyCode,
        ),
    ];

    return OperationResult.success(
      value: PostingPreview(
        documentId: draft.id,
        lines: lines,
        notes:
            'Estimated sales posting; account resolution occurs on confirmation.',
      ),
    );
  }
}
