// ignore_for_file: lines_longer_than_80_chars
import 'dart:async';

import 'package:basir_app/core/extensions/context_extensions.dart';
import 'package:basir_app/core/theme/services/icon_customization_service.dart';
import 'package:basir_app/core/theme/tokens/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ودجت إعدادات الأيقونات - نسخة بلاتينيوم
class IconSettingsTile extends ConsumerWidget {
  /// إنشاء ودجت إعدادات الأيقونات
  const IconSettingsTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final customizationState = ref.watch(iconCustomizationProvider).value;
    final currentPack = customizationState?.iconPack ?? IconPack.material;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
          child: Text(
            context.l10n.iconSettingsTitle,
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: Spacing.md),

        // اختيار حزمة الأيقونات - Visual Cards
        Row(
          children: [
            Expanded(
              child: _IconPackCard(
                pack: IconPack.material,
                isSelected: currentPack == IconPack.material,
                label: context.l10n.iconMaterial,
                exampleIcon: Icons.home_rounded,
                onTap: () => _updatePack(ref, IconPack.material),
              ),
            ),
            const SizedBox(width: Spacing.md),
            Expanded(
              child: _IconPackCard(
                pack: IconPack.cupertino,
                isSelected: currentPack == IconPack.cupertino,
                label: context.l10n.iconCupertino,
                exampleIcon: Icons.apple,
                onTap: () => _updatePack(ref, IconPack.cupertino),
              ),
            ),
          ],
        ),

        const SizedBox(height: Spacing.xl),

        // معاينة حية
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
          child: Text(
            'معاينة الحزمة الحالية',
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: Spacing.md),
        DecoratedBox(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.3,
            ),
            borderRadius: BorderRadius.circular(Radii.lg),
            border: Border.all(
              color: theme.colorScheme.outlineVariant,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _IconPreviewItem(
                icon: customizationState?.icons.home ?? Icons.home,
                label: context.l10n.labelHome,
              ),
              _IconPreviewItem(
                icon: customizationState?.icons.invoices ?? Icons.receipt,
                label: context.l10n.invoicesTitle,
              ),
              _IconPreviewItem(
                icon: customizationState?.icons.customers ?? Icons.people,
                label: context.l10n.customersTitle,
              ),
              _IconPreviewItem(
                icon: customizationState?.icons.settings ?? Icons.settings,
                label: context.l10n.labelSettings,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _updatePack(WidgetRef ref, IconPack pack) {
    unawaited(
      ref.read(iconCustomizationProvider.notifier).setIconPack(pack),
    );
  }
}

class _IconPackCard extends StatelessWidget {
  const _IconPackCard({
    required this.pack,
    required this.isSelected,
    required this.label,
    required this.exampleIcon,
    required this.onTap,
  });

  final IconPack pack;
  final bool isSelected;
  final String label;
  final IconData exampleIcon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Radii.md),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(Spacing.md),
        decoration: BoxDecoration(
          color:
              isSelected ? colorScheme.primaryContainer : colorScheme.surface,
          borderRadius: BorderRadius.circular(Radii.md),
          border: Border.all(
            color:
                isSelected ? colorScheme.primary : colorScheme.outlineVariant,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              exampleIcon,
              color: isSelected ? colorScheme.primary : colorScheme.onSurface,
              size: 32,
            ),
            const SizedBox(height: Spacing.sm),
            Text(
              label,
              style: theme.textTheme.labelLarge?.copyWith(
                color: isSelected
                    ? colorScheme.onPrimaryContainer
                    : colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconPreviewItem extends StatelessWidget {
  const _IconPreviewItem({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Icon(icon, size: 28, color: theme.colorScheme.primary),
        const SizedBox(height: Spacing.xs),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
