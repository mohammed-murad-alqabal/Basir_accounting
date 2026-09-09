import 'package:drift/drift.dart';

/// Database tables for the canonical accounting storage model.
///
/// Financial facts use minor-unit integers rather than floating-point values.
/// Every financial table is tenant-scoped to make isolation explicit in both
/// queries and uniqueness constraints.
class Tenants extends Table {
  TextColumn get id => text()();
  TextColumn get legalName => text()();
  TextColumn get baseCurrency => text().withLength(min: 3, max: 3)();
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
        'CHECK (length(trim(id)) > 0)',
        'CHECK (length(base_currency) = 3)',
      ];
}

class FiscalPeriods extends Table {
  TextColumn get id => text()();
  TextColumn get tenantId => text().references(Tenants, #id)();
  TextColumn get code => text()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  TextColumn get status => text()();
  DateTimeColumn get closedAt => dateTime().nullable()();
  TextColumn get closedBy => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {tenantId, code},
        {tenantId, startDate, endDate},
      ];

  @override
  List<String> get customConstraints => [
        'CHECK (end_date >= start_date)',
        "CHECK (status IN ('OPEN', 'LOCKED', 'CLOSED'))",
        "CHECK ((status = 'OPEN' AND closed_at IS NULL) OR status <> 'OPEN')",
      ];
}

