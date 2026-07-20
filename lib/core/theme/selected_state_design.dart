import 'package:flutter/material.dart';
import 'package:basir_accounting_system/core/theme/app_state_colors.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';

/// Selected state design utilities
abstract final class SelectedStateDesign {
  /// Build a selected container decoration
  static BoxDecoration buildSelectedBoxDecoration() => BoxDecoration(
        color: AppStateColors.selectedBackground,
        border: Border.all(
          color: AppStateColors.selectedBorder,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12),
      );

  /// Build a selected list tile
  static Widget buildSelectedListTile({
    required Widget title,
    Widget? subtitle,
    Widget? leading,
    Widget? trailing,
    bool showCheckmark = true,
    VoidCallback? onTap,
  }) =>
      Container(
        decoration: buildSelectedBoxDecoration(),
        child: ListTile(
          title: title,
          subtitle: subtitle,
          leading: leading,
          trailing: showCheckmark
              ? Icon(
                  Icons.check_circle,
                  color: AppColors.primary,
                )
              : trailing,
          onTap: onTap,
        ),
      );
}
