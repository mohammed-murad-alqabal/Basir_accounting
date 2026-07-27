import 'dart:async';

import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/features/settings/domain/entities/barcode_config.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// شاشة إعدادات محرك الباركود لتكوين قياسات الملصقات والطابعات (FORENSIC 098).
class BarcodeSettingsScreen extends ConsumerStatefulWidget {
  /// Creates the [BarcodeSettingsScreen].
  const BarcodeSettingsScreen({super.key});

  @override
  ConsumerState<BarcodeSettingsScreen> createState() => _BarcodeSettingsScreenState();
}

class _BarcodeSettingsScreenState extends ConsumerState<BarcodeSettingsScreen> {
  PrinterType _printerType = PrinterType.thermal;
  double _height = 30;
  double _width = 50;
  double _margin = 2;
  int _columnsPerRow = 1;
  bool _showItemName = true;
  bool _showPrice = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    unawaited(_loadConfig());
  }

  Future<void> _loadConfig() async {
    final repo = ref.read(barcodeConfigRepositoryProvider);
    final config = await repo.getConfig();
    if (mounted) {
      setState(() {
        _printerType = config.printerType;
        _height = config.height;
        _width = config.width;
        _margin = config.margin;
        _columnsPerRow = config.columnsPerRow;
        _showItemName = config.showItemName;
        _showPrice = config.showPrice;
        _isLoading = false;
      });
    }
  }

  Future<void> _saveConfig() async {
    final repo = ref.read(barcodeConfigRepositoryProvider);
    final config = BarcodeConfig(
      printerType: _printerType,
      height: _height,
      width: _width,
      margin: _margin,
      columnsPerRow: _columnsPerRow,
      showItemName: _showItemName,
      showPrice: _showPrice,
    );
    await repo.saveConfig(config);
    if (mounted) {
      Navigator.pop(context);
    }
  }

  void _resetToDefault() {
    setState(() {
      _height = 30.0;
      _width = 50.0;
      _margin = 2.0;
      _columnsPerRow = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GlassScaffold(
      title: 'إعدادات محرك الباركود',
      actions: [
        TextButton(
          onPressed: _isLoading ? null : _saveConfig,
          child: const Text('حفظ'),
        ),
      ],
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(Spacing.lg),
              children: [
                _buildHeaderSection(theme),
                const SizedBox(height: Spacing.xl),
                _buildTypeSelector(theme),
                const Divider(height: Spacing.xxl),
                _buildDimensionSettings(theme),
                const Divider(height: Spacing.xxl),
                _buildPreferenceSettings(theme),
                const SizedBox(height: Spacing.xxl),
                OutlinedButton.icon(
                  onPressed: _resetToDefault,
                  icon: const Icon(Icons.restore),
                  label: const Text('استعادة الإعدادات الافتراضية'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(Spacing.md),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildHeaderSection(ThemeData theme) => Column(
        children: [
          Icon(
            Icons.settings_overscan,
            size: 48,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: Spacing.md),
          const Text(
            'تكوين قياسات وتنسيق ملصقات الباركود',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      );

  Widget _buildTypeSelector(ThemeData theme) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'نوع الطابعة والورق',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: Spacing.md),
          Row(
            children: [
              Expanded(
                child: ChoiceChip(
                  label: const Text('طابعة حرارية'),
                  selected: _printerType == PrinterType.thermal,
                  onSelected: (val) => setState(() => _printerType = PrinterType.thermal),
                ),
              ),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: ChoiceChip(
                  label: const Text('ورق A4 عادى'),
                  selected: _printerType == PrinterType.a4,
                  onSelected: (val) => setState(() => _printerType = PrinterType.a4),
                ),
              ),
            ],
          ),
        ],
      );

  Widget _buildDimensionSettings(ThemeData theme) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'أبعاد الملصق (ملم)',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: Spacing.md),
          _buildSliderSetting(
            'العرض',
            _width,
            10,
            100,
            (v) => setState(() => _width = v),
          ),
          _buildSliderSetting(
            'الطول',
            _height,
            10,
            100,
            (v) => setState(() => _height = v),
          ),
          _buildSliderSetting(
            'الهامش',
            _margin,
            0,
            10,
            (v) => setState(() => _margin = v),
          ),
          if (_printerType == PrinterType.a4)
            _buildSliderSetting(
              'أعمدة في الصف',
              _columnsPerRow.toDouble(),
              1,
              5,
              (v) => setState(() => _columnsPerRow = v.toInt()),
              isDiscrete: true,
            ),
        ],
      );

  Widget _buildPreferenceSettings(ThemeData theme) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'خيارات العرض',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SwitchListTile(
            title: const Text('إظهار اسم الصنف'),
            value: _showItemName,
            onChanged: (val) => setState(() => _showItemName = val),
          ),
          SwitchListTile(
            title: const Text('إظهار سعر البيع'),
            value: _showPrice,
            onChanged: (val) => setState(() => _showPrice = val),
          ),
        ],
      );

  Widget _buildSliderSetting(
    String label,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged, {
    bool isDiscrete = false,
  }) =>
      Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label),
              Text('${value.toStringAsFixed(isDiscrete ? 0 : 1)} ملم'),
            ],
          ),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: isDiscrete ? (max - min).toInt() : 90,
            onChanged: onChanged,
          ),
        ],
      );
}
