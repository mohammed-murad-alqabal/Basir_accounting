// ignore_for_file: lines_longer_than_80_chars
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/features/forensics/application/ledger_integrity_service.dart';
import 'package:basir_accounting_system/features/forensics/domain/entities/integrity_status.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Advanced monitoring screen visualizing the hash chain and ledger integrity.
class ForensicGuardianScreen extends ConsumerWidget {
  /// Creates the [ForensicGuardianScreen].
  const ForensicGuardianScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final health = ref.watch(ledgerIntegrityServiceProvider);

    return GlassScaffold(
      title: 'Forensic Guardian',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusHeader(health),
            const SizedBox(height: Spacing.lg),
            _buildIntegrityStats(health),
            const SizedBox(height: Spacing.lg),
            const Text(
              'Hash Chain Sequence',
              style: TextStyle(
                fontSize: AppTypography.titleMedium,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: Spacing.sm),
            _buildHashChainList(),
            if (health.status == IntegrityStatus.needsHeal) ...[
              const SizedBox(height: Spacing.xl),
              AppEnhancedButton(
                label: 'Execute Self-Healing Protocol',
                onPressed: () => ref
                    .read(ledgerIntegrityServiceProvider.notifier)
                    .healLedger(),
                isLoading: health.status == IntegrityStatus.needsHeal &&
                    (health.message?.contains('Healing') ?? false),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusHeader(LedgerHealth health) => GlassCard(
        child: Row(
          children: [
            Icon(
              health.status == IntegrityStatus.healthy
                  ? Icons.gpp_good
                  : health.status == IntegrityStatus.needsHeal
                      ? Icons.gpp_maybe
                      : Icons.gpp_bad,
              size: 48,
              color: health.color,
            ),
            const SizedBox(width: Spacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    health.status.toString().split('.').last.toUpperCase(),
                    style: TextStyle(
                      fontSize: AppTypography.titleLarge,
                      fontWeight: FontWeight.bold,
                      color: health.color,
                    ),
                  ),
                  Text(
                    health.message ??
                        'All systems operational. Ledger integrity verified.',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _buildIntegrityStats(LedgerHealth health) => Row(
        children: [
          Expanded(
            child: _StatTile(
              label: 'Verified Entries',
              value: health.verifiedCount.toString(),
              icon: Icons.history,
            ),
          ),
          const SizedBox(width: Spacing.md),
          Expanded(
            child: _StatTile(
              label: 'Anomalies',
              value: health.errorCount.toString(),
              icon: Icons.warning_amber,
              valueColor: health.errorCount > 0 ? AppColors.error : null,
            ),
          ),
        ],
      );

  Widget _buildHashChainList() => ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 5, // Simulated recent blocks
        itemBuilder: (context, index) => GlassCard(
          margin: const EdgeInsets.only(bottom: Spacing.sm),
          padding: const EdgeInsets.all(Spacing.sm),
          child: Row(
            children: [
              const Icon(Icons.link, color: AppColors.primary, size: 20),
              const SizedBox(width: Spacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Block #${5000 - index}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      'SHA-256: ${'a1b2c3d4'.padRight(64, '0')}',
                      style: const TextStyle(
                        fontSize: 10,
                        fontFamily: 'monospace',
                        color: AppColors.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.check_circle,
                color: AppColors.success,
                size: 16,
              ),
            ],
          ),
        ),
      );
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.icon,
    this.valueColor,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) => GlassCard(
        child: Column(
          children: [
            Icon(icon, size: 24, color: AppColors.primary),
            const SizedBox(height: Spacing.xs),
            Text(
              value,
              style: TextStyle(
                fontSize: AppTypography.titleLarge,
                fontWeight: FontWeight.bold,
                color: valueColor,
              ),
            ),
            Text(
              label,
              style:
                  const TextStyle(fontSize: 10, color: AppColors.textSecondary),
            ),
          ],
        ),
      );
}
