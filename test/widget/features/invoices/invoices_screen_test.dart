import 'package:basir_app/core/assets/app_illustrations.dart';
import 'package:basir_app/core/providers/calendar_provider.dart';
import 'package:basir_app/core/providers/supabase_auth_provider.dart';
import 'package:basir_app/features/invoices/presentation/providers/invoice_provider.dart';
import 'package:basir_app/features/invoices/presentation/screens/invoices_screen.dart';
import 'package:basir_app/l10n/app_localizations.dart';
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
                  totalAmount: 0,
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
                  totalAmount: 0,
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
                  totalAmount: 1000,
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
                    totalAmount: 1000,
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
}

class _MockCalendarNotifier extends CalendarNotifier {
  _MockCalendarNotifier(this.initial);
  final CalendarType initial;

  @override
  Future<CalendarType> build() async => initial;
}
