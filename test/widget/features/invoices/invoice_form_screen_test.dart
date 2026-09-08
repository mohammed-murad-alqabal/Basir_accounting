import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/core/theme/tokens/app_icons.dart';
import 'package:basir_accounting_system/features/accounting/application/accounting_service.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/journal_entry.dart';
import 'package:basir_accounting_system/features/auth/domain/models/auth_models.dart';
import 'package:basir_accounting_system/features/invoices/application/sales_invoice_posting_service.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice_status.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice_type.dart';
import 'package:basir_accounting_system/features/invoices/presentation/providers/invoice_provider.dart';
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

class _InvoiceAccountingServiceFake extends AccountingService {
  static final List<Invoice> postedInvoices = [];

  @override
  Future<List<JournalEntry>> build() async => [];

  @override
  Future<void> postInvoice(
    Invoice invoice, {
    bool bypassCognitive = false,
  }) async {
    postedInvoices.add(invoice);
  }
}

class _SalesInvoicePostingGatewayFake implements SalesInvoicePostingGateway {
  _SalesInvoicePostingGatewayFake(this.repository);

  final MockInvoiceRepository repository;
  final List<Invoice> postedInvoices = [];
  final List<JournalEntry> postedEntries = [];

  @override
  Future<JournalEntry> buildSalesJournalEntry({
    required Invoice invoice,
    required String actorId,
    required DateTime recordedAt,
  }) async {
    final amount = invoice.totalAmount;
    return JournalEntry(
      id: 'entry-${invoice.id}',
      referenceNumber: 'POST-${invoice.invoiceNumber}',
      date: recordedAt,
      temporal: TemporalJustification(
        transactionDate: recordedAt,
        effectiveDate: recordedAt,
        recordingDate: recordedAt,
      ),
      standards: const StandardsJustification(standardReference: 'IFRS 15.31'),
      description: 'Posted sales invoice',
      status: JournalEntryStatus.posted,
      lines: [
        JournalEntryLine(
          accountId: 'accounts-receivable',
          accountName: 'Accounts receivable',
          debit: amount,
          credit: Decimal.zero,
        ),
        JournalEntryLine(
          accountId: 'sales-revenue',
          accountName: 'Sales revenue',
          debit: Decimal.zero,
          credit: invoice.subtotalAmount,
        ),
        if (invoice.taxAmount > Decimal.zero)
          JournalEntryLine(
            accountId: 'vat-liability',
            accountName: 'VAT liability',
            debit: Decimal.zero,
            credit: invoice.taxAmount,
          ),
      ],
      sourceDocument: 'sales_invoice',
      sourceId: invoice.id,
      createdBy: actorId,
      createdAt: recordedAt,
      updatedAt: recordedAt,
    );
  }

  @override
  Future<void> commitSalesInvoice({
    required Invoice invoice,
    required JournalEntry journalEntry,
  }) async {
    if (repository.invoices.any((current) => current.id == invoice.id)) {
      await repository.updateInvoice(invoice);
    } else {
      await repository.addInvoice(invoice);
    }
    postedInvoices.add(invoice);
    postedEntries.add(journalEntry);
  }
}

