import 'package:basir_accounting_system/core/extensions/context_extensions.dart';
import 'package:basir_accounting_system/features/accounting/application/accounting_service.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/journal_entry.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

/// Screen to display the General Ledger for a specific account.
/// Allows drill-down into individual Journal Entries.
class GeneralLedgerScreen extends ConsumerStatefulWidget {
  const GeneralLedgerScreen({
    required this.accountId,
    required this.accountName,
    required this.fromDate,
    required this.toDate,
    super.key,
  });

  final String accountId;
  final String accountName;
  final DateTime fromDate;
  final DateTime toDate;

  @override
  ConsumerState<GeneralLedgerScreen> createState() =>
      _GeneralLedgerScreenState();
}

class _GeneralLedgerScreenState extends ConsumerState<GeneralLedgerScreen> {
  @override
  Widget build(BuildContext context) {
    // Determine the relevant journal entries for this account and period.
    // In a real implementation, this would likely be a specific repository method
    // (e.g., getLedgerForAccount) to ensure efficient fetching and running balance calculation.
    // For now, we filter the all-entries stream.
    final entriesAsync = ref.watch(accountingServiceProvider);

    return GlassScaffold(
      title: widget.accountName,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: entriesAsync.when(
              loading: () => const Center(child: AppLoadingIndicator()),
              error: (err, stack) => AppErrorWidget(message: err.toString()),
              data: (allEntries) {
                final relevantEntries = _filterAndSortEntries(allEntries);

                if (relevantEntries.isEmpty) {
                  return AppEmptyState(
                    title: context.l10n.msgNoTransactionsFound,
                    icon: Icons.receipt_long,
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: relevantEntries.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final entry = relevantEntries[index];
                    return _buildLedgerItem(context, entry);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final dateFormat =
        DateFormat.yMMMd(Localizations.localeOf(context).languageCode);
    return Padding(
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
                    context.l10n.labelPeriod,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  Text(
                    '${dateFormat.format(widget.fromDate)} - ${dateFormat.format(widget.toDate)}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              // Placeholder for Opening Balance if we had it easily available
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    context.l10n
                        .labelGeneralLedger, // "General Ledger" / "دفتر الأستاذ"
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  Text(
                    widget.accountName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLedgerItem(BuildContext context, JournalEntry entry) {
    // Find limits line for this account
    final line = entry.lines.firstWhere((l) => l.accountId == widget.accountId);
    final isDebit = line.debit > line.credit;
    final amount = isDebit ? line.debit : line.credit;

    return GlassCard(
      // ignore: discarded_futures
      onTap: () async {
        await Navigator.pushNamed(
          context,
          '/journal-entry-detail',
          arguments: entry,
        );
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isDebit
              ? Colors.green.withValues(alpha: 0.1)
              : Colors.red.withValues(alpha: 0.1),
          child: Icon(
            isDebit ? Icons.arrow_downward : Icons.arrow_upward,
            color: isDebit ? Colors.green : Colors.red,
            size: 16,
          ),
        ),
        title: Text(entry.description),
        subtitle: Text(
          DateFormat.yMMMd(Localizations.localeOf(context).languageCode)
              .format(entry.date),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              amount.toStringAsFixed(2),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDebit ? Colors.green : Colors.red,
              ),
            ),
            Text(
              isDebit ? context.l10n.labelDebit : context.l10n.labelCredit,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
  }

  List<JournalEntry> _filterAndSortEntries(List<JournalEntry> allEntries) =>
      allEntries.where((e) {
        if (e.date.isBefore(widget.fromDate) || e.date.isAfter(widget.toDate)) {
          return false;
        }
        return e.lines.any((l) => l.accountId == widget.accountId);
      }).toList()
        ..sort((a, b) => b.date.compareTo(a.date));
}
