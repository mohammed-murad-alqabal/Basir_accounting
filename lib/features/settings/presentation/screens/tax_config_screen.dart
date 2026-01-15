import 'package:basir_accounting_system/core/extensions/context_extensions.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 💎 شاشة تكوين الضرائب (Tax Configuration Screen Platinum)
/// واجهة متطورة للتحكم في الضرائب والفوترة الإلكترونية (ZATCA)
class TaxConfigScreen extends ConsumerStatefulWidget {
  /// إنشاء شاشة تكوين الضرائب
  const TaxConfigScreen({super.key});

  @override
  ConsumerState<TaxConfigScreen> createState() => _TaxConfigScreenState();
}

class _TaxConfigScreenState extends ConsumerState<TaxConfigScreen> {
  bool _enableTax = true;
  bool _priceIncludesTax = false;
  final _vatNumberController = TextEditingController(text: '300000000000003');
  final _defaultTaxController = TextEditingController(text: '15');
  final _b2cLabelController =
      TextEditingController(text: 'Simplified Tax Invoice');
  final _b2bLabelController = TextEditingController(text: 'Tax Invoice');

  @override
  void dispose() {
    _vatNumberController.dispose();
    _defaultTaxController.dispose();
    _b2cLabelController.dispose();
    _b2bLabelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return GlassScaffold(
      title: l10n.taxConfigTitle,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🕋 تنبيه زاتكا
            _buildZatcaAlert(),
            const SizedBox(height: Spacing.xl),

            // ⚙️ إعدادات الضريبة الأساسية
            _buildSectionHeader(
              l10n.settingsTitle,
              Icons.receipt_long_outlined,
            ),
            GlassCard(
              child: Column(
                children: [
                  SwitchListTile(
                    title: Text(l10n.enableTax),
                    value: _enableTax,
                    onChanged: (val) => setState(() => _enableTax = val),
                    secondary: Icon(
                      Icons.check_circle_outline,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: Text(l10n.priceIncludesTax),
                    value: _priceIncludesTax,
                    onChanged: (val) => setState(() => _priceIncludesTax = val),
                    secondary: Icon(
                      Icons.monetization_on_outlined,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(Spacing.md),
                    child: AppTextField(
                      label: l10n.vatNumber,
                      controller: _vatNumberController,
                      prefixIcon: const Icon(Icons.fingerprint),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.md,
                      vertical: Spacing.sm,
                    ),
                    child: AppTextField(
                      label: l10n.defaultTaxRate,
                      controller: _defaultTaxController,
                      prefixIcon: const Icon(Icons.percent),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Spacing.xl),

            // 🏷️ تسميات الفواتير
            _buildSectionHeader(l10n.saveLabels, Icons.label_important_outline),
            GlassCard(
              child: Padding(
                padding: const EdgeInsets.all(Spacing.md),
                child: Column(
                  children: [
                    AppTextField(
                      label: l10n.b2cSimplifiedLabel,
                      controller: _b2cLabelController,
                      prefixIcon: const Icon(Icons.person_outline),
                    ),
                    const SizedBox(height: Spacing.md),
                    AppTextField(
                      label: l10n.b2bStandardLabel,
                      controller: _b2bLabelController,
                      prefixIcon: const Icon(Icons.business_outlined),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: Spacing.xxl),

            // 💾 زر الحفظ
            AppEnhancedButton(
              label: l10n.saveSettings,
              icon: Icons.save_outlined,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.msgOperationSuccess)),
                );
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildZatcaAlert() => Container(
        padding: const EdgeInsets.all(Spacing.md),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.1),
          borderRadius: BorderRadius.circular(Spacing.md),
          border: Border.all(color: Colors.green.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.verified_user_outlined, color: Colors.green),
            const SizedBox(width: Spacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.zatcaPhase2Title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: Spacing.xs),
                  Text(
                    context.l10n.zatcaPhase2Description,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _buildSectionHeader(String title, IconData icon) => Padding(
        padding: const EdgeInsets.only(bottom: Spacing.sm, left: Spacing.xs),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: Spacing.sm),
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
}
