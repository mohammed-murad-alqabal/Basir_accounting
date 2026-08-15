import 'dart:convert';

import 'package:basir_accounting_system/core/models/sync_status.dart';
import 'package:basir_accounting_system/core/services/sync_service.dart';
import 'package:basir_accounting_system/features/accounting/data/models/account_model.dart';
import 'package:basir_accounting_system/features/accounting/data/models/financial_voucher_model.dart';
import 'package:basir_accounting_system/features/accounting/data/models/financial_year_model.dart';
import 'package:basir_accounting_system/features/accounting/data/models/journal_entry_model.dart';
import 'package:basir_accounting_system/features/customers/data/models/customer_model.dart';
import 'package:basir_accounting_system/features/invoices/data/models/invoice_model.dart';
import 'package:basir_accounting_system/features/settings/data/models/business_settings_model.dart';
import 'package:basir_accounting_system/features/settings/data/models/profile_model.dart';
import 'package:basir_accounting_system/features/vendors/data/models/vendor_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:isar/isar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  late Isar isar;
  late ProviderContainer container;
  late _SyncHttpClient httpClient;
  late SyncService service;
  late SupabaseClient supabase;

  setUp(() async {
    httpClient = _SyncHttpClient();
    supabase = SupabaseClient(
      'https://sync.basir.test',
      'test-anon-key',
      httpClient: httpClient,
    );
    isar = await Isar.open(
      [
        AccountModelSchema,
        BusinessSettingsModelSchema,
        CustomerModelSchema,
        FinancialVoucherModelSchema,
        FinancialYearModelSchema,
        InvoiceModelSchema,
        JournalEntryModelSchema,
        ProfileModelSchema,
        VendorModelSchema,
      ],
      directory: '',
      name: 'sync_service_${DateTime.now().microsecondsSinceEpoch}',
    );
    container = ProviderContainer();
    service = container.read(syncServiceProvider.notifier);
    service.init(isar, supabase);
  });

  tearDown(() async {
    container.dispose();
    await isar.close(deleteFromDisk: true);
  });

  test('ينهي المزامنة مبكراً دون مستخدم مصادق أو طلبات شبكة', () async {
    await service.syncAll();

    expect(httpClient.requests, isEmpty);
  });

  test('يدفع التغيير المحلي ويستقبل السجلات البعيدة في أول مزامنة', () async {
    final now = DateTime.utc(2026, 8, 15, 10);
    final pushedCustomer = _customer(
      id: 'customer-push',
      updatedAt: now,
      syncStatus: SyncStatus.pendingPush,
    );
    final localCustomer = _customer(
      id: 'customer-server-wins',
      updatedAt: now.subtract(const Duration(days: 2)),
      syncStatus: SyncStatus.synced,
    );
    httpClient.customerRemoteRecords = [
      _customerJson(
        id: localCustomer.customerId,
        updatedAt: now.add(const Duration(days: 1)),
        nameAr: 'العميل المحدّث من الخادم',
      ),
      _customerJson(
        id: 'customer-remote',
        updatedAt: now.add(const Duration(days: 2)),
        nameAr: 'عميل وصل من الخادم',
      ),
    ];
    await isar.writeTxn(() async {
      await isar.customerModels.putAll([pushedCustomer, localCustomer]);
    });
    await _authenticate(supabase);

    await service.syncAll();

    final pushed = await isar.customerModels
        .filter()
        .customerIdEqualTo('customer-push')
        .findFirst();
    final replaced = await isar.customerModels
        .filter()
        .customerIdEqualTo('customer-server-wins')
        .findFirst();
    final imported = await isar.customerModels
        .filter()
        .customerIdEqualTo('customer-remote')
        .findFirst();

    expect(pushed?.syncStatus, SyncStatus.synced);
    expect(pushed?.serverUpdatedAt?.hour, 12);
    expect(replaced?.nameAr, 'العميل المحدّث من الخادم');
    expect(imported?.nameAr, 'عميل وصل من الخادم');
    expect(httpClient.wasRequested('POST', 'customers'), isTrue);
    expect(httpClient.getRequestCount, 9);
  });

  test('يقبل نسخة الخادم الأحدث بعد فشل دفع تغيير محلي متعارض', () async {
    final now = DateTime.utc(2026, 8, 15, 10);
    final pendingCustomer = _customer(
      id: 'customer-conflict',
      updatedAt: now,
      syncStatus: SyncStatus.pendingPush,
    );
    httpClient.rejectCustomerUpsert = true;
    httpClient.customerRemoteRecords = [
      _customerJson(
        id: pendingCustomer.customerId,
        updatedAt: now.add(const Duration(hours: 1)),
        nameAr: 'نسخة الخادم الأحدث',
      ),
    ];
    await isar.writeTxn(() => isar.customerModels.put(pendingCustomer));
    await _authenticate(supabase);

    await service.syncAll();

    final resolved = await isar.customerModels
        .filter()
        .customerIdEqualTo('customer-conflict')
        .findFirst();

    expect(resolved?.nameAr, 'نسخة الخادم الأحدث');
    expect(resolved?.syncStatus, SyncStatus.synced);
    expect(httpClient.wasRequested('POST', 'customers'), isTrue);
  });
}

