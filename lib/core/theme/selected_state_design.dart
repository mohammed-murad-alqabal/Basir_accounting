import 'package:basir_accounting_system/core/theme/app_state_colors.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:flutter/material.dart';

/// Selected state design utilities
abstract final class SelectedStateDesign {
  /// Build a selected container decoration
  static BoxDecoration buildSelectedBoxDecoration([
    Brightness brightness = Brightness.light,
  ]) =>
      BoxDecoration(
        color: AppStateColors.getSelectedBackground(brightness),
        border: Border.all(
          color: AppStateColors.getSelectedBorder(brightness),
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
    Brightness brightness = Brightness.light,
  }) =>
      DecoratedBox(
        decoration: buildSelectedBoxDecoration(brightness),
        child: ListTile(
          title: title,
          subtitle: subtitle,
          leading: leading,
          trailing: showCheckmark
              ? Icon(
                  Icons.check_circle,
                  color: AppStateColors.getSelectedForeground(brightness),
                )
              : trailing,
          onTap: onTap,
        ),
      );

  /// Build a selected bottom nav item wrapper
  static Widget buildSelectedNavItem({
    required Widget child,
    Brightness brightness = Brightness.light,
  }) =>
      Container(
        decoration: BoxDecoration(
          color: AppStateColors.getSelectedBackground(brightness),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppStateColors.getSelectedBorder(brightness),
            width: 2,
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.sm,
          vertical: Spacing.xs,
        ),
        child: child,
      );
}
