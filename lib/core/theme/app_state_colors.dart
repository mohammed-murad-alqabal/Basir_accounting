
import 'package:flutter/material.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'accessibility/state_contrast_calculator.dart';

/// Interactive states for components
enum InteractiveState {
  normal,
  hovered,
  pressed,
  focused,
  selected,
  disabled,
}

/// State-specific colors for interactive components
abstract final class AppStateColors {
  // Hover state
  static const Color hoverOverlay = Color(0x1A000000);

  // Pressed state
  static const Color pressedOverlay = Color(0x33000000);

  // Selected state
  static const Color selectedBackground = AppColors.primaryLight;
  static const Color selectedBorder = AppColors.primary;
  static const Color selectedForeground = AppColors.primary;

  // Focused state
  static const Color focusBorder = AppColors.primary;
  static const double focusBorderWidth = 2.0;

  // Disabled state
  static const Color disabledBackground = Color(0xFFD1D5DB);
  static const Color disabledForeground = Color(0xFF6B7280);
  static const double disabledOpacity = 0.6;

  /// Get primary button color for specific state
  static Color getPrimaryBackgroundColor(InteractiveState state) {
    switch (state) {
      case InteractiveState.normal:
        return ButtonColors.primaryBackground;
      case InteractiveState.hovered:
        return StateContrastCalculator.darken(
          ButtonColors.primaryBackground,
          0.1,
        );
      case InteractiveState.pressed:
        return StateContrastCalculator.darken(
          ButtonColors.primaryBackground,
          0.15,
        );
      case InteractiveState.focused:
        return ButtonColors.primaryBackground;
      case InteractiveState.selected:
        return selectedBackground;
      case InteractiveState.disabled:
        return disabledBackground;
    }
  }

  /// Get primary foreground color for specific state
  static Color getPrimaryForegroundColor(InteractiveState state) {
    switch (state) {
      case InteractiveState.disabled:
        return disabledForeground;
      default:
        return ButtonColors.primaryForeground;
    }
  }

  /// Get secondary button background for specific state
  static Color getSecondaryBackgroundColor(InteractiveState state) {
    switch (state) {
      case InteractiveState.normal:
        return ButtonColors.secondaryBackground;
      case InteractiveState.hovered:
        return StateContrastCalculator.darken(
          ButtonColors.secondaryBackground,
          0.1,
        );
      case InteractiveState.pressed:
        return StateContrastCalculator.darken(
          ButtonColors.secondaryBackground,
          0.15,
        );
      case InteractiveState.focused:
        return ButtonColors.secondaryBackground;
      case InteractiveState.selected:
        return selectedBackground;
      case InteractiveState.disabled:
        return disabledBackground;
    }
  }

  /// Get secondary foreground color for specific state
  static Color getSecondaryForegroundColor(InteractiveState state) {
    switch (state) {
      case InteractiveState.disabled:
        return disabledForeground;
      default:
        return ButtonColors.secondaryForeground;
    }
  }
}
