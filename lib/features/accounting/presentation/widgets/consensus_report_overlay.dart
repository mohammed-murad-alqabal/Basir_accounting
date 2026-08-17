import 'dart:ui';

import 'package:basir_accounting_system/core/theme/app_icons.dart';
import 'package:basir_accounting_system/core/theme/glass_theme.dart';
import 'package:basir_accounting_system/features/accounting/application/orchestrator_service.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/accounting_agent.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:basir_accounting_system/shared/widgets/glass_card.dart';
import 'package:flutter/material.dart';

/// A premium Glassmorphism overlay for visualizing multi-agent consensus.
class ConsensusReportOverlay extends StatelessWidget {
  /// Standard constructor.
  const ConsensusReportOverlay({
    required this.consensus,
    required this.onConfirm,
    required this.onCancel,
    super.key,
  });

  /// The finalized consensus report from the Orchestrator.
  final AgentConsensus consensus;

  /// Callback when the user confirms the transaction despite warnings.
  final VoidCallback onConfirm;

  /// Callback when the user cancels the transaction.
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final glassTheme = theme.extension<GlassTheme>() ??
        (theme.brightness == Brightness.dark
            ? GlassTheme.dark()
            : GlassTheme.light());
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Semi-transparent backdrop
          GestureDetector(
            onTap: onCancel,
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: glassTheme.blurSigma * 2,
                sigmaY: glassTheme.blurSigma * 2,
              ),
              child: Container(
                color: Colors.black.withValues(alpha: 0.3),
              ),
            ),
          ),

          // Main Modal content
          Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 550, maxHeight: 800),
              child: GlassCard(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context, l10n),
                    const SizedBox(height: 16),
                    Flexible(
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          ...consensus.agentResults.map(
                            (res) => _buildAgentResult(context, res, l10n),
                          ),
                          if (consensus.suggestedAdjustments != null) ...[
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Divider(color: Colors.white24, height: 1),
                            ),
                            _buildSmartAdjustments(context, l10n),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildFooter(context, l10n),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    AppLocalizations l10n,
  ) =>
      Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: consensus.isApproved ? Colors.green : Colors.red,
              shape: BoxShape.circle,
            ),
            child: Icon(
              consensus.isApproved ? AppIcons.check : AppIcons.cancel,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  consensus.isApproved
                      ? 'Consensus Approved'
                      : 'Consensus Rejected',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                ),
                Text(
                  'Cognitive Hexagon Final Audit',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white70,
                        letterSpacing: 1.2,
                      ),
                ),
              ],
            ),
          ),
        ],
      );

  Widget _buildAgentResult(
    BuildContext context,
    AgentResult result,
    AppLocalizations l10n,
  ) {
    final translatedRationale = _getTranslatedRationale(result, l10n);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                result.agentId.split('-').last.toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 12,
                  letterSpacing: 1,
                ),
              ),
              const Spacer(),
              _buildConfidenceIndicator(result.confidenceScore),
              const SizedBox(width: 8),
              Icon(
                result.isAllowed ? Icons.check_circle : Icons.error,
                color: result.isAllowed ? Colors.green : Colors.red,
                size: 16,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            translatedRationale,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmartAdjustments(BuildContext context, AppLocalizations l10n) {
    final adjustments = consensus.suggestedAdjustments!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, color: Colors.blue, size: 20),
              const SizedBox(width: 8),
              Text(
                l10n.labelAiSmartSuggestions,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...adjustments.entries.map((e) {
            final val = e.value as Map<String, dynamic>;
            final title = (val['title'] as String?) ??
                (val['suggestion'] as String?) ??
                (val['reason'] as String?) ??
                'Adjustment recommended';

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (val['reason'] != null && val['reason'] != title)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        val['reason'] as String,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  if (val['suggestedAmount'] != null ||
                      val['suggestedCategory'] != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        '${l10n.labelTarget} '
                        '${val['suggestedAmount'] ?? val['suggestedCategory']}',
                        style: TextStyle(
                          color: Colors.blue.shade100,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildConfidenceIndicator(double score) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          '${(score * 100).toInt()}% CONFIDENCE',
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

  Widget _buildFooter(BuildContext context, AppLocalizations l10n) => Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: onCancel,
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.white.withAlpha(150)),
              ),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: onConfirm,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  consensus.isApproved ? Colors.green : Colors.orange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              consensus.isApproved ? 'Post Transaction' : 'Override & Post',
            ),
          ),
        ],
      );

  String _getTranslatedRationale(AgentResult result, AppLocalizations l10n) {
    switch (result.rationale) {
      case 'agentRationaleForensicBalanced':
        return l10n.agentRationaleForensicBalanced;
      case 'agentRationaleForensicUnbalanced':
        return l10n.agentRationaleForensicUnbalanced;
      case 'agentRationaleForensicHighValue':
        return l10n.agentRationaleForensicHighValue('100,000');
      case 'agentRationaleForensicDuplicate':
        return l10n.agentRationaleForensicDuplicate('REF-001');
      default:
        return result.rationale;
    }
  }
}
