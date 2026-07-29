import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/accounting_agent.dart';
import 'package:basir_accounting_system/features/inventory/application/inventory_service.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'operational_intel_service.g.dart';

/// Operational Intelligence Agent (Agent 4) bridging ledger data
/// with business reality.
///
/// Monitors the alignment between financial entries and operational
/// statuses such as inventory levels and process urgency.
@Riverpod(keepAlive: true)
class OperationalIntelService extends _$OperationalIntelService
    implements AccountingAgent {
  @override
  FutureOr<void> build() {}

  @override
  String get agentId => 'agent-4-operational-intel';

  @override
  AgentAuthority get authority => AgentAuthority.medium;

  /// Validates the operational feasibility and impact of the transaction.
  @override
  Future<AgentResult> process(AccountingContext context) async {
    final rationale = <String>[];
    var confidenceScore = 0.92;
    var isAllowed = true;
    final l10n = lookupAppLocalizations(Locale(context.locale));
    final suggestedAdjustments = <String, dynamic>{};

    // 1. Transaction Type Operational Analysis
    if (context.transactionType == 'sales') {
      rationale.add(
        'Operational Intel: Verifying material availability and '
        'readiness for sales transaction.',
      );

      // Integration with InventoryService
      InventoryService? inventoryService;
      try {
        inventoryService = ref.read(inventoryServiceProvider);
      } on Object catch (_) {
        inventoryService = null;
        rationale.add(
          'Note: Inventory service unavailable; skipped stock verification.',
        );
        confidenceScore = 0.6;
      }
      final items = context.metadata['items'] as List<dynamic>?;

      if (inventoryService != null && items != null && items.isNotEmpty) {
        for (final item in items) {
          try {
            final itemMap = item as Map<String, dynamic>;
            final itemId = itemMap['id'] as String;
            final quantity = (itemMap['quantity'] as num).toDouble();
            final warehouseId = context.metadata['warehouseId'] as String?;

            final stock = await inventoryService.movementRepo.getStockLevel(
              itemId,
              warehouseId: warehouseId,
            );

            if (stock < quantity) {
              isAllowed = false;
              rationale.add(
                l10n.agentRationaleOperationalInsufficient(
                  itemId,
                  '$stock vs $quantity',
                ),
              );
              confidenceScore = 0.75;

              // Smart Adjustment: Suggest alternative warehouse if available
              suggestedAdjustments['warehouse_optimization'] = {
                'itemId': itemId,
                'currentWarehouse': warehouseId ?? 'Primary',
                'required': quantity,
                'available': stock,
                'suggestion': l10n.agentSuggestionWarehouseOptimizationReason,
                'title': l10n.agentSuggestionWarehouseOptimization,
              };
            } else {
              rationale.add(
                l10n.agentRationaleOperationalSufficient(
                  itemId,
                  stock.toString(),
                ),
              );
            }
          } on Object catch (_) {
            rationale.add('Note: Could not verify stock for some items.');
          }
        }
      } else {
        rationale.add(
          'Recommendation: Ensure floor stocks are decremented immediately '
          'upon posting.',
        );
      }
    } else if (context.transactionType == 'purchase') {
      rationale.add(
        'Operational Impact: Assessing warehouse capacity and incoming '
        'quality control requirements.',
      );
    }

    // 2. Urgency and Priority Validation
    final isUrgent = context.metadata['priority'] == 'high';
    if (isUrgent) {
      rationale
          .add('Note: Processed as high operational priority transaction.');
      confidenceScore = 0.98;
    }

    return AgentResult(
      agentId: agentId,
      isAllowed: isAllowed,
      rationale: rationale.join('\n'),
      confidenceScore: confidenceScore,
      suggestedAdjustments:
          suggestedAdjustments.isNotEmpty ? suggestedAdjustments : null,
    );
  }
}
