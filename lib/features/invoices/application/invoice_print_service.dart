import 'package:basir_app/features/invoices/application/zatca_service.dart';
import 'package:basir_app/features/invoices/domain/entities/invoice.dart';
import 'package:basir_app/l10n/app_localizations.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' as intl;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// [InvoicePrintService]
///
/// Specialized engine for generating thermal POS receipts.
/// Optimized for Roll 80mm and Roll 58mm formats.
class InvoicePrintService {
  static const String _fontPath = 'assets/fonts/Cairo-Regular.ttf';
  static const String _boldFontPath = 'assets/fonts/Cairo-Bold.ttf';

  /// Generates a POS receipt PDF.
  Future<Uint8List> generateReceiptPdf(
    Invoice invoice,
    AppLocalizations l10n, {
    PdfPageFormat format = PdfPageFormat.roll80,
  }) async {
    final pdf = pw.Document();

    final fontData = await rootBundle.load(_fontPath);
    final ttf = pw.Font.ttf(fontData);

    final boldFontData = await rootBundle.load(_boldFontPath);
    final ttfBold = pw.Font.ttf(boldFontData);

    // POS receipts are usually continuous rolls.
    pdf.addPage(
      pw.Page(
        pageFormat: format,
        theme: pw.ThemeData.withFont(base: ttf, bold: ttfBold),
        textDirection: pw.TextDirection.rtl,
        build: (context) => pw.Column(
          children: [
            _buildReceiptHeader(invoice, l10n, ttfBold),
            pw.Divider(thickness: 1, color: PdfColors.grey),
            _buildReceiptInfo(invoice, l10n, ttfBold),
            pw.SizedBox(height: 5),
            _buildReceiptItems(invoice, l10n, ttfBold),
            pw.Divider(thickness: 1, color: PdfColors.grey),
            _buildReceiptTotals(invoice, l10n, ttfBold),
            pw.SizedBox(height: 10),
            _buildReceiptQr(invoice),
            pw.SizedBox(height: 10),
            _buildReceiptFooter(l10n),
          ],
        ),
      ),
    );

    return pdf.save();
  }

  pw.Widget _buildReceiptHeader(
    Invoice invoice,
    AppLocalizations l10n,
    pw.Font boldFont,
  ) =>
      pw.Column(
        children: [
          pw.Text(
            'مؤسسة بصير التجارية', // TODO(Basir): Load from settings
            style: pw.TextStyle(font: boldFont, fontSize: 14),
          ),
          pw.Text(
            'Basir Trading Co.',
            style: const pw.TextStyle(fontSize: 10),
            textDirection: pw.TextDirection.ltr,
          ),
          pw.Text(
            '${l10n.labelTaxNumber}: 123456789012345',
            style: const pw.TextStyle(fontSize: 9),
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            invoice.zatcaDeviceId != null
                ? l10n.receiptTitleSimplified
                : l10n.receiptTitleTaxInvoice,
            style: pw.TextStyle(font: boldFont, fontSize: 12),
          ),
        ],
      );

  pw.Widget _buildReceiptInfo(
    Invoice invoice,
    AppLocalizations l10n,
    pw.Font boldFont,
  ) =>
      pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                '${l10n.labelInvoiceNo}: ${invoice.invoiceNumber}',
                style: const pw.TextStyle(fontSize: 9),
              ),
              pw.Text(
                intl.DateFormat('yyyy/MM/dd HH:mm').format(invoice.issuedDate),
                style: const pw.TextStyle(fontSize: 8),
              ),
            ],
          ),
          pw.Text(
            '${l10n.labelCustomer}: ${invoice.customerName}',
            style: const pw.TextStyle(fontSize: 9),
          ),
        ],
      );

  pw.Widget _buildReceiptItems(
    Invoice invoice,
    AppLocalizations l10n,
    pw.Font boldFont,
  ) =>
      pw.Column(
        children: invoice.items
            .map(
              (item) => pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 1),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(item.name, style: const pw.TextStyle(fontSize: 9)),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          '${item.quantity} x ${item.price.toStringAsFixed(2)}',
                          style: const pw.TextStyle(fontSize: 8),
                        ),
                        pw.Text(
                          item.total.toStringAsFixed(2),
                          style: pw.TextStyle(font: boldFont, fontSize: 9),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      );

  pw.Widget _buildReceiptTotals(
    Invoice invoice,
    AppLocalizations l10n,
    pw.Font boldFont,
  ) =>
      pw.Column(
        children: [
          _buildReceiptTotalRow(l10n.labelSubtotal, invoice.subtotalAmount),
          _buildReceiptTotalRow(
            l10n.labelTax(
              (invoice.taxAmount /
                      (invoice.subtotalAmount == Decimal.zero
                          ? Decimal.one
                          : invoice.subtotalAmount))
                  .toDouble()
                  .toStringAsFixed(2),
            ),
            invoice.taxAmount,
          ),
          if (invoice.discountAmount > Decimal.zero)
            _buildReceiptTotalRow(
              l10n.labelDiscount,
              -invoice.discountAmount,
            ),
          pw.SizedBox(height: 2),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                l10n.labelGrandTotal,
                style: pw.TextStyle(font: boldFont, fontSize: 11),
              ),
              pw.Text(
                '${invoice.totalAmount.toStringAsFixed(2)} ${invoice.currency}',
                style: pw.TextStyle(font: boldFont, fontSize: 11),
              ),
            ],
          ),
        ],
      );

  pw.Widget _buildReceiptTotalRow(String label, Decimal amount) => pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: const pw.TextStyle(fontSize: 9),
          ),
          pw.Text(
            amount.toStringAsFixed(2),
            style: const pw.TextStyle(fontSize: 9),
          ),
        ],
      );

  pw.Widget _buildReceiptQr(Invoice invoice) => pw.Container(
        width: 80,
        height: 80,
        child: pw.BarcodeWidget(
          barcode: pw.Barcode.qrCode(),
          data: invoice.qrCode ??
              ZatcaService.encodeTlv(
                sellerName: 'مؤسسة بصير التجارية',
                taxNumber: '123456789012345',
                timestamp: invoice.issuedDate,
                totalAmount: invoice.totalAmount,
                vatAmount: invoice.taxAmount,
              ),
        ),
      );

  pw.Widget _buildReceiptFooter(AppLocalizations l10n) => pw.Column(
        children: [
          pw.Text(l10n.receiptFooterThanks, style: const pw.TextStyle(fontSize: 8)),
          pw.Text(
            l10n.receiptFooterBrand,
            style: const pw.TextStyle(fontSize: 7),
          ),
        ],
      );
}
