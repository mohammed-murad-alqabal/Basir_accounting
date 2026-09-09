// ignore_for_file: lines_longer_than_80_chars
import 'dart:async';

import 'package:basir_accounting_system/features/accounting/application/accounting_service.dart';
import 'package:basir_accounting_system/features/forensics/domain/entities/integrity_status.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for the LedgerIntegrityService.
final ledgerIntegrityServiceProvider =
    StateNotifierProvider<LedgerIntegrityService, LedgerHealth>(
  LedgerIntegrityService.new,
);

/// Service responsible for monitoring the General Ledger and flagging anomalies for controlled remediation.
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

  /// Automated financial corrections are intentionally disabled.
  ///
  /// A detected discrepancy must be investigated and resolved with a
  /// separately prepared, reviewed, and approved adjustment entry. This
  /// prevents a diagnostic service from creating irreversible ledger impact.
  Future<void> healLedger() async {
    if (state.status != IntegrityStatus.needsHeal) return;

    state = state.copyWith(
      status: IntegrityStatus.compromised,
      lastVerification: DateTime.now(),
      message:
          'Automated ledger correction is disabled. Prepare a reviewed adjustment entry through the controlled posting workflow.',
    );
  }
}
