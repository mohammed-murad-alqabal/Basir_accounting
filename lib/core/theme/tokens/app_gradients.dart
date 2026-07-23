/// Gradient tokens for Basir
library;

import 'package:basir_accounting_system/core/theme/tokens/app_palette.dart';
import 'package:flutter/material.dart';

/// Gradient constants
abstract final class AppGradients {
  static const LinearGradient primary = LinearGradient(
    colors: [AppPalette.blueCorporate, AppPalette.blueSky],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondary = LinearGradient(
    colors: [AppPalette.greenForest, AppPalette.greenEmerald],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
