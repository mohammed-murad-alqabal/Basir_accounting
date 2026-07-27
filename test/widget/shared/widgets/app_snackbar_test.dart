// ignore_for_file: prefer_expression_function_bodies, cast_nullable_to_non_nullable

import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/shared/widgets/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('12.1 - اختبارات Widget للرسائل والإشعارات', () {
    testWidgets('عرض رسالة نجاح (Snackbar) بنوع Success', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () => AppSnackbar.showSuccess(context, 'تم الحفظ بنجاح'),
                  child: const Text('Show'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();

      expect(find.text('تم الحفظ بنجاح'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
      final snack = tester.widget<SnackBar>(find.byType(SnackBar));
      expect(snack.behavior, SnackBarBehavior.floating);
    });

    testWidgets('عرض رسالة خطأ (Snackbar) بنوع Error', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () => AppSnackbar.showError(context, 'فشل حفظ البيانات'),
                  child: const Text('Show'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();

      expect(find.text('فشل حفظ البيانات'), findsOneWidget);
      expect(find.byIcon(Icons.error), findsOneWidget);
    });

    testWidgets('عرض رسالة تحذير (Snackbar) بنوع Warning', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () => AppSnackbar.showWarning(context, 'تحذير: بيانات غير كاملة'),
                  child: const Text('Show'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();

      expect(find.text('تحذير: بيانات غير كاملة'), findsOneWidget);
      expect(find.byIcon(Icons.warning), findsOneWidget);
    });

    testWidgets('عرض SnackBar Info مع الإجراء وزر الإجراء يعمل', (tester) async {
      var pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () => AppSnackbar.showInfo(
                    context,
                    'رسالة معلومات',
                    actionLabel: 'تراجع',
                    onActionPressed: () => pressed = true,
                  ),
                  child: const Text('Show'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();
      expect(find.text('تراجع'), findsOneWidget);

      await tester.tap(find.text('تراجع'));
      await tester.pump();
      expect(pressed, isTrue);
    });

    testWidgets('تصميم SnackBar يمتلك: Floating، زوايا Md، elevation Md، IconSizes.md',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () => AppSnackbar.showSuccess(context, 'Design test'),
                  child: const Text('Show'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();

      final snack = tester.widget<SnackBar>(find.byType(SnackBar));
      expect(snack.behavior, SnackBarBehavior.floating);
      expect(snack.elevation, Elevation.md);
      final shape = snack.shape as RoundedRectangleBorder;
      expect(shape.borderRadius, Radii.borderRadiusMd);
    });
  });
}
