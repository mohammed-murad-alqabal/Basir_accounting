import 'package:basir_app/features/accounting/domain/entities/financial_voucher.dart';

/// Repository interface for managing financial receipt and payment vouchers.
abstract class FinancialVoucherRepository {
  /// Retrieves the complete set of financial vouchers across all types.
  Future<List<FinancialVoucher>> getAllVouchers();

  /// Retrieves a specific voucher by its internal ID.
  Future<FinancialVoucher?> getVoucherById(String id);

  /// Persists a new financial voucher.
  Future<void> addVoucher(FinancialVoucher voucher);

  /// Updates metadata for an existing unposted voucher.
  Future<void> updateVoucher(FinancialVoucher voucher);

  /// Removes a voucher from the active system (usually soft-delete).
  Future<void> deleteVoucher(String id);
}
