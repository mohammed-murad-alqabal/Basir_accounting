/// اختبارات AppCard
library;

import 'package:basser_app/core/theme.dart';
import 'package:basser_app/core/widgets/app_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppCard', () {
    testWidgets('should display child widget', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AppCard(child: Text('محتوى البطاقة'))),
        ),
      );

      expect(find.text('محتوى البطاقة'), findsOneWidget);
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

    testWidgets('should use custom background color', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppCard(backgroundColor: Colors.red, child: Text('محتوى')),
          ),
        ),
      );

      final card = tester.widget<Card>(find.byType(Card));
      expect(card.color, Colors.red);
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
      expect(icon.color, AppColors.primary);
    });
  });
}
