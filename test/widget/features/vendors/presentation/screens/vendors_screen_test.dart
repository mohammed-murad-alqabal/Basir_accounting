import 'package:basir_accounting_system/core/assets/app_illustrations.dart';
import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/core/theme/tokens/app_icons.dart';
import 'package:basir_accounting_system/features/vendors/domain/entities/vendor.dart';
import 'package:basir_accounting_system/features/vendors/domain/repositories/vendor_repository.dart';
import 'package:basir_accounting_system/features/vendors/presentation/screens/vendor_details_screen.dart';
import 'package:basir_accounting_system/features/vendors/presentation/screens/vendor_form_screen.dart';
import 'package:basir_accounting_system/features/vendors/presentation/screens/vendors_screen.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _VendorRepositoryMemory implements VendorRepository {
  _VendorRepositoryMemory(this._vendors);

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
    final index = _vendors.indexWhere((item) => item.id == vendor.id);
    if (index >= 0) _vendors[index] = vendor;
  }
}

class _FailingVendorRepository extends _VendorRepositoryMemory {
  _FailingVendorRepository() : super(const []);

  @override
  Future<List<Vendor>> getAllVendors() =>
      Future.error(StateError('تعذر تحميل الموردين'));
}

Vendor vendor({
  required String id,
  required String nameAr,
  required String nameEn,
  required double balance,
}) =>
    Vendor(
      id: id,
      nameAr: nameAr,
      nameEn: nameEn,
      email: '$id@supplier.test',
      phone: '055000000$id',
      balance: balance,
      createdAt: DateTime.utc(2024),
      updatedAt: DateTime.utc(2024),
    );

Widget vendorsApp(VendorRepository repository) => ProviderScope(
      overrides: [
        vendorRepositoryProvider.overrideWithValue(repository),
        appIconsProvider.overrideWithValue(const MaterialAppIcons()),
      ],
      child: const MaterialApp(
        locale: Locale('ar'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: VendorsScreen(),
      ),
    );

void main() {
  group('VendorsScreen', () {
    testWidgets('يعرض الموردين وإجمالي الالتزامات ثم يفلتر البحث فورياً', (
      tester,
    ) async {
      final first = vendor(
        id: 'vendor-1',
        nameAr: 'مورد التقنية',
        nameEn: 'Technology Vendor',
        balance: 1250.5,
      );
      final second = vendor(
        id: 'vendor-2',
        nameAr: 'مورد الخدمات',
        nameEn: 'Services Vendor',
        balance: 349.5,
      );

      await tester
          .pumpWidget(vendorsApp(_VendorRepositoryMemory([first, second])));
      await tester.pumpAndSettle();

      expect(find.text(first.nameAr), findsOneWidget);
      expect(find.text(second.nameAr), findsOneWidget);
      expect(find.text('1600.00 SAR'), findsOneWidget);
      expect(
        find.bySemanticsLabel(
          '${first.nameAr}, ${first.email}, ${first.phone}',
        ),
        findsOneWidget,
      );

      await tester.enterText(find.byType(AppSearchField), 'التقنية');
      await tester.pumpAndSettle();

      expect(find.text(first.nameAr), findsOneWidget);
      expect(find.text(second.nameAr), findsNothing);
    });

    testWidgets('يعرض الحالة الفارغة عند عدم وجود موردين', (tester) async {
      await tester.pumpWidget(vendorsApp(_VendorRepositoryMemory(const [])));
      await tester.pump();
      await tester.pump();

      expect(find.byType(EmptyStateIllustration), findsOneWidget);
    });

    testWidgets('يعرض حالة الخطأ عند فشل قراءة مستودع الموردين',
        (tester) async {
      await tester.pumpWidget(vendorsApp(_FailingVendorRepository()));
      await tester.pump();
      await tester.pump();

      expect(find.byType(AppErrorWidget), findsOneWidget);
      expect(find.textContaining('تعذر تحميل الموردين'), findsOneWidget);
    });

    testWidgets('ينتقل إلى التفاصيل وإلى نموذج الإضافة من القائمة',
        (tester) async {
      final item = vendor(
        id: 'vendor-3',
        nameAr: 'مورد الأنظمة',
        nameEn: 'Systems Vendor',
        balance: 0,
      );
      await tester.pumpWidget(vendorsApp(_VendorRepositoryMemory([item])));
      await tester.pumpAndSettle();

      await tester.tap(find.text(item.nameAr));
      await tester.pumpAndSettle();
      expect(find.byType(VendorDetailsScreen), findsOneWidget);

      Navigator.of(tester.element(find.byType(VendorDetailsScreen))).pop();
      await tester.pumpAndSettle();
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();
      expect(find.byType(VendorFormScreen), findsOneWidget);
    });
  });
}
