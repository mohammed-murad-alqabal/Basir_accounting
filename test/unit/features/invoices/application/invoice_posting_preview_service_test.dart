/// اختبارات خدمة معاينة أثر فاتورة البيع قبل الترحيل.
library;

import 'package:basir_accounting_system/core/domain/contracts/index.dart';
import 'package:basir_accounting_system/features/invoices/application/invoice_posting_preview_service.dart';
import 'package:flutter_test/flutter_test.dart';

final _validDraft = DocumentDraft(
  id: 'sale-draft-1',
  documentType: 'sales_invoice',
  currencyCode: 'SAR',
  updatedAt: DateTime(2026, 8, 13),
  lines: const [
    DraftLineItem(
      id: 'line-1',
      description: 'اشتراك سنوي',
      quantity: 2,
      unitPrice: 100,
    ),
  ],
);

void main() {
  const service = InvoicePostingPreviewService();

  group('InvoicePostingPreviewService', () {
    test('ينتج قيد بيع متوازنًا بذمة وإيراد وضريبة من مسودة صحيحة', () {
      final result = service.previewSalesDocument(
        draft: _validDraft,
        customerName: 'شركة بصير',
      );

      expect(result.success, isTrue);
      final preview = result.getOrThrow();
      expect(preview.documentId, 'sale-draft-1');
      expect(preview.lines, hasLength(3));
      expect(preview.lines.first.kind, PostingImpactKind.partnerBalance);
      expect(preview.lines.first.direction, PostingDirection.debit);
      expect(preview.lines.first.amount, 230);
      expect(preview.lines[1].kind, PostingImpactKind.ledgerEntry);
      expect(preview.lines[1].direction, PostingDirection.credit);
      expect(preview.lines[1].amount, 200);
      expect(preview.lines[2].kind, PostingImpactKind.taxLiability);
      expect(preview.lines[2].amount, 30);
    });

    test('يرفض طلب معاينة لمسودة لا تحتوي بنودًا قابلة للترحيل', () {
      final emptyDraft = DocumentDraft(
        id: 'empty',
        documentType: 'sales_invoice',
        currencyCode: 'SAR',
        updatedAt: DateTime(2026, 8, 13),
      );

      final result = service.previewSalesDocument(
        draft: emptyDraft,
        customerName: 'شركة بصير',
      );

      expect(result.success, isFalse);
      expect(result.message, InvoicePostingPreviewService.invalidDraftCode);
    });

    test('يرفض مسودة ليست فاتورة بيع كي لا يطبّق قيدًا خاطئًا', () {
      final purchaseDraft = DocumentDraft(
        id: 'purchase-draft-1',
        documentType: 'purchase_invoice',
        currencyCode: 'SAR',
        updatedAt: DateTime(2026, 8, 13),
        lines: _validDraft.lines,
      );

      final result = service.previewSalesDocument(
        draft: purchaseDraft,
        customerName: 'شركة بصير',
      );

      expect(result.success, isFalse);
      expect(
        result.message,
        InvoicePostingPreviewService.unsupportedDocumentCode,
      );
    });
  });
}
