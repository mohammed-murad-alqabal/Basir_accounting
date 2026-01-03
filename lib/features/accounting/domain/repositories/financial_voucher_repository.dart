import 'package:basir_app/features/accounting/domain/entities/financial_voucher.dart';

/// واجهة مستودع السندات المالية
abstract class FinancialVoucherRepository {
  /// الحصول على جميع السندات
  Future<List<FinancialVoucher>> getAllVouchers();

  /// الحصول على سند بمقدار المعرف
  Future<FinancialVoucher?> getVoucherById(String id);

  /// إضافة سند جديد
  Future<void> addVoucher(FinancialVoucher voucher);

  /// تحديث سند موجود
  Future<void> updateVoucher(FinancialVoucher voucher);

  /// حذف سند
  Future<void> deleteVoucher(String id);
}
