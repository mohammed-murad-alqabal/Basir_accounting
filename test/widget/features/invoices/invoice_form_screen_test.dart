import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/core/theme/tokens/app_icons.dart';
import 'package:basir_accounting_system/features/auth/domain/models/auth_models.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice_status.dart';
import 'package:basir_accounting_system/features/invoices/presentation/screens/invoice_form_screen.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../fixtures/invoice_fixtures.dart';
import '../../../mocks/mock_customer_repository.dart';
import '../../../mocks/mock_invoice_repository.dart';

class _FakeNotificationService extends NotificationService {
  int initializeCalls = 0;
  final List<DateTime> scheduledDates = [];

  @override
  Future<void> initialize() async {
    initializeCalls++;
  }

  @override
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    scheduledDates.add(scheduledDate);
  }
}

void main() {
  late MockCustomerRepository mockCustomerRepository;
  late MockInvoiceRepository mockInvoiceRepository;
  late _FakeNotificationService notificationService;

  setUp(() {
    mockCustomerRepository = MockCustomerRepository();
    mockInvoiceRepository = MockInvoiceRepository();
    notificationService = _FakeNotificationService();
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
          notificationServiceProvider.overrideWithValue(notificationService),
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
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      final saveButton = find.descendant(
        of: dialog,
        matching: find.text('حفظ'),
      );
      expect(saveButton, findsOneWidget);
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      expect(find.text('5%'), findsOneWidget);
    });

    testWidgets('should keep the tax dialog open for an out-of-range rate', (
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
      await tester.enterText(taxField, '101');
      await tester.pumpAndSettle();
      await tester.tap(find.descendant(of: dialog, matching: find.text('حفظ')));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('15%'), findsOneWidget);
    });

    testWidgets('should show validation feedback when saving without customer',
        (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final saveAction = find.byKey(const Key('summaryRailSaveDraftAction'));
      await tester.ensureVisible(saveAction);
      await tester.tap(saveAction);
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
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
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      final confirmAddButton = find.descendant(
        of: dialog,
        matching: find.text('إضافة'),
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

    testWidgets('يحفظ مسودة فاتورة مكتملة بالحسابات الدقيقة وجدولة الاستحقاق',
        (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final customerPicker = find.byKey(const Key('entityPickerInput'));
      await tester.ensureVisible(customerPicker);
      await tester.tap(customerPicker);
      await tester.pumpAndSettle();
      await tester.tap(find.text('أحمد محمد').last);
      await tester.pumpAndSettle();

      final addItemButton = find.byTooltip('إضافة بند جديد');
      await tester.ensureVisible(addItemButton);
      await tester.tap(addItemButton);
      await tester.pumpAndSettle();

      final dialog = find.byType(AlertDialog);
      await tester.enterText(
        find.descendant(
          of: dialog,
          matching: find.byWidgetPredicate(
            (widget) =>
                widget is TextField && widget.decoration?.labelText == 'اسم الصنف',
          ),
        ),
        'اشتراك محاسبي',
      );
      await tester.enterText(
        find.descendant(
          of: dialog,
          matching: find.byWidgetPredicate(
            (widget) =>
                widget is TextField && widget.decoration?.labelText == 'الكمية',
          ),
        ),
        '2',
      );
      await tester.enterText(
        find.descendant(
          of: dialog,
          matching: find.byWidgetPredicate(
            (widget) =>
                widget is TextField && widget.decoration?.labelText == 'السعر',
          ),
        ),
        '100',
      );
      await tester.tap(find.descendant(of: dialog, matching: find.text('إضافة')));
      await tester.pumpAndSettle();

      final saveAction = find.byKey(const Key('summaryRailSaveDraftAction'));
      await tester.ensureVisible(saveAction);
      await tester.tap(saveAction);
      await tester.pump();

      expect(mockInvoiceRepository.invoices, hasLength(1));
      final savedInvoice = mockInvoiceRepository.invoices.single;
      expect(savedInvoice.customerId, 'test-1');
      expect(savedInvoice.customerName, 'أحمد محمد');
      expect(savedInvoice.status, InvoiceStatus.draft);
      expect(savedInvoice.items, hasLength(1));
      expect(savedInvoice.items.single.name, 'اشتراك محاسبي');
      expect(savedInvoice.subtotalAmount, Decimal.parse('200'));
      expect(savedInvoice.taxAmount, Decimal.parse('30'));
      expect(savedInvoice.totalAmount, Decimal.parse('230'));
      expect(notificationService.initializeCalls, 1);
      expect(notificationService.scheduledDates, hasLength(1));
    });

    testWidgets('يرفض الحفظ بعد اختيار العميل عند غياب بنود الفاتورة',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final customerPicker = find.byKey(const Key('entityPickerInput'));
      await tester.ensureVisible(customerPicker);
      await tester.tap(customerPicker);
      await tester.pumpAndSettle();
      await tester.tap(find.text('أحمد محمد').last);
      await tester.pumpAndSettle();

      final saveAction = find.byKey(const Key('summaryRailSaveDraftAction'));
      await tester.ensureVisible(saveAction);
      await tester.tap(saveAction);
      await tester.pump();

      expect(mockInvoiceRepository.invoices, isEmpty);
      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}

class _MockCalendarNotifier extends CalendarNotifier {
  _MockCalendarNotifier(this.initial);
  final CalendarType initial;

  @override
  Future<CalendarType> build() async => initial;
}
