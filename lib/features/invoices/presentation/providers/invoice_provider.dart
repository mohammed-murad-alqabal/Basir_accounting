import 'package:basser_app/core/providers.dart';
import 'package:basser_app/features/invoices/data/services/pdf_service.dart';
import 'package:basser_app/features/invoices/domain/entities/invoice.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider لخدمة PDF
final pdfServiceProvider = Provider((ref) {
  final settingsService = ref.watch(settingsServiceProvider);
  return PdfService(settingsService: settingsService);
});

/// Provider لقائمة جميع الفواتير
final invoicesProvider = FutureProvider<List<Invoice>>((ref) async {
  final repository = ref.watch(
    invoiceRepositoryProvider,
  );
  return repository.getAllInvoices();
});

/// Provider لإضافة فاتورة جديدة
final addInvoiceProvider = FutureProvider.family<bool, Invoice>((
  ref,
  invoice,
) async {
  final repository = ref.watch(
    invoiceRepositoryProvider.select((repo) => repo),
  );

  try {
    await repository.addInvoice(
      invoice,
    );
    ref.invalidate(
      invoicesProvider,
    );
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
  final repository = ref.watch(
    invoiceRepositoryProvider.select((repo) => repo),
  );

  try {
    await repository.updateInvoice(
      invoice,
    );
    ref.invalidate(
      invoicesProvider,
    );
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
  final repository = ref.watch(
    invoiceRepositoryProvider.select((repo) => repo),
  );

  try {
    await repository.deleteInvoice(
      invoiceId,
    );
    ref.invalidate(
      invoicesProvider,
    );
    return true;
  } on Exception {
    return false;
  }
});

/// State Provider لحالة البحث
final invoiceSearchProvider = StateProvider<String>(
  (ref) => '',
);

/// State Provider لحالة الفلتر
final invoiceFilterProvider = StateProvider<String>(
  (ref) => 'الكل',
);

/// Provider لقائمة الفواتير المفلترة حسب البحث والحالة
final filteredInvoicesProvider = Provider<AsyncValue<List<Invoice>>>((ref) {
  final searchQuery = ref.watch(
    invoiceSearchProvider.select((value) => value),
  );
  final filterStatus = ref.watch(
    invoiceFilterProvider.select((value) => value),
  );
  final invoicesAsync = ref.watch(
    invoicesProvider,
  );

  return invoicesAsync.whenData((invoices) {
    var filtered = invoices;

    if (filterStatus != 'الكل') {
      filtered =
          filtered.where((invoice) => invoice.status == filterStatus).toList();
    }

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
  final invoicesAsync = ref.watch(
    invoicesProvider,
  );

  return invoicesAsync.whenData(
    (invoices) =>
        invoices.fold<double>(0, (sum, invoice) => sum + invoice.grandTotal),
  );
});

/// Provider لحساب عدد الفواتير المتأخرة
final overdueInvoicesCountProvider = Provider<AsyncValue<int>>((ref) {
  final invoicesAsync = ref.watch(
    invoicesProvider,
  );

  return invoicesAsync.whenData(
    (invoices) =>
        invoices.where((invoice) => invoice.status == 'overdue').length,
  );
});

/// Provider محسن لحالة البحث (مع debouncing)
final searchQueryProvider = Provider<String>(
  (ref) => ref.watch(invoiceSearchProvider.select((query) => query.trim())),
);

/// Provider محسن لحالة الفلتر
final filterStatusProvider = Provider<String>(
  (ref) => ref.watch(invoiceFilterProvider.select((status) => status)),
);

/// Provider لعدد الفواتير الإجمالي
final invoicesCountProvider = Provider<AsyncValue<int>>(
  (ref) => ref.watch(
    invoicesProvider.select(
      (asyncInvoices) => asyncInvoices.whenData((invoices) => invoices.length),
    ),
  ),
);

/// Provider لحالة وجود فواتير
final hasInvoicesProvider = Provider<AsyncValue<bool>>(
  (ref) => ref.watch(
    invoicesProvider.select(
      (asyncInvoices) =>
          asyncInvoices.whenData((invoices) => invoices.isNotEmpty),
    ),
  ),
);

/// نموذج إحصائيات الفواتير
class InvoiceStatistics {
  /// إنشاء نموذج إحصائيات
  InvoiceStatistics({
    required this.totalInvoices,
    required this.paidInvoices,
    required this.overdueInvoices,
    required this.totalAmount,
  });

  /// إجمالي عدد الفواتير
  final int totalInvoices;

  /// عدد الفواتير المدفوعة
  final int paidInvoices;

  /// عدد الفواتير المتأخرة
  final int overdueInvoices;

  /// إجمالي المبلغ
  final double totalAmount;
}

/// Provider لإحصائيات الفواتير
final invoiceStatisticsProvider =
    Provider<AsyncValue<InvoiceStatistics>>((ref) {
  final invoicesAsync = ref.watch(invoicesProvider);

  return invoicesAsync.whenData(
    (invoices) => InvoiceStatistics(
      totalInvoices: invoices.length,
      paidInvoices: invoices.where((i) => i.status == 'paid').length,
      overdueInvoices: invoices.where((i) => i.status == 'overdue').length,
      totalAmount: invoices.fold(0, (sum, i) => sum + i.grandTotal),
    ),
  );
});
