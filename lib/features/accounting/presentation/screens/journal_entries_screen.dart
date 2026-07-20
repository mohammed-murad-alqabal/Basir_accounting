import 'dart:typed_data';

import 'package:basir_accounting_system/core/extensions/context_extensions.dart';
import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/core/theme/tokens/color_tokens.dart';
import 'package:basir_accounting_system/core/theme/tokens/spacing_tokens.dart';
import 'package:basir_accounting_system/features/accounting/application/accounting_service.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/journal_entry.dart';
import 'package:basir_accounting_system/features/accounting/presentation/providers/journal_entry_providers.dart';
import 'package:basir_accounting_system/features/accounting/presentation/screens/journal_entry_form_screen.dart';
import 'package:basir_accounting_system/features/reports/application/report_export_service.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' as intl;

/// Primary screen for browsing, filtering, and managing the General Ledger
/// (Journal Entries).
///
/// Provides a detailed view of balanced accounting transactions with
/// support for reversal of posted entries and state transitions
/// (Draft -> Posted).
class JournalEntriesScreen extends ConsumerWidget {
  /// Creates the Journal Entries screen.
  const JournalEntriesScreen({super.key, this.accountId});

  /// Unique account identifier to filter entries (for drill-down).
  final String? accountId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(
      filteredJournalEntriesProvider(accountId: accountId),
    );

