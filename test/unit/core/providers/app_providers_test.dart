import 'package:basir_accounting_system/core/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';

import '../../../helpers/test_helpers.dart';

void main() {
  group('Central application providers', () {
    late Isar isar;
    late ProviderContainer container;

    setUp(() async {
      isar = await TestHelpers.createTestIsar();
      container = ProviderContainer(
        overrides: [
          isarProvider.overrideWith((ref) async => isar),
          basirUserProvider.overrideWithValue(null),
        ],
      );
      await container.read(isarProvider.future);
    });

    tearDown(() async {
      container.dispose();
      await TestHelpers.cleanupTestIsar(isar);
    });

    test('ينشئ مستودعات العمليات الأساسية عند جاهزية قاعدة البيانات', () async {
      final customerRepository = container.read(customerRepositoryProvider);
      final invoiceRepository = container.read(invoiceRepositoryProvider);
      final financialYearRepository = container.read(
        financialYearRepositoryProvider,
      );
      final vendorRepository = container.read(vendorRepositoryProvider);
      final voucherRepository = container.read(
        financialVoucherRepositoryProvider,
      );
      final profileRepository = container.read(profileRepositoryProvider);
      final businessSettingsRepository = container.read(
        businessSettingsRepositoryProvider,
      );

      expect(await customerRepository.getAllCustomers(), isEmpty);
      expect(await invoiceRepository.getAllInvoices(), isEmpty);
      expect(await profileRepository.getProfile(), isNull);
      expect(await businessSettingsRepository.getSettings(), isNull);
      expect(financialYearRepository, isNotNull);
      expect(vendorRepository, isNotNull);
      expect(voucherRepository, isNotNull);
    });

    test('يوفر خدمات المنصة الخفيفة من دون تهيئة خارجية', () {
      expect(container.read(contactServiceProvider), isNotNull);
      expect(container.read(sharingServiceProvider), isNotNull);
      expect(container.read(googleSignInProvider), isNotNull);
    });

    test('يرفض إنشاء مستودع العميل عندما لا تكون قاعدة البيانات جاهزة', () {
      final unavailableContainer = ProviderContainer(
        overrides: [
          isarProvider.overrideWith(
            (ref) async => throw StateError('قاعدة اختبار غير متاحة'),
          ),
          basirUserProvider.overrideWithValue(null),
        ],
      );
      addTearDown(unavailableContainer.dispose);

      expect(
        () => unavailableContainer.read(customerRepositoryProvider),
        throwsA(
          isA<Exception>().having(
            (error) => error.toString(),
            'message',
            contains('قاعدة البيانات غير جاهزة'),
          ),
        ),
      );
    });
  });
}
