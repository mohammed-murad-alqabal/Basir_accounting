import 'package:flutter/material.dart';
import 'package:basir_accounting_system/core/theme/app_state_colors.dart';

/// Disabled state design utilities
abstract final class DisabledStateDesign {
  /// Build a disabled indicator widget
  static Widget buildDisabledIndicator({
    required Widget child,
  }) =>
      Opacity(
        opacity: AppStateColors.disabledOpacity,
        child: IgnorePointer(child: child),
      );

  /// Build a tooltip for disabled widgets explaining why they're disabled
  static Widget buildDisabledTooltip({
    required Widget child,
    required String message,
  }) =>
      Tooltip(
        message: message,
        child: buildDisabledIndicator(child: child),
      );
}