    return Scaffold(
      appBar: AppAppBar(
        title: context.l10n.labelJournalEntries,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _showExportOptions(context, ref),
            tooltip: context.l10n.btnExport,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'تحديث',
            onPressed: () => ref.invalidate(accountingServiceProvider),
          ),
        ],
      ),
      body: entriesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (entries) {
          if (entries.isEmpty) {
            return Center(child: Text(context.l10n.emptyJournalEntriesMessage));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(Spacing.md),
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              return Card(
                margin: const EdgeInsets.only(bottom: Spacing.md),
                child: Theme(
                  data: Theme.of(
                    context,
                  ).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    title: Row(
                      children: [
                        Text(
                          entry.referenceNumber,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          intl.DateFormat('yyyy-MM-dd').format(entry.date),
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                        _buildActions(context, ref, entry),
                      ],
                    ),
                    subtitle: Text(
                      entry.description,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                    children: [
                      const Divider(height: 1),
                      _buildEntryLines(context, entry.lines),
                      const Divider(height: 1),
                      Padding(
                        padding: const EdgeInsets.all(Spacing.md),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${context.l10n.labelTotal}: '
                              '${_formatCurrency(entry.totalDebit)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (entry.status == JournalEntryStatus.posted)
                              _buildStatusBadge(
                                context,
                                context.l10n.statusPosted,
                                AppColors.success,
                                AppColors.successLight,
                              )
                            else
                              _buildStatusBadge(
                                context,
                                context.l10n.statusDraft,
                                AppColors.textSecondary,
                                AppColors.surfaceVariant,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'journal_entries_add_fab',
        onPressed: () async {
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute<bool>(
              builder: (context) => const JournalEntryFormScreen(),
            ),
          );
          if (result ?? false) {
            // Re-invalidate handled by build
          }
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  /// Contextual action menu based on the entry's lifecycle state.
  Widget _buildActions(
    BuildContext context,
    WidgetRef ref,
    JournalEntry entry,
  ) {
    if (entry.status == JournalEntryStatus.posted) {
      return PopupMenuButton<String>(
        icon: const Icon(Icons.more_vert, size: 20),
        onSelected: (value) async {
          if (value == 'reverse') {
            await _handleReverse(context, ref, entry);
          }
        },
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 'reverse',
            child: Text(context.l10n.actionReverse),
          ),
        ],
      );
    } else {
      return PopupMenuButton<String>(
        icon: const Icon(Icons.more_vert, size: 20),
        onSelected: (value) async {
          if (value == 'edit') {
            await _handleEdit(context, entry);
          } else if (value == 'post') {
            await _handlePost(context, ref, entry);
          }
        },
        itemBuilder: (context) => [
          PopupMenuItem(value: 'edit', child: Text(context.l10n.actionEdit)),
          PopupMenuItem(value: 'post', child: Text(context.l10n.actionPostNow)),
        ],
      );
    }
  }

  /// Initiates an automated reversal entry workflow for historical corrections.
  Future<void> _handleReverse(
    BuildContext context,
    WidgetRef ref,
    JournalEntry entry,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.actionReverse),
        content: Text(context.l10n.msgConfirmReverse),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.dialogCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.l10n.actionReverse),
          ),
        ],
      ),
    );

    if (confirm ?? false) {
      try {
        await ref
            .read(accountingServiceProvider.notifier)
            .reverseJournalEntry(entry.id);
        if (!context.mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(context.l10n.msgReverseSuccess)));
      } on Exception catch (e) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  /// Navigates to the editor for unposted draft entries.
  Future<void> _handleEdit(BuildContext context, JournalEntry entry) async {
    await Navigator.push<bool>(
      context,
      MaterialPageRoute<bool>(
        builder: (context) => JournalEntryFormScreen(entry: entry),
      ),
    );
  }

  /// Transitions a Draft entry to a final Posted state in the General Ledger.
  Future<void> _handlePost(
    BuildContext context,
    WidgetRef ref,
    JournalEntry entry,
  ) async {
    try {
      final updated = entry.copyWith(
        status: JournalEntryStatus.posted,
        updatedAt: DateTime.now(),
        postedAt: DateTime.now(),
      );
      await ref
          .read(accountingServiceProvider.notifier)
          .postJournalEntry(updated);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.msgJournalEntryPosted)),
      );
    } on Exception catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error),
      );
    }
  }

  /// Renders a thematic badge for entry status (Draft/Posted).
  Widget _buildStatusBadge(
    BuildContext context,
    String label,
    Color textColor,
    Color bgColor,
  ) =>
      Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.sm,
          vertical: Spacing.xs,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: Radii.borderRadiusSm,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

  /// Builds the scrollable list of Debit/Credit atomic lines.
  Widget _buildEntryLines(BuildContext context, List<JournalEntryLine> lines) =>
      Column(
        children: lines.map((line) => _buildLineRow(context, line)).toList(),
      );

  /// Renders a single accounting line with semantic balance colors.
  Widget _buildLineRow(BuildContext context, JournalEntryLine line) => Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.md,
          vertical: Spacing.xs,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    line.accountName,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  if (line.description != null)
                    Text(
                      line.description!,
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.textHint,
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                line.debit > Decimal.zero ? _formatCurrency(line.debit) : '-',
                textAlign: TextAlign.end,
                style: const TextStyle(
                  color: AppColors.success,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                line.credit > Decimal.zero ? _formatCurrency(line.credit) : '-',
                textAlign: TextAlign.end,
                style: const TextStyle(
                  color: AppColors.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      );

  /// Formats currency values for consistency across the UI.
  String _formatCurrency(Decimal value) => intl.NumberFormat.currency(
        symbol: '',
        decimalDigits: 2,
      ).format(value.toDouble());

  /// Shows export format modal (PDF/CSV).
  Future<void> _showExportOptions(BuildContext context, WidgetRef ref) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.picture_as_pdf),
              title: Text(context.l10n.labelExportPdf),
              onTap: () async {
                Navigator.pop(context);
                await _exportReport(context, ref, asPdf: true);
              },
            ),
            ListTile(
              leading: const Icon(Icons.table_chart),
              title: Text(context.l10n.labelExportCsv),
              onTap: () async {
                Navigator.pop(context);
                await _exportReport(context, ref, asPdf: false);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Exports the current ledger view in the selected format.
  Future<void> _exportReport(
    BuildContext context,
    WidgetRef ref, {
    required bool asPdf,
  }) async {
    try {
      final entries = await ref.read(accountingServiceProvider.future);
      if (!context.mounted) return;

      final exportService = ref.read(reportExportServiceProvider.notifier);

      final headers = [
        context.l10n.labelIssuedDate,
        context.l10n.labelReference,
        context.l10n.labelDescription,
        context.l10n.labelStatus,
        context.l10n.labelTotal,
      ];

      final data = entries
          .map(
            (e) => [
              intl.DateFormat('yyyy-MM-dd').format(e.date),
              e.referenceNumber,
              e.description,
              if (e.status == JournalEntryStatus.posted)
                context.l10n.statusPosted
              else
                context.l10n.statusDraft,
              e.totalDebit.toString(),
            ],
          )
          .toList();

      if (asPdf) {
        await exportService.shareTablePdf(
          title: context.l10n.labelJournalEntries,
          headers: headers,
          data: data,
          filename: 'journal_entries.pdf',
        );
      } else {
        final csvData = exportService.generateTableCsv(
          headers: headers,
          data: data,
        );
        final bytes = Uint8List.fromList(csvData.codeUnits);
        final sharingService = ref.read(sharingServiceProvider);
        await sharingService.shareFile(
          bytes: bytes,
          fileName: 'journal_entries.csv',
        );
      }
    } on Exception catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${context.l10n.errorExportingReport}: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}
