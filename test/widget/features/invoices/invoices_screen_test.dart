import 'package:basir_accounting_system/core/assets/app_illustrations.dart';
import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/core/providers/supabase_auth_provider.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/features/auth/domain/models/auth_models.dart';
import 'package:basir_accounting_system/features/invoices/presentation/providers/invoice_provider.dart';
import 'package:basir_accounting_system/features/invoices/presentation/screens/invoices_screen.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/mock_data.dart';

void main() {
  group('InvoicesScreen Tests', () {
    testWidgets('should display app bar with title', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appIconsProvider.overrideWithValue(const MaterialAppIcons()),
            currentUserProfileProvider.overrideWith(
              (ref) => const BasirUser(
                id: 'test-user',
                email: 'test@example.com',
                displayName: 'Test User',
                role: UserRole.admin,
              ),
            ),
            currentUserProvider.overrideWith((ref) => null),
            filteredInvoicesProvider.overrideWithValue(
              const AsyncValue.data([]),
            ),
            invoiceStatisticsProvider.overrideWithValue(
              AsyncValue.data(
                InvoiceStatistics(
                  totalInvoices: 0,
                  paidInvoices: 0,
                  overdueInvoices: 0,
                  totalAmount: Decimal.zero,
                ),
              ),
            ),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale('ar'),
            home: InvoicesScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('الفواتير'), findsOneWidget);
    });

    testWidgets('should display empty state when no invoices', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appIconsProvider.overrideWithValue(const MaterialAppIcons()),
            currentUserProfileProvider.overrideWith(
              (ref) => const BasirUser(
                id: 'test-user',
                email: 'test@example.com',
                displayName: 'Test User',
                role: UserRole.admin,
              ),
            ),
            currentUserProvider.overrideWith((ref) => null),
            filteredInvoicesProvider.overrideWithValue(
              const AsyncValue.data([]),
            ),
            invoiceStatisticsProvider.overrideWithValue(
              AsyncValue.data(
                InvoiceStatistics(
                  totalInvoices: 0,
                  paidInvoices: 0,
                  overdueInvoices: 0,
                  totalAmount: Decimal.zero,
                ),
              ),
            ),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale('ar'),
            home: InvoicesScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert basir Strings
      expect(find.text('سجل الفواتير الذكي منظم'), findsOneWidget);
      expect(find.text('فاتورتك الأولى بانتظارك'), findsOneWidget);
      expect(find.byType(EmptyStateIllustration), findsOneWidget);
    });

    // ignore: lines_longer_than_80_chars
    testWidgets('should display invoice list when data is available', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final invoice = MockData.createTestInvoice(id: 'inv-1');
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appIconsProvider.overrideWithValue(const MaterialAppIcons()),
            currentUserProfileProvider.overrideWith(
              (ref) => const BasirUser(
                id: 'test-user',
                email: 'test@example.com',
                displayName: 'Test User',
                role: UserRole.admin,
              ),
            ),
            currentUserProvider.overrideWith((ref) => null),
            filteredInvoicesProvider.overrideWithValue(
              AsyncValue.data([invoice]),
            ),
            invoiceStatisticsProvider.overrideWithValue(
              AsyncValue.data(
                InvoiceStatistics(
                  totalInvoices: 1,
                  paidInvoices: 0,
                  overdueInvoices: 0,
                  totalAmount: Decimal.fromInt(1000),
                ),
              ),
            ),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale('ar'),
            home: InvoicesScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('فاتورة رقم INV-inv-1'), findsOneWidget);
    });

    testWidgets(
      'should display dates in Hijri when calendar preference is Hijri',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        // 2023-10-27 is 1445-04-12 in Hijri
        final date = DateTime(2023, 10, 27);
        final invoice = MockData.createTestInvoice(
          id: 'inv-1',
        ).copyWith(issuedDate: date);

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              appIconsProvider.overrideWithValue(const MaterialAppIcons()),
              currentUserProfileProvider.overrideWith(
                (ref) => const BasirUser(
                  id: 'test-user',
                  email: 'test@example.com',
                  displayName: 'Test User',
                  role: UserRole.admin,
                ),
              ),
              currentUserProvider.overrideWith((ref) => null),
              calendarProvider.overrideWith(
                () => _MockCalendarNotifier(CalendarType.hijri),
              ),
              filteredInvoicesProvider.overrideWithValue(
                AsyncValue.data([invoice]),
              ),
              invoiceStatisticsProvider.overrideWithValue(
                AsyncValue.data(
                  InvoiceStatistics(
                    totalInvoices: 1,
                    paidInvoices: 0,
                    overdueInvoices: 0,
                    totalAmount: Decimal.fromInt(1000),
                  ),
                ),
              ),
            ],
            child: const MaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: Locale('ar'),
              home: InvoicesScreen(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Check for Hijri year "١٤٤٥" and month "ربيع"
        expect(find.textContaining('١٤٤٥'), findsOneWidget);
      },
    );
  });

  group('InvoicesScreen - UI/UX Improvements (Task 17)', () {
    Widget createTestWidget({
      required List<Override> overrides,
      Locale locale = const Locale('ar'),
    }) =>
        ProviderScope(
          overrides: [
            appIconsProvider.overrideWithValue(const MaterialAppIcons()),
            currentUserProfileProvider.overrideWith(
              (ref) => const BasirUser(
                id: 'test-user',
                email: 'test@example.com',
                displayName: 'Test User',
                role: UserRole.admin,
              ),
            ),
            currentUserProvider.overrideWith((ref) => null),
            ...overrides,
          ],
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: locale,
            home: const InvoicesScreen(),
          ),
        );

    testWidgets('uses GlassScaffold as root layout container', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          overrides: [
            filteredInvoicesProvider.overrideWithValue(
              AsyncValue.data([MockData.createTestInvoice(id: 'inv-1')]),
            ),
            invoiceStatisticsProvider.overrideWithValue(
              AsyncValue.data(
                InvoiceStatistics(
                  totalInvoices: 1,
                  paidInvoices: 0,
                  overdueInvoices: 0,
                  totalAmount: Decimal.fromInt(1000),
                ),
              ),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(GlassScaffold), findsOneWidget);
    });

    testWidgets('action button icons use IconSizes.md (24px) - WCAG standard', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          overrides: [
            filteredInvoicesProvider.overrideWithValue(
              AsyncValue.data([MockData.createTestInvoice(id: 'inv-1')]),
            ),
            invoiceStatisticsProvider.overrideWithValue(
              AsyncValue.data(
                InvoiceStatistics(
                  totalInvoices: 1,
                  paidInvoices: 0,
                  overdueInvoices: 0,
                  totalAmount: Decimal.fromInt(1000),
                ),
              ),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      final addIconFinder = find.descendant(
        of: find.ancestor(
          of: find.byTooltip('إضافة فاتورة'),
          matching: find.byType(IconButton),
        ),
        matching: find.byType(Icon),
      );
      final addIcon = tester.widget<Icon>(addIconFinder);
      expect(addIcon.size, IconSizes.md);

      final exportIconFinder = find.descendant(
        of: find.ancestor(
          of: find.byTooltip('تصدير الكل'),
          matching: find.byType(IconButton),
        ),
        matching: find.byType(Icon),
      );
      final exportIcon = tester.widget<Icon>(exportIconFinder);
      expect(exportIcon.size, IconSizes.md);
    });

    testWidgets(
        'action buttons have BoxConstraints minWidth/minHeight = TouchTargets.minimum (48px)', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          overrides: [
            filteredInvoicesProvider.overrideWithValue(
              AsyncValue.data([MockData.createTestInvoice(id: 'inv-1')]),
            ),
            invoiceStatisticsProvider.overrideWithValue(
              AsyncValue.data(
                InvoiceStatistics(
                  totalInvoices: 1,
                  paidInvoices: 0,
                  overdueInvoices: 0,
                  totalAmount: Decimal.fromInt(1000),
                ),
              ),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      final addButton = tester.widget<IconButton>(
        find.ancestor(
          of: find.byTooltip('إضافة فاتورة'),
          matching: find.byType(IconButton),
        ),
      );
      expect(addButton.constraints?.minWidth, TouchTargets.minimum);
      expect(addButton.constraints?.minHeight, TouchTargets.minimum);

      final exportButton = tester.widget<IconButton>(
        find.ancestor(
          of: find.byTooltip('تصدير الكل'),
          matching: find.byType(IconButton),
        ),
      );
      expect(exportButton.constraints?.minWidth, TouchTargets.minimum);
      expect(exportButton.constraints?.minHeight, TouchTargets.minimum);
    });

    testWidgets('action buttons use EdgeInsets.zero for padding', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          overrides: [
            filteredInvoicesProvider.overrideWithValue(
              AsyncValue.data([MockData.createTestInvoice(id: 'inv-1')]),
            ),
            invoiceStatisticsProvider.overrideWithValue(
              AsyncValue.data(
                InvoiceStatistics(
                  totalInvoices: 1,
                  paidInvoices: 0,
                  overdueInvoices: 0,
                  totalAmount: Decimal.fromInt(1000),
                ),
              ),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      final addButton = tester.widget<IconButton>(
        find.ancestor(
          of: find.byTooltip('إضافة فاتورة'),
          matching: find.byType(IconButton),
        ),
      );
      expect(addButton.padding, EdgeInsets.zero);

      final exportButton = tester.widget<IconButton>(
        find.ancestor(
          of: find.byTooltip('تصدير الكل'),
          matching: find.byType(IconButton),
        ),
      );
      expect(exportButton.padding, EdgeInsets.zero);
    });

    testWidgets('action buttons have Arabic tooltips for accessibility', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          overrides: [
            filteredInvoicesProvider.overrideWithValue(
              AsyncValue.data([MockData.createTestInvoice(id: 'inv-1')]),
            ),
            invoiceStatisticsProvider.overrideWithValue(
              AsyncValue.data(
                InvoiceStatistics(
                  totalInvoices: 1,
                  paidInvoices: 0,
                  overdueInvoices: 0,
                  totalAmount: Decimal.fromInt(1000),
                ),
              ),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byTooltip('إضافة فاتورة'), findsWidgets);
      expect(find.byTooltip('تصدير الكل'), findsOneWidget);
    });

    testWidgets('action buttons have English tooltips for accessibility', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          overrides: [
            filteredInvoicesProvider.overrideWithValue(
              AsyncValue.data([MockData.createTestInvoice(id: 'inv-1')]),
            ),
            invoiceStatisticsProvider.overrideWithValue(
              AsyncValue.data(
                InvoiceStatistics(
                  totalInvoices: 1,
                  paidInvoices: 0,
                  overdueInvoices: 0,
                  totalAmount: Decimal.fromInt(1000),
                ),
              ),
            ),
          ],
          locale: const Locale('en'),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byTooltip('Add Invoice'), findsWidgets);
      expect(find.byTooltip('Export All'), findsOneWidget);
    });

    testWidgets('invoice cards use AppListCard component', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          overrides: [
            filteredInvoicesProvider.overrideWithValue(
              AsyncValue.data([MockData.createTestInvoice(id: 'inv-1')]),
            ),
            invoiceStatisticsProvider.overrideWithValue(
              AsyncValue.data(
                InvoiceStatistics(
                  totalInvoices: 1,
                  paidInvoices: 0,
                  overdueInvoices: 0,
                  totalAmount: Decimal.fromInt(1000),
                ),
              ),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(AppListCard), findsWidgets);
    });

    testWidgets('invoice cards have Semantics wrapper with button:true', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          overrides: [
            filteredInvoicesProvider.overrideWithValue(
              AsyncValue.data([MockData.createTestInvoice(id: 'inv-1')]),
            ),
            invoiceStatisticsProvider.overrideWithValue(
              AsyncValue.data(
                InvoiceStatistics(
                  totalInvoices: 1,
                  paidInvoices: 0,
                  overdueInvoices: 0,
                  totalAmount: Decimal.fromInt(1000),
                ),
              ),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      final allSemantics = tester.widgetList<Semantics>(
        find.descendant(
          of: find.byType(ListView),
          matching: find.byType(Semantics),
        ),
      );
      final hasButtonSemantics = allSemantics.any(
        (s) => s.properties.button ?? false,
      );
      expect(hasButtonSemantics, isTrue);
    });

    testWidgets('invoice status icon uses IconSizes.md (24px)', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          overrides: [
            filteredInvoicesProvider.overrideWithValue(
              AsyncValue.data([MockData.createTestInvoice(id: 'inv-1')]),
            ),
            invoiceStatisticsProvider.overrideWithValue(
              AsyncValue.data(
                InvoiceStatistics(
                  totalInvoices: 1,
                  paidInvoices: 0,
                  overdueInvoices: 0,
                  totalAmount: Decimal.fromInt(1000),
                ),
              ),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      final appListCardFinder = find.byType(AppListCard).first;
      final iconFinder = find.descendant(
        of: appListCardFinder,
        matching: find.byType(Icon),
      );
      expect(iconFinder, findsWidgets);

      final statusIcon = tester.widgetList<Icon>(iconFinder).firstWhere(
            (icon) => icon.size == IconSizes.md,
            orElse: () => tester.widget<Icon>(iconFinder.first),
          );
      expect(statusIcon.size, IconSizes.md);
    });

    testWidgets('FAB has Arabic tooltip and icon size 24px (IconSizes.md)', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          overrides: [
            filteredInvoicesProvider.overrideWithValue(
              AsyncValue.data([MockData.createTestInvoice(id: 'inv-1')]),
            ),
            invoiceStatisticsProvider.overrideWithValue(
              AsyncValue.data(
                InvoiceStatistics(
                  totalInvoices: 1,
                  paidInvoices: 0,
                  overdueInvoices: 0,
                  totalAmount: Decimal.fromInt(1000),
                ),
              ),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      final fabTooltipFinder = find.descendant(
        of: find.byType(FloatingActionButton),
        matching: find.byTooltip('إضافة فاتورة'),
      );
      expect(fabTooltipFinder, findsOneWidget);

      final fabIconFinder = find.descendant(
        of: find.byType(FloatingActionButton),
        matching: find.byType(Icon),
      );
      final fabIcon = tester.widget<Icon>(fabIconFinder);
      expect(fabIcon.size, IconSizes.md);
    });

    testWidgets('FAB has English tooltip and icon size 24px (IconSizes.md)', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          overrides: [
            filteredInvoicesProvider.overrideWithValue(
              AsyncValue.data([MockData.createTestInvoice(id: 'inv-1')]),
            ),
            invoiceStatisticsProvider.overrideWithValue(
              AsyncValue.data(
                InvoiceStatistics(
                  totalInvoices: 1,
                  paidInvoices: 0,
                  overdueInvoices: 0,
                  totalAmount: Decimal.fromInt(1000),
                ),
              ),
            ),
          ],
          locale: const Locale('en'),
        ),
      );
      await tester.pumpAndSettle();

      final fabTooltipFinder = find.descendant(
        of: find.byType(FloatingActionButton),
        matching: find.byTooltip('Add Invoice'),
      );
      expect(fabTooltipFinder, findsOneWidget);

      final fabIconFinder = find.descendant(
        of: find.byType(FloatingActionButton),
        matching: find.byType(Icon),
      );
      final fabIcon = tester.widget<Icon>(fabIconFinder);
      expect(fabIcon.size, IconSizes.md);
    });
  });
}

class _MockCalendarNotifier extends CalendarNotifier {
  _MockCalendarNotifier(this.initial);
  final CalendarType initial;

  @override
  Future<CalendarType> build() async => initial;
}
