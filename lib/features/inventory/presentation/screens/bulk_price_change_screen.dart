import 'dart:async';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/features/inventory/domain/entities/bulk_price_change.dart';
import 'package:basir_accounting_system/features/inventory/domain/entities/inventory_item.dart';
import 'package:basir_accounting_system/features/inventory/presentation/providers/bulk_price_change_provider.dart';
import 'package:basir_accounting_system/features/inventory/presentation/providers/inventory_provider.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:basir_accounting_system/shared/widgets/app_card.dart';
import 'package:basir_accounting_system/shared/widgets/app_enhanced_button.dart';
import 'package:basir_accounting_system/shared/widgets/app_error_widget.dart';
import 'package:basir_accounting_system/shared/widgets/app_loading_indicator.dart';
import 'package:basir_accounting_system/shared/widgets/app_snackbar.dart';
import 'package:basir_accounting_system/shared/widgets/app_text_field.dart';
import 'package:basir_accounting_system/shared/widgets/glass_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// شاشة معالج تغيير الأسعار الجماعي متعددة الخطوات.
///
/// تتبع خطوات المخطط التنفيذي: النطاق، القاعدة، المعاينة، الاعتماد
/// والتنفيذ، مع نافذة إلغاء 24 ساعة موثقة في أثر التدقيق.
class BulkPriceChangeScreen extends ConsumerWidget {
  /// إنشاء شاشة معالج تغيير الأسعار الجماعي.
  const BulkPriceChangeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wizard = ref.watch(bulkChangeWizardProvider);
    return GlassScaffold(
      title: AppLocalizations.of(context).bulkWizardTitle,
      body: Column(
        children: [
          _WizardStepper(step: wizard.step),
          Expanded(
            child: IndexedStack(
              index: wizard.step.index,
              children: const [
                _ScopeStep(),
                _RuleStep(),
                _PreviewStep(),
                _ApprovalStep(),
                _SuccessStep(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// مؤشر الخطوات الزجاجي أعلى المعالج.
class _WizardStepper extends StatelessWidget {
  /// إنشاء مؤشر الخطوات.
  const _WizardStepper({required this.step});

  /// الخطوة الحالية.
  final BulkChangeWizardStep step;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final labels = [
      l10n.bulkWizardStep1,
      l10n.bulkWizardStep2,
      l10n.bulkWizardStep3,
      l10n.bulkWizardStep4,
    ];
    return Padding(
      padding: const EdgeInsets.all(Spacing.lg),
      child: Row(
        children: List.generate(labels.length, (index) {
          final active = index == step.index;
          return Expanded(
            child: Padding(
              padding: index < labels.length - 1
                  ? const EdgeInsetsDirectional.only(end: Spacing.sm)
                  : EdgeInsets.zero,
              child: Column(
                children: [
                  Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: active
                          ? AppColors.primary
                          : AppColors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(Radii.sm),
                    ),
                  ),
                  const SizedBox(height: Spacing.xs),
                  Text(
                    labels[index],
                    style: TextStyle(
                      fontSize: AppTextStyles.titleSmallSize,
                      fontWeight: active ? FontWeight.bold : FontWeight.normal,
                      color:
                          active ? AppColors.primary : AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

/// الخطوة الأولى: تحديد نطاق الأصناف.
class _ScopeStep extends ConsumerWidget {
  /// إنشاء خطوة النطاق.
  const _ScopeStep();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final wizard = ref.watch(bulkChangeWizardProvider);
    final scope = wizard.scope;
    final isSpecific = scope.isSpecific;
    return ListView(
      padding: const EdgeInsets.all(Spacing.lg),
      children: [
        AppListCard(
          title: l10n.bulkScopeAll,
          subtitle: l10n.bulkScopeAllDescription,
          isSelected: !isSpecific,
          onTap: () => ref
              .read(bulkChangeWizardProvider.notifier)
              .updateScope(const BulkPriceChangeScope.all()),
        ),
        const SizedBox(height: Spacing.md),
        AppListCard(
          title: l10n.bulkScopeSpecific,
          subtitle: l10n.bulkScopeSpecificDescription,
          trailing: isSpecific
              ? Text(
                  l10n.bulkScopeSelectedCount(scope.count),
                  style: const TextStyle(color: AppColors.primary),
                )
              : null,
          onTap: () => _openItemPicker(context, ref),
        ),
        const SizedBox(height: Spacing.xl),
        AppEnhancedButton(
          label: l10n.bulkWizardNext,
          width: double.infinity,
          type: AppEnhancedButtonType.primary,
          onPressed: ref.read(bulkChangeWizardProvider.notifier).nextStep,
        ),
      ],
    );
  }

  Future<void> _openItemPicker(BuildContext context, WidgetRef ref) async {
    final selection = await Navigator.push<List<InventoryItem>>(
      context,
      MaterialPageRoute<List<InventoryItem>>(
        builder: (_) => const _InventoryMultiPicker(),
      ),
    );
    if (selection == null) return;
    if (selection.isEmpty) {
      ref.read(bulkChangeWizardProvider.notifier).updateScope(
            const BulkPriceChangeScope.all(),
          );
    } else {
      ref.read(bulkChangeWizardProvider.notifier).updateScope(
            BulkPriceChangeScope.items(
              selection.map((item) => item.id).toList(growable: false),
            ),
          );
    }
  }
}

/// خطوة التعريف بقاعدة التغيير.
class _RuleStep extends ConsumerStatefulWidget {
  /// إنشاء خطوة القاعدة.
  const _RuleStep();

  @override
  ConsumerState<_RuleStep> createState() => _RuleStepState();
}

class _RuleStepState extends ConsumerState<_RuleStep> {
  final TextEditingController _valueController = TextEditingController();

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final wizard = ref.watch(bulkChangeWizardProvider);
    final notifier = ref.read(bulkChangeWizardProvider.notifier);
    final ruleType = wizard.ruleType;
    final needsValue = ruleType != BulkPriceChangeRuleType.copyFromPurchase;
    return ListView(
      padding: const EdgeInsets.all(Spacing.lg),
      children: [
        Text(
          l10n.bulkTargetLabel,
          style: const TextStyle(
            fontSize: AppTextStyles.titleMediumSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: Spacing.md),
        Wrap(
          spacing: Spacing.sm,
          runSpacing: Spacing.sm,
          children: [
            for (final target in BulkPriceTarget.values)
              FilterChip(
                label: Text(_targetLabel(l10n, target)),
                selected: wizard.target == target,
                onSelected: (_) => notifier.updateTarget(target),
              ),
          ],
        ),
        const SizedBox(height: Spacing.lg),
        Text(
          l10n.bulkRuleTypeLabel,
          style: const TextStyle(
            fontSize: AppTextStyles.titleMediumSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: Spacing.md),
        Wrap(
          spacing: Spacing.sm,
          runSpacing: Spacing.sm,
          children: [
            for (final type in BulkPriceChangeRuleType.values)
              FilterChip(
                label: Text(_ruleLabel(l10n, type)),
                selected: ruleType == type,
                onSelected: (_) {
                  notifier.updateRuleType(type);
                  _valueController.clear();
                },
              ),
          ],
        ),
        if (needsValue) ...[
          const SizedBox(height: Spacing.lg),
          TextField(
            controller: _valueController,
            decoration: InputDecoration(
              labelText: l10n.bulkRuleValueLabel,
              hintText: l10n.bulkRuleValueHint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Radii.md),
              ),
            ),
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
              signed: true,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d*')),
            ],
            onChanged: (value) {
              final parsed = double.tryParse(value);
              if (parsed != null) notifier.updateRuleValue(parsed);
            },
          ),
        ],
        const SizedBox(height: Spacing.xl),
        AppEnhancedButton(
          label: l10n.bulkWizardNext,
          width: double.infinity,
          type: AppEnhancedButtonType.primary,
          onPressed: notifier.nextStep,
        ),
      ],
    );
  }

  String _targetLabel(AppLocalizations l10n, BulkPriceTarget target) {
    switch (target) {
      case BulkPriceTarget.sale:
        return l10n.bulkTargetSale;
      case BulkPriceTarget.purchase:
        return l10n.bulkTargetPurchase;
      case BulkPriceTarget.both:
        return l10n.bulkTargetBoth;
    }
  }

  String _ruleLabel(AppLocalizations l10n, BulkPriceChangeRuleType type) {
    switch (type) {
      case BulkPriceChangeRuleType.percentage:
        return l10n.bulkRulePercentage;
      case BulkPriceChangeRuleType.fixedAmount:
        return l10n.bulkRuleFixedAmount;
      case BulkPriceChangeRuleType.setTo:
        return l10n.bulkRuleSetTo;
      case BulkPriceChangeRuleType.copyFromPurchase:
        return l10n.bulkRuleCopyFromPurchase;
    }
  }
}

/// خطوة معاينة الأثر قبل التنفيذ.
class _PreviewStep extends ConsumerWidget {
  /// إنشاء خطوة المعاينة.
  const _PreviewStep();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final wizard = ref.watch(bulkChangeWizardProvider);
    final notifier = ref.read(bulkChangeWizardProvider.notifier);
    if (!wizard.previewLoaded && !wizard.applying) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await notifier.refreshPreview();
      });
    }
    if (wizard.applying && wizard.previewEntries.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(Spacing.xl),
          child: AppLoadingIndicator(),
        ),
      );
    }
    final entries = wizard.previewEntries;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.bulkPreviewCount(entries.length),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.refresh, size: IconSizes.md),
                tooltip: l10n.bulkPreviewRefresh,
                onPressed: notifier.refreshPreview,
              ),
            ],
          ),
        ),
        if (entries.isEmpty)
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(Spacing.xl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.info_outline,
                      size: 40,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(height: Spacing.md),
                    Text(
                      l10n.bulkPreviewNoChanges,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(Spacing.lg),
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final entry = entries[index];
                return _PreviewEntryCard(entry: entry, target: wizard.target);
              },
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(Spacing.lg),
          child: AppEnhancedButton(
            label: l10n.bulkWizardNext,
            width: double.infinity,
            type: AppEnhancedButtonType.primary,
            onPressed: wizard.previewEntries.isEmpty ? null : notifier.nextStep,
          ),
        ),
      ],
    );
  }
}

/// بطاقة معاينة أثر التغيير على صنف واحد.
class _PreviewEntryCard extends StatelessWidget {
  /// إنشاء بطاقة معاينة.
  const _PreviewEntryCard({required this.entry, required this.target});

