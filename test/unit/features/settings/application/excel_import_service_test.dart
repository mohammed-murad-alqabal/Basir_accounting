import 'dart:io';

import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/account.dart';
import 'package:basir_accounting_system/features/settings/application/excel_import_service.dart';
import 'package:decimal/decimal.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/riverpod.dart';

import '../../../../mocks/mock_accounting_repository.dart';
import '../../../../mocks/mock_customer_repository.dart';

class _FilePickerFake extends FilePicker {
  _FilePickerFake(this.result);

  final FilePickerResult? result;

  @override
  Future<FilePickerResult?> pickFiles({
    String? dialogTitle,
    String? initialDirectory,
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    void Function(FilePickerStatus)? onFileLoading,
    bool allowCompression = false,
    int compressionQuality = 0,
    bool allowMultiple = false,
    bool withData = false,
    bool withReadStream = false,
    bool lockParentWindow = false,
    bool readSequential = false,
  }) async =>
      result;
}

Future<File> _createWorkbook() async {
  final excel = Excel.createExcel();
  final sheet = excel['العملاء'];
  sheet.appendRow([
    TextCellValue('الاسم'),
    TextCellValue('الهاتف'),
    TextCellValue('العنوان'),
    TextCellValue('الرصيد'),
    TextCellValue('الطبيعة'),
  ]);
  sheet.appendRow([
    TextCellValue('شركة النور'),
    TextCellValue('0500000001'),
    TextCellValue('الرياض'),
    TextCellValue('1500.50'),
    TextCellValue('دائن'),
  ]);
  sheet.appendRow([
    TextCellValue('متجر الصفا'),
    TextCellValue('0500000002'),
    TextCellValue('جدة'),
    TextCellValue('قيمة غير رقمية'),
    TextCellValue('Debit'),
  ]);
  sheet.appendRow([TextCellValue('')]);
  sheet.appendRow([TextCellValue('صف ناقص')]);

  final directory = await Directory.systemTemp.createTemp('basir_excel_import_');
  final file = File('${directory.path}/customers.xlsx');
  await file.writeAsBytes(excel.encode()!);
  return file;
}

ProviderContainer _container({
  required MockCustomerRepository customerRepository,
  required MockAccountingRepository accountingRepository,
}) =>
    ProviderContainer(
    overrides: [
      customerRepositoryProvider.overrideWithValue(customerRepository),
      accountingRepositoryProvider.overrideWithValue(accountingRepository),
    ],
  );

void main() {
  tearDown(() {
    FilePicker.platform = _FilePickerFake(null);
  });

  group('ExcelImportService', () {
    test('يحلل ملف Excel ويصنف الطبيعة ويتجاوز الصفوف الفارغة', () async {
      final file = await _createWorkbook();
      addTearDown(() => file.parent.delete(recursive: true));
      FilePicker.platform = _FilePickerFake(
        FilePickerResult([
          PlatformFile(
            name: 'customers.xlsx',
            path: file.path,
            size: await file.length(),
          ),
        ]),
      );
      final container = _container(
        customerRepository: MockCustomerRepository(customers: []),
        accountingRepository: MockAccountingRepository(),
      );
      addTearDown(container.dispose);

      await container.read(excelImportServiceProvider.future);
      await container.read(excelImportServiceProvider.notifier).pickAndParse();

      final rows = container.read(excelImportServiceProvider).requireValue;
      expect(rows, hasLength(3));
      expect(rows[0].name, 'شركة النور');
      expect(rows[0].balance, Decimal.parse('1500.50'));
      expect(rows[0].nature, AccountNature.credit);
      expect(rows[1].name, 'متجر الصفا');
      expect(rows[1].balance, Decimal.zero);
      expect(rows[1].nature, AccountNature.debit);
      expect(rows[2].name, 'صف ناقص');
      expect(rows[2].balance, Decimal.zero);
      expect(rows[2].isValid, isTrue);
    });

    test('يعيد قائمة فارغة عندما يلغي المستخدم اختيار الملف', () async {
      FilePicker.platform = _FilePickerFake(null);
      final container = _container(
        customerRepository: MockCustomerRepository(customers: []),
        accountingRepository: MockAccountingRepository(),
      );
      addTearDown(container.dispose);

      await container.read(excelImportServiceProvider.future);
      await container.read(excelImportServiceProvider.notifier).pickAndParse();

      expect(container.read(excelImportServiceProvider).requireValue, isEmpty);
    });

    test('يحفظ الصفوف الصالحة وينشئ الحسابات وقيود الأرصدة الافتتاحية', () async {
      final file = await _createWorkbook();
      addTearDown(() => file.parent.delete(recursive: true));
      FilePicker.platform = _FilePickerFake(
        FilePickerResult([
          PlatformFile(
            name: 'customers.xlsx',
            path: file.path,
            size: await file.length(),
          ),
        ]),
      );
      final customerRepository = MockCustomerRepository(customers: []);
      final accountingRepository = MockAccountingRepository();
      final container = _container(
        customerRepository: customerRepository,
        accountingRepository: accountingRepository,
      );
      addTearDown(container.dispose);

      await container.read(excelImportServiceProvider.future);
      final notifier = container.read(excelImportServiceProvider.notifier);
      await notifier.pickAndParse();
      await notifier.commitImport();

      expect(customerRepository.count, 3);
      expect(accountingRepository.accounts, hasLength(3));
      expect(accountingRepository.accounts.first.balance, Decimal.parse('1500.50'));
      expect(accountingRepository.journalEntries, hasLength(1));
      final entry = accountingRepository.journalEntries.single;
      expect(entry.lines.first.credit, Decimal.parse('1500.50'));
      expect(entry.lines.last.debit, Decimal.parse('1500.50'));
      expect(container.read(excelImportServiceProvider).requireValue, isEmpty);
    });

    test('يسجل حالة خطأ عند فشل حفظ الاستيراد', () async {
      final file = await _createWorkbook();
      addTearDown(() => file.parent.delete(recursive: true));
      FilePicker.platform = _FilePickerFake(
        FilePickerResult([
          PlatformFile(
            name: 'customers.xlsx',
            path: file.path,
            size: await file.length(),
          ),
        ]),
      );
      final accountingRepository = MockAccountingRepository()
        ..shouldThrowError = true;
      final container = _container(
        customerRepository: MockCustomerRepository(customers: []),
        accountingRepository: accountingRepository,
      );
      addTearDown(container.dispose);

      await container.read(excelImportServiceProvider.future);
      final notifier = container.read(excelImportServiceProvider.notifier);
      await notifier.pickAndParse();
      await notifier.commitImport();

      expect(container.read(excelImportServiceProvider).hasError, isTrue);
    });
  });
}
