// Test doubles must implement generated value DTO interfaces to exercise DCO
// list decoders without invoking the native FFI bridge.
// ignore_for_file: avoid_implementing_value_types

import 'dart:async';

import 'package:basir_accounting_system/src/rust/api.dart';
import 'package:basir_accounting_system/src/rust/api/accounts.dart';
import 'package:basir_accounting_system/src/rust/api/assets.dart';
import 'package:basir_accounting_system/src/rust/api/auditor.dart';
import 'package:basir_accounting_system/src/rust/api/calendar.dart';
import 'package:basir_accounting_system/src/rust/api/currency.dart';
import 'package:basir_accounting_system/src/rust/api/inventory.dart';
import 'package:basir_accounting_system/src/rust/api/ledger.dart';
import 'package:basir_accounting_system/src/rust/api/purchasing.dart';
import 'package:basir_accounting_system/src/rust/api/reports.dart';
import 'package:basir_accounting_system/src/rust/api/sales.dart';
import 'package:basir_accounting_system/src/rust/api/standards.dart';
import 'package:basir_accounting_system/src/rust/api/zatca.dart';
import 'package:basir_accounting_system/src/rust/frb_generated.dart';
import 'package:basir_accounting_system/src/rust/frb_generated.io.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';
import 'package:flutter_rust_bridge/src/generalized_frb_rust_binding/_io.dart'
    as frb_io;
import 'package:flutter_rust_bridge/src/main_components/port_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _RecordedTask {
  const _RecordedTask(this.name, this.arguments);

  final String name;
  final Map<String, dynamic> arguments;
}

class _RecordingHandler extends BaseHandler {
  final tasks = <_RecordedTask>[];

  @override
  Future<S> executeNormal<S, E extends Object>(NormalTask<S, E> task) {
    tasks.add(_RecordedTask(task.constMeta.debugName, task.argMap));
    return Completer<S>().future;
  }

  @override
  S executeSync<S, E extends Object, WireSyncType>(
    SyncTask<S, E, WireSyncType> task,
  ) {
    tasks.add(_RecordedTask(task.constMeta.debugName, task.argMap));
    if (task.constMeta.debugName == 'scan_sequence') {
      return <AnomalyDto>[] as S;
    }
    return false as S;
  }
}

class _MockBinding extends Mock implements frb_io.GeneralizedFrbRustBinding {}

class _MockWire extends Mock implements RustLibWire {}

class _MockAccountDto extends Mock implements AccountDto {}

class _MockAssetCategoryDto extends Mock implements AssetCategoryDto {}

class _MockAssetDto extends Mock implements AssetDto {}

class _MockBillPaymentDto extends Mock implements BillPaymentDto {}

class _MockCustomerDto extends Mock implements CustomerDto {}

class _MockCustomerPaymentDto extends Mock implements CustomerPaymentDto {}

class _MockEntryDto extends Mock implements EntryDto {}

class _MockExchangeRateDto extends Mock implements ExchangeRateDto {}

class _MockInventoryItemDto extends Mock implements InventoryItemDto {}

class _MockPeriodDto extends Mock implements PeriodDto {}

class _MockPurchaseBillDto extends Mock implements PurchaseBillDto {}

class _MockSalesInvoiceDto extends Mock implements SalesInvoiceDto {}

class _MockSalesInvoiceLineDto extends Mock implements SalesInvoiceLineDto {}

class _MockStockMovementDto extends Mock implements StockMovementDto {}

class _MockVendorDto extends Mock implements VendorDto {}

class _MockZatcaCsrInputDto extends Mock implements ZatcaCsrInputDto {}

class _MockZatcaInvoiceInputDto extends Mock implements ZatcaInvoiceInputDto {}

AuditMetadataDto _auditMetadata() => const AuditMetadataDto(
      who: WhoDto(
        userId: 'auditor-1',
        userName: 'مراجع النظام',
        role: 'auditor',
        sessionId: 'session-1',
      ),
      where: WhereDto(systemId: 'basir-test'),
      why: WhyDto(reasonCode: 'coverage-contract'),
      how: HowDto(method: 'widget-test'),
    );

RustLibApiImpl _apiFor(_RecordingHandler handler) {
  final binding = _MockBinding();
  return RustLibApiImpl(
    handler: handler,
    wire: _MockWire(),
    generalizedFrbRustBinding: binding,
    portManager: PortManager(binding, handler),
  );
}

class _DcoProbe extends RustLibApiImpl {
  _DcoProbe({
    required super.handler,
    required super.wire,
    required frb_io.GeneralizedFrbRustBinding binding,
    required super.portManager,
  }) : super(
          generalizedFrbRustBinding: binding,
        );

