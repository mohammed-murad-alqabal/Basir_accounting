// ignore_for_file: lines_longer_than_80_chars
/// ***
/// Cognitive Foundation: InvoicePdfService
///
/// High-fidelity PDF generation engine for institutional invoices.
/// Supports multi-language (Arabic RTL), ZATCA QR codes, and IFRS 18 standards.
///
/// Uses [Decimal] for precise representation of all financial values.
/// ***
library;

import 'package:basir_accounting_system/features/invoices/application/zatca_service.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice.dart';
import 'package:basir_accounting_system/services/settings_service.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' as intl;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// [InvoicePdfService]
class InvoicePdfService {
  /// Creating the [InvoicePdfService] with [SettingsService].
  InvoicePdfService(this._settingsService);

  final SettingsService _settingsService;

  static const String _fontPath = 'assets/fonts/Cairo-Regular.ttf';
  static const String _boldFontPath = 'assets/fonts/Cairo-Bold.ttf';

  /// Generates a professional PDF document for the given [invoice].
  Future<Uint8List> generateInvoicePdf(
    Invoice invoice, {
    String locale = 'ar',
  }) async {
    final settings = await _settingsService.getCompanySettings();
    final companyName = settings['companyName'] ?? 'Basir Tech';
    final taxNumber = settings['taxNumber'] ?? '123456789012345';

    final pdf = pw.Document();

    // Institutional Font Loading for RTL Support
    final fontData = await rootBundle.load(_fontPath);
    final ttf = pw.Font.ttf(fontData);

    final boldFontData = await rootBundle.load(_boldFontPath);
    final ttfBold = pw.Font.ttf(boldFontData);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(base: ttf, bold: ttfBold),
        textDirection: pw.TextDirection.rtl,
        build: (context) => [
          _buildHeader(invoice, ttfBold),
          pw.SizedBox(height: 20),
          _buildCustomerInfo(invoice, ttfBold),
          pw.SizedBox(height: 20),
          _buildItemsTable(invoice, ttfBold),
          pw.SizedBox(height: 20),
          _buildTotalsAndQr(
            invoice,
            ttfBold,
            companyName: companyName,
            taxNumber: taxNumber,
          ),
          pw.SizedBox(height: 40),
          _buildFooter(invoice),
        ],
      ),
    );

    return pdf.save();
  }

  pw.Widget _buildHeader(Invoice invoice, pw.Font boldFont) => pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'فاتورة ضريبية',
                style: pw.TextStyle(
                  font: boldFont,
                  fontSize: 24,
                  color: PdfColors.blue900,
                ),
              ),
              pw.Text(
                invoice.zatcaDeviceId != null
                    ? 'فاتورة ضريبية مبسطة'
                    : 'فاتورة ضريبية',
                style: pw.TextStyle(
                  font: boldFont,
                  fontSize: 12,
                  color: PdfColors.grey700,
                ),
              ),
              pw.Text(
                'Tax Invoice',
                style:
                    const pw.TextStyle(fontSize: 16, color: PdfColors.grey700),
                textDirection: pw.TextDirection.ltr,
              ),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(
                'رقم الفاتورة: ${invoice.invoiceNumber}',
                style: pw.TextStyle(font: boldFont, fontSize: 14),
              ),
              pw.Text(
                'تاريخ الإصدار: '
                '${intl.DateFormat('yyyy/MM/dd').format(invoice.issuedDate)}',
                style: const pw.TextStyle(fontSize: 12),
              ),
            ],
          ),
        ],
      );

  pw.Widget _buildCustomerInfo(Invoice invoice, pw.Font boldFont) =>
      pw.Container(
        padding: const pw.EdgeInsets.all(10),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: PdfColors.grey300),
          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
        ),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'العميل / Customer:',
                  style: pw.TextStyle(font: boldFont),
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
                  'المجموع الإجمالي / Total Amount:',
                  style: pw.TextStyle(font: boldFont),
                ),
                pw.Text(
                  '${invoice.totalAmount.toStringAsFixed(2)} '
                  '${invoice.currency}',
                  style: pw.TextStyle(
                    font: boldFont,
                    fontSize: 16,
                    color: PdfColors.blue700,
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  pw.Widget _buildItemsTable(Invoice invoice, pw.Font boldFont) {
    final headers = ['البند', 'الكمية', 'سعر الوحدة', 'الضريبة', 'المجموع'];

    return pw.TableHelper.fromTextArray(
      headers: headers,
      data: List<List<dynamic>>.generate(invoice.items.length, (index) {
        final item = invoice.items[index];
        return [
          item.name,
          item.quantity.toString(),
          item.price.toStringAsFixed(2),
          item.taxAmount.toStringAsFixed(2),
          item.total.toStringAsFixed(2),
        ];
      }),
      headerStyle: pw.TextStyle(font: boldFont, color: PdfColors.white),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.blue900),
      cellAlignment: pw.Alignment.center,
      columnWidths: {
        0: const pw.FlexColumnWidth(3),
        1: const pw.FlexColumnWidth(),
        2: const pw.FlexColumnWidth(1.5),
        3: const pw.FlexColumnWidth(1.5),
        4: const pw.FlexColumnWidth(1.5),
      },
    );
  }

  pw.Widget _buildTotalsAndQr(
    Invoice invoice,
    pw.Font boldFont, {
    required String companyName,
    required String taxNumber,
  }) =>
      pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // ZATCA Compliant QR Code
          pw.Container(
            width: 100,
            height: 100,
            child: pw.BarcodeWidget(
              barcode: pw.Barcode.qrCode(),
              data: ZatcaService.encodeTlv(
                sellerName: companyName,
                taxNumber: taxNumber,
                timestamp: invoice.issuedDate,
                totalAmount: invoice.totalAmount,
                vatAmount: invoice.taxAmount,
              ),
              width: 100,
              height: 100,
            ),
          ),
          pw.Spacer(),
          // Institutional Totals
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              _buildTotalLine(
                'المجموع الفرعي / Subtotal:',
                invoice.subtotalAmount,
              ),
              _buildTotalLine('مبلغ الضريبة / Tax Amount:', invoice.taxAmount),
              if (invoice.discountAmount > Decimal.zero)
                _buildTotalLine('الخصم / Discount:', -invoice.discountAmount),
              pw.Divider(color: PdfColors.grey400),
              pw.Text(
                'الإجمالي / Total:',
                style: pw.TextStyle(font: boldFont, fontSize: 16),
              ),
              pw.Text(
                '${invoice.totalAmount.toStringAsFixed(2)} ${invoice.currency}',
                style: pw.TextStyle(
                  font: boldFont,
                  fontSize: 18,
                  color: PdfColors.blue900,
                ),
              ),
            ],
          ),
        ],
      );

  pw.Widget _buildTotalLine(String label, Decimal amount) => pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 2),
        child: pw.Row(
          mainAxisSize: pw.MainAxisSize.min,
          children: [
            pw.Text(label, style: const pw.TextStyle(fontSize: 10)),
            pw.SizedBox(width: 10),
            pw.Text(
              amount.toStringAsFixed(2),
              style: const pw.TextStyle(fontSize: 12),
            ),
          ],
        ),
      );

  pw.Widget _buildFooter(Invoice invoice) => pw.Column(
        children: [
          pw.Divider(color: PdfColors.grey300),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'شكراً لتعاملكم معنا',
                style: const pw.TextStyle(fontSize: 10),
              ),
              pw.Text(
                'برنامج بصير المحاسبي - Basir Accounting',
                style: const pw.TextStyle(fontSize: 10),
              ),
            ],
          ),
        ],
      );
}
