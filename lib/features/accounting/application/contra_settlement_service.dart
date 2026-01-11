import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/journal_entry.dart';
import 'package:decimal/decimal.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'contra_settlement_service.g.dart';

/// Contra-Settlement Service for balancing mutual AR/AP positions.
///
/// Responsible for automating the netting process between a Customer
/// and a Vendor when they represent the same legal entity, reducing
/// both Receivable and Payable balances simultaneously.
@riverpod
class ContraSettlementService extends _$ContraSettlementService {
  @override
  FutureOr<void> build() {}

  /// Executes a Contra Settlement (Netting) transaction.
  ///
  /// Simultaneously reduces the vendor liability and the customer asset
  /// to settle mutual debts without cash exchange.
  ///
  /// ## Entry Logic:
  /// - **Debit**: Accounts Payable (Liability decrease).
  /// - **Credit**: Accounts Receivable (Asset decrease).
  ///
  /// ## Compliance:
  /// Maps to IFRS 9 / IFRS 15 principles regarding financial instrument settlement.
  Future<String> performContraSettlement({
    required String customerId,
    required String vendorId,
    required String receivableAccountId,
    required String payableAccountId,
    required Decimal amount,
    required String description,
  }) async {
    final repository = ref.read(accountingRepositoryProvider);
    final user = ref.read(basirUserProvider);
    final now = DateTime.now();

    // Validate settlement amount
    if (amount <= Decimal.zero) {
      throw Exception('Settlement amount must be greater than zero');
    }

    final lines = [
      // Decrease Supplier Balance (Debit)
      JournalEntryLine(
        accountId: payableAccountId,
        accountName: 'Contra Settlement - Vendor $vendorId',
        debit: amount,
        credit: Decimal.zero,
        description: 'Netting Settlement: $description',
      ),
      // Decrease Customer Balance (Credit)
      JournalEntryLine(
        accountId: receivableAccountId,
        accountName: 'Contra Settlement - Customer $customerId',
        credit: amount,
        debit: Decimal.zero,
        description: 'Netting Settlement: $description',
      ),
    ];

    final entry = JournalEntry(
      id: const Uuid().v4(),
      referenceNumber: 'CON-${now.millisecondsSinceEpoch}',
      date: now,
      temporal: TemporalJustification(
        transactionDate: now,
        effectiveDate: now,
        recordingDate: now,
      ),
      standards: const StandardsJustification(
        standardReference: 'IFRS 9 / IFRS 15',
        recognitionBasis: 'Settlement through Netting',
        measurementBasis: 'Amortized Cost',
      ),
      description: 'Contra-Settlement: $description',
      status: JournalEntryStatus.posted,
      lines: lines,
      sourceDocument: 'contra_settlement',
      sourceId: '${customerId}_${vendorId}_${now.millisecondsSinceEpoch}',
      createdAt: now,
      createdBy: user?.id ?? 'system',
      updatedAt: now,
      postedAt: now,
    );

    await repository.addJournalEntry(entry);
    return entry.id;
  }
}
