// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $BarcodeConfigRowsTable extends BarcodeConfigRows
    with TableInfo<$BarcodeConfigRowsTable, BarcodeConfigRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BarcodeConfigRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _printerTypeMeta = const VerificationMeta(
    'printerType',
  );
  @override
  late final GeneratedColumn<int> printerType = GeneratedColumn<int>(
    'printer_type',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _columnsPerRowMeta = const VerificationMeta(
    'columnsPerRow',
  );
  @override
  late final GeneratedColumn<int> columnsPerRow = GeneratedColumn<int>(
    'columns_per_row',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _heightMeta = const VerificationMeta('height');
  @override
  late final GeneratedColumn<double> height = GeneratedColumn<double>(
    'height',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _widthMeta = const VerificationMeta('width');
  @override
  late final GeneratedColumn<double> width = GeneratedColumn<double>(
    'width',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _marginMeta = const VerificationMeta('margin');
  @override
  late final GeneratedColumn<double> margin = GeneratedColumn<double>(
    'margin',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _showItemNameMeta = const VerificationMeta(
    'showItemName',
  );
  @override
  late final GeneratedColumn<bool> showItemName = GeneratedColumn<bool>(
    'show_item_name',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("show_item_name" IN (0, 1))',
    ),
  );
  static const VerificationMeta _showPriceMeta = const VerificationMeta(
    'showPrice',
  );
  @override
  late final GeneratedColumn<bool> showPrice = GeneratedColumn<bool>(
    'show_price',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("show_price" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
        id,
        printerType,
        columnsPerRow,
        height,
        width,
        margin,
        showItemName,
        showPrice,
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'barcode_config_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<BarcodeConfigRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('printer_type')) {
      context.handle(
        _printerTypeMeta,
        printerType.isAcceptableOrUnknown(
          data['printer_type']!,
          _printerTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_printerTypeMeta);
    }
    if (data.containsKey('columns_per_row')) {
      context.handle(
        _columnsPerRowMeta,
        columnsPerRow.isAcceptableOrUnknown(
          data['columns_per_row']!,
          _columnsPerRowMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_columnsPerRowMeta);
    }
    if (data.containsKey('height')) {
      context.handle(
        _heightMeta,
        height.isAcceptableOrUnknown(data['height']!, _heightMeta),
      );
    } else if (isInserting) {
      context.missing(_heightMeta);
    }
    if (data.containsKey('width')) {
      context.handle(
        _widthMeta,
        width.isAcceptableOrUnknown(data['width']!, _widthMeta),
      );
    } else if (isInserting) {
      context.missing(_widthMeta);
    }
    if (data.containsKey('margin')) {
      context.handle(
        _marginMeta,
        margin.isAcceptableOrUnknown(data['margin']!, _marginMeta),
      );
    } else if (isInserting) {
      context.missing(_marginMeta);
    }
    if (data.containsKey('show_item_name')) {
      context.handle(
        _showItemNameMeta,
        showItemName.isAcceptableOrUnknown(
          data['show_item_name']!,
          _showItemNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_showItemNameMeta);
    }
    if (data.containsKey('show_price')) {
      context.handle(
        _showPriceMeta,
        showPrice.isAcceptableOrUnknown(data['show_price']!, _showPriceMeta),
      );
    } else if (isInserting) {
      context.missing(_showPriceMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BarcodeConfigRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BarcodeConfigRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      printerType: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}printer_type'],
      )!,
      columnsPerRow: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}columns_per_row'],
      )!,
      height: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}height'],
      )!,
      width: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}width'],
      )!,
      margin: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}margin'],
      )!,
      showItemName: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}show_item_name'],
      )!,
      showPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}show_price'],
      )!,
    );
  }

  @override
  $BarcodeConfigRowsTable createAlias(String alias) {
    return $BarcodeConfigRowsTable(attachedDatabase, alias);
  }
}

