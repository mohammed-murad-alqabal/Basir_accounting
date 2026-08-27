import 'package:basir_accounting_system/src/rust/api/reports.dart';
import 'package:flutter_test/flutter_test.dart';

TrialBalanceLineDto _trialBalanceLine({String debit = '100.00'}) =>
    TrialBalanceLineDto(
      accountId: 'cash',
      accountCode: '1101',
      accountName: 'Cash',
      debitBalance: debit,
      creditBalance: '0.00',
    );

FinancialReportLineDto _reportLine({bool isTotal = false}) =>
    FinancialReportLineDto(
      label: 'Operating revenue',
      amount: '1200.00',
      isTitle: false,
      isTotal: isTotal,
      indentLevel: 1,
    );

void main() {
  group('Rust reports DTO contract', () {
    test('preserves trial-balance values, equality, and change detection', () {
      final lines = [_trialBalanceLine()];
      final balance = TrialBalanceDto(
        asOfDate: '2025-12-31',
        periodStart: '2025-01-01',
        periodEnd: '2025-12-31',
        lines: lines,
        totalDebits: '100.00',
        totalCredits: '100.00',
        isBalanced: true,
      );
      final equivalent = TrialBalanceDto(
        asOfDate: '2025-12-31',
        periodStart: '2025-01-01',
        periodEnd: '2025-12-31',
        lines: lines,
        totalDebits: '100.00',
        totalCredits: '100.00',
        isBalanced: true,
      );
      final unbalanced = TrialBalanceDto(
        asOfDate: '2025-12-31',
        periodEnd: '2025-12-31',
        lines: lines,
        totalDebits: '100.00',
        totalCredits: '90.00',
        isBalanced: false,
      );

      expect(balance, equivalent);
      expect(balance.hashCode, equivalent.hashCode);
      expect(balance, isNot(unbalanced));
      expect(balance.periodStart, '2025-01-01');
      expect(_trialBalanceLine(), _trialBalanceLine());
      expect(_trialBalanceLine(), isNot(_trialBalanceLine(debit: '99.00')));
    });

    test('preserves report lines and exposes line-level changes', () {
      final lines = [_reportLine()];
      final report = FinancialReportDto(
        title: 'Income statement',
        fromDate: '2025-01-01',
        toDate: '2025-12-31',
        lines: lines,
        generatedAt: '2026-08-15T00:00:00Z',
      );
      final equivalent = FinancialReportDto(
        title: 'Income statement',
        fromDate: '2025-01-01',
        toDate: '2025-12-31',
        lines: lines,
        generatedAt: '2026-08-15T00:00:00Z',
      );
      final changedPeriod = FinancialReportDto(
        title: 'Income statement',
        fromDate: '2025-01-01',
        toDate: '2026-01-01',
        lines: lines,
        generatedAt: '2026-08-15T00:00:00Z',
      );

      expect(report, equivalent);
      expect(report.hashCode, equivalent.hashCode);
      expect(report, isNot(changedPeriod));
      expect(_reportLine(), _reportLine());
      expect(_reportLine(), isNot(_reportLine(isTotal: true)));
    });

    test('keeps aging and drill-down audit details distinct by every field',
        () {
      const aging = AgingReportLineDto(
        partnerId: 'customer-1',
        partnerName: 'Basir customer',
        currentAmount: '50.00',
        period130: '20.00',
        period3160: '10.00',
        period6190: '5.00',
        periodOver90: '2.00',
        totalAmount: '87.00',
      );
      const sameAging = AgingReportLineDto(
        partnerId: 'customer-1',
        partnerName: 'Basir customer',
        currentAmount: '50.00',
        period130: '20.00',
        period3160: '10.00',
        period6190: '5.00',
        periodOver90: '2.00',
        totalAmount: '87.00',
      );
      const changedAging = AgingReportLineDto(
        partnerId: 'customer-1',
        partnerName: 'Basir customer',
        currentAmount: '50.00',
        period130: '20.00',
        period3160: '10.00',
        period6190: '5.00',
        periodOver90: '3.00',
        totalAmount: '88.00',
      );
      const entry = DrillDownEntryDto(
        entryId: 'je-1',
        entryNumber: 'JE-001',
        effectiveDate: '2025-01-01',
        description: 'Cash sale',
        debit: '100.00',
        credit: '0.00',
      );
      const equivalentEntry = DrillDownEntryDto(
        entryId: 'je-1',
        entryNumber: 'JE-001',
        effectiveDate: '2025-01-01',
        description: 'Cash sale',
        debit: '100.00',
        credit: '0.00',
      );
      const auditedEntry = DrillDownEntryDto(
        entryId: 'je-1',
        entryNumber: 'JE-001',
        effectiveDate: '2025-01-01',
        description: 'Cash sale',
        debit: '100.00',
        credit: '0.00',
        standardReference: 'IFRS 18',
      );

      expect(aging, sameAging);
      expect(aging.hashCode, sameAging.hashCode);
      expect(aging, isNot(changedAging));
      expect(entry, equivalentEntry);
      expect(entry.hashCode, equivalentEntry.hashCode);
      expect(entry, isNot(auditedEntry));
    });

    test('keeps the supported Zakah calendar options explicit', () {
      expect(ZakahCalendarDto.values, [
        ZakahCalendarDto.hijri,
        ZakahCalendarDto.gregorian,
      ]);
    });
  });
}
