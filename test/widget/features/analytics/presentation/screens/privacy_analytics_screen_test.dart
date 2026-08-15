import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/features/analytics/presentation/screens/privacy_analytics_screen.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget subject() => ProviderScope(
        overrides: [
          appIconsProvider.overrideWithValue(const MaterialAppIcons()),
          analyticsServiceProvider.overrideWithValue(null),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale('ar'),
          home: PrivacyAnalyticsScreen(),
        ),
      );

  setUp(() {
    // لا تعتمد هذه الشاشة على مستودع أو خدمة منصة عند عدم تهيئة التحليلات.
  });

  testWidgets('يعرض إشعار الخصوصية ويبدل التتبع محلياً', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(subject());
    await tester.pumpAndSettle();

    expect(find.byType(GlassScaffold), findsOneWidget);
    expect(find.byIcon(Icons.info_outline), findsOneWidget);
    final trackingSwitch = find.byType(SwitchListTile);
    expect(trackingSwitch, findsOneWidget);
    expect(tester.widget<SwitchListTile>(trackingSwitch).value, isTrue);

    await tester.tap(trackingSwitch);
    await tester.pump();

    expect(tester.widget<SwitchListTile>(trackingSwitch).value, isFalse);
  });

  testWidgets('يعرض حوار مسح البيانات ويدعم الإلغاء والتأكيد', (tester) async {
    await tester.pumpWidget(subject());
    await tester.pumpAndSettle();

    final clearTile = find.byType(ListTile).last;
    expect(find.byType(ListTile), findsNWidgets(2));
    await tester.tap(clearTile);
    await tester.pumpAndSettle();

    final dialog = find.byType(AlertDialog);
    expect(dialog, findsOneWidget);
    expect(find.textContaining('لا يمكن التراجع'), findsOneWidget);

    var actions =
        find.descendant(of: dialog, matching: find.byType(TextButton));
    expect(actions, findsNWidgets(2));
    await tester.tap(actions.first);
    await tester.pumpAndSettle();
    expect(dialog, findsNothing);

    await tester.tap(clearTile);
    await tester.pumpAndSettle();
    final confirmedDialog = find.byType(AlertDialog);
    actions = find.descendant(
      of: confirmedDialog,
      matching: find.byType(TextButton),
    );
    await tester.tap(actions.last);
    await tester.pumpAndSettle();

    expect(confirmedDialog, findsNothing);
    expect(find.byType(SnackBar), findsOneWidget);
  });
}
