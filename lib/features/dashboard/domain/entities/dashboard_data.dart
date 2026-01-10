import 'package:basir_app/features/invoices/domain/entities/invoice.dart';
import 'package:decimal/decimal.dart';

/// بيانات لوحة التحكم (Dashboard Data)
///
/// كائن بيانات مركزي يحتوي على جميع الإحصائيات والتحليلات
/// اللازمة لعرضها في لوحة التحكم.
class DashboardData {
  /// إنشاء كائن بيانات لوحة التحكم
  const DashboardData({
    required this.totalInvoices,
    required this.paidInvoices,
    required this.overdueInvoices,
    required this.pendingInvoices,
    required this.totalSales,
    required this.paidRevenue,
    required this.pendingRevenue,
    required this.overdueRevenue,
    required this.activeCustomersCount,
    required this.recentInvoices,
    required this.salesTrend,
  });

  /// إجمالي عدد الفواتير
  final int totalInvoices;

  /// عدد الفواتير المدفوعة
  final int paidInvoices;

  /// عدد الفواتير المتأخرة
  final int overdueInvoices;

  /// عدد الفواتير قيد الانتظار (صادرة ولكن غير مدفوعة)
  final int pendingInvoices;

  /// إجمالي المبيعات (جميع الفواتير غير الملغاة)
  final Decimal totalSales;

  /// المبالغ المحصلة (المدفوعة فعلياً)
  final Decimal paidRevenue;

  /// المبالغ المعلقة (صادرة وغير مدفوعة وليست متأخرة)
  final Decimal pendingRevenue;

  /// المبالغ المتأخرة (تجاوزت تاريخ الاستحقاق)
  final Decimal overdueRevenue;

  /// عدد العملاء النشطين
  final int activeCustomersCount;

  /// قائمة بأحدث الفواتير
  final List<Invoice> recentInvoices;

  /// بيانات منحنى المبيعات (للرسم البياني)
  final Map<String, double> salesTrend;
}
