import 'package:freezed_annotation/freezed_annotation.dart';

/// ***
/// Institutional Domain: InvoiceType
///
/// Defines the specific categorization for financial transactions.
/// Bridges the gap between operational inventory events and ledger entries.
/// ***
enum InvoiceType {
  /// Standard revenue-generating sale.
  @JsonValue('sales')
  sales,

  /// Inventory acquisition or expense.
  @JsonValue('purchase')
  purchase,

  /// customer returning items (Revenue reversal).
  @JsonValue('sales_return')
  salesReturn,

  /// Returning items to vendor (Inventory reduction).
  @JsonValue('purchase_return')
  purchaseReturn,

  /// Inventory loss or intentional destruction.
  @JsonValue('damage')
  damage,
}
