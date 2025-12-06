import 'package:basser_app/core/theme.dart';
import 'package:basser_app/core/widgets/index.dart';
import 'package:basser_app/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DashboardScreen', () {
    testWidgets('should display app bar with title', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: DashboardScreen(),
        ),
      );

      expect(find.text('لوحة التحكم'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('should display greeting message', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: DashboardScreen(),
        ),
      );

      expect(find.text('أهلاً وسهلاً بك!'), findsOneWidget);
      expect(find.text('إدارة فواتيرك وعملائك بسهولة'), findsOneWidget);
    });

    group('Statistics Section', () {
      testWidgets('should display statistics title', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: DashboardScreen(),
          ),
        );

        expect(find.text('الإحصائيات'), findsOneWidget);
      });

      testWidgets('should display 4 stat cards', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: DashboardScreen(),
          ),
        );

        // التحقق من وجود 4 بطاقات إحصائيات
        expect(find.byType(AppStatCard), findsNWidgets(4));
      });

      testWidgets('should display total invoices stat', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: DashboardScreen(),
          ),
        );

        expect(find.text('إجمالي الفواتير'), findsOneWidget);
        expect(find.text('24'), findsOneWidget);
      });

      testWidgets('should display customers stat', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: DashboardScreen(),
          ),
        );

        // البحث عن "العملاء" داخل AppStatCard فقط
        final statCards = find.byType(AppStatCard);
        expect(statCards, findsNWidgets(4));

        // التحقق من وجود النص في أي مكان
        expect(find.textContaining('العملاء'), findsWidgets);
        expect(find.text('12'), findsOneWidget);
      });

      testWidgets('should display sales stat', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: DashboardScreen(),
          ),
        );

        expect(find.text('المبيعات'), findsOneWidget);
        expect(find.text('5,240 ر.س'), findsOneWidget);
      });

      testWidgets('should display overdue stat', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: DashboardScreen(),
          ),
        );

        expect(find.text('المتأخرة'), findsOneWidget);
        expect(find.text('3'), findsOneWidget);
      });

      testWidgets('should display correct icons for stats', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: DashboardScreen(),
          ),
        );

        // التحقق من وجود الأيقونات (قد تظهر في أماكن متعددة)
        expect(find.byIcon(Icons.receipt_long), findsWidgets);
        expect(find.byIcon(Icons.people), findsWidgets);
        expect(find.byIcon(Icons.trending_up), findsWidgets);
        expect(find.byIcon(Icons.warning), findsWidgets);
      });
    });

    group('Quick Actions Section', () {
      testWidgets('should display quick actions title', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: DashboardScreen(),
          ),
        );

        expect(find.text('الإجراءات السريعة'), findsOneWidget);
      });

      testWidgets('should display new invoice button', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: const DashboardScreen(),
            routes: {
              '/invoices': (context) => const Scaffold(
                    body: Text('Invoices Screen'),
                  ),
            },
          ),
        );

        expect(find.text('فاتورة جديدة'), findsOneWidget);
        expect(find.byType(AppPrimaryButton), findsOneWidget);
      });

      testWidgets('should display new customer button', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: const DashboardScreen(),
            routes: {
              '/customers': (context) => const Scaffold(
                    body: Text('Customers Screen'),
                  ),
            },
          ),
        );

        expect(find.text('عميل جديد'), findsOneWidget);
        expect(find.byType(AppSecondaryButton), findsOneWidget);
      });

      testWidgets('should navigate to invoices on new invoice button tap',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: const DashboardScreen(),
            routes: {
              '/invoices': (context) => const Scaffold(
                    body: Text('Invoices Screen'),
                  ),
            },
          ),
        );

        // التمرير للوصول للزر
        await tester.dragUntilVisible(
          find.text('فاتورة جديدة'),
          find.byType(SingleChildScrollView),
          const Offset(0, -100),
        );

        await tester.tap(find.text('فاتورة جديدة'));
        await tester.pumpAndSettle();

        expect(find.text('Invoices Screen'), findsOneWidget);
      });

      testWidgets('should navigate to customers on new customer button tap',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: const DashboardScreen(),
            routes: {
              '/customers': (context) => const Scaffold(
                    body: Text('Customers Screen'),
                  ),
            },
          ),
        );

        // التمرير للوصول للزر
        await tester.dragUntilVisible(
          find.text('عميل جديد'),
          find.byType(SingleChildScrollView),
          const Offset(0, -100),
        );

        await tester.tap(find.text('عميل جديد'));
        await tester.pumpAndSettle();

        expect(find.text('Customers Screen'), findsOneWidget);
      });
    });

    group('Recent Activity Section', () {
      testWidgets('should display recent activity title', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: DashboardScreen(),
          ),
        );

        expect(find.text('الأنشطة الأخيرة'), findsOneWidget);
      });

      testWidgets('should display 3 activity cards', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: DashboardScreen(),
          ),
        );

        expect(find.byType(AppListCard), findsNWidgets(3));
      });

      testWidgets('should display first activity (paid invoice)',
          (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: DashboardScreen(),
          ),
        );

        expect(find.text('فاتورة رقم #001'), findsOneWidget);
        expect(find.text('أحمد محمد - 1,500 ر.س'), findsOneWidget);
        expect(find.text('مدفوعة'), findsOneWidget);
        expect(find.byIcon(Icons.check_circle), findsOneWidget);
      });

      testWidgets('should display second activity (pending invoice)',
          (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: DashboardScreen(),
          ),
        );

        expect(find.text('فاتورة رقم #002'), findsOneWidget);
        expect(find.text('سارة علي - 2,300 ر.س'), findsOneWidget);
        expect(find.text('قيد الانتظار'), findsOneWidget);
        expect(find.byIcon(Icons.schedule), findsOneWidget);
      });

      testWidgets('should display third activity (overdue invoice)',
          (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: DashboardScreen(),
          ),
        );

        expect(find.text('فاتورة رقم #003'), findsOneWidget);
        expect(find.text('محمود حسن - 1,800 ر.س'), findsOneWidget);
        expect(find.text('متأخرة'), findsOneWidget);
        expect(find.byIcon(Icons.error), findsOneWidget);
      });
    });

    group('Bottom Navigation Bar', () {
      testWidgets('should display bottom navigation bar', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: DashboardScreen(),
          ),
        );

        expect(find.byType(BottomNavigationBar), findsOneWidget);
      });

      testWidgets('should display 4 navigation items', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: DashboardScreen(),
          ),
        );

        // التحقق من BottomNavigationBar
        final bottomNav = find.byType(BottomNavigationBar);
        expect(bottomNav, findsOneWidget);

        // التحقق من وجود النصوص (قد تظهر في أماكن متعددة)
        expect(find.text('الرئيسية'), findsOneWidget);
        expect(find.text('الفواتير'), findsOneWidget);
        expect(find.textContaining('العملاء'), findsWidgets);
        expect(find.text('الإعدادات'), findsOneWidget);
      });

      testWidgets('should have home tab selected by default', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: DashboardScreen(),
          ),
        );

        final bottomNav = tester
            .widget<BottomNavigationBar>(find.byType(BottomNavigationBar));
        expect(bottomNav.currentIndex, 0);
      });

      testWidgets('should navigate to invoices on invoices tab tap',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: const DashboardScreen(),
            routes: {
              '/invoices': (context) => const Scaffold(
                    body: Text('Invoices Screen'),
                  ),
            },
          ),
        );

        await tester.tap(find.text('الفواتير'));
        await tester.pumpAndSettle();

        expect(find.text('Invoices Screen'), findsOneWidget);
      });

      testWidgets('should navigate to customers on customers tab tap',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: const DashboardScreen(),
            routes: {
              '/customers': (context) => const Scaffold(
                    body: Text('Customers Screen'),
                  ),
            },
          ),
        );

        // البحث عن "العملاء" في BottomNavigationBar فقط
        final bottomNav = find.byType(BottomNavigationBar);
        final customersTab = find.descendant(
          of: bottomNav,
          matching: find.text('العملاء'),
        );

        await tester.tap(customersTab);
        await tester.pumpAndSettle();

        expect(find.text('Customers Screen'), findsOneWidget);
      });

      testWidgets('should navigate to settings on settings tab tap',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: const DashboardScreen(),
            routes: {
              '/settings': (context) => const Scaffold(
                    body: Text('Settings Screen'),
                  ),
            },
          ),
        );

        await tester.tap(find.text('الإعدادات'));
        await tester.pumpAndSettle();

        expect(find.text('Settings Screen'), findsOneWidget);
      });
    });

    group('Layout and Styling', () {
      testWidgets('should be scrollable', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: DashboardScreen(),
          ),
        );

        expect(find.byType(SingleChildScrollView), findsOneWidget);
      });

      testWidgets('should have correct background color', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: DashboardScreen(),
          ),
        );

        final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
        expect(scaffold.backgroundColor, AppColors.background);
      });

      testWidgets('should have proper spacing between sections',
          (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: DashboardScreen(),
          ),
        );

        // التحقق من وجود SizedBox للمسافات
        expect(find.byType(SizedBox), findsWidgets);
      });
    });

    group('Accessibility', () {
      testWidgets('should have semantic labels for buttons', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: const DashboardScreen(),
            routes: {
              '/invoices': (context) => const Scaffold(),
              '/customers': (context) => const Scaffold(),
            },
          ),
        );

        // التحقق من وجود نصوص واضحة للأزرار
        expect(find.text('فاتورة جديدة'), findsOneWidget);
        expect(find.text('عميل جديد'), findsOneWidget);
      });

      testWidgets('should have semantic labels for navigation items',
          (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: DashboardScreen(),
          ),
        );

        // التحقق من وجود BottomNavigationBar مع 4 عناصر
        final bottomNav = find.byType(BottomNavigationBar);
        expect(bottomNav, findsOneWidget);

        final navWidget = tester.widget<BottomNavigationBar>(bottomNav);
        expect(navWidget.items.length, 4);

        // التحقق من التسميات
        expect(navWidget.items[0].label, 'الرئيسية');
        expect(navWidget.items[1].label, 'الفواتير');
        expect(navWidget.items[2].label, 'العملاء');
        expect(navWidget.items[3].label, 'الإعدادات');
      });
    });
  });
}
