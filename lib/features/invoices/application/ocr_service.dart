import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ocr_service.g.dart';

/// خدمة التعرف الضوئي على الحروف (OCR Service)
///
/// تستخدم لاستخراج البيانات من فواتير المشتريات والإيصالات.
@riverpod
class OcrService extends _$OcrService {
  @override
  void build() {}

  /// Processes an image and returns extracted data (Total, Date).
  Future<Map<String, dynamic>> processReceipt(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);
    final textRecognizer = TextRecognizer();

    try {
      final recognizedText = await textRecognizer.processImage(inputImage);

      double? total;
      DateTime? date;

      // Simple heuristic for totals and dates
      for (final block in recognizedText.blocks) {
        for (final line in block.lines) {
          final text = line.text.toLowerCase();

          // Look for total/amount
          if (text.contains('total') ||
              text.contains('amount') ||
              text.contains('الاجمالي')) {
            final regExp = RegExp(r'(\d+[\.,]\d+)');
            final match = regExp.firstMatch(text);
            if (match != null) {
              total = double.tryParse(match.group(1)!.replaceAll(',', '.'));
            }
          }

          // Look for date
          final dateRegExp = RegExp(r'(\d{2,4}[-/]\d{2}[-/]\d{2,4})');
          final dateMatch = dateRegExp.firstMatch(text);
          if (dateMatch != null) {
            date = DateTime.tryParse(dateMatch.group(1)!);
          }
        }
      }

      return {
        'total': total,
        'date': date,
        'rawText': recognizedText.text,
      };
    } finally {
      await textRecognizer.close();
    }
  }
}
