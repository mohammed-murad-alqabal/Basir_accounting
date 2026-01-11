/// Mock Invoice Repository - محاكاة لمستودع الفواتير
///
/// يوفر تطبيق وهمي لـ InvoiceRepository للاستخدام في الاختبارات
library;

import 'package:basir_accounting_system/features/invoices/domain/entities/invoice.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice_status.dart';
import 'package:basir_accounting_system/features/invoices/domain/repositories/invoice_repository.dart';
import 'package:decimal/decimal.dart';

/// Mock implementation لـ InvoiceRepository
///
/// يخزن الفواتير في List في الذاكرة بدلاً من قاعدة البيانات.
/// مفيد لاختبار Providers والـ Services بدون الاعتماد على قاعدة البيانات.
class MockInvoiceRepository implements InvoiceRepository {
  final List<Invoice> _invoices = [];

  /// للوصول المباشر للفواتير في الاختبارات
  List<Invoice> get invoices => List.from(_invoices);

  /// تعيين قائمة الفواتير للاختبارات
  void setInvoices(List<Invoice> invoices) {
    _invoices.clear();
    _invoices.addAll(invoices);
  }

  /// تفعيل/تعطيل رمي الأخطاء للاختبارات
  bool shouldThrowError = false;

  @override
  Future<List<Invoice>> getAllInvoices() async {
    if (shouldThrowError) throw Exception('Test error');
    return List.from(_invoices);
  }

  @override
  Future<Invoice?> getInvoiceById(String id) async {
    try {
      return _invoices.firstWhere((i) => i.id == id);
    } on Object {
      // الفاتورة غير موجودة أو خطأ آخر
      return null;
    }
  }

  @override
  Future<List<Invoice>> getInvoicesByCustomerId(String customerId) async =>
      _invoices.where((i) => i.customerId == customerId).toList();

  @override
  Future<List<Invoice>> getInvoicesByStatus(InvoiceStatus status) async =>
      _invoices.where((i) => i.status == status).toList();

  @override
  Future<void> addInvoice(Invoice invoice) async {
    if (shouldThrowError) throw Exception('Test error');
    // التحقق من عدم وجود فاتورة بنفس الـ ID
    if (_invoices.any((i) => i.id == invoice.id)) {
      throw Exception('Invoice with ID ${invoice.id} already exists');
    }
    _invoices.add(invoice);
  }

  @override
  Future<void> updateInvoice(Invoice invoice) async {
    if (shouldThrowError) throw Exception('Test error');
    final index = _invoices.indexWhere((i) => i.id == invoice.id);
    if (index == -1) {
      throw Exception('Invoice with ID ${invoice.id} not found');
    }
    _invoices[index] = invoice;
  }

  @override
  Future<void> deleteInvoice(String id) async {
    if (shouldThrowError) throw Exception('Test error');
    _invoices.removeWhere((i) => i.id == id);
  }

  @override
  Future<void> deleteAllInvoices() async {
    _invoices.clear();
  }

  @override
  Future<InvoiceStatistics> getInvoiceStatistics() async {
    final totalInvoices = _invoices.length;
    final paidInvoices =
        _invoices.where((i) => i.status == InvoiceStatus.paid).length;
    final overdueInvoices =
        _invoices.where((i) => i.status == InvoiceStatus.overdue).length;
    final totalRevenue = _invoices.fold<Decimal>(
      Decimal.zero,
      (sum, invoice) => sum + invoice.totalAmount,
    );
    final paidRevenue =
        _invoices.where((i) => i.status == InvoiceStatus.paid).fold<Decimal>(
              Decimal.zero,
              (sum, invoice) => sum + invoice.totalAmount,
            );

    return InvoiceStatistics(
      totalInvoices: totalInvoices,
      paidInvoices: paidInvoices,
      overdueInvoices: overdueInvoices,
      totalRevenue: totalRevenue,
      paidRevenue: paidRevenue,
    );
  }

  @override
  Future<Invoice> duplicateInvoice(String id) async {
    if (shouldThrowError) throw Exception('Test error');
    final invoice = _invoices.firstWhere((i) => i.id == id);
    final duplicated = invoice.copyWith(
      id: 'copy_${DateTime.now().millisecondsSinceEpoch}',
    );
    _invoices.add(duplicated);
    return duplicated;
  }

  /// دالة مساعدة لإضافة عدة فواتير دفعة واحدة
  Future<void> addAll(List<Invoice> invoices) async {
    for (final invoice in invoices) {
      await addInvoice(invoice);
    }
  }

  /// دالة مساعدة لمسح جميع الفواتير (للاختبارات)
  void clear() {
    _invoices.clear();
  }

  /// دالة مساعدة للحصول على عدد الفواتير
  int get count => _invoices.length;

  /// دالة مساعدة للتحقق من أن المستودع فارغ
  bool get isEmpty => _invoices.isEmpty;
}
