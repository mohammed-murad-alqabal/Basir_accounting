import 'package:basir_accounting_system/core/extensions/context_extensions.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 💎 شاشة إعدادات الطباعة (Print Settings Screen Platinum)
/// واجهة متطورة للتحكم في قوالب الطباعة وأحجام الورق
class PrintSettingsScreen extends ConsumerStatefulWidget {
  /// إنشاء شاشة إعدادات الطباعة
  const PrintSettingsScreen({super.key});

  @override
  ConsumerState<PrintSettingsScreen> createState() =>
      _PrintSettingsScreenState();
}

class _PrintSettingsScreenState extends ConsumerState<PrintSettingsScreen> {
  String _selectedSize = '80mm';
  String _selectedTemplate = 'A4';
  double _fontSize = 20;
  int _paddingBottom = 7;
  int _printCopies = 1;
  bool _showUnit = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return GlassScaffold(
      title: l10n.printSettingsTitle,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📝 اختيار القالب
            _buildSectionHeader(
              l10n.templateSelection,
              Icons.dashboard_customize_outlined,
            ),
            GlassCard(
              child: Column(
                children: [
                  _buildRadioTile(
                    'A4 Invoice',
                    'A4',
                    _selectedTemplate,
                    (val) => setState(() => _selectedTemplate = val!),
                  ),
                  const Divider(height: 1),
                  _buildRadioTile(
                    'Bluetooth Receipt (Thermal)',
                    'Bluetooth',
                    _selectedTemplate,
                    (val) => setState(() => _selectedTemplate = val!),
                  ),
                  const Divider(height: 1),
                  _buildRadioTile(
                    'Account Statement',
                    'Statement',
                    _selectedTemplate,
                    (val) => setState(() => _selectedTemplate = val!),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Spacing.xl),

            // 📏 حجم الورق والقياسات
            _buildSectionHeader(l10n.paperSize, Icons.straighten_outlined),
            GlassCard(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildRadioTile(
                          '58 mm',
                          '58mm',
                          _selectedSize,
                          (val) => setState(() => _selectedSize = val!),
                        ),
                      ),
                      Expanded(
                        child: _buildRadioTile(
                          '80 mm',
                          '80mm',
                          _selectedSize,
                          (val) => setState(() => _selectedSize = val!),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(Spacing.md),
                    child: Column(
                      children: [
                        _buildSlider(
                          l10n.fontSize,
                          _fontSize,
                          10,
                          30,
                          (val) => setState(() => _fontSize = val),
                        ),
                        const SizedBox(height: Spacing.md),
                        _buildCounter(
                          l10n.paddingBottom,
                          _paddingBottom,
                          (val) => setState(() => _paddingBottom = val),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Spacing.xl),

            // ⚙️ خيارات إضافية
            _buildSectionHeader(
              l10n.settingsTitle,
              Icons.settings_applications_outlined,
            ),
            GlassCard(
              child: Column(
                children: [
                  _buildCounter(
                    l10n.printCopies,
                    _printCopies,
                    (val) => setState(() => _printCopies = val),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: Text(l10n.printItemUnit),
                    secondary: Icon(
                      Icons.unarchive_outlined,
                      color: theme.colorScheme.primary,
                    ),
                    value: _showUnit,
                    onChanged: (val) => setState(() => _showUnit = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Spacing.xxl),

            // 💾 زر الحفظ
            AppEnhancedButton(
              label: l10n.saveSettings,
              icon: Icons.save_outlined,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      l10n.msgExportComingSoon,
                    ),
                  ), // Placeholder for save logic
                );
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

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

  Widget _buildRadioTile(
    String title,
    String value,
    String groupValue,
    ValueChanged<String?> onChanged,
  ) =>
      RadioListTile<String>(
        title: Text(title),
        value: value,
        groupValue: groupValue,
        onChanged: onChanged,
        activeColor: Theme.of(context).colorScheme.primary,
      );

  Widget _buildSlider(
    String label,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged,
  ) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label),
              Text(
                value.toInt().toString(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: (max - min).toInt(),
            onChanged: onChanged,
          ),
        ],
      );

  Widget _buildCounter(String label, int value, ValueChanged<int> onChanged) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: Spacing.xs),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Row(
              children: [
                IconButton(
                  onPressed: () => onChanged(value > 0 ? value - 1 : 0),
                  icon: const Icon(Icons.remove_circle_outline),
                ),
                Text(
                  value.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                IconButton(
                  onPressed: () => onChanged(value + 1),
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ],
            ),
          ],
        ),
      );
}
