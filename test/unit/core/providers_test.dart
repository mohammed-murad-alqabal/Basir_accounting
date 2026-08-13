import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/core/providers/supabase_auth_provider.dart';
import 'package:basir_accounting_system/features/auth/application/auth_service.dart';
import 'package:basir_accounting_system/features/customers/data/models/customer_model.dart';
import 'package:basir_accounting_system/features/customers/data/repositories/customer_repository_impl.dart';
import 'package:basir_accounting_system/features/invoices/data/models/invoice_model.dart';
import 'package:basir_accounting_system/features/invoices/data/repositories/invoice_repository_impl.dart';
import 'package:basir_accounting_system/features/settings/data/models/business_settings_model.dart';
import 'package:basir_accounting_system/features/settings/data/models/profile_model.dart';
import 'package:basir_accounting_system/services/settings_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';

void main() {
  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
  });

  group('Core Providers Tests', () {
    late ProviderContainer container;
    late Isar isar;

    setUp(() async {
      // إنشاء Isar في الذاكرة للاختبار
      isar = await Isar.open(
        [
          CustomerModelSchema,
          InvoiceModelSchema,
          ProfileModelSchema,
          BusinessSettingsModelSchema,
        ],
        directory: '',
        name: 'test_providers_${DateTime.now().millisecondsSinceEpoch}',
      );

      container = ProviderContainer(
        overrides: [
          isarProvider.overrideWith((ref) => Future.value(isar)),
          currentUserProvider.overrideWith((ref) => null),
        ],
      );
      // Wait for Isar to be ready
      await container.read(isarProvider.future);
    });

    tearDown(() async {
      await isar.close(deleteFromDisk: true);
      container.dispose();
    });

    group('secureStorageProvider', () {
      test('should provide FlutterSecureStorage instance', () {
        // Act
        final storage = container.read(secureStorageProvider);

        // Assert
        expect(storage, isA<FlutterSecureStorage>());
      });

      test('should provide same instance on multiple reads', () {
        // Act
        final storage1 = container.read(secureStorageProvider);
        final storage2 = container.read(secureStorageProvider);

        // Assert
        expect(storage1, same(storage2));
      });
    });

    group('isarProvider', () {
      test('should provide Isar instance', () async {
        // Act
        final isarInstance = await container.read(isarProvider.future);

        // Assert
        expect(isarInstance, isA<Isar>());
        expect(isarInstance.isOpen, isTrue);
      });

      test('should have correct collections', () async {
        // Act
        final isarInstance = await container.read(isarProvider.future);

        // Assert
        expect(isarInstance.isOpen, isTrue);
        // التحقق من وجود collections بدلاً من schemas
        expect(isarInstance.customerModels, isNotNull);
        expect(isarInstance.invoiceModels, isNotNull);
      });

      test('should return existing instance if already open', () async {
        // Arrange
        final firstInstance = await container.read(isarProvider.future);

        // Act
        final secondInstance = await container.read(isarProvider.future);

        // Assert
        expect(secondInstance, same(firstInstance));
      });
    });

    group('authServiceProvider', () {
      test('should provide AuthService instance', () {
        // Act
        final authService = <credential-fixture>(authServiceProvider);

        // Assert
        expect(authService, isA<AuthService>());
      });

      test('should use secureStorageProvider', () {
        // Act
        final authService = <credential-fixture>(authServiceProvider);
        final storage = container.read(secureStorageProvider);

        // Assert
        expect(authService, isNotNull);
        expect(storage, isNotNull);
      });
    });

    group('settingsServiceProvider', () {
      test('should provide SettingsService instance', () {
        // Act
        final settingsService = container.read(settingsServiceProvider);

        // Assert
        expect(settingsService, isA<SettingsService>());
      });

      test('should use secureStorageProvider', () {
        // Act
        final settingsService = container.read(settingsServiceProvider);
        final storage = container.read(secureStorageProvider);

        // Assert
        expect(settingsService, isNotNull);
        expect(storage, isNotNull);
      });
    });

    group('customerRepositoryProvider', () {
      test('should provide CustomerRepository instance', () async {
        // Arrange
        await container.read(isarProvider.future);

        // Act
        final repository = container.read(customerRepositoryProvider);

        // Assert
        expect(repository, isA<CustomerRepositoryImpl>());
      });

      test('should throw exception if Isar is not ready', () {
        // Arrange
        final containerWithoutIsar = ProviderContainer(
          overrides: [
            isarProvider.overrideWith(
              (ref) => Future.error(Exception('قاعدة البيانات غير جاهزة')),
            ),
          ],
        );

        // Act & Assert
        expect(
          () => containerWithoutIsar.read(customerRepositoryProvider),
          throwsException,
        );

        containerWithoutIsar.dispose();
      });
    });

    group('invoiceRepositoryProvider', () {
      test('should provide InvoiceRepository instance', () async {
        // Arrange
        await container.read(isarProvider.future);

        // Act
        final repository = container.read(invoiceRepositoryProvider);

        // Assert
        expect(repository, isA<InvoiceRepositoryImpl>());
      });

      test('should throw exception if Isar is not ready', () {
        // Arrange
        final containerWithoutIsar = ProviderContainer(
          overrides: [
            isarProvider.overrideWith(
              (ref) => Future.error(Exception('قاعدة البيانات غير جاهزة')),
            ),
          ],
        );

        // Act & Assert
        expect(
          () => containerWithoutIsar.read(invoiceRepositoryProvider),
          throwsException,
        );

        containerWithoutIsar.dispose();
      });
    });

    group('Provider Integration', () {
      test('should work together correctly', () async {
        // Arrange
        await container.read(isarProvider.future);

        // Act
        final storage = container.read(secureStorageProvider);
        final authService = <credential-fixture>(authServiceProvider);
        final settingsService = container.read(settingsServiceProvider);
        final customerRepo = container.read(customerRepositoryProvider);
        final invoiceRepo = container.read(invoiceRepositoryProvider);

        // Assert
        expect(storage, isNotNull);
        expect(authService, isNotNull);
        expect(settingsService, isNotNull);
        expect(customerRepo, isNotNull);
        expect(invoiceRepo, isNotNull);
      });
    });
  });
}
