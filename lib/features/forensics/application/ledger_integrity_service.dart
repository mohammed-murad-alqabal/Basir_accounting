// ignore_for_file: lines_longer_than_80_chars
import 'dart:async';

import 'package:basir_accounting_system/features/accounting/application/accounting_service.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/account.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/journal_entry.dart';
import 'package:basir_accounting_system/features/forensics/domain/entities/integrity_status.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for the LedgerIntegrityService.
final ledgerIntegrityServiceProvider =
    StateNotifierProvider<LedgerIntegrityService, LedgerHealth>(
  LedgerIntegrityService.new,
);

/// Service responsible for real-time monitoring and self-healing of the General Ledger.
class LedgerIntegrityService extends StateNotifier<LedgerHealth> {
  /// Creates the [LedgerIntegrityService].
  LedgerIntegrityService(this._ref)
      : super(
          LedgerHealth(
            status: IntegrityStatus.healthy,
            lastVerification: DateTime.now(),
            verifiedCount: 0,
            errorCount: 0,
          ),
        ) {
    // Start periodic background verification
    _verificationTimer =
        Timer.periodic(const Duration(minutes: 5), (_) => verifyLedger());
  }

  final Ref _ref;
  Timer? _verificationTimer;

  @override
  void dispose() {
    _verificationTimer?.cancel();
    super.dispose();
  }

  /// Performs a deep scan of the ledger to ensure consistency.
  Future<void> verifyLedger() async {
    final accountingService = _ref.read(accountingServiceProvider.notifier);

    try {
      final entries = await accountingService.getJournalEntries();
      var verified = 0;
      final anomalousIds = <String>[];
      var status = IntegrityStatus.healthy;
      String? message;

      for (final entry in entries) {
        // 1. Verify double-entry balance
        final totalDebit =
            entry.lines.fold<double>(0, (s, l) => s + l.debit.toDouble());
        final totalCredit =
            entry.lines.fold<double>(0, (s, l) => s + l.credit.toDouble());

        if ((totalDebit - totalCredit).abs() > 0.0001) {
          anomalousIds.add(entry.id);
          status = IntegrityStatus.needsHeal;
          message = 'Rounding discrepancy detected in ${entry.referenceNumber}';
        }
        verified++;
      }

      state = LedgerHealth(
        status: status,
        lastVerification: DateTime.now(),
        verifiedCount: verified,
        errorCount: anomalousIds.length,
        anomalousEntryIds: anomalousIds,
        message: message,
      );
    } on Exception catch (e) {
      state = state.copyWith(
        status: IntegrityStatus.compromised,
        lastVerification: DateTime.now(),
        message: 'Verification failed: $e',
      );
    }
  }

  /// Automatically heals minor anomalies (e.g., rounding) by creating adjusting entries.
  Future<void> healLedger() async {
    if (state.status != IntegrityStatus.needsHeal) return;

    final accountingService = _ref.read(accountingServiceProvider.notifier);
    final anomalousIds = List<String>.from(state.anomalousEntryIds);

    state = state.copyWith(message: 'Self-healing in progress...');

    try {
      // 1. Ensure 'Forensic Suspense' account exists
      final suspenseAccount = await _getOrCreateSuspenseAccount();

      for (final entryId in anomalousIds) {
        final entries = await accountingService.getJournalEntries();
        final entry = entries.firstWhere((e) => e.id == entryId);

        final diff = entry.totalDebit - entry.totalCredit;
        if (diff == Decimal.zero) continue;

        // Create adjusting line to suspense account
        final adjustmentLine = JournalEntryLine(
          accountId: suspenseAccount.id,
          accountName: suspenseAccount.nameEn,
          debit: diff < Decimal.zero ? -diff : Decimal.zero,
          credit: diff > Decimal.zero ? diff : Decimal.zero,
          description: 'Forensic Adjustment for ${entry.referenceNumber}',
        );

        final now = DateTime.now();
        final adjustmentEntry = JournalEntry(
          id: 'heal-${entry.id}-$now',
          referenceNumber: 'HEAL-${entry.referenceNumber}',
          date: now,
          temporal: TemporalJustification(
            transactionDate: now,
            effectiveDate: now,
            recordingDate: now,
          ),
          standards: const StandardsJustification(
            standardReference: 'Forensic Self-Healing Protocol',
            recognitionBasis: 'Rounding Adjustment',
          ),
          description: 'Automated healing for entry ${entry.referenceNumber}',
          status: JournalEntryStatus.posted,
          lines: [...entry.lines, adjustmentLine],
          sourceDocument: 'forensic_guardian',
          sourceId: entry.id,
          createdBy: 'forensic_guardian',
          createdAt: now,
          updatedAt: now,
          postedAt: now,
          auditLogs: [
            AuditLogEntry(
              timestamp: now,
              action: 'SELF_HEAL',
              rationale:
                  'Automatic reconciliation of rounding discrepancy ($diff)',
              actor: 'ForensicGuardian',
            ),
          ],
        );

        // Post with cognitive bypass as it's a system correction
        await accountingService.postJournalEntry(
          adjustmentEntry,
          bypassCognitive: true,
        );
      }

      await verifyLedger();
      state = state.copyWith(message: 'Self-healing completed successfully.');
    } on Exception catch (e) {
      state = state.copyWith(
        status: IntegrityStatus.compromised,
        message: 'Self-healing failed: $e',
      );
    }
  }

  Future<Account> _getOrCreateSuspenseAccount() async {
    final accountingService = _ref.read(accountingServiceProvider.notifier);
    final accounts = await accountingService.getAccounts();

    try {
      return accounts.firstWhere((a) => a.code == 'FORENSIC-SUSPENSE');
    } on Exception {
      final suspense = Account(
        id: 'acc-forensic-suspense',
        code: 'FORENSIC-SUSPENSE',
        nameAr: 'حساب المعلق الجنائي',
        nameEn: 'Forensic Suspense Account',
        type: AccountType
            .equity, // Or liability, usually a suspense is equity/liability
        nature: AccountNature.credit,
        balance: Decimal.zero,
        isSystem: true,
      );
      await accountingService.addAccount(suspense);
      return suspense;
    }
  }
}
