// ignore_for_file: lines_longer_than_80_chars
import 'package:basir_accounting_system/core/extensions/context_extensions.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/features/accounting/application/accounting_service.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/journal_entry.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' as intl;

/// Screen presenting a chronological audit trail of system events,
/// consensus bypasses, and forensic flags.
/// (Standard Reference: CP-011: Forensic Traceability)
class AuditTrailReportScreen extends ConsumerWidget {
  /// Creates an audit trail report screen.
  const AuditTrailReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(accountingServiceProvider);

    return Scaffold(
      appBar: AppAppBar(
        title: context.l10n.auditTrailTitle,
      ),
      body: entriesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (entries) {
          final auditEntries =
              entries.where((e) => e.auditLogs.isNotEmpty).toList();

          if (auditEntries.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(Spacing.xl),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.assignment_turned_in_outlined,
                      size: 64,
                      color: AppColors.border,
                    ),
                    const SizedBox(height: Spacing.md),
                    Text(
                      context.l10n.auditTrailNoLogs,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(Spacing.md),
            itemCount: auditEntries.length,
            itemBuilder: (context, index) {
              final entry = auditEntries[index];
              return AppCard(
                margin: const EdgeInsets.only(bottom: Spacing.md),
                child: Padding(
                  padding: const EdgeInsets.all(Spacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            entry.referenceNumber,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          Text(
                            intl.DateFormat('yyyy-MM-dd HH:mm')
                                .format(entry.date),
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                      const SizedBox(height: Spacing.xs),
                      Text(
                        entry.description,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: Spacing.md),
                      _SectionHeader(
                        title: context.l10n.auditTrailSectionForensic,
                      ),
                      const SizedBox(height: Spacing.sm),
                      ...entry.auditLogs.map((log) => _AuditLogItem(log: log)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          const Icon(
            Icons.gpp_maybe_outlined,
            size: 16,
            color: AppColors.error,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              letterSpacing: 0.5,
            ),
          ),
        ],
      );
}

class _AuditLogItem extends StatelessWidget {
  const _AuditLogItem({required this.log});
  final AuditLogEntry log;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: Spacing.xs),
        padding: const EdgeInsets.all(Spacing.sm),
        decoration: BoxDecoration(
          color: Theme.of(context)
              .colorScheme
              .surfaceContainerHighest
              .withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(Radii.sm),
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(Radii.xs),
                  ),
                  child: Text(
                    log.action,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                      color: AppColors.error,
                    ),
                  ),
                ),
                Text(
                  intl.DateFormat('HH:mm:ss').format(log.timestamp),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              log.rationale,
              style: const TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.fingerprint, size: 10, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  'Actor: ${log.actor}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 10,
                        fontStyle: FontStyle.italic,
                      ),
                ),
              ],
            ),
          ],
        ),
      );
}
