import 'package:basir_app/core/extensions/context_extensions.dart';
import 'package:basir_app/core/theme/services/icon_customization_service.dart';
import 'package:basir_app/core/theme/tokens/index.dart';
import 'package:basir_app/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// شاشة اختبار شاملة لجميع أنواع الأزرار الموحدة.
///
/// تحتوي على جميع أنواع الأزرار (primary, secondary, text) في حالات مختلفة
/// (عادي، مع أيقونة، معطل، تحميل، نص طويل) لاختبار عدم وجود قص للنصوص.
class ButtonTestScreen extends ConsumerWidget {
  /// ينشئ شاشة اختبار الأزرار.
  const ButtonTestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appIcons = ref.watch(appIconsProvider);

    return Scaffold(
      appBar: AppAppBar(title: context.l10n.testButtonsTitle),
      body: TextScaleFactorTester(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Spacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildIntroCard(context),
              const SizedBox(height: Spacing.xl),

              // قسم: أزرار Primary
              buildSection(
                context: context,
                title: context.l10n.sectionPrimaryButtons,
                icon: appIcons.touch,
                children: [
                  AppButton(label: 'نص قصير', onPressed: () {}),
                  const SizedBox(height: Spacing.md),
                  AppButton(
                    label: 'نص متوسط الطول للاختبار',
                    onPressed: () {},
                  ),
                  const SizedBox(height: Spacing.md),
                  AppButton(
                    label: 'نص طويل جداً جداً قد يسبب مشاكل في العرض',
                    onPressed: () {},
                  ),
                  const SizedBox(height: Spacing.md),
                  AppButton(
                    label: 'مع أيقونة',
                    icon: appIcons.add,
                    onPressed: () {},
                  ),
                  const SizedBox(height: Spacing.md),
                  const AppButton(label: 'معطل', onPressed: null),
                  const SizedBox(height: Spacing.md),
                  AppButton(
                    label: 'تحميل',
                    onPressed: () {},
                    isLoading: true,
                  ),
                ],
              ),

              const SizedBox(height: Spacing.xl),

              // قسم: أزرار Secondary
              buildSection(
                context: context,
                title: context.l10n.sectionSecondaryButtons,
                icon: appIcons.circle,
                children: [
                  AppButton(
                    label: 'نص قصير',
                    onPressed: () {},
                    type: AppButtonType.secondary,
                  ),
                  const SizedBox(height: Spacing.md),
                  AppButton(
                    label: 'نص متوسط الطول للاختبار',
                    onPressed: () {},
                    type: AppButtonType.secondary,
                  ),
                  const SizedBox(height: Spacing.md),
                  AppButton(
                    label: 'نص طويل جداً جداً قد يسبب مشاكل في العرض',
                    onPressed: () {},
                    type: AppButtonType.secondary,
                  ),
                  const SizedBox(height: Spacing.md),
                  AppButton(
                    label: 'مع أيقونة',
                    icon: appIcons.edit,
                    onPressed: () {},
                    type: AppButtonType.secondary,
                  ),
                  const SizedBox(height: Spacing.md),
                  const AppButton(
                    label: 'معطل',
                    onPressed: null,
                    type: AppButtonType.secondary,
                  ),
                  const SizedBox(height: Spacing.md),
                  AppButton(
                    label: 'تحميل',
                    onPressed: () {},
                    isLoading: true,
                    type: AppButtonType.secondary,
                  ),
                ],
              ),

              const SizedBox(height: Spacing.xl),

              // قسم: أزرار Text
              buildSection(
                context: context,
                title: context.l10n.sectionTextButtons,
                icon: appIcons.text,
                children: [
                  AppButton(
                    label: 'نص قصير',
                    onPressed: () {},
                    type: AppButtonType.text,
                  ),
                  const SizedBox(height: Spacing.md),
                  AppButton(
                    label: 'نص متوسط الطول للاختبار',
                    onPressed: () {},
                    type: AppButtonType.text,
                  ),
                  const SizedBox(height: Spacing.md),
                  AppButton(
                    label: 'نص طويل جداً جداً قد يسبب مشاكل في العرض',
                    onPressed: () {},
                    type: AppButtonType.text,
                  ),
                  const SizedBox(height: Spacing.md),
                  AppButton(
                    label: 'مع أيقونة',
                    icon: appIcons.delete,
                    onPressed: () {},
                    type: AppButtonType.text,
                  ),
                  const SizedBox(height: Spacing.md),
                  const AppButton(
                    label: 'معطل',
                    onPressed: null,
                    type: AppButtonType.text,
                  ),
                ],
              ),

              const SizedBox(height: Spacing.xl),

              // قسم: أزرار في Row
              buildSection(
                context: context,
                title: context.l10n.sectionRowButtons,
                icon: Icons.view_column,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          label: 'إلغاء',
                          onPressed: () {},
                          type: AppButtonType.secondary,
                        ),
                      ),
                      const SizedBox(width: Spacing.md),
                      Expanded(
                        child: AppButton(
                          label: 'موافق',
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Spacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          label: 'حذف',
                          icon: appIcons.delete,
                          onPressed: () {},
                          type: AppButtonType.text,
                        ),
                      ),
                      const SizedBox(width: Spacing.md),
                      Expanded(
                        child: AppButton(
                          label: 'حفظ',
                          icon: appIcons.save,
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: Spacing.xxl),
              buildNoteCard(context),
            ],
          ),
        ),
      ),
    );
  }

  /// ينشئ بطاقة مقدمة الشاشة.
  Widget buildIntroCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      color: colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info, color: colorScheme.primary),
                const SizedBox(width: Spacing.sm),
                Expanded(
                  child: Text(
                    'اختبار الأزرار الموحدة (AppButton)',
                    style: TextStyle(
                      fontSize: AppTypography.titleLarge,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: Spacing.md),
            Text(
              'تم توحيد جميع الأزرار في مكون AppButton واحد يدعم '
              'Cairo Font Metrics ومنع قص النصوص التلقائي.',
              style: TextStyle(
                fontSize: AppTypography.bodyMedium,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ينشئ بطاقة ملاحظات الشاشة.
  Widget buildNoteCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      color: colorScheme.tertiaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb, color: colorScheme.tertiary),
                const SizedBox(width: Spacing.sm),
                Text(
                  'ملاحظة',
                  style: TextStyle(
                    fontSize: AppTypography.titleMedium,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onTertiaryContainer,
                  ),
                ),
              ],
            ),
            const SizedBox(height: Spacing.sm),
            Text(
              '• تم حذف AppEnhancedButton بالكامل.\n'
              '• AppButton هو المكون الوحيد المعتمد حالياً.',
              style: TextStyle(
                fontSize: AppTypography.bodyMedium,
                color: colorScheme.onTertiaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ينشئ قسماً في شاشة الاختبار.
  Widget buildSection({
    required BuildContext context,
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: IconSizes.md, color: colorScheme.primary),
            const SizedBox(width: Spacing.sm),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: AppTypography.titleLarge,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: Spacing.lg),
        ...children,
      ],
    );
  }
}
