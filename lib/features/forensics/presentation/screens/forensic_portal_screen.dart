import 'package:basir_accounting_system/core/extensions/context_extensions.dart';
import 'package:basir_accounting_system/features/forensics/application/forensic_portal_service.dart';
import 'package:basir_accounting_system/features/forensics/domain/entities/integrity_pulse.dart';
import 'package:basir_accounting_system/shared/widgets/glass_card.dart';
import 'package:basir_accounting_system/shared/widgets/glass_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

/// Screen that displays the forensic integrity pulse and hash chain timeline.
class ForensicPortalScreen extends ConsumerWidget {
  /// Creates a [ForensicPortalScreen].
  const ForensicPortalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pulseAsync = ref.watch(forensicPortalNotifierProvider);
    final blocksAsync = ref.watch(ledgerBlocksProvider);

    return GlassScaffold(
      title: context.l10n.titleForensicPortal,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildIntegrityPulse(context, pulseAsync),
            const SizedBox(height: 16),
            _buildAdministrativeControls(context),
            const SizedBox(height: 24),
            _buildLedgerTimeline(context, blocksAsync),
          ],
        ),
      ),
    );
  }

  Widget _buildIntegrityPulse(
    BuildContext context,
    AsyncValue<IntegrityPulse> pulseAsync,
  ) =>
      pulseAsync.when(
        data: (pulse) => GlassCard(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      pulse.isHealthy
                          ? Icons.verified_user
                          : Icons.warning_amber,
                      color: pulse.isHealthy
                          ? Colors.greenAccent
                          : Colors.orangeAccent,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      context.l10n.labelIntegrityPulse,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                    ),
                    const Spacer(),
                    _buildHealthBadge(pulse.healthPercentage),
                  ],
                ),
                const SizedBox(height: 20),
                _buildPulseInfoRow(
                  context,
                  context.l10n.labelLastVerified,
                  DateFormat.yMMMd().add_Hms().format(pulse.lastVerifiedAt),
                ),
                _buildPulseInfoRow(
                  context,
                  context.l10n.labelBlocksScanned,
                  pulse.totalBlocksScanned.toString(),
                ),
                const SizedBox(height: 12),
                const Divider(color: Colors.white24),
                const SizedBox(height: 12),
                Text(
                  'HASH: ${pulse.lastVerifiedHash}',
                  style: const TextStyle(
                    fontFamily: 'JetBrains Mono',
                    fontSize: 12,
                    color: Colors.blueAccent,
                  ),
                ),
              ],
            ),
          ),
        ),
        loading: () => const GlassCard(
          child: SizedBox(
            height: 150,
            child: Center(child: CircularProgressIndicator()),
          ),
        ),
        error: (e, _) => GlassCard(child: Center(child: Text('Error: $e'))),
      );

  Widget _buildHealthBadge(double percentage) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.greenAccent.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.greenAccent.withValues(alpha: 0.5)),
        ),
        child: Text(
          '${percentage.toStringAsFixed(1)}%',
          style: const TextStyle(
            color: Colors.greenAccent,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      );

  Widget _buildPulseInfoRow(BuildContext context, String label, String value) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );

  Widget _buildLedgerTimeline(
    BuildContext context,
    AsyncValue<List<LedgerBlock>> blocksAsync,
  ) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              context.l10n.labelLedgerMutationTimeline,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
            ),
          ),
          const SizedBox(height: 16),
          blocksAsync.when(
            data: (blocks) => ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: blocks.length,
              itemBuilder: (context, index) {
                final block = blocks[index];
                return _buildBlockItem(
                  context,
                  block,
                  index == blocks.length - 1,
                );
              },
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
          ),
        ],
      );

  Widget _buildBlockItem(
    BuildContext context,
    LedgerBlock block,
    bool isLast,
  ) =>
      IntrinsicHeight(
        child: Row(
          children: [
            Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: Colors.blueAccent,
                    shape: BoxShape.circle,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: Colors.white24,
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: GlassCard(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '#${block.referenceNumber}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              DateFormat.yMMMd().format(block.date),
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${context.l10n.labelVerifiedBy} '
                          '${block.agentSignature}',
                          style: const TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Divider(color: Colors.white12),
                        const SizedBox(height: 8),
                        _buildHashRow('HASH', block.hash ?? 'N/A'),
                        const SizedBox(height: 4),
                        _buildHashRow(
                          'PREV',
                          block.previousHash ?? '0x00000000',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  Widget _buildAdministrativeControls(BuildContext context) => GlassCard(
        child: InkWell(
          onTap: () => Navigator.pushNamed(context, '/fiscal-control-center'),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(
                  Icons.settings_suggest,
                  color: Colors.orangeAccent,
                  size: 32,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Fiscal Cycle Management',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Lock periods and manage year-end rollovers.',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: Colors.white54,
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildHashRow(String label, String value) => Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontFamily: 'JetBrains Mono',
                fontSize: 11,
                color: Colors.white70,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      );
}
