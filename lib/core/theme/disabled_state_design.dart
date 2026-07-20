
import 'package:flutter/material.dart';
import 'app_state_colors.dart';

/// Disabled state design utilities
abstract final class DisabledStateDesign {
  /// Build a disabled indicator widget
  static Widget buildDisabledIndicator({
    required Widget child,
  }) {
    return Opacity(
      opacity: AppStateColors.disabledOpacity,
      child: IgnorePointer(child: child),
    );
  }

  /// Build a tooltip for disabled widgets explaining why they're disabled
  static Widget buildDisabledTooltip({
    required Widget child,
    required String message,
  }) {
    return Tooltip(
      message: message,
      child: buildDisabledIndicator(child: child),
    );
  }
}
