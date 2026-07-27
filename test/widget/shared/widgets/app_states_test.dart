import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/shared/widgets/app_empty_state.dart';
import 'package:basir_accounting_system/shared/widgets/app_error_widget.dart';
import 'package:basir_accounting_system/shared/widgets/app_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('13.6 - اختبارات Widget للحالات الفارغة والتحميل والخطأ', () {
    testWidgets('AppEmptyState يعرض العنوان والوصف بشكل صحيح', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppEmptyState(
              title: 'لا توجد فواتير',
              description: 'قم بإنشاء فاتورة جديدة للبدء',
            ),
          ),
        ),
      );

      expect(find.text('لا توجد فواتير'), findsOneWidget);
      expect(find.text('قم بإنشاء فاتورة جديدة للبدء'), findsOneWidget);
      final titleWidget = tester.widget<Text>(find.text('لا توجد فواتير'));
      expect(titleWidget.textAlign, TextAlign.center);
    });

    testWidgets('AppEmptyState يعرض زر الإجراء وعند الضغط يُستدعى onActionPressed', (tester) async {
      var pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppEmptyState(
              title: 'قائمة فارغة',
              actionLabel: 'إضافة عنصر',
              onActionPressed: () => pressed = true,
            ),
          ),
        ),
      );

      expect(find.text('إضافة عنصر'), findsOneWidget);
      await tester.tap(find.text('إضافة عنصر'));
      await tester.pump();
      expect(pressed, isTrue);
    });

    testWidgets('AppEmptyState مع أيقونة تعرض الأيقونة بحجم 80px و padding Spacing.xl',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppEmptyState(title: 'Empty', icon: Icons.inbox),
          ),
        ),
      );

      final icon = tester.widget<Icon>(find.byIcon(Icons.inbox));
      expect(icon.size, 80);
      final padding = tester.widget<Padding>(
        find
            .descendant(
              of: find.byType(AppEmptyState),
              matching: find.byType(Padding),
            )
            .first,
      );
      expect(padding.padding, const EdgeInsets.all(Spacing.xl));
    });

    testWidgets('AppLoadingIndicator يعرض CircularProgressIndicator بحجم و stroke معطّلين',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AppLoadingIndicator(size: 48, strokeWidth: 4)),
        ),
      );

      final indicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );
      expect(indicator.strokeWidth, 4);
      expect(indicator.strokeCap, StrokeCap.round);
      final sized = tester.widget<SizedBox>(find.byType(SizedBox).first);
      expect(sized.width, 48);
      expect(sized.height, 48);
    });

    testWidgets('AppLoadingScreen يعرض 40px مؤشر تحميل في Scaffold كامل', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: AppLoadingScreen()));
      expect(find.byType(Scaffold), findsOneWidget);
      final ind = tester.widget<AppLoadingIndicator>(find.byType(AppLoadingIndicator));
      expect(ind.size, 40);
    });

    testWidgets('AppErrorWidget يعرض رسالة الخطأ وإعادة المحاولة', (tester) async {
      var retried = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppErrorWidget(
              message: 'تعذر الاتصال بالخادم',
              onRetry: () => retried = true,
            ),
          ),
        ),
      );

      expect(find.text('تعذر الاتصال بالخادم'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text('إعادة المحاولة'), findsOneWidget);

      await tester.tap(find.text('إعادة المحاولة'));
      await tester.pump();
      expect(retried, isTrue);
    });

    testWidgets('حالة بحث فارغة - AppEmptyState مع وصف وزر إضافة', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppEmptyState(
              title: 'لا توجد نتائج بحث',
              description: 'جرب كلمات مفتاحية أخرى',
              icon: Icons.search_off,
              actionLabel: 'مسح البحث',
              onActionPressed: _noopAction,
            ),
          ),
        ),
      );

      expect(find.text('لا توجد نتائج بحث'), findsOneWidget);
      expect(find.byIcon(Icons.search_off), findsOneWidget);
      expect(find.text('مسح البحث'), findsOneWidget);
    });
  });
}

void _noopAction() {}
