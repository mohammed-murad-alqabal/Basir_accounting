import 'package:basser_app/core/utils/format_helpers.dart';
import 'package:basser_app/features/customers/domain/entities/customer.dart';
import 'package:basser_app/features/invoices/domain/entities/invoice.dart';
import 'package:basser_app/services/settings_service.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

/// خدمة توليد وطباعة ملفات PDF للفواتير
///
/// توفر هذه الخدمة وظائف لتوليد فواتير PDF احترافية
/// مع دعم كامل للغة العربية والتنسيق RTL
///
/// Example:
/// ```dart
/// final pdfService = PdfService();
/// final pdfBytes = await pdfService.generateInvoicePdf(invoice, customer,);
/// await pdfService.printInvoice(invoice, customer,);
/// ```
class PdfService {
  /// إنشاء خدمة PDF مع خدمة الإعدادات
  PdfService({required this.settingsService});

  /// خدمة الإعدادات لجلب معلومات الشركة والعملة
  final SettingsService settingsService;

  /// توليد ملف PDF للفاتورة
  ///
  /// ينشئ ملف PDF احترافي للفاتورة مع جميع التفاصيل
  /// بما في ذلك معلومات العميل، البنود، والإجماليات
  ///
  /// Parameters:
  /// - [invoice]: الفاتورة المراد توليد PDF لها
  /// - [customer]: بيانات العميل
  ///
  /// Returns: بيانات PDF كـ Uint8List
  ///
  /// Throws: Exception إذا فشل توليد PDF
  ///
  /// Example:
  /// ```dart
  /// final pdfBytes = await pdfService.generateInvoicePdf(
  ///   invoice,
  ///   customer,
  ///,);
  /// ```
  Future<Uint8List> generateInvoicePdf(
    Invoice invoice,
    Customer customer, {
    Color? primaryColor,
  }) async {
    final pdf = pw.Document(
      title: 'فاتورة رقم ${invoice.id}',
      author: 'Basser MVP',
    );

    // تحويل لون التطبيق إلى لون PDF
    final themeColor = primaryColor != null
        ? PdfColor.fromInt(primaryColor.toARGB32())
        : const PdfColor.fromInt(0xFF1565C0); // Default Blue800

    // تحميل خط يدعم اللغة العربية
    final fontData = await rootBundle.load(
      'assets/fonts/Cairo-Regular.ttf',
    );
    final ttf = pw.Font.ttf(
      fontData,
    );

    // جلب إعدادات الشركة والعملة
    final settings = await settingsService.getCompanySettings();
    final currencySymbol = settings['currencySymbol'] ?? 'ر.س';

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) => pw.Directionality(
          textDirection: pw.TextDirection.rtl,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // 1. العنوان الرئيسي
              _buildHeader(invoice, ttf, themeColor),
              pw.SizedBox(height: 20),

              // 2. تفاصيل العميل والبائع
              _buildCustomerAndVendorDetails(invoice, customer, ttf, settings),
              pw.SizedBox(height: 30),

              // 3. جدول البنود
              _buildItemsTable(invoice, ttf, currencySymbol, themeColor),
              pw.SizedBox(height: 30),

              // 4. الإجماليات
              _buildTotals(invoice, ttf, currencySymbol),
              pw.SizedBox(height: 50),

              // 5. الملاحظات والتذييل
              _buildFooter(invoice, ttf),
            ],
          ),
        ),
      ),
    );

    return pdf.save();
  }

  pw.Widget _buildHeader(
    Invoice invoice,
    pw.Font font,
    PdfColor themeColor,
  ) =>
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'فاتورة ضريبية',
            style: pw.TextStyle(
              font: font,
              fontSize: 24,
              fontWeight: pw.FontWeight.bold,
              color: themeColor,
            ),
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(
                'رقم الفاتورة: ${invoice.id}',
                style: pw.TextStyle(font: font, fontSize: 12),
              ),
              pw.Text(
                'تاريخ الإصدار: '
                '${FormatHelpers.formatDate(invoice.issuedDate.toLocal())}',
                style: pw.TextStyle(font: font, fontSize: 12),
              ),
              pw.Text(
                'تاريخ الاستحقاق: '
                '${FormatHelpers.formatDate(invoice.dueDate.toLocal())}',
                style: pw.TextStyle(font: font, fontSize: 12),
              ),
            ],
          ),
        ],
      );

  pw.Widget _buildCustomerAndVendorDetails(
    Invoice invoice,
    Customer customer,
    pw.Font font,
    Map<String, String?> settings,
  ) =>
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          // تفاصيل البائع
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'من:',
                style: pw.TextStyle(font: font, fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(
                settings['companyName'] ?? 'بصير MVP',
                style: pw.TextStyle(font: font),
              ),
              if (settings['companyAddress'] != null)
                pw.Text(
                  'العنوان: ${settings['companyAddress']}',
                  style: pw.TextStyle(font: font),
                ),
              if (settings['companyPhone'] != null)
                pw.Text(
                  'الهاتف: ${settings['companyPhone']}',
                  style: pw.TextStyle(font: font),
                ),
              if (settings['taxNumber'] != null)
                pw.Text(
                  'الرقم الضريبي: ${settings['taxNumber']}',
                  style: pw.TextStyle(font: font),
                ),
            ],
          ),

          // تفاصيل العميل
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'إلى:',
                style: pw.TextStyle(font: font, fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(customer.name, style: pw.TextStyle(font: font)),
              if (customer.address != null)
                pw.Text(
                  'العنوان: ${customer.address}',
                  style: pw.TextStyle(font: font),
                ),
              if (customer.email != null)
                pw.Text(
                  'البريد الإلكتروني: ${customer.email}',
                  style: pw.TextStyle(font: font),
                ),
              if (customer.phone != null)
                pw.Text(
                  'الهاتف: ${customer.phone}',
                  style: pw.TextStyle(font: font),
                ),
            ],
          ),
        ],
      );

  pw.Widget _buildItemsTable(
    Invoice invoice,
    pw.Font font,
    String currency,
    PdfColor themeColor,
  ) {
    const tableHeaders = ['الإجمالي', 'الضريبة', 'السعر', 'الكمية', 'الوصف'];

    final tableData = <List<String>>[];

    // إضافة بنود الفاتورة
    for (final item in invoice.items) {
      tableData.add(
        [
          // Hack to keep number format but add currency manually if needed:
          '${FormatHelpers.formatCurrency(
            item.total,
            currencyCode: '',
            locale: 'en',
          ).replaceAll('en', '')} $currency',
          '${FormatHelpers.formatNumber(
            item.total * invoice.taxRate,
          )} $currency',
          '${FormatHelpers.formatNumber(item.price)} $currency',
          FormatHelpers.formatNumber(item.quantity),
          item.name,
        ],
      );
    }

    return pw.TableHelper.fromTextArray(
      headers: tableHeaders.reversed.toList(), // عكس الترتيب
      data: tableData.map((row) => row.reversed.toList()).toList(),
      border: pw.TableBorder.all(color: PdfColors.grey400),
      headerStyle: pw.TextStyle(
        font: font,
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.white,
      ),
      headerDecoration: pw.BoxDecoration(color: themeColor),
      cellStyle: pw.TextStyle(font: font, fontSize: 10),
      columnWidths: {
        0: const pw.FlexColumnWidth(2), // الوصف
        1: const pw.FlexColumnWidth(), // الكمية
        2: const pw.FlexColumnWidth(1.5), // السعر
        3: const pw.FlexColumnWidth(1.5), // الضريبة
        4: const pw.FlexColumnWidth(1.5), // الإجمالي
      },
      cellAlignments: {
        0: pw.Alignment.centerRight,
        1: pw.Alignment.center,
        2: pw.Alignment.center,
        3: pw.Alignment.center,
        4: pw.Alignment.center,
      },
    );
  }

  pw.Widget _buildTotals(
    Invoice invoice,
    pw.Font font,
    String currency,
  ) =>
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.end,
        children: [
          pw.Container(
            width: 250,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                _buildTotalRow(
                  'الإجمالي الفرعي:',
                  invoice.subtotal,
                  font,
                  currency,
                ),
                _buildTotalRow(
                  'الضريبة (${FormatHelpers.formatNumber(
                    invoice.taxRate * 100,
                  )}%):',
                  invoice.taxTotal,
                  font,
                  currency,
                ),
                pw.Divider(color: PdfColors.grey500),
                _buildTotalRow(
                  'الإجمالي الكلي:',
                  invoice.grandTotal,
                  font,
                  currency,
                  isGrandTotal: true,
                ),
              ],
            ),
          ),
        ],
      );

  pw.Widget _buildTotalRow(
    String label,
    double amount,
    pw.Font font,
    String currency, {
    bool isGrandTotal = false,
  }) =>
      pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 4),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              '${FormatHelpers.formatNumber(amount)} $currency',
              style: pw.TextStyle(
                font: font,
                fontWeight:
                    isGrandTotal ? pw.FontWeight.bold : pw.FontWeight.normal,
                fontSize: isGrandTotal ? 14 : 12,
              ),
            ),
            pw.Text(
              label,
              style: pw.TextStyle(
                font: font,
                fontWeight:
                    isGrandTotal ? pw.FontWeight.bold : pw.FontWeight.normal,
                fontSize: isGrandTotal ? 14 : 12,
              ),
            ),
          ],
        ),
      );

  pw.Widget _buildFooter(Invoice invoice, pw.Font font) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          if (invoice.notes != null && invoice.notes!.isNotEmpty)
            pw.Text(
              'ملاحظات:',
              style: pw.TextStyle(font: font, fontWeight: pw.FontWeight.bold),
            ),
          if (invoice.notes != null && invoice.notes!.isNotEmpty)
            pw.Text(invoice.notes!, style: pw.TextStyle(font: font)),
          pw.SizedBox(height: 20),
          pw.Center(
            child: pw.Text(
              'شكرًا لتعاملك معنا. '
              'هذه الفاتورة تم إنشاؤها بواسطة تطبيق بصير MVP.',
              style: pw.TextStyle(
                font: font,
                fontSize: 10,
                color: PdfColors.grey600,
              ),
            ),
          ),
        ],
      );

  /// وظيفة مساعدة لطباعة الفاتورة مباشرة
  Future<void> printInvoice(
    Invoice invoice,
    Customer customer, [
    Color? primaryColor,
  ]) async {
    final pdfBytes = await generateInvoicePdf(
      invoice,
      customer,
      primaryColor: primaryColor,
    );
    await Printing.sharePdf(
      bytes: pdfBytes,
      filename: 'invoice_${invoice.id}.pdf',
    );
  }
}
