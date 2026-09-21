import 'dart:typed_data';

import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/core/utils/format_helpers.dart';
import 'package:basir_accounting_system/features/customers/domain/entities/customer.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice.dart';
import 'package:decimal/decimal.dart';
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
        theme: pw.ThemeData.withFont(base: font, bold: fontBold),
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
  Future<void> shareInvoice(Invoice invoice, Customer customer, {PdfColor? primaryColor}) async {
    final bytes = await generateInvoice(invoice, customer, primaryColor: primaryColor);
    await Printing.sharePdf(bytes: bytes, filename: 'invoice_${invoice.invoiceNumber}.pdf');
  }

  pw.Widget _buildHeader(Invoice invoice, PdfColor themeColor) => pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    children: [
      pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'فاتورة ضريبية',
            style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: themeColor),
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
  ) => pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    children: [
      // تفاصيل البائع (Company)
      pw.Expanded(
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('من (البائع):', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text(settings['companyName'] ?? 'بصير MVP'),
            if (settings['taxNumber'] != null) pw.Text('الرقم الضريبي: ${settings['taxNumber']}'),
            // Add address if available in settings
          ],
        ),
      ),
      // تفاصيل العميل
      pw.Expanded(
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('إلى (العميل):', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text(customer.nameAr),
            if (customer.address != null) pw.Text('العنوان: ${customer.address}'),
            if (customer.phone != null) pw.Text('الهاتف: ${customer.phone}'),
          ],
        ),
      ),
    ],
  );

  pw.Widget _buildItemsTable(Invoice invoice, String currency, PdfColor themeColor) {
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
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
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
            _buildTotalRow('المجموع الفرعي:', invoice.subtotalAmount, currency),
            _buildTotalRow(
              'الضريبة (${invoice.taxRate * Decimal.fromInt(100)}%):',
              invoice.taxAmount,
              currency,
            ),
            pw.Divider(),
            _buildTotalRow('الإجمالي المستحق:', invoice.totalAmount, currency, isBold: true),
          ],
        ),
      ),
    ],
  );

  pw.Widget _buildTotalRow(String label, Decimal value, String currency, {bool isBold = false}) {
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
      if (invoice.notes != null && invoice.notes!.isNotEmpty) pw.Text('ملاحظات: ${invoice.notes}'),
      pw.SizedBox(height: 20),
      pw.Center(
        child: pw.Text('شكرًا لتعاملكم معنا', style: const pw.TextStyle(color: PdfColors.grey)),
      ),
    ],
  );

  static PdfPageFormat getThermalPageFormat(String paperSize) => switch (paperSize) {
    '58mm' => const PdfPageFormat(
      58 * PdfPageFormat.mm,
      double.infinity,
      marginAll: 2 * PdfPageFormat.mm,
    ),
    '80mm' => PdfPageFormat.roll80,
    _ => PdfPageFormat.a4,
  };

  Future<Uint8List> generateThermalInvoice(
    Invoice invoice,
    Customer customer, {
    String paperSize = '80mm',
    bool printTwoCopies = false,
  }) async {
    final settings = await ref.read(companySettingsProvider.future);
    final currencySymbol = settings['currencySymbol'] ?? 'ر.س';
    final doc = pw.Document();
    final font = await PdfGoogleFonts.cairoRegular();
    final fontBold = await PdfGoogleFonts.cairoBold();
    final pageFormat = getThermalPageFormat(paperSize);

    pw.Page buildPage() => pw.Page(
      pageFormat: pageFormat,
      theme: pw.ThemeData.withFont(base: font, bold: fontBold),
      build: (context) => pw.Directionality(
        textDirection: pw.TextDirection.rtl,
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Center(
              child: pw.Text(
                settings['companyName'] ?? 'بصير',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16),
              ),
            ),
            pw.Center(child: pw.Text('فاتورة ضريبية', style: const pw.TextStyle(fontSize: 14))),
            pw.SizedBox(height: 10),
            pw.Text('العميل: ${customer.nameAr}'),
            pw.Text('التاريخ: ${FormatHelpers.formatDate(invoice.issuedDate.toLocal())}'),
            pw.SizedBox(height: 10),
            pw.TableHelper.fromTextArray(
              headers: ['السعر', 'المادة (الكمية)'],
              data: invoice.items
                  .map(
                    (item) => [
                      FormatHelpers.formatNumber(item.total + item.taxAmount),
                      '${item.name} (${FormatHelpers.formatNumber(item.quantity)})',
                    ],
                  )
                  .toList(),
              border: const pw.TableBorder(
                bottom: pw.BorderSide(width: 0.5, color: PdfColors.grey),
              ),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
              cellStyle: const pw.TextStyle(fontSize: 9),
              cellAlignments: {0: pw.Alignment.centerLeft, 1: pw.Alignment.centerRight},
            ),
            pw.SizedBox(height: 10),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  '${FormatHelpers.formatNumber(invoice.totalAmount)} $currencySymbol',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
                pw.Text('الإجمالي:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Center(
              child: pw.Text('شكراً لتعاملكم معنا', style: const pw.TextStyle(fontSize: 10)),
            ),
          ],
        ),
      ),
    );

    doc.addPage(buildPage());
    if (printTwoCopies) {
      doc.addPage(buildPage());
    }

    return doc.save();
  }

  Future<void> printThermalInvoice(
    Invoice invoice,
    Customer customer, {
    String paperSize = '80mm',
    bool printTwoCopies = false,
  }) async {
    final bytes = await generateThermalInvoice(
      invoice,
      customer,
      paperSize: paperSize,
      printTwoCopies: printTwoCopies,
    );
    await Printing.layoutPdf(onLayout: (format) async => bytes);
  }

  Future<Uint8List> generateStatementPdf({
    required String customerName,
    required String companyName,
    required List<Map<String, dynamic>> transactions,
    required String currency,
  }) async {
    final doc = pw.Document();
    final font = await PdfGoogleFonts.cairoRegular();
    final fontBold = await PdfGoogleFonts.cairoBold();

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(base: font, bold: fontBold),
        build: (context) => pw.Directionality(
          textDirection: pw.TextDirection.rtl,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'كشف حساب',
                    style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(
                    companyName,
                    style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Text('العميل: $customerName', style: const pw.TextStyle(fontSize: 14)),
              pw.SizedBox(height: 20),
              pw.TableHelper.fromTextArray(
                headers: ['الرصيد', 'دائن', 'مدين', 'البيان', 'التاريخ'],
                data: transactions
                    .map(
                      (t) => [
                        '${FormatHelpers.formatNumber(Decimal.parse(t['balance'].toString()))} $currency',
                        FormatHelpers.formatNumber(Decimal.parse(t['credit'].toString())),
                        FormatHelpers.formatNumber(Decimal.parse(t['debit'].toString())),
                        t['description'].toString(),
                        t['date'].toString(),
                      ],
                    )
                    .toList(),
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
                headerDecoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xFF1565C0)),
                cellAlignments: {
                  0: pw.Alignment.centerLeft,
                  1: pw.Alignment.centerLeft,
                  2: pw.Alignment.centerLeft,
                  3: pw.Alignment.centerRight,
                  4: pw.Alignment.centerRight,
                },
              ),
            ],
          ),
        ),
      ),
    );

    return doc.save();
  }
}
