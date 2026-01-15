import 'dart:async';

import 'package:basir_accounting_system/core/extensions/context_extensions.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/features/accounting/application/accounting_service.dart';
import 'package:basir_accounting_system/features/accounting/application/treasury_service.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/account.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/financial_voucher.dart';
import 'package:basir_accounting_system/features/accounting/presentation/screens/voucher_form_screen.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' as intl;

/// Command center for tracking liquidity and treasury operations.
///
/// Provides a real-time monitor for cash and bank balances, along with a
/// prioritized list of recent Receipt and Payment vouchers.
class TreasuryOverviewScreen extends ConsumerWidget {
  /// Creates the treasury overview screen.
  const TreasuryOverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
        appBar: AppAppBar(title: context.l10n.treasuryTitle),
        body: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(getVouchersProvider);
            ref.invalidate(accountingServiceProvider);
          },
          child: ListView(
            padding: const EdgeInsets.all(Spacing.md),
            children: [
              _buildCashBalances(ref),
              const SizedBox(height: Spacing.lg),
              _buildQuickActions(context),
              const SizedBox(height: Spacing.lg),
              Text(
                context.l10n.recentVouchersTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: Spacing.md),
              _buildVouchersList(context, ref),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _createNewVoucher(context, VoucherType.receipt),
          label: Text(context.l10n.newVoucherLabel),
          icon: const Icon(Icons.add),
          backgroundColor: AppColors.primary,
        ),
      );

  /// Renders a horizontal scrollable view of atomic cash/bank accounts.
  Widget _buildCashBalances(WidgetRef ref) => ref
      .watch(accountingServiceProvider)
      .when(
        data: (_) => FutureBuilder<List<Account>>(
          future: ref.read(accountingServiceProvider.notifier).getAccounts(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: AppLoadingIndicator());
            }

            final cashAccounts = snapshot.data!
                .where((a) => a.code.startsWith('11') || a.subType == 'cash')
                .toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.cashBalancesTitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: Spacing.md),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: cashAccounts.length,
                    itemBuilder: (context, index) {
                      final account = cashAccounts[index];
                      return Container(
                        width: 200,
                        margin: const EdgeInsets.only(left: Spacing.md),
                        child: AppCard(
                          padding: const EdgeInsets.all(Spacing.md),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                account.nameAr,
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 14,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: Spacing.sm),
                              Text(
                                '${account.balance} ر.س',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
        loading: () => const Center(child: AppLoadingIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      );

  /// Renders shortcut buttons for issuing new Receipts or Payments.
  Widget _buildQuickActions(BuildContext context) => Column(
        children: [
          Row(
            children: [
              Expanded(
                child: AppEnhancedButton(
                  label: context.l10n.receiptVoucherAction,
                  icon: Icons.call_received,
                  onPressed: () =>
                      _createNewVoucher(context, VoucherType.receipt),
                ),
              ),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: AppEnhancedButton(
                  label: context.l10n.paymentVoucherAction,
                  type: AppEnhancedButtonType.secondary,
                  icon: Icons.call_made,
                  onPressed: () =>
                      _createNewVoucher(context, VoucherType.payment),
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.md),
          AppEnhancedButton(
            label: 'تسوية النقدية (Liquid Verification)',
            type: AppEnhancedButtonType.outlined,
            icon: Icons.account_balance_wallet_outlined,
            onPressed: () {
              unawaited(Navigator.pushNamed(context, '/cash-reconciliation'));
            },
          ),
        ],
      );

  /// Lists the chronologically sorted recent financial vouchers.
  Widget _buildVouchersList(BuildContext context, WidgetRef ref) => ref
      .watch(getVouchersProvider)
      .when(
        data: (vouchers) {
          if (vouchers.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: Spacing.xl),
                child: Text(context.l10n.noVouchersMessage),
              ),
            );
          }

          final sortedVouchers = [...vouchers]
            ..sort((a, b) => b.date.compareTo(a.date));

          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: sortedVouchers.length,
            separatorBuilder: (_, __) => const SizedBox(height: Spacing.sm),
            itemBuilder: (context, index) {
              final voucher = sortedVouchers[index];
              final color = voucher.type == VoucherType.receipt
                  ? AppColors.success
                  : AppColors.error;

              return AppCard(
                onTap: () {
                  // Future: Navigate to voucher details/preview
                },
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: color.withValues(alpha: 0.1),
                    child: Icon(
                      voucher.type == VoucherType.receipt
                          ? Icons.add
                          : Icons.remove,
                      color: color,
                    ),
                  ),
                  title: Text(
                    voucher.personName ?? context.l10n.anonymousPerson,
                  ),
                  subtitle: Text(
                    '${intl.DateFormat('yyyy/MM/dd').format(voucher.date)} '
                    '- ${voucher.referenceNumber}',
                  ),
                  trailing: Text(
                    '${voucher.amount} ر.س',
                    style: TextStyle(fontWeight: FontWeight.bold, color: color),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: AppLoadingIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      );

  /// Navigates to the voucher issuance form.
  void _createNewVoucher(BuildContext context, VoucherType type) {
    unawaited(
      Navigator.push<void>(
        context,
        MaterialPageRoute<void>(
          builder: (context) => VoucherFormScreen(type: type),
        ),
      ),
    );
  }
}
