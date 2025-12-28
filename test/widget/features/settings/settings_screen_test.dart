import 'package:basser_app/core/theme/app_theme.dart';
import 'package:basser_app/core/widgets/index.dart';
import 'package:basser_app/features/settings/presentation/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SettingsScreen', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    Widget createTestWidget() => UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const SettingsScreen(),
          ),
        );

    group('Basic Display', () {
      testWidgets('should display app bar with title', (tester) async {
        await tester.pumpWidget(createTestWidget());
        expect(find.widgetWithText(AppBar, 'الإعدادات'), findsOneWidget);
        expect(find.byType(AppAppBar), findsOneWidget);
      });

      testWidgets('should display all section titles', (tester) async {
        await tester.pumpWidget(createTestWidget());
        expect(find.text('الحساب'), findsOneWidget);
        expect(find.text('الإشعارات'), findsOneWidget);
        expect(find.text('المظهر'), findsOneWidget);
        expect(find.text('المساعدة والدعم'), findsOneWidget);
      });
    });
  });
}
