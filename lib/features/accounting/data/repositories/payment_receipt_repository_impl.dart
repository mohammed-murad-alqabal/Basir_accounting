import 'package:basir_accounting_system/features/accounting/data/models/payment_receipt_model.dart';
import 'package:basir_accounting_system/features/accounting/data/models/payment_voucher_model.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/payment_receipt.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/payment_voucher.dart';
import 'package:basir_accounting_system/features/accounting/domain/repositories/payment_receipt_repository.dart';
import 'package:isar/isar.dart';

/// Isar-based implementation of PaymentReceiptRepository.
///
/// This class provides concrete data persistence operations for payment
/// receipts using the Isar database.
///
/// ## Features:
/// - Local-first data storage
/// - Offline-first architecture
/// - Efficient querying with indexes
/// - Soft-delete support for audit trail
class PaymentReceiptRepositoryImpl implements PaymentReceiptRepository {
  /// Creates a payment receipt repository with Isar instance.
  PaymentReceiptRepositoryImpl(this._isar);

  /// Isar database instance.
  final Isar _isar;

  @override
  Future<void> saveReceipt(PaymentReceipt receipt) async {
    final model = PaymentReceiptModel.fromEntity(receipt);
    await _isar.writeTxn(() async {
      await _isar.paymentReceiptModels.put(model);
    });
  }

  @override
  Future<PaymentReceipt?> getReceiptById(String id) async {
    final model = await _isar.paymentReceiptModels
        .where()
        .paymentReceiptIdEqualTo(id)
        .findFirst();
    return model?.toEntity();
  }

  @override
  Future<PaymentReceipt?> getReceiptByNumber(String receiptNumber) async {
    final model = await _isar.paymentReceiptModels
        .where()
        .receiptNumberEqualTo(receiptNumber)
        .findFirst();
    return model?.toEntity();
  }

