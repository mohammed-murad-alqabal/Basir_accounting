import 'package:basir_accounting_system/core/extensions/context_extensions.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/accounting_agent.dart';
import 'package:flutter/material.dart';

/// A widget that visualizes the "Cognitive Hexagon" multi-agent consensus.
/// Displays individual agent scores and their rationale.
class ConsensusVisualizationWidget extends StatelessWidget {
  /// Creates a [ConsensusVisualizationWidget].
  const ConsensusVisualizationWidget({
    required this.agentResults,
    required this.isConsensusAchieved,
    super.key,
  });

  /// The collection of agent results that form the consensus.
  final List<AgentResult> agentResults;

  /// Whether consensus was achieved.
  final bool isConsensusAchieved;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryHeader(context),
          const SizedBox(height: 16),
          ...agentResults.map((agent) => _buildAgentTile(context, agent)),
        ],
      );

  Widget _buildSummaryHeader(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isConsensusAchieved
              ? Colors.green.withValues(alpha: 0.1)
              : Colors.orange.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isConsensusAchieved
                ? Colors.green.withValues(alpha: 0.3)
                : Colors.orange.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isConsensusAchieved ? Icons.verified : Icons.warning_amber,
              size: 16,
              color: isConsensusAchieved ? Colors.green : Colors.orange,
            ),
            const SizedBox(width: 8),
            Text(
              isConsensusAchieved
                  ? 'Consensus Achieved'
                  : 'Bypass Active / Partial Consensus',
              style: context.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isConsensusAchieved
                    ? Colors.green[800]
                    : Colors.orange[800],
              ),
            ),
          ],
        ),
      );

  Widget _buildAgentTile(BuildContext context, AgentResult agent) {
    final isAllowed = agent.isAllowed;
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _getAgentIcon(agent.agentId),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getAgentName(agent.agentId),
                        style: context.textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Confidence: ${(agent.confidenceScore * 100).toInt()}%',
                        style: context.textTheme.labelSmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  isAllowed ? Icons.check_circle : Icons.cancel,
                  color: isAllowed ? Colors.green : Colors.red,
                  size: 20,
                ),
              ],
            ),
            if (agent.rationale.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                agent.rationale,
                style: context.textTheme.bodySmall
                    ?.copyWith(fontStyle: FontStyle.italic),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _getAgentIcon(String agentId) {
    IconData iconData;
    Color color;
    switch (agentId) {
      case 'agent_standards':
        iconData = Icons.gavel;
        color = Colors.blue;
      case 'agent_forensic':
        iconData = Icons.security;
        color = Colors.red;
      case 'agent_tax':
        iconData = Icons.account_balance;
        color = Colors.green;
      case 'agent_strategy':
        iconData = Icons.trending_up;
        color = Colors.purple;
      case 'agent_ops':
        iconData = Icons.inventory_2;
        color = Colors.orange;
      case 'agent_sustainability':
        iconData = Icons.eco;
        color = Colors.teal;
      default:
        iconData = Icons.smart_toy;
        color = Colors.grey;
    }
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(iconData, size: 16, color: color),
    );
  }

  String _getAgentName(String agentId) {
    switch (agentId) {
      case 'agent_standards':
        return 'Standards Engine';
      case 'agent_forensic':
        return 'Forensic Auditor';
      case 'agent_tax':
        return 'Tax Compliance';
      case 'agent_strategy':
        return 'Financial Strategy';
      case 'agent_ops':
        return 'Operational Intel';
      case 'agent_sustainability':
        return 'Sustainability Expert';
      default:
        return 'Cognitive Agent';
    }
  }
}
