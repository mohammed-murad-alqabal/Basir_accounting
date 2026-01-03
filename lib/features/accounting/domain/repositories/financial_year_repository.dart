import 'package:basir_app/features/accounting/domain/entities/financial_year.dart';

/// مستودع السنة المالية (Financial Year Repository).
/// مسؤول عن تخزين واسترجاع بيانات السنوات والفترات المالية.
abstract class FinancialYearRepository {
  /// الحصول على السنة المالية الحالية (المفتوحة)
  Future<FinancialYear?> getCurrentFinancialYear();

  /// الحصول على سنة مالية بواسطة التاريخ (لمعرفة السنة التي يتبع لها قيد معين)
  Future<FinancialYear?> getFinancialYearByDate(DateTime date);

  /// الحصول على جميع السنوات المالية
  Future<List<FinancialYear>> getAllFinancialYears();

  /// إضافة أو تحديث سنة مالية
  Future<void> saveFinancialYear(FinancialYear year);

  /// إغلاق سنة مالية
  Future<void> closeFinancialYear(String id, String userId);

  /// التحقق من إمكانية الترحيل لتاريخ معين
  /// يرجع true إذا كان التاريخ يقع ضمن سنة مفتوحة وفترة غير مغلقة
  Future<bool> isPeriodOpen(DateTime date);
}
