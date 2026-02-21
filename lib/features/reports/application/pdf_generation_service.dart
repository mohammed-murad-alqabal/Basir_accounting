import 'package:basir_accounting_system/features/accounting/domain/entities/accounting_agent.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/journal_entry.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice.dart'
    as domain_inv;
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice_type.dart';
import 'package:basir_accounting_system/src/rust/api/reports.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pdf_generation_service.g.dart';

/// Service responsible for generating various PDF reports.
@Riverpod(keepAlive: true)
class PdfGenerationService extends _$PdfGenerationService {
  @override
  FutureOr<void> build() {}

  /// Generates a professional A4 PDF for the given invoice.
  Future<Uint8List> generateInvoicePdf(
    domain_inv.Invoice invoice, {
    Map<String, String?>? companySettings,
  }) async {
    final pdf = pw.Document();

    final fontData = await rootBundle.load('assets/fonts/Cairo-Regular.ttf');
    final fontBoldData = await rootBundle.load('assets/fonts/Cairo-Bold.ttf');
    final ttf = pw.Font.ttf(fontData);
    final ttfBold = pw.Font.ttf(fontBoldData);

    final companyName = companySettings?['companyName'] ?? 'Basir Accounting';
    final taxNumber = companySettings?['taxNumber'] ?? '';

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(
          base: ttf,
          bold: ttfBold,
        ),
        textDirection: pw.TextDirection.rtl,
        header: (context) => _buildInvoiceHeader(
          invoice,
          companyName,
          taxNumber,
        ),
        footer: (context) => _buildInvoiceFooter(invoice, companyName),
        build: (context) => [
          _buildCustomerSection(invoice),
          pw.SizedBox(height: 20),
          _buildInvoiceItemsTable(invoice),
          pw.SizedBox(height: 20),
          _buildInvoiceTotalsAndQr(invoice, companyName, taxNumber),
        ],
      ),
    );

    return pdf.save();
  }

  /// Generates a professional PDF for a Journal Entry.
  Future<Uint8List> generateJournalEntryPdf(
    JournalEntry entry, {
    Map<String, String?>? companySettings,
  }) async {
    final pdf = pw.Document();

    final fontData = await rootBundle.load('assets/fonts/Cairo-Regular.ttf');
    final fontBoldData = await rootBundle.load('assets/fonts/Cairo-Bold.ttf');
    final ttf = pw.Font.ttf(fontData);
    final ttfBold = pw.Font.ttf(fontBoldData);

    final companyName = companySettings?['companyName'] ?? 'Basir Accounting';
    final taxNumber = companySettings?['taxNumber'] ?? '';

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(
          base: ttf,
          bold: ttfBold,
        ),
        textDirection: pw.TextDirection.rtl,
        header: (context) => _buildJeHeader(entry, companyName, taxNumber),
        footer: (context) => _buildJeFooter(entry),
        build: (context) => [
          _buildJeInfoSection(entry),
          pw.SizedBox(height: 20),
          _buildJeLinesTable(entry),
          pw.SizedBox(height: 20),
          _buildJeTotalsSection(entry),
        ],
      ),
    );

    return pdf.save();
  }

  pw.Widget _buildJeHeader(
    JournalEntry entry,
    String companyName,
    String taxNumber,
  ) =>
      pw.Column(
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    companyName,
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.blue900,
                    ),
                  ),
                  if (taxNumber.isNotEmpty)
                    pw.Text(
                      'الرقم الضريبي: $taxNumber',
                      style: const pw.TextStyle(fontSize: 9),
                    ),
                ],
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text(
                    'قيد يومية / JOURNAL ENTRY',
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.blue800,
                    ),
                  ),
                  pw.Text(
                    'المرجع: ${entry.referenceNumber}',
                    style: const pw.TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          pw.Divider(thickness: 1, color: PdfColors.grey400),
        ],
      );

  pw.Widget _buildJeInfoSection(JournalEntry entry) => pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'التاريخ: ${entry.date.toString().split(' ')[0]}',
                style: const pw.TextStyle(fontSize: 10),
              ),
              pw.Text(
                'البيان: ${entry.description}',
                style: const pw.TextStyle(fontSize: 11),
              ),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(
                'الحالة: ${entry.status.name.toUpperCase()}',
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                  color: entry.status == JournalEntryStatus.posted
                      ? PdfColors.green800
                      : PdfColors.orange800,
                ),
              ),
              pw.Text(
                'المصدر: ${entry.sourceDocument}',
                style: const pw.TextStyle(fontSize: 10),
              ),
            ],
          ),
        ],
      );

  pw.Widget _buildJeLinesTable(JournalEntry entry) =>
      pw.TableHelper.fromTextArray(
        headers: [
          'الحساب / Account',
          'مدين / Debit',
          'دائن / Credit',
          'شرح السطر / Memo',
        ],
        data: entry.lines
            .map(
              (line) => [
                line.accountName,
                if (line.debit > Decimal.zero)
                  line.debit.toStringAsFixed(2)
                else
                  '',
                if (line.credit > Decimal.zero)
                  line.credit.toStringAsFixed(2)
                else
                  '',
                line.description ?? '',
              ],
            )
            .toList(),
        headerStyle: pw.TextStyle(
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.white,
        ),
        headerDecoration: const pw.BoxDecoration(color: PdfColors.blueGrey800),
        cellAlignment: pw.Alignment.centerLeft,
        columnWidths: {
          0: const pw.FlexColumnWidth(3),
          1: const pw.FlexColumnWidth(1.5),
          2: const pw.FlexColumnWidth(1.5),
          3: const pw.FlexColumnWidth(3),
        },
      );

  pw.Widget _buildJeTotalsSection(JournalEntry entry) => pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.end,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Row(
                children: [
                  pw.Text(
                    'إجمالي المدين:',
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                  pw.SizedBox(width: 10),
                  pw.Text(
                    entry.totalDebit.toStringAsFixed(2),
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ],
              ),
              pw.Row(
                children: [
                  pw.Text(
                    'إجمالي الدائن:',
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                  pw.SizedBox(width: 10),
                  pw.Text(
                    entry.totalCredit.toStringAsFixed(2),
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ],
      );

  pw.Widget _buildJeFooter(JournalEntry entry) => pw.Column(
        children: [
          pw.Divider(thickness: 0.5),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'مدخل القيد: ${entry.createdBy}',
                style: const pw.TextStyle(
                  fontSize: 8,
                  color: PdfColors.grey700,
                ),
              ),
              pw.Text(
                'Basir Accounting | Diamond Purity Certified',
                style: const pw.TextStyle(
                  fontSize: 8,
                  color: PdfColors.grey600,
                ),
              ),
            ],
          ),
        ],
      );

  pw.Widget _buildInvoiceHeader(
    domain_inv.Invoice invoice,
    String companyName,
    String taxNumber,
  ) =>
      pw.Column(
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    companyName,
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.blue900,
                    ),
                  ),
                  if (taxNumber.isNotEmpty)
                    pw.Text(
                      'الرقم الضريبي / VAT No: $taxNumber',
                      style: const pw.TextStyle(fontSize: 10),
                    ),
                ],
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text(
                    invoice.type == InvoiceType.sales
                        ? 'فاتورة ضريبية / TAX INVOICE'
                        : 'إشعار دائن / CREDIT NOTE',
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.blue800,
                    ),
                  ),
                  pw.Text(
                    'رقم الفاتورة / Invoice #: ${invoice.invoiceNumber}',
                    style: const pw.TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          pw.Divider(thickness: 2, color: PdfColors.blue900),
        ],
      );

  pw.Widget _buildCustomerSection(domain_inv.Invoice invoice) => pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'فاتورة إلى / Bill To:',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(
                invoice.customerName,
                style: const pw.TextStyle(fontSize: 14),
              ),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(
                'تاريخ الإصدار / Date:',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(
                invoice.issuedDate.toString().split(' ')[0],
                style: const pw.TextStyle(fontSize: 12),
              ),
            ],
          ),
        ],
      );

  pw.Widget _buildInvoiceItemsTable(domain_inv.Invoice invoice) =>
      pw.TableHelper.fromTextArray(
        headers: [
          'الوصف / Description',
          'الكمية / Qty',
          'السعر / Price',
          'الضريبة / VAT',
          'المجموع / Total',
        ],
        data: invoice.items
            .map(
              (item) => [
                item.name,
                item.quantity.toString(),
                item.price.toStringAsFixed(2),
                item.taxAmount.toStringAsFixed(2),
                item.total.toStringAsFixed(2),
              ],
            )
            .toList(),
        headerStyle: pw.TextStyle(
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.white,
        ),
        headerDecoration: const pw.BoxDecoration(color: PdfColors.blue800),
        cellAlignment: pw.Alignment.center,
        columnWidths: {
          0: const pw.FlexColumnWidth(3),
          1: const pw.FlexColumnWidth(),
          2: const pw.FlexColumnWidth(1.5),
          3: const pw.FlexColumnWidth(1.5),
          4: const pw.FlexColumnWidth(2),
        },
      );

  pw.Widget _buildInvoiceTotalsAndQr(
    domain_inv.Invoice invoice,
    String companyName,
    String taxNumber,
  ) =>
      pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            width: 100,
            height: 100,
            child: pw.BarcodeWidget(
              barcode: pw.Barcode.qrCode(),
              data: invoice.qrCode ??
                  'ZATCA:$companyName:$taxNumber:${invoice.totalAmount}',
            ),
          ),
          pw.Spacer(),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              _buildTotalLine(
                'المجموع الفرعي / Subtotal:',
                invoice.subtotalAmount,
              ),
              _buildTotalLine('مجموع الضريبة (15%) / VAT:', invoice.taxAmount),
              pw.Divider(),
              pw.Text(
                'الإجمالي / GRAND TOTAL:',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                '${invoice.totalAmount.toStringAsFixed(2)} ${invoice.currency}',
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blue900,
                ),
              ),
            ],
          ),
        ],
      );

  pw.Widget _buildTotalLine(String label, Decimal amount) => pw.Row(
        mainAxisSize: pw.MainAxisSize.min,
        children: [
          pw.Text(label, style: const pw.TextStyle(fontSize: 10)),
          pw.SizedBox(width: 20),
          pw.Text(
            amount.toStringAsFixed(2),
            style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
          ),
        ],
      );

  pw.Widget _buildInvoiceFooter(
    domain_inv.Invoice invoice,
    String companyName,
  ) =>
      pw.Column(
        children: [
          pw.Divider(),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'Generated by Basir Intelligent Systems'
                ' | Diamond Purity Certified',
                style: const pw.TextStyle(
                  fontSize: 8,
                  color: PdfColors.grey600,
                ),
              ),
            ],
          ),
        ],
      );

  /// Generates a branded PDF for the given financial report.
  Future<Uint8List> generateReportPdf(FinancialReportDto report) async {
    final pdf = pw.Document();

    final fontData = await rootBundle.load('assets/fonts/Cairo-Regular.ttf');
    final fontBoldData = await rootBundle.load('assets/fonts/Cairo-Bold.ttf');
    final ttf = pw.Font.ttf(fontData);
    final ttfBold = pw.Font.ttf(fontBoldData);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(
          base: ttf,
          bold: ttfBold,
        ),
        textDirection: pw.TextDirection.rtl,
        build: (context) => [
          _buildHeader(report),
          pw.SizedBox(height: 20),
          _buildReportTable(report),
          pw.SizedBox(height: 20),
          _buildFooter(report),
        ],
      ),
    );

    return pdf.save();
  }

  /// Generates a high-fidelity thermal receipt (80mm) for the given invoice.
  Future<Uint8List> generateThermalReceipt(
    domain_inv.Invoice invoice, {
    Map<String, String?>? companySettings,
  }) async {
    final pdf = pw.Document();

    final fontData = await rootBundle.load('assets/fonts/Cairo-Regular.ttf');
    final fontBoldData = await rootBundle.load('assets/fonts/Cairo-Bold.ttf');
    final ttf = pw.Font.ttf(fontData);
    final ttfBold = pw.Font.ttf(fontBoldData);

    final companyName = companySettings?['companyName'] ?? 'Basir Accounting';
    final taxNumber = companySettings?['taxNumber'] ?? '';

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        margin: const pw.EdgeInsets.all(5 * PdfPageFormat.mm),
        theme: pw.ThemeData.withFont(
          base: ttf,
          bold: ttfBold,
        ),
        textDirection: pw.TextDirection.rtl,
        build: (context) => pw.Column(
          children: [
            pw.Text(
              companyName,
              style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
              textAlign: pw.TextAlign.center,
            ),
            if (taxNumber.isNotEmpty) ...[
              pw.SizedBox(height: 2),
              pw.Text(
                'الرقم الضريبي: $taxNumber',
                style: const pw.TextStyle(fontSize: 10),
              ),
              pw.Text(
                'VAT No: $taxNumber',
                style: const pw.TextStyle(fontSize: 8),
              ),
            ],
            pw.SizedBox(height: 5),
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(
                vertical: 2,
                horizontal: 4,
              ),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(width: 0.5),
              ),
              child: pw.Text(
                invoice.type == InvoiceType.sales
                    ? 'فاتورة ضريبية مبسطة\nSimplified Tax Invoice'
                    : 'إشعار دائن مبسط\nSimplified Credit Note',
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                ),
                textAlign: pw.TextAlign.center,
              ),
            ),
            pw.SizedBox(height: 5),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'رقم الفاتورة / Invoice No:',
                  style: const pw.TextStyle(fontSize: 8),
                ),
                pw.Text(
                  invoice.invoiceNumber,
                  style: pw.TextStyle(
                    fontSize: 8,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'التاريخ / Date:',
                  style: const pw.TextStyle(fontSize: 8),
                ),
                pw.Text(
                  invoice.issuedDate.toString().split('.')[0],
                  style: const pw.TextStyle(fontSize: 8),
                ),
              ],
            ),
            pw.Divider(thickness: 0.5),
            pw.Table(
              columnWidths: {
                0: const pw.FlexColumnWidth(3),
                1: const pw.FlexColumnWidth(),
                2: const pw.FlexColumnWidth(1.5),
              },
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(2),
                      child: pw.Text(
                        'الوصف / Description',
                        style: pw.TextStyle(
                          fontSize: 7,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(2),
                      child: pw.Text(
                        'الكمية\nQty',
                        style: pw.TextStyle(
                          fontSize: 7,
                          fontWeight: pw.FontWeight.bold,
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(2),
                      child: pw.Text(
                        'المبلغ\nAmount',
                        style: pw.TextStyle(
                          fontSize: 7,
                          fontWeight: pw.FontWeight.bold,
                        ),
                        textAlign: pw.TextAlign.right,
                      ),
                    ),
                  ],
                ),
                ...invoice.items.map(
                  (item) => pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(2),
                        child: pw.Text(
                          item.name,
                          style: const pw.TextStyle(fontSize: 8),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(2),
                        child: pw.Text(
                          item.quantity.toString(),
                          style: const pw.TextStyle(fontSize: 8),
                          textAlign: pw.TextAlign.center,
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(2),
                        child: pw.Text(
                          item.total.toString(),
                          style: const pw.TextStyle(fontSize: 8),
                          textAlign: pw.TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            pw.Divider(thickness: 1),
            _buildThermalSummaryRow(
              'الإجمالي (غير شامل الضريبة)\nTotal (Excl. VAT)',
              invoice.subtotalAmount.toString(),
            ),
            _buildThermalSummaryRow(
              'مجموع الضريبة (15%)\nTotal VAT (15%)',
              invoice.taxAmount.toString(),
            ),
            _buildThermalSummaryRow(
              'الإجمالي شامل الضريبة\nTotal (Incl. VAT)',
              invoice.totalAmount.toString(),
              isBold: true,
            ),
            pw.SizedBox(height: 10),
            if (invoice.qrCode != null)
              pw.Container(
                width: 120,
                height: 120,
                child: pw.BarcodeWidget(
                  barcode: pw.Barcode.qrCode(),
                  data: invoice.qrCode!,
                ),
              ),
            pw.SizedBox(height: 10),
            pw.Text(
              'شكراً لشرائكم من $companyName\n'
              'Thank you for choosing $companyName',
              style: const pw.TextStyle(fontSize: 8),
              textAlign: pw.TextAlign.center,
            ),
            pw.SizedBox(height: 5),
            pw.Text(
              'Certified by Basir Intelligent Systems'
              '\nDiamond Purity v1.0',
              style: const pw.TextStyle(fontSize: 6, color: PdfColors.grey600),
              textAlign: pw.TextAlign.center,
            ),
          ],
        ),
      ),
    );

    return pdf.save();
  }

  pw.Widget _buildThermalSummaryRow(
    String label,
    String value, {
    bool isBold = false,
  }) =>
      pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 2),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              label,
              style: pw.TextStyle(
                fontSize: 8,
                fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
              ),
            ),
            pw.Text(
              value,
              style: pw.TextStyle(
                fontSize: 9,
                fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
              ),
            ),
          ],
        ),
      );

  /// Generates an "Intelligence Report" summarizing agent consensus for
  /// a period.
  Future<Uint8List> generateIntelligenceReportPdf(
    DateTime from,
    DateTime to,
    List<AgentResult> results,
  ) async {
    final pdf = pw.Document();

    final fontData = await rootBundle.load('assets/fonts/Cairo-Regular.ttf');
    final fontBoldData = await rootBundle.load('assets/fonts/Cairo-Bold.ttf');
    final ttf = pw.Font.ttf(fontData);
    final ttfBold = pw.Font.ttf(fontBoldData);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(
          base: ttf,
          bold: ttfBold,
        ),
        textDirection: pw.TextDirection.rtl,
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Basir Intelligent Accounting System',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blue900,
                  ),
                ),
                pw.Text(
                  'Institutional Intelligence Report',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 5),
                pw.Text(
                  'Analysis Period: '
                  '${from.toString().split(' ')[0]} to '
                  '${to.toString().split(' ')[0]}',
                  style: const pw.TextStyle(
                    fontSize: 12,
                    color: PdfColors.grey700,
                  ),
                ),
                pw.Divider(thickness: 2, color: PdfColors.blue900),
              ],
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Text(
            'The Cognitive Hexagon: Strategic Consensus',
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 10),
          ...results.map(
            (res) => pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 15),
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey300),
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
                color: res.isAllowed ? PdfColors.green50 : PdfColors.red50,
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        res.agentId.toUpperCase(),
                        style: pw.TextStyle(
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                          color: res.isAllowed
                              ? PdfColors.green900
                              : PdfColors.red900,
                        ),
                      ),
                      pw.Text(
                        'Confidence: '
                        '${(res.confidenceScore * 100).toStringAsFixed(1)}%',
                        style: const pw.TextStyle(
                          fontSize: 10,
                          color: PdfColors.grey700,
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 5),
                  pw.Text(
                    res.rationale,
                    style: const pw.TextStyle(fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
          pw.Footer(
            trailing: pw.Text(
              'Diamond Purity Certified | Basir AI Orchestration',
              style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey500),
            ),
          ),
        ],
      ),
    );

    return pdf.save();
  }

  /// Internal helper to build the header for financial reports.
  pw.Widget _buildHeader(FinancialReportDto report) => pw.Column(
        children: [
          pw.Text(
            'Basir Accounting System',
            style: pw.TextStyle(
              fontSize: 24,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue900,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            report.title,
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
              decoration: pw.TextDecoration.underline,
            ),
          ),
          pw.Text(
            'From: ${report.fromDate} '
            'To: ${report.toDate}',
            style: const pw.TextStyle(
              fontSize: 12,
              color: PdfColors.grey700,
            ),
          ),
        ],
      );

  /// Internal helper to build the table for financial reports.
  pw.Widget _buildReportTable(FinancialReportDto report) =>
      pw.TableHelper.fromTextArray(
        headerStyle: pw.TextStyle(
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.white,
        ),
        headerDecoration: const pw.BoxDecoration(color: PdfColors.blue800),
        cellAlignment: pw.Alignment.centerLeft,
        data: <List<String>>[
          <String>['البند', 'المبلغ'],
          ...report.lines.map(
            (line) => [
              line.label,
              line.amount,
            ],
          ),
        ],
      );

  /// Internal helper to build the footer for financial reports.
  pw.Widget _buildFooter(FinancialReportDto report) => pw.Column(
        children: [
          pw.Divider(),
          pw.Text(
            'Generated by Basir Intelligent Accounting System',
            style: const pw.TextStyle(
              fontSize: 10,
              color: PdfColors.grey500,
            ),
          ),
          pw.Text(
            'Diamond Purity Certified',
            style: const pw.TextStyle(
              fontSize: 8,
              color: PdfColors.blueGrey,
            ),
          ),
        ],
      );
}
