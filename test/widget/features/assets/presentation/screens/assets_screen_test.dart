import 'package:basir_accounting_system/core/assets/app_illustrations.dart';
import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/core/theme/tokens/app_icons.dart';
import 'package:basir_accounting_system/features/assets/domain/entities/fixed_asset.dart';
import 'package:basir_accounting_system/features/assets/presentation/providers/asset_provider.dart';
import 'package:basir_accounting_system/features/assets/presentation/screens/assets_screen.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final serverAsset = FixedAsset(
    id: 'asset-server-1',
    code: 'AST-001',
    nameAr: 'خادم محاسبي',
    nameEn: 'Accounting Server',
    categoryId: 'it',
    acquisitionDate: DateTime(2025),
    cost: 12500,
    residualValue: 2500,
    usefulLifeYears: 5,
    depreciationMethod: 'straight_line',
    assetAccountId: 'asset-account',
    depreciationAccountId: 'expense-account',
    accumDepreciationAccountId: 'accumulated-account',
  );

  Widget subject({
    required AsyncValue<List<FixedAsset>> assets,
    ProviderContainer? container,
  }) {
    final overrides = [
      appIconsProvider.overrideWithValue(const MaterialAppIcons()),
      filteredAssetsProvider.overrideWithValue(assets),
    ];
    const app = MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale('ar'),
      home: AssetsScreen(),
    );
    return container == null
        ? ProviderScope(overrides: overrides, child: app)
        : UncontrolledProviderScope(container: container, child: app);
  }

  setUp(() {
    // مساحة هاتف عمودية تكشف شريط البحث وأول صف بصورة حتمية.
  });

  group('AssetsScreen', () {
    testWidgets('يعرض مؤشّر التحميل أثناء انتظار الأصول', (tester) async {
      await tester.pumpWidget(subject(assets: const AsyncLoading()));
      await tester.pump();

      expect(find.byType(AppLoadingIndicator), findsOneWidget);
    });

    testWidgets('يعرض رسالة خطأ قابلة لإعادة المحاولة عند فشل التحميل',
        (tester) async {
      await tester.pumpWidget(
        subject(
          assets: AsyncValue.error(
            StateError('asset repository unavailable'),
            StackTrace.empty,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AppErrorWidget), findsOneWidget);
      expect(
        find.textContaining('asset repository unavailable'),
        findsOneWidget,
      );
    });

    testWidgets('يعرض الرسم الفارغ عند غياب الأصول', (tester) async {
      await tester.pumpWidget(subject(assets: const AsyncValue.data([])));
      await tester.pumpAndSettle();

      expect(find.byType(EmptyStateIllustration), findsOneWidget);
    });

    testWidgets('يعرض بيانات الأصل بسياق عربي ودلالة وصول مفيدة',
        (tester) async {
      await tester.pumpWidget(
        subject(assets: AsyncValue.data([serverAsset])),
      );
      await tester.pumpAndSettle();

      expect(find.text('خادم محاسبي'), findsOneWidget);
      expect(find.text('AST-001'), findsOneWidget);
      expect(find.textContaining('12500.00'), findsOneWidget);
      expect(
        find.bySemanticsLabel(RegExp('خادم محاسبي, AST-001, 12500.0')),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.business_center), findsOneWidget);
    });

    testWidgets('يربط حقل البحث بحالة مزود البحث للأصول', (tester) async {
      final container = ProviderContainer(
        overrides: [
          appIconsProvider.overrideWithValue(const MaterialAppIcons()),
          filteredAssetsProvider
              .overrideWithValue(AsyncValue.data([serverAsset])),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        subject(assets: AsyncValue.data([serverAsset]), container: container),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'خادم');
      await tester.pump();

      expect(container.read(assetSearchQueryProvider), 'خادم');
    });
  });
}
