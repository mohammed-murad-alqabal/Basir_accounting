import 'package:basir_accounting_system/core/theme/app_state_colors.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:flutter/material.dart';

/// Enhanced button theme with proper state management
abstract final class EnhancedButtonTheme {
  /// Create primary button style with full state support
  static ButtonStyle createPrimaryButtonStyle() => ButtonStyle(
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
            );
          } else if (states.contains(WidgetState.pressed)) {
            return AppStateColors.getPrimaryBackgroundColor(
              InteractiveState.pressed,
            );
          } else if (states.contains(WidgetState.hovered)) {
            return AppStateColors.getPrimaryBackgroundColor(
              InteractiveState.hovered,
            );
          }
          return AppStateColors.getPrimaryBackgroundColor(
            InteractiveState.normal,
          );
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return AppStateColors.getPrimaryForegroundColor(
              InteractiveState.disabled,
            );
          }
          return AppStateColors.getPrimaryForegroundColor(
            InteractiveState.normal,
          );
        }),
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return AppStateColors.pressedOverlay;
          } else if (states.contains(WidgetState.hovered)) {
            return AppStateColors.hoverOverlay;
          }
          return null;
        }),
        side: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.focused)) {
            return const BorderSide(
              color: AppStateColors.focusBorder,
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
  static ButtonStyle createSecondaryButtonStyle() => ButtonStyle(
        elevation: WidgetStateProperty.all(0),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return AppStateColors.disabledBackground;
          }
          return Colors.transparent;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return AppStateColors.disabledForeground;
          }
          return AppColors.primary;
        }),
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return AppStateColors.pressedOverlay;
          } else if (states.contains(WidgetState.hovered)) {
            return AppStateColors.hoverOverlay;
          }
          return null;
        }),
        side: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return const BorderSide(color: AppStateColors.disabledBackground);
          } else if (states.contains(WidgetState.focused)) {
            return const BorderSide(
              color: AppStateColors.focusBorder,
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
  static ButtonStyle createTextButtonStyle() => ButtonStyle(
        elevation: WidgetStateProperty.all(0),
        backgroundColor: WidgetStateProperty.all(Colors.transparent),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return AppStateColors.disabledForeground;
          }
          return AppColors.primary;
        }),
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return AppStateColors.pressedOverlay;
          } else if (states.contains(WidgetState.hovered)) {
            return AppStateColors.hoverOverlay;
          }
          return null;
        }),
        side: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.focused)) {
            return const BorderSide(
              color: AppStateColors.focusBorder,
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