  /// معاينة الصنف.
  final BulkPriceChangePreviewEntry entry;

  /// السعر المستهدف للمعراجة.
  final BulkPriceTarget target;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final blocked = entry.isBlocked ?? false;
    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.md),
      child: AppListCard(
        title: entry.itemName,
        subtitle: blocked
            ? '${l10n.bulkPreviewBlocked}: ${entry.blockReason}'
            : _priceDelta(l10n),
        leading: CircleAvatar(
          backgroundColor: blocked
              ? AppColors.error.withValues(alpha: 0.15)
              : AppColors.primary.withValues(alpha: 0.2),
          child: Icon(
            blocked ? Icons.block : Icons.price_change,
            color: blocked ? AppColors.error : AppColors.primary,
            size: IconSizes.md,
          ),
        ),
        backgroundColor:
            blocked ? AppColors.error.withValues(alpha: 0.05) : null,
      ),
    );
  }

  String _priceDelta(AppLocalizations l10n) {
    final parts = <String>[];
    final showSale =
        target == BulkPriceTarget.sale || target == BulkPriceTarget.both;
    final showPurchase =
        target == BulkPriceTarget.purchase || target == BulkPriceTarget.both;
    if (showSale &&
        entry.previousSalePrice != null &&
        entry.newSalePrice != null) {
      parts.add(
        '${l10n.bulkPreviewSale}: ${_format(entry.previousSalePrice)} → ${_format(entry.newSalePrice)}',
      );
    }
    if (showPurchase &&
        entry.previousPurchasePrice != null &&
        entry.newPurchasePrice != null) {
      parts.add(
        '${l10n.bulkPreviewPurchase}: ${_format(entry.previousPurchasePrice)} → ${_format(entry.newPurchasePrice)}',
      );
    }
    if (parts.isEmpty) return '';
    return parts.join(' • ');
  }

  String _format(double? value) {
    if (value == null) return '—';
    final fixed = value.toStringAsFixed(2);
    final trimmed = fixed.replaceAll(RegExp(r'0+$'), '').replaceAll('.', '');
    return trimmed.isEmpty ? '0' : trimmed;
  }
}

