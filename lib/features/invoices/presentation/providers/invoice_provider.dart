import 'package:basir_accounting_system/core/extensions/string_extensions.dart';
import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/accounting/application/accounting_service.dart';
import 'package:basir_accounting_system/features/accounting/domain/exceptions/cognitive_exceptions.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice_status.dart';
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
    // ignore: lines_longer_than_80_chars
    if (invoice.status == InvoiceStatus.sent ||
        invoice.status == InvoiceStatus.paid) {
      final accountingService = ref.read(accountingServiceProvider.notifier);
      await accountingService.postInvoice(invoice);
    }

    // Schedule notification for due date
    if (invoice.status != InvoiceStatus.paid) {
      final notificationService = ref.read(notificationServiceProvider);
      await notificationService.initialize();
      await notificationService.scheduleNotification(
        id: invoice.id.hashCode,
        title: 'Invoice Due: ${invoice.invoiceNumber}',
        body: 'Invoice for ${invoice.customerName} is due today.',
        scheduledDate: invoice.dueDate,
      );
    }

    ref.invalidate(invoicesProvider);
    return true;
  } on CognitiveConsensusException {
    rethrow;
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
    // ignore: lines_longer_than_80_chars
    if (invoice.status == InvoiceStatus.sent ||
        invoice.status == InvoiceStatus.paid) {
      final accountingService = ref.read(accountingServiceProvider.notifier);
      await accountingService.postInvoice(invoice);
    }

    // Update notification
    final notificationService = ref.read(notificationServiceProvider);
    await notificationService.initialize();

    // Cancel existing notification
    await notificationService.cancelNotification(invoice.id.hashCode);

    // Schedule new one if applicable
    if (invoice.status != InvoiceStatus.paid &&
        invoice.status != InvoiceStatus.cancelled) {
      await notificationService.scheduleNotification(
        id: invoice.id.hashCode,
        title: 'Invoice Due: ${invoice.invoiceNumber}',
        body: 'Invoice for ${invoice.customerName} is due today.',
        scheduledDate: invoice.dueDate,
      );
    }

    ref.invalidate(invoicesProvider);
    return true;
  } on CognitiveConsensusException {
    rethrow;
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

    // Cancel notification
    final notificationService = ref.read(notificationServiceProvider);
    await notificationService.initialize();
    await notificationService.cancelNotification(invoiceId.hashCode);

    ref.invalidate(invoicesProvider);
    return true;
  } on CognitiveConsensusException {
    rethrow;
  } on Exception {
    return false;
  }
});

/// State Provider لحالة البحث
final invoiceSearchProvider = StateProvider<String>((ref) => '');

/// State Provider لحالة الفلتر
final invoiceFilterProvider = StateProvider<String>((ref) => 'all');

/// Provider لحالة الترتيب (إصدار، قديم، مبلغ، عميل، استحقاق)
final invoiceSortProvider = StateProvider<String>((ref) => 'newest');

/// Provider لقائمة الفواتير المفلترة حسب البحث والحالة مع الترتيب
final filteredInvoicesProvider = Provider<AsyncValue<List<Invoice>>>((ref) {
  final searchQuery = ref.watch(invoiceSearchProvider.select((value) => value));
  final filterStatus = ref.watch(
    invoiceFilterProvider.select((value) => value),
  );
  final sortKey = ref.watch(invoiceSortProvider.select((value) => value));
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
      final query = searchQuery.normalizeArabic().toLowerCase();
      filtered = filtered
          .where(
            (invoice) =>
                invoice.invoiceNumber.toLowerCase().contains(query) ||
                invoice.id.toLowerCase().contains(query) ||
                invoice.customerName
                    .normalizeArabic()
                    .toLowerCase()
                    .contains(query),
          )
          .toList();
    }

    return _sortedInvoices(filtered, sortKey);
  });
});

/// ترتيب قائمة الفواتير وفق مفتاح الترتيب المحدد.
/// يدعم الافتراضي `newest`، وأيضًا `oldest` و`amount_desc` و`amount_asc`
/// و`customer` و`due_date`.
List<Invoice> _sortedInvoices(List<Invoice> invoices, String sortKey) {
  final sorted = List<Invoice>.of(invoices);
  switch (sortKey) {
    case 'oldest':
      sorted.sort((a, b) => a.issuedDate.compareTo(b.issuedDate));
      return sorted;
    case 'amount_desc':
      sorted.sort(
        (a, b) =>
            b.totalAmountBaseCurrency.compareTo(a.totalAmountBaseCurrency),
      );
      return sorted;
    case 'amount_asc':
      sorted.sort(
        (a, b) =>
            a.totalAmountBaseCurrency.compareTo(b.totalAmountBaseCurrency),
      );
      return sorted;
    case 'customer':
      sorted.sort((a, b) => a.customerName.compareTo(b.customerName));
      return sorted;
    case 'due_date':
      sorted.sort((a, b) => a.dueDate.compareTo(b.dueDate));
      return sorted;
    case 'newest':
    default:
      sorted.sort((a, b) => b.issuedDate.compareTo(a.issuedDate));
      return sorted;
  }
}

/// Provider لحساب إجمالي المبيعات
final totalSalesProvider = Provider<AsyncValue<Decimal>>((ref) {
  final invoicesAsync = ref.watch(invoicesProvider);

  return invoicesAsync.whenData(
    (invoices) => invoices.fold<Decimal>(
      Decimal.zero,
      (sum, invoice) => sum + invoice.totalAmountBaseCurrency,
    ),
  );
});

/// Provider لحساب عدد الفواتير المتأخرة
final overdueInvoicesCountProvider = Provider<AsyncValue<int>>((ref) {
  final invoicesAsync = ref.watch(invoicesProvider);

  return invoicesAsync.whenData(
    (invoices) => invoices
        .where(
          (invoice) => invoice.status == InvoiceStatus.overdue,
        )
        .length,
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
      (asyncInvoices) => asyncInvoices.whenData(
        (invoices) => invoices.isNotEmpty,
      ),
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
      paidInvoices: invoices
          .where((i) => i.status == InvoiceStatus.paid)
          .length, // ignore: lines_longer_than_80_chars
      overdueInvoices: invoices
          .where((i) => i.status == InvoiceStatus.overdue)
          .length, // ignore: lines_longer_than_80_chars
      totalAmount: invoices.fold<Decimal>(
        Decimal.zero,
        (sum, i) => sum + i.totalAmountBaseCurrency,
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
    await accountingService.postInvoice(updatedInvoice);

    // Cancel notification
    final notificationService = ref.read(notificationServiceProvider);
    await notificationService.initialize();
    await notificationService.cancelNotification(invoiceId.hashCode);

    ref.invalidate(invoicesProvider);
    return true;
  } on CognitiveConsensusException {
    rethrow;
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
    await accountingService.postInvoice(updatedInvoice);

    ref.invalidate(invoicesProvider);
    return true;
  } on CognitiveConsensusException {
    rethrow;
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

    // Cancel notification
    final notificationService = ref.read(notificationServiceProvider);
    await notificationService.initialize();
    await notificationService.cancelNotification(invoiceId.hashCode);

    ref.invalidate(invoicesProvider);
    return true;
  } on CognitiveConsensusException {
    rethrow;
  } on Exception {
    return false;
  }
});
