import 'package:basir_accounting_system/features/accounting/domain/entities/accounting_agent.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice_type.dart';
import 'package:basir_accounting_system/src/rust/api/reports.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pdf_generation_service.g.dart';

@Riverpod(keepAlive: true)
class PdfGenerationService extends _$PdfGenerationService {
  @override
  FutureOr<void> build() {}

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

  /// Generates a thermal receipt (80mm) for the given invoice.
  Future<Uint8List> generateThermalReceipt(Invoice invoice) async {
    final pdf = pw.Document();

    final fontData = await rootBundle.load('assets/fonts/Cairo-Regular.ttf');
    final fontBoldData = await rootBundle.load('assets/fonts/Cairo-Bold.ttf');
    final ttf = pw.Font.ttf(fontData);
    final ttfBold = pw.Font.ttf(fontBoldData);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        theme: pw.ThemeData.withFont(
          base: ttf,
          bold: ttfBold,
        ),
        textDirection: pw.TextDirection.rtl,
        build: (context) => pw.Column(
          children: [
            pw.Text(
              'Basir Accounting',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 5),
            pw.Text(
              invoice.type == InvoiceType.sales ? 'Sales Invoice' : 'Invoice',
              style: const pw.TextStyle(fontSize: 12),
            ),
            pw.Text(
              invoice.invoiceNumber,
              style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
            ),
            pw.Divider(),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Date:', style: const pw.TextStyle(fontSize: 8)),
                pw.Text(
                  invoice.issuedDate.toString().split(' ')[0],
                  style: const pw.TextStyle(fontSize: 8),
                ),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Customer:', style: const pw.TextStyle(fontSize: 8)),
                pw.Text(
                  invoice.customerName,
                  style: const pw.TextStyle(fontSize: 8),
                ),
              ],
            ),
            pw.Divider(),
            ...invoice.items.map(
              (item) => pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 2),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(item.name, style: const pw.TextStyle(fontSize: 9)),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          '${item.quantity} x ${item.price}',
                          style: const pw.TextStyle(fontSize: 8),
                        ),
                        pw.Text(
                          item.total.toString(),
                          style: pw.TextStyle(
                            fontSize: 8,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            pw.Divider(),
            _buildReceiptSummaryRow(
              'Subtotal',
              invoice.subtotalAmount.toString(),
            ),
            _buildReceiptSummaryRow('Tax', invoice.taxAmount.toString()),
            _buildReceiptSummaryRow(
              'Total',
              invoice.totalAmount.toString(),
              isBold: true,
            ),
            pw.SizedBox(height: 10),
            if (invoice.qrCode != null)
              pw.Container(
                width: 100,
                height: 100,
                child: pw.BarcodeWidget(
                  barcode: pw.Barcode.qrCode(),
                  data: invoice.qrCode!,
                ),
              ),
            pw.SizedBox(height: 10),
            pw.Text(
              'Thank you for your business!',
              style: const pw.TextStyle(fontSize: 8),
            ),
          ],
        ),
      ),
    );

    return pdf.save();
  }

  /// Generates an "Intelligence Report" summarizing agent consensus for a period.
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
                  'Analysis Period: ${from.toString().split(' ')[0]} to ${to.toString().split(' ')[0]}',
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
                          color: res.isAllowed ? PdfColors.green900 : PdfColors.red900,
                        ),
                      ),
                      pw.Text(
                        'Confidence: ${(res.confidenceScore * 100).toStringAsFixed(1)}%',
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

  /// Internal helper to build a summary row for thermal receipts.
  pw.Widget _buildReceiptSummaryRow(
    String label,
    String value, {
    bool isBold = false,
  }) =>
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: 10,
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 10,
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
        ],
      );

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
            'From: ${report.fromDate} To: ${report.toDate}',
            style: const pw.TextStyle(
              fontSize: 12,
              color: PdfColors.grey700,
            ),
          ),
        ],
      );

  /// Internal helper to build the table for financial reports.
  pw.Widget _buildReportTable(FinancialReportDto report) => pw.TableHelper.fromTextArray(
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