  AccountDto account(dynamic raw) => dco_decode_account_dto(raw);
  CustomerDto customer(dynamic raw) => dco_decode_customer_dto(raw);
  EntryDto entry(dynamic raw) => dco_decode_entry_dto(raw);
  ExchangeRateDto exchangeRate(dynamic raw) =>
      dco_decode_exchange_rate_dto(raw);
  FinancialReportDto financialReport(dynamic raw) =>
      dco_decode_financial_report_dto(raw);
  InventoryItemDto inventoryItem(dynamic raw) =>
      dco_decode_inventory_item_dto(raw);
  PeriodDto period(dynamic raw) => dco_decode_period_dto(raw);
  PurchaseBillDto purchaseBill(dynamic raw) =>
      dco_decode_purchase_bill_dto(raw);
  SalesInvoiceDto salesInvoice(dynamic raw) =>
      dco_decode_sales_invoice_dto(raw);
  SalesInvoiceLineDto salesInvoiceLine(dynamic raw) =>
      dco_decode_sales_invoice_line_dto(raw);
  StandardDto standard(dynamic raw) => dco_decode_standard_dto(raw);
  StockMovementDto stockMovement(dynamic raw) =>
      dco_decode_stock_movement_dto(raw);
  TrialBalanceDto trialBalance(dynamic raw) =>
      dco_decode_trial_balance_dto(raw);
  ValuationItemDto valuationItem(dynamic raw) =>
      dco_decode_valuation_item_dto(raw);
  VendorDto vendor(dynamic raw) => dco_decode_vendor_dto(raw);
  ZakahCalendarDto zakahCalendar(dynamic raw) =>
      dco_decode_zakah_calendar_dto(raw);
  ZatcaCsrInputDto zatcaCsr(dynamic raw) => dco_decode_zatca_csr_input_dto(raw);
  List<AgingReportLineDto> agingLines(dynamic raw) =>
      dco_decode_list_aging_report_line_dto(raw);
  List<AnomalyDto> anomalies(dynamic raw) => dco_decode_list_anomaly_dto(raw);
  List<AssetCategoryDto> assetCategories(dynamic raw) =>
      dco_decode_list_asset_category_dto(raw);
  List<AssetDto> assets(dynamic raw) => dco_decode_list_asset_dto(raw);
  AuditMetadataDto auditMetadata(dynamic raw) =>
      dco_decode_audit_metadata_dto(raw);
  List<AuditRecordDto> auditRecords(dynamic raw) =>
      dco_decode_list_audit_record_dto(raw);
  BillPaymentDto billPayment(dynamic raw) => dco_decode_bill_payment_dto(raw);
  CustomerPaymentDto customerPayment(dynamic raw) =>
      dco_decode_customer_payment_dto(raw);
  List<DrillDownEntryDto> drillDownEntries(dynamic raw) =>
      dco_decode_list_drill_down_entry_dto(raw);
  InventoryValuationReportDto inventoryValuation(dynamic raw) =>
      dco_decode_inventory_valuation_report_dto(raw);
  List<AccountDto> accounts(dynamic raw) => dco_decode_list_account_dto(raw);
  List<CustomerDto> customers(dynamic raw) => dco_decode_list_customer_dto(raw);
  List<EntryDto> entries(dynamic raw) => dco_decode_list_entry_dto(raw);
  List<ExchangeRateDto> exchangeRates(dynamic raw) =>
      dco_decode_list_exchange_rate_dto(raw);
  List<FinancialReportLineDto> financialReportLines(dynamic raw) =>
      dco_decode_list_financial_report_line_dto(raw);
  List<InventoryItemDto> inventoryItems(dynamic raw) =>
      dco_decode_list_inventory_item_dto(raw);
  List<LineDto> lines(dynamic raw) => dco_decode_list_line_dto(raw);
  List<PeriodDto> periods(dynamic raw) => dco_decode_list_period_dto(raw);
  List<PurchaseBillDto> purchaseBills(dynamic raw) =>
      dco_decode_list_purchase_bill_dto(raw);
  List<SalesInvoiceDto> salesInvoices(dynamic raw) =>
      dco_decode_list_sales_invoice_dto(raw);
  List<SalesInvoiceLineDto> salesInvoiceLines(dynamic raw) =>
      dco_decode_list_sales_invoice_line_dto(raw);
  List<StandardDto> standards(dynamic raw) => dco_decode_list_standard_dto(raw);
  List<StockMovementDto> stockMovements(dynamic raw) =>
      dco_decode_list_stock_movement_dto(raw);
  List<TrialBalanceLineDto> trialBalanceLines(dynamic raw) =>
      dco_decode_list_trial_balance_line_dto(raw);
  List<ValuationItemDto> valuationItems(dynamic raw) =>
      dco_decode_list_valuation_item_dto(raw);
  List<VendorDto> vendors(dynamic raw) => dco_decode_list_vendor_dto(raw);
  List<ZatcaInvoiceLineDto> zatcaInvoiceLines(dynamic raw) =>
      dco_decode_list_zatca_invoice_line_dto(raw);
  List<(String, String)> stringPairs(dynamic raw) =>
      dco_decode_list_record_string_string(raw);
  Map<String, String>? stringMap(dynamic raw) =>
      dco_decode_opt_Map_String_String_None(raw);
  Uint8List bytes(dynamic raw) => dco_decode_list_prim_u_8_strict(raw);
  bool boolValue(dynamic raw) => dco_decode_bool(raw);
  int int32(dynamic raw) => dco_decode_i_32(raw);
  int uint32(dynamic raw) => dco_decode_u_32(raw);
  int uint8(dynamic raw) => dco_decode_u_8(raw);
  void unit(dynamic raw) => dco_decode_unit(raw);
  AccountDto boxedAccount(dynamic raw) =>
      dco_decode_box_autoadd_account_dto(raw);
  AssetCategoryDto boxedAssetCategory(dynamic raw) =>
      dco_decode_box_autoadd_asset_category_dto(raw);
  AssetDto boxedAsset(dynamic raw) => dco_decode_box_autoadd_asset_dto(raw);
  AuditMetadataDto boxedAuditMetadata(dynamic raw) =>
      dco_decode_box_autoadd_audit_metadata_dto(raw);
  BillPaymentDto boxedBillPayment(dynamic raw) =>
      dco_decode_box_autoadd_bill_payment_dto(raw);
  CustomerDto boxedCustomer(dynamic raw) =>
      dco_decode_box_autoadd_customer_dto(raw);
  CustomerPaymentDto boxedCustomerPayment(dynamic raw) =>
      dco_decode_box_autoadd_customer_payment_dto(raw);
  EntryDto boxedEntry(dynamic raw) => dco_decode_box_autoadd_entry_dto(raw);
  ExchangeRateDto boxedExchangeRate(dynamic raw) =>
      dco_decode_box_autoadd_exchange_rate_dto(raw);
  InventoryItemDto boxedInventoryItem(dynamic raw) =>
      dco_decode_box_autoadd_inventory_item_dto(raw);
  PeriodDto boxedPeriod(dynamic raw) => dco_decode_box_autoadd_period_dto(raw);
  PurchaseBillDto boxedPurchaseBill(dynamic raw) =>
      dco_decode_box_autoadd_purchase_bill_dto(raw);
  SalesInvoiceDto boxedSalesInvoice(dynamic raw) =>
      dco_decode_box_autoadd_sales_invoice_dto(raw);
  StockMovementDto boxedStockMovement(dynamic raw) =>
      dco_decode_box_autoadd_stock_movement_dto(raw);
  VendorDto boxedVendor(dynamic raw) => dco_decode_box_autoadd_vendor_dto(raw);
  ZatcaCsrInputDto boxedZatcaCsr(dynamic raw) =>
      dco_decode_box_autoadd_zatca_csr_input_dto(raw);
  ZatcaInvoiceInputDto boxedZatcaInvoice(dynamic raw) =>
      dco_decode_box_autoadd_zatca_invoice_input_dto(raw);
  AccountDto? optionalAccount(dynamic raw) =>
      dco_decode_opt_box_autoadd_account_dto(raw);
  AssetDto? optionalAsset(dynamic raw) =>
      dco_decode_opt_box_autoadd_asset_dto(raw);
  ExchangeRateDto? optionalExchangeRate(dynamic raw) =>
      dco_decode_opt_box_autoadd_exchange_rate_dto(raw);
  InventoryItemDto? optionalInventoryItem(dynamic raw) =>
      dco_decode_opt_box_autoadd_inventory_item_dto(raw);
  PeriodDto? optionalPeriod(dynamic raw) =>
      dco_decode_opt_box_autoadd_period_dto(raw);
  PurchaseBillDto? optionalPurchaseBill(dynamic raw) =>
      dco_decode_opt_box_autoadd_purchase_bill_dto(raw);
  SalesInvoiceDto? optionalSalesInvoice(dynamic raw) =>
      dco_decode_opt_box_autoadd_sales_invoice_dto(raw);
  VendorDto? optionalVendor(dynamic raw) =>
      dco_decode_opt_box_autoadd_vendor_dto(raw);
  ZatcaInvoiceInputDto zatcaInvoice(dynamic raw) =>
      dco_decode_zatca_invoice_input_dto(raw);
}

