import 'package:basir_accounting_system/core/theme/accessibility/state_contrast_calculator.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:flutter/material.dart';

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
  static const Color hoverOverlayLight = Color(0x1A000000);
  static const Color hoverOverlayDark = Color(0x1AFFFFFF);

  // Pressed state
  static const Color pressedOverlayLight = Color(0x33000000);
  static const Color pressedOverlayDark = Color(0x33FFFFFF);

  // Selected state
  static const Color selectedBackgroundLight = AppColors.primaryLight;
  static const Color selectedBackgroundDark = AppPalette.navyDeep;
  static const Color selectedBorderLight = AppColors.primary;
  static const Color selectedBorderDark = AppPalette.blueCorporate;
  static const Color selectedForegroundLight = AppColors.primary;
  static const Color selectedForegroundDark = AppPalette.blueLight;

  // Focused state
  static const Color focusBorderLight = AppColors.primary;
  static const Color focusBorderDark = AppPalette.blueCorporate;
  static const double focusBorderWidth = 2;

  // Disabled state
  static const Color disabledBackgroundLight = Color(0xFFD1D5DB);
  static const Color disabledBackgroundDark = Color(0xFF374151);
  static const Color disabledForegroundLight = Color(0xFF6B7280);
  static const Color disabledForegroundDark = Color(0xFF9CA3AF);
  static const double disabledOpacity = 0.6;

  /// Get hover overlay color based on brightness
  static Color getHoverOverlay(Brightness brightness) =>
      brightness == Brightness.dark ? hoverOverlayDark : hoverOverlayLight;

  /// Get pressed overlay color based on brightness
  static Color getPressedOverlay(Brightness brightness) =>
      brightness == Brightness.dark ? pressedOverlayDark : pressedOverlayLight;

  /// Get selected background color based on brightness
  static Color getSelectedBackground(Brightness brightness) =>
      brightness == Brightness.dark
          ? selectedBackgroundDark
          : selectedBackgroundLight;

  /// Get selected border color based on brightness
  static Color getSelectedBorder(Brightness brightness) =>
      brightness == Brightness.dark ? selectedBorderDark : selectedBorderLight;

  /// Get selected foreground color based on brightness
  static Color getSelectedForeground(Brightness brightness) =>
      brightness == Brightness.dark
          ? selectedForegroundDark
          : selectedForegroundLight;

  /// Get focus border color based on brightness
  static Color getFocusBorder(Brightness brightness) =>
      brightness == Brightness.dark ? focusBorderDark : focusBorderLight;

  /// Get disabled background color based on brightness
  static Color getDisabledBackground(Brightness brightness) =>
      brightness == Brightness.dark
          ? disabledBackgroundDark
          : disabledBackgroundLight;

  /// Get disabled foreground color based on brightness
  static Color getDisabledForeground(Brightness brightness) =>
      brightness == Brightness.dark
          ? disabledForegroundDark
          : disabledForegroundLight;

  /// Get primary button background color for specific state
  static Color getPrimaryBackgroundColor(
    InteractiveState state, [
    Brightness brightness = Brightness.light,
  ]) {
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
        return getSelectedBackground(brightness);
      case InteractiveState.disabled:
        return getDisabledBackground(brightness);
    }
  }

  /// Get primary foreground color for specific state
  static Color getPrimaryForegroundColor(
    InteractiveState state, [
    Brightness brightness = Brightness.light,
  ]) {
    switch (state) {
      case InteractiveState.disabled:
        return getDisabledForeground(brightness);
      case InteractiveState.selected:
        return getSelectedForeground(brightness);
      default:
        return ButtonColors.primaryForeground;
    }
  }

  /// Get secondary button background color for specific state
  static Color getSecondaryBackgroundColor(
    InteractiveState state, [
    Brightness brightness = Brightness.light,
  ]) {
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
        return getSelectedBackground(brightness);
      case InteractiveState.disabled:
        return getDisabledBackground(brightness);
    }
  }

  /// Get secondary foreground color for specific state
  static Color getSecondaryForegroundColor(
    InteractiveState state, [
    Brightness brightness = Brightness.light,
  ]) {
    switch (state) {
      case InteractiveState.disabled:
        return getDisabledForeground(brightness);
      case InteractiveState.selected:
        return getSelectedForeground(brightness);
      default:
        return ButtonColors.secondaryForeground;
    }
  }
}