  @override
  Future<List<PaymentReceipt>> getReceiptsByCustomer(String customerId) async {
    final models = await _isar.paymentReceiptModels
        .where()
        .customerIdEqualTo(customerId)
        .sortByReceiptDateDesc()
        .findAll();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<PaymentReceipt>> getReceiptsByDateRange({
    required DateTime fromDate,
    required DateTime toDate,
  }) async {
    final models = await _isar.paymentReceiptModels
        .where()
        .receiptDateBetween(fromDate, toDate)
        .sortByReceiptDateDesc()
        .findAll();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<PaymentReceipt>> getReceiptsByStatus(
    PaymentStatus status,
  ) async {
    final models = await _isar.paymentReceiptModels
        .where()
        .statusEqualTo(status.index)
        .sortByReceiptDateDesc()
        .findAll();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<PaymentReceipt>> getAllReceipts() async {
    final models = await _isar.paymentReceiptModels
        .where()
        .sortByReceiptDateDesc()
        .findAll();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> updateReceipt(PaymentReceipt receipt) async {
    await saveReceipt(receipt);
  }

  @override
  Future<void> deleteReceipt(String id) async {
    final receipt = await getReceiptById(id);
    if (receipt != null) {
      final deletedReceipt = receipt.copyWith(isDeleted: true);
      await saveReceipt(deletedReceipt);
    }
  }

  @override
  Future<void> hardDeleteReceipt(String id) async {
    await _isar.writeTxn(() async {
      await _isar.paymentReceiptModels
          .where()
          .paymentReceiptIdEqualTo(id)
          .deleteFirst();
    });
  }

  @override
  Future<double> getTotalReceiptsAmount({
    required String customerId,
    required DateTime fromDate,
    required DateTime toDate,
  }) async {
    final models = await _isar.paymentReceiptModels
        .where()
        .customerIdEqualTo(customerId)
        .filter()
        .receiptDateBetween(fromDate, toDate)
        .and()
        .statusEqualTo(PaymentStatus.cleared.index)
        .findAll();

    return models.fold<double>(0, (sum, model) => sum + model.amount);
  }

  @override
  Future<String> generateNextReceiptNumber() async {
    final now = DateTime.now();
    final year = now.year;

    // Get count of receipts this year
    final yearStart = DateTime(year);
    final yearEnd = DateTime(year, 12, 31, 23, 59, 59);

    final count = await _isar.paymentReceiptModels
        .where()
        .receiptDateBetween(yearStart, yearEnd)
        .count();

    final sequence = (count + 1).toString().padLeft(5, '0');
    return 'RCPT-$year-$sequence';
  }

  @override
  Future<int> getReceiptsCount({
    required DateTime fromDate,
    required DateTime toDate,
  }) async =>
      _isar.paymentReceiptModels
          .where()
          .receiptDateBetween(fromDate, toDate)
          .count();
}

/// Isar-based implementation of PaymentVoucherRepository.
///
/// This class provides concrete data persistence operations for payment
/// vouchers using the Isar database.
///
/// ## Features:
/// - Local-first data storage
/// - Offline-first architecture
/// - Efficient querying with indexes
/// - Soft-delete support for audit trail
class PaymentVoucherRepositoryImpl implements PaymentVoucherRepository {
  /// Creates a payment voucher repository with Isar instance.
  PaymentVoucherRepositoryImpl(this._isar);

  /// Isar database instance.
  final Isar _isar;

  @override
  Future<void> saveVoucher(PaymentVoucher voucher) async {
    final model = PaymentVoucherModel.fromEntity(voucher);
    await _isar.writeTxn(() async {
      await _isar.paymentVoucherModels.put(model);
    });
  }

  @override
  Future<PaymentVoucher?> getVoucherById(String id) async {
    final model = await _isar.paymentVoucherModels
        .where()
        .paymentVoucherIdEqualTo(id)
        .findFirst();
    return model?.toEntity();
  }

  @override
  Future<PaymentVoucher?> getVoucherByNumber(String voucherNumber) async {
    final model = await _isar.paymentVoucherModels
        .where()
        .voucherNumberEqualTo(voucherNumber)
        .findFirst();
    return model?.toEntity();
  }

  @override
  Future<List<PaymentVoucher>> getVouchersByVendor(String vendorId) async {
    final models = await _isar.paymentVoucherModels
        .where()
        .vendorIdEqualTo(vendorId)
        .sortByPaymentDateDesc()
        .findAll();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<PaymentVoucher>> getVouchersByDateRange({
    required DateTime fromDate,
    required DateTime toDate,
  }) async {
    final models = await _isar.paymentVoucherModels
        .where()
        .paymentDateBetween(fromDate, toDate)
        .sortByPaymentDateDesc()
        .findAll();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<PaymentVoucher>> getVouchersByStatus(
    PaymentStatus status,
  ) async {
    final models = await _isar.paymentVoucherModels
        .where()
        .statusEqualTo(status.index)
        .sortByPaymentDateDesc()
        .findAll();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<PaymentVoucher>> getAllVouchers() async {
    final models = await _isar.paymentVoucherModels
        .where()
        .sortByPaymentDateDesc()
        .findAll();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> updateVoucher(PaymentVoucher voucher) async {
    await saveVoucher(voucher);
  }

  @override
  Future<void> deleteVoucher(String id) async {
    final voucher = await getVoucherById(id);
    if (voucher != null) {
      final deletedVoucher = voucher.copyWith(isDeleted: true);
      await saveVoucher(deletedVoucher);
    }
  }

  @override
  Future<void> hardDeleteVoucher(String id) async {
    await _isar.writeTxn(() async {
      await _isar.paymentVoucherModels
          .where()
          .paymentVoucherIdEqualTo(id)
          .deleteFirst();
    });
  }

  @override
  Future<double> getTotalVouchersAmount({
    required String vendorId,
    required DateTime fromDate,
    required DateTime toDate,
  }) async {
    final models = await _isar.paymentVoucherModels
        .where()
        .vendorIdEqualTo(vendorId)
        .filter()
        .paymentDateBetween(fromDate, toDate)
        .and()
        .statusEqualTo(PaymentStatus.cleared.index)
        .findAll();

    return models.fold<double>(0, (sum, model) => sum + model.amount);
  }

  @override
  Future<String> generateNextVoucherNumber() async {
    final now = DateTime.now();
    final year = now.year;

    // Get count of vouchers this year
    final yearStart = DateTime(year);
    final yearEnd = DateTime(year, 12, 31, 23, 59, 59);

    final count = await _isar.paymentVoucherModels
        .where()
        .paymentDateBetween(yearStart, yearEnd)
        .count();

    final sequence = (count + 1).toString().padLeft(5, '0');
    return 'VCHR-$year-$sequence';
  }

  @override
  Future<int> getVouchersCount({
    required DateTime fromDate,
    required DateTime toDate,
  }) async =>
      _isar.paymentVoucherModels
          .where()
          .paymentDateBetween(fromDate, toDate)
          .count();
}
