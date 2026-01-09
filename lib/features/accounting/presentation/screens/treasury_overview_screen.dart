import 'package:basir_app/core/extensions/context_extensions.dart';
import 'package:basir_app/features/accounting/application/accounting_service.dart';
import 'package:basir_app/features/accounting/application/treasury_service.dart';
import 'package:basir_app/features/accounting/domain/entities/account.dart';
import 'package:basir_app/features/accounting/domain/entities/financial_voucher.dart';
// ignore: unused_import
import 'package:basir_app/features/accounting/presentation/screens/voucher_form_screen.dart';
import 'package:basir_app/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' as intl;

/// شاشة نظرة عامة على الخزينة (Treasury Overview)
class TreasuryOverviewScreen extends ConsumerWidget {
  /// إنشاء شاشة نظرة عامة على الخزينة.
  const TreasuryOverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
        appBar: AppAppBar(
          title: context.l10n.treasuryTitle,
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(getVouchersProvider);
            ref.invalidate(accountingServiceProvider);
          },
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildCashBalances(ref),
              const SizedBox(height: 24),
              _buildQuickActions(context),
              const SizedBox(height: 24),
              Text(
                context.l10n.recentVouchersTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              _buildVouchersList(context, ref),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _createNewVoucher(context, VoucherType.receipt),
          label: Text(context.l10n.newVoucherLabel),
          icon: const Icon(Icons.add),
        ),
      );

  Widget _buildCashBalances(WidgetRef ref) => ref
      .watch(accountingServiceProvider)
      .when(
        data: (_) => FutureBuilder<List<Account>>(
          future: ref.read(accountingServiceProvider.notifier).getAccounts(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
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
                const SizedBox(height: 12),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: cashAccounts.length,
                    itemBuilder: (context, index) {
                      final account = cashAccounts[index];
                      return Container(
                        width: 200,
                        margin: const EdgeInsets.only(left: 12),
                        child: AppCard(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                account.nameAr,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
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
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      );

  Widget _buildQuickActions(BuildContext context) => Row(
        children: [
          Expanded(
            child: AppEnhancedButton(
              label: context.l10n.receiptVoucherAction,
              icon: Icons.call_received,
              onPressed: () => _createNewVoucher(context, VoucherType.receipt),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: AppEnhancedButton(
              label: context.l10n.paymentVoucherAction,
              type: AppEnhancedButtonType.secondary,
              icon: Icons.call_made,
              onPressed: () => _createNewVoucher(context, VoucherType.payment),
            ),
          ),
        ],
      );

  Widget _buildVouchersList(BuildContext context, WidgetRef ref) => ref
      .watch(getVouchersProvider)
      .when(
        data: (vouchers) {
          if (vouchers.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
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
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final voucher = sortedVouchers[index];
              final color = voucher.type == VoucherType.receipt
                  ? Colors.green
                  : Colors.red;

              return AppCard(
                onTap: () {
                  // Future: Navigate to details
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
                  title:
                      Text(voucher.personName ?? context.l10n.anonymousPerson),
                  subtitle: Text(
                    '${intl.DateFormat('yyyy/MM/dd').format(voucher.date)} '
                    '- ${voucher.referenceNumber}',
                  ),
                  trailing: Text(
                    '${voucher.amount} ر.س',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      );

  void _createNewVoucher(BuildContext context, VoucherType type) {
    // ignore: discarded_futures
    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (context) => VoucherFormScreen(type: type),
      ),
    );
  }
}
