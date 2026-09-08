import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/reports/application/forensic_export_service.dart';
import 'package:excel/excel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer(
      overrides: [basirUserProvider.overrideWith((ref) => null)],
    );
  });

  tearDown(() => container.dispose());

  ReportData makeReport({String? subtitle, Map<String, String>? metadata}) =>
      ReportData(
        title: 'تقرير الالتزام الجنائي',
        subtitle: subtitle,
        headers: const ['القيد', 'الحالة'],
        rows: const [
          ['JE-2026-001', 'مرحل'],
          ['JE-2026-002', 'قيد المراجعة'],
        ],
        metadata: metadata ?? const {},
      );

  group('ForensicExportService', () {
    test('ينتج بصمة SHA-256 ثابتة وتختلف عند تعديل محتوى التقرير', () {
      final baseline = makeReport(subtitle: 'فترة يناير');
      final sameContent = makeReport(subtitle: 'فترة يناير');
      final changed = makeReport(subtitle: 'فترة فبراير');

      expect(baseline.contentHash, hasLength(64));
      expect(baseline.contentHash, sameContent.contentHash);
      expect(baseline.contentHash, isNot(changed.contentHash));
    });

    test('يصدر PDF جنائياً صالحاً مع جدول وختم للنظام عند غياب جلسة المستخدم',
        () async {
      final service = container.read(forensicExportServiceProvider);

      final bytes = await service.exportToPdf(
        makeReport(subtitle: 'الفترة المالية 2026'),
      );

      expect(bytes.length, greaterThan(500));
      expect(String.fromCharCodes(bytes.take(4)), '%PDF');
    });

    test('يصدر Excel يحفظ التقرير وأثر التدقيق والبيانات الوصفية', () async {
      final report = makeReport(
        metadata: const {'معيار المراجعة': 'IFRS', 'البيئة': 'اختبار'},
      );
      final bytes = await container
          .read(forensicExportServiceProvider)
          .exportToExcel(report);
      final workbook = Excel.decodeBytes(bytes);
      final auditValues = workbook['Audit Trail']
          .rows
          .expand((row) => row)
          .map((cell) => cell?.value.toString())
          .whereType<String>();

      expect(workbook.tables.keys, containsAll(['Report', 'Audit Trail']));
      expect(
        workbook['Report'].cell(CellIndex.indexByString('A1')).value,
        isA<TextCellValue>(),
      );
      expect(
        (workbook['Report'].cell(CellIndex.indexByString('A1')).value!
                as TextCellValue)
            .value
            .toString(),
        report.title,
      );
      expect(auditValues, containsAll(['System', report.contentHash]));
      expect(auditValues, contains('معيار المراجعة'));
    });
  });
}
