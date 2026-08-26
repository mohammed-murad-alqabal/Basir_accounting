import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/settings/domain/entities/business_settings.dart';
import 'package:basir_accounting_system/features/settings/domain/entities/profile.dart';
import 'package:basir_accounting_system/features/settings/domain/repositories/business_settings_repository.dart';
import 'package:basir_accounting_system/features/settings/domain/repositories/profile_repository.dart';
import 'package:basir_accounting_system/features/settings/presentation/providers/settings_controller.dart';
import 'package:basir_accounting_system/features/settings/presentation/widgets/company_settings_sheet.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:basir_accounting_system/services/settings_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../mocks/mock_secure_storage.dart';

class _MemoryBusinessSettingsRepository implements BusinessSettingsRepository {
  _MemoryBusinessSettingsRepository(this.current);

  BusinessSettings? current;
  BusinessSettings? saved;

  @override
  Future<BusinessSettings?> getSettings() async => current;

  @override
  Future<void> saveSettings(BusinessSettings settings) async {
    saved = settings;
    current = settings;
  }
}

class _NoopProfileRepository implements ProfileRepository {
  @override
  Future<void> deleteProfile() async {}

  @override
  Future<Profile?> getProfile() async => null;

  @override
  Future<void> saveProfile(dynamic profile) async {}
}

void main() {
  const initialSettings = <String, String?>{
    'companyName': 'شركة بصير',
    'taxNumber': '310123456700003',
    'taxRate': '15',
    'currencySymbol': 'ر.س',
    'defaultCountryCode': 'SA',
    'invoiceStyle': 'standard',
  };

  ProviderContainer createContainer({
    required _MemoryBusinessSettingsRepository repository,
    required MockSecureStorage storage,
  }) {
    final service = SettingsService(
      secureStorage: storage,
      businessSettingsRepository: repository,
      profileRepository: _NoopProfileRepository(),
    );
    return ProviderContainer(
      overrides: [
        secureStorageProvider.overrideWithValue(storage),
        settingsServiceProvider.overrideWithValue(service),
      ],
    );
  }

  Widget buildSheet(ProviderContainer container) => UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          locale: Locale('ar'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: CompanySettingsSheet(initialSettings: initialSettings),
          ),
        ),
      );

  group('CompanySettingsSheet', () {
    testWidgets('يعدل الإعدادات ويحفظ الحمولة المحاسبية الصحيحة',
        (tester) async {
      final repository = _MemoryBusinessSettingsRepository(
        const BusinessSettings(id: 'settings-1', companyName: 'شركة بصير'),
      );
      final storage = MockSecureStorage();
      final container =
          createContainer(repository: repository, storage: storage);
      addTearDown(container.dispose);

      await tester.pumpWidget(buildSheet(container));
      await tester.pumpAndSettle();

      expect(find.text('شركة بصير'), findsOneWidget);
      final fields = find.byType(TextFormField);
      expect(fields, findsNWidgets(4));

      await tester.enterText(fields.at(0), 'شركة بصير المتقدمة');
      await tester.enterText(fields.at(1), '399999999900003');
      await tester.enterText(fields.at(2), '17.5');
      await tester.enterText(fields.at(3), 'SAR');
      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('عصري'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('حفظ'));
      await tester.pumpAndSettle();

      expect(repository.saved, isNotNull);
      expect(repository.saved!.companyName, 'شركة بصير المتقدمة');
      expect(repository.saved!.taxNumber, '399999999900003');
      expect(repository.saved!.defaultTaxRate, 17.5);
      expect(repository.saved!.currencySymbol, 'SAR');
      expect(repository.saved!.address, 'SA');
      expect(repository.saved!.isDeleted, isFalse);
      expect(container.read(settingsControllerProvider).isLoading, isFalse);
    });

    testWidgets('يبقي الورقة مفتوحة عند فشل حفظ نمط الفاتورة', (tester) async {
      final repository = _MemoryBusinessSettingsRepository(
        const BusinessSettings(id: 'settings-2', companyName: 'شركة بصير'),
      );
      final storage = MockSecureStorage()..shouldThrowOnWrite = true;
      final container =
          createContainer(repository: repository, storage: storage);
      addTearDown(container.dispose);

      await tester.pumpWidget(buildSheet(container));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('عصري'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('حفظ'));
      await tester.pumpAndSettle();

      expect(find.byType(CompanySettingsSheet), findsOneWidget);
      expect(container.read(settingsControllerProvider).isLoading, isFalse);
      expect(container.read(settingsControllerProvider).error, isNotNull);
    });
  });
}
