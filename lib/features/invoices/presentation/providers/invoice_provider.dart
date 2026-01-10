import 'package:basir_app/core/providers.dart';
import 'package:basir_app/features/accounting/application/accounting_service.dart';
import 'package:basir_app/features/invoices/domain/entities/invoice.dart';
import 'package:basir_app/features/invoices/domain/entities/invoice_status.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  final repository = ref.watch(
    invoiceRepositoryProvider.select((repo) => repo),
  );

  try {
    await repository.addInvoice(invoice);

    // ترحيل القيد المحاسبي تلقائياً (نظام القيد المزدوج)
    if (invoice.status == InvoiceStatus.sent || invoice.status == InvoiceStatus.paid) {
      final accountingService = ref.read(accountingServiceProvider.notifier);
      await accountingService.postSalesInvoice(invoice);
    }
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
  final repository = ref.watch(
    invoiceRepositoryProvider.select((repo) => repo),
  );

  try {
    await repository.updateInvoice(invoice);

    // ترحيل أو تحديث القيد المحاسبي (نظام القيد المزدوج)
    if (invoice.status == InvoiceStatus.sent || invoice.status == InvoiceStatus.paid) {
      final accountingService = ref.read(accountingServiceProvider.notifier);
      await accountingService.postSalesInvoice(invoice);
    }
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
  final repository = ref.watch(
    invoiceRepositoryProvider.select((repo) => repo),
  );

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
final invoiceFilterProvider = StateProvider<String>((ref) => 'all');

/// Provider لقائمة الفواتير المفلترة حسب البحث والحالة
final filteredInvoicesProvider = Provider<AsyncValue<List<Invoice>>>((ref) {
  final searchQuery = ref.watch(invoiceSearchProvider.select((value) => value));
  final filterStatus = ref.watch(
    invoiceFilterProvider.select((value) => value),
  );
  final invoicesAsync = ref.watch(invoicesProvider);

  return invoicesAsync.whenData((invoices) {
    var filtered = invoices;

    if (filterStatus != 'all' && filterStatus != 'الكل') {
      filtered = filtered.where((invoice) {
        if (filterStatus == 'draft') {
          return invoice.status == InvoiceStatus.draft;
        }
        if (filterStatus == 'paid') return invoice.status == InvoiceStatus.paid;
        if (filterStatus == 'overdue') {
          return invoice.status == InvoiceStatus.overdue;
        }
        if (filterStatus == 'sent' || filterStatus == 'issued') {
          return invoice.status == InvoiceStatus.sent;
        }
        if (filterStatus == 'cancelled') {
          return invoice.status == InvoiceStatus.cancelled;
        }
        if (filterStatus == 'refunded') {
          return invoice.status == InvoiceStatus.refunded;
        }
        return false;
      }).toList();
    }

    if (searchQuery.isNotEmpty) {
      filtered = filtered
          .where(
            (invoice) =>
                invoice.invoiceNumber.contains(searchQuery) ||
                invoice.id.contains(searchQuery) ||
                invoice.customerName.contains(searchQuery),
          )
          .toList();
    }

    return filtered;
  });
});

/// Provider لحساب إجمالي المبيعات
final totalSalesProvider = Provider<AsyncValue<Decimal>>((ref) {
  final invoicesAsync = ref.watch(invoicesProvider);

  return invoicesAsync.whenData(
    (invoices) => invoices.fold<Decimal>(Decimal.zero, (sum, invoice) => sum + invoice.totalAmount),
  );
});

/// Provider لحساب عدد الفواتير المتأخرة
final overdueInvoicesCountProvider = Provider<AsyncValue<int>>((ref) {
  final invoicesAsync = ref.watch(invoicesProvider);

  return invoicesAsync.whenData(
    (invoices) => invoices.where((invoice) => invoice.status == InvoiceStatus.overdue).length,
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
      (asyncInvoices) => asyncInvoices.whenData((invoices) => invoices.isNotEmpty),
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
  final Decimal totalAmount;
}

/// Provider لإحصائيات الفواتير
final invoiceStatisticsProvider = Provider<AsyncValue<InvoiceStatistics>>((
  ref,
) {
  final invoicesAsync = ref.watch(invoicesProvider);

  return invoicesAsync.whenData(
    (invoices) => InvoiceStatistics(
      totalInvoices: invoices.length,
      paidInvoices: invoices.where((i) => i.status == InvoiceStatus.paid).length,
      overdueInvoices: invoices.where((i) => i.status == InvoiceStatus.overdue).length,
      totalAmount: invoices.fold<Decimal>(
        Decimal.zero,
        (sum, i) => sum + i.totalAmount,
      ),
    ),
  );
});

/// Provider لمضاعفة فاتورة (Logic from Go backend)
final duplicateInvoiceProvider = FutureProvider.family<Invoice, String>((
  ref,
  invoiceId,
) async {
  final repository = ref.watch(invoiceRepositoryProvider);
  final duplicated = await repository.duplicateInvoice(invoiceId);
  ref.invalidate(invoicesProvider);
  return duplicated;
});

/// Provider لتحديد فاتورة كمدفوعة (Logic from Go backend)
final markInvoiceAsPaidProvider = FutureProvider.family<bool, String>((
  ref,
  invoiceId,
) async {
  final repository = ref.watch(invoiceRepositoryProvider);

  try {
    final invoice = await repository.getInvoiceById(invoiceId);
    if (invoice == null) return false;

    // تكييف المنطق من Go: تحديث مبالغ الدفع والحالة
    final updatedInvoice = invoice.copyWith(
      status: InvoiceStatus.paid,
      paidAmount: invoice.totalAmount,
      paidDate: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await repository.updateInvoice(updatedInvoice);

    // ترحيل القيد المحاسبي تلقائياً عند الدفع (إذا لم يرحل عند الإرسال)
    final accountingService = ref.read(accountingServiceProvider.notifier);
    await accountingService.postSalesInvoice(updatedInvoice);

    ref.invalidate(invoicesProvider);
    return true;
  } on Exception {
    return false;
  }
});

/// Provider لإرسال الفاتورة (تغيير الحالة)
final sendInvoiceProvider = FutureProvider.family<bool, String>((
  ref,
  invoiceId,
) async {
  final repository = ref.watch(invoiceRepositoryProvider);

  try {
    final invoice = await repository.getInvoiceById(invoiceId);
    if (invoice == null) return false;

    final updatedInvoice = invoice.copyWith(
      status: InvoiceStatus.sent,
      updatedAt: DateTime.now(),
    );

    await repository.updateInvoice(updatedInvoice);

    // ترحيل القيد المحاسبي عند الانتقال لحالة 'مرسلة'
    final accountingService = ref.read(accountingServiceProvider.notifier);
    await accountingService.postSalesInvoice(updatedInvoice);

    ref.invalidate(invoicesProvider);
    return true;
  } on Exception {
    return false;
  }
});

/// Provider لإلغاء الفاتورة
final cancelInvoiceProvider = FutureProvider.family<bool, String>((
  ref,
  invoiceId,
) async {
  final repository = ref.watch(invoiceRepositoryProvider);

  try {
    final invoice = await repository.getInvoiceById(invoiceId);
    if (invoice == null) return false;

    final updatedInvoice = invoice.copyWith(
      status: InvoiceStatus.cancelled,
      updatedAt: DateTime.now(),
    );

    await repository.updateInvoice(updatedInvoice);
    ref.invalidate(invoicesProvider);
    return true;
  } on Exception {
    return false;
  }
});
