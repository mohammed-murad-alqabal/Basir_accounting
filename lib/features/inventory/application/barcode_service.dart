import 'dart:math';

import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/inventory/domain/entities/inventory_item.dart';
import 'package:basir_accounting_system/features/settings/domain/entities/barcode_config.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'barcode_service.g.dart';

/// خدمة محرك الباركود (Barcode Engine Service)
@riverpod
class BarcodeService extends _$BarcodeService {
  @override
  void build() {}

  /// توليد باركود عشوائي فريد (رقمي فقط بطول 12-13 رقم)
  String generateRandomBarcode() {
    final random = Random();
    final buffer = StringBuffer('629'); // بادئة دولية (مثال: الإمارات)
    for (var i = 0; i < 9; i++) {
      buffer.write(random.nextInt(10));
    }
    return buffer.toString();
  }

  /// إنشاء ملف PDF للملصقات بناءً على الإعدادات والصنف
  Future<void> printLabels({
    required InventoryItem item,
    required int count,
    BarcodeConfig? config,
  }) async {
    final activeConfig =
        config ?? await ref.read(barcodeConfigRepositoryProvider).getConfig();
    final doc = pw.Document();

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat(
          activeConfig.width * PdfPageFormat.mm,
          activeConfig.height * PdfPageFormat.mm,
          marginAll: activeConfig.margin * PdfPageFormat.mm,
        ),
        build: (context) => [
          for (var i = 0; i < count; i++)
            pw.Container(
              width: activeConfig.width * PdfPageFormat.mm,
              height: activeConfig.height * PdfPageFormat.mm,
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  if (activeConfig.showItemName)
                    pw.Text(
                      item.nameAr,
                      style: const pw.TextStyle(fontSize: 8),
                      textDirection: pw.TextDirection.rtl,
                    ),
                  pw.SizedBox(height: 2),
                  pw.BarcodeWidget(
                    barcode: pw.Barcode.code128(),
                    data: item.barcode ?? item.sku ?? '000000',
                    width: (activeConfig.width - 4) * PdfPageFormat.mm,
                    height: (activeConfig.height * 0.5) * PdfPageFormat.mm,
                  ),
                  pw.SizedBox(height: 2),
                  if (activeConfig.showPrice)
                    pw.Text(
                      '${item.salePrice ?? 0.0} SAR',
                      style: pw.TextStyle(
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => doc.save(),
      name: 'barcode_${item.nameAr}.pdf',
    );
  }
}
