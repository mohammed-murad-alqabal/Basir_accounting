// ignore_for_file: prefer_const_literals_to_create_immutables
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unused_local_variable
// ignore_for_file: inference_failure_on_function_invocation
// ignore_for_file: discarded_futures
// ignore_for_file: deprecated_member_use
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/features/settings/application/print_settings_provider.dart';
import 'package:basir_accounting_system/features/settings/domain/entities/print_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThermalPrintSettingsScreen extends ConsumerStatefulWidget {
  const ThermalPrintSettingsScreen({super.key});

  @override
  ConsumerState<ThermalPrintSettingsScreen> createState() => _ThermalPrintSettingsScreenState();
}

class _ThermalPrintSettingsScreenState extends ConsumerState<ThermalPrintSettingsScreen> {
  late PrintSettings _tempSettings;
  late TextEditingController _customSizeController;
  late TextEditingController _fontSizeController;
  late TextEditingController _blankLinesController;

  @override
  void initState() {
    super.initState();
    _tempSettings = ref.read(printSettingsNotifierProvider);
    _customSizeController = TextEditingController(text: _tempSettings.customPaperSize.toString());
    _fontSizeController = TextEditingController(text: _tempSettings.fontSize.toString());
    _blankLinesController = TextEditingController(text: _tempSettings.paddingBottom.toString());
  }

  @override
  void dispose() {
    _customSizeController.dispose();
    _fontSizeController.dispose();
    _blankLinesController.dispose();
    super.dispose();
  }

  void _saveSettings() {
    final updated = _tempSettings.copyWith(
      customPaperSize: int.tryParse(_customSizeController.text) ?? 375,
      fontSize: double.tryParse(_fontSizeController.text) ?? 20.0,
      paddingBottom: int.tryParse(_blankLinesController.text) ?? 7,
    );

    ref.read(printSettingsNotifierProvider.notifier).updateSettings(updated);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم حفظ الإعدادات')));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('إعدادات الطباعة الحرارية'), centerTitle: true),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(Spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Radio<String>(
                value: '58mm',
                groupValue: _tempSettings.paperSize,
                onChanged: (val) =>
                    setState(() => _tempSettings = _tempSettings.copyWith(paperSize: val)),
                activeColor: AppColors.primary,
              ),
              const Text('قياس 58 mm'),
              const SizedBox(width: Spacing.md),
              Radio<String>(
                value: '80mm',
                groupValue: _tempSettings.paperSize,
                onChanged: (val) =>
                    setState(() => _tempSettings = _tempSettings.copyWith(paperSize: val)),
                activeColor: AppColors.primary,
              ),
              const Text('قياس 80 mm'),
            ],
          ),
          const SizedBox(height: Spacing.md),
          _buildNumberField('قياسات ورق أخرى', _customSizeController),
          const SizedBox(height: Spacing.md),
          _buildNumberField('حجم الخط', _fontSizeController),
          const SizedBox(height: Spacing.md),
          _buildNumberField('اسطر فراغ اخر الورقة', _blankLinesController),
          const SizedBox(height: Spacing.md),
          CheckboxListTile(
            title: const Text('طباعة نسختين', style: TextStyle(fontWeight: FontWeight.bold)),
            value: _tempSettings.printTwoCopies,
            onChanged: (val) =>
                setState(() => _tempSettings = _tempSettings.copyWith(printTwoCopies: val)),
            controlAffinity: ListTileControlAffinity.trailing,
            activeColor: AppColors.primary,
          ),
          CheckboxListTile(
            title: const Text('طباعة وحدة المادة', style: TextStyle(fontWeight: FontWeight.bold)),
            value: _tempSettings.showUnit,
            onChanged: (val) =>
                setState(() => _tempSettings = _tempSettings.copyWith(showUnit: val)),
            controlAffinity: ListTileControlAffinity.trailing,
            activeColor: AppColors.primary,
          ),
          const SizedBox(height: Spacing.md),
          const Text(
            'نوع الخط',
            textAlign: TextAlign.right,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          RadioListTile<String>(
            title: const Text('بصير المحاسبي (خط 1)'),
            value: '1',
            groupValue: _tempSettings.fontType,
            onChanged: (val) =>
                setState(() => _tempSettings = _tempSettings.copyWith(fontType: val)),
            controlAffinity: ListTileControlAffinity.trailing,
            activeColor: AppColors.primary,
          ),
          RadioListTile<String>(
            title: const Text('بصير المحاسبي (خط 2)'),
            value: '2',
            groupValue: _tempSettings.fontType,
            onChanged: (val) =>
                setState(() => _tempSettings = _tempSettings.copyWith(fontType: val)),
            controlAffinity: ListTileControlAffinity.trailing,
            activeColor: AppColors.primary,
          ),
          const SizedBox(height: Spacing.xl),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: _saveSettings,
            child: const Text('حفظ الإعدادات', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    ),
  );

  Widget _buildNumberField(String label, TextEditingController controller) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(
        width: 80,
        child: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          decoration: const InputDecoration(isDense: true),
        ),
      ),
    ],
  );
}
