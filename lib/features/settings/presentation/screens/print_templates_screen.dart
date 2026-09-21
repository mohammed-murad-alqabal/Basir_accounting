// ignore_for_file: prefer_const_literals_to_create_immutables
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unused_local_variable
// ignore_for_file: inference_failure_on_function_invocation
// ignore_for_file: discarded_futures
// ignore_for_file: deprecated_member_use
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/features/settings/application/print_settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PrintTemplatesScreen extends ConsumerWidget {
  const PrintTemplatesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(printSettingsNotifierProvider);
    final settingsNotifier = ref.read(printSettingsNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('قوالب الطباعة'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(Spacing.lg),
        children: [
          _buildSectionHeader('قوالب A4'),
          _buildTemplateOption(
            0,
            settings.a4Template,
            (val) => settingsNotifier.updateSettings(settings.copyWith(a4Template: val)),
            'نموذج A4 1',
            Icons.description,
          ),
          _buildTemplateOption(
            1,
            settings.a4Template,
            (val) => settingsNotifier.updateSettings(settings.copyWith(a4Template: val)),
            'نموذج A4 2 (طولي)',
            Icons.text_snippet,
          ),

          const Divider(height: Spacing.xl),
          _buildSectionHeader('قوالب الطباعة الحرارية (Bluetooth)'),
          _buildTemplateOption(
            0,
            settings.bluetoothTemplate,
            (val) => settingsNotifier.updateSettings(settings.copyWith(bluetoothTemplate: val)),
            'رول حراري عريض 80mm',
            Icons.receipt_long,
          ),
          _buildTemplateOption(
            1,
            settings.bluetoothTemplate,
            (val) => settingsNotifier.updateSettings(settings.copyWith(bluetoothTemplate: val)),
            'رول حراري صغير 58mm',
            Icons.receipt,
          ),

          const Divider(height: Spacing.xl),
          _buildSectionHeader('قالب كشف الحساب'),
          _buildTemplateOption(
            0,
            settings.statementTemplate,
            (val) => settingsNotifier.updateSettings(settings.copyWith(statementTemplate: val)),
            'كشف حساب تفصيلي',
            Icons.list_alt,
          ),
          _buildTemplateOption(
            1,
            settings.statementTemplate,
            (val) => settingsNotifier.updateSettings(settings.copyWith(statementTemplate: val)),
            'كشف حساب مبسط',
            Icons.fact_check,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) => Padding(
    padding: const EdgeInsets.only(bottom: Spacing.md),
    child: Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
    ),
  );

  Widget _buildTemplateOption(
    int index,
    int groupValue,
    ValueChanged<int?> onChanged,
    String placeholderText,
    IconData icon,
  ) {
    final isSelected = index == groupValue;
    return Card(
      margin: const EdgeInsets.only(bottom: Spacing.md),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Spacing.sm),
        side: BorderSide(color: isSelected ? AppColors.primary : Colors.transparent, width: 2),
      ),
      child: InkWell(
        onTap: () => onChanged(index),
        borderRadius: BorderRadius.circular(Spacing.sm),
        child: Padding(
          padding: const EdgeInsets.all(Spacing.sm),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(Spacing.xs),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, size: 48, color: isSelected ? AppColors.primary : Colors.grey),
                      const SizedBox(height: Spacing.xs),
                      Text(
                        placeholderText,
                        style: TextStyle(
                          color: isSelected ? AppColors.primary : Colors.grey,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: Spacing.md),
              Radio<int>(
                value: index,
                groupValue: groupValue,
                onChanged: onChanged,
                activeColor: AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
