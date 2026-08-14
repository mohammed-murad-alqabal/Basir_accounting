import 'package:basir_accounting_system/core/domain/contracts/index.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/journal_entry.dart';
import 'package:basir_accounting_system/features/invoices/application/sales_invoice_posting_service.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice_status.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final recordedAt = DateTime(2026, 8, 14, 9);

  group('SalesInvoicePostingService', () {
    late _FakeSalesInvoicePostingGateway gateway;
    late SalesInvoicePostingService service;

    setUp(() {
      gateway = _FakeSalesInvoicePostingGateway();
      service = SalesInvoicePostingService(
        gateway: gateway,
        now: () => recordedAt,
      );
    });

    test('يرحل المسودة المؤكدة للمستخدم المخول ويثبت القيد وسجل التدقيق',
        () async {
      final invoice = _draftInvoice();
      final result = await service.post(
        SalesInvoicePostingRequest(
          invoice: invoice,
          preview: _previewFor(invoice),
          hasExplicitConfirmation: true,
          canPost: true,
          operatorId: 'user-1',
          operatorName: 'المحاسب الأول',
        ),
      );

      expect(result.success, isTrue);
      expect(result.value, isNotNull);
      expect(result.value!.invoice.status, InvoiceStatus.sent);
      expect(result.value!.invoice.updatedAt, recordedAt);
      expect(result.value!.journalEntry.isBalanced, isTrue);
      expect(result.value!.journalEntry.status, JournalEntryStatus.posted);
      expect(result.value!.journalEntry.auditLogs, hasLength(1));
      expect(
        result.value!.journalEntry.auditLogs.single.action,
        'INVOICE_POSTED',
      );
      expect(result.value!.journalEntry.auditLogs.single.actor, 'user-1');
      expect(gateway.committedInvoices, hasLength(1));
      expect(gateway.committedEntries, hasLength(1));
      expect(gateway.committedInvoices.single.status, InvoiceStatus.sent);
      expect(gateway.committedEntries.single.id, 'je-inv-${invoice.id}');
      expect(result.auditTrail, hasLength(2));
      expect(result.auditTrail!.map((entry) => entry.type), [
        AuditEventType.approved,
        AuditEventType.posted,
      ]);
    });

    test('يرفض الترحيل عند غياب صلاحية الترحيل ولا يكتب أي أثر', () async {
      final invoice = _draftInvoice();
      final result = await service.post(
        SalesInvoicePostingRequest(
          invoice: invoice,
          preview: _previewFor(invoice),
          hasExplicitConfirmation: true,
          canPost: false,
          operatorId: 'user-2',
          operatorName: 'مستخدم قراءة',
        ),
      );

      expect(result.success, isFalse);
      expect(result.message, SalesInvoicePostingService.unauthorizedCode);
      expect(gateway.buildCalls, isZero);
      expect(gateway.committedInvoices, isEmpty);
      expect(gateway.committedEntries, isEmpty);
    });

    test('يرفض الترحيل دون إقرار صريح بعد المعاينة ولا يكتب أي أثر', () async {
      final invoice = _draftInvoice();
      final result = await service.post(
        SalesInvoicePostingRequest(
          invoice: invoice,
          preview: _previewFor(invoice),
          hasExplicitConfirmation: false,
          canPost: true,
          operatorId: 'user-1',
          operatorName: 'المحاسب الأول',
        ),
      );

      expect(result.success, isFalse);
      expect(
        result.message,
        SalesInvoicePostingService.confirmationRequiredCode,
      );
      expect(gateway.buildCalls, isZero);
      expect(gateway.committedInvoices, isEmpty);
    });

    test('يرفض معاينة تخص وثيقة أخرى قبل بناء القيد', () async {
      final invoice = _draftInvoice();
      final result = await service.post(
        SalesInvoicePostingRequest(
          invoice: invoice,
          preview: const PostingPreview(
            documentId: 'other-document',
            lines: [
              PostingImpactLine(
                kind: PostingImpactKind.ledgerEntry,
                direction: PostingDirection.debit,
                description: 'اختبار',
                amount: 100,
              ),
            ],
          ),
          hasExplicitConfirmation: true,
          canPost: true,
          operatorId: 'user-1',
          operatorName: 'المحاسب الأول',
        ),
      );

      expect(result.success, isFalse);
      expect(result.message, SalesInvoicePostingService.previewMismatchCode);
      expect(gateway.buildCalls, isZero);
      expect(gateway.committedEntries, isEmpty);
    });

    test('يرفض القيد المتزن إذا اختلفت مبالغه عن معاينة الأثر المعتمدة',
        () async {
      final invoice = _draftInvoice();
      const inconsistentPreview = PostingPreview(
        documentId: 'inv-100',
        lines: [
          PostingImpactLine(
            kind: PostingImpactKind.partnerBalance,
            direction: PostingDirection.debit,
            description: 'ذمم مدينة',
            amount: 120,
          ),
          PostingImpactLine(
            kind: PostingImpactKind.ledgerEntry,
            direction: PostingDirection.credit,
            description: 'إيراد',
            amount: 105,
          ),
          PostingImpactLine(
            kind: PostingImpactKind.taxLiability,
            direction: PostingDirection.credit,
            description: 'ضريبة',
            amount: 15,
          ),
        ],
      );

      final result = await service.post(
        SalesInvoicePostingRequest(
          invoice: invoice,
          preview: inconsistentPreview,
          hasExplicitConfirmation: true,
          canPost: true,
          operatorId: 'user-1',
          operatorName: 'المحاسب الأول',
        ),
      );

      expect(result.success, isFalse);
      expect(result.message, SalesInvoicePostingService.invalidJournalCode);
      expect(gateway.buildCalls, 1);
      expect(gateway.committedEntries, isEmpty);
    });

    test('يرفض إعادة ترحيل فاتورة غير مسودة ويحافظ على عدم وجود كتابة',
        () async {
      final invoice = _draftInvoice(status: InvoiceStatus.sent);
      final result = await service.post(
        SalesInvoicePostingRequest(
          invoice: invoice,
          preview: _previewFor(invoice),
          hasExplicitConfirmation: true,
          canPost: true,
          operatorId: 'user-1',
          operatorName: 'المحاسب الأول',
        ),
      );

      expect(result.success, isFalse);
      expect(result.message, SalesInvoicePostingService.invalidStateCode);
      expect(gateway.buildCalls, isZero);
      expect(gateway.committedEntries, isEmpty);
    });

    test('يعيد فشلًا قابلًا للعرض إذا أخفقت المعاملة ولا يدّعي نجاحًا',
        () async {
      gateway.commitError = StateError('storage unavailable');
      final invoice = _draftInvoice();

      final result = await service.post(
        SalesInvoicePostingRequest(
          invoice: invoice,
          preview: _previewFor(invoice),
          hasExplicitConfirmation: true,
          canPost: true,
          operatorId: 'user-1',
          operatorName: 'المحاسب الأول',
        ),
      );

      expect(result.success, isFalse);
      expect(result.message, SalesInvoicePostingService.commitFailedCode);
      expect(result.cause, isA<StateError>());
      expect(gateway.committedInvoices, isEmpty);
      expect(gateway.committedEntries, isEmpty);
    });
  });
}

