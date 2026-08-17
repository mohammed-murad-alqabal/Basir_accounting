/// اختبارات عقد JSON لقيود اليومية.
library;

import 'package:basir_accounting_system/features/accounting/domain/entities/journal_entry.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'يحول القيد المتوازن وخطوطه إلى JSON ويعيده دون فقدان بيانات التدقيق',
    () {
      final timestamp = DateTime.utc(2026, 2, 1, 9, 30);
      final original = JournalEntry(
        id: 'je-json-001',
        referenceNumber: 'JE-2026-JSON-001',
        date: timestamp,
        temporal: TemporalJustification(
          transactionDate: timestamp,
          effectiveDate: timestamp,
          recordingDate: timestamp,
        ),
        standards: const StandardsJustification(
          standardReference: 'IFRS 15',
          recognitionBasis: 'Accrual',
          measurementBasis: 'Transaction price',
        ),
        description: 'إثبات إيراد خدمة محاسبية',
        status: JournalEntryStatus.posted,
        lines: [
          JournalEntryLine(
            accountId: 'cash',
            accountName: 'النقدية',
            description: 'تحصيل نقدي',
            debit: Decimal.fromInt(1250),
            credit: Decimal.zero,
          ),
          JournalEntryLine(
            accountId: 'revenue',
            accountName: 'إيرادات الخدمات',
            debit: Decimal.zero,
            credit: Decimal.fromInt(1250),
          ),
        ],
        sourceDocument: 'service_invoice',
        sourceId: 'INV-JSON-1',
        createdBy: 'auditor',
        createdAt: timestamp,
        updatedAt: timestamp,
        postedAt: timestamp,
      );

      final encoded = original.toJson();
      final restored = JournalEntry.fromJson(encoded);

      expect(encoded['id'], 'je-json-001');
      expect(encoded['status'], 'posted');
      expect(encoded['lines'], hasLength(2));
      expect(restored, original);
      expect(restored.isBalanced, isTrue);
      expect(restored.totalDebit, Decimal.fromInt(1250));
      expect(restored.totalCredit, Decimal.fromInt(1250));
      expect(restored.postedAt, timestamp);
    },
  );

  test('يحتفظ سطر القيد بالمرجع والعملة والقيمة الأصلية عند التحويل المستقل',
      () {
    final line = JournalEntryLine(
      accountId: 'inventory',
      accountName: 'المخزون',
      description: 'تسوية كمية',
      debit: Decimal.fromInt(42),
      credit: Decimal.zero,
      originalCurrency: 'SAR',
      exchangeRate: Decimal.parse('1.0'),
      originalAmount: Decimal.fromInt(42),
      sourceDocumentRef: 'INV-42',
      costCenterId: 'CC-01',
    );

    final restored = JournalEntryLine.fromJson(line.toJson());

    expect(restored, line);
    expect(restored.originalAmount, Decimal.fromInt(42));
    expect(restored.originalCurrency, 'SAR');
    expect(restored.sourceDocumentRef, 'INV-42');
  });
}
