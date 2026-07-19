import 'dart:async';

import 'package:basir_accounting_system/core/models/sync_status.dart';
import 'package:basir_accounting_system/features/accounting/data/models/account_model.dart';
import 'package:basir_accounting_system/features/accounting/data/models/financial_voucher_model.dart';
import 'package:basir_accounting_system/features/accounting/data/models/financial_year_model.dart';
import 'package:basir_accounting_system/features/accounting/data/models/journal_entry_model.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/account.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/financial_voucher.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/financial_year.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/journal_entry.dart';
import 'package:basir_accounting_system/features/customers/data/models/customer_model.dart';
import 'package:basir_accounting_system/features/customers/domain/entities/customer.dart';
import 'package:basir_accounting_system/features/invoices/data/models/invoice_model.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice.dart';
import 'package:basir_accounting_system/features/settings/data/models/business_settings_model.dart';
import 'package:basir_accounting_system/features/settings/data/models/profile_model.dart';
import 'package:basir_accounting_system/features/settings/domain/entities/business_settings.dart';
import 'package:basir_accounting_system/features/settings/domain/entities/profile.dart';
import 'package:basir_accounting_system/features/vendors/data/models/vendor_model.dart';
import 'package:basir_accounting_system/features/vendors/domain/entities/vendor.dart';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'sync_service.g.dart';

/// Bidirectional data synchronization service.
///
/// Manages offline-first data synchronization between local Isar database
/// and remote Supabase backend. Implements Last-Write-Wins (LWW) conflict
/// resolution strategy.
///
/// ## Features
/// - Offline-first architecture with local persistence
/// - Bidirectional sync (push local changes, pull remote updates)
/// - Last-Write-Wins conflict resolution
/// - Supports 9 entity types across all business domains
///
/// ## Sync Process
/// 1. **Push Phase**: Upload pending local changes to server
/// 2. **Pull Phase**: Download server changes since last sync
/// 3. **Conflict Resolution**: LWW based on `updatedAt` timestamps
///
/// ## Usage
/// ```dart
/// final syncService = ref.read(syncServiceProvider.notifier);
/// syncService.init(isar, supabaseClient);
/// await syncService.syncAll();
/// ```
@riverpod
class SyncService extends _$SyncService {
  late Isar _isar;
  late SupabaseClient _supabase;

  @override
  FutureOr<void> build() {
    // Initialization handled by init() method for dependency injection
  }

  /// Initializes the sync service with database connections.
  ///
  /// Must be called before [syncAll] to provide database instances.
  ///
  /// - [isar]: Local Isar database instance.
  /// - [supabase]: Supabase client for remote operations.
  void init(Isar isar, SupabaseClient supabase) {
    _isar = isar;
    _supabase = supabase;
  }

  /// Executes full synchronization across all entity types.
  ///
  /// Syncs the following entities in order:
  /// 1. Customers
  /// 2. Vendors
  /// 3. Accounts
  /// 4. Financial Years
  /// 5. Invoices
  /// 6. Journal Entries
  /// 7. Financial Vouchers
  /// 8. Profiles
  /// 9. Business Settings
  ///
  /// Requires authenticated user. Returns early if not authenticated.
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
      getById: (col, id) => col.filter().customerIdEqualTo(id).findFirst(),
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
      getById: (col, id) => col.filter().vendorIdEqualTo(id).findFirst(),
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
      getById: (col, id) => col.filter().idEqualTo(id).findFirst(),
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
      getById: (col, id) => col.filter().idEqualTo(id).findFirst(),
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
      getById: (col, id) => col.filter().invoiceIdEqualTo(id).findFirst(),
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
      getById: (col, id) => col.filter().idEqualTo(id).findFirst(),
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
      getById: (col, id) => col.filter().idEqualTo(id).findFirst(),
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
      getById: (col, id) => col.filter().idEqualTo(id).findFirst(),
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
      getById: (col, id) => col.filter().idEqualTo(id).findFirst(),
      setSyncMetadata: (m, status, time) {
        m.syncStatus = status;
        m.serverUpdatedAt = time;
      },
    );
  }

  /// Synchronizes a single table with bidirectional sync.
  ///
  /// Implements the core sync algorithm:
  /// 1. Push: Upload records with [SyncStatus.pendingPush]
  /// 2. Pull: Download records updated after last sync timestamp
  /// 3. Resolve: Apply LWW conflict resolution
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
    required Future<M?> Function(IsarCollection<M>, String) getById,
    required void Function(M, SyncStatus, DateTime) setSyncMetadata,
  }) async {
    // Phase 1: Push local changes to server
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

        final serverUpdatedAt = DateTime.parse(
          response['server_updated_at'] as String,
        );

        await _isar.writeTxn(() async {
          setSyncMetadata(record, SyncStatus.synced, serverUpdatedAt);
          await collection.put(record);
        });
      } on Exception catch (e) {
        debugPrint('Error pushing $tableName: $e');
      }
    }

    // Phase 2: Pull server changes
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
        final remoteData = json as Map<String, dynamic>;
        final remoteEntity = fromJson(remoteData);
        final remoteModel = fromEntity(remoteEntity);
        final id = remoteData['id'] as String;

        // Conflict Resolution: Last Write Wins (LWW)
        final localRecord = await getById(collection, id);

        if (localRecord != null) {
          final localSyncStatus =
              (localRecord as dynamic).syncStatus as SyncStatus;
          final localUpdatedAt = (localRecord as dynamic).updatedAt as DateTime;
          final remoteUpdatedAt = DateTime.parse(
            remoteData['updatedAt'] as String,
          );

          if (localSyncStatus == SyncStatus.pendingPush) {
            // Conflict: Local has unsynced changes, server has updates
            if (remoteUpdatedAt.isAfter(localUpdatedAt)) {
              // Server is newer -> Server Wins
              await _isar.writeTxn(() async {
                await collection.put(remoteModel);
              });
            } else {
              // Local is newer -> Local Wins (pushed in next cycle)
              continue;
            }
          } else {
            // No local conflict -> Accept server version
            await _isar.writeTxn(() async {
              await collection.put(remoteModel);
            });
          }
        } else {
          // New record from server
          await _isar.writeTxn(() async {
            await collection.put(remoteModel);
          });
        }
      }
    } on Exception catch (e) {
      debugPrint('Error pulling $tableName: $e');
    }
  }
}
