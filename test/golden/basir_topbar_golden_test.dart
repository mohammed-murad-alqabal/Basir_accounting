import 'package:basir_accounting_system/core/theme/app_theme.dart';
import 'package:basir_accounting_system/core/theme/font_manager.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:basir_accounting_system/shared/widgets/basir_topbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(FontManager.initialize);

  Widget buildGoldenApp({required double width}) => MaterialApp(
        theme: AppTheme.lightTheme,
        locale: const Locale('ar'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('ar'), Locale('en')],
        debugShowCheckedModeBanner: false,
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: MediaQuery(
            data: MediaQueryData(size: Size(width, 120)),
            child: Scaffold(
              body: Builder(
                builder: (context) => BasirTopBar(
                  appIcons: null,
                  l10n: AppLocalizations.of(context),
                  collapsed: false,
                  orgName: 'شركة بصير للتجارة',
                  branchName: 'الفرع الرئيسي',
                  periodName: 'الفترة المالية الحالية',
                ),
              ),
            ),
          ),
        ),
      );

  Future<void> pumpAtSize(WidgetTester tester, double width) async {
    tester.view.physicalSize = Size(width, 120);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(buildGoldenApp(width: width));
    await tester.pumpAndSettle();
  }

  testWidgets('desktop topbar preserves the Arabic visual contract', (
    tester,
  ) async {
    await pumpAtSize(tester, 1280);

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/basir_topbar_ar_desktop.png'),
    );
  });

  testWidgets('compact topbar keeps context chips icon-first', (tester) async {
    await pumpAtSize(tester, 560);

    expect(find.text('شركة بصير للتجارة'), findsNothing);
    expect(find.text('الفرع الرئيسي'), findsNothing);
    expect(find.text('الفترة المالية الحالية'), findsNothing);

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/basir_topbar_ar_compact.png'),
    );
  });
}
