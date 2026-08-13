/// منتقي كيان موحد لمحررات الوثائق.
///
/// يفصل بيانات الكيان وقواعد أهليته التي تزودها طبقة الخدمة عن آلية العرض،
/// ويمكن تهيئته لاختيار عميل أو مورد أو صنف أو حساب.
library;

import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// خيار واحد يمكن اختياره داخل [EntityPicker].
@immutable
class EntityPickerOption {
  /// ينشئ خيار كيان بمعرف وعنوان قابلين للعرض.
  const EntityPickerOption({
    required this.id,
    required this.label,
    this.subtitle,
    this.enabled = true,
    this.disabledReason,
  }) : assert(
          enabled || disabledReason != null,
          'Provide a reason when an option is ineligible.',
        );

  /// المعرّف الدائم للكيان في طبقة المجال.
  final String id;

  /// العنوان الأساسي المعرب/المترجم للكيان.
  final String label;

  /// وصف ثانوي، مثل الرصيد أو الرمز أو وحدة الصنف.
  final String? subtitle;

  /// هل يسمح السياق والسياسات باختيار هذا الكيان؟
  final bool enabled;

  /// سبب عدم الأهلية، ويظهر للمستخدم بدل تعطيل صامت.
  final String? disabledReason;
}

/// حقل اختيار كيان قابل لإعادة الاستخدام داخل محرر الوثيقة.
class EntityPicker extends StatelessWidget {
  /// ينشئ المنتقي مع خيارات صالحة وقرار اختيار يملكه المستدعي.
  const EntityPicker({
    required this.label,
    required this.hint,
    required this.options,
    super.key,
    this.selectedId,
    this.onChanged,
    this.enabled = true,
  });

  /// اسم نوع الكيان، مثل العميل أو الصنف.
  final String label;

  /// إرشاد مختصر قبل الاختيار.
  final String hint;

  /// الخيارات المحمّلة من طبقة البحث أو المرجع.
  final List<EntityPickerOption> options;

  /// معرّف الخيار الحالي إن وجد.
  final String? selectedId;

  /// يستقبل الخيار المؤهل الجديد أو `null` عند إلغاء الاختيار.
  final ValueChanged<EntityPickerOption?>? onChanged;

  /// يعطل الحقل كاملًا أثناء التحميل أو عند غياب الصلاحية.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final selectedIsAvailable =
        options.any((option) => option.id == selectedId);
    final value = selectedIsAvailable ? selectedId : null;

    return Semantics(
      label: label,
      child: DropdownButtonFormField<String>(
        key: const Key('entityPickerInput'),
        initialValue: value,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
        ),
        items: options
            .map(
              (option) => DropdownMenuItem<String>(
                value: option.id,
                enabled: option.enabled,
                child: _EntityOptionLabel(
                  option: option,
                  defaultDisabledLabel: l10n.workEntityPickerDisabled,
                ),
              ),
            )
            .toList(growable: false),
        onChanged: enabled && onChanged != null
            ? (id) {
                final option = options.cast<EntityPickerOption?>().firstWhere(
                      (option) => option?.id == id,
                      orElse: () => null,
                    );
                onChanged?.call(option);
              }
            : null,
        disabledHint: Text(l10n.workEntityPickerNoOptions),
      ),
    );
  }
}

class _EntityOptionLabel extends StatelessWidget {
  const _EntityOptionLabel({
    required this.option,
    required this.defaultDisabledLabel,
  });

  final EntityPickerOption option;
  final String defaultDisabledLabel;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(option.label, overflow: TextOverflow.ellipsis),
          if (option.subtitle != null || !option.enabled)
            Text(
              option.enabled
                  ? option.subtitle!
                  : option.disabledReason ?? defaultDisabledLabel,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
        ],
      );
}
