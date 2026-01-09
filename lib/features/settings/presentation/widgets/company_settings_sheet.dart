import 'package:basir_app/core/extensions/context_extensions.dart';
import 'package:basir_app/core/theme/tokens/index.dart';
import 'package:basir_app/features/settings/presentation/providers/settings_controller.dart';
import 'package:basir_app/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// واجهة تعديل إعدادات الشركة
class CompanySettingsSheet extends ConsumerStatefulWidget {
  /// إنشاء واجهة تعديل إعدادات الشركة
  const CompanySettingsSheet({
    required this.initialSettings,
    super.key,
  });

  /// الإعدادات الأولية للشركة
  final Map<String, String?> initialSettings;

  /// عرض الواجهة
  static Future<void> show(
    BuildContext context,
    Map<String, String?> settings,
  ) =>
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => CompanySettingsSheet(initialSettings: settings),
      );

  @override
  ConsumerState<CompanySettingsSheet> createState() =>
      _CompanySettingsSheetState();
}

class _CompanySettingsSheetState extends ConsumerState<CompanySettingsSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _taxNumberController;
  late final TextEditingController _taxRateController;
  late final TextEditingController _currencySymbolController;
  late final TextEditingController _countryCodeController;
  late String _selectedStyle;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.initialSettings['companyName']);
    _taxNumberController =
        TextEditingController(text: widget.initialSettings['taxNumber']);
    _taxRateController =
        TextEditingController(text: widget.initialSettings['taxRate']);
    _currencySymbolController =
        TextEditingController(text: widget.initialSettings['currencySymbol']);
    _countryCodeController = TextEditingController(
      text: widget.initialSettings['defaultCountryCode'],
    );
    _selectedStyle = widget.initialSettings['invoiceStyle'] ?? 'standard';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _taxNumberController.dispose();
    _taxRateController.dispose();
    _currencySymbolController.dispose();
    _countryCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(settingsControllerProvider);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(Radii.xl)),
      ),
      padding: EdgeInsets.only(
        top: Spacing.lg,
        left: Spacing.lg,
        right: Spacing.lg,
        bottom: MediaQuery.of(context).viewInsets.bottom + Spacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(Radii.full),
              ),
            ),
          ),
          const SizedBox(height: Spacing.md),
          Text(
            context.l10n.companySettingsDialogTitle,
            style: theme.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Spacing.lg),
          AppTextField(
            controller: _nameController,
            label: context.l10n.labelCompanyName,
            hint: context.l10n.hintCompanyName,
            prefixIcon: const Icon(Icons.business),
          ),
          const SizedBox(height: Spacing.md),
          AppTextField(
            controller: _taxNumberController,
            label: context.l10n.labelTaxNumber,
            hint: context.l10n.hintTaxNumber,
            prefixIcon: const Icon(Icons.receipt_long),
          ),
          const SizedBox(height: Spacing.md),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: _taxRateController,
                  label: context.l10n.labelTaxRate,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  prefixIcon: const Icon(Icons.percent),
                ),
              ),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: AppTextField(
                  controller: _currencySymbolController,
                  label: context.l10n.labelCurrencySymbol,
                  hint: context.l10n.hintCurrencySymbol,
                  prefixIcon: const Icon(Icons.currency_exchange),
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.md),
          DropdownButtonFormField<String>(
            initialValue: _selectedStyle,
            decoration: InputDecoration(
              labelText: context.l10n.labelInvoiceStyle,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Radii.md),
              ),
              prefixIcon: const Icon(Icons.style),
            ),
            items: [
              DropdownMenuItem(
                value: 'standard',
                child: Text(context.l10n.styleStandard),
              ),
              DropdownMenuItem(
                value: 'modern',
                child: Text(context.l10n.styleModern),
              ),
              DropdownMenuItem(
                value: 'compact',
                child: Text(context.l10n.styleCompact),
              ),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _selectedStyle = value);
            },
          ),
          const SizedBox(height: Spacing.xl),
          AppEnhancedButton(
            width: double.infinity,
            label: context.l10n.dialogSave,
            isLoading: state.isLoading,
            onPressed: () async {
              final navigator = Navigator.of(context);
              final success = await ref
                  .read(settingsControllerProvider.notifier)
                  .updateCompanySettings(
                    name: _nameController.text.trim(),
                    taxNumber: _taxNumberController.text.trim(),
                    taxRate: double.tryParse(_taxRateController.text) ?? 0.15,
                    currencySymbol: _currencySymbolController.text.trim(),
                    countryCode: _countryCodeController.text.trim(),
                    invoiceStyle: _selectedStyle,
                  );

              if (success && mounted) {
                navigator.pop();
              }
            },
          ),
        ],
      ),
    );
  }
}
