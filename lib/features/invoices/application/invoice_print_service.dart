import 'package:basir_accounting_system/features/invoices/domain/entities/invoice.dart';
import 'package:basir_accounting_system/features/reports/application/pdf_generation_service.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:basir_accounting_system/services/settings_service.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';

/// [InvoicePrintService]
///
/// Specialized engine for generating thermal POS receipts.
/// Optimized for Roll 80mm and Roll 58mm formats.
/// Delegates high-fidelity rendering to [PdfGenerationService].
class InvoicePrintService {
  /// Creating the [InvoicePrintService] with [SettingsService]
  /// and [PdfGenerationService].
  InvoicePrintService(this._settingsService, this._pdfService);

  final SettingsService _settingsService;
  final PdfGenerationService _pdfService;

  /// Generates a POS receipt PDF using the centralized [PdfGenerationService].
  Future<Uint8List> generateReceiptPdf(
    Invoice invoice,
    AppLocalizations l10n, {
    PdfPageFormat format = PdfPageFormat.roll80,
  }) async {
    final settings = await _settingsService.getCompanySettings();

    // Delegate to the specialized high-fidelity generator
    return _pdfService.generateThermalReceipt(
      invoice,
      companySettings: settings,
    );
  }
}
