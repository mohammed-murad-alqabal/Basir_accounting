import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// شاشة تسوية النقدية (Cash Reconciliation Screen)
/// تتيح للمستخدم مطابقة الرصيد الدفتري مع الرصيد الفعلي في الصندوق.
/// (Phase 9 - Institutional Deepening - ATLAS Image 011)
/// شاشة تسوية النقدية (Cash Reconciliation Screen)
/// Screen for performing manual cash reconciliation.
class CashReconciliationScreen extends ConsumerStatefulWidget {
  /// Creates a [CashReconciliationScreen].
  const CashReconciliationScreen({super.key});

  @override
  ConsumerState<CashReconciliationScreen> createState() =>
      _CashReconciliationScreenState();
}

class _CashReconciliationScreenState
    extends ConsumerState<CashReconciliationScreen> {
  final _manualCountController = TextEditingController();

  @override
  void dispose() {
    _manualCountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => GlassScaffold(
        title: 'تسوية النقدية',
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(Spacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GlassCard(
                child: Column(
                  children: [
                    _buildReconciliationRow(
                      context,
                      label: 'الرصيد الدفتري الحالي',
                      value: '12,500.00 ر.س',
                      color: AppColors.primary,
                    ),
                    const Divider(height: 32),
                    _buildManualEntryField(context),
                    const Divider(height: 32),
                    _buildReconciliationRow(
                      context,
                      label: 'الفارق (عجز/زيادة)',
                      value: '0.00 ر.س',
                      color: AppColors.success,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Spacing.xl),
              AppEnhancedButton(
                label: 'اعتماد التسوية',
                onPressed: () {
                  // Logic to post reconciliation journal entry
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('تم اعتماد تسوية النقدية بنجاح'),
                    ),
                  );
                },
                icon: Icons.check_circle_outline,
              ),
            ],
          ),
        ),
      );

  Widget _buildReconciliationRow(
    BuildContext context, {
    required String label,
    required String value,
    required Color color,
  }) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      );

  Widget _buildManualEntryField(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'الرصيد الفعلي (العد النقدي)',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          TextField(
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              hintText: '0.00',
              suffixText: 'ر.س',
              filled: true,
              fillColor: Colors.black.withValues(alpha: 0.05),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Radii.md),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (val) {
              setState(() {
                // Update difference calculation
              });
            },
          ),
        ],
      );
}
