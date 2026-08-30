import 'package:basir_accounting_system/core/database/drift/tables.dart';
import 'package:drift/drift.dart';

part 'app_database.g.dart';

/// Canonical relational database for the staged Isar -> Drift migration.
///
/// The executor is injected so each platform can provide its own SQLite
/// implementation. Isar remains a separate legacy adapter during migration.
@DriftDatabase(
  tables: [
    Tenants,
    FiscalPeriods,
    Accounts,
    SourceDocuments,
    JournalEntries,
    JournalLines,
    IdempotencyKeys,
    PostingReceipts,
    OutboxEvents,
    AuditEvents,
    StockMovements,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await _createIndexes();
          await _createImmutabilityTriggers();
        },
        onUpgrade: (m, from, to) async {
          // Keep upgrades explicit and append-only. Each future version must
          // be accompanied by a migration test from every supported baseline.
          if (from < 1) {
            await m.createAll();
          }
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
          await customStatement('PRAGMA busy_timeout = 5000');
        },
      );

  Future<void> _createIndexes() async {
    const statements = [
      '''
      CREATE INDEX IF NOT EXISTS idx_accounts_tenant_parent
      ON accounts (tenant_id, parent_id)
      ''',
      '''
      CREATE INDEX IF NOT EXISTS idx_accounts_tenant_active_code
      ON accounts (tenant_id, is_active, code)
      ''',
      '''
      CREATE INDEX IF NOT EXISTS idx_periods_tenant_dates
      ON fiscal_periods (tenant_id, start_date, end_date, status)
      ''',
      '''
      CREATE INDEX IF NOT EXISTS idx_entries_tenant_period_status_date
      ON journal_entries (tenant_id, fiscal_period_id, status, transaction_date)
      ''',
      '''
      CREATE INDEX IF NOT EXISTS idx_entries_tenant_status_date
      ON journal_entries (tenant_id, status, transaction_date)
      ''',
      '''
      CREATE INDEX IF NOT EXISTS idx_entries_tenant_source
      ON journal_entries (tenant_id, source_type, source_id)
      ''',
      '''
      CREATE INDEX IF NOT EXISTS idx_lines_entry_number
      ON journal_lines (entry_id, line_number)
      ''',
      '''
      CREATE INDEX IF NOT EXISTS idx_lines_account_entry
      ON journal_lines (account_id, entry_id)
      ''',
      '''
      CREATE INDEX IF NOT EXISTS idx_idempotency_tenant_state
      ON idempotency_keys (tenant_id, state, created_at)
      ''',
      '''
      CREATE INDEX IF NOT EXISTS idx_outbox_tenant_state_sequence
      ON outbox_events (tenant_id, state, sequence)
      ''',
      '''
      CREATE INDEX IF NOT EXISTS idx_stock_tenant_warehouse_item_sequence
      ON stock_movements (tenant_id, warehouse_id, item_id, sequence)
      ''',
    ];
    for (final statement in statements) {
      await customStatement(statement);
    }
  }

  Future<void> _createImmutabilityTriggers() async {
    const statements = [
      '''
      CREATE TRIGGER IF NOT EXISTS prevent_posted_entry_update
      BEFORE UPDATE ON journal_entries
      WHEN OLD.status IN ('POSTED', 'REVERSED') AND (
        NEW.tenant_id <> OLD.tenant_id OR
        NEW.reference_number <> OLD.reference_number OR
        NEW.transaction_date <> OLD.transaction_date OR
        NEW.status <> OLD.status OR
        NEW.fiscal_period_id <> OLD.fiscal_period_id
      )
      BEGIN
        SELECT RAISE(ABORT, 'POSTED_ENTRY_IMMUTABLE');
      END
      ''',
      '''
      CREATE TRIGGER IF NOT EXISTS prevent_posted_entry_delete
      BEFORE DELETE ON journal_entries
      WHEN OLD.status IN ('POSTED', 'REVERSED')
      BEGIN
        SELECT RAISE(ABORT, 'POSTED_ENTRY_DELETE_FORBIDDEN');
      END
      ''',
      '''
      CREATE TRIGGER IF NOT EXISTS prevent_posted_line_update
      BEFORE UPDATE ON journal_lines
      WHEN EXISTS (
        SELECT 1 FROM journal_entries e
        WHERE e.id = OLD.entry_id AND e.status IN ('POSTED', 'REVERSED')
      )
      BEGIN
        SELECT RAISE(ABORT, 'POSTED_LINE_IMMUTABLE');
      END
      ''',
      '''
      CREATE TRIGGER IF NOT EXISTS prevent_posted_line_delete
      BEFORE DELETE ON journal_lines
      WHEN EXISTS (
        SELECT 1 FROM journal_entries e
        WHERE e.id = OLD.entry_id AND e.status IN ('POSTED', 'REVERSED')
      )
      BEGIN
        SELECT RAISE(ABORT, 'POSTED_LINE_DELETE_FORBIDDEN');
      END
      ''',
    ];
    for (final statement in statements) {
      await customStatement(statement);
    }
  }
}