/// خطوة الاعتماد والتنفيذ.
class _ApprovalStep extends ConsumerStatefulWidget {
  /// إنشاء خطوة الاعتماد.
  const _ApprovalStep();

  @override
  ConsumerState<_ApprovalStep> createState() => _ApprovalStepState();
}

class _ApprovalStepState extends ConsumerState<_ApprovalStep> {
  final TextEditingController _operatorController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();

  late final BulkChangeWizardNotifier _notifier;

  @override
  void initState() {
    super.initState();
    _notifier = ref.read(bulkChangeWizardProvider.notifier);
  }

  @override
  void dispose() {
    _operatorController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final wizard = ref.watch(bulkChangeWizardProvider);
    final notifier = ref.read(bulkChangeWizardProvider.notifier);
    return ListView(
      padding: const EdgeInsets.all(Spacing.lg),
      children: [
        if (wizard.error != null) ...[
          _ErrorBanner(message: wizard.error!),
          const SizedBox(height: Spacing.md),
        ],
        AppListCard(
          title: l10n.bulkApprovalReviewSummary,
          subtitle: _summaryLine(l10n, wizard),
        ),
        const SizedBox(height: Spacing.lg),
        AppTextField(
          label: l10n.bulkApprovalOperator,
          controller: _operatorController,
          hint: l10n.bulkErrorOperatorRequired,
        ),
        const SizedBox(height: Spacing.md),
        AppTextField(
          label: l10n.bulkApprovalReason,
          controller: _reasonController,
          hint: l10n.bulkApprovalReasonHint,
          maxLines: 3,
          minLines: 2,
        ),
        const SizedBox(height: Spacing.md),
        _ConfirmationCheckbox(
          label: l10n.bulkApprovalConfirmLabel,
          value: wizard.confirmed,
          onChanged: (value) =>
              notifier.updateConfirmation(confirmed: value ?? false),
        ),
        const SizedBox(height: Spacing.md),
        Text(
          l10n.bulkApprovalWarning,
          style: const TextStyle(
            fontSize: AppTextStyles.titleSmallSize,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: Spacing.xl),
        AppEnhancedButton(
          label: l10n.bulkApprovalExecute,
          width: double.infinity,
          type: AppEnhancedButtonType.primary,
          isLoading: wizard.executing,
          onPressed: wizard.confirmed && !wizard.executing
              ? () => _onExecute(context, ref)
              : null,
        ),
        const SizedBox(height: Spacing.md),
        if (wizard.executing) const Center(child: AppLoadingIndicator()),
      ],
    );
  }

  String _summaryLine(AppLocalizations l10n, BulkChangeWizardState wizard) {
    final scope = wizard.scope.isSpecific
        ? l10n.bulkScopeSelectedCount(wizard.scope.count)
        : l10n.bulkScopeAll;
    final rule = wizard.ruleType == BulkPriceChangeRuleType.copyFromPurchase
        ? l10n.bulkRuleCopyFromPurchase
        : '${l10n.bulkRuleValueLabel}: ${wizard.ruleValue}';
    return '$scope • ${_targetLabel(l10n, wizard.target)} • $rule';
  }

  String _targetLabel(AppLocalizations l10n, BulkPriceTarget target) {
    switch (target) {
      case BulkPriceTarget.sale:
        return l10n.bulkTargetSale;
      case BulkPriceTarget.purchase:
        return l10n.bulkTargetPurchase;
      case BulkPriceTarget.both:
        return l10n.bulkTargetBoth;
    }
  }

  Future<void> _onExecute(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final operatorName = _operatorController.text.trim();
    final reason = _reasonController.text.trim();
    if (operatorName.isEmpty) {
      AppSnackbar.showError(context, l10n.bulkApprovalOperator);
      return;
    }
    if (reason.isEmpty) {
      AppSnackbar.showError(context, l10n.bulkApprovalReason);
      return;
    }
    await _notifier.execute(operatorName: operatorName, reason: reason);
    final wizard = ref.read(bulkChangeWizardProvider);
    if (wizard.lastRecord != null && wizard.error == null) {
      if (context.mounted) {
        await _notifier.nextStep();
      }
    } else if (wizard.error != null) {
      if (context.mounted) {
        AppSnackbar.showError(context, wizard.error!);
      }
    }
  }
}

/// خطوة النجاح مع نافذة الإلغاء (24 ساعة).
class _SuccessStep extends ConsumerStatefulWidget {
  /// إنشاء خطوة النجاح.
  const _SuccessStep();

