import 'dart:typed_data';

import 'package:basir_accounting_system/core/utils/format_helpers.dart';
import 'package:basir_accounting_system/features/accounting/application/tax_engine_service.dart';
import 'package:decimal/decimal.dart';
import 'package:intl/intl.dart' as intl;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'report_pdf_service.g.dart';

/// Service for generating PDF reports for tax returns.
@riverpod
class ReportPdfService extends _$ReportPdfService {
  @override
  void build() {
    return;
  }

  /// Generates the VAT Return PDF binary data.
  Future<Uint8List> generateVatReturnPdf(VatReturnStatement data) async {
    final pdf = pw.Document(
      title: 'VAT Return Report',
      author: 'Basir Accounting System',
    );

    // Load fonts
    final fontRegular = await PdfGoogleFonts.cairoRegular();
    final fontBold = await PdfGoogleFonts.cairoBold();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(
          base: fontRegular,
          bold: fontBold,
        ),
        build: (context) => pw.Directionality(
          textDirection: pw.TextDirection.rtl,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildHeader(data),
              pw.SizedBox(height: 20),
              _buildSummaryParams(data),
              pw.SizedBox(height: 20),
              _buildSalesSection(data),
              pw.SizedBox(height: 20),
              _buildPurchasesSection(data),
              pw.SizedBox(height: 30),
              _buildNetVatSection(data),
              pw.Spacer(),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );

    return pdf.save();
  }

  /// Shares the generated VAT Return PDF.
  Future<void> shareVatReturnPdf(VatReturnStatement data) async {
    final bytes = await generateVatReturnPdf(data);
    final filename = 'vat_return_${intl.DateFormat('yyyyMMdd').format(data.periodEnd)}.pdf';
    await Printing.sharePdf(bytes: bytes, filename: filename);
  }

  pw.Widget _buildHeader(VatReturnStatement data) {
    final dateFormat = intl.DateFormat('yyyy-MM-dd');
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'إقرار ضريبة القيمة المضافة',
          style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
        ),
        pw.Text(
          'VAT Return Statement',
          style: const pw.TextStyle(fontSize: 14, color: PdfColors.grey700),
        ),
        pw.SizedBox(height: 10),
        pw.Text(
          'الفترة: ${dateFormat.format(data.periodStart)} إلى ${dateFormat.format(data.periodEnd)}',
          style: const pw.TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  pw.Widget _buildSummaryParams(VatReturnStatement data) => pw.Container(
        padding: const pw.EdgeInsets.all(10),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: PdfColors.grey300),
          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
        ),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('العملة: ريال سعودي (SAR)'),
            pw.Text(
              'تاريخ التقرير: '
              '${intl.DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())}',
            ),
          ],
        ),
      );

  pw.Widget _buildSalesSection(VatReturnStatement data) => _buildSectionTable(
        title: 'ضريبة القيمة المضافة على المبيعات (Output Tax)',
        rows: [
          [
            'المبيعات الخاضعة للنسبة الأساسية',
            data.standardSalesBase,
            data.standardSalesTax,
          ],
          [
            'المبيعات للمواطنين (الخدمات الصحية/التعليمية)',
            Decimal.zero,
            Decimal.zero,
          ], // Placeholder
          ['المبيعات الصفرية', data.zeroRatedSales, Decimal.zero],
          ['المبيعات المعفاة', data.exemptSales, Decimal.zero],
        ],
      );

  pw.Widget _buildPurchasesSection(VatReturnStatement data) => _buildSectionTable(
        title: 'ضريبة القيمة المضافة على المشتريات (Input Tax)',
        rows: [
          [
            'المشتريات الخاضعة للنسبة الأساسية',
            data.standardPurchasesBase,
            data.standardPurchasesTax,
          ],
          ['المشتريات الصفرية', Decimal.zero, Decimal.zero],
          ['المشتريات المعفاة', Decimal.zero, Decimal.zero],
        ],
      );

  pw.Widget _buildSectionTable({
    required String title,
    required List<List<dynamic>> rows,
  }) =>
      pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue800,
            ),
          ),
          pw.SizedBox(height: 5),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey300),
            children: [
              // Header
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey100),
                children: [
                  _buildTableCell('الوصف', isHeader: true),
                  _buildTableCell(
                    'المبلغ (SAR)',
                    isHeader: true,
                    alignRight: true,
                  ),
                  _buildTableCell(
                    'مبلغ التعديل',
                    isHeader: true,
                    alignRight: true,
                  ),
                  _buildTableCell(
                    'مبلغ الضريبة',
                    isHeader: true,
                    alignRight: true,
                  ),
                ],
              ),
              // Rows
              ...rows.map((row) {
                final label = row[0] as String;
                final amount = row[1] as Decimal;
                final tax = row[2] as Decimal;
                return pw.TableRow(
                  children: [
                    _buildTableCell(label),
                    _buildTableCell(
                      FormatHelpers.formatNumber(amount),
                      alignRight: true,
                    ),
                    _buildTableCell(
                      '0.00',
                      alignRight: true,
                    ), // Adjustment placeholder
                    _buildTableCell(
                      FormatHelpers.formatNumber(tax),
                      alignRight: true,
                    ),
                  ],
                );
              }),
            ],
          ),
        ],
      );

  pw.Widget _buildTableCell(
    String text, {
    bool isHeader = false,
    bool alignRight = false,
  }) =>
      pw.Padding(
        padding: const pw.EdgeInsets.all(5),
        child: pw.Text(
          text,
          textAlign: alignRight ? pw.TextAlign.right : pw.TextAlign.left,
          style: isHeader ? pw.TextStyle(fontWeight: pw.FontWeight.bold) : null,
        ),
      );

  pw.Widget _buildNetVatSection(VatReturnStatement data) => pw.Container(
        color: PdfColors.blue50,
        padding: const pw.EdgeInsets.all(15),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'صافي الضريبة المستحقة للدفع / الاسترداد',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              '${FormatHelpers.formatNumber(data.netVatDue)} SAR',
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue900,
              ),
            ),
          ],
        ),
      );

  pw.Widget _buildFooter() => pw.Column(
        children: [
          pw.Divider(color: PdfColors.grey400),
          pw.Center(
            child: pw.Text(
              'تم إنشاء هذا التقرير آلياً بواسطة نظام بصير المحاسبي',
              style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
            ),
          ),
        ],
      );
}
