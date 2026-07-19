import 'package:basir_accounting_system/features/accounting/domain/entities/account.dart';
import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'import_row.freezed.dart';

/// Represents a validated row from an Excel import.
@freezed
class ImportRow with _$ImportRow {
  /// Creates an [ImportRow] using a factory constructor.
  const factory ImportRow({
    /// The name of the account or customer.
    required String name,

    /// The opening balance amount.
    required Decimal balance,

    /// The accounting nature (Debit/Credit).
    required AccountNature nature,

    /// Optional phone number.
    String? phone,

    /// Optional address.
    String? address,

    /// Validation error message if any.
    String? error,
  }) = _ImportRow;

  const ImportRow._();

  /// Returns true if the row is valid and can be imported.
  bool get isValid => error == null && name.isNotEmpty;
}
