// ignore_for_file: lines_longer_than_80_chars
import 'dart:io';

import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/account.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/journal_entry.dart';
import 'package:basir_accounting_system/features/customers/domain/entities/customer.dart';
import 'package:basir_accounting_system/features/settings/domain/entities/import_row.dart';
import 'package:decimal/decimal.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';

part 'excel_import_service.g.dart';

/// خدمة استيراد البيانات من ملفات Excel إلى النظام.
@riverpod
class ExcelImportService extends _$ExcelImportService {
  @override
  FutureOr<List<ImportRow>> build() => [];

  /// يفتح منتقي الملفات ويقرأ بيانات Excel
  Future<void> pickAndParse() async {
    state = const AsyncValue.loading();
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
      );

      if (result == null || result.files.isEmpty) {
        state = const AsyncValue.data([]);
        return;
      }

      final file = File(result.files.first.path!);
      final bytes = file.readAsBytesSync();
      final excel = Excel.decodeBytes(bytes);

      final rows = <ImportRow>[];
      for (final table in excel.tables.keys) {
        final sheet = excel.tables[table];
        if (sheet == null) continue;

        // تجاهل الهيدر (أول صف)
        for (var i = 1; i < sheet.maxRows; i++) {
          final rowData = sheet.rows[i];
          if (rowData.isEmpty) continue;

          try {
            final name = rowData[0]?.value?.toString() ?? '';
            if (name.isEmpty) continue;

            final phone = rowData[1]?.value?.toString();
            final address = rowData[2]?.value?.toString();
            final balanceStr = rowData[3]?.value?.toString() ?? '0';
            final natureStr = rowData[4]?.value?.toString().toLowerCase() ?? '';

            final balance = Decimal.tryParse(balanceStr) ?? Decimal.zero;
            final nature =
                natureStr.contains('credit') || natureStr.contains('دائن')
                    ? AccountNature.credit
                    : AccountNature.debit;

            rows.add(
              ImportRow(
                name: name,
                phone: phone,
                address: address,
                balance: balance,
                nature: nature,
              ),
            );
          } on Exception catch (e) {
            // إضافة صف مع خطأ
            rows.add(
              ImportRow(
                name: 'Error at row ${i + 1}',
                balance: Decimal.zero,
                nature: AccountNature.debit,
                error: e.toString(),
              ),
            );
          }
        }
      }
      state = AsyncValue.data(rows);
    } on Exception catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// إنشاء ملف Template ومشاركته
  Future<void> generateTemplate() async {
    final excel = Excel.createExcel();
    final sheet = excel['Sheet1'];

    // الهيدر باللغتين لسهولة الاستخدام
    sheet.appendRow([
      TextCellValue('Account Name / اسم الحساب'),
      TextCellValue('Phone / الهاتف'),
      TextCellValue('Address / العنوان'),
      TextCellValue('Balance / الرصيد'),
      TextCellValue('Nature (Debit/Credit) / طبيعة الحساب'),
    ]);

    // مثال توضيحي
    sheet.appendRow([
      TextCellValue('Sample Customer'),
      TextCellValue('0501234567'),
      TextCellValue('Riyadh, KSA'),
      TextCellValue('1500.50'),
      TextCellValue('Debit'),
    ]);

    final directory = await getTemporaryDirectory();
    final path = '${directory.path}/basir_import_template.xlsx';
    final file = File(path);
    await file.writeAsBytes(excel.encode()!);

    // ignore: deprecated_member_use
    await Share.shareXFiles(
      [XFile(path)],
      subject: 'Basir Data Import Template',
    );
  }

  /// تنفيذ عملية الاستيراد وحفظ البيانات في القاعدة
  Future<void> commitImport() async {
    final rows = state.valueOrNull;
    if (rows == null || rows.isEmpty) return;

    state = const AsyncValue.loading();
    try {
      final customerRepo = ref.read(customerRepositoryProvider);
      final accountRepo = ref.read(accountingRepositoryProvider);
      final now = DateTime.now();
      const uuid = Uuid();

      for (final row in rows) {
        if (!row.isValid) continue;

        // 1. إنشاء العميل
        final customerId = uuid.v4();
        final accountId = uuid.v4();

        final customer = Customer(
          id: customerId,
          nameAr: row.name,
          nameEn: row.name,
          createdAt: now,
          updatedAt: now,
          phone: row.phone,
          address: row.address,
          balance: row.balance.toDouble(),
          receivableAccountId: accountId,
        );

        // 2. إنشاء الحساب المرتبط (AR Account)
        final account = Account(
          id: accountId,
          code: '1201-${customerId.substring(0, 4)}',
          nameAr: 'حساب عميل: ${row.name}',
          nameEn: 'Customer A/C: ${row.name}',
          type: AccountType.asset,
          nature: AccountNature.debit,
          balance: row.balance,
          subType: 'ar',
        );

        await customerRepo.addCustomer(customer);
        await accountRepo.addAccount(account);

        // 3. إنشاء قيد الرصيد الافتتاحي (Opening Balance)
        if (row.balance != Decimal.zero) {
          final entry = JournalEntry(
            id: uuid.v4(),
            referenceNumber: 'OB-${now.millisecondsSinceEpoch}',
            date: now,
            // TODO(basir): Integrate with LedgerIntegrityService
            temporal: TemporalJustification(
              transactionDate: now,
              effectiveDate: now,
              recordingDate: now,
            ),
            standards: const StandardsJustification(
              standardReference: 'IFRS Opening Balance',
              recognitionBasis: 'Accrual',
            ),
            description: 'رصيد افتتاحي مستورد من Excel: ${row.name}',
            status: JournalEntryStatus.posted,
            sourceDocument: 'excel_import',
            sourceId: customerId,
            createdBy: 'system_import',
            createdAt: now,
            updatedAt: now,
            lines: [
              JournalEntryLine(
                accountId: accountId,
                accountName: row.name,
                debit: row.nature == AccountNature.debit
                    ? row.balance
                    : Decimal.zero,
                credit: row.nature == AccountNature.credit
                    ? row.balance
                    : Decimal.zero,
              ),
              // القيد المقابل: أرصدة افتتاحية
              JournalEntryLine(
                accountId: 'opening_balance_equity',
                accountName: 'الأرصدة الافتتاحية',
                debit: row.nature == AccountNature.credit
                    ? row.balance
                    : Decimal.zero,
                credit: row.nature == AccountNature.debit
                    ? row.balance
                    : Decimal.zero,
              ),
            ],
          );
          await accountRepo.addJournalEntry(entry);
        }
      }

      state = const AsyncValue.data([]);
    } on Exception catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
