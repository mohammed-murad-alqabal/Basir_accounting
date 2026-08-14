import 'dart:async';

import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/financial_year.dart';
import 'package:basir_accounting_system/features/accounting/domain/repositories/financial_year_repository.dart';
import 'package:basir_accounting_system/features/accounting/presentation/screens/fiscal_control_center_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeFinancialYearRepository implements FinancialYearRepository {
  _FakeFinancialYearRepository(this.yearsFuture);

  final Future<List<FinancialYear>> yearsFuture;

  @override
  Future<void> closeFinancialYear(String id, String userId) async {}

  @override
  Future<FinancialYear?> getCurrentFinancialYear() async =>
      (await yearsFuture).where((year) => !year.isClosed).firstOrNull;

  @override
  Future<List<FinancialYear>> getAllFinancialYears() => yearsFuture;

  @override
  Future<FinancialYear?> getFinancialYearByDate(DateTime date) async =>
      (await yearsFuture).where((year) => year.containsDate(date)).firstOrNull;

  @override
  Future<bool> isPeriodOpen(DateTime date) async => true;

  @override
  Future<void> saveFinancialYear(FinancialYear year) async {}
}

final _openYear = FinancialYear(
  id: 'fy-2026',
  name: 'FY 2026',
  startDate: DateTime(2026),
  endDate: DateTime(2026, 12, 31),
  lockedPeriodIds: const <String>['2026-02'],
);

final _closedYear = FinancialYear(
  id: 'fy-2025',
  name: 'FY 2025',
  startDate: DateTime(2025),
  endDate: DateTime(2025, 12, 31),
  isClosed: true,
);

Widget _testApp(Future<List<FinancialYear>> yearsFuture) => ProviderScope(
      overrides: [
        financialYearRepositoryProvider.overrideWithValue(
          _FakeFinancialYearRepository(yearsFuture),
        ),
      ],
      child: const MaterialApp(home: FiscalControlCenterScreen()),
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('يعرض تنبيه غياب السنة النشطة عندما تكون القائمة فارغة', (
    tester,
  ) async {
    await tester.pumpWidget(_testApp(Future<List<FinancialYear>>.value([])));
    await tester.pump();

    expect(find.text('Operational Period'), findsOneWidget);
    expect(
      find.text(
          'No active financial year detected. System operation might be restricted.'),
      findsOneWidget,
    );
    expect(find.text('Financial Cycles'), findsOneWidget);
  });

  testWidgets('يعرض السنوات وحالاتها وفترات القفل', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1440, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      _testApp(Future<List<FinancialYear>>.value([_openYear, _closedYear])),
    );
    await tester.pump();

    expect(find.text('FY 2026'), findsNWidgets(2));
    expect(find.text('Status: Open'), findsOneWidget);
    expect(find.byIcon(Icons.lock), findsOneWidget);
    expect(find.byIcon(Icons.lock_open), findsNWidgets(23));
    expect(find.byIcon(Icons.edit_outlined), findsOneWidget);
    expect(find.text('Year-End Close'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('FY 2025', skipOffstage: false),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('FY 2025'), findsOneWidget);
    expect(find.text('Status: Closed'), findsOneWidget);
  });

  testWidgets('يتعامل مع فشل تحميل المستودع دون انهيار الشاشة', (tester) async {
    await tester.pumpWidget(
      _testApp(
        Future<List<FinancialYear>>.delayed(
          Duration.zero,
          () => throw StateError('financial-year store unavailable'),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.byType(FiscalControlCenterScreen), findsOneWidget);
    expect(find.text('Financial Cycles'), findsOneWidget);
  });
}
