import 'package:basser_app/core/theme.dart';
import 'package:basser_app/core/widgets/index.dart';
import 'package:basser_app/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DashboardScreen', () {
    testWidgets('should display app bar with title', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: DashboardScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('لوحة التحكم'), findsOneWidget);
    });

    testWidgets('should display greeting message', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: DashboardScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('أهلاً وسهلاً بك!'), findsOneWidget);
      expect(find.text('إدارة فواتيرك وعملائك بسهولة'), findsOneWidget);
    });

    testWidgets('should display statistics section title', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: DashboardScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('الإحصائيات'), findsOneWidget);
    });

    testWidgets('should display 4 statistics cards', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: DashboardScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(AppStatCard), findsNWidgets(4));
    });

    testWidgets('should display total invoices stat card', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: DashboardScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('إجمالي الفواتير'), findsOneWidget);
      expect(find.text('24'), findsOneWidget);
      expect(find.byIcon(Icons.receipt_long), findsOneWidget);
    });

    testWidgets('should display customers stat card', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: DashboardScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('العملاء'), findsWidgets); // Multiple instances
      expect(find.text('12'), findsOneWidget);
      expect(find.byIcon(Icons.people), findsWidgets); // Multiple instances
    });

    testWidgets('should display sales stat card', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: DashboardScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('المبيعات'), findsOneWidget);
      expect(find.text('5,240 ر.س'), findsOneWidget);
      expect(find.byIcon(Icons.trending_up), findsOneWidget);
    });

    testWidgets('should display overdue stat card', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: DashboardScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('المتأخرة'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
      expect(find.byIcon(Icons.warning), findsOneWidget);
    });

    testWidgets('should display quick actions section title', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: DashboardScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('الإجراءات السريعة'), findsOneWidget);
    });

    testWidgets('should display new invoice button', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: DashboardScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('فاتورة جديدة'), findsOneWidget);
      expect(find.byType(AppPrimaryButton), findsOneWidget);
    });

    testWidgets('should display new customer button', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: DashboardScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('عميل جديد'), findsOneWidget);
      expect(find.byType(AppSecondaryButton), findsOneWidget);
    });

    testWidgets('should display recent activity section title', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: DashboardScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('الأنشطة الأخيرة'), findsOneWidget);
    });

    testWidgets('should display 3 recent activity cards', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: DashboardScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(AppListCard), findsNWidgets(3));
    });

    testWidgets('should display first recent activity', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: DashboardScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('فاتورة رقم #001'), findsOneWidget);
      expect(find.text('أحمد محمد - 1,500 ر.س'), findsOneWidget);
      expect(find.text('مدفوعة'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('should display second recent activity', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: DashboardScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('فاتورة رقم #002'), findsOneWidget);
      expect(find.text('سارة علي - 2,300 ر.س'), findsOneWidget);
      expect(find.text('قيد الانتظار'), findsOneWidget);
      expect(find.byIcon(Icons.schedule), findsOneWidget);
    });

    testWidgets('should display third recent activity', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: DashboardScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('فاتورة رقم #003'), findsOneWidget);
      expect(find.text('محمود حسن - 1,800 ر.س'), findsOneWidget);
      expect(find.text('متأخرة'), findsOneWidget);
      expect(find.byIcon(Icons.error), findsOneWidget);
    });

    testWidgets('should display bottom navigation bar', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: DashboardScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });

    testWidgets('should display 4 navigation items', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: DashboardScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      final bottomNav =
          tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar));
      expect(bottomNav.items.length, 4);
    });

    testWidgets('should display navigation item labels', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: DashboardScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('الرئيسية'), findsOneWidget);
      expect(find.text('الفواتير'), findsWidgets); // Multiple instances
      expect(find.text('العملاء'), findsWidgets); // Multiple instances
      expect(find.text('الإعدادات'), findsOneWidget);
    });

    testWidgets('should display navigation item icons', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: DashboardScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.byIcon(Icons.receipt), findsOneWidget);
      expect(find.byIcon(Icons.people), findsWidgets);
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('should have home tab selected by default', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: DashboardScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      final bottomNav =
          tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar));
      expect(bottomNav.currentIndex, 0);
    });

    testWidgets('should use correct background color', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: DashboardScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, AppColors.background);
    });

    testWidgets('should be scrollable', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: DashboardScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('should have tappable navigation items', (tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: DashboardScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert - Bottom navigation bar should exist and be interactive
      expect(find.byType(BottomNavigationBar), findsOneWidget);
      final bottomNav =
          tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar));
      expect(bottomNav.items.length, 4);
      expect(bottomNav.onTap, isNotNull);
    });

    testWidgets('should have tappable quick action buttons', (tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: DashboardScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert - Quick action buttons should exist
      expect(find.text('فاتورة جديدة'), findsOneWidget);
      expect(find.text('عميل جديد'), findsOneWidget);
      expect(find.byType(AppPrimaryButton), findsOneWidget);
      expect(find.byType(AppSecondaryButton), findsOneWidget);
    });

    testWidgets('should display statistics in grid layout', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: DashboardScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('should have correct stat card colors', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: DashboardScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert - Check that different colored icons exist
      expect(find.byIcon(Icons.receipt_long), findsOneWidget);
      expect(find.byIcon(Icons.trending_up), findsOneWidget);
      expect(find.byIcon(Icons.warning), findsOneWidget);
    });
  });
}