Invoice _draftInvoice({InvoiceStatus status = InvoiceStatus.draft}) => Invoice(
      id: 'inv-100',
      invoiceNumber: 'INV-100',
      customerId: 'customer-100',
      customerName: 'شركة الاختبار',
      items: [
        InvoiceItem(
          id: 'line-1',
          name: 'خدمة محاسبية',
          quantity: Decimal.one,
          price: Decimal.fromInt(100),
          total: Decimal.fromInt(100),
          taxAmount: Decimal.fromInt(15),
          taxRate: Decimal.parse('0.15'),
        ),
      ],
      issuedDate: DateTime(2026, 8, 14),
      dueDate: DateTime(2026, 9, 14),
      createdAt: DateTime(2026, 8, 14),
      updatedAt: DateTime(2026, 8, 14),
      status: status,
      subtotalAmount: Decimal.fromInt(100),
      taxAmount: Decimal.fromInt(15),
      discountAmount: Decimal.zero,
      totalAmount: Decimal.fromInt(115),
      paidAmount: Decimal.zero,
      taxRate: Decimal.parse('0.15'),
      discountRate: Decimal.zero,
      exchangeRate: Decimal.one,
    );

PostingPreview _previewFor(Invoice invoice) => PostingPreview(
      documentId: invoice.id,
      lines: [
        PostingImpactLine(
          kind: PostingImpactKind.partnerBalance,
          direction: PostingDirection.debit,
          description: 'ذمم مدينة',
          amount: invoice.totalAmount.toDouble(),
        ),
        PostingImpactLine(
          kind: PostingImpactKind.ledgerEntry,
          direction: PostingDirection.credit,
          description: 'إيراد',
          amount: invoice.subtotalAmount.toDouble(),
        ),
        PostingImpactLine(
          kind: PostingImpactKind.taxLiability,
          direction: PostingDirection.credit,
          description: 'ضريبة',
          amount: invoice.taxAmount.toDouble(),
        ),
      ],
    );

class _FakeSalesInvoicePostingGateway implements SalesInvoicePostingGateway {
  int buildCalls = 0;
  Error? commitError;
  final committedInvoices = <Invoice>[];
  final committedEntries = <JournalEntry>[];

  @override
  Future<JournalEntry> buildSalesJournalEntry({
    required Invoice invoice,
    required String actorId,
    required DateTime recordedAt,
  }) async {
    buildCalls += 1;
    return JournalEntry(
      id: 'je-inv-${invoice.id}',
      referenceNumber: 'JE-${invoice.id}',
      date: invoice.issuedDate,
      temporal: TemporalJustification(
        transactionDate: invoice.issuedDate,
        effectiveDate: invoice.issuedDate,
        recordingDate: recordedAt,
      ),
      standards: const StandardsJustification(
        standardReference: 'IFRS 15',
        recognitionBasis: 'Accrual',
        measurementBasis: 'Transaction Price',
      ),
      description: 'Posting sales invoice ${invoice.id}',
      status: JournalEntryStatus.posted,
      lines: [
        JournalEntryLine(
          accountId: 'acc-1201',
          accountName: 'Accounts receivable',
          debit: invoice.totalAmount,
          credit: Decimal.zero,
        ),
        JournalEntryLine(
          accountId: 'acc-4101',
          accountName: 'Sales revenue',
          debit: Decimal.zero,
          credit: invoice.subtotalAmount,
        ),
        JournalEntryLine(
          accountId: 'acc-2105',
          accountName: 'VAT',
          debit: Decimal.zero,
          credit: invoice.taxAmount,
        ),
      ],
      sourceDocument: 'invoice',
      sourceId: invoice.id,
      createdBy: actorId,
      createdAt: recordedAt,
      updatedAt: recordedAt,
      postedAt: recordedAt,
    );
  }

  @override
  Future<void> commitSalesInvoice({
    required Invoice invoice,
    required JournalEntry journalEntry,
  }) async {
    final error = commitError;
    if (error != null) {
      throw error;
    }
    committedInvoices.add(invoice);
    committedEntries.add(journalEntry);
  }
}