class Accounts extends Table {
  TextColumn get id => text()();
  TextColumn get tenantId => text().references(Tenants, #id)();
  TextColumn get code => text()();
  TextColumn get nameAr => text()();
  TextColumn get nameEn => text()();
  TextColumn get type => text()();
  TextColumn get nature => text()();
  TextColumn get parentId => text().nullable().references(Accounts, #id)();
  BoolColumn get isPostingAllowed =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {tenantId, code},
      ];

  @override
  List<String> get customConstraints => [
        "CHECK (type IN ('ASSET', 'LIABILITY', 'EQUITY', 'REVENUE', 'EXPENSE'))",
        "CHECK (nature IN ('DEBIT', 'CREDIT'))",
        'CHECK (parent_id IS NULL OR parent_id <> id)',
      ];
}

class SourceDocuments extends Table {
  TextColumn get id => text()();
  TextColumn get tenantId => text().references(Tenants, #id)();
  TextColumn get sourceType => text()();
  TextColumn get sourceId => text()();
  TextColumn get externalReference => text().nullable()();
  TextColumn get payloadHash => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {tenantId, sourceType, sourceId},
      ];
}

class JournalEntries extends Table {
  TextColumn get id => text()();
  TextColumn get tenantId => text().references(Tenants, #id)();
  TextColumn get fiscalPeriodId => text().references(FiscalPeriods, #id)();
  TextColumn get referenceNumber => text()();
  TextColumn get sourceDocumentId =>
      text().nullable().references(SourceDocuments, #id)();
  TextColumn get sourceType => text()();
  TextColumn get sourceId => text().nullable()();
  TextColumn get status => text()();
  DateTimeColumn get transactionDate => dateTime()();
  DateTimeColumn get effectiveDate => dateTime()();
  DateTimeColumn get recordingDate => dateTime()();
  DateTimeColumn get postedAt => dateTime().nullable()();
  TextColumn get createdBy => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get reversalOfEntryId =>
      text().nullable().references(JournalEntries, #id)();
  TextColumn get rowVersion => text()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {tenantId, referenceNumber},
        {tenantId, sourceType, sourceId},
      ];

  @override
  List<String> get customConstraints => [
        "CHECK (status IN ('DRAFT', 'POSTED', 'REVERSED', 'VOIDED'))",
        "CHECK (source_id IS NOT NULL OR source_type = 'MANUAL')",
        "CHECK ((status = 'POSTED' AND posted_at IS NOT NULL) OR status <> 'POSTED')",
      ];
}

class JournalLines extends Table {
  TextColumn get id => text()();
  TextColumn get entryId => text().references(JournalEntries, #id)();
  IntColumn get lineNumber => integer()();
  TextColumn get accountId => text().references(Accounts, #id)();
  IntColumn get debitMinor => integer().withDefault(const Constant(0))();
  IntColumn get creditMinor => integer().withDefault(const Constant(0))();
  TextColumn get currencyCode => text().withLength(min: 3, max: 3)();
  IntColumn get originalAmountMinor => integer().nullable()();
  IntColumn get exchangeRatePpm => integer().nullable()();
  TextColumn get description => text().nullable()();
  TextColumn get analyticDimensionJson => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {entryId, lineNumber},
      ];

  @override
  List<String> get customConstraints => [
        'CHECK (debit_minor >= 0)',
        'CHECK (credit_minor >= 0)',
        'CHECK (NOT (debit_minor > 0 AND credit_minor > 0))',
        'CHECK (debit_minor > 0 OR credit_minor > 0)',
        'CHECK (original_amount_minor IS NULL OR original_amount_minor >= 0)',
        'CHECK (exchange_rate_ppm IS NULL OR exchange_rate_ppm > 0)',
      ];
}

class IdempotencyKeys extends Table {
  TextColumn get id => text()();
  TextColumn get tenantId => text().references(Tenants, #id)();
  TextColumn get key => text()();
  TextColumn get commandType => text()();
  TextColumn get commandHash => text()();
  TextColumn get state => text()();
  TextColumn get receiptId => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {tenantId, key},
      ];

  @override
  List<String> get customConstraints => [
        "CHECK (state IN ('ACCEPTED', 'APPLIED', 'FAILED'))",
      ];
}

class PostingReceipts extends Table {
  TextColumn get id => text()();
  TextColumn get tenantId => text().references(Tenants, #id)();
  TextColumn get entryId => text().references(JournalEntries, #id)();
  TextColumn get idempotencyKeyId => text().references(IdempotencyKeys, #id)();
  TextColumn get writerEpoch => text()();
  TextColumn get commandHash => text()();
  DateTimeColumn get acceptedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {tenantId, entryId},
        {tenantId, idempotencyKeyId},
      ];
}

class OutboxEvents extends Table {
  TextColumn get id => text()();
  TextColumn get tenantId => text().references(Tenants, #id)();
  IntColumn get sequence => integer()();
  TextColumn get aggregateType => text()();
  TextColumn get aggregateId => text()();
  TextColumn get eventType => text()();
  TextColumn get payloadJson => text()();
  TextColumn get payloadHash => text()();
  TextColumn get state => text()();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get processedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {tenantId, sequence},
      ];

  @override
  List<String> get customConstraints => [
        'CHECK (sequence > 0)',
        'CHECK (attempts >= 0)',
        "CHECK (state IN ('PENDING', 'SENT', 'FAILED'))",
      ];
}

class AuditEvents extends Table {
  TextColumn get id => text()();
  TextColumn get tenantId => text().references(Tenants, #id)();
  TextColumn get actorId => text()();
  TextColumn get action => text()();
  TextColumn get aggregateType => text().nullable()();
  TextColumn get aggregateId => text().nullable()();
  TextColumn get payloadHash => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class StockMovements extends Table {
  TextColumn get id => text()();
  TextColumn get tenantId => text().references(Tenants, #id)();
  TextColumn get warehouseId => text()();
  TextColumn get itemId => text()();
  IntColumn get sequence => integer()();
  IntColumn get quantityMinor => integer()();
  IntColumn get unitCostMinor => integer().nullable()();
  TextColumn get movementType => text()();
  TextColumn get previousHash => text().nullable()();
  TextColumn get hash => text()();
  DateTimeColumn get occurredAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {tenantId, warehouseId, itemId, sequence},
      ];

  @override
  List<String> get customConstraints => [
        'CHECK (sequence > 0)',
        'CHECK (quantity_minor <> 0)',
      ];
}
