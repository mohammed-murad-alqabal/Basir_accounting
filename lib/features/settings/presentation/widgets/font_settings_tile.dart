import 'dart:async';

import 'package:basser_app/core/extensions/context_extensions.dart';
import 'package:basser_app/core/theme/services/font_customization_service.dart';
import 'package:basser_app/core/theme/tokens/index.dart';
import 'package:basser_app/core/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ودجت إعدادات الخطوط
class FontSettingsTile extends ConsumerWidget {
  /// إنشاء ودجت إعدادات الخطوط
  const FontSettingsTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fontState = ref.watch(fontCustomizationProvider).value;
    final currentFont = fontState?.fontFamily ?? FontFamilies.arabic;
    final currentScale = fontState?.textScaleFactor ?? 1.0;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
            child: Text(
              'الخطوط والنصوص',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const SizedBox(height: Spacing.md),

          // اختيار نوع الخط
          ListTile(
            title: Text(context.l10n.fontSettingsTitle),
            subtitle: Text(_getFontName(currentFont)),
            trailing: DropdownButton<String>(
              value: currentFont,
              underline: const SizedBox(),
              items: [
                DropdownMenuItem(
                  value: FontFamilies.arabic,
                  child: Text(context.l10n.fontCairo),
                ),
                DropdownMenuItem(
                  value: 'Roboto',
                  child: Text(context.l10n.fontRoboto),
                ),
                // يمكن إضافة المزيد من الخطوط هنا
              ],
              onChanged: (value) {
                if (value != null) {
                  unawaited(
                    ref
                        .read(fontCustomizationProvider.notifier)
                        .setFontFamily(value),
                  );
                }
              },
            ),
          ),

          const Divider(),

          // حجم النص Slider
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.md,
              vertical: Spacing.sm,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(context.l10n.fontSizeLabel),
                    Text('${(currentScale * 100).toInt()}%'),
                  ],
                ),
                Slider(
                  value: currentScale,
                  min: 0.8,
                  max: 1.4,
                  divisions: 6,
                  label: '${(currentScale * 100).toInt()}%',
                  onChanged: (value) {
                    unawaited(
                      ref
                          .read(fontCustomizationProvider.notifier)
                          .setTextScale(value),
                    );
                  },
                ),
                // معاينة النص
                Container(
                  padding: const EdgeInsets.all(Spacing.md),
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(Radii.md),
                  ),
                  child: const Row(
                    children: [
                      Expanded(
                        child: Text(
                          'معاينة النص: بصير نظام متكامل.',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getFontName(String family) {
    if (family == FontFamilies.arabic) return 'Cairo';
    if (family == 'Roboto') return 'Roboto';
    return family;
  }
}
