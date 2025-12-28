import 'dart:async';

import 'package:basser_app/core/theme/services/icon_customization_service.dart';
import 'package:basser_app/core/theme/tokens/index.dart';
import 'package:basser_app/core/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ودجت إعدادات الأيقونات
class IconSettingsTile extends ConsumerWidget {
  /// إنشاء ودجت إعدادات الأيقونات
  const IconSettingsTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customizationState = ref.watch(iconCustomizationProvider).value;
    final currentPack = customizationState?.iconPack ?? IconPack.material;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
            child: Text(
              'الأيقونات (Beta)',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const SizedBox(height: Spacing.md),

          // اختيار حزمة الأيقونات
          ListTile(
            title: const Text('نمط الأيقونات'),
            subtitle: Text(_getPackName(currentPack)),
            trailing: DropdownButton<IconPack>(
              value: currentPack,
              underline: const SizedBox(),
              items: const [
                DropdownMenuItem(
                  value: IconPack.material,
                  child: Text('Material Design'),
                ),
                DropdownMenuItem(
                  value: IconPack.cupertino,
                  child: Text('Cupertino (iOS)'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  unawaited(
                    ref
                        .read(iconCustomizationProvider.notifier)
                        .setIconPack(value),
                  );
                }
              },
            ),
          ),

          const Divider(),

          // معاينة
          Padding(
            padding: const EdgeInsets.all(Spacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'معاينة',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: Spacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _IconPreview(
                      icon: customizationState?.icons.home ?? Icons.home,
                      label: 'الرئيسية',
                    ),
                    _IconPreview(
                      icon:
                          customizationState?.icons.settings ?? Icons.settings,
                      label: 'الإعدادات',
                    ),
                    _IconPreview(
                      icon: customizationState?.icons.person ?? Icons.person,
                      label: 'الملف',
                    ),
                    _IconPreview(
                      icon: customizationState?.icons.notifications ??
                          Icons.notifications,
                      label: 'تنبيهات',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getPackName(IconPack pack) {
    switch (pack) {
      case IconPack.material:
        return 'Material Design';
      case IconPack.cupertino:
        return 'Cupertino';
    }
  }
}

class _IconPreview extends StatelessWidget {
  const _IconPreview({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Icon(icon, size: 28),
          const SizedBox(height: Spacing.xs),
          Text(label, style: Theme.of(context).textTheme.labelSmall),
        ],
      );
}
