import 'dart:typed_data';

import 'package:basir_app/core/providers.dart';
import 'package:basir_app/core/utils/format_helpers.dart';
import 'package:basir_app/features/customers/domain/entities/customer.dart';
import 'package:basir_app/features/invoices/domain/entities/invoice.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pdf_invoice_service.g.dart';

/// خدمة توليد فواتير PDF
@riverpod
class PdfInvoiceService extends _$PdfInvoiceService {
  @override
  void build() {
    return;
  }

  /// توليد ملف PDF للفاتورة
  Future<Uint8List> generateInvoice(
    Invoice invoice,
    Customer customer, {
    PdfColor? primaryColor,
  }) async {
    final settings = await ref.read(companySettingsProvider.future);
    final currencySymbol = settings['currencySymbol'] ?? 'ر.س';

    final doc = pw.Document(
      title: 'فاتورة رقم ${invoice.invoiceNumber}',
      author: settings['companyName'] ?? 'Basir App',
    );

    final font = await PdfGoogleFonts.cairoRegular();
    final fontBold = await PdfGoogleFonts.cairoBold();

    final themeColor = primaryColor ?? const PdfColor.fromInt(0xFF1565C0);

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(
          base: font,
          bold: fontBold,
        ),
        build: (context) => pw.Directionality(
          textDirection: pw.TextDirection.rtl,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildHeader(invoice, themeColor),
              pw.SizedBox(height: 20),
              _buildCustomerAndVendorDetails(invoice, customer, settings),
              pw.SizedBox(height: 30),
              _buildItemsTable(invoice, currencySymbol, themeColor),
              pw.SizedBox(height: 30),
              _buildTotals(invoice, currencySymbol),
              pw.Spacer(),
              _buildFooter(invoice),
            ],
          ),
        ),
      ),
    );

    return doc.save();
  }

  /// مشاركة الفاتورة
  Future<void> shareInvoice(
    Invoice invoice,
    Customer customer, {
    PdfColor? primaryColor,
  }) async {
    final bytes = await generateInvoice(
      invoice,
      customer,
      primaryColor: primaryColor,
    );
    await Printing.sharePdf(
      bytes: bytes,
      filename: 'invoice_${invoice.invoiceNumber}.pdf',
    );
  }

  pw.Widget _buildHeader(Invoice invoice, PdfColor themeColor) => pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'فاتورة ضريبية',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                  color: themeColor,
                ),
              ),
              pw.Text('Tax Invoice', style: const pw.TextStyle(fontSize: 14)),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text('رقم الفاتورة: ${invoice.invoiceNumber}'),
              pw.Text(
                'تاريخ الإصدار: '
                '${FormatHelpers.formatDate(invoice.issuedDate.toLocal())}',
              ),
              pw.Text(
                'تاريخ الاستحقاق: '
                '${FormatHelpers.formatDate(invoice.dueDate.toLocal())}',
              ),
            ],
          ),
        ],
      );

  pw.Widget _buildCustomerAndVendorDetails(
    Invoice invoice,
    Customer customer,
    Map<String, String?> settings,
  ) =>
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          // تفاصيل البائع (Company)
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'من (البائع):',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
                pw.Text(settings['companyName'] ?? 'بصير MVP'),
                if (settings['taxNumber'] != null)
                  pw.Text('الرقم الضريبي: ${settings['taxNumber']}'),
                // Add address if available in settings
              ],
            ),
          ),
          // تفاصيل العميل
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'إلى (العميل):',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
                pw.Text(customer.name),
                if (customer.address != null)
                  pw.Text('العنوان: ${customer.address}'),
                if (customer.phone != null)
                  pw.Text('الهاتف: ${customer.phone}'),
              ],
            ),
          ),
        ],
      );

  pw.Widget _buildItemsTable(
    Invoice invoice,
    String currency,
    PdfColor themeColor,
  ) {
    // Note: In RTL PDF table, columns are filled left-to-right
    // visually if textDirection is RTL.
    // pw.TableHelper with RTL directionality should handle it.
    // Columns: Item, Qty, Price, Tax, Total
    final headers = ['الإجمالي', 'الضريبة', 'السعر', 'الكمية', 'الوصف'];

    final data = invoice.items.map((item) {
      final totalWithTax = item.total + item.taxAmount;
      final taxAmount = item.taxAmount;
      return [
        '${FormatHelpers.formatNumber(totalWithTax)} $currency',
        '${FormatHelpers.formatNumber(taxAmount)} $currency',
        '${FormatHelpers.formatNumber(item.price)} $currency',
        FormatHelpers.formatNumber(item.quantity),
        item.name,
      ];
    }).toList();

    return pw.TableHelper.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.white,
      ),
      headerDecoration: pw.BoxDecoration(color: themeColor),
      cellHeight: 30,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerLeft,
        3: pw.Alignment.center,
        4: pw.Alignment.centerRight,
      },
    );
  }

  pw.Widget _buildTotals(Invoice invoice, String currency) => pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.end,
        children: [
          pw.Container(
            width: 200,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _buildTotalRow(
                  'المجموع الفرعي:',
                  invoice.subtotalAmount,
                  currency,
                ),
                _buildTotalRow(
                  'الضريبة (${(invoice.taxRate * 100).toInt()}%):',
                  invoice.taxAmount,
                  currency,
                ),
                pw.Divider(),
                _buildTotalRow(
                  'الإجمالي المستحق:',
                  invoice.totalAmount,
                  currency,
                  isBold: true,
                ),
              ],
            ),
          ),
        ],
      );

  pw.Widget _buildTotalRow(
    String label,
    double value,
    String currency, {
    bool isBold = false,
  }) {
    final style = isBold
        ? pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)
        : const pw.TextStyle(fontSize: 12);
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text('${FormatHelpers.formatNumber(value)} $currency', style: style),
        pw.Text(label, style: style),
      ],
    );
  }

  pw.Widget _buildFooter(Invoice invoice) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          if (invoice.notes != null && invoice.notes!.isNotEmpty)
            pw.Text('ملاحظات: ${invoice.notes}'),
          pw.SizedBox(height: 20),
          pw.Center(
            child: pw.Text(
              'شكرًا لتعاملكم معنا',
              style: const pw.TextStyle(color: PdfColors.grey),
            ),
          ),
        ],
      );
}
