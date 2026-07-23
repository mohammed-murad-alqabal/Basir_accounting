/// Button color tokens for Basir
library;

import 'package:basir_accounting_system/core/theme/tokens/app_colors.dart';
import 'package:flutter/material.dart';

/// Button color constants
abstract final class ButtonColors {
  static const Color primary = AppColors.primary;
  static const Color onPrimary = AppColors.onPrimary;
  static const Color secondary = AppColors.secondary;
  static const Color onSecondary = AppColors.onSecondary;
  static const Color disabled = AppColors.textDisabled;
  static const Color danger = AppColors.error;
  static const Color onDanger = AppColors.onError;

  static const Color primaryBackground = AppColors.primary;
  static const Color primaryForeground = AppColors.onPrimary;
  static const Color secondaryBackground = AppColors.secondary;
  static const Color secondaryForeground = AppColors.onSecondary;
  static const Color dangerBackground = AppColors.error;
  static const Color dangerForeground = AppColors.onError;
}
