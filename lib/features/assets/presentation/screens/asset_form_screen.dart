import 'package:basir_accounting_system/core/extensions/context_extensions.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/features/assets/domain/entities/fixed_asset.dart';
import 'package:basir_accounting_system/features/assets/presentation/providers/asset_provider.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

/// شاشة إضافة/تعديل أصل ثابت (Asset Form Screen)
class AssetFormScreen extends ConsumerStatefulWidget {
  /// إنشاء شاشة نموذج الأصول
  const AssetFormScreen({super.key, this.asset});

  /// الأصل المراد تعديله (إن وجد)
  final FixedAsset? asset;

  @override
  ConsumerState<AssetFormScreen> createState() => _AssetFormScreenState();
}

class _AssetFormScreenState extends ConsumerState<AssetFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameArController;
  late TextEditingController _nameEnController;
  late TextEditingController _codeController;
  late TextEditingController _costController;
  late TextEditingController _salvageValueController;
  late TextEditingController _usefulLifeController;
  DateTime _acquisitionDate = DateTime.now();
  String _depreciationMethod = 'Straight Line';
  String _categoryId = 'default';

  @override
  void initState() {
    super.initState();
    _nameArController = TextEditingController(text: widget.asset?.nameAr ?? '');
    _nameEnController = TextEditingController(text: widget.asset?.nameEn ?? '');
    _codeController = TextEditingController(text: widget.asset?.code ?? '');
    _costController = TextEditingController(
      text: widget.asset?.cost.toString() ?? '',
    );
    _salvageValueController = TextEditingController(
      text: widget.asset?.residualValue.toString() ?? '0.0',
    );
    _usefulLifeController = TextEditingController(
      text: widget.asset?.usefulLifeYears.toString() ?? '5',
    );
    if (widget.asset != null) {
      _acquisitionDate = widget.asset!.acquisitionDate;
      _depreciationMethod = widget.asset!.depreciationMethod;
      _categoryId = widget.asset!.categoryId;
    }
  }

  @override
  void dispose() {
    _nameArController.dispose();
    _nameEnController.dispose();
    _codeController.dispose();
    _costController.dispose();
    _salvageValueController.dispose();
    _usefulLifeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.asset != null;
    final actionState = ref.watch(assetActionProvider);

    return GlassScaffold(
      title: isEdit ? context.l10n.titleEditAsset : context.l10n.titleAddAsset,
      body: actionState.when(
        data: (_) => _buildForm(),
        loading: () => const Center(child: AppLoadingIndicator()),
        error: (error, _) => AppErrorWidget(
          message: error.toString(),
          onRetry: () => ref.invalidate(assetActionProvider),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(Spacing.lg),
        child: AppEnhancedButton(
          label: context.l10n.btnSave,
          onPressed: _saveAsset,
        ),
      ),
    );
  }

  Widget _buildForm() => SingleChildScrollView(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              AppTextField(
                controller: _nameArController,
                label: context.l10n.labelNameAr,
                validator: (v) =>
                    v?.isEmpty ?? true ? context.l10n.errEmptyField : null,
              ),
              const SizedBox(height: Spacing.md),
              AppTextField(
                controller: _nameEnController,
                label: context.l10n.labelNameEn,
                validator: (v) =>
                    v?.isEmpty ?? true ? context.l10n.errEmptyField : null,
              ),
              const SizedBox(height: Spacing.md),
              AppTextField(
                controller: _codeController,
                label: context.l10n.labelCode,
              ),
              const SizedBox(height: Spacing.md),
              AppTextField(
                controller: _costController,
                label: context.l10n.labelCost,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: Spacing.md),
              AppTextField(
                controller: _salvageValueController,
                label: context.l10n.labelSalvageValue,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: Spacing.md),
              AppTextField(
                controller: _usefulLifeController,
                label: context.l10n.labelUsefulLife,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: Spacing.md),
              // Simple date picker placeholder
              ListTile(
                title: Text(context.l10n.labelPurchaseDate),
                subtitle:
                    Text(_acquisitionDate.toIso8601String().split('T')[0]),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _acquisitionDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) setState(() => _acquisitionDate = date);
                },
              ),
            ],
          ),
        ),
      );

  Future<void> _saveAsset() async {
    if (!_formKey.currentState!.validate()) return;

    final asset = FixedAsset(
      id: widget.asset?.id ?? const Uuid().v4(),
      code: _codeController.text,
      nameAr: _nameArController.text,
      nameEn: _nameEnController.text,
      categoryId: _categoryId,
      acquisitionDate: _acquisitionDate,
      cost: double.tryParse(_costController.text) ?? 0.0,
      residualValue: double.tryParse(_salvageValueController.text) ?? 0.0,
      usefulLifeYears: int.tryParse(_usefulLifeController.text) ?? 5,
      depreciationMethod: _depreciationMethod,
      assetAccountId: 'placeholder',
      depreciationAccountId: 'placeholder',
      accumDepreciationAccountId: 'placeholder',
      isActive: widget.asset?.isActive ?? true,
    );

    final success = widget.asset == null
        ? await ref.read(assetActionProvider.notifier).addAsset(asset)
        : await ref.read(assetActionProvider.notifier).updateAsset(asset);

    if (success && mounted) {
      Navigator.pop(context, true);
    } else if (mounted) {
      AppSnackbar.showError(context, context.l10n.errGeneric(''));
    }
  }
}
