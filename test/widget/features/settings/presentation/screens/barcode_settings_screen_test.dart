import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/settings/domain/entities/barcode_config.dart';
import 'package:basir_accounting_system/features/settings/domain/repositories/barcode_config_repository.dart';
import 'package:basir_accounting_system/features/settings/presentation/screens/barcode_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late _MemoryBarcodeConfigRepository repository;

  setUp(() {
    repository = _MemoryBarcodeConfigRepository(_initialConfig);
  });

  Widget buildSubject() => ProviderScope(
        overrides: [
          barcodeConfigRepositoryProvider.overrideWithValue(repository),
        ],
        child: const MaterialApp(home: BarcodeSettingsScreen()),
      );

  group('BarcodeSettingsScreen', () {
    testWidgets('يعرض التحميل ثم تكوين الطابعة المحفوظ بما فيه إعداد A4',
        (tester) async {
      repository = _MemoryBarcodeConfigRepository(
        _initialConfig.copyWith(printerType: PrinterType.a4, columnsPerRow: 3),
        delay: const Duration(milliseconds: 40),
      );

      await tester.pumpWidget(buildSubject());
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 50));
      expect(find.text('إعدادات محرك الباركود'), findsOneWidget);
      expect(find.text('أعمدة في الصف'), findsOneWidget);
      expect(find.text('3 ملم'), findsOneWidget);
    });

    testWidgets('يبدّل نوع الطابعة وخيار السعر ثم يحفظ التكوين الفعلي',
        (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      await tester.tap(find.text('ورق A4 عادى'));
      await tester.pump();
      await tester.scrollUntilVisible(find.text('إظهار سعر البيع'), 240);
      await tester.tap(find.text('إظهار سعر البيع'));
      await tester.pump();
      await tester.tap(find.text('حفظ'));
      await tester.pump();

      expect(repository.savedConfigs, hasLength(1));
      final saved = repository.savedConfigs.single;
      expect(saved.printerType, PrinterType.a4);
      expect(saved.showItemName, isTrue);
      expect(saved.showPrice, isFalse);
    });

    testWidgets('يستعيد قياسات الملصق الافتراضية قبل الحفظ', (tester) async {
      repository = _MemoryBarcodeConfigRepository(
        _initialConfig.copyWith(
          printerType: PrinterType.a4,
          width: 84,
          height: 45,
          margin: 7,
          columnsPerRow: 4,
        ),
      );
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.text('84.0 ملم'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('استعادة الإعدادات الافتراضية'),
        240,
      );
      await tester.tap(find.text('استعادة الإعدادات الافتراضية'));
      await tester.pump();
      expect(find.text('50.0 ملم'), findsOneWidget);
      expect(find.text('30.0 ملم'), findsOneWidget);
      expect(find.text('2.0 ملم'), findsOneWidget);

      await tester.tap(find.text('حفظ'));
      await tester.pump();
      final saved = repository.savedConfigs.single;
      expect(saved.width, 50);
      expect(saved.height, 30);
      expect(saved.margin, 2);
      expect(saved.columnsPerRow, 1);
    });
  });
}

const _initialConfig = BarcodeConfig(
  width: 60,
  height: 35,
  margin: 4,
  columnsPerRow: 2,
);

class _MemoryBarcodeConfigRepository implements BarcodeConfigRepository {
  _MemoryBarcodeConfigRepository(this.config, {this.delay = Duration.zero});

  BarcodeConfig config;
  final Duration delay;
  final List<BarcodeConfig> savedConfigs = [];

  @override
  Future<BarcodeConfig> getConfig() async {
    if (delay > Duration.zero) await Future<void>.delayed(delay);
    return config;
  }

  @override
  Future<void> saveConfig(BarcodeConfig config) async {
    this.config = config;
    savedConfigs.add(config);
  }
}
