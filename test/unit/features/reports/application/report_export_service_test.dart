import 'package:basir_accounting_system/features/reports/application/report_export_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late ProviderContainer container;

  setUp(() => container = ProviderContainer());
  tearDown(() => container.dispose());

  group('ReportExportService', () {
    test('ينتج CSV عربياً متوافقاً مع Excel ويهّرب الحقول المركبة', () {
      final csv =
          container.read(reportExportServiceProvider.notifier).generateTableCsv(
        headers: const ['الحساب', 'الوصف', 'القيمة'],
        data: const [
          ['1010', 'خدمة, استشارية', '1500'],
          ['1020', 'قال "تم"', '300'],
          ['1030', 'السطر الأول\nالسطر الثاني', '0'],
        ],
      );

      expect(csv, startsWith('\uFEFFالحساب,الوصف,القيمة\n'));
      expect(csv, contains('1010,"خدمة, استشارية",1500\n'));
      expect(csv, contains('1020,"قال ""تم""",300\n'));
      expect(csv, contains('1030,"السطر الأول\nالسطر الثاني",0\n'));
    });

    test('ينتج PDF صالحاً لجدول عربي مع عنوان فرعي', () async {
      final bytes = await container
          .read(reportExportServiceProvider.notifier)
          .generateTablePdf(
        title: 'دفتر الأستاذ',
        subtitle: 'الفترة من 1 إلى 31 يناير',
        headers: const ['الحساب', 'مدين', 'دائن'],
        data: const [
          ['النقدية', '1000', '0'],
          ['إيراد الخدمات', '0', '1000'],
        ],
      );

      expect(bytes.length, greaterThan(500));
      expect(String.fromCharCodes(bytes.take(4)), '%PDF');
    });
  });
}
