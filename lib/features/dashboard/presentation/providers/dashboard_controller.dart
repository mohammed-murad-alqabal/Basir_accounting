import 'package:basir_app/core/providers.dart';
import 'package:basir_app/features/dashboard/domain/entities/dashboard_data.dart';
import 'package:basir_app/features/invoices/domain/entities/invoice.dart';
import 'package:basir_app/features/invoices/domain/entities/invoice_status.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// مزود وحدة تحكم لوحة التحكم (Dashboard Controller Provider)
final dashboardControllerProvider =
    AsyncNotifierProvider<DashboardController, DashboardData>(
  DashboardController.new,
);

/// وحدة تحكم لوحة التحكم (Dashboard Controller)
///
/// تدير منطق جلب وتحليل البيانات لعرضها في الشاشة الرئيسية.
class DashboardController extends AsyncNotifier<DashboardData> {
  /// إنشاء كائن وحدة تحكم لوحة التحكم
  DashboardController();
  @override
  Future<DashboardData> build() async => _fetchData();

  /// جلب البيانات وتحليلها
  Future<DashboardData> _fetchData() async {
    final invoiceRepo = ref.watch(invoiceRepositoryProvider);
    final customerRepo = ref.watch(customerRepositoryProvider);

    // جلب البيانات بشكل متوازي لسرعة التنفيذ
    final results = await Future.wait([
      invoiceRepo.getAllInvoices(),
      customerRepo.getAllCustomers(),
    ]);

    final allInvoices = results[0] as List<Invoice>;
    final allCustomers = results[1] as List<dynamic>;

    // تصفية الفواتير غير الملغاة
    final activeInvoices = allInvoices
        .where((inv) => inv.status != InvoiceStatus.cancelled)
        .toList();

    // حساب الإحصائيات
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

      if (inv.status == InvoiceStatus.paid) {
        paidCount++;
        paidRevenue += total;
      } else if (inv.status == InvoiceStatus.overdue) {
        overdueCount++;
        overdueRevenue += total;
      } else {
        pendingCount++;
        pendingRevenue += total;
      }
    }

    // ترتيب الفواتير حسب الأحدث
    final recentInvoices = [...allInvoices]..sort(
        (a, b) => b.createdAt.compareTo(a.createdAt),
      );
    final limitedRecent = recentInvoices.take(5).toList();

    // معالجة بيانات الرسم البياني
    final salesTrend = _calculateSalesTrend(activeInvoices);

    return DashboardData(
      totalInvoices: allInvoices.length,
      paidInvoices: paidCount,
      overdueInvoices: overdueCount,
      pendingInvoices: pendingCount,
      totalSales: totalSales,
      paidRevenue: paidRevenue,
      pendingRevenue: pendingRevenue,
      overdueRevenue: overdueRevenue,
      activeCustomersCount: allCustomers.length,
      recentInvoices: limitedRecent,
      salesTrend: salesTrend,
    );
  }

  /// حساب اتجاه المبيعات لآخر 7 أيام
  Map<String, double> _calculateSalesTrend(List<Invoice> invoices) {
    final trend = <String, double>{};
    final now = DateTime.now();

    for (var i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dateKey = '${date.day}/${date.month}';

      final dailyTotal = invoices
          .where(
            (inv) =>
                inv.issuedDate.year == date.year &&
                inv.issuedDate.month == date.month &&
                inv.issuedDate.day == date.day,
          )
          .fold<Decimal>(Decimal.zero, (sum, inv) => sum + inv.totalAmount);

      trend[dateKey] = dailyTotal.toDouble();
    }

    return trend;
  }

  /// تحديث البيانات يدوياً
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_fetchData);
  }
}