CustomerModel _customer({
  required String id,
  required DateTime updatedAt,
  required SyncStatus syncStatus,
}) =>
    CustomerModel()
      ..customerId = id
      ..nameAr = 'عميل $id'
      ..nameEn = 'Customer $id'
      ..createdAt = updatedAt.subtract(const Duration(days: 1))
      ..updatedAt = updatedAt
      ..syncStatus = syncStatus
      ..isDeleted = false;

Map<String, dynamic> _customerJson({
  required String id,
  required DateTime updatedAt,
  required String nameAr,
}) =>
    {
      'id': id,
      'nameAr': nameAr,
      'nameEn': 'Customer $id',
      'createdAt':
          updatedAt.subtract(const Duration(days: 1)).toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'syncStatus': 'synced',
      'isDeleted': false,
    };

Future<void> _authenticate(SupabaseClient supabase) => supabase.auth.setSession(
      'refresh-token',
      accessToken: redacted(),
    );

String _accessToken() {
  final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  final header = _base64UrlJson({'alg': 'none', 'typ': 'JWT'});
  final payload = _base64UrlJson({
    'sub': 'sync-user',
    'iat': now,
    'exp': now + 3600,
  });
  return '$header.$payload.c2ln';
}

String _base64UrlJson(Map<String, dynamic> value) =>
    base64Url.encode(utf8.encode(jsonEncode(value))).replaceAll('=', '');

class _SyncHttpClient extends http.BaseClient {
  final List<http.BaseRequest> requests = [];
  List<Map<String, dynamic>> customerRemoteRecords = [];
  bool rejectCustomerUpsert = false;

  int get getRequestCount => requests
      .where((request) => request.method == 'GET' && _isRest(request))
      .length;

  bool wasRequested(String method, String table) => requests.any(
        (request) =>
            request.method == method &&
            request.url.path.endsWith('/rest/v1/$table'),
      );

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    requests.add(request);
    final path = request.url.path;
    if (path.endsWith('/auth/v1/user')) {
      return _jsonResponse(_userJson(), request: request);
    }
    if (_isRest(request)) {
      final table = request.url.pathSegments.last;
      if (request.method == 'POST' && table == 'customers') {
        if (rejectCustomerUpsert) {
          return _jsonResponse(
            {'message': 'رفض اختباري'},
            request: request,
            statusCode: 500,
          );
        }
        return _jsonResponse(
          {
            'server_updated_at':
                DateTime.utc(2026, 8, 15, 12).toIso8601String(),
          },
          request: request,
        );
      }
      if (request.method == 'GET') {
        return _jsonResponse(
          table == 'customers' ? customerRemoteRecords : [],
          request: request,
        );
      }
    }
    return _jsonResponse(
      {'message': 'مسار غير متوقع: $path'},
      request: request,
      statusCode: 404,
    );
  }

  bool _isRest(http.BaseRequest request) =>
      request.url.path.contains('/rest/v1/');

  http.StreamedResponse _jsonResponse(
    Object body, {
    required http.BaseRequest request,
    int statusCode = 200,
  }) =>
      http.StreamedResponse(
        Stream.value(utf8.encode(jsonEncode(body))),
        statusCode,
        headers: const {'content-type': 'application/json'},
        request: request,
      );

  Map<String, dynamic> _userJson() => {
        'id': 'sync-user',
        'aud': 'authenticated',
        'role': 'authenticated',
        'email': 'sync@example.com',
        'email_confirmed_at': DateTime.utc(2026, 8).toIso8601String(),
        'created_at': DateTime.utc(2026, 8).toIso8601String(),
        'updated_at': DateTime.utc(2026, 8).toIso8601String(),
        'app_metadata': <String, dynamic>{},
        'user_metadata': <String, dynamic>{},
      };
}
