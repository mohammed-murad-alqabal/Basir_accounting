// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $TenantsTable extends Tenants with TableInfo<$TenantsTable, Tenant> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TenantsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _legalNameMeta =
      const VerificationMeta('legalName');
  @override
  late final GeneratedColumn<String> legalName = GeneratedColumn<String>(
      'legal_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _baseCurrencyMeta =
      const VerificationMeta('baseCurrency');
  @override
  late final GeneratedColumn<String> baseCurrency = GeneratedColumn<String>(
      'base_currency', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 3, maxTextLength: 3),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns =>
      [id, legalName, baseCurrency, createdAt, isActive];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tenants';
  @override
  VerificationContext validateIntegrity(Insertable<Tenant> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('legal_name')) {
      context.handle(_legalNameMeta,
          legalName.isAcceptableOrUnknown(data['legal_name']!, _legalNameMeta));
    } else if (isInserting) {
      context.missing(_legalNameMeta);
    }
    if (data.containsKey('base_currency')) {
      context.handle(
          _baseCurrencyMeta,
          baseCurrency.isAcceptableOrUnknown(
              data['base_currency']!, _baseCurrencyMeta));
    } else if (isInserting) {
      context.missing(_baseCurrencyMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Tenant map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Tenant(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      legalName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}legal_name'])!,
      baseCurrency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}base_currency'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
    );
  }

  @override
  $TenantsTable createAlias(String alias) {
    return $TenantsTable(attachedDatabase, alias);
  }
}

class Tenant extends DataClass implements Insertable<Tenant> {
  final String id;
  final String legalName;
  final String baseCurrency;
  final DateTime createdAt;
  final bool isActive;
  const Tenant(
      {required this.id,
      required this.legalName,
      required this.baseCurrency,
      required this.createdAt,
      required this.isActive});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['legal_name'] = Variable<String>(legalName);
    map['base_currency'] = Variable<String>(baseCurrency);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  TenantsCompanion toCompanion(bool nullToAbsent) {
    return TenantsCompanion(
      id: Value(id),
      legalName: Value(legalName),
      baseCurrency: Value(baseCurrency),
      createdAt: Value(createdAt),
      isActive: Value(isActive),
    );
  }