_DcoProbe _dcoProbe() {
  final handler = _RecordingHandler();
  final binding = _MockBinding();
  return _DcoProbe(
    handler: handler,
    wire: _MockWire(),
    binding: binding,
    portManager: PortManager(binding, handler),
  );
}

void main() {
  group('RustLibApiImpl bridge task contracts', () {
    test('يحافظ على تعريفات مهام دفتر الأستاذ والتقارير ووسائطها', () {
      final handler = _RecordingHandler();
      final api = _apiFor(handler);
      final metadata = _auditMetadata();
      final entry = _MockEntryDto();

      unawaited(
        api.crateApiCalendarCloseFinancialYear(
          periodId: 'FY-2026',
          closingDate: '2026-12-31',
          retainedEarningsAccountId: '3200',
        ),
      );
      unawaited(
        api.crateApiCalendarClosePeriod(id: 'P-2026-01', userId: 'u-1'),
      );
      unawaited(
        api.crateApiReportsGenerateBalanceSheet(
          asOfDate: '2026-01-31',
          fairValuationUpdates: const {'asset-1': '12.50'},
        ),
      );
      unawaited(
        api.crateApiReportsGenerateCashFlowStatement(
          fromDate: '2026-01-01',
          toDate: '2026-01-31',
        ),
      );
      unawaited(
        api.crateApiReportsGenerateIncomeStatement(
          fromDate: '2026-01-01',
          toDate: '2026-01-31',
        ),
      );
      unawaited(
        api.crateApiReportsGenerateTrialBalance(
          asOfDate: '2026-01-31',
          periodStart: '2026-01-01',
        ),
      );
      unawaited(
        api.crateApiLedgerPostJournalEntry(
          dto: entry,
          metadata: metadata,
        ),
      );
      unawaited(
        api.crateApiLedgerReverseJournalEntry(
          entryId: 'JE-1',
          reason: 'تصحيح محاسبي معتمد',
          metadata: metadata,
        ),
      );
      unawaited(api.crateApiLedgerValidateJournalEntry(dto: entry));
      unawaited(
        api.crateApiLedgerLogAgentConsensus(
          entryId: 'JE-1',
          consensusJson: '{"decision":"approve"}',
          metadata: metadata,
        ),
      );
      unawaited(
        api.crateApiReportsGetAccountEntries(
          accountId: '1101',
          periodStart: '2026-01-01',
          periodEnd: '2026-01-31',
        ),
      );
      unawaited(
        api.crateApiLedgerListJournalEntries(
          limit: 50,
          offset: 0,
          fromDate: '2026-01-01',
          toDate: '2026-01-31',
          accountId: '1101',
        ),
      );

      expect(
        handler.tasks.map((task) => task.name),
        containsAll(<String>[
          'close_financial_year',
          'close_period',
          'generate_balance_sheet',
          'generate_cash_flow_statement',
          'generate_income_statement',
          'generate_trial_balance',
          'post_journal_entry',
          'reverse_journal_entry',
          'validate_journal_entry',
          'log_agent_consensus',
          'get_account_entries',
          'list_journal_entries',
        ]),
      );
      expect(handler.tasks.first.arguments, <String, dynamic>{
        'periodId': 'FY-2026',
        'closingDate': '2026-12-31',
        'retainedEarningsAccountId': '3200',
      });
      expect(
        handler.tasks
            .singleWhere((task) => task.name == 'post_journal_entry')
            .arguments,
        <String, dynamic>{'dto': entry, 'metadata': metadata},
      );
    });

    test('يعرّف مسارات المخزون والأصول والعملات بوسائط قابلة للتتبع', () {
      final handler = _RecordingHandler();
      final api = _apiFor(handler);
      final metadata = _auditMetadata();

      unawaited(api.crateApiInventoryGetItemById(id: 'ITEM-1'));
      unawaited(api.crateApiInventoryGetValuationReport(asOf: '2026-01-31'));
      unawaited(api.crateApiInventoryListItems());
      unawaited(api.crateApiInventoryListMovements(itemId: 'ITEM-1'));
      unawaited(
        api.crateApiInventoryRecordImpairment(
          itemId: 'ITEM-1',
          totalImpairmentAmount: '25.00',
          referenceId: 'ADJ-1',
          metadata: metadata,
        ),
      );
      unawaited(
        api.crateApiInventoryRecordMovement(
          movement: _MockStockMovementDto(),
          metadata: metadata,
        ),
      );
      unawaited(
        api.crateApiInventoryRecordPurchase(
          itemId: 'ITEM-1',
          quantity: '4',
          unitCost: '25.00',
          metadata: metadata,
        ),
      );
      unawaited(
        api.crateApiInventoryRecordSale(
          itemId: 'ITEM-1',
          quantity: '1',
          referenceId: 'INV-1',
          metadata: metadata,
        ),
      );
      unawaited(api.crateApiInventorySaveItem(item: _MockInventoryItemDto()));
      unawaited(api.crateApiInventoryVerifyInventoryChain(itemId: 'ITEM-1'));
      unawaited(api.crateApiAssetsGetAssetById(id: 'ASSET-1'));
      unawaited(api.crateApiAssetsListAssets());
      unawaited(api.crateApiAssetsListCategories());
      unawaited(api.crateApiAssetsRegisterAsset(asset: _MockAssetDto()));
      unawaited(
        api.crateApiAssetsRegisterCategory(
          category: _MockAssetCategoryDto(),
        ),
      );
      unawaited(
        api.crateApiAssetsRunDepreciationCycle(
          assetId: 'ASSET-1',
          asOf: '2026-01-31',
          metadata: metadata,
        ),
      );
      unawaited(
        api.crateApiCurrencyGetExchangeRate(
          base: 'SAR',
          target: 'USD',
          date: '2026-01-31',
        ),
      );
      unawaited(
        api.crateApiCurrencyListExchangeRates(base: 'SAR', target: 'USD'),
      );
      unawaited(
        api.crateApiCurrencyPerformRevaluation(
          date: '2026-01-31',
          systemBase: 'SAR',
          unrealizedGainLossAccountId: '5100',
          metadata: metadata,
        ),
      );
      unawaited(
        api.crateApiCurrencySaveExchangeRate(
          dto: _MockExchangeRateDto(),
        ),
      );

      expect(handler.tasks, hasLength(20));
      expect(
        handler.tasks
            .singleWhere((task) => task.name == 'record_purchase')
            .arguments,
        <String, dynamic>{
          'itemId': 'ITEM-1',
          'quantity': '4',
          'unitCost': '25.00',
          'referenceId': null,
          'metadata': metadata,
        },
      );
      expect(
        handler.tasks
            .singleWhere((task) => task.name == 'verify_inventory_chain')
            .arguments['itemId'],
        'ITEM-1',
      );
    });

    test('ينقل عقود العملاء والفواتير والموردين وZATCA دون FFI فعلي', () {
      final handler = _RecordingHandler();
      final api = _apiFor(handler);
      final metadata = _auditMetadata();

      unawaited(
        api.crateApiAccountsCreateAccount(
          dto: _MockAccountDto(),
          metadata: metadata,
        ),
      );
      unawaited(api.crateApiAccountsGetAccountById(id: '1101'));
      unawaited(api.crateApiAccountsListAccounts());
      unawaited(
        api.crateApiAccountsUpdateAccount(
          dto: _MockAccountDto(),
          metadata: metadata,
        ),
      );
      unawaited(
        api.crateApiAccountsUpdateAccountCategory(
          accountId: '1101',
          category: 'operating',
          metadata: metadata,
        ),
      );
      unawaited(api.crateApiSalesCreateCustomer(customer: _MockCustomerDto()));
      unawaited(
        api.crateApiSalesCreateInvoice(
          invoice: _MockSalesInvoiceDto(),
          lines: <SalesInvoiceLineDto>[_MockSalesInvoiceLineDto()],
          metadata: metadata,
        ),
      );
      unawaited(api.crateApiSalesDeleteCustomer(id: 'C-1'));
      unawaited(api.crateApiSalesDeleteInvoice(id: 'INV-1'));
      unawaited(api.crateApiSalesGetInvoiceById(id: 'INV-1'));
      unawaited(api.crateApiSalesListCustomers());
      unawaited(api.crateApiSalesListInvoices());
      unawaited(api.crateApiSalesPostInvoice(id: 'INV-1', metadata: metadata));
      unawaited(
        api.crateApiSalesRecordCustomerPayment(
          payment: _MockCustomerPaymentDto(),
          metadata: metadata,
        ),
      );
      unawaited(api.crateApiSalesUpdateCustomer(customer: _MockCustomerDto()));
      unawaited(
        api.crateApiPurchasingCreatePurchaseBill(
          bill: _MockPurchaseBillDto(),
          metadata: metadata,
        ),
      );
      unawaited(api.crateApiPurchasingCreateVendor(vendor: _MockVendorDto()));
      unawaited(api.crateApiPurchasingDeleteBill(id: 'BILL-1'));
      unawaited(api.crateApiPurchasingDeleteVendor(id: 'V-1'));
      unawaited(api.crateApiPurchasingGetPurchaseBillById(id: 'BILL-1'));
      unawaited(api.crateApiPurchasingGetVendorById(id: 'V-1'));
      unawaited(api.crateApiPurchasingListPurchaseBills());
      unawaited(api.crateApiPurchasingListVendors());
      unawaited(
        api.crateApiPurchasingRecordBillPayment(
          payment: _MockBillPaymentDto(),
          metadata: metadata,
        ),
      );
      unawaited(api.crateApiPurchasingUpdateVendor(vendor: _MockVendorDto()));
      unawaited(api.crateApiCalendarGetPeriodByDate(date: '2026-01-31'));
      unawaited(api.crateApiCalendarListPeriods());
      unawaited(api.crateApiCalendarSavePeriod(dto: _MockPeriodDto()));
      unawaited(
        api.crateApiZatcaGenerateZatcaCsr(
          input: _MockZatcaCsrInputDto(),
          keyPairPem: 'test-key-pair',
        ),
      );
      unawaited(api.crateApiZatcaGenerateZatcaKeyPair());
      unawaited(
        api.crateApiZatcaGenerateZatcaSignedXml(
          input: _MockZatcaInvoiceInputDto(),
          certificatePem: 'test-certificate',
          privateKeyPem: 'test-private-key',
        ),
      );
      unawaited(api.crateApiInitApi(databaseUrl: 'postgres://local-test'));
      unawaited(api.crateApiReportsGetPayablesAging(asOfDate: '2026-01-31'));
      unawaited(api.crateApiReportsGetReceivablesAging(asOfDate: '2026-01-31'));

      expect(api.crateApiCheckHealth(), isFalse);
      expect(handler.tasks, hasLength(35));
      expect(
        handler.tasks
            .singleWhere((task) => task.name == 'create_invoice')
            .arguments['lines'],
        hasLength(1),
      );
      expect(
        handler.tasks
            .singleWhere((task) => task.name == 'generate_zatca_signed_xml')
            .arguments
            .keys,
        containsAll(<String>['input', 'certificatePem', 'privateKeyPem']),
      );
    });

    test('يغطي عقود التدقيق والمعايير والزكاة المتبقية', () {
      final handler = _RecordingHandler();
      final api = _apiFor(handler);
      final entry = _MockEntryDto();

      expect(
        api.crateApiAuditorScanSequence(
          prefix: 'ledger-chain',
          entries: <EntryDto>[entry],
        ),
        isEmpty,
      );
      unawaited(api.crateApiLedgerGetAgentConsensus(entryId: 'JE-42'));
      unawaited(api.crateApiLedgerListAuditLogs(entityId: 'JE-42'));
      unawaited(
        api.crateApiReportsGenerateZakahStatement(
          asOfDate: '2026-08-14',
          calendar: ZakahCalendarDto.hijri,
        ),
      );
      unawaited(api.crateApiStandardsGetStandardInfo(reference: 'IAS 2'));
      unawaited(api.crateApiStandardsSearchStandards(query: 'inventory'));

      expect(
        handler.tasks.map((task) => task.name),
        containsAll(<String>[
          'scan_sequence',
          'get_agent_consensus',
          'list_audit_logs',
          'generate_zakah_statement',
          'get_standard_info',
          'search_standards',
        ]),
      );
      expect(
        handler.tasks
            .singleWhere((task) => task.name == 'scan_sequence')
            .arguments,
        <String, dynamic>{
          'prefix': 'ledger-chain',
          'entries': <EntryDto>[entry],
        },
      );
      expect(
        handler.tasks
            .singleWhere((task) => task.name == 'generate_zakah_statement')
            .arguments,
        <String, dynamic>{
          'asOfDate': '2026-08-14',
          'calendar': ZakahCalendarDto.hijri,
        },
      );
    });

    test('يفك عقود DCO المحاسبية والمخزنية والتقريرية إلى DTO صحيحة', () {
      final api = _dcoProbe();

      final account = api.account(<dynamic>[
        'ACC-1',
        '1101',
        'الصندوق',
        'Cash',
        'asset',
        null,
        'IAS 1',
        'current',
        'operating',
        'SAR',
      ]);
      final customer = api.customer(<dynamic>[
        null,
        'C-100',
        'عميل الاختبار',
        'Test customer',
        '3000000000',
      ]);
      final entry = api.entry(<dynamic>[
        'JE-1',
        'JE-2026-001',
        'قيد افتتاحي',
        '2026-01-01',
        'IAS 1',
        <dynamic>[
          <dynamic>[
            '1101',
            '125.50',
            true,
            'مدين',
            'USD',
            '3.75',
            '33.47',
          ],
          <dynamic>[
            '3101',
            '125.50',
            false,
            'دائن',
            null,
            null,
            null,
          ],
        ],
        null,
        'opening',
      ]);
      final exchangeRate = api.exchangeRate(<dynamic>[
        'SAR',
        'USD',
        '3.75',
        '2026-01-31',
        'SAMA',
      ]);
      final inventoryItem = api.inventoryItem(<dynamic>[
        'ITEM-1',
        'STK-100',
        'مخزون تجريبي',
        'Test inventory',
        'قابل للقياس بالتكلفة',
        'قطعة',
        '5',
        'FIFO',
        '10.00',
        '15.00',
        '1301',
        '5101',
        '4101',
        '2026-01-01T00:00:00Z',
        '2026-01-31T00:00:00Z',
      ]);
      final report = api.financialReport(<dynamic>[
        'قائمة الدخل',
        '2026-01-01',
        '2026-01-31',
        <dynamic>[
          <dynamic>['الإيرادات', '1500.00', true, false, 0],
          <dynamic>['صافي الربح', '450.00', false, true, 1],
        ],
        '2026-01-31T23:59:59Z',
      ]);

      expect(account.code, '1101');
      expect(account.parentId, isNull);
      expect(customer.taxId, '3000000000');
      expect(entry.lines, hasLength(2));
      expect(entry.lines.first.originalCurrency, 'USD');
      expect(entry.lines.last.isDebit, isFalse);
      expect(exchangeRate.source, 'SAMA');
      expect(inventoryItem.valuationMethod, 'FIFO');
      expect(inventoryItem.minStockLevel, '5');
      expect(report.lines, hasLength(2));
      expect(report.lines.last.isTotal, isTrue);
    });

    test('يفك DCO مسارات الفترات والمبيعات والمشتريات والامتثال', () {
      final api = _dcoProbe();

      final period = api.period(<dynamic>[
        'P-2026-01',
        'يناير 2026',
        '2026-01-01',
        '2026-01-31',
        'open',
        false,
      ]);
      final purchaseBill = api.purchaseBill(<dynamic>[
        'BILL-1',
        'PB-2026-001',
        'V-1',
        '2026-01-05',
        '2026-02-05',
        '575.00',
        '575.00',
        'open',
        '5101',
        '2101',
        null,
      ]);
      final salesInvoice = api.salesInvoice(<dynamic>[
        'INV-1',
        'SI-2026-001',
        'C-1',
        '2026-01-10',
        '2026-02-10',
        'posted',
        '230.00',
        '0.00',
        'فاتورة خاضعة للضريبة',
        '4101',
        '1201',
        'qr-payload',
      ]);
      final invoiceLine = api.salesInvoiceLine(<dynamic>[
        'ITEM-1',
        'خدمة استشارية',
        '2',
        '100.00',
        '30.00',
        'S',
      ]);
      final movement = api.stockMovement(<dynamic>[
        null,
        'ITEM-1',
        'purchase',
        '5',
        '10.00',
        'BILL-1',
        '2026-01-05',
        null,
      ]);
      final trialBalance = api.trialBalance(<dynamic>[
        '2026-01-31',
        null,
        '2026-01-31',
        <dynamic>[
          <dynamic>['ACC-1', '1101', 'الصندوق', '100.00', '0.00'],
          <dynamic>['ACC-2', '3101', 'رأس المال', '0.00', '100.00'],
        ],
        '100.00',
        '100.00',
        true,
      ]);
      final valuation = api.valuationItem(<dynamic>[
        'ITEM-1',
        'مخزون',
        'Inventory',
        '5',
        '10.00',
        '50.00',
      ]);
      final vendor = api.vendor(<dynamic>[
        null,
        'V-100',
        'مورد الاختبار',
        'Test vendor',
        null,
      ]);
      final standard = api.standard(<dynamic>['IAS 2', 'Inventories', true]);
      final csr = api.zatcaCsr(<dynamic>[
        'Basir',
        'Finance',
        'Basir Accounting',
        'SA',
        'CR-100',
        '3000000000',
        'Software',
        'Riyadh',
      ]);

      expect(period.id, 'P-2026-01');
      expect(period.isYearEnd, isFalse);
      expect(purchaseBill.description, isNull);
      expect(salesInvoice.qrCodeData, 'qr-payload');
      expect(invoiceLine.productId, 'ITEM-1');
      expect(movement.referenceId, 'BILL-1');
      expect(movement.description, isNull);
      expect(trialBalance.isBalanced, isTrue);
      expect(trialBalance.lines, hasLength(2));
      expect(valuation.totalValue, '50.00');
      expect(vendor.taxId, isNull);
      expect(standard.isEffective, isTrue);
      expect(api.zakahCalendar(0), ZakahCalendarDto.hijri);
      expect(csr.country, 'SA');
    });

    test('يفك DCO القوائم والخيارات المركبة للأصول والتدقيق والتحصيل', () {
      final api = _dcoProbe();
      final assets = api.assets(<dynamic>[
        <dynamic>[
          'ASSET-1',
          'FA-001',
          'خادم محاسبي',
          'Accounting server',
          'CAT-IT',
          '2025-01-01',
          '12000.00',
          '2000.00',
          5,
          'straight_line',
          '1500.00',
          '1501',
          '5501',
          '1502',
          true,
        ],
      ]);
      final categories = api.assetCategories(<dynamic>[
        <dynamic>[
          null,
          'تقنية',
          'Technology',
          'straight_line',
          5,
          '1501',
          '5501',
          '1502',
        ],
      ]);
      final billPayment = api.billPayment(<dynamic>[
        null,
        'BILL-1',
        '575.00',
        '2026-02-01',
        'bank_transfer',
        'BANK-1',
        'TRX-1',
      ]);
      final customerPayment = api.customerPayment(<dynamic>[
        'CP-1',
        'INV-1',
        '230.00',
        '2026-02-02',
        'BANK-1',
        'mada',
        null,
      ]);
      final agingLines = api.agingLines(<dynamic>[
        <dynamic>[
          'C-1',
          'عميل الاختبار',
          '100.00',
          '50.00',
          '25.00',
          '10.00',
          '5.00',
          '190.00',
        ],
      ]);
      final drillDownEntries = api.drillDownEntries(<dynamic>[
        <dynamic>[
          'JE-1',
          'JE-2026-001',
          '2026-01-01',
          'ترحيل افتتاحي',
          '100.00',
          '0.00',
          null,
        ],
      ]);
      final valuation = api.inventoryValuation(<dynamic>[
        '2026-01-31',
        <dynamic>[
          <dynamic>['ITEM-1', 'مخزون', 'Inventory', '5', '10.00', '50.00'],
        ],
        '50.00',
      ]);

      expect(assets.single.usefulLifeYears, 5);
      expect(categories.single.id, isNull);
      expect(billPayment.reference, 'TRX-1');
      expect(customerPayment.reference, isNull);
      expect(agingLines.single.totalAmount, '190.00');
      expect(drillDownEntries.single.standardReference, isNull);
      expect(valuation.items.single.itemId, 'ITEM-1');
    });

    test('يفك DCO سجلات التدقيق وحالات الشذوذ الثلاث بعقود سياقية مكتملة', () {
      final api = _dcoProbe();
      final who = <dynamic>['U-1', 'مراجع', 'auditor', 'S-1'];
      final where = <dynamic>['basir', null, 'Riyadh', null, '1.0.0'];
      final why = <dynamic>['audit', 'monthly review', null];
      final how = <dynamic>['automated', null, '/audit/records'];
      final metadata = api.auditMetadata(<dynamic>[who, where, why, how]);
      final records = api.auditRecords(<dynamic>[
        <dynamic>[
          'AR-1',
          who,
          <dynamic>['update', 'entry', 'JE-1', 'تم الترحيل', null, 'posted'],
          '2026-01-31T12:00:00Z',
          where,
          why,
          how,
          'hash-1',
          'hash-0',
          true,
        ],
      ]);
      final anomalies = api.anomalies(<dynamic>[
        <dynamic>[0, '100', '102'],
        <dynamic>[1, 'ACC-1', '120.00', '100.00'],
        <dynamic>[2, 'JE-DRAFT', '2026-01-30'],
      ]);

      expect(metadata.who.userId, 'U-1');
      expect(metadata.how.apiEndpoint, '/audit/records');
      expect(records.single.what.newValue, 'posted');
      expect(records.single.isVerified, isTrue);
      expect(anomalies, hasLength(3));
      expect(anomalies[0], isA<AnomalyDto_SequenceGap>());
      expect(anomalies[1], isA<AnomalyDto_ReconciliationMismatch>());
      expect(anomalies[2], isA<AnomalyDto_OrphanedDraft>());
    });

    test('يفك مسارات DCO المتبقية للقوائم والصناديق والخيارات وZATCA', () {
      final api = _dcoProbe();
      final account = <dynamic>[
        'ACC-1',
        '1101',
        'الصندوق',
        'Cash',
        'asset',
        null,
        'IAS 1',
        'current',
        'operating',
        'SAR',
      ];
      final category = <dynamic>[
        'CAT-1',
        'تقنية',
        'Technology',
        'straight_line',
        5,
        '1501',
        '5501',
        '1502',
      ];
      final asset = <dynamic>[
        'ASSET-1',
        'FA-001',
        'خادم',
        'Server',
        'CAT-1',
        '2025-01-01',
        '12000.00',
        '2000.00',
        5,
        'straight_line',
        '1500.00',
        '1501',
        '5501',
        '1502',
        true,
      ];
      final metadata = <dynamic>[
        <dynamic>['U-1', 'مراجع', 'auditor', 'S-1'],
        <dynamic>['basir', null, null, null, null],
        <dynamic>['audit', null, null],
        <dynamic>['automated', null, null],
      ];
      final billPayment = <dynamic>[
        'BP-1',
        'BILL-1',
        '50.00',
        '2026-02-01',
        'bank_transfer',
        'BANK-1',
        'REF-1',
      ];
      final customer = <dynamic>[
        'C-1',
        'C-100',
        'عميل',
        'Customer',
        '3000000000',
      ];
      final customerPayment = <dynamic>[
        'CP-1',
        'INV-1',
        '50.00',
        '2026-02-02',
        'BANK-1',
        'mada',
        'REF-2',
      ];
      final line = <dynamic>[
        '1101',
        '50.00',
        true,
        'إثبات',
        null,
        null,
        null,
      ];
      final entry = <dynamic>[
        'JE-1',
        'JE-2026-001',
        'قيد',
        '2026-01-01',
        'IAS 1',
        <dynamic>[line],
        null,
        null,
      ];
      final exchangeRate = <dynamic>[
        'SAR',
        'USD',
        '3.75',
        '2026-01-31',
        'SAMA',
      ];
      final inventoryItem = <dynamic>[
        'ITEM-1',
        'STK-100',
        'مخزون',
        'Stock',
        null,
        'قطعة',
        null,
        'FIFO',
        null,
        null,
        '1301',
        '5101',
        '4101',
        '2026-01-01T00:00:00Z',
        '2026-01-31T00:00:00Z',
      ];
      final period = <dynamic>[
        'P-1',
        'يناير',
        '2026-01-01',
        '2026-01-31',
        'open',
        false,
      ];
      final purchaseBill = <dynamic>[
        'BILL-1',
        'PB-1',
        'V-1',
        '2026-01-01',
        '2026-02-01',
        '50.00',
        '50.00',
        'open',
        '5101',
        '2101',
        null,
      ];
      final salesInvoice = <dynamic>[
        'INV-1',
        'SI-1',
        'C-1',
        '2026-01-01',
        '2026-02-01',
        'posted',
        '50.00',
        '0.00',
        null,
        '4101',
        '1201',
        null,
      ];
      final salesInvoiceLine = <dynamic>[
        'ITEM-1',
        'خدمة',
        '1',
        '50.00',
        '7.50',
        'S',
      ];
      final standard = <dynamic>['IAS 2', 'Inventories', true];
      final movement = <dynamic>[
        'MOVE-1',
        'ITEM-1',
        'purchase',
        '5',
        '10.00',
        null,
        '2026-01-01',
        null,
      ];
      final trialBalanceLine = <dynamic>[
        'ACC-1',
        '1101',
        'الصندوق',
        '50.00',
        '0.00',
      ];
      final valuation = <dynamic>[
        'ITEM-1',
        'مخزون',
        'Stock',
        '5',
        '10.00',
        '50.00',
      ];
      final vendor = <dynamic>['V-1', 'V-100', 'مورد', 'Vendor', null];
      final csr = <dynamic>[
        'Basir',
        'Finance',
        'Basir Accounting',
        'SA',
        'CR-1',
        '3000000000',
        'Software',
        'Riyadh',
      ];
      final zatcaLine = <dynamic>['L-1', '1', '50.00', 'S', 'خدمة'];
      final zatcaInvoice = <dynamic>[
        'INV-1',
        'uuid-1',
        '2026-01-01',
        '10:00:00',
        '388',
        1,
        'previous-hash',
        <dynamic>['seller-vat', 'VAT'],
        <dynamic>['buyer-vat', 'VAT'],
        <dynamic>[zatcaLine],
      ];

      expect(api.accounts(<dynamic>[account]).single.code, '1101');
      expect(api.customers(<dynamic>[customer]).single.code, 'C-100');
      expect(api.entries(<dynamic>[entry]).single.lines, hasLength(1));
      expect(api.exchangeRates(<dynamic>[exchangeRate]).single.rate, '3.75');
      expect(
        api
            .financialReportLines(<dynamic>[
              <dynamic>['الإيرادات', '50.00', false, true, 0],
            ])
            .single
            .isTotal,
        isTrue,
      );
      expect(
        api.inventoryItems(<dynamic>[inventoryItem]).single.code,
        'STK-100',
      );
      expect(api.lines(<dynamic>[line]).single.isDebit, isTrue);
      expect(api.periods(<dynamic>[period]).single.status, 'open');
      expect(
        api.purchaseBills(<dynamic>[purchaseBill]).single.billNumber,
        'PB-1',
      );
      expect(
        api.salesInvoices(<dynamic>[salesInvoice]).single.invoiceNumber,
        'SI-1',
      );
      expect(
        api.salesInvoiceLines(<dynamic>[salesInvoiceLine]).single.quantity,
        '1',
      );
      expect(api.standards(<dynamic>[standard]).single.reference, 'IAS 2');
      expect(api.stockMovements(<dynamic>[movement]).single.itemId, 'ITEM-1');
      expect(
        api.trialBalanceLines(<dynamic>[trialBalanceLine]).single.accountCode,
        '1101',
      );
      expect(
        api.valuationItems(<dynamic>[valuation]).single.totalValue,
        '50.00',
      );
      expect(api.vendors(<dynamic>[vendor]).single.code, 'V-100');
      expect(
        api.zatcaInvoiceLines(<dynamic>[zatcaLine]).single.itemName,
        'خدمة',
      );
      expect(
        api.stringPairs(<dynamic>[
          <dynamic>['currency', 'SAR'],
        ]),
        [
          ('currency', 'SAR'),
        ],
      );
      expect(
        api.stringMap(<dynamic>[
          <dynamic>['currency', 'SAR'],
        ]),
        {
          'currency': 'SAR',
        },
      );
      expect(api.stringMap(null), isNull);
      expect(api.bytes(Uint8List.fromList(<int>[1, 2, 3])), <int>[1, 2, 3]);
      expect(api.boolValue(true), isTrue);
      expect(api.int32(-32), -32);
      expect(api.uint32(32), 32);
      expect(api.uint8(8), 8);
      api.unit(null);

      expect(api.boxedAccount(account).code, '1101');
      expect(api.boxedAssetCategory(category).id, 'CAT-1');
      expect(api.boxedAsset(asset).code, 'FA-001');
      expect(api.boxedAuditMetadata(metadata).who.role, 'auditor');
      expect(api.boxedBillPayment(billPayment).reference, 'REF-1');
      expect(api.boxedCustomer(customer).taxId, '3000000000');
      expect(api.boxedCustomerPayment(customerPayment).reference, 'REF-2');
      expect(api.boxedEntry(entry).entryId, 'JE-1');
      expect(api.boxedExchangeRate(exchangeRate).source, 'SAMA');
      expect(api.boxedInventoryItem(inventoryItem).valuationMethod, 'FIFO');
      expect(api.boxedPeriod(period).id, 'P-1');
      expect(api.boxedPurchaseBill(purchaseBill).vendorId, 'V-1');
      expect(api.boxedSalesInvoice(salesInvoice).customerId, 'C-1');
      expect(api.boxedStockMovement(movement).movementType, 'purchase');
      expect(api.boxedVendor(vendor).nameEn, 'Vendor');
      expect(api.boxedZatcaCsr(csr).country, 'SA');
      expect(api.boxedZatcaInvoice(zatcaInvoice).lines.single.id, 'L-1');

      expect(api.optionalAccount(null), isNull);
      expect(api.optionalAsset(null), isNull);
      expect(api.optionalExchangeRate(null), isNull);
      expect(api.optionalInventoryItem(null), isNull);
      expect(api.optionalPeriod(null), isNull);
      expect(api.optionalPurchaseBill(null), isNull);
      expect(api.optionalSalesInvoice(null), isNull);
      expect(api.optionalVendor(null), isNull);
      expect(api.optionalAccount(account)?.currency, 'SAR');
      expect(api.optionalAsset(asset)?.id, 'ASSET-1');
      expect(api.optionalExchangeRate(exchangeRate)?.targetCurrency, 'USD');
      expect(api.optionalInventoryItem(inventoryItem)?.id, 'ITEM-1');
      expect(api.optionalPeriod(period)?.name, 'يناير');
      expect(api.optionalPurchaseBill(purchaseBill)?.id, 'BILL-1');
      expect(api.optionalSalesInvoice(salesInvoice)?.id, 'INV-1');
      expect(api.optionalVendor(vendor)?.id, 'V-1');
      expect(api.zatcaInvoice(zatcaInvoice).invoiceCounterValue, BigInt.one);
    });
  });
}