  @override
  ConsumerState<_SuccessStep> createState() => _SuccessStepState();
}

class _SuccessStepState extends ConsumerState<_SuccessStep> {
  late Timer _countdownTimer;

  @override
  void initState() {
    super.initState();
    _countdownTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _countdownTimer.cancel();
    super.dispose();
  }

  String _remainingHours() {
    final record = ref.read(bulkChangeWizardProvider).lastRecord;
    if (record == null) return '24';
    final now = ref.read(bulkChangeNowProvider)();
    final remaining = record.cancellationDeadline.difference(now);
    if (remaining.isNegative) return '0';
    return remaining.inHours.toString();
  }

  Future<void> _openCancellation(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final l10n = AppLocalizations.of(context);
    final record = ref.read(bulkChangeWizardProvider).lastRecord;
    if (record == null) return;
    final notifier = ref.read(bulkChangeWizardProvider.notifier);
    final canCancel = !record.isCancelled &&
        record.isCancellableAt(
          ref.read(bulkChangeNowProvider)(),
        );
    if (!canCancel && mounted) {
      AppSnackbar.showInfo(
        context,
        l10n.bulkCancellationExpired,
      );
      return;
    }
    final operatorName = await _CancellationDialog.show(
      context,
      title: l10n.bulkCancellationTitle,
      confirmLabel: l10n.bulkCancellationExecute,
    );
    if (operatorName == null || !mounted) return;
    await notifier.cancelLastExecution(
      operatorName: operatorName,
      reason: l10n.bulkCancellationTitle,
    );
    final updated = ref.read(bulkChangeWizardProvider);
    if (updated.lastRecord?.isCancelled ?? false) {
      if (context.mounted) {
        AppSnackbar.showSuccess(context, l10n.bulkCancellationSuccess);
        ref.invalidate(inventoryItemsProvider);
      }
    } else if (updated.error != null) {
      if (context.mounted) {
        AppSnackbar.showError(context, updated.error!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final wizard = ref.watch(bulkChangeWizardProvider);
    final record = wizard.lastRecord;
    if (record == null) {
      return const SizedBox.shrink();
    }
    final remaining = _remainingHours();
    final cancellable = !record.isCancelled && int.tryParse(remaining)! > 0;
    return Column(
      children: [
        const SizedBox(height: Spacing.xl),
        Center(
          child: Container(
            padding: const EdgeInsets.all(Spacing.xl),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_outline,
              color: AppColors.success,
              size: 56,
            ),
          ),
        ),
        const SizedBox(height: Spacing.lg),
        Text(
          l10n.bulkSuccessTitle,
          style: const TextStyle(
            fontSize: AppTextStyles.titleMediumSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: Spacing.sm),
        Text(
          l10n.bulkSuccessCount(record.affectedItemIds.length),
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        const SizedBox(height: Spacing.md),
        if (record.isCancelled)
          _CancellationStatusCard(isCancelled: true, hours: '0', l10n: l10n)
        else if (cancellable)
          _CancellationStatusCard(
            isCancelled: false,
            hours: remaining,
            l10n: l10n,
          )
        else if (!record.isCancelled)
          _CancellationStatusCard(
            isCancelled: false,
            hours: '0',
            l10n: l10n,
          ),
        const SizedBox(height: Spacing.lg),
        if (!record.isCancelled)
          AppEnhancedButton(
            label: cancellable
                ? l10n.bulkCancellationExecute
                : l10n.bulkCancellationExpired,
            width: double.infinity,
            type: AppEnhancedButtonType.primary,
            backgroundColor: AppColors.warning,
            onPressed:
                cancellable ? () => _openCancellation(context, ref) : null,
          ),
        if (record.isCancelled)
          AppEnhancedButton(
            label: l10n.bulkWizardReset,
            width: double.infinity,
            type: AppEnhancedButtonType.primary,
            onPressed: () {
              ref.read(bulkChangeWizardProvider.notifier).reset();
            },
          ),
        if (!record.isCancelled)
          TextButton(
            onPressed: () =>
                ref.read(bulkChangeWizardProvider.notifier).reset(),
            child: Text(l10n.bulkWizardFinish),
          ),
      ],
    );
  }
}

/// بطاقة حالة الإلغاء داخل خطوة النجاح.
class _CancellationStatusCard extends StatelessWidget {
  /// إنشاء بطاقة حالة الإلغاء.
  const _CancellationStatusCard({
    required this.isCancelled,
    required this.hours,
    required this.l10n,
  });

  /// هل أُلغي التنفيذ؟
  final bool isCancelled;

  /// الساعات المتبقية من نافذة الإلغاء.
  final String hours;

  /// مورد التوطين.
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(Spacing.md),
        decoration: BoxDecoration(
          color: isCancelled
              ? AppColors.info.withValues(alpha: 0.08)
              : AppColors.warning.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(Radii.md),
          border: Border.all(
            color: (isCancelled ? AppColors.info : AppColors.warning)
                .withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(
              isCancelled ? Icons.check_circle_outline : Icons.timer_outlined,
              color: isCancelled ? AppColors.info : AppColors.warning,
              size: IconSizes.md,
            ),
            const SizedBox(width: Spacing.md),
            Expanded(
              child: Text(
                isCancelled
                    ? l10n.bulkCancellationSuccess
                    : l10n.bulkSuccessCancellable(int.tryParse(hours) ?? 0),
              ),
            ),
          ],
        ),
      );
}

/// حوار إدخال اسم المنفذ للإلغاء.
class _CancellationDialog {
  _CancellationDialog._();

  /// يعرض حوار الإلغاء ويعيد اسم المنفذ أو null عند الإلغاء.
  static Future<String?> show(
    BuildContext context, {
    required String title,
    required String confirmLabel,
  }) async {
    final controller = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(dialogContext).bulkApprovalOperator,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Radii.md),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(AppLocalizations.of(dialogContext).dialogCancel),
          ),
          FilledButton(
            onPressed: controller.text.trim().isEmpty
                ? null
                : () => Navigator.of(dialogContext).pop(true),
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
    if (!(confirmed ?? false)) return null;
    return controller.text.trim();
  }
}

/// خانة إقرار مخصصة.
class _ConfirmationCheckbox extends StatelessWidget {
  /// إنشاء خانة الإقرار.
  const _ConfirmationCheckbox({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  /// تسمية الإقرار.
  final String label;

  /// حالة الاختيار.
  final bool value;

  /// معالج التغيير.
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) => Semantics(
        label: label,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: value,
              onChanged: onChanged,
              activeColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Radii.sm),
              ),
            ),
            const SizedBox(width: Spacing.sm),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: AppTextStyles.titleSmallSize),
              ),
            ),
          ],
        ),
      );
}

