import 'package:basir_accounting_system/features/accounting/domain/entities/payment_receipt.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/payment_voucher.dart';

/// Payment Receipt Repository Interface
///
/// Defines the contract for payment receipt data persistence operations.
/// This interface follows the Repository Pattern to decouple the domain
/// layer from data access implementation details.
///
/// ## Standards Compliance:
/// - **IAS 1**: Presentation of Financial Statements
/// - **IFRS 9**: Financial Instruments
/// - **Clean Architecture**: Domain Layer Repository Interface
abstract class PaymentReceiptRepository {
  /// Saves a payment receipt to the database.
  ///
  /// If a receipt with the same ID exists, it will be replaced.
  Future<void> saveReceipt(PaymentReceipt receipt);

  /// Retrieves a payment receipt by its unique ID.
  ///
  /// Returns null if not found.
  Future<PaymentReceipt?> getReceiptById(String id);

  /// Retrieves a payment receipt by its receipt number.
  ///
  /// Returns null if not found.
  Future<PaymentReceipt?> getReceiptByNumber(String receiptNumber);

  /// Retrieves all payment receipts for a specific customer.
  ///
  /// Results are ordered by receipt date (descending).
  Future<List<PaymentReceipt>> getReceiptsByCustomer(String customerId);

  /// Retrieves all payment receipts within a date range.
  ///
  /// Results are ordered by receipt date (descending).
  Future<List<PaymentReceipt>> getReceiptsByDateRange({
    required DateTime fromDate,
    required DateTime toDate,
  });

  /// Retrieves all payment receipts with a specific status.
  ///
  /// Results are ordered by receipt date (descending).
  Future<List<PaymentReceipt>> getReceiptsByStatus(
    PaymentStatus status,
  );

  /// Retrieves all payment receipts in the system.
  ///
  /// Results are ordered by receipt date (descending).
  Future<List<PaymentReceipt>> getAllReceipts();

  /// Updates an existing payment receipt.
  ///
  /// Throws an exception if the receipt does not exist.
  Future<void> updateReceipt(PaymentReceipt receipt);

  /// Soft-deletes a payment receipt.
  ///
  /// Sets the isDeleted flag to true. The receipt remains in the database
  /// for audit trail purposes.
  Future<void> deleteReceipt(String id);

  /// Permanently removes a payment receipt from the database.
  ///
  /// WARNING: This should only be used for data cleanup. Soft-delete
  /// is preferred for audit trail preservation.
  Future<void> hardDeleteReceipt(String id);

  /// Gets the total amount of receipts for a customer in a period.
  ///
  /// Useful for reporting and analytics.
  Future<double> getTotalReceiptsAmount({
    required String customerId,
    required DateTime fromDate,
    required DateTime toDate,
  });

  /// Generates the next sequential receipt number.
  ///
  /// Format: RCPT-YYYY-NNNNN (e.g., RCPT-2024-00123)
  Future<String> generateNextReceiptNumber();

  /// Gets the count of receipts in a specific period.
  Future<int> getReceiptsCount({
    required DateTime fromDate,
    required DateTime toDate,
  });
}

/// Payment Voucher Repository Interface
///
/// Defines the contract for payment voucher data persistence operations.
/// This interface follows the Repository Pattern to decouple the domain
/// layer from data access implementation details.
///
/// ## Standards Compliance:
/// - **IAS 1**: Presentation of Financial Statements
/// - **IFRS 9**: Financial Instruments
/// - **Clean Architecture**: Domain Layer Repository Interface
abstract class PaymentVoucherRepository {
  /// Saves a payment voucher to the database.
  ///
  /// If a voucher with the same ID exists, it will be replaced.
  Future<void> saveVoucher(PaymentVoucher voucher);

  /// Retrieves a payment voucher by its unique ID.
  ///
  /// Returns null if not found.
  Future<PaymentVoucher?> getVoucherById(String id);

  /// Retrieves a payment voucher by its voucher number.
  ///
  /// Returns null if not found.
  Future<PaymentVoucher?> getVoucherByNumber(String voucherNumber);

  /// Retrieves all payment vouchers for a specific vendor.
  ///
  /// Results are ordered by payment date (descending).
  Future<List<PaymentVoucher>> getVouchersByVendor(String vendorId);

  /// Retrieves all payment vouchers within a date range.
  ///
  /// Results are ordered by payment date (descending).
  Future<List<PaymentVoucher>> getVouchersByDateRange({
    required DateTime fromDate,
    required DateTime toDate,
  });

  /// Retrieves all payment vouchers with a specific status.
  ///
  /// Results are ordered by payment date (descending).
  Future<List<PaymentVoucher>> getVouchersByStatus(
    PaymentStatus status,
  );

  /// Retrieves all payment vouchers in the system.
  ///
  /// Results are ordered by payment date (descending).
  Future<List<PaymentVoucher>> getAllVouchers();

  /// Updates an existing payment voucher.
  ///
  /// Throws an exception if the voucher does not exist.
  Future<void> updateVoucher(PaymentVoucher voucher);

  /// Soft-deletes a payment voucher.
  ///
  /// Sets the isDeleted flag to true. The voucher remains in the database
  /// for audit trail purposes.
  Future<void> deleteVoucher(String id);

  /// Permanently removes a payment voucher from the database.
  ///
  /// WARNING: This should only be used for data cleanup. Soft-delete
  /// is preferred for audit trail preservation.
  Future<void> hardDeleteVoucher(String id);

  /// Gets the total amount of vouchers for a vendor in a period.
  ///
  /// Useful for reporting and analytics.
  Future<double> getTotalVouchersAmount({
    required String vendorId,
    required DateTime fromDate,
    required DateTime toDate,
  });

  /// Generates the next sequential voucher number.
  ///
  /// Format: VCHR-YYYY-NNNNN (e.g., VCHR-2024-00123)
  Future<String> generateNextVoucherNumber();

  /// Gets the count of vouchers in a specific period.
  Future<int> getVouchersCount({
    required DateTime fromDate,
    required DateTime toDate,
  });
}