  factory Tenant.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Tenant(
      id: serializer.fromJson<String>(json['id']),
      legalName: serializer.fromJson<String>(json['legalName']),
      baseCurrency: serializer.fromJson<String>(json['baseCurrency']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'legalName': serializer.toJson<String>(legalName),
      'baseCurrency': serializer.toJson<String>(baseCurrency),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  Tenant copyWith(
          {String? id,
          String? legalName,
          String? baseCurrency,
          DateTime? createdAt,
          bool? isActive}) =>
      Tenant(
        id: id ?? this.id,
        legalName: legalName ?? this.legalName,
        baseCurrency: baseCurrency ?? this.baseCurrency,
        createdAt: createdAt ?? this.createdAt,
        isActive: isActive ?? this.isActive,
      );
  @override
  String toString() {
    return (StringBuffer('Tenant(')
          ..write('id: $id, ')
          ..write('legalName: $legalName, ')
          ..write('baseCurrency: $baseCurrency, ')
          ..write('createdAt: $createdAt, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, legalName, baseCurrency, createdAt, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tenant &&
          other.id == this.id &&
          other.legalName == this.legalName &&
          other.baseCurrency == this.baseCurrency &&
          other.createdAt == this.createdAt &&
          other.isActive == this.isActive);
}

class TenantsCompanion extends UpdateCompanion<Tenant> {
  final Value<String> id;
  final Value<String> legalName;
  final Value<String> baseCurrency;
  final Value<DateTime> createdAt;
  final Value<bool> isActive;
  final Value<int> rowid;
  const TenantsCompanion({
    this.id = const Value.absent(),
    this.legalName = const Value.absent(),
    this.baseCurrency = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TenantsCompanion.insert({
    required String id,
    required String legalName,
    required String baseCurrency,
    required DateTime createdAt,
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        legalName = Value(legalName),
        baseCurrency = Value(baseCurrency),
        createdAt = Value(createdAt);
  static Insertable<Tenant> custom({
    Expression<String>? id,
    Expression<String>? legalName,
    Expression<String>? baseCurrency,
    Expression<DateTime>? createdAt,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (legalName != null) 'legal_name': legalName,
      if (baseCurrency != null) 'base_currency': baseCurrency,
      if (createdAt != null) 'created_at': createdAt,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TenantsCompanion copyWith(
      {Value<String>? id,
      Value<String>? legalName,
      Value<String>? baseCurrency,
      Value<DateTime>? createdAt,
      Value<bool>? isActive,
      Value<int>? rowid}) {
    return TenantsCompanion(
      id: id ?? this.id,
      legalName: legalName ?? this.legalName,
      baseCurrency: baseCurrency ?? this.baseCurrency,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (legalName.present) {
      map['legal_name'] = Variable<String>(legalName.value);
    }
    if (baseCurrency.present) {
      map['base_currency'] = Variable<String>(baseCurrency.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TenantsCompanion(')
          ..write('id: $id, ')
          ..write('legalName: $legalName, ')
          ..write('baseCurrency: $baseCurrency, ')
          ..write('createdAt: $createdAt, ')
          ..write('isActive: $isActive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FiscalPeriodsTable extends FiscalPeriods
    with TableInfo<$FiscalPeriodsTable, FiscalPeriod> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FiscalPeriodsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tenantIdMeta =
      const VerificationMeta('tenantId');
  @override
  late final GeneratedColumn<String> tenantId = GeneratedColumn<String>(
      'tenant_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES tenants (id)'));
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _startDateMeta =
      const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
      'start_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _endDateMeta =
      const VerificationMeta('endDate');
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
      'end_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _closedAtMeta =
      const VerificationMeta('closedAt');
  @override
  late final GeneratedColumn<DateTime> closedAt = GeneratedColumn<DateTime>(
      'closed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _closedByMeta =
      const VerificationMeta('closedBy');
  @override
  late final GeneratedColumn<String> closedBy = GeneratedColumn<String>(
      'closed_by', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, tenantId, code, startDate, endDate, status, closedAt, closedBy];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'fiscal_periods';
  @override
  VerificationContext validateIntegrity(Insertable<FiscalPeriod> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('tenant_id')) {
      context.handle(_tenantIdMeta,
          tenantId.isAcceptableOrUnknown(data['tenant_id']!, _tenantIdMeta));
    } else if (isInserting) {
      context.missing(_tenantIdMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(_endDateMeta,
          endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta));
    } else if (isInserting) {
      context.missing(_endDateMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('closed_at')) {
      context.handle(_closedAtMeta,
          closedAt.isAcceptableOrUnknown(data['closed_at']!, _closedAtMeta));
    }
    if (data.containsKey('closed_by')) {
      context.handle(_closedByMeta,
          closedBy.isAcceptableOrUnknown(data['closed_by']!, _closedByMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {tenantId, code},
        {tenantId, startDate, endDate},
      ];
  @override
  FiscalPeriod map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FiscalPeriod(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      tenantId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tenant_id'])!,
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code'])!,
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_date'])!,
      endDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end_date'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      closedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}closed_at']),
      closedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}closed_by']),
    );
  }

  @override
  $FiscalPeriodsTable createAlias(String alias) {
    return $FiscalPeriodsTable(attachedDatabase, alias);
  }
}

class FiscalPeriod extends DataClass implements Insertable<FiscalPeriod> {
  final String id;
  final String tenantId;
  final String code;
  final DateTime startDate;
  final DateTime endDate;
  final String status;
  final DateTime? closedAt;
  final String? closedBy;
  const FiscalPeriod(
      {required this.id,
      required this.tenantId,
      required this.code,
      required this.startDate,
      required this.endDate,
      required this.status,
      this.closedAt,
      this.closedBy});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['tenant_id'] = Variable<String>(tenantId);
    map['code'] = Variable<String>(code);
    map['start_date'] = Variable<DateTime>(startDate);
    map['end_date'] = Variable<DateTime>(endDate);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || closedAt != null) {
      map['closed_at'] = Variable<DateTime>(closedAt);
    }
    if (!nullToAbsent || closedBy != null) {
      map['closed_by'] = Variable<String>(closedBy);
    }
    return map;
  }

  FiscalPeriodsCompanion toCompanion(bool nullToAbsent) {
    return FiscalPeriodsCompanion(
      id: Value(id),
      tenantId: Value(tenantId),
      code: Value(code),
      startDate: Value(startDate),
      endDate: Value(endDate),
      status: Value(status),
      closedAt: closedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(closedAt),
      closedBy: closedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(closedBy),
    );
  }

  factory FiscalPeriod.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FiscalPeriod(
      id: serializer.fromJson<String>(json['id']),
      tenantId: serializer.fromJson<String>(json['tenantId']),
      code: serializer.fromJson<String>(json['code']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime>(json['endDate']),
      status: serializer.fromJson<String>(json['status']),
      closedAt: serializer.fromJson<DateTime?>(json['closedAt']),
      closedBy: serializer.fromJson<String?>(json['closedBy']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tenantId': serializer.toJson<String>(tenantId),
      'code': serializer.toJson<String>(code),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime>(endDate),
      'status': serializer.toJson<String>(status),
      'closedAt': serializer.toJson<DateTime?>(closedAt),
      'closedBy': serializer.toJson<String?>(closedBy),
    };
  }

  FiscalPeriod copyWith(
          {String? id,
          String? tenantId,
          String? code,
          DateTime? startDate,
          DateTime? endDate,
          String? status,
          Value<DateTime?> closedAt = const Value.absent(),
          Value<String?> closedBy = const Value.absent()}) =>
      FiscalPeriod(
        id: id ?? this.id,
        tenantId: tenantId ?? this.tenantId,
        code: code ?? this.code,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        status: status ?? this.status,
        closedAt: closedAt.present ? closedAt.value : this.closedAt,
        closedBy: closedBy.present ? closedBy.value : this.closedBy,
      );
  @override
  String toString() {
    return (StringBuffer('FiscalPeriod(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('code: $code, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('status: $status, ')
          ..write('closedAt: $closedAt, ')
          ..write('closedBy: $closedBy')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, tenantId, code, startDate, endDate, status, closedAt, closedBy);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FiscalPeriod &&
          other.id == this.id &&
          other.tenantId == this.tenantId &&
          other.code == this.code &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.status == this.status &&
          other.closedAt == this.closedAt &&
          other.closedBy == this.closedBy);
}

class FiscalPeriodsCompanion extends UpdateCompanion<FiscalPeriod> {
  final Value<String> id;
  final Value<String> tenantId;
  final Value<String> code;
  final Value<DateTime> startDate;
  final Value<DateTime> endDate;
  final Value<String> status;
  final Value<DateTime?> closedAt;
  final Value<String?> closedBy;
  final Value<int> rowid;
  const FiscalPeriodsCompanion({
    this.id = const Value.absent(),
    this.tenantId = const Value.absent(),
    this.code = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.status = const Value.absent(),
    this.closedAt = const Value.absent(),
    this.closedBy = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FiscalPeriodsCompanion.insert({
    required String id,
    required String tenantId,
    required String code,
    required DateTime startDate,
    required DateTime endDate,
    required String status,
    this.closedAt = const Value.absent(),
    this.closedBy = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        tenantId = Value(tenantId),
        code = Value(code),
        startDate = Value(startDate),
        endDate = Value(endDate),
        status = Value(status);
  static Insertable<FiscalPeriod> custom({
    Expression<String>? id,
    Expression<String>? tenantId,
    Expression<String>? code,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<String>? status,
    Expression<DateTime>? closedAt,
    Expression<String>? closedBy,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tenantId != null) 'tenant_id': tenantId,
      if (code != null) 'code': code,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (status != null) 'status': status,
      if (closedAt != null) 'closed_at': closedAt,
      if (closedBy != null) 'closed_by': closedBy,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FiscalPeriodsCompanion copyWith(
      {Value<String>? id,
      Value<String>? tenantId,
      Value<String>? code,
      Value<DateTime>? startDate,
      Value<DateTime>? endDate,
      Value<String>? status,
      Value<DateTime?>? closedAt,
      Value<String?>? closedBy,
      Value<int>? rowid}) {
    return FiscalPeriodsCompanion(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      code: code ?? this.code,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      closedAt: closedAt ?? this.closedAt,
      closedBy: closedBy ?? this.closedBy,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tenantId.present) {
      map['tenant_id'] = Variable<String>(tenantId.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (closedAt.present) {
      map['closed_at'] = Variable<DateTime>(closedAt.value);
    }
    if (closedBy.present) {
      map['closed_by'] = Variable<String>(closedBy.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FiscalPeriodsCompanion(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('code: $code, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('status: $status, ')
          ..write('closedAt: $closedAt, ')
          ..write('closedBy: $closedBy, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AccountsTable extends Accounts with TableInfo<$AccountsTable, Account> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tenantIdMeta =
      const VerificationMeta('tenantId');
  @override
  late final GeneratedColumn<String> tenantId = GeneratedColumn<String>(
      'tenant_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES tenants (id)'));
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameArMeta = const VerificationMeta('nameAr');
  @override
  late final GeneratedColumn<String> nameAr = GeneratedColumn<String>(
      'name_ar', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
      'name_en', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _natureMeta = const VerificationMeta('nature');
  @override
  late final GeneratedColumn<String> nature = GeneratedColumn<String>(
      'nature', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _parentIdMeta =
      const VerificationMeta('parentId');
  @override
  late final GeneratedColumn<String> parentId = GeneratedColumn<String>(
      'parent_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES accounts (id)'));
  static const VerificationMeta _isPostingAllowedMeta =
      const VerificationMeta('isPostingAllowed');
  @override
  late final GeneratedColumn<bool> isPostingAllowed = GeneratedColumn<bool>(
      'is_posting_allowed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_posting_allowed" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        tenantId,
        code,
        nameAr,
        nameEn,
        type,
        nature,
        parentId,
        isPostingAllowed,
        isActive,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accounts';
  @override
  VerificationContext validateIntegrity(Insertable<Account> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('tenant_id')) {
      context.handle(_tenantIdMeta,
          tenantId.isAcceptableOrUnknown(data['tenant_id']!, _tenantIdMeta));
    } else if (isInserting) {
      context.missing(_tenantIdMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name_ar')) {
      context.handle(_nameArMeta,
          nameAr.isAcceptableOrUnknown(data['name_ar']!, _nameArMeta));
    } else if (isInserting) {
      context.missing(_nameArMeta);
    }
    if (data.containsKey('name_en')) {
      context.handle(_nameEnMeta,
          nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta));
    } else if (isInserting) {
      context.missing(_nameEnMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('nature')) {
      context.handle(_natureMeta,
          nature.isAcceptableOrUnknown(data['nature']!, _natureMeta));
    } else if (isInserting) {
      context.missing(_natureMeta);
    }
    if (data.containsKey('parent_id')) {
      context.handle(_parentIdMeta,
          parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta));
    }
    if (data.containsKey('is_posting_allowed')) {
      context.handle(
          _isPostingAllowedMeta,
          isPostingAllowed.isAcceptableOrUnknown(
              data['is_posting_allowed']!, _isPostingAllowedMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {tenantId, code},
      ];
  @override
  Account map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Account(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      tenantId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tenant_id'])!,
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code'])!,
      nameAr: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_ar'])!,
      nameEn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_en'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      nature: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nature'])!,
      parentId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}parent_id']),
      isPostingAllowed: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}is_posting_allowed'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $AccountsTable createAlias(String alias) {
    return $AccountsTable(attachedDatabase, alias);
  }
}

class Account extends DataClass implements Insertable<Account> {
  final String id;
  final String tenantId;
  final String code;
  final String nameAr;
  final String nameEn;
  final String type;
  final String nature;
  final String? parentId;
  final bool isPostingAllowed;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Account(
      {required this.id,
      required this.tenantId,
      required this.code,
      required this.nameAr,
      required this.nameEn,
      required this.type,
      required this.nature,
      this.parentId,
      required this.isPostingAllowed,
      required this.isActive,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['tenant_id'] = Variable<String>(tenantId);
    map['code'] = Variable<String>(code);
    map['name_ar'] = Variable<String>(nameAr);
    map['name_en'] = Variable<String>(nameEn);
    map['type'] = Variable<String>(type);
    map['nature'] = Variable<String>(nature);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<String>(parentId);
    }
    map['is_posting_allowed'] = Variable<bool>(isPostingAllowed);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AccountsCompanion toCompanion(bool nullToAbsent) {
    return AccountsCompanion(
      id: Value(id),
      tenantId: Value(tenantId),
      code: Value(code),
      nameAr: Value(nameAr),
      nameEn: Value(nameEn),
      type: Value(type),
      nature: Value(nature),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      isPostingAllowed: Value(isPostingAllowed),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Account.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Account(
      id: serializer.fromJson<String>(json['id']),
      tenantId: serializer.fromJson<String>(json['tenantId']),
      code: serializer.fromJson<String>(json['code']),
      nameAr: serializer.fromJson<String>(json['nameAr']),
      nameEn: serializer.fromJson<String>(json['nameEn']),
      type: serializer.fromJson<String>(json['type']),
      nature: serializer.fromJson<String>(json['nature']),
      parentId: serializer.fromJson<String?>(json['parentId']),
      isPostingAllowed: serializer.fromJson<bool>(json['isPostingAllowed']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tenantId': serializer.toJson<String>(tenantId),
      'code': serializer.toJson<String>(code),
      'nameAr': serializer.toJson<String>(nameAr),
      'nameEn': serializer.toJson<String>(nameEn),
      'type': serializer.toJson<String>(type),
      'nature': serializer.toJson<String>(nature),
      'parentId': serializer.toJson<String?>(parentId),
      'isPostingAllowed': serializer.toJson<bool>(isPostingAllowed),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Account copyWith(
          {String? id,
          String? tenantId,
          String? code,
          String? nameAr,
          String? nameEn,
          String? type,
          String? nature,
          Value<String?> parentId = const Value.absent(),
          bool? isPostingAllowed,
          bool? isActive,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Account(
        id: id ?? this.id,
        tenantId: tenantId ?? this.tenantId,
        code: code ?? this.code,
        nameAr: nameAr ?? this.nameAr,
        nameEn: nameEn ?? this.nameEn,
        type: type ?? this.type,
        nature: nature ?? this.nature,
        parentId: parentId.present ? parentId.value : this.parentId,
        isPostingAllowed: isPostingAllowed ?? this.isPostingAllowed,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('Account(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('code: $code, ')
          ..write('nameAr: $nameAr, ')
          ..write('nameEn: $nameEn, ')
          ..write('type: $type, ')
          ..write('nature: $nature, ')
          ..write('parentId: $parentId, ')
          ..write('isPostingAllowed: $isPostingAllowed, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, tenantId, code, nameAr, nameEn, type,
      nature, parentId, isPostingAllowed, isActive, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Account &&
          other.id == this.id &&
          other.tenantId == this.tenantId &&
          other.code == this.code &&
          other.nameAr == this.nameAr &&
          other.nameEn == this.nameEn &&
          other.type == this.type &&
          other.nature == this.nature &&
          other.parentId == this.parentId &&
          other.isPostingAllowed == this.isPostingAllowed &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class AccountsCompanion extends UpdateCompanion<Account> {
  final Value<String> id;
  final Value<String> tenantId;
  final Value<String> code;
  final Value<String> nameAr;
  final Value<String> nameEn;
  final Value<String> type;
  final Value<String> nature;
  final Value<String?> parentId;
  final Value<bool> isPostingAllowed;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const AccountsCompanion({
    this.id = const Value.absent(),
    this.tenantId = const Value.absent(),
    this.code = const Value.absent(),
    this.nameAr = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.type = const Value.absent(),
    this.nature = const Value.absent(),
    this.parentId = const Value.absent(),
    this.isPostingAllowed = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AccountsCompanion.insert({
    required String id,
    required String tenantId,
    required String code,
    required String nameAr,
    required String nameEn,
    required String type,
    required String nature,
    this.parentId = const Value.absent(),
    this.isPostingAllowed = const Value.absent(),
    this.isActive = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        tenantId = Value(tenantId),
        code = Value(code),
        nameAr = Value(nameAr),
        nameEn = Value(nameEn),
        type = Value(type),
        nature = Value(nature),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Account> custom({
    Expression<String>? id,
    Expression<String>? tenantId,
    Expression<String>? code,
    Expression<String>? nameAr,
    Expression<String>? nameEn,
    Expression<String>? type,
    Expression<String>? nature,
    Expression<String>? parentId,
    Expression<bool>? isPostingAllowed,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tenantId != null) 'tenant_id': tenantId,
      if (code != null) 'code': code,
      if (nameAr != null) 'name_ar': nameAr,
      if (nameEn != null) 'name_en': nameEn,
      if (type != null) 'type': type,
      if (nature != null) 'nature': nature,
      if (parentId != null) 'parent_id': parentId,
      if (isPostingAllowed != null) 'is_posting_allowed': isPostingAllowed,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AccountsCompanion copyWith(
      {Value<String>? id,
      Value<String>? tenantId,
      Value<String>? code,
      Value<String>? nameAr,
      Value<String>? nameEn,
      Value<String>? type,
      Value<String>? nature,
      Value<String?>? parentId,
      Value<bool>? isPostingAllowed,
      Value<bool>? isActive,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return AccountsCompanion(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      code: code ?? this.code,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
      type: type ?? this.type,
      nature: nature ?? this.nature,
      parentId: parentId ?? this.parentId,
      isPostingAllowed: isPostingAllowed ?? this.isPostingAllowed,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tenantId.present) {
      map['tenant_id'] = Variable<String>(tenantId.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (nameAr.present) {
      map['name_ar'] = Variable<String>(nameAr.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (nature.present) {
      map['nature'] = Variable<String>(nature.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<String>(parentId.value);
    }
    if (isPostingAllowed.present) {
      map['is_posting_allowed'] = Variable<bool>(isPostingAllowed.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountsCompanion(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('code: $code, ')
          ..write('nameAr: $nameAr, ')
          ..write('nameEn: $nameEn, ')
          ..write('type: $type, ')
          ..write('nature: $nature, ')
          ..write('parentId: $parentId, ')
          ..write('isPostingAllowed: $isPostingAllowed, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SourceDocumentsTable extends SourceDocuments
    with TableInfo<$SourceDocumentsTable, SourceDocument> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SourceDocumentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tenantIdMeta =
      const VerificationMeta('tenantId');
  @override
  late final GeneratedColumn<String> tenantId = GeneratedColumn<String>(
      'tenant_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES tenants (id)'));
  static const VerificationMeta _sourceTypeMeta =
      const VerificationMeta('sourceType');
  @override
  late final GeneratedColumn<String> sourceType = GeneratedColumn<String>(
      'source_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sourceIdMeta =
      const VerificationMeta('sourceId');
  @override
  late final GeneratedColumn<String> sourceId = GeneratedColumn<String>(
      'source_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _externalReferenceMeta =
      const VerificationMeta('externalReference');
  @override
  late final GeneratedColumn<String> externalReference =
      GeneratedColumn<String>('external_reference', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _payloadHashMeta =
      const VerificationMeta('payloadHash');
  @override
  late final GeneratedColumn<String> payloadHash = GeneratedColumn<String>(
      'payload_hash', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        tenantId,
        sourceType,
        sourceId,
        externalReference,
        payloadHash,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'source_documents';
  @override
  VerificationContext validateIntegrity(Insertable<SourceDocument> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('tenant_id')) {
      context.handle(_tenantIdMeta,
          tenantId.isAcceptableOrUnknown(data['tenant_id']!, _tenantIdMeta));
    } else if (isInserting) {
      context.missing(_tenantIdMeta);
    }
    if (data.containsKey('source_type')) {
      context.handle(
          _sourceTypeMeta,
          sourceType.isAcceptableOrUnknown(
              data['source_type']!, _sourceTypeMeta));
    } else if (isInserting) {
      context.missing(_sourceTypeMeta);
    }
    if (data.containsKey('source_id')) {
      context.handle(_sourceIdMeta,
          sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta));
    } else if (isInserting) {
      context.missing(_sourceIdMeta);
    }
    if (data.containsKey('external_reference')) {
      context.handle(
          _externalReferenceMeta,
          externalReference.isAcceptableOrUnknown(
              data['external_reference']!, _externalReferenceMeta));
    }
    if (data.containsKey('payload_hash')) {
      context.handle(
          _payloadHashMeta,
          payloadHash.isAcceptableOrUnknown(
              data['payload_hash']!, _payloadHashMeta));
    } else if (isInserting) {
      context.missing(_payloadHashMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {tenantId, sourceType, sourceId},
      ];
  @override
  SourceDocument map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SourceDocument(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      tenantId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tenant_id'])!,
      sourceType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source_type'])!,
      sourceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source_id'])!,
      externalReference: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}external_reference']),
      payloadHash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payload_hash'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $SourceDocumentsTable createAlias(String alias) {
    return $SourceDocumentsTable(attachedDatabase, alias);
  }
}

class SourceDocument extends DataClass implements Insertable<SourceDocument> {
  final String id;
  final String tenantId;
  final String sourceType;
  final String sourceId;
  final String? externalReference;
  final String payloadHash;
  final DateTime createdAt;
  const SourceDocument(
      {required this.id,
      required this.tenantId,
      required this.sourceType,
      required this.sourceId,
      this.externalReference,
      required this.payloadHash,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['tenant_id'] = Variable<String>(tenantId);
    map['source_type'] = Variable<String>(sourceType);
    map['source_id'] = Variable<String>(sourceId);
    if (!nullToAbsent || externalReference != null) {
      map['external_reference'] = Variable<String>(externalReference);
    }
    map['payload_hash'] = Variable<String>(payloadHash);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SourceDocumentsCompanion toCompanion(bool nullToAbsent) {
    return SourceDocumentsCompanion(
      id: Value(id),
      tenantId: Value(tenantId),
      sourceType: Value(sourceType),
      sourceId: Value(sourceId),
      externalReference: externalReference == null && nullToAbsent
          ? const Value.absent()
          : Value(externalReference),
      payloadHash: Value(payloadHash),
      createdAt: Value(createdAt),
    );
  }

  factory SourceDocument.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SourceDocument(
      id: serializer.fromJson<String>(json['id']),
      tenantId: serializer.fromJson<String>(json['tenantId']),
      sourceType: serializer.fromJson<String>(json['sourceType']),
      sourceId: serializer.fromJson<String>(json['sourceId']),
      externalReference:
          serializer.fromJson<String?>(json['externalReference']),
      payloadHash: serializer.fromJson<String>(json['payloadHash']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tenantId': serializer.toJson<String>(tenantId),
      'sourceType': serializer.toJson<String>(sourceType),
      'sourceId': serializer.toJson<String>(sourceId),
      'externalReference': serializer.toJson<String?>(externalReference),
      'payloadHash': serializer.toJson<String>(payloadHash),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SourceDocument copyWith(
          {String? id,
          String? tenantId,
          String? sourceType,
          String? sourceId,
          Value<String?> externalReference = const Value.absent(),
          String? payloadHash,
          DateTime? createdAt}) =>
      SourceDocument(
        id: id ?? this.id,
        tenantId: tenantId ?? this.tenantId,
        sourceType: sourceType ?? this.sourceType,
        sourceId: sourceId ?? this.sourceId,
        externalReference: externalReference.present
            ? externalReference.value
            : this.externalReference,
        payloadHash: payloadHash ?? this.payloadHash,
        createdAt: createdAt ?? this.createdAt,
      );
  @override
  String toString() {
    return (StringBuffer('SourceDocument(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('sourceType: $sourceType, ')
          ..write('sourceId: $sourceId, ')
          ..write('externalReference: $externalReference, ')
          ..write('payloadHash: $payloadHash, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, tenantId, sourceType, sourceId,
      externalReference, payloadHash, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SourceDocument &&
          other.id == this.id &&
          other.tenantId == this.tenantId &&
          other.sourceType == this.sourceType &&
          other.sourceId == this.sourceId &&
          other.externalReference == this.externalReference &&
          other.payloadHash == this.payloadHash &&
          other.createdAt == this.createdAt);
}

class SourceDocumentsCompanion extends UpdateCompanion<SourceDocument> {
  final Value<String> id;
  final Value<String> tenantId;
  final Value<String> sourceType;
  final Value<String> sourceId;
  final Value<String?> externalReference;
  final Value<String> payloadHash;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const SourceDocumentsCompanion({
    this.id = const Value.absent(),
    this.tenantId = const Value.absent(),
    this.sourceType = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.externalReference = const Value.absent(),
    this.payloadHash = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SourceDocumentsCompanion.insert({
    required String id,
    required String tenantId,
    required String sourceType,
    required String sourceId,
    this.externalReference = const Value.absent(),
    required String payloadHash,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        tenantId = Value(tenantId),
        sourceType = Value(sourceType),
        sourceId = Value(sourceId),
        payloadHash = Value(payloadHash),
        createdAt = Value(createdAt);
  static Insertable<SourceDocument> custom({
    Expression<String>? id,
    Expression<String>? tenantId,
    Expression<String>? sourceType,
    Expression<String>? sourceId,
    Expression<String>? externalReference,
    Expression<String>? payloadHash,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tenantId != null) 'tenant_id': tenantId,
      if (sourceType != null) 'source_type': sourceType,
      if (sourceId != null) 'source_id': sourceId,
      if (externalReference != null) 'external_reference': externalReference,
      if (payloadHash != null) 'payload_hash': payloadHash,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SourceDocumentsCompanion copyWith(
      {Value<String>? id,
      Value<String>? tenantId,
      Value<String>? sourceType,
      Value<String>? sourceId,
      Value<String?>? externalReference,
      Value<String>? payloadHash,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return SourceDocumentsCompanion(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      sourceType: sourceType ?? this.sourceType,
      sourceId: sourceId ?? this.sourceId,
      externalReference: externalReference ?? this.externalReference,
      payloadHash: payloadHash ?? this.payloadHash,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tenantId.present) {
      map['tenant_id'] = Variable<String>(tenantId.value);
    }
    if (sourceType.present) {
      map['source_type'] = Variable<String>(sourceType.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<String>(sourceId.value);
    }
    if (externalReference.present) {
      map['external_reference'] = Variable<String>(externalReference.value);
    }
    if (payloadHash.present) {
      map['payload_hash'] = Variable<String>(payloadHash.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SourceDocumentsCompanion(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('sourceType: $sourceType, ')
          ..write('sourceId: $sourceId, ')
          ..write('externalReference: $externalReference, ')
          ..write('payloadHash: $payloadHash, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $JournalEntriesTable extends JournalEntries
    with TableInfo<$JournalEntriesTable, JournalEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JournalEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tenantIdMeta =
      const VerificationMeta('tenantId');
  @override
  late final GeneratedColumn<String> tenantId = GeneratedColumn<String>(
      'tenant_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES tenants (id)'));
  static const VerificationMeta _fiscalPeriodIdMeta =
      const VerificationMeta('fiscalPeriodId');
  @override
  late final GeneratedColumn<String> fiscalPeriodId = GeneratedColumn<String>(
      'fiscal_period_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES fiscal_periods (id)'));
  static const VerificationMeta _referenceNumberMeta =
      const VerificationMeta('referenceNumber');
  @override
  late final GeneratedColumn<String> referenceNumber = GeneratedColumn<String>(
      'reference_number', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sourceDocumentIdMeta =
      const VerificationMeta('sourceDocumentId');
  @override
  late final GeneratedColumn<String> sourceDocumentId = GeneratedColumn<String>(
      'source_document_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES source_documents (id)'));
  static const VerificationMeta _sourceTypeMeta =
      const VerificationMeta('sourceType');
  @override
  late final GeneratedColumn<String> sourceType = GeneratedColumn<String>(
      'source_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sourceIdMeta =
      const VerificationMeta('sourceId');
  @override
  late final GeneratedColumn<String> sourceId = GeneratedColumn<String>(
      'source_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _transactionDateMeta =
      const VerificationMeta('transactionDate');
  @override
  late final GeneratedColumn<DateTime> transactionDate =
      GeneratedColumn<DateTime>('transaction_date', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _effectiveDateMeta =
      const VerificationMeta('effectiveDate');
  @override
  late final GeneratedColumn<DateTime> effectiveDate =
      GeneratedColumn<DateTime>('effective_date', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _recordingDateMeta =
      const VerificationMeta('recordingDate');
  @override
  late final GeneratedColumn<DateTime> recordingDate =
      GeneratedColumn<DateTime>('recording_date', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _postedAtMeta =
      const VerificationMeta('postedAt');
  @override
  late final GeneratedColumn<DateTime> postedAt = GeneratedColumn<DateTime>(
      'posted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdByMeta =
      const VerificationMeta('createdBy');
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
      'created_by', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _reversalOfEntryIdMeta =
      const VerificationMeta('reversalOfEntryId');
  @override
  late final GeneratedColumn<String> reversalOfEntryId =
      GeneratedColumn<String>('reversal_of_entry_id', aliasedName, true,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintIsAlways(
              'REFERENCES journal_entries (id)'));
  static const VerificationMeta _rowVersionMeta =
      const VerificationMeta('rowVersion');
  @override
  late final GeneratedColumn<String> rowVersion = GeneratedColumn<String>(
      'row_version', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        tenantId,
        fiscalPeriodId,
        referenceNumber,
        sourceDocumentId,
        sourceType,
        sourceId,
        status,
        transactionDate,
        effectiveDate,
        recordingDate,
        postedAt,
        createdBy,
        createdAt,
        updatedAt,
        reversalOfEntryId,
        rowVersion
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'journal_entries';
  @override
  VerificationContext validateIntegrity(Insertable<JournalEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('tenant_id')) {
      context.handle(_tenantIdMeta,
          tenantId.isAcceptableOrUnknown(data['tenant_id']!, _tenantIdMeta));
    } else if (isInserting) {
      context.missing(_tenantIdMeta);
    }
    if (data.containsKey('fiscal_period_id')) {
      context.handle(
          _fiscalPeriodIdMeta,
          fiscalPeriodId.isAcceptableOrUnknown(
              data['fiscal_period_id']!, _fiscalPeriodIdMeta));
    } else if (isInserting) {
      context.missing(_fiscalPeriodIdMeta);
    }
    if (data.containsKey('reference_number')) {
      context.handle(
          _referenceNumberMeta,
          referenceNumber.isAcceptableOrUnknown(
              data['reference_number']!, _referenceNumberMeta));
    } else if (isInserting) {
      context.missing(_referenceNumberMeta);
    }
    if (data.containsKey('source_document_id')) {
      context.handle(
          _sourceDocumentIdMeta,
          sourceDocumentId.isAcceptableOrUnknown(
              data['source_document_id']!, _sourceDocumentIdMeta));
    }
    if (data.containsKey('source_type')) {
      context.handle(
          _sourceTypeMeta,
          sourceType.isAcceptableOrUnknown(
              data['source_type']!, _sourceTypeMeta));
    } else if (isInserting) {
      context.missing(_sourceTypeMeta);
    }
    if (data.containsKey('source_id')) {
      context.handle(_sourceIdMeta,
          sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('transaction_date')) {
      context.handle(
          _transactionDateMeta,
          transactionDate.isAcceptableOrUnknown(
              data['transaction_date']!, _transactionDateMeta));
    } else if (isInserting) {
      context.missing(_transactionDateMeta);
    }
    if (data.containsKey('effective_date')) {
      context.handle(
          _effectiveDateMeta,
          effectiveDate.isAcceptableOrUnknown(
              data['effective_date']!, _effectiveDateMeta));
    } else if (isInserting) {
      context.missing(_effectiveDateMeta);
    }
    if (data.containsKey('recording_date')) {
      context.handle(
          _recordingDateMeta,
          recordingDate.isAcceptableOrUnknown(
              data['recording_date']!, _recordingDateMeta));
    } else if (isInserting) {
      context.missing(_recordingDateMeta);
    }
    if (data.containsKey('posted_at')) {
      context.handle(_postedAtMeta,
          postedAt.isAcceptableOrUnknown(data['posted_at']!, _postedAtMeta));
    }
    if (data.containsKey('created_by')) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('reversal_of_entry_id')) {
      context.handle(
          _reversalOfEntryIdMeta,
          reversalOfEntryId.isAcceptableOrUnknown(
              data['reversal_of_entry_id']!, _reversalOfEntryIdMeta));
    }
    if (data.containsKey('row_version')) {
      context.handle(
          _rowVersionMeta,
          rowVersion.isAcceptableOrUnknown(
              data['row_version']!, _rowVersionMeta));
    } else if (isInserting) {
      context.missing(_rowVersionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {tenantId, referenceNumber},
        {tenantId, sourceType, sourceId},
      ];
  @override
  JournalEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JournalEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      tenantId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tenant_id'])!,
      fiscalPeriodId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}fiscal_period_id'])!,
      referenceNumber: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}reference_number'])!,
      sourceDocumentId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}source_document_id']),
      sourceType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source_type'])!,
      sourceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source_id']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      transactionDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}transaction_date'])!,
      effectiveDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}effective_date'])!,
      recordingDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}recording_date'])!,
      postedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}posted_at']),
      createdBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_by'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      reversalOfEntryId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}reversal_of_entry_id']),
      rowVersion: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}row_version'])!,
    );
  }

  @override
  $JournalEntriesTable createAlias(String alias) {
    return $JournalEntriesTable(attachedDatabase, alias);
  }
}

class JournalEntry extends DataClass implements Insertable<JournalEntry> {
  final String id;
  final String tenantId;
  final String fiscalPeriodId;
  final String referenceNumber;
  final String? sourceDocumentId;
  final String sourceType;
  final String? sourceId;
  final String status;
  final DateTime transactionDate;
  final DateTime effectiveDate;
  final DateTime recordingDate;
  final DateTime? postedAt;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? reversalOfEntryId;
  final String rowVersion;
  const JournalEntry(
      {required this.id,
      required this.tenantId,
      required this.fiscalPeriodId,
      required this.referenceNumber,
      this.sourceDocumentId,
      required this.sourceType,
      this.sourceId,
      required this.status,
      required this.transactionDate,
      required this.effectiveDate,
      required this.recordingDate,
      this.postedAt,
      required this.createdBy,
      required this.createdAt,
      required this.updatedAt,
      this.reversalOfEntryId,
      required this.rowVersion});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['tenant_id'] = Variable<String>(tenantId);
    map['fiscal_period_id'] = Variable<String>(fiscalPeriodId);
    map['reference_number'] = Variable<String>(referenceNumber);
    if (!nullToAbsent || sourceDocumentId != null) {
      map['source_document_id'] = Variable<String>(sourceDocumentId);
    }
    map['source_type'] = Variable<String>(sourceType);
    if (!nullToAbsent || sourceId != null) {
      map['source_id'] = Variable<String>(sourceId);
    }
    map['status'] = Variable<String>(status);
    map['transaction_date'] = Variable<DateTime>(transactionDate);
    map['effective_date'] = Variable<DateTime>(effectiveDate);
    map['recording_date'] = Variable<DateTime>(recordingDate);
    if (!nullToAbsent || postedAt != null) {
      map['posted_at'] = Variable<DateTime>(postedAt);
    }
    map['created_by'] = Variable<String>(createdBy);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || reversalOfEntryId != null) {
      map['reversal_of_entry_id'] = Variable<String>(reversalOfEntryId);
    }
    map['row_version'] = Variable<String>(rowVersion);
    return map;
  }

  JournalEntriesCompanion toCompanion(bool nullToAbsent) {
    return JournalEntriesCompanion(
      id: Value(id),
      tenantId: Value(tenantId),
      fiscalPeriodId: Value(fiscalPeriodId),
      referenceNumber: Value(referenceNumber),
      sourceDocumentId: sourceDocumentId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceDocumentId),
      sourceType: Value(sourceType),
      sourceId: sourceId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceId),
      status: Value(status),
      transactionDate: Value(transactionDate),
      effectiveDate: Value(effectiveDate),
      recordingDate: Value(recordingDate),
      postedAt: postedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(postedAt),
      createdBy: Value(createdBy),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      reversalOfEntryId: reversalOfEntryId == null && nullToAbsent
          ? const Value.absent()
          : Value(reversalOfEntryId),
      rowVersion: Value(rowVersion),
    );
  }

  factory JournalEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return JournalEntry(
      id: serializer.fromJson<String>(json['id']),
      tenantId: serializer.fromJson<String>(json['tenantId']),
      fiscalPeriodId: serializer.fromJson<String>(json['fiscalPeriodId']),
      referenceNumber: serializer.fromJson<String>(json['referenceNumber']),
      sourceDocumentId: serializer.fromJson<String?>(json['sourceDocumentId']),
      sourceType: serializer.fromJson<String>(json['sourceType']),
      sourceId: serializer.fromJson<String?>(json['sourceId']),
      status: serializer.fromJson<String>(json['status']),
      transactionDate: serializer.fromJson<DateTime>(json['transactionDate']),
      effectiveDate: serializer.fromJson<DateTime>(json['effectiveDate']),
      recordingDate: serializer.fromJson<DateTime>(json['recordingDate']),
      postedAt: serializer.fromJson<DateTime?>(json['postedAt']),
      createdBy: serializer.fromJson<String>(json['createdBy']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      reversalOfEntryId:
          serializer.fromJson<String?>(json['reversalOfEntryId']),
      rowVersion: serializer.fromJson<String>(json['rowVersion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tenantId': serializer.toJson<String>(tenantId),
      'fiscalPeriodId': serializer.toJson<String>(fiscalPeriodId),
      'referenceNumber': serializer.toJson<String>(referenceNumber),
      'sourceDocumentId': serializer.toJson<String?>(sourceDocumentId),
      'sourceType': serializer.toJson<String>(sourceType),
      'sourceId': serializer.toJson<String?>(sourceId),
      'status': serializer.toJson<String>(status),
      'transactionDate': serializer.toJson<DateTime>(transactionDate),
      'effectiveDate': serializer.toJson<DateTime>(effectiveDate),
      'recordingDate': serializer.toJson<DateTime>(recordingDate),
      'postedAt': serializer.toJson<DateTime?>(postedAt),
      'createdBy': serializer.toJson<String>(createdBy),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'reversalOfEntryId': serializer.toJson<String?>(reversalOfEntryId),
      'rowVersion': serializer.toJson<String>(rowVersion),
    };
  }

  JournalEntry copyWith(
          {String? id,
          String? tenantId,
          String? fiscalPeriodId,
          String? referenceNumber,
          Value<String?> sourceDocumentId = const Value.absent(),
          String? sourceType,
          Value<String?> sourceId = const Value.absent(),
          String? status,
          DateTime? transactionDate,
          DateTime? effectiveDate,
          DateTime? recordingDate,
          Value<DateTime?> postedAt = const Value.absent(),
          String? createdBy,
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<String?> reversalOfEntryId = const Value.absent(),
          String? rowVersion}) =>
      JournalEntry(
        id: id ?? this.id,
        tenantId: tenantId ?? this.tenantId,
        fiscalPeriodId: fiscalPeriodId ?? this.fiscalPeriodId,
        referenceNumber: referenceNumber ?? this.referenceNumber,
        sourceDocumentId: sourceDocumentId.present
            ? sourceDocumentId.value
            : this.sourceDocumentId,
        sourceType: sourceType ?? this.sourceType,
        sourceId: sourceId.present ? sourceId.value : this.sourceId,
        status: status ?? this.status,
        transactionDate: transactionDate ?? this.transactionDate,
        effectiveDate: effectiveDate ?? this.effectiveDate,
        recordingDate: recordingDate ?? this.recordingDate,
        postedAt: postedAt.present ? postedAt.value : this.postedAt,
        createdBy: createdBy ?? this.createdBy,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        reversalOfEntryId: reversalOfEntryId.present
            ? reversalOfEntryId.value
            : this.reversalOfEntryId,
        rowVersion: rowVersion ?? this.rowVersion,
      );
  @override
  String toString() {
    return (StringBuffer('JournalEntry(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('fiscalPeriodId: $fiscalPeriodId, ')
          ..write('referenceNumber: $referenceNumber, ')
          ..write('sourceDocumentId: $sourceDocumentId, ')
          ..write('sourceType: $sourceType, ')
          ..write('sourceId: $sourceId, ')
          ..write('status: $status, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('effectiveDate: $effectiveDate, ')
          ..write('recordingDate: $recordingDate, ')
          ..write('postedAt: $postedAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('reversalOfEntryId: $reversalOfEntryId, ')
          ..write('rowVersion: $rowVersion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      tenantId,
      fiscalPeriodId,
      referenceNumber,
      sourceDocumentId,
      sourceType,
      sourceId,
      status,
      transactionDate,
      effectiveDate,
      recordingDate,
      postedAt,
      createdBy,
      createdAt,
      updatedAt,
      reversalOfEntryId,
      rowVersion);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is JournalEntry &&
          other.id == this.id &&
          other.tenantId == this.tenantId &&
          other.fiscalPeriodId == this.fiscalPeriodId &&
          other.referenceNumber == this.referenceNumber &&
          other.sourceDocumentId == this.sourceDocumentId &&
          other.sourceType == this.sourceType &&
          other.sourceId == this.sourceId &&
          other.status == this.status &&
          other.transactionDate == this.transactionDate &&
          other.effectiveDate == this.effectiveDate &&
          other.recordingDate == this.recordingDate &&
          other.postedAt == this.postedAt &&
          other.createdBy == this.createdBy &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.reversalOfEntryId == this.reversalOfEntryId &&
          other.rowVersion == this.rowVersion);
}

class JournalEntriesCompanion extends UpdateCompanion<JournalEntry> {
  final Value<String> id;
  final Value<String> tenantId;
  final Value<String> fiscalPeriodId;
  final Value<String> referenceNumber;
  final Value<String?> sourceDocumentId;
  final Value<String> sourceType;
  final Value<String?> sourceId;
  final Value<String> status;
  final Value<DateTime> transactionDate;
  final Value<DateTime> effectiveDate;
  final Value<DateTime> recordingDate;
  final Value<DateTime?> postedAt;
  final Value<String> createdBy;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String?> reversalOfEntryId;
  final Value<String> rowVersion;
  final Value<int> rowid;
  const JournalEntriesCompanion({
    this.id = const Value.absent(),
    this.tenantId = const Value.absent(),
    this.fiscalPeriodId = const Value.absent(),
    this.referenceNumber = const Value.absent(),
    this.sourceDocumentId = const Value.absent(),
    this.sourceType = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.status = const Value.absent(),
    this.transactionDate = const Value.absent(),
    this.effectiveDate = const Value.absent(),
    this.recordingDate = const Value.absent(),
    this.postedAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.reversalOfEntryId = const Value.absent(),
    this.rowVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  JournalEntriesCompanion.insert({
    required String id,
    required String tenantId,
    required String fiscalPeriodId,
    required String referenceNumber,
    this.sourceDocumentId = const Value.absent(),
    required String sourceType,
    this.sourceId = const Value.absent(),
    required String status,
    required DateTime transactionDate,
    required DateTime effectiveDate,
    required DateTime recordingDate,
    this.postedAt = const Value.absent(),
    required String createdBy,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.reversalOfEntryId = const Value.absent(),
    required String rowVersion,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        tenantId = Value(tenantId),
        fiscalPeriodId = Value(fiscalPeriodId),
        referenceNumber = Value(referenceNumber),
        sourceType = Value(sourceType),
        status = Value(status),
        transactionDate = Value(transactionDate),
        effectiveDate = Value(effectiveDate),
        recordingDate = Value(recordingDate),
        createdBy = Value(createdBy),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt),
        rowVersion = Value(rowVersion);
  static Insertable<JournalEntry> custom({
    Expression<String>? id,
    Expression<String>? tenantId,
    Expression<String>? fiscalPeriodId,
    Expression<String>? referenceNumber,
    Expression<String>? sourceDocumentId,
    Expression<String>? sourceType,
    Expression<String>? sourceId,
    Expression<String>? status,
    Expression<DateTime>? transactionDate,
    Expression<DateTime>? effectiveDate,
    Expression<DateTime>? recordingDate,
    Expression<DateTime>? postedAt,
    Expression<String>? createdBy,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? reversalOfEntryId,
    Expression<String>? rowVersion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tenantId != null) 'tenant_id': tenantId,
      if (fiscalPeriodId != null) 'fiscal_period_id': fiscalPeriodId,
      if (referenceNumber != null) 'reference_number': referenceNumber,
      if (sourceDocumentId != null) 'source_document_id': sourceDocumentId,
      if (sourceType != null) 'source_type': sourceType,
      if (sourceId != null) 'source_id': sourceId,
      if (status != null) 'status': status,
      if (transactionDate != null) 'transaction_date': transactionDate,
      if (effectiveDate != null) 'effective_date': effectiveDate,
      if (recordingDate != null) 'recording_date': recordingDate,
      if (postedAt != null) 'posted_at': postedAt,
      if (createdBy != null) 'created_by': createdBy,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (reversalOfEntryId != null) 'reversal_of_entry_id': reversalOfEntryId,
      if (rowVersion != null) 'row_version': rowVersion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  JournalEntriesCompanion copyWith(
      {Value<String>? id,
      Value<String>? tenantId,
      Value<String>? fiscalPeriodId,
      Value<String>? referenceNumber,
      Value<String?>? sourceDocumentId,
      Value<String>? sourceType,
      Value<String?>? sourceId,
      Value<String>? status,
      Value<DateTime>? transactionDate,
      Value<DateTime>? effectiveDate,
      Value<DateTime>? recordingDate,
      Value<DateTime?>? postedAt,
      Value<String>? createdBy,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<String?>? reversalOfEntryId,
      Value<String>? rowVersion,
      Value<int>? rowid}) {
    return JournalEntriesCompanion(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      fiscalPeriodId: fiscalPeriodId ?? this.fiscalPeriodId,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      sourceDocumentId: sourceDocumentId ?? this.sourceDocumentId,
      sourceType: sourceType ?? this.sourceType,
      sourceId: sourceId ?? this.sourceId,
      status: status ?? this.status,
      transactionDate: transactionDate ?? this.transactionDate,
      effectiveDate: effectiveDate ?? this.effectiveDate,
      recordingDate: recordingDate ?? this.recordingDate,
      postedAt: postedAt ?? this.postedAt,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      reversalOfEntryId: reversalOfEntryId ?? this.reversalOfEntryId,
      rowVersion: rowVersion ?? this.rowVersion,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tenantId.present) {
      map['tenant_id'] = Variable<String>(tenantId.value);
    }
    if (fiscalPeriodId.present) {
      map['fiscal_period_id'] = Variable<String>(fiscalPeriodId.value);
    }
    if (referenceNumber.present) {
      map['reference_number'] = Variable<String>(referenceNumber.value);
    }
    if (sourceDocumentId.present) {
      map['source_document_id'] = Variable<String>(sourceDocumentId.value);
    }
    if (sourceType.present) {
      map['source_type'] = Variable<String>(sourceType.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<String>(sourceId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (transactionDate.present) {
      map['transaction_date'] = Variable<DateTime>(transactionDate.value);
    }
    if (effectiveDate.present) {
      map['effective_date'] = Variable<DateTime>(effectiveDate.value);
    }
    if (recordingDate.present) {
      map['recording_date'] = Variable<DateTime>(recordingDate.value);
    }
    if (postedAt.present) {
      map['posted_at'] = Variable<DateTime>(postedAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (reversalOfEntryId.present) {
      map['reversal_of_entry_id'] = Variable<String>(reversalOfEntryId.value);
    }
    if (rowVersion.present) {
      map['row_version'] = Variable<String>(rowVersion.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JournalEntriesCompanion(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('fiscalPeriodId: $fiscalPeriodId, ')
          ..write('referenceNumber: $referenceNumber, ')
          ..write('sourceDocumentId: $sourceDocumentId, ')
          ..write('sourceType: $sourceType, ')
          ..write('sourceId: $sourceId, ')
          ..write('status: $status, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('effectiveDate: $effectiveDate, ')
          ..write('recordingDate: $recordingDate, ')
          ..write('postedAt: $postedAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('reversalOfEntryId: $reversalOfEntryId, ')
          ..write('rowVersion: $rowVersion, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $JournalLinesTable extends JournalLines
    with TableInfo<$JournalLinesTable, JournalLine> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JournalLinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entryIdMeta =
      const VerificationMeta('entryId');
  @override
  late final GeneratedColumn<String> entryId = GeneratedColumn<String>(
      'entry_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES journal_entries (id)'));
  static const VerificationMeta _lineNumberMeta =
      const VerificationMeta('lineNumber');
  @override
  late final GeneratedColumn<int> lineNumber = GeneratedColumn<int>(
      'line_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _accountIdMeta =
      const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
      'account_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES accounts (id)'));
  static const VerificationMeta _debitMinorMeta =
      const VerificationMeta('debitMinor');
  @override
  late final GeneratedColumn<int> debitMinor = GeneratedColumn<int>(
      'debit_minor', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _creditMinorMeta =
      const VerificationMeta('creditMinor');
  @override
  late final GeneratedColumn<int> creditMinor = GeneratedColumn<int>(
      'credit_minor', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _currencyCodeMeta =
      const VerificationMeta('currencyCode');
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
      'currency_code', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 3, maxTextLength: 3),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _originalAmountMinorMeta =
      const VerificationMeta('originalAmountMinor');
  @override
  late final GeneratedColumn<int> originalAmountMinor = GeneratedColumn<int>(
      'original_amount_minor', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _exchangeRatePpmMeta =
      const VerificationMeta('exchangeRatePpm');
  @override
  late final GeneratedColumn<int> exchangeRatePpm = GeneratedColumn<int>(
      'exchange_rate_ppm', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _analyticDimensionJsonMeta =
      const VerificationMeta('analyticDimensionJson');
  @override
  late final GeneratedColumn<String> analyticDimensionJson =
      GeneratedColumn<String>('analytic_dimension_json', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        entryId,
        lineNumber,
        accountId,
        debitMinor,
        creditMinor,
        currencyCode,
        originalAmountMinor,
        exchangeRatePpm,
        description,
        analyticDimensionJson
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'journal_lines';
  @override
  VerificationContext validateIntegrity(Insertable<JournalLine> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('entry_id')) {
      context.handle(_entryIdMeta,
          entryId.isAcceptableOrUnknown(data['entry_id']!, _entryIdMeta));
    } else if (isInserting) {
      context.missing(_entryIdMeta);
    }
    if (data.containsKey('line_number')) {
      context.handle(
          _lineNumberMeta,
          lineNumber.isAcceptableOrUnknown(
              data['line_number']!, _lineNumberMeta));
    } else if (isInserting) {
      context.missing(_lineNumberMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta,
          accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('debit_minor')) {
      context.handle(
          _debitMinorMeta,
          debitMinor.isAcceptableOrUnknown(
              data['debit_minor']!, _debitMinorMeta));
    }
    if (data.containsKey('credit_minor')) {
      context.handle(
          _creditMinorMeta,
          creditMinor.isAcceptableOrUnknown(
              data['credit_minor']!, _creditMinorMeta));
    }
    if (data.containsKey('currency_code')) {
      context.handle(
          _currencyCodeMeta,
          currencyCode.isAcceptableOrUnknown(
              data['currency_code']!, _currencyCodeMeta));
    } else if (isInserting) {
      context.missing(_currencyCodeMeta);
    }
    if (data.containsKey('original_amount_minor')) {
      context.handle(
          _originalAmountMinorMeta,
          originalAmountMinor.isAcceptableOrUnknown(
              data['original_amount_minor']!, _originalAmountMinorMeta));
    }
    if (data.containsKey('exchange_rate_ppm')) {
      context.handle(
          _exchangeRatePpmMeta,
          exchangeRatePpm.isAcceptableOrUnknown(
              data['exchange_rate_ppm']!, _exchangeRatePpmMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('analytic_dimension_json')) {
      context.handle(
          _analyticDimensionJsonMeta,
          analyticDimensionJson.isAcceptableOrUnknown(
              data['analytic_dimension_json']!, _analyticDimensionJsonMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {entryId, lineNumber},
      ];
  @override
  JournalLine map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JournalLine(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      entryId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entry_id'])!,
      lineNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}line_number'])!,
      accountId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}account_id'])!,
      debitMinor: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}debit_minor'])!,
      creditMinor: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}credit_minor'])!,
      currencyCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency_code'])!,
      originalAmountMinor: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}original_amount_minor']),
      exchangeRatePpm: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}exchange_rate_ppm']),
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      analyticDimensionJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}analytic_dimension_json']),
    );
  }

  @override
  $JournalLinesTable createAlias(String alias) {
    return $JournalLinesTable(attachedDatabase, alias);
  }
}

class JournalLine extends DataClass implements Insertable<JournalLine> {
  final String id;
  final String entryId;
  final int lineNumber;
  final String accountId;
  final int debitMinor;
  final int creditMinor;
  final String currencyCode;
  final int? originalAmountMinor;
  final int? exchangeRatePpm;
  final String? description;
  final String? analyticDimensionJson;
  const JournalLine(
      {required this.id,
      required this.entryId,
      required this.lineNumber,
      required this.accountId,
      required this.debitMinor,
      required this.creditMinor,
      required this.currencyCode,
      this.originalAmountMinor,
      this.exchangeRatePpm,
      this.description,
      this.analyticDimensionJson});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['entry_id'] = Variable<String>(entryId);
    map['line_number'] = Variable<int>(lineNumber);
    map['account_id'] = Variable<String>(accountId);
    map['debit_minor'] = Variable<int>(debitMinor);
    map['credit_minor'] = Variable<int>(creditMinor);
    map['currency_code'] = Variable<String>(currencyCode);
    if (!nullToAbsent || originalAmountMinor != null) {
      map['original_amount_minor'] = Variable<int>(originalAmountMinor);
    }
    if (!nullToAbsent || exchangeRatePpm != null) {
      map['exchange_rate_ppm'] = Variable<int>(exchangeRatePpm);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || analyticDimensionJson != null) {
      map['analytic_dimension_json'] = Variable<String>(analyticDimensionJson);
    }
    return map;
  }

  JournalLinesCompanion toCompanion(bool nullToAbsent) {
    return JournalLinesCompanion(
      id: Value(id),
      entryId: Value(entryId),
      lineNumber: Value(lineNumber),
      accountId: Value(accountId),
      debitMinor: Value(debitMinor),
      creditMinor: Value(creditMinor),
      currencyCode: Value(currencyCode),
      originalAmountMinor: originalAmountMinor == null && nullToAbsent
          ? const Value.absent()
          : Value(originalAmountMinor),
      exchangeRatePpm: exchangeRatePpm == null && nullToAbsent
          ? const Value.absent()
          : Value(exchangeRatePpm),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      analyticDimensionJson: analyticDimensionJson == null && nullToAbsent
          ? const Value.absent()
          : Value(analyticDimensionJson),
    );
  }

  factory JournalLine.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return JournalLine(
      id: serializer.fromJson<String>(json['id']),
      entryId: serializer.fromJson<String>(json['entryId']),
      lineNumber: serializer.fromJson<int>(json['lineNumber']),
      accountId: serializer.fromJson<String>(json['accountId']),
      debitMinor: serializer.fromJson<int>(json['debitMinor']),
      creditMinor: serializer.fromJson<int>(json['creditMinor']),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      originalAmountMinor:
          serializer.fromJson<int?>(json['originalAmountMinor']),
      exchangeRatePpm: serializer.fromJson<int?>(json['exchangeRatePpm']),
      description: serializer.fromJson<String?>(json['description']),
      analyticDimensionJson:
          serializer.fromJson<String?>(json['analyticDimensionJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entryId': serializer.toJson<String>(entryId),
      'lineNumber': serializer.toJson<int>(lineNumber),
      'accountId': serializer.toJson<String>(accountId),
      'debitMinor': serializer.toJson<int>(debitMinor),
      'creditMinor': serializer.toJson<int>(creditMinor),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'originalAmountMinor': serializer.toJson<int?>(originalAmountMinor),
      'exchangeRatePpm': serializer.toJson<int?>(exchangeRatePpm),
      'description': serializer.toJson<String?>(description),
      'analyticDimensionJson':
          serializer.toJson<String?>(analyticDimensionJson),
    };
  }

  JournalLine copyWith(
          {String? id,
          String? entryId,
          int? lineNumber,
          String? accountId,
          int? debitMinor,
          int? creditMinor,
          String? currencyCode,
          Value<int?> originalAmountMinor = const Value.absent(),
          Value<int?> exchangeRatePpm = const Value.absent(),
          Value<String?> description = const Value.absent(),
          Value<String?> analyticDimensionJson = const Value.absent()}) =>
      JournalLine(
        id: id ?? this.id,
        entryId: entryId ?? this.entryId,
        lineNumber: lineNumber ?? this.lineNumber,
        accountId: accountId ?? this.accountId,
        debitMinor: debitMinor ?? this.debitMinor,
        creditMinor: creditMinor ?? this.creditMinor,
        currencyCode: currencyCode ?? this.currencyCode,
        originalAmountMinor: originalAmountMinor.present
            ? originalAmountMinor.value
            : this.originalAmountMinor,
        exchangeRatePpm: exchangeRatePpm.present
            ? exchangeRatePpm.value
            : this.exchangeRatePpm,
        description: description.present ? description.value : this.description,
        analyticDimensionJson: analyticDimensionJson.present
            ? analyticDimensionJson.value
            : this.analyticDimensionJson,
      );
  @override
  String toString() {
    return (StringBuffer('JournalLine(')
          ..write('id: $id, ')
          ..write('entryId: $entryId, ')
          ..write('lineNumber: $lineNumber, ')
          ..write('accountId: $accountId, ')
          ..write('debitMinor: $debitMinor, ')
          ..write('creditMinor: $creditMinor, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('originalAmountMinor: $originalAmountMinor, ')
          ..write('exchangeRatePpm: $exchangeRatePpm, ')
          ..write('description: $description, ')
          ..write('analyticDimensionJson: $analyticDimensionJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      entryId,
      lineNumber,
      accountId,
      debitMinor,
      creditMinor,
      currencyCode,
      originalAmountMinor,
      exchangeRatePpm,
      description,
      analyticDimensionJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is JournalLine &&
          other.id == this.id &&
          other.entryId == this.entryId &&
          other.lineNumber == this.lineNumber &&
          other.accountId == this.accountId &&
          other.debitMinor == this.debitMinor &&
          other.creditMinor == this.creditMinor &&
          other.currencyCode == this.currencyCode &&
          other.originalAmountMinor == this.originalAmountMinor &&
          other.exchangeRatePpm == this.exchangeRatePpm &&
          other.description == this.description &&
          other.analyticDimensionJson == this.analyticDimensionJson);
}

class JournalLinesCompanion extends UpdateCompanion<JournalLine> {
  final Value<String> id;
  final Value<String> entryId;
  final Value<int> lineNumber;
  final Value<String> accountId;
  final Value<int> debitMinor;
  final Value<int> creditMinor;
  final Value<String> currencyCode;
  final Value<int?> originalAmountMinor;
  final Value<int?> exchangeRatePpm;
  final Value<String?> description;
  final Value<String?> analyticDimensionJson;
  final Value<int> rowid;
  const JournalLinesCompanion({
    this.id = const Value.absent(),
    this.entryId = const Value.absent(),
    this.lineNumber = const Value.absent(),
    this.accountId = const Value.absent(),
    this.debitMinor = const Value.absent(),
    this.creditMinor = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.originalAmountMinor = const Value.absent(),
    this.exchangeRatePpm = const Value.absent(),
    this.description = const Value.absent(),
    this.analyticDimensionJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  JournalLinesCompanion.insert({
    required String id,
    required String entryId,
    required int lineNumber,
    required String accountId,
    this.debitMinor = const Value.absent(),
    this.creditMinor = const Value.absent(),
    required String currencyCode,
    this.originalAmountMinor = const Value.absent(),
    this.exchangeRatePpm = const Value.absent(),
    this.description = const Value.absent(),
    this.analyticDimensionJson = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        entryId = Value(entryId),
        lineNumber = Value(lineNumber),
        accountId = Value(accountId),
        currencyCode = Value(currencyCode);
  static Insertable<JournalLine> custom({
    Expression<String>? id,
    Expression<String>? entryId,
    Expression<int>? lineNumber,
    Expression<String>? accountId,
    Expression<int>? debitMinor,
    Expression<int>? creditMinor,
    Expression<String>? currencyCode,
    Expression<int>? originalAmountMinor,
    Expression<int>? exchangeRatePpm,
    Expression<String>? description,
    Expression<String>? analyticDimensionJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entryId != null) 'entry_id': entryId,
      if (lineNumber != null) 'line_number': lineNumber,
      if (accountId != null) 'account_id': accountId,
      if (debitMinor != null) 'debit_minor': debitMinor,
      if (creditMinor != null) 'credit_minor': creditMinor,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (originalAmountMinor != null)
        'original_amount_minor': originalAmountMinor,
      if (exchangeRatePpm != null) 'exchange_rate_ppm': exchangeRatePpm,
      if (description != null) 'description': description,
      if (analyticDimensionJson != null)
        'analytic_dimension_json': analyticDimensionJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  JournalLinesCompanion copyWith(
      {Value<String>? id,
      Value<String>? entryId,
      Value<int>? lineNumber,
      Value<String>? accountId,
      Value<int>? debitMinor,
      Value<int>? creditMinor,
      Value<String>? currencyCode,
      Value<int?>? originalAmountMinor,
      Value<int?>? exchangeRatePpm,
      Value<String?>? description,
      Value<String?>? analyticDimensionJson,
      Value<int>? rowid}) {
    return JournalLinesCompanion(
      id: id ?? this.id,
      entryId: entryId ?? this.entryId,
      lineNumber: lineNumber ?? this.lineNumber,
      accountId: accountId ?? this.accountId,
      debitMinor: debitMinor ?? this.debitMinor,
      creditMinor: creditMinor ?? this.creditMinor,
      currencyCode: currencyCode ?? this.currencyCode,
      originalAmountMinor: originalAmountMinor ?? this.originalAmountMinor,
      exchangeRatePpm: exchangeRatePpm ?? this.exchangeRatePpm,
      description: description ?? this.description,
      analyticDimensionJson:
          analyticDimensionJson ?? this.analyticDimensionJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (entryId.present) {
      map['entry_id'] = Variable<String>(entryId.value);
    }
    if (lineNumber.present) {
      map['line_number'] = Variable<int>(lineNumber.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (debitMinor.present) {
      map['debit_minor'] = Variable<int>(debitMinor.value);
    }
    if (creditMinor.present) {
      map['credit_minor'] = Variable<int>(creditMinor.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (originalAmountMinor.present) {
      map['original_amount_minor'] = Variable<int>(originalAmountMinor.value);
    }
    if (exchangeRatePpm.present) {
      map['exchange_rate_ppm'] = Variable<int>(exchangeRatePpm.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (analyticDimensionJson.present) {
      map['analytic_dimension_json'] =
          Variable<String>(analyticDimensionJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JournalLinesCompanion(')
          ..write('id: $id, ')
          ..write('entryId: $entryId, ')
          ..write('lineNumber: $lineNumber, ')
          ..write('accountId: $accountId, ')
          ..write('debitMinor: $debitMinor, ')
          ..write('creditMinor: $creditMinor, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('originalAmountMinor: $originalAmountMinor, ')
          ..write('exchangeRatePpm: $exchangeRatePpm, ')
          ..write('description: $description, ')
          ..write('analyticDimensionJson: $analyticDimensionJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $IdempotencyKeysTable extends IdempotencyKeys
    with TableInfo<$IdempotencyKeysTable, IdempotencyKey> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IdempotencyKeysTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tenantIdMeta =
      const VerificationMeta('tenantId');
  @override
  late final GeneratedColumn<String> tenantId = GeneratedColumn<String>(
      'tenant_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES tenants (id)'));
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _commandTypeMeta =
      const VerificationMeta('commandType');
  @override
  late final GeneratedColumn<String> commandType = GeneratedColumn<String>(
      'command_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _commandHashMeta =
      const VerificationMeta('commandHash');
  @override
  late final GeneratedColumn<String> commandHash = GeneratedColumn<String>(
      'command_hash', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
      'state', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _receiptIdMeta =
      const VerificationMeta('receiptId');
  @override
  late final GeneratedColumn<String> receiptId = GeneratedColumn<String>(
      'receipt_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
      'completed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        tenantId,
        key,
        commandType,
        commandHash,
        state,
        receiptId,
        createdAt,
        completedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'idempotency_keys';
  @override
  VerificationContext validateIntegrity(Insertable<IdempotencyKey> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('tenant_id')) {
      context.handle(_tenantIdMeta,
          tenantId.isAcceptableOrUnknown(data['tenant_id']!, _tenantIdMeta));
    } else if (isInserting) {
      context.missing(_tenantIdMeta);
    }
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('command_type')) {
      context.handle(
          _commandTypeMeta,
          commandType.isAcceptableOrUnknown(
              data['command_type']!, _commandTypeMeta));
    } else if (isInserting) {
      context.missing(_commandTypeMeta);
    }
    if (data.containsKey('command_hash')) {
      context.handle(
          _commandHashMeta,
          commandHash.isAcceptableOrUnknown(
              data['command_hash']!, _commandHashMeta));
    } else if (isInserting) {
      context.missing(_commandHashMeta);
    }
    if (data.containsKey('state')) {
      context.handle(
          _stateMeta, state.isAcceptableOrUnknown(data['state']!, _stateMeta));
    } else if (isInserting) {
      context.missing(_stateMeta);
    }
    if (data.containsKey('receipt_id')) {
      context.handle(_receiptIdMeta,
          receiptId.isAcceptableOrUnknown(data['receipt_id']!, _receiptIdMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {tenantId, key},
      ];
  @override
  IdempotencyKey map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IdempotencyKey(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      tenantId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tenant_id'])!,
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      commandType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}command_type'])!,
      commandHash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}command_hash'])!,
      state: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}state'])!,
      receiptId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}receipt_id']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}completed_at']),
    );
  }

  @override
  $IdempotencyKeysTable createAlias(String alias) {
    return $IdempotencyKeysTable(attachedDatabase, alias);
  }
}

class IdempotencyKey extends DataClass implements Insertable<IdempotencyKey> {
  final String id;
  final String tenantId;
  final String key;
  final String commandType;
  final String commandHash;
  final String state;
  final String? receiptId;
  final DateTime createdAt;
  final DateTime? completedAt;
  const IdempotencyKey(
      {required this.id,
      required this.tenantId,
      required this.key,
      required this.commandType,
      required this.commandHash,
      required this.state,
      this.receiptId,
      required this.createdAt,
      this.completedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['tenant_id'] = Variable<String>(tenantId);
    map['key'] = Variable<String>(key);
    map['command_type'] = Variable<String>(commandType);
    map['command_hash'] = Variable<String>(commandHash);
    map['state'] = Variable<String>(state);
    if (!nullToAbsent || receiptId != null) {
      map['receipt_id'] = Variable<String>(receiptId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    return map;
  }

  IdempotencyKeysCompanion toCompanion(bool nullToAbsent) {
    return IdempotencyKeysCompanion(
      id: Value(id),
      tenantId: Value(tenantId),
      key: Value(key),
      commandType: Value(commandType),
      commandHash: Value(commandHash),
      state: Value(state),
      receiptId: receiptId == null && nullToAbsent
          ? const Value.absent()
          : Value(receiptId),
      createdAt: Value(createdAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
    );
  }

  factory IdempotencyKey.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IdempotencyKey(
      id: serializer.fromJson<String>(json['id']),
      tenantId: serializer.fromJson<String>(json['tenantId']),
      key: serializer.fromJson<String>(json['key']),
      commandType: serializer.fromJson<String>(json['commandType']),
      commandHash: serializer.fromJson<String>(json['commandHash']),
      state: serializer.fromJson<String>(json['state']),
      receiptId: serializer.fromJson<String?>(json['receiptId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tenantId': serializer.toJson<String>(tenantId),
      'key': serializer.toJson<String>(key),
      'commandType': serializer.toJson<String>(commandType),
      'commandHash': serializer.toJson<String>(commandHash),
      'state': serializer.toJson<String>(state),
      'receiptId': serializer.toJson<String?>(receiptId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
    };
  }

  IdempotencyKey copyWith(
          {String? id,
          String? tenantId,
          String? key,
          String? commandType,
          String? commandHash,
          String? state,
          Value<String?> receiptId = const Value.absent(),
          DateTime? createdAt,
          Value<DateTime?> completedAt = const Value.absent()}) =>
      IdempotencyKey(
        id: id ?? this.id,
        tenantId: tenantId ?? this.tenantId,
        key: key ?? this.key,
        commandType: commandType ?? this.commandType,
        commandHash: commandHash ?? this.commandHash,
        state: state ?? this.state,
        receiptId: receiptId.present ? receiptId.value : this.receiptId,
        createdAt: createdAt ?? this.createdAt,
        completedAt: completedAt.present ? completedAt.value : this.completedAt,
      );
  @override
  String toString() {
    return (StringBuffer('IdempotencyKey(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('key: $key, ')
          ..write('commandType: $commandType, ')
          ..write('commandHash: $commandHash, ')
          ..write('state: $state, ')
          ..write('receiptId: $receiptId, ')
          ..write('createdAt: $createdAt, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, tenantId, key, commandType, commandHash,
      state, receiptId, createdAt, completedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IdempotencyKey &&
          other.id == this.id &&
          other.tenantId == this.tenantId &&
          other.key == this.key &&
          other.commandType == this.commandType &&
          other.commandHash == this.commandHash &&
          other.state == this.state &&
          other.receiptId == this.receiptId &&
          other.createdAt == this.createdAt &&
          other.completedAt == this.completedAt);
}

class IdempotencyKeysCompanion extends UpdateCompanion<IdempotencyKey> {
  final Value<String> id;
  final Value<String> tenantId;
  final Value<String> key;
  final Value<String> commandType;
  final Value<String> commandHash;
  final Value<String> state;
  final Value<String?> receiptId;
  final Value<DateTime> createdAt;
  final Value<DateTime?> completedAt;
  final Value<int> rowid;
  const IdempotencyKeysCompanion({
    this.id = const Value.absent(),
    this.tenantId = const Value.absent(),
    this.key = const Value.absent(),
    this.commandType = const Value.absent(),
    this.commandHash = const Value.absent(),
    this.state = const Value.absent(),
    this.receiptId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  IdempotencyKeysCompanion.insert({
    required String id,
    required String tenantId,
    required String key,
    required String commandType,
    required String commandHash,
    required String state,
    this.receiptId = const Value.absent(),
    required DateTime createdAt,
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        tenantId = Value(tenantId),
        key = Value(key),
        commandType = Value(commandType),
        commandHash = Value(commandHash),
        state = Value(state),
        createdAt = Value(createdAt);
  static Insertable<IdempotencyKey> custom({
    Expression<String>? id,
    Expression<String>? tenantId,
    Expression<String>? key,
    Expression<String>? commandType,
    Expression<String>? commandHash,
    Expression<String>? state,
    Expression<String>? receiptId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? completedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tenantId != null) 'tenant_id': tenantId,
      if (key != null) 'key': key,
      if (commandType != null) 'command_type': commandType,
      if (commandHash != null) 'command_hash': commandHash,
      if (state != null) 'state': state,
      if (receiptId != null) 'receipt_id': receiptId,
      if (createdAt != null) 'created_at': createdAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  IdempotencyKeysCompanion copyWith(
      {Value<String>? id,
      Value<String>? tenantId,
      Value<String>? key,
      Value<String>? commandType,
      Value<String>? commandHash,
      Value<String>? state,
      Value<String?>? receiptId,
      Value<DateTime>? createdAt,
      Value<DateTime?>? completedAt,
      Value<int>? rowid}) {
    return IdempotencyKeysCompanion(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      key: key ?? this.key,
      commandType: commandType ?? this.commandType,
      commandHash: commandHash ?? this.commandHash,
      state: state ?? this.state,
      receiptId: receiptId ?? this.receiptId,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tenantId.present) {
      map['tenant_id'] = Variable<String>(tenantId.value);
    }
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (commandType.present) {
      map['command_type'] = Variable<String>(commandType.value);
    }
    if (commandHash.present) {
      map['command_hash'] = Variable<String>(commandHash.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (receiptId.present) {
      map['receipt_id'] = Variable<String>(receiptId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IdempotencyKeysCompanion(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('key: $key, ')
          ..write('commandType: $commandType, ')
          ..write('commandHash: $commandHash, ')
          ..write('state: $state, ')
          ..write('receiptId: $receiptId, ')
          ..write('createdAt: $createdAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PostingReceiptsTable extends PostingReceipts
    with TableInfo<$PostingReceiptsTable, PostingReceipt> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PostingReceiptsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tenantIdMeta =
      const VerificationMeta('tenantId');
  @override
  late final GeneratedColumn<String> tenantId = GeneratedColumn<String>(
      'tenant_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES tenants (id)'));
  static const VerificationMeta _entryIdMeta =
      const VerificationMeta('entryId');
  @override
  late final GeneratedColumn<String> entryId = GeneratedColumn<String>(
      'entry_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES journal_entries (id)'));
  static const VerificationMeta _idempotencyKeyIdMeta =
      const VerificationMeta('idempotencyKeyId');
  @override
  late final GeneratedColumn<String> idempotencyKeyId = GeneratedColumn<String>(
      'idempotency_key_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES idempotency_keys (id)'));
  static const VerificationMeta _writerEpochMeta =
      const VerificationMeta('writerEpoch');
  @override
  late final GeneratedColumn<String> writerEpoch = GeneratedColumn<String>(
      'writer_epoch', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _commandHashMeta =
      const VerificationMeta('commandHash');
  @override
  late final GeneratedColumn<String> commandHash = GeneratedColumn<String>(
      'command_hash', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _acceptedAtMeta =
      const VerificationMeta('acceptedAt');
  @override
  late final GeneratedColumn<DateTime> acceptedAt = GeneratedColumn<DateTime>(
      'accepted_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        tenantId,
        entryId,
        idempotencyKeyId,
        writerEpoch,
        commandHash,
        acceptedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'posting_receipts';
  @override
  VerificationContext validateIntegrity(Insertable<PostingReceipt> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('tenant_id')) {
      context.handle(_tenantIdMeta,
          tenantId.isAcceptableOrUnknown(data['tenant_id']!, _tenantIdMeta));
    } else if (isInserting) {
      context.missing(_tenantIdMeta);
    }
    if (data.containsKey('entry_id')) {
      context.handle(_entryIdMeta,
          entryId.isAcceptableOrUnknown(data['entry_id']!, _entryIdMeta));
    } else if (isInserting) {
      context.missing(_entryIdMeta);
    }
    if (data.containsKey('idempotency_key_id')) {
      context.handle(
          _idempotencyKeyIdMeta,
          idempotencyKeyId.isAcceptableOrUnknown(
              data['idempotency_key_id']!, _idempotencyKeyIdMeta));
    } else if (isInserting) {
      context.missing(_idempotencyKeyIdMeta);
    }
    if (data.containsKey('writer_epoch')) {
      context.handle(
          _writerEpochMeta,
          writerEpoch.isAcceptableOrUnknown(
              data['writer_epoch']!, _writerEpochMeta));
    } else if (isInserting) {
      context.missing(_writerEpochMeta);
    }
    if (data.containsKey('command_hash')) {
      context.handle(
          _commandHashMeta,
          commandHash.isAcceptableOrUnknown(
              data['command_hash']!, _commandHashMeta));
    } else if (isInserting) {
      context.missing(_commandHashMeta);
    }
    if (data.containsKey('accepted_at')) {
      context.handle(
          _acceptedAtMeta,
          acceptedAt.isAcceptableOrUnknown(
              data['accepted_at']!, _acceptedAtMeta));
    } else if (isInserting) {
      context.missing(_acceptedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {tenantId, entryId},
        {tenantId, idempotencyKeyId},
      ];
  @override
  PostingReceipt map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PostingReceipt(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      tenantId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tenant_id'])!,
      entryId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entry_id'])!,
      idempotencyKeyId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}idempotency_key_id'])!,
      writerEpoch: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}writer_epoch'])!,
      commandHash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}command_hash'])!,
      acceptedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}accepted_at'])!,
    );
  }

  @override
  $PostingReceiptsTable createAlias(String alias) {
    return $PostingReceiptsTable(attachedDatabase, alias);
  }
}

class PostingReceipt extends DataClass implements Insertable<PostingReceipt> {
  final String id;
  final String tenantId;
  final String entryId;
  final String idempotencyKeyId;
  final String writerEpoch;
  final String commandHash;
  final DateTime acceptedAt;
  const PostingReceipt(
      {required this.id,
      required this.tenantId,
      required this.entryId,
      required this.idempotencyKeyId,
      required this.writerEpoch,
      required this.commandHash,
      required this.acceptedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['tenant_id'] = Variable<String>(tenantId);
    map['entry_id'] = Variable<String>(entryId);
    map['idempotency_key_id'] = Variable<String>(idempotencyKeyId);
    map['writer_epoch'] = Variable<String>(writerEpoch);
    map['command_hash'] = Variable<String>(commandHash);
    map['accepted_at'] = Variable<DateTime>(acceptedAt);
    return map;
  }

  PostingReceiptsCompanion toCompanion(bool nullToAbsent) {
    return PostingReceiptsCompanion(
      id: Value(id),
      tenantId: Value(tenantId),
      entryId: Value(entryId),
      idempotencyKeyId: Value(idempotencyKeyId),
      writerEpoch: Value(writerEpoch),
      commandHash: Value(commandHash),
      acceptedAt: Value(acceptedAt),
    );
  }

  factory PostingReceipt.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PostingReceipt(
      id: serializer.fromJson<String>(json['id']),
      tenantId: serializer.fromJson<String>(json['tenantId']),
      entryId: serializer.fromJson<String>(json['entryId']),
      idempotencyKeyId: serializer.fromJson<String>(json['idempotencyKeyId']),
      writerEpoch: serializer.fromJson<String>(json['writerEpoch']),
      commandHash: serializer.fromJson<String>(json['commandHash']),
      acceptedAt: serializer.fromJson<DateTime>(json['acceptedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tenantId': serializer.toJson<String>(tenantId),
      'entryId': serializer.toJson<String>(entryId),
      'idempotencyKeyId': serializer.toJson<String>(idempotencyKeyId),
      'writerEpoch': serializer.toJson<String>(writerEpoch),
      'commandHash': serializer.toJson<String>(commandHash),
      'acceptedAt': serializer.toJson<DateTime>(acceptedAt),
    };
  }

  PostingReceipt copyWith(
          {String? id,
          String? tenantId,
          String? entryId,
          String? idempotencyKeyId,
          String? writerEpoch,
          String? commandHash,
          DateTime? acceptedAt}) =>
      PostingReceipt(
        id: id ?? this.id,
        tenantId: tenantId ?? this.tenantId,
        entryId: entryId ?? this.entryId,
        idempotencyKeyId: idempotencyKeyId ?? this.idempotencyKeyId,
        writerEpoch: writerEpoch ?? this.writerEpoch,
        commandHash: commandHash ?? this.commandHash,
        acceptedAt: acceptedAt ?? this.acceptedAt,
      );
  @override
  String toString() {
    return (StringBuffer('PostingReceipt(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('entryId: $entryId, ')
          ..write('idempotencyKeyId: $idempotencyKeyId, ')
          ..write('writerEpoch: $writerEpoch, ')
          ..write('commandHash: $commandHash, ')
          ..write('acceptedAt: $acceptedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, tenantId, entryId, idempotencyKeyId,
      writerEpoch, commandHash, acceptedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PostingReceipt &&
          other.id == this.id &&
          other.tenantId == this.tenantId &&
          other.entryId == this.entryId &&
          other.idempotencyKeyId == this.idempotencyKeyId &&
          other.writerEpoch == this.writerEpoch &&
          other.commandHash == this.commandHash &&
          other.acceptedAt == this.acceptedAt);
}

class PostingReceiptsCompanion extends UpdateCompanion<PostingReceipt> {
  final Value<String> id;
  final Value<String> tenantId;
  final Value<String> entryId;
  final Value<String> idempotencyKeyId;
  final Value<String> writerEpoch;
  final Value<String> commandHash;
  final Value<DateTime> acceptedAt;
  final Value<int> rowid;
  const PostingReceiptsCompanion({
    this.id = const Value.absent(),
    this.tenantId = const Value.absent(),
    this.entryId = const Value.absent(),
    this.idempotencyKeyId = const Value.absent(),
    this.writerEpoch = const Value.absent(),
    this.commandHash = const Value.absent(),
    this.acceptedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PostingReceiptsCompanion.insert({
    required String id,
    required String tenantId,
    required String entryId,
    required String idempotencyKeyId,
    required String writerEpoch,
    required String commandHash,
    required DateTime acceptedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        tenantId = Value(tenantId),
        entryId = Value(entryId),
        idempotencyKeyId = Value(idempotencyKeyId),
        writerEpoch = Value(writerEpoch),
        commandHash = Value(commandHash),
        acceptedAt = Value(acceptedAt);
  static Insertable<PostingReceipt> custom({
    Expression<String>? id,
    Expression<String>? tenantId,
    Expression<String>? entryId,
    Expression<String>? idempotencyKeyId,
    Expression<String>? writerEpoch,
    Expression<String>? commandHash,
    Expression<DateTime>? acceptedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tenantId != null) 'tenant_id': tenantId,
      if (entryId != null) 'entry_id': entryId,
      if (idempotencyKeyId != null) 'idempotency_key_id': idempotencyKeyId,
      if (writerEpoch != null) 'writer_epoch': writerEpoch,
      if (commandHash != null) 'command_hash': commandHash,
      if (acceptedAt != null) 'accepted_at': acceptedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PostingReceiptsCompanion copyWith(
      {Value<String>? id,
      Value<String>? tenantId,
      Value<String>? entryId,
      Value<String>? idempotencyKeyId,
      Value<String>? writerEpoch,
      Value<String>? commandHash,
      Value<DateTime>? acceptedAt,
      Value<int>? rowid}) {
    return PostingReceiptsCompanion(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      entryId: entryId ?? this.entryId,
      idempotencyKeyId: idempotencyKeyId ?? this.idempotencyKeyId,
      writerEpoch: writerEpoch ?? this.writerEpoch,
      commandHash: commandHash ?? this.commandHash,
      acceptedAt: acceptedAt ?? this.acceptedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tenantId.present) {
      map['tenant_id'] = Variable<String>(tenantId.value);
    }
    if (entryId.present) {
      map['entry_id'] = Variable<String>(entryId.value);
    }
    if (idempotencyKeyId.present) {
      map['idempotency_key_id'] = Variable<String>(idempotencyKeyId.value);
    }
    if (writerEpoch.present) {
      map['writer_epoch'] = Variable<String>(writerEpoch.value);
    }
    if (commandHash.present) {
      map['command_hash'] = Variable<String>(commandHash.value);
    }
    if (acceptedAt.present) {
      map['accepted_at'] = Variable<DateTime>(acceptedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PostingReceiptsCompanion(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('entryId: $entryId, ')
          ..write('idempotencyKeyId: $idempotencyKeyId, ')
          ..write('writerEpoch: $writerEpoch, ')
          ..write('commandHash: $commandHash, ')
          ..write('acceptedAt: $acceptedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OutboxEventsTable extends OutboxEvents
    with TableInfo<$OutboxEventsTable, OutboxEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OutboxEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tenantIdMeta =
      const VerificationMeta('tenantId');
  @override
  late final GeneratedColumn<String> tenantId = GeneratedColumn<String>(
      'tenant_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES tenants (id)'));
  static const VerificationMeta _sequenceMeta =
      const VerificationMeta('sequence');
  @override
  late final GeneratedColumn<int> sequence = GeneratedColumn<int>(
      'sequence', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _aggregateTypeMeta =
      const VerificationMeta('aggregateType');
  @override
  late final GeneratedColumn<String> aggregateType = GeneratedColumn<String>(
      'aggregate_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _aggregateIdMeta =
      const VerificationMeta('aggregateId');
  @override
  late final GeneratedColumn<String> aggregateId = GeneratedColumn<String>(
      'aggregate_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _eventTypeMeta =
      const VerificationMeta('eventType');
  @override
  late final GeneratedColumn<String> eventType = GeneratedColumn<String>(
      'event_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _payloadJsonMeta =
      const VerificationMeta('payloadJson');
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
      'payload_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _payloadHashMeta =
      const VerificationMeta('payloadHash');
  @override
  late final GeneratedColumn<String> payloadHash = GeneratedColumn<String>(
      'payload_hash', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
      'state', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _attemptsMeta =
      const VerificationMeta('attempts');
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
      'attempts', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _processedAtMeta =
      const VerificationMeta('processedAt');
  @override
  late final GeneratedColumn<DateTime> processedAt = GeneratedColumn<DateTime>(
      'processed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        tenantId,
        sequence,
        aggregateType,
        aggregateId,
        eventType,
        payloadJson,
        payloadHash,
        state,
        attempts,
        createdAt,
        processedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'outbox_events';
  @override
  VerificationContext validateIntegrity(Insertable<OutboxEvent> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('tenant_id')) {
      context.handle(_tenantIdMeta,
          tenantId.isAcceptableOrUnknown(data['tenant_id']!, _tenantIdMeta));
    } else if (isInserting) {
      context.missing(_tenantIdMeta);
    }
    if (data.containsKey('sequence')) {
      context.handle(_sequenceMeta,
          sequence.isAcceptableOrUnknown(data['sequence']!, _sequenceMeta));
    } else if (isInserting) {
      context.missing(_sequenceMeta);
    }
    if (data.containsKey('aggregate_type')) {
      context.handle(
          _aggregateTypeMeta,
          aggregateType.isAcceptableOrUnknown(
              data['aggregate_type']!, _aggregateTypeMeta));
    } else if (isInserting) {
      context.missing(_aggregateTypeMeta);
    }
    if (data.containsKey('aggregate_id')) {
      context.handle(
          _aggregateIdMeta,
          aggregateId.isAcceptableOrUnknown(
              data['aggregate_id']!, _aggregateIdMeta));
    } else if (isInserting) {
      context.missing(_aggregateIdMeta);
    }
    if (data.containsKey('event_type')) {
      context.handle(_eventTypeMeta,
          eventType.isAcceptableOrUnknown(data['event_type']!, _eventTypeMeta));
    } else if (isInserting) {
      context.missing(_eventTypeMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
          _payloadJsonMeta,
          payloadJson.isAcceptableOrUnknown(
              data['payload_json']!, _payloadJsonMeta));
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('payload_hash')) {
      context.handle(
          _payloadHashMeta,
          payloadHash.isAcceptableOrUnknown(
              data['payload_hash']!, _payloadHashMeta));
    } else if (isInserting) {
      context.missing(_payloadHashMeta);
    }
    if (data.containsKey('state')) {
      context.handle(
          _stateMeta, state.isAcceptableOrUnknown(data['state']!, _stateMeta));
    } else if (isInserting) {
      context.missing(_stateMeta);
    }
    if (data.containsKey('attempts')) {
      context.handle(_attemptsMeta,
          attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('processed_at')) {
      context.handle(
          _processedAtMeta,
          processedAt.isAcceptableOrUnknown(
              data['processed_at']!, _processedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {tenantId, sequence},
      ];
  @override
  OutboxEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OutboxEvent(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      tenantId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tenant_id'])!,
      sequence: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sequence'])!,
      aggregateType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}aggregate_type'])!,
      aggregateId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}aggregate_id'])!,
      eventType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}event_type'])!,
      payloadJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payload_json'])!,
      payloadHash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payload_hash'])!,
      state: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}state'])!,
      attempts: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}attempts'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      processedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}processed_at']),
    );
  }

  @override
  $OutboxEventsTable createAlias(String alias) {
    return $OutboxEventsTable(attachedDatabase, alias);
  }
}

class OutboxEvent extends DataClass implements Insertable<OutboxEvent> {
  final String id;
  final String tenantId;
  final int sequence;
  final String aggregateType;
  final String aggregateId;
  final String eventType;
  final String payloadJson;
  final String payloadHash;
  final String state;
  final int attempts;
  final DateTime createdAt;
  final DateTime? processedAt;
  const OutboxEvent(
      {required this.id,
      required this.tenantId,
      required this.sequence,
      required this.aggregateType,
      required this.aggregateId,
      required this.eventType,
      required this.payloadJson,
      required this.payloadHash,
      required this.state,
      required this.attempts,
      required this.createdAt,
      this.processedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['tenant_id'] = Variable<String>(tenantId);
    map['sequence'] = Variable<int>(sequence);
    map['aggregate_type'] = Variable<String>(aggregateType);
    map['aggregate_id'] = Variable<String>(aggregateId);
    map['event_type'] = Variable<String>(eventType);
    map['payload_json'] = Variable<String>(payloadJson);
    map['payload_hash'] = Variable<String>(payloadHash);
    map['state'] = Variable<String>(state);
    map['attempts'] = Variable<int>(attempts);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || processedAt != null) {
      map['processed_at'] = Variable<DateTime>(processedAt);
    }
    return map;
  }

  OutboxEventsCompanion toCompanion(bool nullToAbsent) {
    return OutboxEventsCompanion(
      id: Value(id),
      tenantId: Value(tenantId),
      sequence: Value(sequence),
      aggregateType: Value(aggregateType),
      aggregateId: Value(aggregateId),
      eventType: Value(eventType),
      payloadJson: Value(payloadJson),
      payloadHash: Value(payloadHash),
      state: Value(state),
      attempts: Value(attempts),
      createdAt: Value(createdAt),
      processedAt: processedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(processedAt),
    );
  }

  factory OutboxEvent.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OutboxEvent(
      id: serializer.fromJson<String>(json['id']),
      tenantId: serializer.fromJson<String>(json['tenantId']),
      sequence: serializer.fromJson<int>(json['sequence']),
      aggregateType: serializer.fromJson<String>(json['aggregateType']),
      aggregateId: serializer.fromJson<String>(json['aggregateId']),
      eventType: serializer.fromJson<String>(json['eventType']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      payloadHash: serializer.fromJson<String>(json['payloadHash']),
      state: serializer.fromJson<String>(json['state']),
      attempts: serializer.fromJson<int>(json['attempts']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      processedAt: serializer.fromJson<DateTime?>(json['processedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tenantId': serializer.toJson<String>(tenantId),
      'sequence': serializer.toJson<int>(sequence),
      'aggregateType': serializer.toJson<String>(aggregateType),
      'aggregateId': serializer.toJson<String>(aggregateId),
      'eventType': serializer.toJson<String>(eventType),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'payloadHash': serializer.toJson<String>(payloadHash),
      'state': serializer.toJson<String>(state),
      'attempts': serializer.toJson<int>(attempts),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'processedAt': serializer.toJson<DateTime?>(processedAt),
    };
  }

  OutboxEvent copyWith(
          {String? id,
          String? tenantId,
          int? sequence,
          String? aggregateType,
          String? aggregateId,
          String? eventType,
          String? payloadJson,
          String? payloadHash,
          String? state,
          int? attempts,
          DateTime? createdAt,
          Value<DateTime?> processedAt = const Value.absent()}) =>
      OutboxEvent(
        id: id ?? this.id,
        tenantId: tenantId ?? this.tenantId,
        sequence: sequence ?? this.sequence,
        aggregateType: aggregateType ?? this.aggregateType,
        aggregateId: aggregateId ?? this.aggregateId,
        eventType: eventType ?? this.eventType,
        payloadJson: payloadJson ?? this.payloadJson,
        payloadHash: payloadHash ?? this.payloadHash,
        state: state ?? this.state,
        attempts: attempts ?? this.attempts,
        createdAt: createdAt ?? this.createdAt,
        processedAt: processedAt.present ? processedAt.value : this.processedAt,
      );
  @override
  String toString() {
    return (StringBuffer('OutboxEvent(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('sequence: $sequence, ')
          ..write('aggregateType: $aggregateType, ')
          ..write('aggregateId: $aggregateId, ')
          ..write('eventType: $eventType, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('payloadHash: $payloadHash, ')
          ..write('state: $state, ')
          ..write('attempts: $attempts, ')
          ..write('createdAt: $createdAt, ')
          ..write('processedAt: $processedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      tenantId,
      sequence,
      aggregateType,
      aggregateId,
      eventType,
      payloadJson,
      payloadHash,
      state,
      attempts,
      createdAt,
      processedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OutboxEvent &&
          other.id == this.id &&
          other.tenantId == this.tenantId &&
          other.sequence == this.sequence &&
          other.aggregateType == this.aggregateType &&
          other.aggregateId == this.aggregateId &&
          other.eventType == this.eventType &&
          other.payloadJson == this.payloadJson &&
          other.payloadHash == this.payloadHash &&
          other.state == this.state &&
          other.attempts == this.attempts &&
          other.createdAt == this.createdAt &&
          other.processedAt == this.processedAt);
}

class OutboxEventsCompanion extends UpdateCompanion<OutboxEvent> {
  final Value<String> id;
  final Value<String> tenantId;
  final Value<int> sequence;
  final Value<String> aggregateType;
  final Value<String> aggregateId;
  final Value<String> eventType;
  final Value<String> payloadJson;
  final Value<String> payloadHash;
  final Value<String> state;
  final Value<int> attempts;
  final Value<DateTime> createdAt;
  final Value<DateTime?> processedAt;
  final Value<int> rowid;
  const OutboxEventsCompanion({
    this.id = const Value.absent(),
    this.tenantId = const Value.absent(),
    this.sequence = const Value.absent(),
    this.aggregateType = const Value.absent(),
    this.aggregateId = const Value.absent(),
    this.eventType = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.payloadHash = const Value.absent(),
    this.state = const Value.absent(),
    this.attempts = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.processedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OutboxEventsCompanion.insert({
    required String id,
    required String tenantId,
    required int sequence,
    required String aggregateType,
    required String aggregateId,
    required String eventType,
    required String payloadJson,
    required String payloadHash,
    required String state,
    this.attempts = const Value.absent(),
    required DateTime createdAt,
    this.processedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        tenantId = Value(tenantId),
        sequence = Value(sequence),
        aggregateType = Value(aggregateType),
        aggregateId = Value(aggregateId),
        eventType = Value(eventType),
        payloadJson = Value(payloadJson),
        payloadHash = Value(payloadHash),
        state = Value(state),
        createdAt = Value(createdAt);
  static Insertable<OutboxEvent> custom({
    Expression<String>? id,
    Expression<String>? tenantId,
    Expression<int>? sequence,
    Expression<String>? aggregateType,
    Expression<String>? aggregateId,
    Expression<String>? eventType,
    Expression<String>? payloadJson,
    Expression<String>? payloadHash,
    Expression<String>? state,
    Expression<int>? attempts,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? processedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tenantId != null) 'tenant_id': tenantId,
      if (sequence != null) 'sequence': sequence,
      if (aggregateType != null) 'aggregate_type': aggregateType,
      if (aggregateId != null) 'aggregate_id': aggregateId,
      if (eventType != null) 'event_type': eventType,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (payloadHash != null) 'payload_hash': payloadHash,
      if (state != null) 'state': state,
      if (attempts != null) 'attempts': attempts,
      if (createdAt != null) 'created_at': createdAt,
      if (processedAt != null) 'processed_at': processedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OutboxEventsCompanion copyWith(
      {Value<String>? id,
      Value<String>? tenantId,
      Value<int>? sequence,
      Value<String>? aggregateType,
      Value<String>? aggregateId,
      Value<String>? eventType,
      Value<String>? payloadJson,
      Value<String>? payloadHash,
      Value<String>? state,
      Value<int>? attempts,
      Value<DateTime>? createdAt,
      Value<DateTime?>? processedAt,
      Value<int>? rowid}) {
    return OutboxEventsCompanion(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      sequence: sequence ?? this.sequence,
      aggregateType: aggregateType ?? this.aggregateType,
      aggregateId: aggregateId ?? this.aggregateId,
      eventType: eventType ?? this.eventType,
      payloadJson: payloadJson ?? this.payloadJson,
      payloadHash: payloadHash ?? this.payloadHash,
      state: state ?? this.state,
      attempts: attempts ?? this.attempts,
      createdAt: createdAt ?? this.createdAt,
      processedAt: processedAt ?? this.processedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tenantId.present) {
      map['tenant_id'] = Variable<String>(tenantId.value);
    }
    if (sequence.present) {
      map['sequence'] = Variable<int>(sequence.value);
    }
    if (aggregateType.present) {
      map['aggregate_type'] = Variable<String>(aggregateType.value);
    }
    if (aggregateId.present) {
      map['aggregate_id'] = Variable<String>(aggregateId.value);
    }
    if (eventType.present) {
      map['event_type'] = Variable<String>(eventType.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (payloadHash.present) {
      map['payload_hash'] = Variable<String>(payloadHash.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (processedAt.present) {
      map['processed_at'] = Variable<DateTime>(processedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OutboxEventsCompanion(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('sequence: $sequence, ')
          ..write('aggregateType: $aggregateType, ')
          ..write('aggregateId: $aggregateId, ')
          ..write('eventType: $eventType, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('payloadHash: $payloadHash, ')
          ..write('state: $state, ')
          ..write('attempts: $attempts, ')
          ..write('createdAt: $createdAt, ')
          ..write('processedAt: $processedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AuditEventsTable extends AuditEvents
    with TableInfo<$AuditEventsTable, AuditEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuditEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tenantIdMeta =
      const VerificationMeta('tenantId');
  @override
  late final GeneratedColumn<String> tenantId = GeneratedColumn<String>(
      'tenant_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES tenants (id)'));
  static const VerificationMeta _actorIdMeta =
      const VerificationMeta('actorId');
  @override
  late final GeneratedColumn<String> actorId = GeneratedColumn<String>(
      'actor_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
      'action', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _aggregateTypeMeta =
      const VerificationMeta('aggregateType');
  @override
  late final GeneratedColumn<String> aggregateType = GeneratedColumn<String>(
      'aggregate_type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _aggregateIdMeta =
      const VerificationMeta('aggregateId');
  @override
  late final GeneratedColumn<String> aggregateId = GeneratedColumn<String>(
      'aggregate_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _payloadHashMeta =
      const VerificationMeta('payloadHash');
  @override
  late final GeneratedColumn<String> payloadHash = GeneratedColumn<String>(
      'payload_hash', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        tenantId,
        actorId,
        action,
        aggregateType,
        aggregateId,
        payloadHash,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'audit_events';
  @override
  VerificationContext validateIntegrity(Insertable<AuditEvent> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('tenant_id')) {
      context.handle(_tenantIdMeta,
          tenantId.isAcceptableOrUnknown(data['tenant_id']!, _tenantIdMeta));
    } else if (isInserting) {
      context.missing(_tenantIdMeta);
    }
    if (data.containsKey('actor_id')) {
      context.handle(_actorIdMeta,
          actorId.isAcceptableOrUnknown(data['actor_id']!, _actorIdMeta));
    } else if (isInserting) {
      context.missing(_actorIdMeta);
    }
    if (data.containsKey('action')) {
      context.handle(_actionMeta,
          action.isAcceptableOrUnknown(data['action']!, _actionMeta));
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('aggregate_type')) {
      context.handle(
          _aggregateTypeMeta,
          aggregateType.isAcceptableOrUnknown(
              data['aggregate_type']!, _aggregateTypeMeta));
    }
    if (data.containsKey('aggregate_id')) {
      context.handle(
          _aggregateIdMeta,
          aggregateId.isAcceptableOrUnknown(
              data['aggregate_id']!, _aggregateIdMeta));
    }
    if (data.containsKey('payload_hash')) {
      context.handle(
          _payloadHashMeta,
          payloadHash.isAcceptableOrUnknown(
              data['payload_hash']!, _payloadHashMeta));
    } else if (isInserting) {
      context.missing(_payloadHashMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AuditEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuditEvent(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      tenantId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tenant_id'])!,
      actorId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}actor_id'])!,
      action: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}action'])!,
      aggregateType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}aggregate_type']),
      aggregateId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}aggregate_id']),
      payloadHash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payload_hash'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $AuditEventsTable createAlias(String alias) {
    return $AuditEventsTable(attachedDatabase, alias);
  }
}

class AuditEvent extends DataClass implements Insertable<AuditEvent> {
  final String id;
  final String tenantId;
  final String actorId;
  final String action;
  final String? aggregateType;
  final String? aggregateId;
  final String payloadHash;
  final DateTime createdAt;
  const AuditEvent(
      {required this.id,
      required this.tenantId,
      required this.actorId,
      required this.action,
      this.aggregateType,
      this.aggregateId,
      required this.payloadHash,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['tenant_id'] = Variable<String>(tenantId);
    map['actor_id'] = Variable<String>(actorId);
    map['action'] = Variable<String>(action);
    if (!nullToAbsent || aggregateType != null) {
      map['aggregate_type'] = Variable<String>(aggregateType);
    }
    if (!nullToAbsent || aggregateId != null) {
      map['aggregate_id'] = Variable<String>(aggregateId);
    }
    map['payload_hash'] = Variable<String>(payloadHash);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AuditEventsCompanion toCompanion(bool nullToAbsent) {
    return AuditEventsCompanion(
      id: Value(id),
      tenantId: Value(tenantId),
      actorId: Value(actorId),
      action: Value(action),
      aggregateType: aggregateType == null && nullToAbsent
          ? const Value.absent()
          : Value(aggregateType),
      aggregateId: aggregateId == null && nullToAbsent
          ? const Value.absent()
          : Value(aggregateId),
      payloadHash: Value(payloadHash),
      createdAt: Value(createdAt),
    );
  }

  factory AuditEvent.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuditEvent(
      id: serializer.fromJson<String>(json['id']),
      tenantId: serializer.fromJson<String>(json['tenantId']),
      actorId: serializer.fromJson<String>(json['actorId']),
      action: serializer.fromJson<String>(json['action']),
      aggregateType: serializer.fromJson<String?>(json['aggregateType']),
      aggregateId: serializer.fromJson<String?>(json['aggregateId']),
      payloadHash: serializer.fromJson<String>(json['payloadHash']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tenantId': serializer.toJson<String>(tenantId),
      'actorId': serializer.toJson<String>(actorId),
      'action': serializer.toJson<String>(action),
      'aggregateType': serializer.toJson<String?>(aggregateType),
      'aggregateId': serializer.toJson<String?>(aggregateId),
      'payloadHash': serializer.toJson<String>(payloadHash),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  AuditEvent copyWith(
          {String? id,
          String? tenantId,
          String? actorId,
          String? action,
          Value<String?> aggregateType = const Value.absent(),
          Value<String?> aggregateId = const Value.absent(),
          String? payloadHash,
          DateTime? createdAt}) =>
      AuditEvent(
        id: id ?? this.id,
        tenantId: tenantId ?? this.tenantId,
        actorId: actorId ?? this.actorId,
        action: action ?? this.action,
        aggregateType:
            aggregateType.present ? aggregateType.value : this.aggregateType,
        aggregateId: aggregateId.present ? aggregateId.value : this.aggregateId,
        payloadHash: payloadHash ?? this.payloadHash,
        createdAt: createdAt ?? this.createdAt,
      );
  @override
  String toString() {
    return (StringBuffer('AuditEvent(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('actorId: $actorId, ')
          ..write('action: $action, ')
          ..write('aggregateType: $aggregateType, ')
          ..write('aggregateId: $aggregateId, ')
          ..write('payloadHash: $payloadHash, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, tenantId, actorId, action, aggregateType,
      aggregateId, payloadHash, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuditEvent &&
          other.id == this.id &&
          other.tenantId == this.tenantId &&
          other.actorId == this.actorId &&
          other.action == this.action &&
          other.aggregateType == this.aggregateType &&
          other.aggregateId == this.aggregateId &&
          other.payloadHash == this.payloadHash &&
          other.createdAt == this.createdAt);
}

class AuditEventsCompanion extends UpdateCompanion<AuditEvent> {
  final Value<String> id;
  final Value<String> tenantId;
  final Value<String> actorId;
  final Value<String> action;
  final Value<String?> aggregateType;
  final Value<String?> aggregateId;
  final Value<String> payloadHash;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const AuditEventsCompanion({
    this.id = const Value.absent(),
    this.tenantId = const Value.absent(),
    this.actorId = const Value.absent(),
    this.action = const Value.absent(),
    this.aggregateType = const Value.absent(),
    this.aggregateId = const Value.absent(),
    this.payloadHash = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AuditEventsCompanion.insert({
    required String id,
    required String tenantId,
    required String actorId,
    required String action,
    this.aggregateType = const Value.absent(),
    this.aggregateId = const Value.absent(),
    required String payloadHash,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        tenantId = Value(tenantId),
        actorId = Value(actorId),
        action = Value(action),
        payloadHash = Value(payloadHash),
        createdAt = Value(createdAt);
  static Insertable<AuditEvent> custom({
    Expression<String>? id,
    Expression<String>? tenantId,
    Expression<String>? actorId,
    Expression<String>? action,
    Expression<String>? aggregateType,
    Expression<String>? aggregateId,
    Expression<String>? payloadHash,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tenantId != null) 'tenant_id': tenantId,
      if (actorId != null) 'actor_id': actorId,
      if (action != null) 'action': action,
      if (aggregateType != null) 'aggregate_type': aggregateType,
      if (aggregateId != null) 'aggregate_id': aggregateId,
      if (payloadHash != null) 'payload_hash': payloadHash,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AuditEventsCompanion copyWith(
      {Value<String>? id,
      Value<String>? tenantId,
      Value<String>? actorId,
      Value<String>? action,
      Value<String?>? aggregateType,
      Value<String?>? aggregateId,
      Value<String>? payloadHash,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return AuditEventsCompanion(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      actorId: actorId ?? this.actorId,
      action: action ?? this.action,
      aggregateType: aggregateType ?? this.aggregateType,
      aggregateId: aggregateId ?? this.aggregateId,
      payloadHash: payloadHash ?? this.payloadHash,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tenantId.present) {
      map['tenant_id'] = Variable<String>(tenantId.value);
    }
    if (actorId.present) {
      map['actor_id'] = Variable<String>(actorId.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (aggregateType.present) {
      map['aggregate_type'] = Variable<String>(aggregateType.value);
    }
    if (aggregateId.present) {
      map['aggregate_id'] = Variable<String>(aggregateId.value);
    }
    if (payloadHash.present) {
      map['payload_hash'] = Variable<String>(payloadHash.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuditEventsCompanion(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('actorId: $actorId, ')
          ..write('action: $action, ')
          ..write('aggregateType: $aggregateType, ')
          ..write('aggregateId: $aggregateId, ')
          ..write('payloadHash: $payloadHash, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StockMovementsTable extends StockMovements
    with TableInfo<$StockMovementsTable, StockMovement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StockMovementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tenantIdMeta =
      const VerificationMeta('tenantId');
  @override
  late final GeneratedColumn<String> tenantId = GeneratedColumn<String>(
      'tenant_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES tenants (id)'));
  static const VerificationMeta _warehouseIdMeta =
      const VerificationMeta('warehouseId');
  @override
  late final GeneratedColumn<String> warehouseId = GeneratedColumn<String>(
      'warehouse_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
      'item_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sequenceMeta =
      const VerificationMeta('sequence');
  @override
  late final GeneratedColumn<int> sequence = GeneratedColumn<int>(
      'sequence', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _quantityMinorMeta =
      const VerificationMeta('quantityMinor');
  @override
  late final GeneratedColumn<int> quantityMinor = GeneratedColumn<int>(
      'quantity_minor', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _unitCostMinorMeta =
      const VerificationMeta('unitCostMinor');
  @override
  late final GeneratedColumn<int> unitCostMinor = GeneratedColumn<int>(
      'unit_cost_minor', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _movementTypeMeta =
      const VerificationMeta('movementType');
  @override
  late final GeneratedColumn<String> movementType = GeneratedColumn<String>(
      'movement_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _previousHashMeta =
      const VerificationMeta('previousHash');
  @override
  late final GeneratedColumn<String> previousHash = GeneratedColumn<String>(
      'previous_hash', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _hashMeta = const VerificationMeta('hash');
  @override
  late final GeneratedColumn<String> hash = GeneratedColumn<String>(
      'hash', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _occurredAtMeta =
      const VerificationMeta('occurredAt');
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
      'occurred_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        tenantId,
        warehouseId,
        itemId,
        sequence,
        quantityMinor,
        unitCostMinor,
        movementType,
        previousHash,
        hash,
        occurredAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stock_movements';
  @override
  VerificationContext validateIntegrity(Insertable<StockMovement> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('tenant_id')) {
      context.handle(_tenantIdMeta,
          tenantId.isAcceptableOrUnknown(data['tenant_id']!, _tenantIdMeta));
    } else if (isInserting) {
      context.missing(_tenantIdMeta);
    }
    if (data.containsKey('warehouse_id')) {
      context.handle(
          _warehouseIdMeta,
          warehouseId.isAcceptableOrUnknown(
              data['warehouse_id']!, _warehouseIdMeta));
    } else if (isInserting) {
      context.missing(_warehouseIdMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(_itemIdMeta,
          itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta));
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('sequence')) {
      context.handle(_sequenceMeta,
          sequence.isAcceptableOrUnknown(data['sequence']!, _sequenceMeta));
    } else if (isInserting) {
      context.missing(_sequenceMeta);
    }
    if (data.containsKey('quantity_minor')) {
      context.handle(
          _quantityMinorMeta,
          quantityMinor.isAcceptableOrUnknown(
              data['quantity_minor']!, _quantityMinorMeta));
    } else if (isInserting) {
      context.missing(_quantityMinorMeta);
    }
    if (data.containsKey('unit_cost_minor')) {
      context.handle(
          _unitCostMinorMeta,
          unitCostMinor.isAcceptableOrUnknown(
              data['unit_cost_minor']!, _unitCostMinorMeta));
    }
    if (data.containsKey('movement_type')) {
      context.handle(
          _movementTypeMeta,
          movementType.isAcceptableOrUnknown(
              data['movement_type']!, _movementTypeMeta));
    } else if (isInserting) {
      context.missing(_movementTypeMeta);
    }
    if (data.containsKey('previous_hash')) {
      context.handle(
          _previousHashMeta,
          previousHash.isAcceptableOrUnknown(
              data['previous_hash']!, _previousHashMeta));
    }
    if (data.containsKey('hash')) {
      context.handle(
          _hashMeta, hash.isAcceptableOrUnknown(data['hash']!, _hashMeta));
    } else if (isInserting) {
      context.missing(_hashMeta);
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
          _occurredAtMeta,
          occurredAt.isAcceptableOrUnknown(
              data['occurred_at']!, _occurredAtMeta));
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {tenantId, warehouseId, itemId, sequence},
      ];
  @override
  StockMovement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StockMovement(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      tenantId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tenant_id'])!,
      warehouseId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}warehouse_id'])!,
      itemId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}item_id'])!,
      sequence: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sequence'])!,
      quantityMinor: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity_minor'])!,
      unitCostMinor: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}unit_cost_minor']),
      movementType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}movement_type'])!,
      previousHash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}previous_hash']),
      hash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}hash'])!,
      occurredAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}occurred_at'])!,
    );
  }

  @override
  $StockMovementsTable createAlias(String alias) {
    return $StockMovementsTable(attachedDatabase, alias);
  }
}

class StockMovement extends DataClass implements Insertable<StockMovement> {
  final String id;
  final String tenantId;
  final String warehouseId;
  final String itemId;
  final int sequence;
  final int quantityMinor;
  final int? unitCostMinor;
  final String movementType;
  final String? previousHash;
  final String hash;
  final DateTime occurredAt;
  const StockMovement(
      {required this.id,
      required this.tenantId,
      required this.warehouseId,
      required this.itemId,
      required this.sequence,
      required this.quantityMinor,
      this.unitCostMinor,
      required this.movementType,
      this.previousHash,
      required this.hash,
      required this.occurredAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['tenant_id'] = Variable<String>(tenantId);
    map['warehouse_id'] = Variable<String>(warehouseId);
    map['item_id'] = Variable<String>(itemId);
    map['sequence'] = Variable<int>(sequence);
    map['quantity_minor'] = Variable<int>(quantityMinor);
    if (!nullToAbsent || unitCostMinor != null) {
      map['unit_cost_minor'] = Variable<int>(unitCostMinor);
    }
    map['movement_type'] = Variable<String>(movementType);
    if (!nullToAbsent || previousHash != null) {
      map['previous_hash'] = Variable<String>(previousHash);
    }
    map['hash'] = Variable<String>(hash);
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    return map;
  }

  StockMovementsCompanion toCompanion(bool nullToAbsent) {
    return StockMovementsCompanion(
      id: Value(id),
      tenantId: Value(tenantId),
      warehouseId: Value(warehouseId),
      itemId: Value(itemId),
      sequence: Value(sequence),
      quantityMinor: Value(quantityMinor),
      unitCostMinor: unitCostMinor == null && nullToAbsent
          ? const Value.absent()
          : Value(unitCostMinor),
      movementType: Value(movementType),
      previousHash: previousHash == null && nullToAbsent
          ? const Value.absent()
          : Value(previousHash),
      hash: Value(hash),
      occurredAt: Value(occurredAt),
    );
  }

  factory StockMovement.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StockMovement(
      id: serializer.fromJson<String>(json['id']),
      tenantId: serializer.fromJson<String>(json['tenantId']),
      warehouseId: serializer.fromJson<String>(json['warehouseId']),
      itemId: serializer.fromJson<String>(json['itemId']),
      sequence: serializer.fromJson<int>(json['sequence']),
      quantityMinor: serializer.fromJson<int>(json['quantityMinor']),
      unitCostMinor: serializer.fromJson<int?>(json['unitCostMinor']),
      movementType: serializer.fromJson<String>(json['movementType']),
      previousHash: serializer.fromJson<String?>(json['previousHash']),
      hash: serializer.fromJson<String>(json['hash']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tenantId': serializer.toJson<String>(tenantId),
      'warehouseId': serializer.toJson<String>(warehouseId),
      'itemId': serializer.toJson<String>(itemId),
      'sequence': serializer.toJson<int>(sequence),
      'quantityMinor': serializer.toJson<int>(quantityMinor),
      'unitCostMinor': serializer.toJson<int?>(unitCostMinor),
      'movementType': serializer.toJson<String>(movementType),
      'previousHash': serializer.toJson<String?>(previousHash),
      'hash': serializer.toJson<String>(hash),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
    };
  }

  StockMovement copyWith(
          {String? id,
          String? tenantId,
          String? warehouseId,
          String? itemId,
          int? sequence,
          int? quantityMinor,
          Value<int?> unitCostMinor = const Value.absent(),
          String? movementType,
          Value<String?> previousHash = const Value.absent(),
          String? hash,
          DateTime? occurredAt}) =>
      StockMovement(
        id: id ?? this.id,
        tenantId: tenantId ?? this.tenantId,
        warehouseId: warehouseId ?? this.warehouseId,
        itemId: itemId ?? this.itemId,
        sequence: sequence ?? this.sequence,
        quantityMinor: quantityMinor ?? this.quantityMinor,
        unitCostMinor:
            unitCostMinor.present ? unitCostMinor.value : this.unitCostMinor,
        movementType: movementType ?? this.movementType,
        previousHash:
            previousHash.present ? previousHash.value : this.previousHash,
        hash: hash ?? this.hash,
        occurredAt: occurredAt ?? this.occurredAt,
      );
  @override
  String toString() {
    return (StringBuffer('StockMovement(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('warehouseId: $warehouseId, ')
          ..write('itemId: $itemId, ')
          ..write('sequence: $sequence, ')
          ..write('quantityMinor: $quantityMinor, ')
          ..write('unitCostMinor: $unitCostMinor, ')
          ..write('movementType: $movementType, ')
          ..write('previousHash: $previousHash, ')
          ..write('hash: $hash, ')
          ..write('occurredAt: $occurredAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      tenantId,
      warehouseId,
      itemId,
      sequence,
      quantityMinor,
      unitCostMinor,
      movementType,
      previousHash,
      hash,
      occurredAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StockMovement &&
          other.id == this.id &&
          other.tenantId == this.tenantId &&
          other.warehouseId == this.warehouseId &&
          other.itemId == this.itemId &&
          other.sequence == this.sequence &&
          other.quantityMinor == this.quantityMinor &&
          other.unitCostMinor == this.unitCostMinor &&
          other.movementType == this.movementType &&
          other.previousHash == this.previousHash &&
          other.hash == this.hash &&
          other.occurredAt == this.occurredAt);
}

class StockMovementsCompanion extends UpdateCompanion<StockMovement> {
  final Value<String> id;
  final Value<String> tenantId;
  final Value<String> warehouseId;
  final Value<String> itemId;
  final Value<int> sequence;
  final Value<int> quantityMinor;
  final Value<int?> unitCostMinor;
  final Value<String> movementType;
  final Value<String?> previousHash;
  final Value<String> hash;
  final Value<DateTime> occurredAt;
  final Value<int> rowid;
  const StockMovementsCompanion({
    this.id = const Value.absent(),
    this.tenantId = const Value.absent(),
    this.warehouseId = const Value.absent(),
    this.itemId = const Value.absent(),
    this.sequence = const Value.absent(),
    this.quantityMinor = const Value.absent(),
    this.unitCostMinor = const Value.absent(),
    this.movementType = const Value.absent(),
    this.previousHash = const Value.absent(),
    this.hash = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StockMovementsCompanion.insert({
    required String id,
    required String tenantId,
    required String warehouseId,
    required String itemId,
    required int sequence,
    required int quantityMinor,
    this.unitCostMinor = const Value.absent(),
    required String movementType,
    this.previousHash = const Value.absent(),
    required String hash,
    required DateTime occurredAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        tenantId = Value(tenantId),
        warehouseId = Value(warehouseId),
        itemId = Value(itemId),
        sequence = Value(sequence),
        quantityMinor = Value(quantityMinor),
        movementType = Value(movementType),
        hash = Value(hash),
        occurredAt = Value(occurredAt);
  static Insertable<StockMovement> custom({
    Expression<String>? id,
    Expression<String>? tenantId,
    Expression<String>? warehouseId,
    Expression<String>? itemId,
    Expression<int>? sequence,
    Expression<int>? quantityMinor,
    Expression<int>? unitCostMinor,
    Expression<String>? movementType,
    Expression<String>? previousHash,
    Expression<String>? hash,
    Expression<DateTime>? occurredAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tenantId != null) 'tenant_id': tenantId,
      if (warehouseId != null) 'warehouse_id': warehouseId,
      if (itemId != null) 'item_id': itemId,
      if (sequence != null) 'sequence': sequence,
      if (quantityMinor != null) 'quantity_minor': quantityMinor,
      if (unitCostMinor != null) 'unit_cost_minor': unitCostMinor,
      if (movementType != null) 'movement_type': movementType,
      if (previousHash != null) 'previous_hash': previousHash,
      if (hash != null) 'hash': hash,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StockMovementsCompanion copyWith(
      {Value<String>? id,
      Value<String>? tenantId,
      Value<String>? warehouseId,
      Value<String>? itemId,
      Value<int>? sequence,
      Value<int>? quantityMinor,
      Value<int?>? unitCostMinor,
      Value<String>? movementType,
      Value<String?>? previousHash,
      Value<String>? hash,
      Value<DateTime>? occurredAt,
      Value<int>? rowid}) {
    return StockMovementsCompanion(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      warehouseId: warehouseId ?? this.warehouseId,
      itemId: itemId ?? this.itemId,
      sequence: sequence ?? this.sequence,
      quantityMinor: quantityMinor ?? this.quantityMinor,
      unitCostMinor: unitCostMinor ?? this.unitCostMinor,
      movementType: movementType ?? this.movementType,
      previousHash: previousHash ?? this.previousHash,
      hash: hash ?? this.hash,
      occurredAt: occurredAt ?? this.occurredAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tenantId.present) {
      map['tenant_id'] = Variable<String>(tenantId.value);
    }
    if (warehouseId.present) {
      map['warehouse_id'] = Variable<String>(warehouseId.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (sequence.present) {
      map['sequence'] = Variable<int>(sequence.value);
    }
    if (quantityMinor.present) {
      map['quantity_minor'] = Variable<int>(quantityMinor.value);
    }
    if (unitCostMinor.present) {
      map['unit_cost_minor'] = Variable<int>(unitCostMinor.value);
    }
    if (movementType.present) {
      map['movement_type'] = Variable<String>(movementType.value);
    }
    if (previousHash.present) {
      map['previous_hash'] = Variable<String>(previousHash.value);
    }
    if (hash.present) {
      map['hash'] = Variable<String>(hash.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StockMovementsCompanion(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('warehouseId: $warehouseId, ')
          ..write('itemId: $itemId, ')
          ..write('sequence: $sequence, ')
          ..write('quantityMinor: $quantityMinor, ')
          ..write('unitCostMinor: $unitCostMinor, ')
          ..write('movementType: $movementType, ')
          ..write('previousHash: $previousHash, ')
          ..write('hash: $hash, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  late final $TenantsTable tenants = $TenantsTable(this);
  late final $FiscalPeriodsTable fiscalPeriods = $FiscalPeriodsTable(this);
  late final $AccountsTable accounts = $AccountsTable(this);
  late final $SourceDocumentsTable sourceDocuments =
      $SourceDocumentsTable(this);
  late final $JournalEntriesTable journalEntries = $JournalEntriesTable(this);
  late final $JournalLinesTable journalLines = $JournalLinesTable(this);
  late final $IdempotencyKeysTable idempotencyKeys =
      $IdempotencyKeysTable(this);
  late final $PostingReceiptsTable postingReceipts =
      $PostingReceiptsTable(this);
  late final $OutboxEventsTable outboxEvents = $OutboxEventsTable(this);
  late final $AuditEventsTable auditEvents = $AuditEventsTable(this);
  late final $StockMovementsTable stockMovements = $StockMovementsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        tenants,
        fiscalPeriods,
        accounts,
        sourceDocuments,
        journalEntries,
        journalLines,
        idempotencyKeys,
        postingReceipts,
        outboxEvents,
        auditEvents,
        stockMovements
      ];
}
