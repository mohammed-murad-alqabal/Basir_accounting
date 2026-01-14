// ignore_for_file: lines_longer_than_80_chars
import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice_status.dart';
import 'package:basir_accounting_system/src/rust/api.dart';
import 'package:basir_accounting_system/src/rust/api/sales.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:uuid/uuid.dart';

/// [SalesBridgeService]
///
/// Bridges the Flutter Invoices module with the Rust-based Sales core.
/// Handles ZATCA Phase 2 compliance by delegating to the Rust API.
class SalesBridgeService {
  /// Standard constructor for [SalesBridgeService].
  SalesBridgeService(this.ref);

  /// The Riverpod reference for dependency injection.
  final Ref ref;

  /// Synchronizes an invoice with the Rust core and performs ZATCA
  /// compliance steps.
  Future<Invoice> finalizeInvoiceWithZatca(Invoice invoice) async {
    final user = ref.read(basirUserProvider);

    // Dynamic metadata retrieval
    final deviceInfo = DeviceInfoPlugin();
    String? deviceId;
    try {
      final androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.id;
    } on Object catch (_) {
      deviceId = 'basir-generic-device';
    }

    final packageInfo = await PackageInfo.fromPlatform();

    final metadata = AuditMetadataDto(
      who: WhoDto(
        userId: user?.id ?? 'anonymous',
        userName: user?.displayName ?? 'Anonymous',
        role: user?.isGuest ?? false ? 'guest' : 'user',
        sessionId: const Uuid().v4(),
      ),
      where: WhereDto(
        systemId: 'Basir-Mobile',
        deviceId: deviceId,
        appVersion: packageInfo.version,
      ),
      why: const WhyDto(
        justification: 'ZATCA Phase 2 Compliance Finalization',
      ),
      how: const HowDto(
        method: 'SalesBridgeService.finalizeInvoiceWithZatca',
      ),
    );

    final salesDto = SalesInvoiceDto(
      id: invoice.id,
      invoiceNumber: invoice.invoiceNumber,
      customerId: invoice.customerId,
      invoiceDate: invoice.issuedDate.toUtc().toIso8601String(),
      dueDate: invoice.dueDate.toUtc().toIso8601String(),
      status: _mapStatus(invoice.status),
      totalAmount: invoice.totalAmount.toString(),
      balanceDue: (invoice.totalAmount - invoice.paidAmount).toString(),
      description: invoice.notes,
      incomeAccountId: 'acc-4101', // Default revenue
      arAccountId: 'acc-1201', // Default AR
    );

    final lines = invoice.items
        .map(
          (item) => SalesInvoiceLineDto(
            productId: item.id,
            description: item.name,
            quantity: item.quantity.toString(),
            unitPrice: item.price.toString(),
            taxAmount: item.taxAmount.toString(),
            taxCategory: item.taxCategory,
          ),
        )
        .toList();

    // 1. Create/Update in Rust core
    await createInvoice(invoice: salesDto, lines: lines, metadata: metadata);

    // 2. Post and perform ZATCA compliance checks
    if (invoice.status != InvoiceStatus.draft) {
      await postInvoice(id: invoice.id, metadata: metadata);

      // 3. Retrieve updated invoice with compliance data (QR Code, Hash, etc.)
      final updatedDto = await getInvoiceById(id: invoice.id);
      if (updatedDto != null) {
        return invoice.copyWith(
          qrCode: updatedDto.qrCodeData,
          // Note: In a real scenario, we'd also sync the XML content and Hash
          // if we add them to the DTO and the domain entity.
        );
      }
    }

    return invoice;
  }

  String _mapStatus(InvoiceStatus status) {
    switch (status) {
      case InvoiceStatus.draft:
        return 'Draft';
      case InvoiceStatus.sent:
        return 'Open';
      case InvoiceStatus.paid:
        return 'Paid';
      case InvoiceStatus.overdue:
        return 'Overdue';
      case InvoiceStatus.cancelled:
        return 'Cancelled';
      case InvoiceStatus.refunded:
        return 'Refunded';
    }
  }
}

/// [salesBridgeServiceProvider]
///
/// Provider for the [SalesBridgeService] instance.
final salesBridgeServiceProvider = Provider(SalesBridgeService.new);
