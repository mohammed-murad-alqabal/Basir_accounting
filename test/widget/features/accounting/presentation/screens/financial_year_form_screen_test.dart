import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/financial_year.dart';
import 'package:basir_accounting_system/features/accounting/presentation/screens/financial_year_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../helpers/mock_financial_year_repository.dart';

class _FinancialYearFake extends Fake implements FinancialYear {}

void main() {
  setUpAll(() => registerFallbackValue(_FinancialYearFake()));
  late MockFinancialYearRepository repository;

  Widget buildApp({FinancialYear? financialYear}) => ProviderScope(
        overrides: [
          financialYearRepositoryProvider.overrideWithValue(repository),
          basirUserProvider.overrideWith((ref) => null),
        ],
        child: MaterialApp(
          home: FinancialYearFormScreen(financialYear: financialYear),
        ),
      );

  setUp(() => repository = MockFinancialYearRepository());

  group('FinancialYearFormScreen', () {
    testWidgets('يعرض نموذج السنة الجديدة ويمنع الحفظ دون اسم', (tester) async {
      await tester.pumpWidget(buildApp());

      expect(find.text('New Financial Year'), findsOneWidget);
      expect(find.text('Start Date'), findsOneWidget);
      expect(find.text('End Date'), findsOneWidget);

      await tester.tap(find.text('Save Fiscal Year'));
      await tester.pump();

      expect(find.text('Name is required'), findsOneWidget);
      verifyNever(() => repository.saveFinancialYear(any()));
    });

    testWidgets('يحفظ سنة جديدة بالمدى الافتراضي واسم المستخدم المدخل',
        (tester) async {
      when(() => repository.saveFinancialYear(any())).thenAnswer((_) async {});
      await tester.pumpWidget(buildApp());

      await tester.enterText(find.byType(TextFormField), 'Fiscal Year 2027');
      await tester.tap(find.text('Save Fiscal Year'));
      await tester.pumpAndSettle();

      final saved = verify(() => repository.saveFinancialYear(captureAny()))
          .captured
          .single as FinancialYear;
      expect(saved.name, 'Fiscal Year 2027');
      expect(saved.startDate, DateTime(DateTime.now().year));
      expect(saved.endDate, DateTime(DateTime.now().year, 12, 31));
      expect(saved.userId, isNull);
    });

    testWidgets('يعرض بيانات السنة عند التعديل ويحافظ على معرفها',
        (tester) async {
      final existing = FinancialYear(
        id: 'fy-2025',
        name: 'Fiscal Year 2025',
        startDate: DateTime(2025),
        endDate: DateTime(2025, 12, 31),
        userId: 'owner-1',
      );
      when(() => repository.saveFinancialYear(any())).thenAnswer((_) async {});
      await tester.pumpWidget(buildApp(financialYear: existing));

      expect(find.text('Edit Financial Year'), findsOneWidget);
      expect(find.text('Fiscal Year 2025'), findsOneWidget);
      await tester.tap(find.text('Save Fiscal Year'));
      await tester.pumpAndSettle();

      final saved = verify(() => repository.saveFinancialYear(captureAny()))
          .captured
          .single as FinancialYear;
      expect(saved.id, existing.id);
      expect(saved.name, existing.name);
      expect(saved.startDate, existing.startDate);
    });

    testWidgets('يعرض خطأ المستودع ولا يغلق النموذج عند فشل الحفظ',
        (tester) async {
      when(() => repository.saveFinancialYear(any()))
          .thenThrow(Exception('storage unavailable'));
      await tester.pumpWidget(buildApp());

      await tester.enterText(find.byType(TextFormField), 'Fiscal Year 2028');
      await tester.tap(find.text('Save Fiscal Year'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Error saving:'), findsOneWidget);
      expect(find.text('New Financial Year'), findsOneWidget);
    });
  });
}
