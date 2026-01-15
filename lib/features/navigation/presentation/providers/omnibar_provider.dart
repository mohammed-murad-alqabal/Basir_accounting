import 'package:basir_accounting_system/features/customers/presentation/providers/customer_provider.dart';
import 'package:basir_accounting_system/features/inventory/presentation/providers/inventory_provider.dart';
import 'package:basir_accounting_system/features/invoices/presentation/providers/invoice_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Institutional search result model for the global Omnibar.
class OmnibarResult {
  /// Standard constructor for search result.
  OmnibarResult({
    required this.title,
    required this.subtitle,
    required this.type,
    this.data,
  });

  /// Primary display label (e.g. Invoice Number or Customer Name).
  final String title;

  /// Secondary display label (e.g. Total Amount or Phone Number).
  final String subtitle;

  /// Underlying domain object (Invoice, Customer, etc.).
  final dynamic data;

  /// Categorization of the result for routing and iconography.
  final OmnibarResultType type;
}

/// Categorization of Omnibar results for institutional routing.
enum OmnibarResultType {
  /// Financial document.
  invoice,

  /// Institutional stakeholder.
  customer,

  /// Inventory item.
  item,

  /// System command or navigation target.
  action,
}

/// مزود نتائج البحث في الـ Omnibar
final omnibarSearchProvider =
    Provider.family<List<OmnibarResult>, String>((ref, query) {
  if (query.isEmpty) return [];

  final invoicesAsync = ref.watch(invoicesProvider);
  final customersAsync = ref.watch(customersProvider);
  final itemsAsync = ref.watch(inventoryItemsProvider);

  final invoices = invoicesAsync.asData?.value ?? [];
  final customers = customersAsync.asData?.value ?? [];
  final items = itemsAsync.asData?.value ?? [];

  final results = <OmnibarResult>[];

  // بحث في الفواتير
  for (final inv in invoices) {
    if (inv.invoiceNumber.contains(query) || inv.customerName.contains(query)) {
      results.add(
        OmnibarResult(
          title: 'فاتورة ${inv.invoiceNumber}',
          subtitle: inv.customerName,
          data: inv,
          type: OmnibarResultType.invoice,
        ),
      );
    }
  }

  // بحث في العملاء
  for (final cust in customers) {
    if (cust.nameAr.contains(query) ||
        cust.nameEn.toLowerCase().contains(query.toLowerCase()) ||
        (cust.phone?.contains(query) ?? false)) {
      results.add(
        OmnibarResult(
          title: cust.nameAr,
          subtitle: cust.phone ?? '',
          data: cust,
          type: OmnibarResultType.customer,
        ),
      );
    }
  }

  // بحث في الأصناف
  for (final item in items) {
    if (item.nameAr.contains(query) ||
        item.nameEn.toLowerCase().contains(query.toLowerCase()) ||
        (item.sku?.contains(query) ?? false)) {
      results.add(
        OmnibarResult(
          title: item.nameAr,
          subtitle: 'SKU: ${item.sku ?? '-'}',
          data: item,
          type: OmnibarResultType.item,
        ),
      );
    }
  }

  return results;
});
