// ignore_for_file: lines_longer_than_80_chars
import 'package:basir_accounting_system/core/extensions/context_extensions.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/journal_entry.dart';
import 'package:basir_accounting_system/features/accounting/presentation/providers/journal_entry_providers.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

/// Screen to display the Sub-Ledger for a specific entity (Customer or Supplier).
/// Part of the drill-down analysis from Aging Reports.
class EntityTransactionsScreen extends ConsumerWidget {
  /// Creates a new Entity Transactions screen instance.
  const EntityTransactionsScreen({
    required this.entityId,
    required this.entityName,
    required this.isCustomer,
    super.key,
  });

  /// The unique identifier of the customer or supplier.
  final String entityId;

  /// The human-readable name of the entity.
  final String entityName;

  /// Whether the entity is a customer (AR) or supplier (AP).
  final bool isCustomer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(
      subLedgerJournalEntriesProvider(
        entityId: entityId,
        isCustomer: isCustomer,
      ),
    );

    return GlassScaffold(
      title: entityName,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: entriesAsync.when(
              loading: () => const Center(child: AppLoadingIndicator()),
              error: (err, stack) => AppErrorWidget(message: err.toString()),
              data: (entries) {
                if (entries.isEmpty) {
                  return AppEmptyState(
                    title: context.l10n.msgNoTransactionsFound,
                    icon: Icons.receipt_long,
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: entries.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final entry = entries[index];
                    return _buildTransactionItem(context, entry);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) => Padding(
        padding: const EdgeInsets.all(16),
        child: GlassCard(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isCustomer
                          ? context.l10n.labelCustomer
                          : context.l10n.navVendors,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    Text(
                      entityName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                Icon(
                  isCustomer ? Icons.person_outline : Icons.business_outlined,
                  color: AppColors.primary,
                  size: 32,
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildTransactionItem(BuildContext context, JournalEntry entry) {
    // Determine if this entry is a net debit or credit for the entity
    // For customers (AR): Debit is increase, Credit is decrease.
    // For suppliers (AP): Credit is increase, Debit is decrease.

    // Total the impact on the entity's ledger
    // We'll peek at the first line that matches our expected accounts/name
    // (This logic mirrors the provider's filtering)
    final line = entry.lines.firstWhere(
      (l) =>
          l.accountName.contains(entityId) ||
          l.accountId.startsWith('acc-12') ||
          l.accountId.startsWith('acc-21'),
    );

    final amount = line.debit > line.credit ? line.debit : line.credit;
    final isPositiveImpact =
        isCustomer ? line.debit > line.credit : line.credit > line.debit;

    return GlassCard(
      onTap: () async {
        await Navigator.pushNamed(
          context,
          '/journal-entry-detail',
          arguments: entry,
        );
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isPositiveImpact
              ? Colors.green.withValues(alpha: 0.1)
              : Colors.red.withValues(alpha: 0.1),
          child: Icon(
            isPositiveImpact ? Icons.add : Icons.remove,
            color: isPositiveImpact ? Colors.green : Colors.red,
            size: 16,
          ),
        ),
        title: Text(entry.description),
        subtitle: Text(
          DateFormat.yMMMd(Localizations.localeOf(context).languageCode)
              .format(entry.date),
        ),
        trailing: Text(
          amount.toStringAsFixed(2),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isPositiveImpact ? Colors.green : Colors.red,
          ),
        ),
      ),
    );
  }
}
