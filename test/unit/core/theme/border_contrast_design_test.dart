import 'package:basir_accounting_system/core/theme/border_contrast_design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BorderContrastDesign', () {
    test('buildEnhancedInputBorder returns correct border', () {
      final border = BorderContrastDesign.buildEnhancedInputBorder();
      expect(border.borderSide.color, BorderContrastDesign.borderNormal);
      expect(border.borderSide.width, BorderContrastDesign.borderWidthNormal);
    });

    test('buildEnhancedInputBorder uses custom color and width', () {
      const customColor = Colors.red;
      const customWidth = 3.0;
      final border = BorderContrastDesign.buildEnhancedInputBorder(
        color: customColor,
        width: customWidth,
      );
      expect(border.borderSide.color, customColor);
      expect(border.borderSide.width, customWidth);
    });

    test('buildEnhancedDivider returns correct divider', () {
      final divider = BorderContrastDesign.buildEnhancedDivider();
      expect(divider.color, BorderContrastDesign.borderNormal);
      expect(divider.thickness, 1.0);
    });

    test('buildEnhancedDivider uses custom color and thickness', () {
      const customColor = Colors.blue;
      const customThickness = 2.0;
      final divider = BorderContrastDesign.buildEnhancedDivider(
        color: customColor,
        thickness: customThickness,
      );
      expect(divider.color, customColor);
      expect(divider.thickness, customThickness);
    });
  });
}
