import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/vendors/domain/entities/vendor.dart';
import 'package:basir_accounting_system/features/vendors/domain/repositories/vendor_repository.dart';
import 'package:basir_accounting_system/features/vendors/presentation/screens/vendor_form_screen.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _MemoryVendorRepository implements VendorRepository {
  _MemoryVendorRepository([List<Vendor>? vendors]) : _vendors = [...?vendors];

  final List<Vendor> _vendors;

  @override
  Future<void> addVendor(Vendor vendor) async => _vendors.add(vendor);

  @override
  Future<void> deleteVendor(String id) async =>
      _vendors.removeWhere((vendor) => vendor.id == id);

  @override
  Future<List<Vendor>> getAllVendors() async => List.unmodifiable(_vendors);

  @override
  Future<Vendor?> getVendorById(String id) async {
    for (final vendor in _vendors) {
      if (vendor.id == id) return vendor;
    }
    return null;
  }

  @override
  Future<List<Vendor>> searchVendors(String query) async => _vendors
      .where(
        (vendor) =>
            vendor.nameAr.contains(query) || vendor.nameEn.contains(query),
      )
      .toList();

  @override
  Future<void> updateVendor(Vendor vendor) async {
    final index = _vendors.indexWhere((existing) => existing.id == vendor.id);
    if (index >= 0) _vendors[index] = vendor;
  }
}

Vendor existingVendor() => Vendor(
      id: 'vendor-001',
      nameAr: 'مورد التقنية',
      nameEn: 'Technology Vendor',
      email: 'old@supplier.test',
      phone: '0500000000',
      vatNumber: '300000000000003',
      registrationNumber: '1010000000',
      createdAt: DateTime.utc(2024),
      updatedAt: DateTime.utc(2024),
    );

Widget testApp({
  required VendorRepository repository,
  Vendor? vendor,
}) =>
    ProviderScope(
      overrides: [vendorRepositoryProvider.overrideWithValue(repository)],
      child: MaterialApp(
        locale: const Locale('ar'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: VendorFormScreen(vendor: vendor),
      ),
    );

Future<void> submitForm(WidgetTester tester) async {
  await tester.drag(find.byType(ListView), const Offset(0, -1000));
  await tester.pumpAndSettle();
  final save = find.text('حفظ').last;
  await tester.ensureVisible(save);
  await tester.tap(save);
}

void main() {
  group('VendorFormScreen', () {
    testWidgets('يرفض الحفظ حين يغيب اسم المورد بالعربية والإنجليزية', (
      tester,
    ) async {
      final repository = _MemoryVendorRepository();
      await tester.pumpWidget(testApp(repository: repository));
      await tester.pumpAndSettle();

      await submitForm(tester);
      await tester.pumpAndSettle();

      expect(await repository.getAllVendors(), isEmpty);
      expect(find.text('هذا الحقل مطلوب'), findsOneWidget);
    });

    testWidgets('ينشئ مورداً جديداً بعد تعبئة بيانات التواصل والامتثال', (
      tester,
    ) async {
      final repository = _MemoryVendorRepository();
      await tester.pumpWidget(testApp(repository: repository));
      await tester.pumpAndSettle();

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'شركة إمداد بصير');
      await tester.enterText(fields.at(1), 'Basir Supply Company');
      await tester.enterText(fields.at(2), 'accounts@supply.test');
      await tester.enterText(fields.at(3), '0551234567');
      await tester.enterText(fields.at(4), '300000000000003');
      await tester.enterText(fields.at(5), '1010000001');

      await submitForm(tester);
      await tester.pumpAndSettle();

      final vendors = await repository.getAllVendors();
      expect(vendors, hasLength(1));
      expect(vendors.single.nameAr, 'شركة إمداد بصير');
      expect(vendors.single.nameEn, 'Basir Supply Company');
      expect(vendors.single.email, 'accounts@supply.test');
      expect(vendors.single.phone, '0551234567');
      expect(vendors.single.vatNumber, '300000000000003');
      expect(vendors.single.registrationNumber, '1010000001');
    });

    testWidgets('يمرر تعديل المورد إلى المستودع مع الحفاظ على معرفه', (
      tester,
    ) async {
      final original = existingVendor();
      final repository = _MemoryVendorRepository([original]);
      await tester
          .pumpWidget(testApp(repository: repository, vendor: original));
      await tester.pumpAndSettle();

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(2), 'finance@supplier.test');
      await tester.enterText(fields.at(3), '0557654321');
      await submitForm(tester);
      await tester.pumpAndSettle();

      final updated = (await repository.getAllVendors()).single;
      expect(updated.id, original.id);
      expect(updated.email, 'finance@supplier.test');
      expect(updated.phone, '0557654321');
      expect(updated.nameAr, original.nameAr);
    });
  });
}
