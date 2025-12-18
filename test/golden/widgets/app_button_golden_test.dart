/// Golden Tests for AppButton Widgets
///
/// المشروع: بصير MVP
/// المؤلف: فريق وكلاء تطوير مشروع بصير
///
/// يختبر المظهر البصري لجميع أنواع الأزرار في التطبيق
library;

import 'package:basser_app/core/widgets/app_primary_button.dart';
import 'package:basser_app/core/widgets/app_secondary_button.dart';
import 'package:basser_app/core/widgets/app_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../golden_test_helper.dart';

void main() {
  group('AppButton Golden Tests', () {
    testWidgets('AppPrimaryButton - All States', (tester) async {
      final states = {
        'enabled': const AppPrimaryButton(
          text: 'زر أساسي',
        ),
        'disabled': const AppPrimaryButton(
          text: 'زر معطل',
        ),
        'loading': const AppPrimaryButton(
          text: 'جاري التحميل...',
          isLoading: true,
        ),
        'with_icon': const AppPrimaryButton(
          text: 'زر مع أيقونة',
          icon: Icons.add,
        ),
        'long_text': const AppPrimaryButton(
          text: 'زر بنص طويل جداً يجب أن يتم عرضه بشكل صحيح',
        ),
      };

      await tester.stateGoldenTest(
        states,
        'app_primary_button',
        size: const Size(300, 400),
      );
    });

    testWidgets('AppSecondaryButton - All States', (tester) async {
      final states = {
        'enabled': const AppSecondaryButton(
          text: 'زر ثانوي',
        ),
        'disabled': const AppSecondaryButton(
          text: 'زر معطل',
        ),
        'with_icon': const AppSecondaryButton(
          text: 'زر مع أيقونة',
          icon: Icons.edit,
        ),
        'small_size': const AppSecondaryButton(
          text: 'زر صغير',
        ),
      };

      await tester.stateGoldenTest(
        states,
        'app_secondary_button',
        size: const Size(300, 350),
      );
    });

    testWidgets('AppTextButton - All States', (tester) async {
      final states = {
        'enabled': const AppTextButton(
          text: 'زر نصي',
        ),
        'disabled': const AppTextButton(
          text: 'زر معطل',
        ),
        'with_icon': const AppTextButton(
          text: 'زر مع أيقونة',
          icon: Icons.info,
        ),
      };

      await tester.stateGoldenTest(
        states,
        'app_text_button',
        size: const Size(300, 250),
      );
    });

    testWidgets('Button Comparison - All Types', (tester) async {
      const comparisonWidget = Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          AppPrimaryButton(
            text: 'زر أساسي',
          ),
          AppSecondaryButton(
            text: 'زر ثانوي',
          ),
          AppTextButton(
            text: 'زر نصي',
          ),
        ],
      );

      await tester.goldenTest(
        comparisonWidget,
        'button_comparison',
        size: const Size(300, 400),
      );
    });

    testWidgets('Buttons - Multi Size Test', (tester) async {
      const testWidget = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppPrimaryButton(
            text: 'اختبار الأحجام',
            icon: Icons.phone,
          ),
          SizedBox(height: 16),
          AppSecondaryButton(
            text: 'زر ثانوي',
          ),
        ],
      );

      await tester.multiSizeGoldenTest(
        testWidget,
        'buttons_multi_size',
        sizes: [
          const Size(320, 200), // Small
          const Size(375, 200), // Medium
          const Size(414, 200), // Large
        ],
      );
    });

    testWidgets('Buttons - RTL vs LTR', (tester) async {
      const testWidget = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppPrimaryButton(
            text: 'Primary Button',
            icon: Icons.arrow_forward,
          ),
          SizedBox(height: 16),
          AppSecondaryButton(
            text: 'Secondary Button',
            icon: Icons.edit,
          ),
        ],
      );

      // Test RTL (Arabic)
      await GoldenTestHelper.runGoldenTest(
        tester: tester,
        widget: testWidget,
        goldenFileName: 'buttons_rtl_ltr',
        locales: [
          const Locale('ar', 'SA'), // RTL
          const Locale('en', 'US'), // LTR
        ],
        size: const Size(300, 200),
      );
    });
  });

  group('Button Edge Cases', () {
    testWidgets('Very Long Text Handling', (tester) async {
      const longTextWidget = Column(
        children: [
          AppPrimaryButton(
            text: 'هذا نص طويل جداً جداً جداً يجب أن يتم التعامل معه '
                'بشكل صحيح ولا يسبب مشاكل في التخطيط',
          ),
          SizedBox(height: 16),
          AppSecondaryButton(
            text: 'This is a very very very long text that should be '
                'handled correctly without layout issues',
          ),
        ],
      );

      await tester.goldenTest(
        longTextWidget,
        'buttons_long_text',
        size: const Size(250, 200),
      );
    });

    testWidgets('Minimum Size Constraints', (tester) async {
      const minSizeWidget = Column(
        children: [
          AppPrimaryButton(
            text: 'ق',
          ),
          SizedBox(height: 16),
          AppSecondaryButton(
            text: 'A',
          ),
        ],
      );

      await tester.goldenTest(
        minSizeWidget,
        'buttons_min_size',
        size: const Size(200, 200),
      );
    });

    testWidgets('Icon Alignment Test', (tester) async {
      const iconAlignmentWidget = Column(
        children: [
          AppPrimaryButton(
            text: 'أيقونة يسار',
            icon: Icons.arrow_back,
          ),
          SizedBox(height: 8),
          AppPrimaryButton(
            text: 'أيقونة يمين',
            icon: Icons.arrow_forward,
          ),
          SizedBox(height: 8),
          AppSecondaryButton(
            text: 'أيقونة علوية',
            icon: Icons.arrow_upward,
          ),
        ],
      );

      await tester.goldenTest(
        iconAlignmentWidget,
        'buttons_icon_alignment',
        size: const Size(300, 250),
      );
    });
  });
}
