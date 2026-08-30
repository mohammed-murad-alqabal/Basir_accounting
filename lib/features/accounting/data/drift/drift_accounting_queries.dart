import 'package:basir_accounting_system/core/database/drift/app_database.dart';
import 'package:drift/drift.dart';

class DriftTrialBalanceRow {
  const DriftTrialBalanceRow({
    required this.tenantId,
    required this.fiscalPeriodId,
    required this.accountId,
    required this.currencyCode,
    required this.totalDebitMinor,
    required this.totalCreditMinor,
  });

  final String tenantId;
  final String fiscalPeriodId;
  final String accountId;
  final String currencyCode;
  final int totalDebitMinor;
  final int totalCreditMinor;

  int get signedTotalMinor => totalDebitMinor - totalCreditMinor;
}

/// Read-side accounting queries for the staged Drift adapter.
///
/// This class intentionally exposes only canonical financial facts. Cached
/// account balances must be derived from these rows and are not authoritative.
class DriftAccountingQueries extends DatabaseAccessor<AppDatabase> {
  DriftAccountingQueries(super.attachedDatabase);

  Future<List<DriftTrialBalanceRow>> trialBalance({
    required String tenantId,
    required String fiscalPeriodId,
  }) async {
    final result = await customSelect(
      '''
      SELECT
        e.tenant_id,
        e.fiscal_period_id,
        l.account_id,
        l.currency_code,
        SUM(l.debit_minor) AS total_debit_minor,
        SUM(l.credit_minor) AS total_credit_minor
      FROM journal_entries e
      JOIN journal_lines l ON l.entry_id = e.id
      WHERE e.tenant_id = ?
        AND e.fiscal_period_id = ?
        AND e.status = 'POSTED'
      GROUP BY e.tenant_id, e.fiscal_period_id, l.account_id, l.currency_code
      ORDER BY l.account_id, l.currency_code
      ''',
      variables: [
        Variable<String>(tenantId),
        Variable<String>(fiscalPeriodId),
      ],
      readsFrom: {
        attachedDatabase.journalEntries,
        attachedDatabase.journalLines,
      },
    ).get();

    return result
        .map(
          (row) => DriftTrialBalanceRow(
            tenantId: row.read<String>('tenant_id'),
            fiscalPeriodId: row.read<String>('fiscal_period_id'),
            accountId: row.read<String>('account_id'),
            currencyCode: row.read<String>('currency_code'),
            totalDebitMinor: row.read<int>('total_debit_minor'),
            totalCreditMinor: row.read<int>('total_credit_minor'),
          ),
        )
        .toList(growable: false);
  }

  Future<int> countPostedEntries({
    required String tenantId,
    required String fiscalPeriodId,
  }) async {
    final row = await customSelect(
      '''
      SELECT COUNT(*) AS count
      FROM journal_entries
      WHERE tenant_id = ?
        AND fiscal_period_id = ?
        AND status = 'POSTED'
      ''',
      variables: [
        Variable<String>(tenantId),
        Variable<String>(fiscalPeriodId),
      ],
      readsFrom: {attachedDatabase.journalEntries},
    ).getSingle();
    return row.read<int>('count');
  }
}
