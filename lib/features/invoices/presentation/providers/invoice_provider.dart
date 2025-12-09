import 'package:basser_app/core/providers.dart';
import 'package:basser_app/features/invoices/data/services/pdf_service.dart';
import 'package:basser_app/features/invoices/domain/entities/invoice.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider لخدمة PDF
final pdfServiceProvider = Provider((ref) => PdfService());

/// Provider لقائمة جميع الفواتير
final invoicesProvider = FutureProvider<List<Invoice>>((ref) async {
  final repository = ref.watch(invoiceRepositoryProvider);
  return repository.getAllInvoices();
});

/// Provider لإضافة فاتورة جديدة
final addInvoiceProvider = FutureProvider.family<bool, Invoice>((
  ref,
  invoice,
) async {
  final repository = ref.watch(invoiceRepositoryProvider);

  try {
    await repository.addInvoice(invoice);
    ref.invalidate(invoicesProvider);
    return true;
  } on Exception {
    return false;
  }
});

/// Provider لتحديث فاتورة
final updateInvoiceProvider = FutureProvider.family<bool, Invoice>((
  ref,
  invoice,
) async {
  final repository = ref.watch(invoiceRepositoryProvider);

  try {
    await repository.updateInvoice(invoice);
    ref.invalidate(invoicesProvider);
    return true;
  } on Exception {
    return false;
  }
});

/// Provider لحذف فاتورة
final deleteInvoiceProvider = FutureProvider.family<bool, String>((
  ref,
  invoiceId,
) async {
  final repository = ref.watch(invoiceRepositoryProvider);

  try {
    await repository.deleteInvoice(invoiceId);
    ref.invalidate(invoicesProvider);
    return true;
  } on Exception {
    return false;
  }
});

/// State Provider لحالة البحث
final invoiceSearchProvider = StateProvider<String>((ref) => '');

/// State Provider لحالة الفلتر
final invoiceFilterProvider = StateProvider<String>((ref) => 'الكل');

/// Provider لقائمة الفواتير المفلترة حسب البحث والحالة
final filteredInvoicesProvider = Provider<AsyncValue<List<Invoice>>>((ref) {
  final searchQuery = ref.watch(invoiceSearchProvider);
  final filterStatus = ref.watch(invoiceFilterProvider);
  final invoicesAsync = ref.watch(invoicesProvider);

  return invoicesAsync.whenData((invoices) {
    var filtered = invoices;

    // تطبيق فلتر الحالة
    if (filterStatus != 'الكل') {
      filtered =
          filtered.where((invoice) => invoice.status == filterStatus).toList();
    }

    // تطبيق البحث
    if (searchQuery.isNotEmpty) {
      filtered = filtered
          .where(
            (invoice) =>
                invoice.id.contains(searchQuery) ||
                invoice.customerName.contains(searchQuery),
          )
          .toList();
    }

    return filtered;
  });
});

/// Provider لحساب إجمالي المبيعات
final totalSalesProvider = Provider<AsyncValue<double>>((ref) {
  final invoicesAsync = ref.watch(invoicesProvider);

  return invoicesAsync.whenData(
    (invoices) =>
        invoices.fold<double>(0, (sum, invoice) => sum + invoice.grandTotal),
  );
});

/// Provider لحساب عدد الفواتير المتأخرة
final overdueInvoicesCountProvider = Provider<AsyncValue<int>>((ref) {
  final invoicesAsync = ref.watch(invoicesProvider);

  return invoicesAsync.whenData(
    (invoices) =>
        invoices.where((invoice) => invoice.status == 'overdue').length,
  );
});
