/// Mock لـ InvoiceRepository
///
/// يوفر هذا الملف mock object لـ InvoiceRepository للاستخدام في الاختبارات.
/// يحاكي سلوك repository بدون الحاجة لقاعدة بيانات فعلية.
library;

import 'package:basser_app/features/invoices/domain/entities/invoice.dart';

/// Mock implementation لـ InvoiceRepository
///
/// يستخدم List في الذاكرة لتخزين الفواتير بدلاً من قاعدة البيانات الفعلية.
///
/// مثال:
/// ```dart
/// final mockRepo = MockInvoiceRepository();
/// final invoice = MockData.createTestInvoice();
/// await mockRepo.addInvoice(invoice);
/// final invoices = await mockRepo.getAllInvoices();
/// expect(invoices.length, 1);
/// ```
class MockInvoiceRepository {
  /// قائمة الفواتير في الذاكرة
  final List<Invoice> _invoices = [];

  /// الحصول على جميع الفواتير
  ///
  /// Returns قائمة بجميع الفواتير المخزنة
  Future<List<Invoice>> getAllInvoices() async => List.from(_invoices);

  /// الحصول على فاتورة بواسطة المعرف
  ///
  /// [id] معرف الفاتورة
  ///
  /// Returns الفاتورة إذا وُجدت، null إذا لم تُوجد
  Future<Invoice?> getInvoiceById(String id) async {
    try {
      return _invoices.firstWhere((i) => i.id == id);
    } on StateError {
      return null;
    }
  }

  /// الحصول على فواتير عميل معين
  ///
  /// [customerId] معرف العميل
  ///
  /// Returns قائمة فواتير العميل
  Future<List<Invoice>> getInvoicesByCustomerId(String customerId) async =>
      _invoices.where((i) => i.customerId == customerId).toList();

  /// الحصول على فواتير بحالة معينة
  ///
  /// [status] حالة الفاتورة (draft, issued, paid, overdue, cancelled)
  ///
  /// Returns قائمة الفواتير بالحالة المحددة
  Future<List<Invoice>> getInvoicesByStatus(String status) async =>
      _invoices.where((i) => i.status == status).toList();

  /// إضافة فاتورة جديدة
  ///
  /// [invoice] الفاتورة المراد إضافتها
  ///
  /// Throws Exception إذا كان المعرف موجود مسبقاً
  Future<void> addInvoice(Invoice invoice) async {
    // التحقق من عدم وجود فاتورة بنفس المعرف
    final exists = _invoices.any((i) => i.id == invoice.id);
    if (exists) {
      throw Exception('فاتورة بنفس المعرف موجودة مسبقاً');
    }
    _invoices.add(invoice);
  }

  /// تحديث بيانات فاتورة موجودة
  ///
  /// [invoice] الفاتورة المراد تحديثها
  ///
  /// Throws Exception إذا لم تكن الفاتورة موجودة
  Future<void> updateInvoice(Invoice invoice) async {
    final index = _invoices.indexWhere((i) => i.id == invoice.id);
    if (index == -1) {
      throw Exception('الفاتورة غير موجودة');
    }
    _invoices[index] = invoice;
  }

  /// حذف فاتورة
  ///
  /// [id] معرف الفاتورة المراد حذفها
  ///
  /// Throws Exception إذا لم تكن الفاتورة موجودة
  Future<void> deleteInvoice(String id) async {
    final initialLength = _invoices.length;
    _invoices.removeWhere((i) => i.id == id);
    if (_invoices.length == initialLength) {
      throw Exception('الفاتورة غير موجودة');
    }
  }

  /// حساب إجمالي الفواتير
  ///
  /// Returns مجموع grandTotal لجميع الفواتير
  Future<double> getTotalAmount() async => _invoices.fold<double>(
        0,
        (sum, invoice) => sum + invoice.grandTotal,
      );

  /// حساب إجمالي الفواتير المدفوعة
  ///
  /// Returns مجموع grandTotal للفواتير المدفوعة فقط
  Future<double> getPaidAmount() async => _invoices
      .where((i) => i.status == 'paid')
      .fold<double>(0, (sum, invoice) => sum + invoice.grandTotal);

  /// حساب إجمالي الفواتير المعلقة
  ///
  /// Returns مجموع grandTotal للفواتير غير المدفوعة
  Future<double> getUnpaidAmount() async => _invoices
      .where((i) => i.status != 'paid' && i.status != 'cancelled')
      .fold<double>(0, (sum, invoice) => sum + invoice.grandTotal);

  /// تنظيف القائمة (للاستخدام في tearDown)
  void clear() {
    _invoices.clear();
  }

  /// الحصول على عدد الفواتير
  int get count => _invoices.length;

  /// التحقق من أن القائمة فارغة
  bool get isEmpty => _invoices.isEmpty;

  /// التحقق من أن القائمة تحتوي على فواتير
  bool get isNotEmpty => _invoices.isNotEmpty;
}
