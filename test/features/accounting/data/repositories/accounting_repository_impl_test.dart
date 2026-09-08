import 'dart:io';

import 'package:basir_accounting_system/features/accounting/data/models/account_model.dart';
import 'package:basir_accounting_system/features/accounting/data/models/financial_year_model.dart';
import 'package:basir_accounting_system/features/accounting/data/models/journal_entry_model.dart';
import 'package:basir_accounting_system/features/accounting/data/repositories/accounting_repository_impl.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/account.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/financial_year.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/journal_entry.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';

void main() {
  const userId = 'accounting-user';
  const warehouseId = 'warehouse-riyadh';
  final transactionDate = DateTime.utc(2026, 8, 15);

  late Directory temporaryDirectory;
  late Isar isar;
  late IsarAccountingRepository repository;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
  });

  setUp(() async {
    temporaryDirectory =
        Directory.systemTemp.createTempSync('accounting_repo_');
    isar = await Isar.open(
      [
        AccountModelSchema,
        FinancialYearModelSchema,
        JournalEntryModelSchema,
      ],
      directory: temporaryDirectory.path,
    );
    repository = IsarAccountingRepository(
      isar: isar,
      userId: userId,
      warehouseId: warehouseId,
    );
  });

  tearDown(() async {
    await isar.close();
    if (temporaryDirectory.existsSync()) {
      temporaryDirectory.deleteSync(recursive: true);
    }
  });

  group('IsarAccountingRepository', () {
    test('يعزل الحسابات حسب المستخدم ويحافظ على التحديث والرصيد الدقيق',
        () async {
      final cash = _account(
        id: 'cash',
        code: '1101',
        nameAr: 'النقدية',
        nameEn: 'Cash',
        type: AccountType.asset,
        nature: AccountNature.debit,
      );
      await repository.addAccount(cash);

      final otherUserRepository = IsarAccountingRepository(
        isar: isar,
        userId: 'other-user',
      );
      await otherUserRepository.addAccount(
        _account(
          id: 'other-cash',
          code: '1102',
          nameAr: 'نقدية مستخدم آخر',
          nameEn: 'Other Cash',
          type: AccountType.asset,
          nature: AccountNature.debit,
        ),
      );

      expect(await repository.getAccounts(), hasLength(1));
      expect(await repository.getAccountById('other-cash'), isNull);

      await repository.updateAccount(
        cash.copyWith(nameAr: 'الصندوق', balance: Decimal.parse('42.75')),
      );

      final updated = await repository.getAccountById(cash.id);
      expect(updated?.nameAr, 'الصندوق');
      expect(
        await repository.getAccountBalance(cash.id),
        Decimal.parse('42.75'),
      );
      expect(await repository.getAccountBalance('missing'), Decimal.zero);
    });

    test('يرحل قيداً منشوراً ويحدّث أرصدة مدين ودائن ويعيد القيود بالتاريخ',
        () async {
      await _addOpenFinancialYear(isar, userId);
      final cash = _account(
        id: 'cash',
        code: '1101',
        nameAr: 'النقدية',
        nameEn: 'Cash',
        type: AccountType.asset,
        nature: AccountNature.debit,
      );
      final revenue = _account(
        id: 'revenue',
        code: '4101',
        nameAr: 'الإيرادات',
        nameEn: 'Revenue',
        type: AccountType.revenue,
        nature: AccountNature.credit,
      );
      await repository.addAccount(cash);
      await repository.addAccount(revenue);

      await repository.addJournalEntry(
        _entry(
          id: 'posted-entry',
          date: transactionDate,
          status: JournalEntryStatus.posted,
          lines: [
            JournalEntryLine(
              accountId: cash.id,
              accountName: cash.nameAr,
              debit: Decimal.fromInt(100),
              credit: Decimal.zero,
            ),
            JournalEntryLine(
              accountId: revenue.id,
              accountName: revenue.nameAr,
              debit: Decimal.zero,
              credit: Decimal.fromInt(100),
            ),
          ],
        ),
      );

      final sharedRepository =
          IsarAccountingRepository(isar: isar, userId: userId);
      await sharedRepository.addJournalEntry(
        _entry(
          id: 'shared-draft',
          date: transactionDate.add(const Duration(days: 1)),
          status: JournalEntryStatus.draft,
          lines: const [],
        ),
      );

      expect(await repository.getAccountBalance(cash.id), Decimal.fromInt(100));
      expect(
        await repository.getAccountBalance(revenue.id),
        Decimal.fromInt(100),
      );

      final entries = await repository.getJournalEntries();
      expect(
        entries.map((entry) => entry.id),
        ['shared-draft', 'posted-entry'],
      );
      expect(entries.last.warehouseId, warehouseId);
      expect(entries.first.warehouseId, isNull);
    });

    test('يرفض الترحيل عند غياب السنة أو إغلاق الفترة المالية', () async {
      final entry = _entry(
        id: 'blocked-entry',
        date: transactionDate,
        status: JournalEntryStatus.draft,
        lines: const [],
      );

      await expectLater(
        repository.addJournalEntry(entry),
        throwsA(isA<Exception>()),
      );

      await _addOpenFinancialYear(
        isar,
        userId,
        lockedPeriodIds: const ['2026-08'],
      );
      await expectLater(
        repository.addJournalEntry(entry),
        throwsA(isA<Exception>()),
      );
    });
  });
}

Account _account({
  required String id,
  required String code,
  required String nameAr,
  required String nameEn,
  required AccountType type,
  required AccountNature nature,
}) =>
    Account(
      id: id,
      code: code,
      nameAr: nameAr,
      nameEn: nameEn,
      type: type,
      nature: nature,
      balance: Decimal.zero,
    );

JournalEntry _entry({
  required String id,
  required DateTime date,
  required JournalEntryStatus status,
  required List<JournalEntryLine> lines,
}) =>
    JournalEntry(
      id: id,
      referenceNumber: 'JE-$id',
      date: date,
      temporal: TemporalJustification(
        transactionDate: date,
        effectiveDate: date,
        recordingDate: date,
      ),
      standards: const StandardsJustification(standardReference: 'IAS 1.27'),
      description: 'قيد اختبار المستودع',
      status: status,
      lines: lines,
      sourceDocument: 'test',
      sourceId: id,
      createdBy: 'accounting-user',
      createdAt: date,
      updatedAt: date,
    );

Future<void> _addOpenFinancialYear(
  Isar isar,
  String userId, {
  List<String> lockedPeriodIds = const [],
}) async {
  final year = FinancialYear(
    id: 'fy-$userId',
    name: 'السنة المالية 2026',
    startDate: DateTime.utc(2026),
    endDate: DateTime.utc(2026, 12, 31),
    userId: userId,
    lockedPeriodIds: lockedPeriodIds,
  );
  await isar.writeTxn(() async {
    await isar.financialYearModels.put(FinancialYearModel.fromEntity(year));
  });
}
