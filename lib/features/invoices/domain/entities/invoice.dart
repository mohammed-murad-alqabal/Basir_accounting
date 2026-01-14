/// ***
/// Cognitive Foundation: Invoice Entity
///
/// High-fidelity entity representing a financial transaction (Sales/Purchase).
/// Complies with IFRS 18 and ZATCA Phase 2 standards.
///
/// Uses [Decimal] for all financial calculations to ensure absolute precision
/// across institutional accounting workflows.
/// ***
library;

import 'package:basir_accounting_system/core/models/sync_status.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice_status.dart';
import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'invoice.freezed.dart';
part 'invoice.g.dart';

/// [InvoiceItem]
///
/// Represents a single line item within an invoice.
@freezed
class InvoiceItem with _$InvoiceItem {
  /// Standard constructor for invoice line items.
  factory InvoiceItem({
    required String id,
    required String name,
    required Decimal quantity,
    required Decimal price,

    /// Calculated subtotal: quantity * price.
    required Decimal total,

    /// VAT amount calculated for this specific item.
    required Decimal taxAmount,

    /// VAT rate applied to this item (e.g., 0.15, 0.05, 0.0).
    required Decimal taxRate,

    /// Semantic description or notes.
    String? description,

    /// VAT category (e.g., 'S' for Standard, 'Z' for Zero, etc.)
    @Default('S') String taxCategory,
  }) = _InvoiceItem;

  /// Factory for JSON hydration.
  factory InvoiceItem.fromJson(Map<String, dynamic> json) =>
      _$InvoiceItemFromJson(json);

  const InvoiceItem._();

  /// Calculated getter for tax amount if null.
  Decimal get effectiveTaxAmount => taxAmount;
}

/// [Invoice]
///
/// The central entity for revenue and expense recording.
/// Bridges the gap between operational sales and the General Ledger.
@freezed
class Invoice with _$Invoice {
  /// Standard constructor for institutional invoices.
  factory Invoice({
    /// Unique immutable identifier (UUID).
    required String id,

    /// Human-readable sequential reference code.
    required String invoiceNumber,

    /// Target entity identifier.
    required String customerId,
    required String customerName,

    /// Granular list of products or services.
    required List<InvoiceItem> items,

    /// Execution and audit timestamps.
    required DateTime issuedDate,
    required DateTime dueDate,
    required DateTime createdAt,
    required DateTime updatedAt,

    /// Transaction lifecycle status.
    required InvoiceStatus status,

    /// Financial aggregates (Persisted for Data Integrity).
    required Decimal subtotalAmount,
    required Decimal taxAmount,
    required Decimal discountAmount,
    required Decimal totalAmount,
    required Decimal paidAmount,

    /// Rates and adjustments.
    required Decimal taxRate,
    required Decimal discountRate,
    DateTime? paidDate,

    /// Multi-currency support (Default: SAR).
    @Default('SAR') String currency,

    /// Institutional memos and terms.
    String? notes,
    String? terms,

    /// ZATCA (Fatoora) Compliance Data.
    String? zatcaUuid,
    String? zatcaHash,
    String? qrCode,
    String? xmlContent,
    String? zatcaDeviceId,
    @Default(0) int zatcaCounter,

    /// Data isolation handle.
    String? userId,

    /// Warehouse scope identifier.
    String? warehouseId,

    /// Distributed ledger synchronization state.
    @Default(SyncStatus.synced) SyncStatus syncStatus,

    /// Authority-verified timestamp.
    DateTime? serverUpdatedAt,

    /// Soft-deletion flag for audit preservation.
    @Default(false) bool isDeleted,
  }) = _Invoice;

  /// Factory for JSON hydration.
  factory Invoice.fromJson(Map<String, dynamic> json) =>
      _$InvoiceFromJson(json);

  const Invoice._();

  /// Calculates the outstanding liability.
  Decimal get remainingAmount => totalAmount - paidAmount;

  /// Validates the settlement status against temporal constraints.
  bool get isOverdue {
    if (status == InvoiceStatus.paid || status == InvoiceStatus.cancelled) {
      return false;
    }
    return DateTime.now().isAfter(dueDate);
  }
}
