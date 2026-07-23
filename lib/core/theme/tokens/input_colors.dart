/// Input color tokens for Basir
library;

import 'package:basir_accounting_system/core/theme/tokens/app_colors.dart';
import 'package:flutter/material.dart';

/// Input color constants
abstract final class InputColors {
  static const Color border = AppColors.border;
  static const Color borderFocused = AppColors.primary;
  static const Color borderError = AppColors.error;
  static const Color fill = AppColors.surfaceVariant;
  static const Color label = AppColors.textSecondary;
  static const Color text = AppColors.textPrimary;
  static const Color placeholder = AppColors.textSecondary;
  static const Color background = AppColors.surface;
}
