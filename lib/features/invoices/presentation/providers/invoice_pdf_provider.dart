import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/invoices/application/invoice_pdf_service.dart';
import 'package:basir_accounting_system/features/invoices/application/invoice_print_service.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

/// مزود خدمة إنشاء PDF
final invoicePdfServiceProvider = Provider((ref) {
  final settings = ref.watch(settingsServiceProvider);
  final pdfGen = ref.watch(pdfGenerationServiceProvider.notifier);
  return InvoicePdfService(settings, pdfGen);
});

/// مزود خدمة الطباعة الحرارية
final invoicePrintServiceProvider = Provider((ref) {
  final settings = ref.watch(settingsServiceProvider);
  final pdfGen = ref.watch(pdfGenerationServiceProvider.notifier);
  return InvoicePrintService(settings, pdfGen);
});

/// Provider لتصدير الفاتورة كملف PDF
final exportInvoicePdfProvider = FutureProvider.family<void, Invoice>((
  ref,
  invoice,
) async {
  final pdfService = ref.read(invoicePdfServiceProvider);
  final pdfBytes = await pdfService.generateInvoicePdf(invoice);

  await Printing.layoutPdf(
    onLayout: (format) async => pdfBytes,
    name: 'invoice_${invoice.invoiceNumber}.pdf',
  );
});

/// Provider لمشاركة الفاتورة كملف PDF
final shareInvoicePdfProvider = FutureProvider.family<void, Invoice>((
  ref,
  invoice,
) async {
  final pdfService = ref.read(invoicePdfServiceProvider);
  final pdfBytes = await pdfService.generateInvoicePdf(invoice);

  await Printing.sharePdf(
    bytes: pdfBytes,
    filename: 'invoice_${invoice.invoiceNumber}.pdf',
  );
});

/// Provider لإرسال الفاتورة عبر البريد الإلكتروني (עם موضوع ونص جاهز)
final emailInvoiceProvider = FutureProvider.family<void, Invoice>((
  ref,
  invoice,
) async {
  final pdfService = ref.read(invoicePdfServiceProvider);
  final pdfBytes = await pdfService.generateInvoicePdf(invoice);

  // TODO(basir): Get company name from settings
  const companyName = 'Basir Accounting';

  await Printing.sharePdf(
    bytes: pdfBytes,
    filename: 'invoice_${invoice.invoiceNumber}.pdf',
    subject: 'Invoice #${invoice.invoiceNumber} from $companyName',
    body: 'Dear Customer,\n\n'
        'Please find attached invoice #${invoice.invoiceNumber}.\n\n'
        'Best regards,\n$companyName',
  );
});

/// Provider لطباعة إيصال حراري (POS Receipt)
final printReceiptProvider =
    FutureProvider.family<void, ({Invoice invoice, AppLocalizations l10n})>((
  ref,
  args,
) async {
  final printService = ref.read(invoicePrintServiceProvider);
  final pdfBytes = await printService.generateReceiptPdf(
    args.invoice,
    args.l10n,
  );

  await Printing.layoutPdf(
    onLayout: (format) async => pdfBytes,
    name: 'receipt_${args.invoice.invoiceNumber}.pdf',
    format: PdfPageFormat.roll80,
  );
});
