import 'dart:async';

import 'package:basir_app/core/models/sync_status.dart';
import 'package:basir_app/features/accounting/data/models/account_model.dart';
import 'package:basir_app/features/accounting/data/models/financial_voucher_model.dart';
import 'package:basir_app/features/accounting/data/models/financial_year_model.dart';
import 'package:basir_app/features/accounting/data/models/journal_entry_model.dart';
import 'package:basir_app/features/accounting/domain/entities/account.dart';
import 'package:basir_app/features/accounting/domain/entities/financial_voucher.dart';
import 'package:basir_app/features/accounting/domain/entities/financial_year.dart';
import 'package:basir_app/features/accounting/domain/entities/journal_entry.dart';
import 'package:basir_app/features/customers/data/models/customer_model.dart';
import 'package:basir_app/features/customers/domain/entities/customer.dart';
import 'package:basir_app/features/invoices/data/models/invoice_model.dart';
import 'package:basir_app/features/invoices/domain/entities/invoice.dart';
import 'package:basir_app/features/settings/data/models/business_settings_model.dart';
import 'package:basir_app/features/settings/data/models/profile_model.dart';
import 'package:basir_app/features/settings/domain/entities/business_settings.dart';
import 'package:basir_app/features/settings/domain/entities/profile.dart';
import 'package:basir_app/features/vendors/data/models/vendor_model.dart';
import 'package:basir_app/features/vendors/domain/entities/vendor.dart';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'sync_service.g.dart';

@riverpod
class SyncService extends _$SyncService {
  late Isar _isar;
  late SupabaseClient _supabase;

  @override
  FutureOr<void> build() {
    // Initialization will be handled by a separate method or dependency injection
  }

  /// التهيئة الأولية للخدمة
  void init(Isar isar, SupabaseClient supabase) {
    _isar = isar;
    _supabase = supabase;
  }

  /// بدء عملية المزامنة الشاملة
  Future<void> syncAll() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    // 1. Customers
    await _syncTable<CustomerModel, Customer>(
      tableName: 'customers',
      collection: _isar.customerModels,
      getPendingPush: (col) =>
          col.filter().syncStatusEqualTo(SyncStatus.pendingPush).findAll(),
      getLastSynced: (col) =>
          col.where().sortByServerUpdatedAtDesc().findFirst(),
      toEntity: (m) => m.toEntity(),
      toJson: (e) => e.toJson(),
      fromJson: Customer.fromJson,
      fromEntity: CustomerModel.fromEntity,
      getServerUpdatedAt: (m) => m.serverUpdatedAt,
      setSyncMetadata: (m, status, time) {
        m.syncStatus = status;
        m.serverUpdatedAt = time;
      },
    );

    // 2. Vendors
    await _syncTable<VendorModel, Vendor>(
      tableName: 'vendors',
      collection: _isar.vendorModels,
      getPendingPush: (col) =>
          col.filter().syncStatusEqualTo(SyncStatus.pendingPush).findAll(),
      getLastSynced: (col) =>
          col.where().sortByServerUpdatedAtDesc().findFirst(),
      toEntity: (m) => m.toEntity(),
      toJson: (e) => e.toJson(),
      fromJson: Vendor.fromJson,
      fromEntity: VendorModel.fromEntity,
      getServerUpdatedAt: (m) => m.serverUpdatedAt,
      setSyncMetadata: (m, status, time) {
        m.syncStatus = status;
        m.serverUpdatedAt = time;
      },
    );

    // 3. Accounts
    await _syncTable<AccountModel, Account>(
      tableName: 'accounts',
      collection: _isar.accountModels,
      getPendingPush: (col) =>
          col.filter().syncStatusEqualTo(SyncStatus.pendingPush).findAll(),
      getLastSynced: (col) =>
          col.where().sortByServerUpdatedAtDesc().findFirst(),
      toEntity: (m) => m.toEntity(),
      toJson: (e) => e.toJson(),
      fromJson: Account.fromJson,
      fromEntity: AccountModel.fromEntity,
      getServerUpdatedAt: (m) => m.serverUpdatedAt,
      setSyncMetadata: (m, status, time) {
        m.syncStatus = status;
        m.serverUpdatedAt = time;
      },
    );

    // 4. Financial Years
    await _syncTable<FinancialYearModel, FinancialYear>(
      tableName: 'financial_years',
      collection: _isar.financialYearModels,
      getPendingPush: (col) =>
          col.filter().syncStatusEqualTo(SyncStatus.pendingPush).findAll(),
      getLastSynced: (col) =>
          col.where().sortByServerUpdatedAtDesc().findFirst(),
      toEntity: (m) => m.toEntity(),
      toJson: (e) => e.toJson(),
      fromJson: FinancialYear.fromJson,
      fromEntity: FinancialYearModel.fromEntity,
      getServerUpdatedAt: (m) => m.serverUpdatedAt,
      setSyncMetadata: (m, status, time) {
        m.syncStatus = status;
        m.serverUpdatedAt = time;
      },
    );

    // 5. Invoices
    await _syncTable<InvoiceModel, Invoice>(
      tableName: 'invoices',
      collection: _isar.invoiceModels,
      getPendingPush: (col) =>
          col.filter().syncStatusEqualTo(SyncStatus.pendingPush).findAll(),
      getLastSynced: (col) =>
          col.where().sortByServerUpdatedAtDesc().findFirst(),
      toEntity: (m) => m.toEntity(),
      toJson: (e) => e.toJson(),
      fromJson: Invoice.fromJson,
      fromEntity: InvoiceModel.fromEntity,
      getServerUpdatedAt: (m) => m.serverUpdatedAt,
      setSyncMetadata: (m, status, time) {
        m.syncStatus = status;
        m.serverUpdatedAt = time;
      },
    );

