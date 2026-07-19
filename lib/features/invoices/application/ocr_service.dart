/// ***
/// Cognitive Foundation: OcrService
///
/// High-fidelity optical character recognition for automated data ingestion.
/// Uses Google ML Kit to extract institutional financial metadata from physical
/// receipts and invoices.
///
/// Ref: BASIR-OCR-SPEC-2025
/// ***
library;

import 'package:decimal/decimal.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ocr_service.g.dart';

/// [OcrService]
@riverpod
class OcrService extends _$OcrService {
  @override
  void build() {}

  /// Orchestrates the forensic analysis of a physical document.
  /// Returns a map of extracted institutional metadata (Total [Decimal], Date).
  Future<Map<String, dynamic>> processReceipt(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);
    final textRecognizer = TextRecognizer();

    try {
      final recognizedText = await textRecognizer.processImage(inputImage);

      Decimal? total;
      DateTime? date;

      // Heuristic extraction engine for institutional financial patterns
      for (final block in recognizedText.blocks) {
        for (final line in block.lines) {
          final text = line.text.toLowerCase();

          // Pattern: Total/Amount Detection
          if (text.contains('total') ||
              text.contains('amount') ||
              text.contains('الاجمالي')) {
            final regExp = RegExp(r'(\d+[\.,]\d+)');
            final match = regExp.firstMatch(text);
            if (match != null) {
              final cleanValue = match.group(1)!.replaceAll(',', '.');
              total = Decimal.tryParse(cleanValue);
            }
          }

          // Pattern: Temporal Metadata Detection
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
