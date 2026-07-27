/// اختبارات AppCard
library;

import 'package:basir_accounting_system/core/theme/app_theme.dart';
import 'package:basir_accounting_system/core/theme/border_contrast_design.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/shared/widgets/app_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppCard', () {
    testWidgets('should display child widget (light mode)', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(body: AppCard(child: Text('محتوى البطاقة'))),
        ),
      );

      expect(find.text('محتوى البطاقة'), findsOneWidget);
    });

    testWidgets('should display child widget (dark mode)', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const Scaffold(body: AppCard(child: Text('محتوى البطاقة'))),
        ),
      );

      expect(find.text('محتوى البطاقة'), findsOneWidget);
    });

    testWidgets('should display isSelected border (light mode)', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: AppCard(
              isSelected: true,
              child: Text('محتوى'),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(AppCard),
              matching: find.byType(Container),
            )
            .first,
      );
      expect(
        (container.decoration! as BoxDecoration).border?.top.color,
        BorderContrastDesign.borderFocusedLight,
      );
      expect(
        (container.decoration! as BoxDecoration).border?.top.width,
        BorderWidths.normal,
      );
    });

    testWidgets('should display isSelected border (dark mode)', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const Scaffold(
            body: AppCard(
              isSelected: true,
              child: Text('محتوى'),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(AppCard),
              matching: find.byType(Container),
            )
            .first,
      );
      expect(
        (container.decoration! as BoxDecoration).border?.top.color,
        BorderContrastDesign.borderFocusedDark,
      );
    });

    testWidgets('should call onTap', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppCard(
              onTap: () => tapped = true,
              child: const Text('اضغط هنا'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('اضغط هنا'));
      expect(tapped, true);
    });

    testWidgets('should call onLongPress', (tester) async {
      var longPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppCard(
              onLongPress: () => longPressed = true,
              child: const Text('اضغط مطولاً'),
            ),
          ),
        ),
      );

      await tester.longPress(find.text('اضغط مطولاً'));
      expect(longPressed, true);
    });

    testWidgets('should use custom padding', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppCard(padding: EdgeInsets.all(32), child: Text('محتوى')),
          ),
        ),
      );

      final padding = tester.widgetList<Padding>(find.byType(Padding)).last;
      expect(padding.padding, const EdgeInsets.all(32));
    });

    testWidgets('should use custom margin', (tester) async {
      const testMargin = EdgeInsets.all(16);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppCard(
              margin: testMargin,
              child: Text('محتوى'),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(AppCard),
              matching: find.byType(Container),
            )
            .first,
      );
      expect(container.margin, testMargin);
    });

    testWidgets('should use custom background color', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppCard(backgroundColor: Colors.red, child: Text('محتوى')),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(AppCard),
              matching: find.byType(Container),
            )
            .first,
      );
      expect(container.decoration, isA<BoxDecoration>());
      expect((container.decoration! as BoxDecoration).color, Colors.red);
    });

    testWidgets('should use custom elevation', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppCard(elevation: 8, child: Text('محتوى')),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(AppCard),
              matching: find.byType(Container),
            )
            .first,
      );
      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.boxShadow, isNotNull);
      expect(decoration.boxShadow!.first.blurRadius, 16);
    });

    testWidgets('should display badge success', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: AppCard(
              badgeText: 'ناجح',
              badgeStatus: CardBadgeStatus.success,
              child: Text('محتوى'),
            ),
          ),
        ),
      );

      expect(find.text('ناجح'), findsOneWidget);

      final badgeContainer = tester.widget<Container>(
        find
            .ancestor(
              of: find.text('ناجح'),
              matching: find.byType(Container),
            )
            .first,
      );
      final boxDeco = badgeContainer.decoration! as BoxDecoration;
      expect(boxDeco.color, AppColors.success);
    });

    testWidgets('should display badge error', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: AppCard(
              badgeText: 'خطأ',
              badgeStatus: CardBadgeStatus.error,
              child: Text('محتوى'),
            ),
          ),
        ),
      );

      expect(find.text('خطأ'), findsOneWidget);
      final badgeContainer = tester.widget<Container>(
        find
            .ancestor(
              of: find.text('خطأ'),
              matching: find.byType(Container),
            )
            .first,
      );
      final boxDeco = badgeContainer.decoration! as BoxDecoration;
      expect(boxDeco.color, AppColors.error);
    });

    testWidgets('should display badge warning', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: AppCard(
              badgeText: 'تحذير',
              badgeStatus: CardBadgeStatus.warning,
              child: Text('محتوى'),
            ),
          ),
        ),
      );

      expect(find.text('تحذير'), findsOneWidget);
      final badgeContainer = tester.widget<Container>(
        find
            .ancestor(
              of: find.text('تحذير'),
              matching: find.byType(Container),
            )
            .first,
      );
      final boxDeco = badgeContainer.decoration! as BoxDecoration;
      expect(boxDeco.color, AppColors.warning);
    });

    testWidgets('should display badge info', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: AppCard(
              badgeText: 'معلومة',
              child: Text('محتوى'),
            ),
          ),
        ),
      );

      expect(find.text('معلومة'), findsOneWidget);
      final badgeContainer = tester.widget<Container>(
        find
            .ancestor(
              of: find.text('معلومة'),
              matching: find.byType(Container),
            )
            .first,
      );
      final boxDeco = badgeContainer.decoration! as BoxDecoration;
      expect(boxDeco.color, AppColors.info);
    });

    testWidgets('should display custom badge color', (tester) async {
      const customColor = Colors.purple;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppCard(
              badgeText: 'مخصص',
              badgeStatus: CardBadgeStatus.custom,
              badgeColor: customColor,
              child: Text('محتوى'),
            ),
          ),
        ),
      );

      expect(find.text('مخصص'), findsOneWidget);
      final badgeContainer = tester.widget<Container>(
        find
            .ancestor(
              of: find.text('مخصص'),
              matching: find.byType(Container),
            )
            .first,
      );
      final boxDeco = badgeContainer.decoration! as BoxDecoration;
      expect(boxDeco.color, customColor);
    });

    testWidgets('should not display badge when text is empty', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppCard(
              badgeText: '',
              badgeStatus: CardBadgeStatus.success,
              child: Text('محتوى'),
            ),
          ),
        ),
      );

      expect(
        find.byWidgetPredicate(
          (w) => w is Semantics && (w.properties.label?.contains('شارة الحالة') ?? false),
        ),
        findsNothing,
      );
    });

    testWidgets('should display badge with custom alignment topStart', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppCard(
              badgeText: 'جديد',
              badgeAlignment: AlignmentDirectional.topStart,
              child: Text('محتوى'),
            ),
          ),
        ),
      );

      expect(find.text('جديد'), findsOneWidget);
    });

    testWidgets('should display statusColor bar', (tester) async {
      const statusColor = Colors.green;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppCard(
              statusColor: statusColor,
              child: Text('محتوى'),
            ),
          ),
        ),
      );

      final statusBars = find.byWidgetPredicate((w) {
        if (w is! Container) return false;
        final deco = w.decoration;
        if (deco is! BoxDecoration) return false;
        return deco.color == statusColor && w.constraints?.minWidth == BorderWidths.thick;
      });

      expect(statusBars, findsOneWidget);
    });

    testWidgets('should have Semantics wrapper when onTap provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppCard(
              semanticLabel: 'بطاقة العملاء',
              onTap: () {},
              child: const Text('العملاء'),
            ),
          ),
        ),
      );

      final semanticsWrapper = find.descendant(
        of: find.byType(AppCard),
        matching: find.byType(Semantics),
      );
      expect(semanticsWrapper, findsWidgets);

      final semanticsData = tester.getSemantics(find.text('العملاء').hitTestable().first);
      expect(semanticsData.label, contains('بطاقة العملاء'));
    });

    testWidgets('should have default Semantics wrapper without interaction', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppCard(
              child: Text('بطاقة معلوماتية'),
            ),
          ),
        ),
      );

      final semanticsWrapper = find.descendant(
        of: find.byType(AppCard),
        matching: find.byType(Semantics),
      );
      expect(semanticsWrapper, findsWidgets);
    });

    testWidgets('should pass semanticLabel to Semantics wrapper', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppCard(
              semanticLabel: 'بطاقة فاتورة رقم 123',
              child: Text('فاتورة'),
            ),
          ),
        ),
      );

      final semanticsData = tester.getSemantics(find.text('فاتورة').hitTestable().first);
      expect(semanticsData.label, contains('فاتورة رقم 123'));
    });

    testWidgets('should not call onTap when disabled (no onTap)', (tester) async {
      const tapped = false;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppCard(
              child: Text('غير تفاعلي'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('غير تفاعلي'));
      expect(tapped, false);
    });

    testWidgets('should use custom borderRadius', (tester) async {
      const customRadius = BorderRadius.all(Radius.circular(24));

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppCard(
              borderRadius: customRadius,
              child: Text('محتوى'),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(AppCard),
              matching: find.byType(Container),
            )
            .first,
      );
      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.borderRadius, customRadius);
    });

    testWidgets('should respect isSelected in Semantics wrapper', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppCard(
              isSelected: true,
              onTap: () {},
              semanticLabel: 'بطاقة مختارة',
              child: const Text('محتوى'),
            ),
          ),
        ),
      );

      final semanticsWrapper = find.descendant(
        of: find.byType(AppCard),
        matching: find.byType(Semantics),
      );
      expect(semanticsWrapper, findsWidgets);

      final semanticsData = tester.getSemantics(find.text('محتوى').hitTestable().first);
      expect(semanticsData.label, contains('بطاقة مختارة'));
    });
  });

  group('AppListCard', () {
    testWidgets('should display title', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AppListCard(title: 'أحمد محمد')),
        ),
      );

      expect(find.text('أحمد محمد'), findsOneWidget);
    });

    testWidgets('should display subtitle', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppListCard(title: 'أحمد محمد', subtitle: '0501234567'),
          ),
        ),
      );

      expect(find.text('0501234567'), findsOneWidget);
    });

    testWidgets('should display trailing text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppListCard(title: 'أحمد محمد', trailing: '5 فواتير'),
          ),
        ),
      );

      expect(find.text('5 فواتير'), findsOneWidget);
    });

    testWidgets('should display trailing widget', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppListCard(
              title: 'أحمد محمد',
              trailing: Icon(Icons.check_circle),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('should display leading widget', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppListCard(title: 'أحمد محمد', leading: Icon(Icons.person)),
          ),
        ),
      );

      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('should call onTap', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppListCard(title: 'أحمد محمد', onTap: () => tapped = true),
          ),
        ),
      );

      await tester.tap(find.text('أحمد محمد'));
      expect(tapped, true);
    });

    testWidgets('should call onLongPress', (tester) async {
      var longPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppListCard(
              title: 'أحمد محمد',
              onLongPress: () => longPressed = true,
            ),
          ),
        ),
      );

      await tester.longPress(find.text('أحمد محمد'));
      expect(longPressed, true);
    });

    testWidgets('should have isSelected state and border', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: AppListCard(
              title: 'أحمد محمد',
              isSelected: true,
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(AppCard),
              matching: find.byType(Container),
            )
            .first,
      );
      expect(
        (container.decoration! as BoxDecoration).border?.top.color,
        BorderContrastDesign.borderFocusedLight,
      );
    });

    testWidgets('should include title subtitle trailing in semanticLabel', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppListCard(
              title: 'أحمد محمد',
              subtitle: 'جدة',
              trailing: '10 فواتير',
            ),
          ),
        ),
      );

      final semanticsWrapper = find.descendant(
        of: find.byType(AppListCard),
        matching: find.byType(Semantics),
      );
      expect(semanticsWrapper, findsWidgets);

      final semanticsData = tester.getSemantics(find.text('أحمد محمد').hitTestable().first);
      final label = semanticsData.label;
      expect(label, contains('أحمد محمد'));
      expect(label, contains('جدة'));
      expect(label, contains('10 فواتير'));
    });
  });

  group('AppStatCard', () {
    testWidgets('should display label', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppStatCard(
              label: 'إجمالي الفواتير',
              value: '150',
              icon: Icons.receipt,
            ),
          ),
        ),
      );

      expect(find.text('إجمالي الفواتير'), findsOneWidget);
    });

    testWidgets('should display value', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppStatCard(
              label: 'إجمالي الفواتير',
              value: '150',
              icon: Icons.receipt,
            ),
          ),
        ),
      );

      expect(find.text('150'), findsOneWidget);
    });

    testWidgets('should display icon', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppStatCard(
              label: 'إجمالي الفواتير',
              value: '150',
              icon: Icons.receipt,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.receipt), findsOneWidget);
    });

    testWidgets('should use custom icon color', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppStatCard(
              label: 'إجمالي الفواتير',
              value: '150',
              icon: Icons.receipt,
              iconColor: Colors.red,
            ),
          ),
        ),
      );

      final icon = tester.widget<Icon>(find.byIcon(Icons.receipt));
      expect(icon.color, Colors.red);
    });

    testWidgets('should use default icon color', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppStatCard(
              label: 'إجمالي الفواتير',
              value: '150',
              icon: Icons.receipt,
            ),
          ),
        ),
      );

      final icon = tester.widget<Icon>(find.byIcon(Icons.receipt));
      expect(icon.color, AppTheme.lightTheme.colorScheme.primary);
    });

    testWidgets('should use 24px icon size (IconSizes.md)', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppStatCard(
              label: 'العملاء',
              value: '25',
              icon: Icons.people,
            ),
          ),
        ),
      );

      final icon = tester.widget<Icon>(find.byIcon(Icons.people));
      expect(icon.size, IconSizes.md);
    });

    testWidgets('should use custom backgroundColor', (tester) async {
      const bgColor = Color(0xFFF5F5F5);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppStatCard(
              label: 'العملاء',
              value: '25',
              icon: Icons.people,
              backgroundColor: bgColor,
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(AppCard),
              matching: find.byType(Container),
            )
            .first,
      );
      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.color, bgColor);
    });
  });
}
