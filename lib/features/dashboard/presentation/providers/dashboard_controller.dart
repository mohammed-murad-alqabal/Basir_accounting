import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/dashboard/domain/entities/dashboard_data.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice_status.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// مزود وحدة تحكم لوحة التحكم (Dashboard Controller Provider)
final dashboardControllerProvider =
    AsyncNotifierProvider<DashboardController, DashboardData>(
  DashboardController.new,
);

/// فئة مساعدة لتجميع إحصائيات الفواتير
class _InvoiceStatistics {
  const _InvoiceStatistics({
    required this.paidCount,
    required this.overdueCount,
    required this.pendingCount,
    required this.totalSales,
    required this.paidRevenue,
    required this.pendingRevenue,
    required this.overdueRevenue,
  });

  final int paidCount;
  final int overdueCount;
  final int pendingCount;
  final Decimal totalSales;
  final Decimal paidRevenue;
  final Decimal pendingRevenue;
  final Decimal overdueRevenue;
}

/// وحدة تحكم لوحة التحكم (Dashboard Controller)
///
/// تدير منطق جلب وتحليل البيانات لعرضها في الشاشة الرئيسية.
class DashboardController extends AsyncNotifier<DashboardData> {
  /// إنشاء كائن وحدة تحكم لوحة التحكم
  DashboardController();

  @override
  Future<DashboardData> build() async => _fetchData();

  /// جلب البيانات وتحليلها بطريقة محسنة للأداء
  Future<DashboardData> _fetchData() async {
    final invoiceRepo = ref.watch(invoiceRepositoryProvider);
    final customerRepo = ref.watch(customerRepositoryProvider);

    try {
      // جلب البيانات بشكل متوازي لسرعة التنفيذ
      final results = await Future.wait([
        invoiceRepo.getAllInvoices(),
        customerRepo.getAllCustomers(),
      ]);

      final allInvoices = results[0] as List<Invoice>;
      final allCustomers = results[1] as List<dynamic>;

      // تصفية الفواتير غير الملغاة مرة واحدة
      final activeInvoices = allInvoices
          .where((inv) => inv.status != InvoiceStatus.cancelled)
          .toList();

      // حساب الإحصائيات في تمريرة واحدة لتحسين الأداء
      final stats = _calculateStatistics(activeInvoices);

      // ترتيب الفواتير حسب الأحدث وأخذ أول 5 فقط
      final recentInvoices = _getRecentInvoices(allInvoices);

      // معالجة بيانات الرسم البياني
      final salesTrend = _calculateSalesTrend(activeInvoices);

      return DashboardData(
        totalInvoices: allInvoices.length,
        paidInvoices: stats.paidCount,
        overdueInvoices: stats.overdueCount,
        pendingInvoices: stats.pendingCount,
        totalSales: stats.totalSales,
        paidRevenue: stats.paidRevenue,
        pendingRevenue: stats.pendingRevenue,
        overdueRevenue: stats.overdueRevenue,
        activeCustomersCount: allCustomers.length,
        recentInvoices: recentInvoices,
        salesTrend: salesTrend,
      );
    } on Exception {
      // في حالة الخطأ، إرجاع بيانات فارغة بدلاً من إيقاف التطبيق
      return _createEmptyDashboardData();
    }
  }

  /// حساب الإحصائيات في تمريرة واحدة لتحسين الأداء
  _InvoiceStatistics _calculateStatistics(List<Invoice> activeInvoices) {
    var paidCount = 0;
    var overdueCount = 0;
    var pendingCount = 0;
    var totalSales = Decimal.zero;
    var paidRevenue = Decimal.zero;
    var pendingRevenue = Decimal.zero;
    var overdueRevenue = Decimal.zero;

    for (final inv in activeInvoices) {
      final total = inv.totalAmount;
      totalSales += total;

      switch (inv.status) {
        case InvoiceStatus.paid:
          paidCount++;
          paidRevenue += total;
        case InvoiceStatus.overdue:
          overdueCount++;
          overdueRevenue += total;
        case InvoiceStatus.sent:
        case InvoiceStatus.draft:
        case InvoiceStatus.cancelled:
        case InvoiceStatus.refunded:
          pendingCount++;
          pendingRevenue += total;
      }
    }

    return _InvoiceStatistics(
      paidCount: paidCount,
      overdueCount: overdueCount,
      pendingCount: pendingCount,
      totalSales: totalSales,
      paidRevenue: paidRevenue,
      pendingRevenue: pendingRevenue,
      overdueRevenue: overdueRevenue,
    );
  }

  /// الحصول على أحدث الفواتير بطريقة محسنة
  List<Invoice> _getRecentInvoices(List<Invoice> allInvoices) {
    // استخدام sort مع limit لتحسين الأداء
    final sortedInvoices = [...allInvoices];
    sortedInvoices.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sortedInvoices.take(5).toList();
  }

  /// إنشاء بيانات فارغة في حالة الخطأ
  DashboardData _createEmptyDashboardData() => DashboardData(
        totalInvoices: 0,
        paidInvoices: 0,
        overdueInvoices: 0,
        pendingInvoices: 0,
        totalSales: Decimal.zero,
        paidRevenue: Decimal.zero,
        pendingRevenue: Decimal.zero,
        overdueRevenue: Decimal.zero,
        activeCustomersCount: 0,
        recentInvoices: const [],
        salesTrend: const {},
      );

  /// حساب اتجاه المبيعات لآخر 7 أيام بطريقة محسنة
  Map<String, double> _calculateSalesTrend(List<Invoice> invoices) {
    final trend = <String, double>{};
    final now = DateTime.now();

    // إنشاء خريطة للتواريخ مسبقاً
    final dateMap = <String, Decimal>{};

    // تجميع المبيعات حسب التاريخ في تمريرة واحدة
    for (final inv in invoices) {
      final dateKey = '${inv.issuedDate.day}/${inv.issuedDate.month}';
      dateMap[dateKey] = (dateMap[dateKey] ?? Decimal.zero) + inv.totalAmount;
    }

    // إنشاء البيانات لآخر 7 أيام
    for (var i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dateKey = '${date.day}/${date.month}';
      trend[dateKey] = (dateMap[dateKey] ?? Decimal.zero).toDouble();
    }

    return trend;
  }

  /// تحديث البيانات يدوياً
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_fetchData);
  }
}