class BarcodeConfigRow extends DataClass
    implements Insertable<BarcodeConfigRow> {
  final String id;
  final int printerType;
  final int columnsPerRow;
  final double height;
  final double width;
  final double margin;
  final bool showItemName;
  final bool showPrice;
  const BarcodeConfigRow({
    required this.id,
    required this.printerType,
    required this.columnsPerRow,
    required this.height,
    required this.width,
    required this.margin,
    required this.showItemName,
    required this.showPrice,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['printer_type'] = Variable<int>(printerType);
    map['columns_per_row'] = Variable<int>(columnsPerRow);
    map['height'] = Variable<double>(height);
    map['width'] = Variable<double>(width);
    map['margin'] = Variable<double>(margin);
    map['show_item_name'] = Variable<bool>(showItemName);
    map['show_price'] = Variable<bool>(showPrice);
    return map;
  }

  BarcodeConfigRowsCompanion toCompanion(bool nullToAbsent) {
    return BarcodeConfigRowsCompanion(
      id: Value(id),
      printerType: Value(printerType),
      columnsPerRow: Value(columnsPerRow),
      height: Value(height),
      width: Value(width),
      margin: Value(margin),
      showItemName: Value(showItemName),
      showPrice: Value(showPrice),
    );
  }

  factory BarcodeConfigRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BarcodeConfigRow(
      id: serializer.fromJson<String>(json['id']),
      printerType: serializer.fromJson<int>(json['printerType']),
      columnsPerRow: serializer.fromJson<int>(json['columnsPerRow']),
      height: serializer.fromJson<double>(json['height']),
      width: serializer.fromJson<double>(json['width']),
      margin: serializer.fromJson<double>(json['margin']),
      showItemName: serializer.fromJson<bool>(json['showItemName']),
      showPrice: serializer.fromJson<bool>(json['showPrice']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'printerType': serializer.toJson<int>(printerType),
      'columnsPerRow': serializer.toJson<int>(columnsPerRow),
      'height': serializer.toJson<double>(height),
      'width': serializer.toJson<double>(width),
      'margin': serializer.toJson<double>(margin),
      'showItemName': serializer.toJson<bool>(showItemName),
      'showPrice': serializer.toJson<bool>(showPrice),
    };
  }

  BarcodeConfigRow copyWith({
    String? id,
    int? printerType,
    int? columnsPerRow,
    double? height,
    double? width,
    double? margin,
    bool? showItemName,
    bool? showPrice,
  }) =>
      BarcodeConfigRow(
        id: id ?? this.id,
        printerType: printerType ?? this.printerType,
        columnsPerRow: columnsPerRow ?? this.columnsPerRow,
        height: height ?? this.height,
        width: width ?? this.width,
        margin: margin ?? this.margin,
        showItemName: showItemName ?? this.showItemName,
        showPrice: showPrice ?? this.showPrice,
      );
  BarcodeConfigRow copyWithCompanion(BarcodeConfigRowsCompanion data) {
    return BarcodeConfigRow(
      id: data.id.present ? data.id.value : this.id,
      printerType:
          data.printerType.present ? data.printerType.value : this.printerType,
      columnsPerRow: data.columnsPerRow.present
          ? data.columnsPerRow.value
          : this.columnsPerRow,
      height: data.height.present ? data.height.value : this.height,
      width: data.width.present ? data.width.value : this.width,
      margin: data.margin.present ? data.margin.value : this.margin,
      showItemName: data.showItemName.present
          ? data.showItemName.value
          : this.showItemName,
      showPrice: data.showPrice.present ? data.showPrice.value : this.showPrice,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BarcodeConfigRow(')
          ..write('id: $id, ')
          ..write('printerType: $printerType, ')
          ..write('columnsPerRow: $columnsPerRow, ')
          ..write('height: $height, ')
          ..write('width: $width, ')
          ..write('margin: $margin, ')
          ..write('showItemName: $showItemName, ')
          ..write('showPrice: $showPrice')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
        id,
        printerType,
        columnsPerRow,
        height,
        width,
        margin,
        showItemName,
        showPrice,
      );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BarcodeConfigRow &&
          other.id == this.id &&
          other.printerType == this.printerType &&
          other.columnsPerRow == this.columnsPerRow &&
          other.height == this.height &&
          other.width == this.width &&
          other.margin == this.margin &&
          other.showItemName == this.showItemName &&
          other.showPrice == this.showPrice);
}

class BarcodeConfigRowsCompanion extends UpdateCompanion<BarcodeConfigRow> {
  final Value<String> id;
  final Value<int> printerType;
  final Value<int> columnsPerRow;
  final Value<double> height;
  final Value<double> width;
  final Value<double> margin;
  final Value<bool> showItemName;
  final Value<bool> showPrice;
  final Value<int> rowid;
  const BarcodeConfigRowsCompanion({
    this.id = const Value.absent(),
    this.printerType = const Value.absent(),
    this.columnsPerRow = const Value.absent(),
    this.height = const Value.absent(),
    this.width = const Value.absent(),
    this.margin = const Value.absent(),
    this.showItemName = const Value.absent(),
    this.showPrice = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BarcodeConfigRowsCompanion.insert({
    required String id,
    required int printerType,
    required int columnsPerRow,
    required double height,
    required double width,
    required double margin,
    required bool showItemName,
    required bool showPrice,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        printerType = Value(printerType),
        columnsPerRow = Value(columnsPerRow),
        height = Value(height),
        width = Value(width),
        margin = Value(margin),
        showItemName = Value(showItemName),
        showPrice = Value(showPrice);
  static Insertable<BarcodeConfigRow> custom({
    Expression<String>? id,
    Expression<int>? printerType,
    Expression<int>? columnsPerRow,
    Expression<double>? height,
    Expression<double>? width,
    Expression<double>? margin,
    Expression<bool>? showItemName,
    Expression<bool>? showPrice,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (printerType != null) 'printer_type': printerType,
      if (columnsPerRow != null) 'columns_per_row': columnsPerRow,
      if (height != null) 'height': height,
      if (width != null) 'width': width,
      if (margin != null) 'margin': margin,
      if (showItemName != null) 'show_item_name': showItemName,
      if (showPrice != null) 'show_price': showPrice,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BarcodeConfigRowsCompanion copyWith({
    Value<String>? id,
    Value<int>? printerType,
    Value<int>? columnsPerRow,
    Value<double>? height,
    Value<double>? width,
    Value<double>? margin,
    Value<bool>? showItemName,
    Value<bool>? showPrice,
    Value<int>? rowid,
  }) {
    return BarcodeConfigRowsCompanion(
      id: id ?? this.id,
      printerType: printerType ?? this.printerType,
      columnsPerRow: columnsPerRow ?? this.columnsPerRow,
      height: height ?? this.height,
      width: width ?? this.width,
      margin: margin ?? this.margin,
      showItemName: showItemName ?? this.showItemName,
      showPrice: showPrice ?? this.showPrice,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (printerType.present) {
      map['printer_type'] = Variable<int>(printerType.value);
    }
    if (columnsPerRow.present) {
      map['columns_per_row'] = Variable<int>(columnsPerRow.value);
    }
    if (height.present) {
      map['height'] = Variable<double>(height.value);
    }
    if (width.present) {
      map['width'] = Variable<double>(width.value);
    }
    if (margin.present) {
      map['margin'] = Variable<double>(margin.value);
    }
    if (showItemName.present) {
      map['show_item_name'] = Variable<bool>(showItemName.value);
    }
    if (showPrice.present) {
      map['show_price'] = Variable<bool>(showPrice.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BarcodeConfigRowsCompanion(')
          ..write('id: $id, ')
          ..write('printerType: $printerType, ')
          ..write('columnsPerRow: $columnsPerRow, ')
          ..write('height: $height, ')
          ..write('width: $width, ')
          ..write('margin: $margin, ')
          ..write('showItemName: $showItemName, ')
          ..write('showPrice: $showPrice, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$BarcodeDatabase extends GeneratedDatabase {
  _$BarcodeDatabase(QueryExecutor e) : super(e);
  $BarcodeDatabaseManager get managers => $BarcodeDatabaseManager(this);
  late final $BarcodeConfigRowsTable barcodeConfigRows =
      $BarcodeConfigRowsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [barcodeConfigRows];
}

typedef $$BarcodeConfigRowsTableCreateCompanionBuilder
    = BarcodeConfigRowsCompanion Function({
  required String id,
  required int printerType,
  required int columnsPerRow,
  required double height,
  required double width,
  required double margin,
  required bool showItemName,
  required bool showPrice,
  Value<int> rowid,
});
typedef $$BarcodeConfigRowsTableUpdateCompanionBuilder
    = BarcodeConfigRowsCompanion Function({
  Value<String> id,
  Value<int> printerType,
  Value<int> columnsPerRow,
  Value<double> height,
  Value<double> width,
  Value<double> margin,
  Value<bool> showItemName,
  Value<bool> showPrice,
  Value<int> rowid,
});

class $$BarcodeConfigRowsTableFilterComposer
    extends Composer<_$BarcodeDatabase, $BarcodeConfigRowsTable> {
  $$BarcodeConfigRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
        column: $table.id,
        builder: (column) => ColumnFilters(column),
      );

  ColumnFilters<int> get printerType => $composableBuilder(
        column: $table.printerType,
        builder: (column) => ColumnFilters(column),
      );

  ColumnFilters<int> get columnsPerRow => $composableBuilder(
        column: $table.columnsPerRow,
        builder: (column) => ColumnFilters(column),
      );

  ColumnFilters<double> get height => $composableBuilder(
        column: $table.height,
        builder: (column) => ColumnFilters(column),
      );

  ColumnFilters<double> get width => $composableBuilder(
        column: $table.width,
        builder: (column) => ColumnFilters(column),
      );

  ColumnFilters<double> get margin => $composableBuilder(
        column: $table.margin,
        builder: (column) => ColumnFilters(column),
      );

  ColumnFilters<bool> get showItemName => $composableBuilder(
        column: $table.showItemName,
        builder: (column) => ColumnFilters(column),
      );

  ColumnFilters<bool> get showPrice => $composableBuilder(
        column: $table.showPrice,
        builder: (column) => ColumnFilters(column),
      );
}

class $$BarcodeConfigRowsTableOrderingComposer
    extends Composer<_$BarcodeDatabase, $BarcodeConfigRowsTable> {
  $$BarcodeConfigRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
        column: $table.id,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<int> get printerType => $composableBuilder(
        column: $table.printerType,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<int> get columnsPerRow => $composableBuilder(
        column: $table.columnsPerRow,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<double> get height => $composableBuilder(
        column: $table.height,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<double> get width => $composableBuilder(
        column: $table.width,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<double> get margin => $composableBuilder(
        column: $table.margin,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<bool> get showItemName => $composableBuilder(
        column: $table.showItemName,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<bool> get showPrice => $composableBuilder(
        column: $table.showPrice,
        builder: (column) => ColumnOrderings(column),
      );
}

class $$BarcodeConfigRowsTableAnnotationComposer
    extends Composer<_$BarcodeDatabase, $BarcodeConfigRowsTable> {
  $$BarcodeConfigRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get printerType => $composableBuilder(
        column: $table.printerType,
        builder: (column) => column,
      );

  GeneratedColumn<int> get columnsPerRow => $composableBuilder(
        column: $table.columnsPerRow,
        builder: (column) => column,
      );

  GeneratedColumn<double> get height =>
      $composableBuilder(column: $table.height, builder: (column) => column);

  GeneratedColumn<double> get width =>
      $composableBuilder(column: $table.width, builder: (column) => column);

  GeneratedColumn<double> get margin =>
      $composableBuilder(column: $table.margin, builder: (column) => column);

  GeneratedColumn<bool> get showItemName => $composableBuilder(
        column: $table.showItemName,
        builder: (column) => column,
      );

  GeneratedColumn<bool> get showPrice =>
      $composableBuilder(column: $table.showPrice, builder: (column) => column);
}

class $$BarcodeConfigRowsTableTableManager extends RootTableManager<
    _$BarcodeDatabase,
    $BarcodeConfigRowsTable,
    BarcodeConfigRow,
    $$BarcodeConfigRowsTableFilterComposer,
    $$BarcodeConfigRowsTableOrderingComposer,
    $$BarcodeConfigRowsTableAnnotationComposer,
    $$BarcodeConfigRowsTableCreateCompanionBuilder,
    $$BarcodeConfigRowsTableUpdateCompanionBuilder,
    (
      BarcodeConfigRow,
      BaseReferences<_$BarcodeDatabase, $BarcodeConfigRowsTable,
          BarcodeConfigRow>,
    ),
    BarcodeConfigRow,
    PrefetchHooks Function()> {
  $$BarcodeConfigRowsTableTableManager(
    _$BarcodeDatabase db,
    $BarcodeConfigRowsTable table,
  ) : super(
          TableManagerState(
            db: db,
            table: table,
            createFilteringComposer: () =>
                $$BarcodeConfigRowsTableFilterComposer($db: db, $table: table),
            createOrderingComposer: () =>
                $$BarcodeConfigRowsTableOrderingComposer(
                    $db: db, $table: table),
            createComputedFieldComposer: () =>
                $$BarcodeConfigRowsTableAnnotationComposer(
              $db: db,
              $table: table,
            ),
            updateCompanionCallback: ({
              Value<String> id = const Value.absent(),
              Value<int> printerType = const Value.absent(),
              Value<int> columnsPerRow = const Value.absent(),
              Value<double> height = const Value.absent(),
              Value<double> width = const Value.absent(),
              Value<double> margin = const Value.absent(),
              Value<bool> showItemName = const Value.absent(),
              Value<bool> showPrice = const Value.absent(),
              Value<int> rowid = const Value.absent(),
            }) =>
                BarcodeConfigRowsCompanion(
              id: id,
              printerType: printerType,
              columnsPerRow: columnsPerRow,
              height: height,
              width: width,
              margin: margin,
              showItemName: showItemName,
              showPrice: showPrice,
              rowid: rowid,
            ),
            createCompanionCallback: ({
              required String id,
              required int printerType,
              required int columnsPerRow,
              required double height,
              required double width,
              required double margin,
              required bool showItemName,
              required bool showPrice,
              Value<int> rowid = const Value.absent(),
            }) =>
                BarcodeConfigRowsCompanion.insert(
              id: id,
              printerType: printerType,
              columnsPerRow: columnsPerRow,
              height: height,
              width: width,
              margin: margin,
              showItemName: showItemName,
              showPrice: showPrice,
              rowid: rowid,
            ),
            withReferenceMapper: (p0) => p0
                .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
                .toList(),
            prefetchHooksCallback: null,
          ),
        );
}

typedef $$BarcodeConfigRowsTableProcessedTableManager = ProcessedTableManager<
    _$BarcodeDatabase,
    $BarcodeConfigRowsTable,
    BarcodeConfigRow,
    $$BarcodeConfigRowsTableFilterComposer,
    $$BarcodeConfigRowsTableOrderingComposer,
    $$BarcodeConfigRowsTableAnnotationComposer,
    $$BarcodeConfigRowsTableCreateCompanionBuilder,
    $$BarcodeConfigRowsTableUpdateCompanionBuilder,
    (
      BarcodeConfigRow,
      BaseReferences<_$BarcodeDatabase, $BarcodeConfigRowsTable,
          BarcodeConfigRow>,
    ),
    BarcodeConfigRow,
    PrefetchHooks Function()>;

class $BarcodeDatabaseManager {
  final _$BarcodeDatabase _db;
  $BarcodeDatabaseManager(this._db);
  $$BarcodeConfigRowsTableTableManager get barcodeConfigRows =>
      $$BarcodeConfigRowsTableTableManager(_db, _db.barcodeConfigRows);
}
