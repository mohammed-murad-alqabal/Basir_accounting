import 'package:basir_accounting_system/features/accounting/domain/entities/accounting_agent.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/journal_entry.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice_type.dart';
import 'package:basir_accounting_system/features/reports/application/pdf_generation_service.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/invoice_fixtures.dart';

void main() {
  final service = PdfGenerationService();
  final timestamp = DateTime.utc(2025, 6, 15, 10);

  JournalEntry entryFor(JournalEntryStatus status) => JournalEntry(
        id: 'je-pdf-${status.name}',
        referenceNumber: 'JE-PDF-2025-001',
        date: DateTime.utc(2025, 6, 15),
        temporal: TemporalJustification(
          transactionDate: DateTime.utc(2025, 6, 15),
          effectiveDate: DateTime.utc(2025, 6, 15),
          recordingDate: timestamp,
        ),
        standards: const StandardsJustification(
          standardReference: 'IAS 1.27',
          recognitionBasis: 'Accrual',
          measurementBasis: 'Historical cost',
        ),
        description: 'قيد اختبار لتقرير الأستاذ العام',
        status: status,
        sourceDocument: 'manual_journal',
        sourceId: 'source-pdf-1',
        createdBy: 'test.accountant',
        createdAt: timestamp,
        updatedAt: timestamp,
        lines: [
          JournalEntryLine(
            accountId: 'cash',
            accountName: 'الصندوق',
            debit: Decimal.parse('1150.00'),
            credit: Decimal.zero,
            description: 'استلام نقدي',
          ),
          JournalEntryLine(
            accountId: 'revenue',
            accountName: 'إيراد خدمات',
            debit: Decimal.zero,
            credit: Decimal.parse('1150.00'),
            description: 'إثبات الإيراد',
          ),
        ],
      );

  void expectPdf(List<int> bytes) {
    expect(bytes, hasLength(greaterThan(1000)));
    expect(bytes.take(4).toList(), equals(<int>[0x25, 0x50, 0x44, 0x46]));
  }

  group('PdfGenerationService', () {
    testWidgets('ينشئ فاتورة ضريبية صالحة ببيانات الشركة والضريبة', (
      tester,
    ) async {
      final bytes = await service.generateInvoicePdf(
        InvoiceFixtures.invoice2,
        companySettings: const {
          'companyName': 'شركة بصير للاختبارات',
          'taxNumber': '310000000000003',
        },
      );

      expectPdf(bytes);
    });

    testWidgets('ينشئ مستند فاتورة غير مبيعات مع رمز QR معطى', (tester) async {
      final invoice = InvoiceFixtures.invoice1.copyWith(
        type: InvoiceType.purchase,
        qrCode: 'ZATCA:TEST:invoice-1',
      );

      final bytes = await service.generateInvoicePdf(invoice);

      expectPdf(bytes);
    });

    testWidgets('ينشئ إيصالاً حرارياً يتضمن رقم الضريبة ورمز QR',
        (tester) async {
      final invoice = InvoiceFixtures.invoice1.copyWith(
        qrCode: 'ZATCA:THERMAL:invoice-1',
      );

      final bytes = await service.generateThermalReceipt(
        invoice,
        companySettings: const {
          'companyName': 'شركة بصير للاختبارات',
          'taxNumber': '310000000000003',
        },
      );

      expectPdf(bytes);
    });

    testWidgets('ينشئ إيصال إشعار دائن حرارياً بالإعدادات الافتراضية', (
      tester,
    ) async {
      final invoice = InvoiceFixtures.invoice1.copyWith(
        type: InvoiceType.salesReturn,
      );

      final bytes = await service.generateThermalReceipt(invoice);

      expectPdf(bytes);
    });

    testWidgets('ينشئ تقرير PDF لقيد يومية مرحّل ومتوازن', (tester) async {
      final bytes = await service.generateJournalEntryPdf(
        entryFor(JournalEntryStatus.posted),
        companySettings: const {
          'companyName': 'شركة بصير للاختبارات',
          'taxNumber': '310000000000003',
        },
      );

      expectPdf(bytes);
    });

    testWidgets('ينشئ تقرير PDF لقيد مسودة بالبيانات الافتراضية',
        (tester) async {
      final bytes = await service.generateJournalEntryPdf(
        entryFor(JournalEntryStatus.draft),
      );

      expectPdf(bytes);
    });

    testWidgets('ينشئ تقرير ذكاء لفترة بنتائج قبول واعتراض وتوصيات', (
      tester,
    ) async {
      final bytes = await service.generateIntelligenceReportPdf(
        DateTime.utc(2025),
        DateTime.utc(2025, 1, 31),
        const [
          AgentResult(
            agentId: 'standards',
            isAllowed: true,
            rationale: 'المعالجة متوافقة مع معيار الاعتراف بالإيراد.',
            confidenceScore: 0.97,
            suggestedAdjustments: {'classification': 'service_revenue'},
          ),
          AgentResult(
            agentId: 'forensic',
            isAllowed: false,
            rationale: 'يلزم إرفاق مستند مصدر إضافي.',
            confidenceScore: 0.82,
          ),
        ],
      );

      expectPdf(bytes);
    });
  });
}