    // 6. Journal Entries
    await _syncTable<JournalEntryModel, JournalEntry>(
      tableName: 'journal_entries',
      collection: _isar.journalEntryModels,
      getPendingPush: (col) =>
          col.filter().syncStatusEqualTo(SyncStatus.pendingPush).findAll(),
      getLastSynced: (col) =>
          col.where().sortByServerUpdatedAtDesc().findFirst(),
      toEntity: (m) => m.toEntity(),
      toJson: (e) => e.toJson(),
      fromJson: JournalEntry.fromJson,
      fromEntity: JournalEntryModel.fromEntity,
      getServerUpdatedAt: (m) => m.serverUpdatedAt,
      setSyncMetadata: (m, status, time) {
        m.syncStatus = status;
        m.serverUpdatedAt = time;
      },
    );

    // 7. Financial Vouchers
    await _syncTable<FinancialVoucherModel, FinancialVoucher>(
      tableName: 'financial_vouchers',
      collection: _isar.financialVoucherModels,
      getPendingPush: (col) =>
          col.filter().syncStatusEqualTo(SyncStatus.pendingPush).findAll(),
      getLastSynced: (col) =>
          col.where().sortByServerUpdatedAtDesc().findFirst(),
      toEntity: (m) => m.toEntity(),
      fromJson: FinancialVoucher.fromJson,
      toJson: (e) => e.toJson(),
      fromEntity: FinancialVoucherModel.fromEntity,
      getServerUpdatedAt: (m) => m.serverUpdatedAt,
      setSyncMetadata: (m, status, time) {
        m.syncStatus = status;
        m.serverUpdatedAt = time;
      },
    );

    // 8. Profiles
    await _syncTable<ProfileModel, Profile>(
      tableName: 'profiles',
      collection: _isar.profileModels,
      getPendingPush: (col) =>
          col.filter().syncStatusEqualTo(SyncStatus.pendingPush).findAll(),
      getLastSynced: (col) =>
          col.where().sortByServerUpdatedAtDesc().findFirst(),
      toEntity: (m) => m.toEntity(),
      toJson: (e) => e.toJson(),
      fromJson: Profile.fromJson,
      fromEntity: ProfileModel.fromEntity,
      getServerUpdatedAt: (m) => m.serverUpdatedAt,
      setSyncMetadata: (m, status, time) {
        m.syncStatus = status;
        m.serverUpdatedAt = time;
      },
    );

    // 9. Business Settings
    await _syncTable<BusinessSettingsModel, BusinessSettings>(
      tableName: 'business_settings',
      collection: _isar.businessSettingsModels,
      getPendingPush: (col) =>
          col.filter().syncStatusEqualTo(SyncStatus.pendingPush).findAll(),
      getLastSynced: (col) =>
          col.where().sortByServerUpdatedAtDesc().findFirst(),
      toEntity: (m) => m.toEntity(),
      toJson: (e) => e.toJson(),
      fromJson: BusinessSettings.fromJson,
      fromEntity: BusinessSettingsModel.fromEntity,
      getServerUpdatedAt: (m) => m.serverUpdatedAt,
      setSyncMetadata: (m, status, time) {
        m.syncStatus = status;
        m.serverUpdatedAt = time;
      },
    );
  }

  /// مزامنة جدول محدد
  Future<void> _syncTable<M, E>({
    required String tableName,
    required IsarCollection<M> collection,
    required Future<List<M>> Function(IsarCollection<M>) getPendingPush,
    required Future<M?> Function(IsarCollection<M>) getLastSynced,
    required E Function(M) toEntity,
    required Map<String, dynamic> Function(E) toJson,
    required E Function(Map<String, dynamic>) fromJson,
    required M Function(E) fromEntity,
    required DateTime? Function(M) getServerUpdatedAt,
    required void Function(M, SyncStatus, DateTime) setSyncMetadata,
  }) async {
    // 1. دفع التعديلات المحلية (Push)
    final pendingRecords = await getPendingPush(collection);
    for (final record in pendingRecords) {
      try {
        final entity = toEntity(record);
        final json = toJson(entity);

        final response = await _supabase
            .from(tableName)
            .upsert(json)
            .select('server_updated_at')
            .single();

        final serverUpdatedAt =
            DateTime.parse(response['server_updated_at'] as String);

        await _isar.writeTxn(() async {
          setSyncMetadata(record, SyncStatus.synced, serverUpdatedAt);
          await collection.put(record);
        });
      } catch (e) {
        // In production, use a proper logger
        debugPrint('Error pushing $tableName: $e');
      }
    }

    // 2. سحب التعديلات من السيرفر (Pull)
    final lastSync = await getLastSynced(collection);
    final lastSyncDate = getServerUpdatedAt(lastSync as M)?.toIso8601String() ??
        DateTime(1970).toIso8601String();

    try {
      final response = await _supabase
          .from(tableName)
          .select()
          .gt('server_updated_at', lastSyncDate)
          .order('server_updated_at', ascending: true);

      final remoteRecords = response as List<dynamic>;
      for (final json in remoteRecords) {
        final entity = fromJson(json as Map<String, dynamic>);
        final model = fromEntity(entity);

        // TODO: تنفيذ منطق فض النزاعات (Conflict Resolution)
        // حالياً: السيرفر يفوز دائماً (Server Wins)
        await _isar.writeTxn(() async {
          await collection.put(model);
        });
      }
    } on Exception catch (e) {
      debugPrint('Error pulling $tableName: $e');
    }
  }
}
