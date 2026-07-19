import 'dart:async';

import 'package:basir_accounting_system/core/extensions/context_extensions.dart';
import 'package:basir_accounting_system/core/theme/services/font_customization_service.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ودجت إعدادات الخطوط - نسخة بلاتينيوم
class FontSettingsTile extends ConsumerWidget {
  /// إنشاء ودجت إعدادات الخطوط
  const FontSettingsTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final fontState = ref.watch(fontCustomizationProvider).value;
    final currentFont = fontState?.fontFamily ?? FontFamilies.arabic;
    final currentScale = fontState?.textScaleFactor ?? 1.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // اختيار نوع الخط - Segmented UI
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
          child: Text(
            context.l10n.fontSettingsTitle,
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: Spacing.md),
        Center(
          child: SegmentedButton<String>(
            segments: [
              ButtonSegment<String>(
                value: FontFamilies.arabic,
                label: Text(context.l10n.fontCairo),
                icon: const Icon(Icons.font_download),
              ),
              ButtonSegment<String>(
                value: 'Roboto',
                label: Text(context.l10n.fontRoboto),
                icon: const Icon(Icons.abc),
              ),
            ],
            selected: {currentFont},
            onSelectionChanged: (newSelection) {
              unawaited(
                ref
                    .read(fontCustomizationProvider.notifier)
                    .setFontFamily(newSelection.first),
              );
            },
            showSelectedIcon: false,
          ),
        ),

        const SizedBox(height: Spacing.xl),

        // حجم النص - Modern Slider
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.fontSizeLabel,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.sm,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(Radii.sm),
                ),
                child: Text(
                  '${(currentScale * 100).toInt()}%',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        Slider(
          value: currentScale,
          min: 0.8,
          max: 1.4,
          divisions: 6,
          onChanged: (value) {
            unawaited(
              ref.read(fontCustomizationProvider.notifier).setTextScale(value),
            );
          },
        ),

        const SizedBox(height: Spacing.md),

        // معاينة النص - Platinum Preview
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: Spacing.md),
          padding: const EdgeInsets.all(Spacing.lg),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.3,
            ),
            borderRadius: BorderRadius.circular(Radii.lg),
            border: Border.all(color: theme.colorScheme.outlineVariant),
          ),
          child: Column(
            children: [
              Text(
                'بصير: شريكك الذكي في إدارة الفواتير والمستودعات',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: currentFont,
                  // ignore: deprecated_member_use
                  fontSize: 16 * currentScale,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: Spacing.sm),
              Text(
                'Smart solution for your business growth.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: currentFont,
                  // ignore: deprecated_member_use
                  fontSize: 14 * currentScale,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
