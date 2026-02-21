import 'package:basir_accounting_system/core/extensions/context_extensions.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// شاشة المرتجعات والتوالف (Returns and Damages Screen)
/// نقطة وصول مركزية لمرتجعات المبيعات والمشتريات وتوالف المخزون.
/// (Phase 9 - Institutional Deepening - Atlas Image 010)
/// Screen for returns and damages operations.
class ReturnsAndDamagesScreen extends ConsumerWidget {
  /// Creates a [ReturnsAndDamagesScreen].
  const ReturnsAndDamagesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => GlassScaffold(
        title: context.l10n.labelReturnsAndDamages,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(Spacing.lg),
          child: Column(
            children: [
              _buildOptionCard(
                context,
                title: context.l10n.labelSalesReturn,
                subtitle: context.l10n.descSalesReturn,
                icon: Icons.assignment_return_outlined,
                color: AppColors.primary,
                onTap: () => Navigator.of(context).pushNamed(
                  '/invoice-form',
                  arguments: {'type': 'sales_return'},
                ),
              ),
              const SizedBox(height: Spacing.md),
              _buildOptionCard(
                context,
                title: context.l10n.labelPurchaseReturn,
                subtitle: context.l10n.descPurchaseReturn,
                icon: Icons.keyboard_return_outlined,
                color: AppColors.secondary,
                onTap: () => Navigator.of(context).pushNamed(
                  '/invoice-form',
                  arguments: {'type': 'purchase_return'},
                ),
              ),
              const SizedBox(height: Spacing.md),
              _buildOptionCard(
                context,
                title: context.l10n.labelDamageInvoice,
                subtitle: context.l10n.descDamageInvoice,
                icon: Icons.local_fire_department_outlined,
                color: AppColors.error,
                onTap: () => Navigator.of(context)
                    .pushNamed('/invoice-form', arguments: {'type': 'damage'}),
              ),
            ],
          ),
        ),
      );

  Widget _buildOptionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) =>
      GlassCard(
        onTap: onTap,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(Spacing.md),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(Radii.md),
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(width: Spacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      );
}
