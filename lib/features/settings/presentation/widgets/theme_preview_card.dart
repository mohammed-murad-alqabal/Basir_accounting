import 'package:basser_app/core/theme/tokens/index.dart';
import 'package:basser_app/core/widgets/index.dart';
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
                  child: AppPrimaryButton(
                    label: 'أساسي',
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: Spacing.sm),
                Expanded(
                  child: AppSecondaryButton(
                    label: 'ثانوي',
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: Spacing.md),

            // حقل إدخال
            const AppTextField(
              label: 'تجربة النص',
              hint: 'اكتب هنا...',
              prefixIcon: Icon(Icons.text_fields),
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
