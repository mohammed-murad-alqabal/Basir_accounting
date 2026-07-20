import 'package:basir_accounting_system/core/theme/app_state_colors.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:flutter/material.dart';

/// Enhanced button theme with proper state management
abstract final class EnhancedButtonTheme {
  /// Create primary button style with full state support
  static ButtonStyle createPrimaryButtonStyle([
    Brightness brightness = Brightness.light,
  ]) =>
      ButtonStyle(
        elevation: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) return 0.0;
          if (states.contains(WidgetState.pressed)) return 2.0;
          if (states.contains(WidgetState.hovered)) return 4.0;
          return 2.0;
        }),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return AppStateColors.getPrimaryBackgroundColor(
              InteractiveState.disabled,
              brightness,
            );
          } else if (states.contains(WidgetState.pressed)) {
            return AppStateColors.getPrimaryBackgroundColor(
              InteractiveState.pressed,
              brightness,
            );
          } else if (states.contains(WidgetState.hovered)) {
            return AppStateColors.getPrimaryBackgroundColor(
              InteractiveState.hovered,
              brightness,
            );
          }
          return AppStateColors.getPrimaryBackgroundColor(
            InteractiveState.normal,
            brightness,
          );
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return AppStateColors.getPrimaryForegroundColor(
              InteractiveState.disabled,
              brightness,
            );
          }
          return AppStateColors.getPrimaryForegroundColor(
            InteractiveState.normal,
            brightness,
          );
        }),
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return AppStateColors.getPressedOverlay(brightness);
          } else if (states.contains(WidgetState.hovered)) {
            return AppStateColors.getHoverOverlay(brightness);
          }
          return null;
        }),
        side: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.focused)) {
            return BorderSide(
              color: AppStateColors.getFocusBorder(brightness),
              width: AppStateColors.focusBorderWidth,
            );
          }
          return null;
        }),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

  /// Create secondary button style
  static ButtonStyle createSecondaryButtonStyle([
    Brightness brightness = Brightness.light,
  ]) =>
      ButtonStyle(
        elevation: WidgetStateProperty.all(0),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return AppStateColors.getDisabledBackground(brightness);
          }
          return Colors.transparent;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return AppStateColors.getDisabledForeground(brightness);
          }
          return AppColors.primary;
        }),
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return AppStateColors.getPressedOverlay(brightness);
          } else if (states.contains(WidgetState.hovered)) {
            return AppStateColors.getHoverOverlay(brightness);
          }
          return null;
        }),
        side: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return BorderSide(
              color: AppStateColors.getDisabledBackground(brightness),
            );
          } else if (states.contains(WidgetState.focused)) {
            return BorderSide(
              color: AppStateColors.getFocusBorder(brightness),
              width: AppStateColors.focusBorderWidth,
            );
          }
          return const BorderSide(color: AppColors.primary);
        }),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

  /// Create text button style
  static ButtonStyle createTextButtonStyle([
    Brightness brightness = Brightness.light,
  ]) =>
      ButtonStyle(
        elevation: WidgetStateProperty.all(0),
        backgroundColor: WidgetStateProperty.all(Colors.transparent),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return AppStateColors.getDisabledForeground(brightness);
          }
          return AppColors.primary;
        }),
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return AppStateColors.getPressedOverlay(brightness);
          } else if (states.contains(WidgetState.hovered)) {
            return AppStateColors.getHoverOverlay(brightness);
          }
          return null;
        }),
        side: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.focused)) {
            return BorderSide(
              color: AppStateColors.getFocusBorder(brightness),
              width: AppStateColors.focusBorderWidth,
            );
          }
          return null;
        }),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
}
