import 'package:basir_accounting_system/features/invoices/domain/entities/invoice.dart';
import 'package:basir_accounting_system/features/reports/application/pdf_generation_service.dart';
import 'package:basir_accounting_system/services/settings_service.dart';
import 'package:flutter/services.dart';

/// [InvoicePdfService]
///
/// High-fidelity PDF generation engine for institutional invoices.
/// Delegates rendering to [PdfGenerationService].
class InvoicePdfService {
  /// Creating the [InvoicePdfService] with [SettingsService]
  /// and [PdfGenerationService].
  InvoicePdfService(this._settingsService, this._pdfService);

  final SettingsService _settingsService;
  final PdfGenerationService _pdfService;

  /// Generates a professional PDF document for the given [invoice].
  Future<Uint8List> generateInvoicePdf(
    Invoice invoice, {
    String locale = 'ar',
  }) async {
    final settings = await _settingsService.getCompanySettings();

    // Delegate to the centralized rendering engine
    return _pdfService.generateInvoicePdf(
      invoice,
      companySettings: settings,
    );
  }
}
