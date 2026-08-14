import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/core/theme/tokens/app_icons.dart';
import 'package:basir_accounting_system/features/auth/domain/models/auth_models.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice.dart';
import 'package:basir_accounting_system/features/invoices/presentation/screens/invoice_form_screen.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart'; // Fixed import
import 'package:basir_accounting_system/shared/widgets/app_enhanced_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../fixtures/invoice_fixtures.dart';
import '../../../mocks/mock_customer_repository.dart';
import '../../../mocks/mock_invoice_repository.dart';

void main() {
  late MockCustomerRepository mockCustomerRepository;
  late MockInvoiceRepository mockInvoiceRepository;

  setUp(() {
    mockCustomerRepository = MockCustomerRepository();
    mockInvoiceRepository = MockInvoiceRepository();
  });

  Widget createTestWidget({Invoice? invoice}) => ProviderScope(
        overrides: [
          appIconsProvider.overrideWithValue(const MaterialAppIcons()),
          currentUserProfileProvider.overrideWith(
            (ref) => const BasirUser(
              id: 'test-user',
              email: 'test@example.com',
              displayName: 'Test User',
              role: UserRole.admin,
            ),
          ),
          customerRepositoryProvider.overrideWithValue(mockCustomerRepository),
          invoiceRepositoryProvider.overrideWithValue(mockInvoiceRepository),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('ar'),
          home: InvoiceFormScreen(invoice: invoice),
        ),
      );

  group('InvoiceFormScreen - Basic Display', () {
    testWidgets('should build without error', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(InvoiceFormScreen), findsOneWidget);
    });

    testWidgets('should display scaffold', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should display app bar', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('should display form', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(Form), findsOneWidget);
    });
  });

  group('InvoiceFormScreen - With Invoice', () {
    testWidgets('should build with invoice', (tester) async {
      await tester.pumpWidget(
        createTestWidget(invoice: InvoiceFixtures.invoice1),
      );
      await tester.pumpAndSettle();

      expect(find.byType(InvoiceFormScreen), findsOneWidget);
    });

    testWidgets(
      'should display date in Hijri when calendar preference is Hijri',
      (tester) async {
        final date = DateTime(2023, 10, 27);
        final invoice = InvoiceFixtures.invoice1.copyWith(issuedDate: date);

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              appIconsProvider.overrideWithValue(const MaterialAppIcons()),
              currentUserProfileProvider.overrideWith(
                (ref) => const BasirUser(
                  id: 'test-user',
                  email: 'test@example.com',
                  displayName: 'Test User',
                  role: UserRole.admin,
                ),
              ),
              calendarProvider.overrideWith(
                () => _MockCalendarNotifier(CalendarType.hijri),
              ),
              customerRepositoryProvider.overrideWithValue(
                mockCustomerRepository,
              ),
              invoiceRepositoryProvider.overrideWithValue(
                mockInvoiceRepository,
              ),
            ],
            child: MaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: const Locale('ar'),
              home: InvoiceFormScreen(invoice: invoice),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Check for Hijri year "١٤٤٥"
        expect(find.textContaining('١٤٤٥'), findsOneWidget);
      },
    );
  });

  group('InvoiceFormScreen - Document composition', () {
    testWidgets('should reveal the exchange-rate field for USD',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final currencySelector =
          find.byType(DropdownButtonFormField<String>).last;
      await tester.ensureVisible(currencySelector);
      await tester.tap(currencySelector);
      await tester.pumpAndSettle();
      final usdOption = find.text('USD').last;
      expect(usdOption, findsOneWidget);
      await tester.tap(usdOption);
      await tester.pumpAndSettle();

      expect(find.text('سعر الصرف'), findsOneWidget);
      expect(find.text('3.75'), findsOneWidget);
    });

    testWidgets('should update the displayed tax rate after confirmation', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final editTaxRateButton = find.byTooltip('تعديل نسبة الضريبة');
      await tester.ensureVisible(editTaxRateButton);
      await tester.tap(editTaxRateButton);
      await tester.pumpAndSettle();

      final dialog = find.byType(AlertDialog);
      final taxField = find.descendant(
        of: dialog,
        matching: find.byType(TextField),
      );
      await tester.enterText(taxField, '5');
      await tester.pumpAndSettle();
      final saveButton = find.descendant(
        of: dialog,
        matching: find.byWidgetPredicate(
          (widget) => widget is AppEnhancedButton && widget.label == 'حفظ',
        ),
      );
      expect(saveButton, findsOneWidget);
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      expect(find.text('5%'), findsOneWidget);
    });

    testWidgets('should add and remove an invoice line item through the dialog',
        (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final addItemButton = find.byTooltip('إضافة بند جديد');
      await tester.ensureVisible(addItemButton);
      await tester.tap(addItemButton);
      await tester.pumpAndSettle();

      final dialog = find.byType(AlertDialog);
      final fields = find.descendant(
        of: dialog,
        matching: find.byWidgetPredicate(
          (widget) =>
              widget is TextField &&
              widget.decoration?.labelText == 'اسم الصنف',
        ),
      );
      await tester.enterText(fields, 'خدمة اختبارية');

      final quantityField = find.descendant(
        of: dialog,
        matching: find.byWidgetPredicate(
          (widget) =>
              widget is TextField && widget.decoration?.labelText == 'الكمية',
        ),
      );
      final priceField = find.descendant(
        of: dialog,
        matching: find.byWidgetPredicate(
          (widget) =>
              widget is TextField && widget.decoration?.labelText == 'السعر',
        ),
      );
      await tester.enterText(quantityField, '2');
      await tester.enterText(priceField, '100');
      await tester.pumpAndSettle();
      final confirmAddButton = find.descendant(
        of: dialog,
        matching: find.byWidgetPredicate(
          (widget) => widget is AppEnhancedButton && widget.label == 'إضافة',
        ),
      );
      expect(confirmAddButton, findsOneWidget);
      await tester.tap(confirmAddButton);
      await tester.pumpAndSettle();

      expect(find.text('خدمة اختبارية'), findsOneWidget);
      final deleteItemButton = find.byTooltip('حذف البند');
      await tester.ensureVisible(deleteItemButton);
      await tester.tap(deleteItemButton);
      await tester.pumpAndSettle();

      expect(find.text('خدمة اختبارية'), findsNothing);
      expect(find.text('لا توجد بنود. اضغط + لإضافة بند'), findsOneWidget);
    });
  });
}

class _MockCalendarNotifier extends CalendarNotifier {
  _MockCalendarNotifier(this.initial);
  final CalendarType initial;

  @override
  Future<CalendarType> build() async => initial;
}
