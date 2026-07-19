import 'package:basir_accounting_system/core/extensions/context_extensions.dart';
import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/accounting_agent.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/journal_entry.dart';
import 'package:basir_accounting_system/features/accounting/presentation/widgets/consensus_visualization_widget.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';

/// Screen displaying high-fidelity details of a single [JournalEntry]
/// with integrated forensic audit findings and multi-agent consensus.
class JournalEntryDetailScreen extends ConsumerWidget {
  /// Creates a [JournalEntryDetailScreen].
  const JournalEntryDetailScreen({
    required this.entry,
    super.key,
  });

  /// The entry to display.
  final JournalEntry entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final totalDebit = entry.lines.fold<double>(
      0,
      (sum, line) => sum + line.debit.toDouble(),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(entry.referenceNumber),
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () async {
              final pdfService = ref.read(pdfGenerationServiceProvider.notifier);
              final pdfBytes = await pdfService.generateJournalEntryPdf(entry);
              await Printing.layoutPdf(
                onLayout: (format) => pdfBytes,
                name: 'JE_${entry.referenceNumber}',
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, ref),
            const SizedBox(height: 24),
            _buildSummary(context, totalDebit),
            const SizedBox(height: 24),
            Text(
              l10n.labelGeneralLedger,
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildLinesList(context),
            const SizedBox(height: 32),
            _buildForensicSection(context),
            const SizedBox(height: 24),
            _buildAuditTrailSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final scHighest = Theme.of(context).colorScheme.surfaceContainerHighest;
    final headerColor = scHighest.withValues(alpha: 0.3);

    return Card(
      elevation: 0,
      color: headerColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _HeaderRow(
              label: l10n.labelDate,
              value: DateFormat.yMMMd(
                Localizations.localeOf(context).languageCode,
              ).format(entry.date),
            ),
            const Divider(),
            _HeaderRow(
              label: l10n.labelStatus,
              value: entry.status.name.toUpperCase(),
              valueColor: _getStatusColor(entry.status),
            ),
            const Divider(),
            _HeaderRow(
              label: l10n.labelDescription,
              value: entry.description,
            ),
            if (entry.sourceId.isNotEmpty && //
                entry.sourceDocument.isNotEmpty) ...[
              const Divider(),
              _HeaderRow(
                label: l10n.labelSourceDocument,
                value: '${entry.sourceDocument}: ${entry.sourceId}',
                onTap: () => _navigateToSource(context, ref),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSummary(BuildContext context, double total) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total Balanced Amount',
              style: context.textTheme.titleSmall,
            ),
            Text(
              total.toStringAsFixed(2),
              style: context.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      );

  Widget _buildLinesList(BuildContext context) => ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: entry.lines.length,
        itemBuilder: (context, index) {
          final line = entry.lines[index];
          final isDebit = line.debit != Decimal.zero;
          return ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(line.accountName),
            subtitle: Text(line.description ?? ''),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  isDebit ? line.debit.toString() : line.credit.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDebit ? Colors.green : Colors.red,
                  ),
                ),
                Text(
                  isDebit ? 'DEBIT' : 'CREDIT',
                  style: context.textTheme.labelSmall,
                ),
              ],
            ),
          );
        },
      );

  Widget _buildForensicSection(BuildContext context) {
    final isPosted = entry.status == JournalEntryStatus.posted;
    return ConsensusVisualizationWidget(
      isConsensusAchieved: isPosted,
      agentResults: const <AgentResult>[],
    );
  }

  Widget _buildAuditTrailSection(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Scientific Audit Trail',
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _AuditItem(
            label: 'Temporal Justification',
            value: 'Effective: '
                '${DateFormat.yMd().format(entry.temporal.effectiveDate)}\n'
                'Recorded: '
                '${DateFormat.yMd().format(entry.temporal.recordingDate)}',
            icon: Icons.history_edu,
          ),
          const SizedBox(height: 12),
          _AuditItem(
            label: 'Standards Reference',
            value: entry.standards.standardReference,
            icon: Icons.gavel,
          ),
        ],
      );

  Future<void> _navigateToSource(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;

    // Show loading indicator
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.msgLoadingSource),
        duration: const Duration(seconds: 1),
      ),
    );

    try {
      final isInvoice = entry.sourceDocument == 'sales_invoice' || //
          entry.sourceDocument == 'invoice';
      if (isInvoice) {
        final repository = ref.read(invoiceRepositoryProvider);
        final invoice = await repository.getInvoiceById(entry.sourceId);

        if (context.mounted) {
          if (invoice != null) {
            await Navigator.pushNamed(
              context,
              '/invoice-detail',
              arguments: invoice,
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.errSourceNotFound)),
            );
          }
        }
      } else {
        // Handle other source types if needed
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Source type ${entry.sourceDocument} navigation '
                'not yet implemented',
              ),
            ),
          );
        }
      }
    } on Exception catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errSourceNotFound)),
        );
      }
    }
  }

  Color _getStatusColor(JournalEntryStatus status) {
    switch (status) {
      case JournalEntryStatus.draft:
        return Colors.orange;
      case JournalEntryStatus.posted:
        return Colors.green;
      case JournalEntryStatus.voided:
        return Colors.red;
    }
  }
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.onTap,
  });
  final String label;
  final String value;
  final Color? valueColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: context.textTheme.bodySmall),
              const SizedBox(width: 16),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Text(
                        value,
                        textAlign: TextAlign.end,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: valueColor ?? //
                              (onTap != null ? Theme.of(context).primaryColor : null),
                          fontWeight: (valueColor != null || onTap != null) //
                              ? FontWeight.bold
                              : null,
                        ),
                      ),
                    ),
                    if (onTap != null) ...[
                      const SizedBox(width: 4),
                      Icon(
                        Icons.open_in_new,
                        size: 14,
                        color: Theme.of(context).primaryColor,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}

class _AuditItem extends StatelessWidget {
  const _AuditItem({
    required this.label,
    required this.value,
    required this.icon,
  });
  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: context.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  value,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
}
