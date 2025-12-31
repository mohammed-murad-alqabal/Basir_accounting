import 'dart:async';

import 'package:basser_app/core/extensions/context_extensions.dart';
import 'package:basser_app/core/theme/services/color_customization_service.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// نافذة اختيار الألوان
class ColorPickerDialog extends ConsumerWidget {
  /// المنشئ الثابت
  const ColorPickerDialog({super.key});

  /// عرض النافذة
  static Future<void> show(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (context) => const ColorPickerDialog(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentColor = ref.watch(colorCustomizationProvider).value;

    return AlertDialog(
      title: Text(context.l10n.themeColorPickerTitle),
      content: SingleChildScrollView(
        child: ColorPicker(
          color: currentColor ?? const Color(0xFF2196F3), // Default fallback
          onColorChanged: (color) {
            // تحديث فوري (Interactive Preview)
            unawaited(
              ref
                  .read(colorCustomizationProvider.notifier)
                  .setPrimaryColor(color),
            );
          },
          borderRadius: 20,
          spacing: 10,
          runSpacing: 10,
          wheelDiameter: 200,
          heading: Text(
            'الألوان الأساسية',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          subheading: Text(
            'درجات اللون',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          wheelSubheading: Text(
            'عجلة الألوان',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          showColorCode: true,
          materialNameTextStyle: Theme.of(context).textTheme.bodySmall,
          colorNameTextStyle: Theme.of(context).textTheme.bodySmall,
          colorCodeTextStyle: Theme.of(context).textTheme.bodySmall,
          pickersEnabled: const <ColorPickerType, bool>{
            ColorPickerType.both: false,
            ColorPickerType.primary: true,
            ColorPickerType.accent: false,
            ColorPickerType.bw: false,
            ColorPickerType.custom: false,
            ColorPickerType.wheel: true,
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            unawaited(
              ref.read(colorCustomizationProvider.notifier).resetToDefault(),
            );
            Navigator.of(context).pop();
          },
          child: Text(context.l10n.btnRestoreDefault),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(context.l10n.btnDone),
        ),
      ],
    );
  }
}
