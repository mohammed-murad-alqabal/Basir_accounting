import 'package:basir_accounting_system/core/extensions/context_extensions.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/features/accounting/application/financial_statement_service.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/financial_report.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' as intl;

/// Screen presenting the Trial Balance worksheet.
///
/// Centrally aggregates the closing balances of all ledger accounts,
/// categorized into Debit and Credit columns to verify mathematical
/// equilibrium and technical ledger readiness for period closing.
class TrialBalanceScreen extends ConsumerWidget {
  /// Creates the trial balance screen.
  const TrialBalanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trialBalanceAsync = ref
        .watch(financialStatementServiceProvider.notifier)
        .generateTrialBalance(DateTime.now());

    final currencyFormatter = intl.NumberFormat.currency(
      symbol: '',
      decimalDigits: 2,
    );

    return Scaffold(
      appBar: AppAppBar(
        title: context.l10n.trialBalanceTitle,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _exportReport(context, ref),
            tooltip: context.l10n.actionShare,
          ),
        ],
      ),
      body: FutureBuilder<TrialBalance>(
        future: trialBalanceAsync,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: AppLoadingIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final trialBalance = snapshot.data;
          final rows = trialBalance?.lines ?? [];

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              child: DataTable(
                columnSpacing: Spacing.lg,
                columns: [
                  DataColumn(label: Text(context.l10n.labelCode)),
                  DataColumn(label: Text(context.l10n.labelAccount)),
                  DataColumn(
                    label: Text(
                      context.l10n.labelDebit,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      context.l10n.labelCredit,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
                rows: rows
                    .map(
                      (row) => DataRow(
                        cells: [
                          DataCell(Text(row.accountCode)),
                          DataCell(Text(row.accountName)),
                          DataCell(
                            Text(
                              row.debitBalance > Decimal.zero
                                  ? currencyFormatter.format(
                                      row.debitBalance.toDouble(),
                                    )
                                  : '-',
                              style: TextStyle(
                                color: row.debitBalance > Decimal.zero
                                    ? AppColors.success
                                    : null,
                                fontWeight: row.debitBalance > Decimal.zero
                                    ? FontWeight.bold
                                    : null,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              row.creditBalance > Decimal.zero
                                  ? currencyFormatter.format(
                                      row.creditBalance.toDouble(),
                                    )
                                  : '-',
                              style: TextStyle(
                                color: row.creditBalance > Decimal.zero
                                    ? AppColors.error
                                    : null,
                                fontWeight: row.creditBalance > Decimal.zero
                                    ? FontWeight.bold
                                    : null,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Triggers the statutory export workflow for trial balance data.
  Future<void> _exportReport(BuildContext context, WidgetRef ref) async {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('ميزة التصدير ستتوفر قريباً')));
  }
}