/// شريط خطأ داخل الخطوات.
class _ErrorBanner extends StatelessWidget {
  /// إنشاء شريط الخطأ.
  const _ErrorBanner({required this.message});

  /// رسالة الخطأ.
  final String message;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(Spacing.md),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(Radii.md),
          border: Border.all(
            color: AppColors.error.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.error_outline,
              color: AppColors.error,
              size: IconSizes.md,
            ),
            const SizedBox(width: Spacing.md),
            Expanded(child: Text(message)),
          ],
        ),
      );
}

/// محدد أصناف المخزون المتعدد.
class _InventoryMultiPicker extends ConsumerStatefulWidget {
  /// إنشاء محدد الأصناف المتعدد.
  const _InventoryMultiPicker();

  @override
  ConsumerState<_InventoryMultiPicker> createState() =>
      _InventoryMultiPickerState();
}

class _InventoryMultiPickerState extends ConsumerState<_InventoryMultiPicker> {
  final Set<String> _selectedIds = <String>{};

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final itemsAsync = ref.watch(filteredInventoryItemsProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.bulkScopeSelectItems),
        actions: [
          TextButton(
            onPressed: _selectedIds.isNotEmpty ? _finish : null,
            child: Text('${l10n.btnDone} (${_selectedIds.length})'),
          ),
        ],
      ),
      body: itemsAsync.when(
        data: (items) => ListView.builder(
          padding: const EdgeInsets.all(Spacing.md),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            final selected = _selectedIds.contains(item.id);
            return AppListCard(
              title: item.name(
                isArabic: Directionality.of(context) == TextDirection.rtl,
              ),
              leading: CircleAvatar(
                backgroundColor: selected
                    ? AppColors.primary.withValues(alpha: 0.2)
                    : AppColors.disabled.withValues(alpha: 0.2),
                child: Icon(
                  selected ? Icons.check : Icons.add,
                  color: selected ? AppColors.primary : AppColors.textSecondary,
                  size: IconSizes.sm,
                ),
              ),
              isSelected: selected,
              onTap: () {
                setState(() {
                  if (selected) {
                    _selectedIds.remove(item.id);
                  } else {
                    _selectedIds.add(item.id);
                  }
                });
              },
            );
          },
        ),
        loading: () => const Center(child: AppLoadingIndicator()),
        error: (error, stack) =>
            AppErrorWidget(message: error.toString(), onRetry: () {}),
      ),
    );
  }

  void _finish() {
    final itemsAsync = ref.read(filteredInventoryItemsProvider).value ??
        const <InventoryItem>[];
    final selected =
        itemsAsync.where((item) => _selectedIds.contains(item.id)).toList();
    Navigator.pop<List<InventoryItem>>(context, selected);
  }
}