void main() {
  late MockCustomerRepository mockCustomerRepository;
  late MockInvoiceRepository mockInvoiceRepository;
  late _FakeNotificationService notificationService;
  late _SalesInvoicePostingGatewayFake salesPostingGateway;

  setUp(() {
    mockCustomerRepository = MockCustomerRepository();
    mockInvoiceRepository = MockInvoiceRepository();
    notificationService = _FakeNotificationService();
    salesPostingGateway = _SalesInvoicePostingGatewayFake(
      mockInvoiceRepository,
    );
    _InvoiceAccountingServiceFake.postedInvoices.clear();
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
              permissions: Permission.all,
            ),
          ),
          customerRepositoryProvider.overrideWithValue(mockCustomerRepository),
          invoiceRepositoryProvider.overrideWithValue(mockInvoiceRepository),
          notificationServiceProvider.overrideWithValue(notificationService),
          accountingServiceProvider
              .overrideWith(_InvoiceAccountingServiceFake.new),
          salesInvoicePostingServiceProvider.overrideWith(
            (ref) async => SalesInvoicePostingService(
              gateway: salesPostingGateway,
              now: () => DateTime.utc(2026),
            ),
          ),
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
                widget is TextField &&
                widget.decoration?.labelText == 'اسم الصنف',
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
      await tester
          .tap(find.descendant(of: dialog, matching: find.text('إضافة')));
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

    testWidgets('يعاين الأثر ثم يرحل فاتورة مبيعات مرسلة بقيد محاسبي',
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
                widget is TextField &&
                widget.decoration?.labelText == 'اسم الصنف',
          ),
        ),
        'خدمة ترحيل',
      );
      await tester.enterText(
        find.descendant(
          of: dialog,
          matching: find.byWidgetPredicate(
            (widget) =>
                widget is TextField && widget.decoration?.labelText == 'الكمية',
          ),
        ),
        '1',
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
      await tester
          .tap(find.descendant(of: dialog, matching: find.text('إضافة')));
      await tester.pumpAndSettle();

      final previewAction = find.byKey(const Key('summaryRailPreviewAction'));
      await tester.ensureVisible(previewAction);
      await tester.tap(previewAction);
      await tester.pumpAndSettle();

      expect(find.text('معاينة الأثر'), findsNWidgets(2));
      expect(find.textContaining('Receivable - أحمد محمد'), findsOneWidget);

      final postAction = find.byKey(const Key('summaryRailPostAction'));
      await tester.ensureVisible(postAction);
      await tester.tap(postAction);
      await tester.pumpAndSettle();

      final confirmDialog = find.byType(AlertDialog);
      expect(confirmDialog, findsOneWidget);
      await tester.tap(
        find.descendant(
          of: confirmDialog,
          matching: find.byType(FilledButton),
        ),
      );
      await tester.pumpAndSettle();

      expect(mockInvoiceRepository.invoices, hasLength(1));
      expect(mockInvoiceRepository.invoices.single.status, InvoiceStatus.sent);
      expect(salesPostingGateway.postedInvoices, hasLength(1));
      expect(salesPostingGateway.postedEntries, hasLength(1));
      expect(salesPostingGateway.postedInvoices.single.type, InvoiceType.sales);
      expect(
        salesPostingGateway.postedEntries.single.auditLogs,
        hasLength(1),
      );

      await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('يحدّث فاتورة موجودة عبر مسار الحفظ مع إبقاء هويتها وبنودها',
        (tester) async {
      final existing = InvoiceFixtures.invoice1;
      mockInvoiceRepository.setInvoices([existing]);

      await tester.pumpWidget(createTestWidget(invoice: existing));
      await tester.pumpAndSettle();

      final saveAction = find.byKey(const Key('summaryRailSaveDraftAction'));
      await tester.ensureVisible(saveAction);
      await tester.tap(saveAction);
      await tester.pump(const Duration(milliseconds: 100));

      expect(mockInvoiceRepository.invoices, hasLength(1));
      final updated = mockInvoiceRepository.invoices.single;
      expect(updated.id, existing.id);
      expect(updated.invoiceNumber, existing.invoiceNumber);
      expect(updated.customerId, existing.customerId);
      expect(updated.status, InvoiceStatus.draft);
      expect(updated.items, hasLength(1));
      expect(updated.items.single.name, 'خدمة استشارية');
      expect(updated.totalAmount, Decimal.parse('1150'));

      await tester.pump(const Duration(seconds: 3));
    });
  });
}

class _MockCalendarNotifier extends CalendarNotifier {
  _MockCalendarNotifier(this.initial);
  final CalendarType initial;

  @override
  Future<CalendarType> build() async => initial;
}
