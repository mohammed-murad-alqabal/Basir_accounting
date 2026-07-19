import 'package:basir_accounting_system/core/extensions/context_extensions.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:flutter/material.dart';

/// بطاقة معاينة الثيم
/// تعرض نماذج من عناصر واجهة المستخدم للتحقق من المظهر
class ThemePreviewCard extends StatelessWidget {
  /// إنشاء بطاقة معاينة الثيم
  const ThemePreviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0.5,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Radii.lg),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // العنوان
            Row(
              children: [
                Icon(Icons.preview, size: 16, color: colorScheme.primary),
                const SizedBox(width: Spacing.xs),
                Text(
                  'معاينة المظهر',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: Spacing.md),

            // الأزرار
            Row(
              children: [
                Expanded(
                  child: AppEnhancedButton(
                    width: double.infinity,
                    label: context.l10n.labelPrimary,
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: Spacing.sm),
                Expanded(
                  child: AppEnhancedButton(
                    type: AppEnhancedButtonType.secondary,
                    width: double.infinity,
                    label: context.l10n.labelSecondary,
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: Spacing.md),

            // حقل إدخال
            AppTextField(
              label: context.l10n.labelTestText,
              hint: 'اكتب هنا...',
              prefixIcon: const Icon(Icons.text_fields),
            ),
            const SizedBox(height: Spacing.md),

            // نصوص وأيقونات
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'عنوان رئيسي',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      'نص توضيحي فرعي',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
                Switch(value: true, onChanged: (_) {}),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
