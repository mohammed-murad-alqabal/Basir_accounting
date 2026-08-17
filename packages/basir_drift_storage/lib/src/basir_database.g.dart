// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'basir_database.dart';

// ignore_for_file: type=lint
class $LocalMetadataTable extends LocalMetadata
    with TableInfo<$LocalMetadataTable, LocalMetadataData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalMetadataTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueJsonMeta =
      const VerificationMeta('valueJson');
  @override
  late final GeneratedColumn<String> valueJson = GeneratedColumn<String>(
      'value_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [key, valueJson, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_metadata';
  @override
  VerificationContext validateIntegrity(Insertable<LocalMetadataData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value_json')) {
      context.handle(_valueJsonMeta,
          valueJson.isAcceptableOrUnknown(data['value_json']!, _valueJsonMeta));
    } else if (isInserting) {
      context.missing(_valueJsonMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  LocalMetadataData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalMetadataData(
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      valueJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value_json'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $LocalMetadataTable createAlias(String alias) {
    return $LocalMetadataTable(attachedDatabase, alias);
  }
}

class LocalMetadataData extends DataClass
    implements Insertable<LocalMetadataData> {
  final String key;
  final String valueJson;
  final DateTime updatedAt;
  const LocalMetadataData(
      {required this.key, required this.valueJson, required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value_json'] = Variable<String>(valueJson);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  LocalMetadataCompanion toCompanion(bool nullToAbsent) {
    return LocalMetadataCompanion(
      key: Value(key),
      valueJson: Value(valueJson),
      updatedAt: Value(updatedAt),
    );
  }

  factory LocalMetadataData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalMetadataData(
      key: serializer.fromJson<String>(json['key']),
      valueJson: serializer.fromJson<String>(json['valueJson']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'valueJson': serializer.toJson<String>(valueJson),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  LocalMetadataData copyWith(
          {String? key, String? valueJson, DateTime? updatedAt}) =>
      LocalMetadataData(
        key: key ?? this.key,
        valueJson: valueJson ?? this.valueJson,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  LocalMetadataData copyWithCompanion(LocalMetadataCompanion data) {
    return LocalMetadataData(
      key: data.key.present ? data.key.value : this.key,
      valueJson: data.valueJson.present ? data.valueJson.value : this.valueJson,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalMetadataData(')
          ..write('key: $key, ')
          ..write('valueJson: $valueJson, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, valueJson, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalMetadataData &&
          other.key == this.key &&
          other.valueJson == this.valueJson &&
          other.updatedAt == this.updatedAt);
}

class LocalMetadataCompanion extends UpdateCompanion<LocalMetadataData> {
  final Value<String> key;
  final Value<String> valueJson;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const LocalMetadataCompanion({
    this.key = const Value.absent(),
    this.valueJson = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalMetadataCompanion.insert({
    required String key,
    required String valueJson,
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : key = Value(key),
        valueJson = Value(valueJson);
  static Insertable<LocalMetadataData> custom({
    Expression<String>? key,
    Expression<String>? valueJson,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (valueJson != null) 'value_json': valueJson,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalMetadataCompanion copyWith(
      {Value<String>? key,
      Value<String>? valueJson,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return LocalMetadataCompanion(
      key: key ?? this.key,
      valueJson: valueJson ?? this.valueJson,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (valueJson.present) {
      map['value_json'] = Variable<String>(valueJson.value);
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
    return (StringBuffer('LocalMetadataCompanion(')
          ..write('key: $key, ')
          ..write('valueJson: $valueJson, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BarcodeConfigsTable extends BarcodeConfigs
    with TableInfo<$BarcodeConfigsTable, BarcodeConfig> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BarcodeConfigsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _printerTypeMeta =
      const VerificationMeta('printerType');
  @override
  late final GeneratedColumn<String> printerType = GeneratedColumn<String>(
      'printer_type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('thermal'));
  static const VerificationMeta _columnsPerRowMeta =
      const VerificationMeta('columnsPerRow');
  @override
  late final GeneratedColumn<int> columnsPerRow = GeneratedColumn<int>(
      'columns_per_row', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _heightMmMeta =
      const VerificationMeta('heightMm');
  @override
  late final GeneratedColumn<double> heightMm = GeneratedColumn<double>(
      'height_mm', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant<double>(30));
  static const VerificationMeta _widthMmMeta =
      const VerificationMeta('widthMm');
  @override
  late final GeneratedColumn<double> widthMm = GeneratedColumn<double>(
      'width_mm', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant<double>(50));
  static const VerificationMeta _marginMmMeta =
      const VerificationMeta('marginMm');
  @override
  late final GeneratedColumn<double> marginMm = GeneratedColumn<double>(
      'margin_mm', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant<double>(2));
  static const VerificationMeta _showItemNameMeta =
      const VerificationMeta('showItemName');
  @override
  late final GeneratedColumn<bool> showItemName = GeneratedColumn<bool>(
      'show_item_name', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("show_item_name" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _showPriceMeta =
      const VerificationMeta('showPrice');
  @override
  late final GeneratedColumn<bool> showPrice = GeneratedColumn<bool>(
      'show_price', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("show_price" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        printerType,
        columnsPerRow,
        heightMm,
        widthMm,
        marginMm,
        showItemName,
        showPrice,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'barcode_configs';
  @override
  VerificationContext validateIntegrity(Insertable<BarcodeConfig> instance,
      {bool isInserting = false}) {
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
              data['printer_type']!, _printerTypeMeta));
    }
    if (data.containsKey('columns_per_row')) {
      context.handle(
          _columnsPerRowMeta,
          columnsPerRow.isAcceptableOrUnknown(
              data['columns_per_row']!, _columnsPerRowMeta));
    }
    if (data.containsKey('height_mm')) {
      context.handle(_heightMmMeta,
          heightMm.isAcceptableOrUnknown(data['height_mm']!, _heightMmMeta));
    }
    if (data.containsKey('width_mm')) {
      context.handle(_widthMmMeta,
          widthMm.isAcceptableOrUnknown(data['width_mm']!, _widthMmMeta));
    }
    if (data.containsKey('margin_mm')) {
      context.handle(_marginMmMeta,
          marginMm.isAcceptableOrUnknown(data['margin_mm']!, _marginMmMeta));
    }
    if (data.containsKey('show_item_name')) {
      context.handle(
          _showItemNameMeta,
          showItemName.isAcceptableOrUnknown(
              data['show_item_name']!, _showItemNameMeta));
    }
    if (data.containsKey('show_price')) {
      context.handle(_showPriceMeta,
          showPrice.isAcceptableOrUnknown(data['show_price']!, _showPriceMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BarcodeConfig map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BarcodeConfig(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      printerType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}printer_type'])!,
      columnsPerRow: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}columns_per_row'])!,
      heightMm: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}height_mm'])!,
      widthMm: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}width_mm'])!,
      marginMm: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}margin_mm'])!,
      showItemName: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}show_item_name'])!,
      showPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}show_price'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $BarcodeConfigsTable createAlias(String alias) {
    return $BarcodeConfigsTable(attachedDatabase, alias);
  }
}

class BarcodeConfig extends DataClass implements Insertable<BarcodeConfig> {
  final String id;
  final String printerType;
  final int columnsPerRow;
  final double heightMm;
  final double widthMm;
  final double marginMm;
  final bool showItemName;
  final bool showPrice;
  final DateTime createdAt;
  final DateTime updatedAt;
  const BarcodeConfig(
      {required this.id,
      required this.printerType,
      required this.columnsPerRow,
      required this.heightMm,
      required this.widthMm,
      required this.marginMm,
      required this.showItemName,
      required this.showPrice,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['printer_type'] = Variable<String>(printerType);
    map['columns_per_row'] = Variable<int>(columnsPerRow);
    map['height_mm'] = Variable<double>(heightMm);
    map['width_mm'] = Variable<double>(widthMm);
    map['margin_mm'] = Variable<double>(marginMm);
    map['show_item_name'] = Variable<bool>(showItemName);
    map['show_price'] = Variable<bool>(showPrice);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  BarcodeConfigsCompanion toCompanion(bool nullToAbsent) {
    return BarcodeConfigsCompanion(
      id: Value(id),
      printerType: Value(printerType),
      columnsPerRow: Value(columnsPerRow),
      heightMm: Value(heightMm),
      widthMm: Value(widthMm),
      marginMm: Value(marginMm),
      showItemName: Value(showItemName),
      showPrice: Value(showPrice),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory BarcodeConfig.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BarcodeConfig(
      id: serializer.fromJson<String>(json['id']),
      printerType: serializer.fromJson<String>(json['printerType']),
      columnsPerRow: serializer.fromJson<int>(json['columnsPerRow']),
      heightMm: serializer.fromJson<double>(json['heightMm']),
      widthMm: serializer.fromJson<double>(json['widthMm']),
      marginMm: serializer.fromJson<double>(json['marginMm']),
      showItemName: serializer.fromJson<bool>(json['showItemName']),
      showPrice: serializer.fromJson<bool>(json['showPrice']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'printerType': serializer.toJson<String>(printerType),
      'columnsPerRow': serializer.toJson<int>(columnsPerRow),
      'heightMm': serializer.toJson<double>(heightMm),
      'widthMm': serializer.toJson<double>(widthMm),
      'marginMm': serializer.toJson<double>(marginMm),
      'showItemName': serializer.toJson<bool>(showItemName),
      'showPrice': serializer.toJson<bool>(showPrice),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  BarcodeConfig copyWith(
          {String? id,
          String? printerType,
          int? columnsPerRow,
          double? heightMm,
          double? widthMm,
          double? marginMm,
          bool? showItemName,
          bool? showPrice,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      BarcodeConfig(
        id: id ?? this.id,
        printerType: printerType ?? this.printerType,
        columnsPerRow: columnsPerRow ?? this.columnsPerRow,
        heightMm: heightMm ?? this.heightMm,
        widthMm: widthMm ?? this.widthMm,
        marginMm: marginMm ?? this.marginMm,
        showItemName: showItemName ?? this.showItemName,
        showPrice: showPrice ?? this.showPrice,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  BarcodeConfig copyWithCompanion(BarcodeConfigsCompanion data) {
    return BarcodeConfig(
      id: data.id.present ? data.id.value : this.id,
      printerType:
          data.printerType.present ? data.printerType.value : this.printerType,
      columnsPerRow: data.columnsPerRow.present
          ? data.columnsPerRow.value
          : this.columnsPerRow,
      heightMm: data.heightMm.present ? data.heightMm.value : this.heightMm,
      widthMm: data.widthMm.present ? data.widthMm.value : this.widthMm,
      marginMm: data.marginMm.present ? data.marginMm.value : this.marginMm,
      showItemName: data.showItemName.present
          ? data.showItemName.value
          : this.showItemName,
      showPrice: data.showPrice.present ? data.showPrice.value : this.showPrice,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BarcodeConfig(')
          ..write('id: $id, ')
          ..write('printerType: $printerType, ')
          ..write('columnsPerRow: $columnsPerRow, ')
          ..write('heightMm: $heightMm, ')
          ..write('widthMm: $widthMm, ')
          ..write('marginMm: $marginMm, ')
          ..write('showItemName: $showItemName, ')
          ..write('showPrice: $showPrice, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, printerType, columnsPerRow, heightMm,
      widthMm, marginMm, showItemName, showPrice, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BarcodeConfig &&
          other.id == this.id &&
          other.printerType == this.printerType &&
          other.columnsPerRow == this.columnsPerRow &&
          other.heightMm == this.heightMm &&
          other.widthMm == this.widthMm &&
          other.marginMm == this.marginMm &&
          other.showItemName == this.showItemName &&
          other.showPrice == this.showPrice &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class BarcodeConfigsCompanion extends UpdateCompanion<BarcodeConfig> {
  final Value<String> id;
  final Value<String> printerType;
  final Value<int> columnsPerRow;
  final Value<double> heightMm;
  final Value<double> widthMm;
  final Value<double> marginMm;
  final Value<bool> showItemName;
  final Value<bool> showPrice;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const BarcodeConfigsCompanion({
    this.id = const Value.absent(),
    this.printerType = const Value.absent(),
    this.columnsPerRow = const Value.absent(),
    this.heightMm = const Value.absent(),
    this.widthMm = const Value.absent(),
    this.marginMm = const Value.absent(),
    this.showItemName = const Value.absent(),
    this.showPrice = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BarcodeConfigsCompanion.insert({
    required String id,
    this.printerType = const Value.absent(),
    this.columnsPerRow = const Value.absent(),
    this.heightMm = const Value.absent(),
    this.widthMm = const Value.absent(),
    this.marginMm = const Value.absent(),
    this.showItemName = const Value.absent(),
    this.showPrice = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<BarcodeConfig> custom({
    Expression<String>? id,
    Expression<String>? printerType,
    Expression<int>? columnsPerRow,
    Expression<double>? heightMm,
    Expression<double>? widthMm,
    Expression<double>? marginMm,
    Expression<bool>? showItemName,
    Expression<bool>? showPrice,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (printerType != null) 'printer_type': printerType,
      if (columnsPerRow != null) 'columns_per_row': columnsPerRow,
      if (heightMm != null) 'height_mm': heightMm,
      if (widthMm != null) 'width_mm': widthMm,
      if (marginMm != null) 'margin_mm': marginMm,
      if (showItemName != null) 'show_item_name': showItemName,
      if (showPrice != null) 'show_price': showPrice,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BarcodeConfigsCompanion copyWith(
      {Value<String>? id,
      Value<String>? printerType,
      Value<int>? columnsPerRow,
      Value<double>? heightMm,
      Value<double>? widthMm,
      Value<double>? marginMm,
      Value<bool>? showItemName,
      Value<bool>? showPrice,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return BarcodeConfigsCompanion(
      id: id ?? this.id,
      printerType: printerType ?? this.printerType,
      columnsPerRow: columnsPerRow ?? this.columnsPerRow,
      heightMm: heightMm ?? this.heightMm,
      widthMm: widthMm ?? this.widthMm,
      marginMm: marginMm ?? this.marginMm,
      showItemName: showItemName ?? this.showItemName,
      showPrice: showPrice ?? this.showPrice,
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
    if (printerType.present) {
      map['printer_type'] = Variable<String>(printerType.value);
    }
    if (columnsPerRow.present) {
      map['columns_per_row'] = Variable<int>(columnsPerRow.value);
    }
    if (heightMm.present) {
      map['height_mm'] = Variable<double>(heightMm.value);
    }
    if (widthMm.present) {
      map['width_mm'] = Variable<double>(widthMm.value);
    }
    if (marginMm.present) {
      map['margin_mm'] = Variable<double>(marginMm.value);
    }
    if (showItemName.present) {
      map['show_item_name'] = Variable<bool>(showItemName.value);
    }
    if (showPrice.present) {
      map['show_price'] = Variable<bool>(showPrice.value);
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
    return (StringBuffer('BarcodeConfigsCompanion(')
          ..write('id: $id, ')
          ..write('printerType: $printerType, ')
          ..write('columnsPerRow: $columnsPerRow, ')
          ..write('heightMm: $heightMm, ')
          ..write('widthMm: $widthMm, ')
          ..write('marginMm: $marginMm, ')
          ..write('showItemName: $showItemName, ')
          ..write('showPrice: $showPrice, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MarketPricesTable extends MarketPrices
    with TableInfo<$MarketPricesTable, MarketPrice> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MarketPricesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
      'item_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
      'price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _asOfDateMeta =
      const VerificationMeta('asOfDate');
  @override
  late final GeneratedColumn<DateTime> asOfDate = GeneratedColumn<DateTime>(
      'as_of_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, itemId, price, asOfDate, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'market_prices';
  @override
  VerificationContext validateIntegrity(Insertable<MarketPrice> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(_itemIdMeta,
          itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta));
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('as_of_date')) {
      context.handle(_asOfDateMeta,
          asOfDate.isAcceptableOrUnknown(data['as_of_date']!, _asOfDateMeta));
    } else if (isInserting) {
      context.missing(_asOfDateMeta);
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
  MarketPrice map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MarketPrice(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      itemId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}item_id'])!,
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price'])!,
      asOfDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}as_of_date'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $MarketPricesTable createAlias(String alias) {
    return $MarketPricesTable(attachedDatabase, alias);
  }
}

class MarketPrice extends DataClass implements Insertable<MarketPrice> {
  final String id;
  final String itemId;
  final double price;
  final DateTime asOfDate;
  final DateTime createdAt;
  const MarketPrice(
      {required this.id,
      required this.itemId,
      required this.price,
      required this.asOfDate,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['item_id'] = Variable<String>(itemId);
    map['price'] = Variable<double>(price);
    map['as_of_date'] = Variable<DateTime>(asOfDate);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  MarketPricesCompanion toCompanion(bool nullToAbsent) {
    return MarketPricesCompanion(
      id: Value(id),
      itemId: Value(itemId),
      price: Value(price),
      asOfDate: Value(asOfDate),
      createdAt: Value(createdAt),
    );
  }

  factory MarketPrice.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MarketPrice(
      id: serializer.fromJson<String>(json['id']),
      itemId: serializer.fromJson<String>(json['itemId']),
      price: serializer.fromJson<double>(json['price']),
      asOfDate: serializer.fromJson<DateTime>(json['asOfDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'itemId': serializer.toJson<String>(itemId),
      'price': serializer.toJson<double>(price),
      'asOfDate': serializer.toJson<DateTime>(asOfDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  MarketPrice copyWith(
          {String? id,
          String? itemId,
          double? price,
          DateTime? asOfDate,
          DateTime? createdAt}) =>
      MarketPrice(
        id: id ?? this.id,
        itemId: itemId ?? this.itemId,
        price: price ?? this.price,
        asOfDate: asOfDate ?? this.asOfDate,
        createdAt: createdAt ?? this.createdAt,
      );
  MarketPrice copyWithCompanion(MarketPricesCompanion data) {
    return MarketPrice(
      id: data.id.present ? data.id.value : this.id,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      price: data.price.present ? data.price.value : this.price,
      asOfDate: data.asOfDate.present ? data.asOfDate.value : this.asOfDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MarketPrice(')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('price: $price, ')
          ..write('asOfDate: $asOfDate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, itemId, price, asOfDate, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MarketPrice &&
          other.id == this.id &&
          other.itemId == this.itemId &&
          other.price == this.price &&
          other.asOfDate == this.asOfDate &&
          other.createdAt == this.createdAt);
}

class MarketPricesCompanion extends UpdateCompanion<MarketPrice> {
  final Value<String> id;
  final Value<String> itemId;
  final Value<double> price;
  final Value<DateTime> asOfDate;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const MarketPricesCompanion({
    this.id = const Value.absent(),
    this.itemId = const Value.absent(),
    this.price = const Value.absent(),
    this.asOfDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MarketPricesCompanion.insert({
    required String id,
    required String itemId,
    required double price,
    required DateTime asOfDate,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        itemId = Value(itemId),
        price = Value(price),
        asOfDate = Value(asOfDate),
        createdAt = Value(createdAt);
  static Insertable<MarketPrice> custom({
    Expression<String>? id,
    Expression<String>? itemId,
    Expression<double>? price,
    Expression<DateTime>? asOfDate,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (itemId != null) 'item_id': itemId,
      if (price != null) 'price': price,
      if (asOfDate != null) 'as_of_date': asOfDate,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MarketPricesCompanion copyWith(
      {Value<String>? id,
      Value<String>? itemId,
      Value<double>? price,
      Value<DateTime>? asOfDate,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return MarketPricesCompanion(
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      price: price ?? this.price,
      asOfDate: asOfDate ?? this.asOfDate,
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
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (asOfDate.present) {
      map['as_of_date'] = Variable<DateTime>(asOfDate.value);
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
    return (StringBuffer('MarketPricesCompanion(')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('price: $price, ')
          ..write('asOfDate: $asOfDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProfilesTable extends Profiles with TableInfo<$ProfilesTable, Profile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _scopeKeyMeta =
      const VerificationMeta('scopeKey');
  @override
  late final GeneratedColumn<String> scopeKey = GeneratedColumn<String>(
      'scope_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _displayNameMeta =
      const VerificationMeta('displayName');
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
      'display_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _avatarUrlMeta =
      const VerificationMeta('avatarUrl');
  @override
  late final GeneratedColumn<String> avatarUrl = GeneratedColumn<String>(
      'avatar_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _phoneNumberMeta =
      const VerificationMeta('phoneNumber');
  @override
  late final GeneratedColumn<String> phoneNumber = GeneratedColumn<String>(
      'phone_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('synced'));
  static const VerificationMeta _serverUpdatedAtMeta =
      const VerificationMeta('serverUpdatedAt');
  @override
  late final GeneratedColumn<DateTime> serverUpdatedAt =
      GeneratedColumn<DateTime>('server_updated_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        scopeKey,
        id,
        email,
        displayName,
        avatarUrl,
        phoneNumber,
        userId,
        syncStatus,
        serverUpdatedAt,
        isDeleted
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'profiles';
  @override
  VerificationContext validateIntegrity(Insertable<Profile> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('scope_key')) {
      context.handle(_scopeKeyMeta,
          scopeKey.isAcceptableOrUnknown(data['scope_key']!, _scopeKeyMeta));
    } else if (isInserting) {
      context.missing(_scopeKeyMeta);
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
          _displayNameMeta,
          displayName.isAcceptableOrUnknown(
              data['display_name']!, _displayNameMeta));
    }
    if (data.containsKey('avatar_url')) {
      context.handle(_avatarUrlMeta,
          avatarUrl.isAcceptableOrUnknown(data['avatar_url']!, _avatarUrlMeta));
    }
    if (data.containsKey('phone_number')) {
      context.handle(
          _phoneNumberMeta,
          phoneNumber.isAcceptableOrUnknown(
              data['phone_number']!, _phoneNumberMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    if (data.containsKey('server_updated_at')) {
      context.handle(
          _serverUpdatedAtMeta,
          serverUpdatedAt.isAcceptableOrUnknown(
              data['server_updated_at']!, _serverUpdatedAtMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {scopeKey};
  @override
  Profile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Profile(
      scopeKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}scope_key'])!,
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email'])!,
      displayName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}display_name']),
      avatarUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}avatar_url']),
      phoneNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone_number']),
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id']),
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
      serverUpdatedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}server_updated_at']),
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
    );
  }

  @override
  $ProfilesTable createAlias(String alias) {
    return $ProfilesTable(attachedDatabase, alias);
  }
}

class Profile extends DataClass implements Insertable<Profile> {
  final String scopeKey;
  final String id;
  final String email;
  final String? displayName;
  final String? avatarUrl;
  final String? phoneNumber;
  final String? userId;
  final String syncStatus;
  final DateTime? serverUpdatedAt;
  final bool isDeleted;
  const Profile(
      {required this.scopeKey,
      required this.id,
      required this.email,
      this.displayName,
      this.avatarUrl,
      this.phoneNumber,
      this.userId,
      required this.syncStatus,
      this.serverUpdatedAt,
      required this.isDeleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['scope_key'] = Variable<String>(scopeKey);
    map['id'] = Variable<String>(id);
    map['email'] = Variable<String>(email);
    if (!nullToAbsent || displayName != null) {
      map['display_name'] = Variable<String>(displayName);
    }
    if (!nullToAbsent || avatarUrl != null) {
      map['avatar_url'] = Variable<String>(avatarUrl);
    }
    if (!nullToAbsent || phoneNumber != null) {
      map['phone_number'] = Variable<String>(phoneNumber);
    }
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || serverUpdatedAt != null) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt);
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  ProfilesCompanion toCompanion(bool nullToAbsent) {
    return ProfilesCompanion(
      scopeKey: Value(scopeKey),
      id: Value(id),
      email: Value(email),
      displayName: displayName == null && nullToAbsent
          ? const Value.absent()
          : Value(displayName),
      avatarUrl: avatarUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarUrl),
      phoneNumber: phoneNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(phoneNumber),
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
      syncStatus: Value(syncStatus),
      serverUpdatedAt: serverUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(serverUpdatedAt),
      isDeleted: Value(isDeleted),
    );
  }

  factory Profile.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Profile(
      scopeKey: serializer.fromJson<String>(json['scopeKey']),
      id: serializer.fromJson<String>(json['id']),
      email: serializer.fromJson<String>(json['email']),
      displayName: serializer.fromJson<String?>(json['displayName']),
      avatarUrl: serializer.fromJson<String?>(json['avatarUrl']),
      phoneNumber: serializer.fromJson<String?>(json['phoneNumber']),
      userId: serializer.fromJson<String?>(json['userId']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      serverUpdatedAt: serializer.fromJson<DateTime?>(json['serverUpdatedAt']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'scopeKey': serializer.toJson<String>(scopeKey),
      'id': serializer.toJson<String>(id),
      'email': serializer.toJson<String>(email),
      'displayName': serializer.toJson<String?>(displayName),
      'avatarUrl': serializer.toJson<String?>(avatarUrl),
      'phoneNumber': serializer.toJson<String?>(phoneNumber),
      'userId': serializer.toJson<String?>(userId),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'serverUpdatedAt': serializer.toJson<DateTime?>(serverUpdatedAt),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  Profile copyWith(
          {String? scopeKey,
          String? id,
          String? email,
          Value<String?> displayName = const Value.absent(),
          Value<String?> avatarUrl = const Value.absent(),
          Value<String?> phoneNumber = const Value.absent(),
          Value<String?> userId = const Value.absent(),
          String? syncStatus,
          Value<DateTime?> serverUpdatedAt = const Value.absent(),
          bool? isDeleted}) =>
      Profile(
        scopeKey: scopeKey ?? this.scopeKey,
        id: id ?? this.id,
        email: email ?? this.email,
        displayName: displayName.present ? displayName.value : this.displayName,
        avatarUrl: avatarUrl.present ? avatarUrl.value : this.avatarUrl,
        phoneNumber: phoneNumber.present ? phoneNumber.value : this.phoneNumber,
        userId: userId.present ? userId.value : this.userId,
        syncStatus: syncStatus ?? this.syncStatus,
        serverUpdatedAt: serverUpdatedAt.present
            ? serverUpdatedAt.value
            : this.serverUpdatedAt,
        isDeleted: isDeleted ?? this.isDeleted,
      );
  Profile copyWithCompanion(ProfilesCompanion data) {
    return Profile(
      scopeKey: data.scopeKey.present ? data.scopeKey.value : this.scopeKey,
      id: data.id.present ? data.id.value : this.id,
      email: data.email.present ? data.email.value : this.email,
      displayName:
          data.displayName.present ? data.displayName.value : this.displayName,
      avatarUrl: data.avatarUrl.present ? data.avatarUrl.value : this.avatarUrl,
      phoneNumber:
          data.phoneNumber.present ? data.phoneNumber.value : this.phoneNumber,
      userId: data.userId.present ? data.userId.value : this.userId,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      serverUpdatedAt: data.serverUpdatedAt.present
          ? data.serverUpdatedAt.value
          : this.serverUpdatedAt,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Profile(')
          ..write('scopeKey: $scopeKey, ')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('displayName: $displayName, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('userId: $userId, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(scopeKey, id, email, displayName, avatarUrl,
      phoneNumber, userId, syncStatus, serverUpdatedAt, isDeleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Profile &&
          other.scopeKey == this.scopeKey &&
          other.id == this.id &&
          other.email == this.email &&
          other.displayName == this.displayName &&
          other.avatarUrl == this.avatarUrl &&
          other.phoneNumber == this.phoneNumber &&
          other.userId == this.userId &&
          other.syncStatus == this.syncStatus &&
          other.serverUpdatedAt == this.serverUpdatedAt &&
          other.isDeleted == this.isDeleted);
}

class ProfilesCompanion extends UpdateCompanion<Profile> {
  final Value<String> scopeKey;
  final Value<String> id;
  final Value<String> email;
  final Value<String?> displayName;
  final Value<String?> avatarUrl;
  final Value<String?> phoneNumber;
  final Value<String?> userId;
  final Value<String> syncStatus;
  final Value<DateTime?> serverUpdatedAt;
  final Value<bool> isDeleted;
  final Value<int> rowid;
  const ProfilesCompanion({
    this.scopeKey = const Value.absent(),
    this.id = const Value.absent(),
    this.email = const Value.absent(),
    this.displayName = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.userId = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProfilesCompanion.insert({
    required String scopeKey,
    required String id,
    required String email,
    this.displayName = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.userId = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : scopeKey = Value(scopeKey),
        id = Value(id),
        email = Value(email);
  static Insertable<Profile> custom({
    Expression<String>? scopeKey,
    Expression<String>? id,
    Expression<String>? email,
    Expression<String>? displayName,
    Expression<String>? avatarUrl,
    Expression<String>? phoneNumber,
    Expression<String>? userId,
    Expression<String>? syncStatus,
    Expression<DateTime>? serverUpdatedAt,
    Expression<bool>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (scopeKey != null) 'scope_key': scopeKey,
      if (id != null) 'id': id,
      if (email != null) 'email': email,
      if (displayName != null) 'display_name': displayName,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (userId != null) 'user_id': userId,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (serverUpdatedAt != null) 'server_updated_at': serverUpdatedAt,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProfilesCompanion copyWith(
      {Value<String>? scopeKey,
      Value<String>? id,
      Value<String>? email,
      Value<String?>? displayName,
      Value<String?>? avatarUrl,
      Value<String?>? phoneNumber,
      Value<String?>? userId,
      Value<String>? syncStatus,
      Value<DateTime?>? serverUpdatedAt,
      Value<bool>? isDeleted,
      Value<int>? rowid}) {
    return ProfilesCompanion(
      scopeKey: scopeKey ?? this.scopeKey,
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      userId: userId ?? this.userId,
      syncStatus: syncStatus ?? this.syncStatus,
      serverUpdatedAt: serverUpdatedAt ?? this.serverUpdatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (scopeKey.present) {
      map['scope_key'] = Variable<String>(scopeKey.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (avatarUrl.present) {
      map['avatar_url'] = Variable<String>(avatarUrl.value);
    }
    if (phoneNumber.present) {
      map['phone_number'] = Variable<String>(phoneNumber.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (serverUpdatedAt.present) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProfilesCompanion(')
          ..write('scopeKey: $scopeKey, ')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('displayName: $displayName, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('userId: $userId, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BusinessSettingsTable extends BusinessSettings
    with TableInfo<$BusinessSettingsTable, BusinessSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BusinessSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _scopeKeyMeta =
      const VerificationMeta('scopeKey');
  @override
  late final GeneratedColumn<String> scopeKey = GeneratedColumn<String>(
      'scope_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _companyNameMeta =
      const VerificationMeta('companyName');
  @override
  late final GeneratedColumn<String> companyName = GeneratedColumn<String>(
      'company_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _taxNumberMeta =
      const VerificationMeta('taxNumber');
  @override
  late final GeneratedColumn<String> taxNumber = GeneratedColumn<String>(
      'tax_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _logoUrlMeta =
      const VerificationMeta('logoUrl');
  @override
  late final GeneratedColumn<String> logoUrl = GeneratedColumn<String>(
      'logo_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _defaultTaxRateMeta =
      const VerificationMeta('defaultTaxRate');
  @override
  late final GeneratedColumn<double> defaultTaxRate = GeneratedColumn<double>(
      'default_tax_rate', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _currencyCodeMeta =
      const VerificationMeta('currencyCode');
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
      'currency_code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _currencySymbolMeta =
      const VerificationMeta('currencySymbol');
  @override
  late final GeneratedColumn<String> currencySymbol = GeneratedColumn<String>(
      'currency_symbol', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('synced'));
  static const VerificationMeta _serverUpdatedAtMeta =
      const VerificationMeta('serverUpdatedAt');
  @override
  late final GeneratedColumn<DateTime> serverUpdatedAt =
      GeneratedColumn<DateTime>('server_updated_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        scopeKey,
        id,
        companyName,
        taxNumber,
        address,
        logoUrl,
        defaultTaxRate,
        currencyCode,
        currencySymbol,
        userId,
        syncStatus,
        serverUpdatedAt,
        isDeleted
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'business_settings';
  @override
  VerificationContext validateIntegrity(Insertable<BusinessSetting> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('scope_key')) {
      context.handle(_scopeKeyMeta,
          scopeKey.isAcceptableOrUnknown(data['scope_key']!, _scopeKeyMeta));
    } else if (isInserting) {
      context.missing(_scopeKeyMeta);
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('company_name')) {
      context.handle(
          _companyNameMeta,
          companyName.isAcceptableOrUnknown(
              data['company_name']!, _companyNameMeta));
    } else if (isInserting) {
      context.missing(_companyNameMeta);
    }
    if (data.containsKey('tax_number')) {
      context.handle(_taxNumberMeta,
          taxNumber.isAcceptableOrUnknown(data['tax_number']!, _taxNumberMeta));
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    }
    if (data.containsKey('logo_url')) {
      context.handle(_logoUrlMeta,
          logoUrl.isAcceptableOrUnknown(data['logo_url']!, _logoUrlMeta));
    }
    if (data.containsKey('default_tax_rate')) {
      context.handle(
          _defaultTaxRateMeta,
          defaultTaxRate.isAcceptableOrUnknown(
              data['default_tax_rate']!, _defaultTaxRateMeta));
    } else if (isInserting) {
      context.missing(_defaultTaxRateMeta);
    }
    if (data.containsKey('currency_code')) {
      context.handle(
          _currencyCodeMeta,
          currencyCode.isAcceptableOrUnknown(
              data['currency_code']!, _currencyCodeMeta));
    } else if (isInserting) {
      context.missing(_currencyCodeMeta);
    }
    if (data.containsKey('currency_symbol')) {
      context.handle(
          _currencySymbolMeta,
          currencySymbol.isAcceptableOrUnknown(
              data['currency_symbol']!, _currencySymbolMeta));
    } else if (isInserting) {
      context.missing(_currencySymbolMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    if (data.containsKey('server_updated_at')) {
      context.handle(
          _serverUpdatedAtMeta,
          serverUpdatedAt.isAcceptableOrUnknown(
              data['server_updated_at']!, _serverUpdatedAtMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {scopeKey};
  @override
  BusinessSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BusinessSetting(
      scopeKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}scope_key'])!,
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      companyName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}company_name'])!,
      taxNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tax_number']),
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address']),
      logoUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}logo_url']),
      defaultTaxRate: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}default_tax_rate'])!,
      currencyCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency_code'])!,
      currencySymbol: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}currency_symbol'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id']),
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
      serverUpdatedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}server_updated_at']),
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
    );
  }

  @override
  $BusinessSettingsTable createAlias(String alias) {
    return $BusinessSettingsTable(attachedDatabase, alias);
  }
}

class BusinessSetting extends DataClass implements Insertable<BusinessSetting> {
  final String scopeKey;
  final String id;
  final String companyName;
  final String? taxNumber;
  final String? address;
  final String? logoUrl;
  final double defaultTaxRate;
  final String currencyCode;
  final String currencySymbol;
  final String? userId;
  final String syncStatus;
  final DateTime? serverUpdatedAt;
  final bool isDeleted;
  const BusinessSetting(
      {required this.scopeKey,
      required this.id,
      required this.companyName,
      this.taxNumber,
      this.address,
      this.logoUrl,
      required this.defaultTaxRate,
      required this.currencyCode,
      required this.currencySymbol,
      this.userId,
      required this.syncStatus,
      this.serverUpdatedAt,
      required this.isDeleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['scope_key'] = Variable<String>(scopeKey);
    map['id'] = Variable<String>(id);
    map['company_name'] = Variable<String>(companyName);
    if (!nullToAbsent || taxNumber != null) {
      map['tax_number'] = Variable<String>(taxNumber);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || logoUrl != null) {
      map['logo_url'] = Variable<String>(logoUrl);
    }
    map['default_tax_rate'] = Variable<double>(defaultTaxRate);
    map['currency_code'] = Variable<String>(currencyCode);
    map['currency_symbol'] = Variable<String>(currencySymbol);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || serverUpdatedAt != null) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt);
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  BusinessSettingsCompanion toCompanion(bool nullToAbsent) {
    return BusinessSettingsCompanion(
      scopeKey: Value(scopeKey),
      id: Value(id),
      companyName: Value(companyName),
      taxNumber: taxNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(taxNumber),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      logoUrl: logoUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(logoUrl),
      defaultTaxRate: Value(defaultTaxRate),
      currencyCode: Value(currencyCode),
      currencySymbol: Value(currencySymbol),
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
      syncStatus: Value(syncStatus),
      serverUpdatedAt: serverUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(serverUpdatedAt),
      isDeleted: Value(isDeleted),
    );
  }

  factory BusinessSetting.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BusinessSetting(
      scopeKey: serializer.fromJson<String>(json['scopeKey']),
      id: serializer.fromJson<String>(json['id']),
      companyName: serializer.fromJson<String>(json['companyName']),
      taxNumber: serializer.fromJson<String?>(json['taxNumber']),
      address: serializer.fromJson<String?>(json['address']),
      logoUrl: serializer.fromJson<String?>(json['logoUrl']),
      defaultTaxRate: serializer.fromJson<double>(json['defaultTaxRate']),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      currencySymbol: serializer.fromJson<String>(json['currencySymbol']),
      userId: serializer.fromJson<String?>(json['userId']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      serverUpdatedAt: serializer.fromJson<DateTime?>(json['serverUpdatedAt']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'scopeKey': serializer.toJson<String>(scopeKey),
      'id': serializer.toJson<String>(id),
      'companyName': serializer.toJson<String>(companyName),
      'taxNumber': serializer.toJson<String?>(taxNumber),
      'address': serializer.toJson<String?>(address),
      'logoUrl': serializer.toJson<String?>(logoUrl),
      'defaultTaxRate': serializer.toJson<double>(defaultTaxRate),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'currencySymbol': serializer.toJson<String>(currencySymbol),
      'userId': serializer.toJson<String?>(userId),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'serverUpdatedAt': serializer.toJson<DateTime?>(serverUpdatedAt),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  BusinessSetting copyWith(
          {String? scopeKey,
          String? id,
          String? companyName,
          Value<String?> taxNumber = const Value.absent(),
          Value<String?> address = const Value.absent(),
          Value<String?> logoUrl = const Value.absent(),
          double? defaultTaxRate,
          String? currencyCode,
          String? currencySymbol,
          Value<String?> userId = const Value.absent(),
          String? syncStatus,
          Value<DateTime?> serverUpdatedAt = const Value.absent(),
          bool? isDeleted}) =>
      BusinessSetting(
        scopeKey: scopeKey ?? this.scopeKey,
        id: id ?? this.id,
        companyName: companyName ?? this.companyName,
        taxNumber: taxNumber.present ? taxNumber.value : this.taxNumber,
        address: address.present ? address.value : this.address,
        logoUrl: logoUrl.present ? logoUrl.value : this.logoUrl,
        defaultTaxRate: defaultTaxRate ?? this.defaultTaxRate,
        currencyCode: currencyCode ?? this.currencyCode,
        currencySymbol: currencySymbol ?? this.currencySymbol,
        userId: userId.present ? userId.value : this.userId,
        syncStatus: syncStatus ?? this.syncStatus,
        serverUpdatedAt: serverUpdatedAt.present
            ? serverUpdatedAt.value
            : this.serverUpdatedAt,
        isDeleted: isDeleted ?? this.isDeleted,
      );
  BusinessSetting copyWithCompanion(BusinessSettingsCompanion data) {
    return BusinessSetting(
      scopeKey: data.scopeKey.present ? data.scopeKey.value : this.scopeKey,
      id: data.id.present ? data.id.value : this.id,
      companyName:
          data.companyName.present ? data.companyName.value : this.companyName,
      taxNumber: data.taxNumber.present ? data.taxNumber.value : this.taxNumber,
      address: data.address.present ? data.address.value : this.address,
      logoUrl: data.logoUrl.present ? data.logoUrl.value : this.logoUrl,
      defaultTaxRate: data.defaultTaxRate.present
          ? data.defaultTaxRate.value
          : this.defaultTaxRate,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      currencySymbol: data.currencySymbol.present
          ? data.currencySymbol.value
          : this.currencySymbol,
      userId: data.userId.present ? data.userId.value : this.userId,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      serverUpdatedAt: data.serverUpdatedAt.present
          ? data.serverUpdatedAt.value
          : this.serverUpdatedAt,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BusinessSetting(')
          ..write('scopeKey: $scopeKey, ')
          ..write('id: $id, ')
          ..write('companyName: $companyName, ')
          ..write('taxNumber: $taxNumber, ')
          ..write('address: $address, ')
          ..write('logoUrl: $logoUrl, ')
          ..write('defaultTaxRate: $defaultTaxRate, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('currencySymbol: $currencySymbol, ')
          ..write('userId: $userId, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      scopeKey,
      id,
      companyName,
      taxNumber,
      address,
      logoUrl,
      defaultTaxRate,
      currencyCode,
      currencySymbol,
      userId,
      syncStatus,
      serverUpdatedAt,
      isDeleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BusinessSetting &&
          other.scopeKey == this.scopeKey &&
          other.id == this.id &&
          other.companyName == this.companyName &&
          other.taxNumber == this.taxNumber &&
          other.address == this.address &&
          other.logoUrl == this.logoUrl &&
          other.defaultTaxRate == this.defaultTaxRate &&
          other.currencyCode == this.currencyCode &&
          other.currencySymbol == this.currencySymbol &&
          other.userId == this.userId &&
          other.syncStatus == this.syncStatus &&
          other.serverUpdatedAt == this.serverUpdatedAt &&
          other.isDeleted == this.isDeleted);
}

class BusinessSettingsCompanion extends UpdateCompanion<BusinessSetting> {
  final Value<String> scopeKey;
  final Value<String> id;
  final Value<String> companyName;
  final Value<String?> taxNumber;
  final Value<String?> address;
  final Value<String?> logoUrl;
  final Value<double> defaultTaxRate;
  final Value<String> currencyCode;
  final Value<String> currencySymbol;
  final Value<String?> userId;
  final Value<String> syncStatus;
  final Value<DateTime?> serverUpdatedAt;
  final Value<bool> isDeleted;
  final Value<int> rowid;
  const BusinessSettingsCompanion({
    this.scopeKey = const Value.absent(),
    this.id = const Value.absent(),
    this.companyName = const Value.absent(),
    this.taxNumber = const Value.absent(),
    this.address = const Value.absent(),
    this.logoUrl = const Value.absent(),
    this.defaultTaxRate = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.currencySymbol = const Value.absent(),
    this.userId = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BusinessSettingsCompanion.insert({
    required String scopeKey,
    required String id,
    required String companyName,
    this.taxNumber = const Value.absent(),
    this.address = const Value.absent(),
    this.logoUrl = const Value.absent(),
    required double defaultTaxRate,
    required String currencyCode,
    required String currencySymbol,
    this.userId = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : scopeKey = Value(scopeKey),
        id = Value(id),
        companyName = Value(companyName),
        defaultTaxRate = Value(defaultTaxRate),
        currencyCode = Value(currencyCode),
        currencySymbol = Value(currencySymbol);
  static Insertable<BusinessSetting> custom({
    Expression<String>? scopeKey,
    Expression<String>? id,
    Expression<String>? companyName,
    Expression<String>? taxNumber,
    Expression<String>? address,
    Expression<String>? logoUrl,
    Expression<double>? defaultTaxRate,
    Expression<String>? currencyCode,
    Expression<String>? currencySymbol,
    Expression<String>? userId,
    Expression<String>? syncStatus,
    Expression<DateTime>? serverUpdatedAt,
    Expression<bool>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (scopeKey != null) 'scope_key': scopeKey,
      if (id != null) 'id': id,
      if (companyName != null) 'company_name': companyName,
      if (taxNumber != null) 'tax_number': taxNumber,
      if (address != null) 'address': address,
      if (logoUrl != null) 'logo_url': logoUrl,
      if (defaultTaxRate != null) 'default_tax_rate': defaultTaxRate,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (currencySymbol != null) 'currency_symbol': currencySymbol,
      if (userId != null) 'user_id': userId,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (serverUpdatedAt != null) 'server_updated_at': serverUpdatedAt,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BusinessSettingsCompanion copyWith(
      {Value<String>? scopeKey,
      Value<String>? id,
      Value<String>? companyName,
      Value<String?>? taxNumber,
      Value<String?>? address,
      Value<String?>? logoUrl,
      Value<double>? defaultTaxRate,
      Value<String>? currencyCode,
      Value<String>? currencySymbol,
      Value<String?>? userId,
      Value<String>? syncStatus,
      Value<DateTime?>? serverUpdatedAt,
      Value<bool>? isDeleted,
      Value<int>? rowid}) {
    return BusinessSettingsCompanion(
      scopeKey: scopeKey ?? this.scopeKey,
      id: id ?? this.id,
      companyName: companyName ?? this.companyName,
      taxNumber: taxNumber ?? this.taxNumber,
      address: address ?? this.address,
      logoUrl: logoUrl ?? this.logoUrl,
      defaultTaxRate: defaultTaxRate ?? this.defaultTaxRate,
      currencyCode: currencyCode ?? this.currencyCode,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      userId: userId ?? this.userId,
      syncStatus: syncStatus ?? this.syncStatus,
      serverUpdatedAt: serverUpdatedAt ?? this.serverUpdatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (scopeKey.present) {
      map['scope_key'] = Variable<String>(scopeKey.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (companyName.present) {
      map['company_name'] = Variable<String>(companyName.value);
    }
    if (taxNumber.present) {
      map['tax_number'] = Variable<String>(taxNumber.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (logoUrl.present) {
      map['logo_url'] = Variable<String>(logoUrl.value);
    }
    if (defaultTaxRate.present) {
      map['default_tax_rate'] = Variable<double>(defaultTaxRate.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (currencySymbol.present) {
      map['currency_symbol'] = Variable<String>(currencySymbol.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (serverUpdatedAt.present) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BusinessSettingsCompanion(')
          ..write('scopeKey: $scopeKey, ')
          ..write('id: $id, ')
          ..write('companyName: $companyName, ')
          ..write('taxNumber: $taxNumber, ')
          ..write('address: $address, ')
          ..write('logoUrl: $logoUrl, ')
          ..write('defaultTaxRate: $defaultTaxRate, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('currencySymbol: $currencySymbol, ')
          ..write('userId: $userId, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GoalsTable extends Goals with TableInfo<$GoalsTable, Goal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _scopeKeyMeta =
      const VerificationMeta('scopeKey');
  @override
  late final GeneratedColumn<String> scopeKey = GeneratedColumn<String>(
      'scope_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
      'uuid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _targetAmountMeta =
      const VerificationMeta('targetAmount');
  @override
  late final GeneratedColumn<String> targetAmount = GeneratedColumn<String>(
      'target_amount', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _currentAmountMeta =
      const VerificationMeta('currentAmount');
  @override
  late final GeneratedColumn<String> currentAmount = GeneratedColumn<String>(
      'current_amount', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _startDateMeta =
      const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
      'start_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _targetDateMeta =
      const VerificationMeta('targetDate');
  @override
  late final GeneratedColumn<DateTime> targetDate = GeneratedColumn<DateTime>(
      'target_date', aliasedName, false,
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
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        scopeKey,
        uuid,
        name,
        category,
        targetAmount,
        currentAmount,
        startDate,
        targetDate,
        isActive,
        description,
        userId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'goals';
  @override
  VerificationContext validateIntegrity(Insertable<Goal> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('scope_key')) {
      context.handle(_scopeKeyMeta,
          scopeKey.isAcceptableOrUnknown(data['scope_key']!, _scopeKeyMeta));
    } else if (isInserting) {
      context.missing(_scopeKeyMeta);
    }
    if (data.containsKey('uuid')) {
      context.handle(
          _uuidMeta, uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta));
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('target_amount')) {
      context.handle(
          _targetAmountMeta,
          targetAmount.isAcceptableOrUnknown(
              data['target_amount']!, _targetAmountMeta));
    } else if (isInserting) {
      context.missing(_targetAmountMeta);
    }
    if (data.containsKey('current_amount')) {
      context.handle(
          _currentAmountMeta,
          currentAmount.isAcceptableOrUnknown(
              data['current_amount']!, _currentAmountMeta));
    } else if (isInserting) {
      context.missing(_currentAmountMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('target_date')) {
      context.handle(
          _targetDateMeta,
          targetDate.isAcceptableOrUnknown(
              data['target_date']!, _targetDateMeta));
    } else if (isInserting) {
      context.missing(_targetDateMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {scopeKey, uuid};
  @override
  Goal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Goal(
      scopeKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}scope_key'])!,
      uuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uuid'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      targetAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}target_amount'])!,
      currentAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}current_amount'])!,
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_date'])!,
      targetDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}target_date'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id']),
    );
  }

  @override
  $GoalsTable createAlias(String alias) {
    return $GoalsTable(attachedDatabase, alias);
  }
}

class Goal extends DataClass implements Insertable<Goal> {
  final String scopeKey;
  final String uuid;
  final String name;
  final String category;
  final String targetAmount;
  final String currentAmount;
  final DateTime startDate;
  final DateTime targetDate;
  final bool isActive;
  final String? description;
  final String? userId;
  const Goal(
      {required this.scopeKey,
      required this.uuid,
      required this.name,
      required this.category,
      required this.targetAmount,
      required this.currentAmount,
      required this.startDate,
      required this.targetDate,
      required this.isActive,
      this.description,
      this.userId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['scope_key'] = Variable<String>(scopeKey);
    map['uuid'] = Variable<String>(uuid);
    map['name'] = Variable<String>(name);
    map['category'] = Variable<String>(category);
    map['target_amount'] = Variable<String>(targetAmount);
    map['current_amount'] = Variable<String>(currentAmount);
    map['start_date'] = Variable<DateTime>(startDate);
    map['target_date'] = Variable<DateTime>(targetDate);
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    return map;
  }

  GoalsCompanion toCompanion(bool nullToAbsent) {
    return GoalsCompanion(
      scopeKey: Value(scopeKey),
      uuid: Value(uuid),
      name: Value(name),
      category: Value(category),
      targetAmount: Value(targetAmount),
      currentAmount: Value(currentAmount),
      startDate: Value(startDate),
      targetDate: Value(targetDate),
      isActive: Value(isActive),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
    );
  }

  factory Goal.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Goal(
      scopeKey: serializer.fromJson<String>(json['scopeKey']),
      uuid: serializer.fromJson<String>(json['uuid']),
      name: serializer.fromJson<String>(json['name']),
      category: serializer.fromJson<String>(json['category']),
      targetAmount: serializer.fromJson<String>(json['targetAmount']),
      currentAmount: serializer.fromJson<String>(json['currentAmount']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      targetDate: serializer.fromJson<DateTime>(json['targetDate']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      description: serializer.fromJson<String?>(json['description']),
      userId: serializer.fromJson<String?>(json['userId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'scopeKey': serializer.toJson<String>(scopeKey),
      'uuid': serializer.toJson<String>(uuid),
      'name': serializer.toJson<String>(name),
      'category': serializer.toJson<String>(category),
      'targetAmount': serializer.toJson<String>(targetAmount),
      'currentAmount': serializer.toJson<String>(currentAmount),
      'startDate': serializer.toJson<DateTime>(startDate),
      'targetDate': serializer.toJson<DateTime>(targetDate),
      'isActive': serializer.toJson<bool>(isActive),
      'description': serializer.toJson<String?>(description),
      'userId': serializer.toJson<String?>(userId),
    };
  }

  Goal copyWith(
          {String? scopeKey,
          String? uuid,
          String? name,
          String? category,
          String? targetAmount,
          String? currentAmount,
          DateTime? startDate,
          DateTime? targetDate,
          bool? isActive,
          Value<String?> description = const Value.absent(),
          Value<String?> userId = const Value.absent()}) =>
      Goal(
        scopeKey: scopeKey ?? this.scopeKey,
        uuid: uuid ?? this.uuid,
        name: name ?? this.name,
        category: category ?? this.category,
        targetAmount: targetAmount ?? this.targetAmount,
        currentAmount: currentAmount ?? this.currentAmount,
        startDate: startDate ?? this.startDate,
        targetDate: targetDate ?? this.targetDate,
        isActive: isActive ?? this.isActive,
        description: description.present ? description.value : this.description,
        userId: userId.present ? userId.value : this.userId,
      );
  Goal copyWithCompanion(GoalsCompanion data) {
    return Goal(
      scopeKey: data.scopeKey.present ? data.scopeKey.value : this.scopeKey,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
      targetAmount: data.targetAmount.present
          ? data.targetAmount.value
          : this.targetAmount,
      currentAmount: data.currentAmount.present
          ? data.currentAmount.value
          : this.currentAmount,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      targetDate:
          data.targetDate.present ? data.targetDate.value : this.targetDate,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      description:
          data.description.present ? data.description.value : this.description,
      userId: data.userId.present ? data.userId.value : this.userId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Goal(')
          ..write('scopeKey: $scopeKey, ')
          ..write('uuid: $uuid, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('targetAmount: $targetAmount, ')
          ..write('currentAmount: $currentAmount, ')
          ..write('startDate: $startDate, ')
          ..write('targetDate: $targetDate, ')
          ..write('isActive: $isActive, ')
          ..write('description: $description, ')
          ..write('userId: $userId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(scopeKey, uuid, name, category, targetAmount,
      currentAmount, startDate, targetDate, isActive, description, userId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Goal &&
          other.scopeKey == this.scopeKey &&
          other.uuid == this.uuid &&
          other.name == this.name &&
          other.category == this.category &&
          other.targetAmount == this.targetAmount &&
          other.currentAmount == this.currentAmount &&
          other.startDate == this.startDate &&
          other.targetDate == this.targetDate &&
          other.isActive == this.isActive &&
          other.description == this.description &&
          other.userId == this.userId);
}

class GoalsCompanion extends UpdateCompanion<Goal> {
  final Value<String> scopeKey;
  final Value<String> uuid;
  final Value<String> name;
  final Value<String> category;
  final Value<String> targetAmount;
  final Value<String> currentAmount;
  final Value<DateTime> startDate;
  final Value<DateTime> targetDate;
  final Value<bool> isActive;
  final Value<String?> description;
  final Value<String?> userId;
  final Value<int> rowid;
  const GoalsCompanion({
    this.scopeKey = const Value.absent(),
    this.uuid = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
    this.targetAmount = const Value.absent(),
    this.currentAmount = const Value.absent(),
    this.startDate = const Value.absent(),
    this.targetDate = const Value.absent(),
    this.isActive = const Value.absent(),
    this.description = const Value.absent(),
    this.userId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GoalsCompanion.insert({
    required String scopeKey,
    required String uuid,
    required String name,
    required String category,
    required String targetAmount,
    required String currentAmount,
    required DateTime startDate,
    required DateTime targetDate,
    this.isActive = const Value.absent(),
    this.description = const Value.absent(),
    this.userId = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : scopeKey = Value(scopeKey),
        uuid = Value(uuid),
        name = Value(name),
        category = Value(category),
        targetAmount = Value(targetAmount),
        currentAmount = Value(currentAmount),
        startDate = Value(startDate),
        targetDate = Value(targetDate);
  static Insertable<Goal> custom({
    Expression<String>? scopeKey,
    Expression<String>? uuid,
    Expression<String>? name,
    Expression<String>? category,
    Expression<String>? targetAmount,
    Expression<String>? currentAmount,
    Expression<DateTime>? startDate,
    Expression<DateTime>? targetDate,
    Expression<bool>? isActive,
    Expression<String>? description,
    Expression<String>? userId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (scopeKey != null) 'scope_key': scopeKey,
      if (uuid != null) 'uuid': uuid,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (targetAmount != null) 'target_amount': targetAmount,
      if (currentAmount != null) 'current_amount': currentAmount,
      if (startDate != null) 'start_date': startDate,
      if (targetDate != null) 'target_date': targetDate,
      if (isActive != null) 'is_active': isActive,
      if (description != null) 'description': description,
      if (userId != null) 'user_id': userId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GoalsCompanion copyWith(
      {Value<String>? scopeKey,
      Value<String>? uuid,
      Value<String>? name,
      Value<String>? category,
      Value<String>? targetAmount,
      Value<String>? currentAmount,
      Value<DateTime>? startDate,
      Value<DateTime>? targetDate,
      Value<bool>? isActive,
      Value<String?>? description,
      Value<String?>? userId,
      Value<int>? rowid}) {
    return GoalsCompanion(
      scopeKey: scopeKey ?? this.scopeKey,
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      category: category ?? this.category,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      startDate: startDate ?? this.startDate,
      targetDate: targetDate ?? this.targetDate,
      isActive: isActive ?? this.isActive,
      description: description ?? this.description,
      userId: userId ?? this.userId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (scopeKey.present) {
      map['scope_key'] = Variable<String>(scopeKey.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (targetAmount.present) {
      map['target_amount'] = Variable<String>(targetAmount.value);
    }
    if (currentAmount.present) {
      map['current_amount'] = Variable<String>(currentAmount.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (targetDate.present) {
      map['target_date'] = Variable<DateTime>(targetDate.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoalsCompanion(')
          ..write('scopeKey: $scopeKey, ')
          ..write('uuid: $uuid, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('targetAmount: $targetAmount, ')
          ..write('currentAmount: $currentAmount, ')
          ..write('startDate: $startDate, ')
          ..write('targetDate: $targetDate, ')
          ..write('isActive: $isActive, ')
          ..write('description: $description, ')
          ..write('userId: $userId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BudgetsTable extends Budgets with TableInfo<$BudgetsTable, Budget> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _scopeKeyMeta =
      const VerificationMeta('scopeKey');
  @override
  late final GeneratedColumn<String> scopeKey = GeneratedColumn<String>(
      'scope_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _budgetIdMeta =
      const VerificationMeta('budgetId');
  @override
  late final GeneratedColumn<String> budgetId = GeneratedColumn<String>(
      'budget_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _limitAmountMeta =
      const VerificationMeta('limitAmount');
  @override
  late final GeneratedColumn<String> limitAmount = GeneratedColumn<String>(
      'limit_amount', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _spentAmountMeta =
      const VerificationMeta('spentAmount');
  @override
  late final GeneratedColumn<String> spentAmount = GeneratedColumn<String>(
      'spent_amount', aliasedName, false,
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
  static const VerificationMeta _alertThresholdMeta =
      const VerificationMeta('alertThreshold');
  @override
  late final GeneratedColumn<double> alertThreshold = GeneratedColumn<double>(
      'alert_threshold', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _isRolloverMeta =
      const VerificationMeta('isRollover');
  @override
  late final GeneratedColumn<bool> isRollover = GeneratedColumn<bool>(
      'is_rollover', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_rollover" IN (0, 1))'),
      defaultValue: const Constant(false));
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
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        scopeKey,
        budgetId,
        name,
        category,
        limitAmount,
        spentAmount,
        startDate,
        endDate,
        alertThreshold,
        isRollover,
        isActive,
        userId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budgets';
  @override
  VerificationContext validateIntegrity(Insertable<Budget> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('scope_key')) {
      context.handle(_scopeKeyMeta,
          scopeKey.isAcceptableOrUnknown(data['scope_key']!, _scopeKeyMeta));
    } else if (isInserting) {
      context.missing(_scopeKeyMeta);
    }
    if (data.containsKey('budget_id')) {
      context.handle(_budgetIdMeta,
          budgetId.isAcceptableOrUnknown(data['budget_id']!, _budgetIdMeta));
    } else if (isInserting) {
      context.missing(_budgetIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('limit_amount')) {
      context.handle(
          _limitAmountMeta,
          limitAmount.isAcceptableOrUnknown(
              data['limit_amount']!, _limitAmountMeta));
    } else if (isInserting) {
      context.missing(_limitAmountMeta);
    }
    if (data.containsKey('spent_amount')) {
      context.handle(
          _spentAmountMeta,
          spentAmount.isAcceptableOrUnknown(
              data['spent_amount']!, _spentAmountMeta));
    } else if (isInserting) {
      context.missing(_spentAmountMeta);
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
    if (data.containsKey('alert_threshold')) {
      context.handle(
          _alertThresholdMeta,
          alertThreshold.isAcceptableOrUnknown(
              data['alert_threshold']!, _alertThresholdMeta));
    } else if (isInserting) {
      context.missing(_alertThresholdMeta);
    }
    if (data.containsKey('is_rollover')) {
      context.handle(
          _isRolloverMeta,
          isRollover.isAcceptableOrUnknown(
              data['is_rollover']!, _isRolloverMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {scopeKey, budgetId};
  @override
  Budget map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Budget(
      scopeKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}scope_key'])!,
      budgetId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}budget_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      limitAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}limit_amount'])!,
      spentAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}spent_amount'])!,
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_date'])!,
      endDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end_date'])!,
      alertThreshold: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}alert_threshold'])!,
      isRollover: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_rollover'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id']),
    );
  }

  @override
  $BudgetsTable createAlias(String alias) {
    return $BudgetsTable(attachedDatabase, alias);
  }
}

class Budget extends DataClass implements Insertable<Budget> {
  final String scopeKey;
  final String budgetId;
  final String name;
  final String category;
  final String limitAmount;
  final String spentAmount;
  final DateTime startDate;
  final DateTime endDate;
  final double alertThreshold;
  final bool isRollover;
  final bool isActive;
  final String? userId;
  const Budget(
      {required this.scopeKey,
      required this.budgetId,
      required this.name,
      required this.category,
      required this.limitAmount,
      required this.spentAmount,
      required this.startDate,
      required this.endDate,
      required this.alertThreshold,
      required this.isRollover,
      required this.isActive,
      this.userId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['scope_key'] = Variable<String>(scopeKey);
    map['budget_id'] = Variable<String>(budgetId);
    map['name'] = Variable<String>(name);
    map['category'] = Variable<String>(category);
    map['limit_amount'] = Variable<String>(limitAmount);
    map['spent_amount'] = Variable<String>(spentAmount);
    map['start_date'] = Variable<DateTime>(startDate);
    map['end_date'] = Variable<DateTime>(endDate);
    map['alert_threshold'] = Variable<double>(alertThreshold);
    map['is_rollover'] = Variable<bool>(isRollover);
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    return map;
  }

  BudgetsCompanion toCompanion(bool nullToAbsent) {
    return BudgetsCompanion(
      scopeKey: Value(scopeKey),
      budgetId: Value(budgetId),
      name: Value(name),
      category: Value(category),
      limitAmount: Value(limitAmount),
      spentAmount: Value(spentAmount),
      startDate: Value(startDate),
      endDate: Value(endDate),
      alertThreshold: Value(alertThreshold),
      isRollover: Value(isRollover),
      isActive: Value(isActive),
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
    );
  }

  factory Budget.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Budget(
      scopeKey: serializer.fromJson<String>(json['scopeKey']),
      budgetId: serializer.fromJson<String>(json['budgetId']),
      name: serializer.fromJson<String>(json['name']),
      category: serializer.fromJson<String>(json['category']),
      limitAmount: serializer.fromJson<String>(json['limitAmount']),
      spentAmount: serializer.fromJson<String>(json['spentAmount']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime>(json['endDate']),
      alertThreshold: serializer.fromJson<double>(json['alertThreshold']),
      isRollover: serializer.fromJson<bool>(json['isRollover']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      userId: serializer.fromJson<String?>(json['userId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'scopeKey': serializer.toJson<String>(scopeKey),
      'budgetId': serializer.toJson<String>(budgetId),
      'name': serializer.toJson<String>(name),
      'category': serializer.toJson<String>(category),
      'limitAmount': serializer.toJson<String>(limitAmount),
      'spentAmount': serializer.toJson<String>(spentAmount),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime>(endDate),
      'alertThreshold': serializer.toJson<double>(alertThreshold),
      'isRollover': serializer.toJson<bool>(isRollover),
      'isActive': serializer.toJson<bool>(isActive),
      'userId': serializer.toJson<String?>(userId),
    };
  }

  Budget copyWith(
          {String? scopeKey,
          String? budgetId,
          String? name,
          String? category,
          String? limitAmount,
          String? spentAmount,
          DateTime? startDate,
          DateTime? endDate,
          double? alertThreshold,
          bool? isRollover,
          bool? isActive,
          Value<String?> userId = const Value.absent()}) =>
      Budget(
        scopeKey: scopeKey ?? this.scopeKey,
        budgetId: budgetId ?? this.budgetId,
        name: name ?? this.name,
        category: category ?? this.category,
        limitAmount: limitAmount ?? this.limitAmount,
        spentAmount: spentAmount ?? this.spentAmount,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        alertThreshold: alertThreshold ?? this.alertThreshold,
        isRollover: isRollover ?? this.isRollover,
        isActive: isActive ?? this.isActive,
        userId: userId.present ? userId.value : this.userId,
      );
  Budget copyWithCompanion(BudgetsCompanion data) {
    return Budget(
      scopeKey: data.scopeKey.present ? data.scopeKey.value : this.scopeKey,
      budgetId: data.budgetId.present ? data.budgetId.value : this.budgetId,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
      limitAmount:
          data.limitAmount.present ? data.limitAmount.value : this.limitAmount,
      spentAmount:
          data.spentAmount.present ? data.spentAmount.value : this.spentAmount,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      alertThreshold: data.alertThreshold.present
          ? data.alertThreshold.value
          : this.alertThreshold,
      isRollover:
          data.isRollover.present ? data.isRollover.value : this.isRollover,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      userId: data.userId.present ? data.userId.value : this.userId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Budget(')
          ..write('scopeKey: $scopeKey, ')
          ..write('budgetId: $budgetId, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('limitAmount: $limitAmount, ')
          ..write('spentAmount: $spentAmount, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('alertThreshold: $alertThreshold, ')
          ..write('isRollover: $isRollover, ')
          ..write('isActive: $isActive, ')
          ..write('userId: $userId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      scopeKey,
      budgetId,
      name,
      category,
      limitAmount,
      spentAmount,
      startDate,
      endDate,
      alertThreshold,
      isRollover,
      isActive,
      userId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Budget &&
          other.scopeKey == this.scopeKey &&
          other.budgetId == this.budgetId &&
          other.name == this.name &&
          other.category == this.category &&
          other.limitAmount == this.limitAmount &&
          other.spentAmount == this.spentAmount &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.alertThreshold == this.alertThreshold &&
          other.isRollover == this.isRollover &&
          other.isActive == this.isActive &&
          other.userId == this.userId);
}

class BudgetsCompanion extends UpdateCompanion<Budget> {
  final Value<String> scopeKey;
  final Value<String> budgetId;
  final Value<String> name;
  final Value<String> category;
  final Value<String> limitAmount;
  final Value<String> spentAmount;
  final Value<DateTime> startDate;
  final Value<DateTime> endDate;
  final Value<double> alertThreshold;
  final Value<bool> isRollover;
  final Value<bool> isActive;
  final Value<String?> userId;
  final Value<int> rowid;
  const BudgetsCompanion({
    this.scopeKey = const Value.absent(),
    this.budgetId = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
    this.limitAmount = const Value.absent(),
    this.spentAmount = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.alertThreshold = const Value.absent(),
    this.isRollover = const Value.absent(),
    this.isActive = const Value.absent(),
    this.userId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BudgetsCompanion.insert({
    required String scopeKey,
    required String budgetId,
    required String name,
    required String category,
    required String limitAmount,
    required String spentAmount,
    required DateTime startDate,
    required DateTime endDate,
    required double alertThreshold,
    this.isRollover = const Value.absent(),
    this.isActive = const Value.absent(),
    this.userId = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : scopeKey = Value(scopeKey),
        budgetId = Value(budgetId),
        name = Value(name),
        category = Value(category),
        limitAmount = Value(limitAmount),
        spentAmount = Value(spentAmount),
        startDate = Value(startDate),
        endDate = Value(endDate),
        alertThreshold = Value(alertThreshold);
  static Insertable<Budget> custom({
    Expression<String>? scopeKey,
    Expression<String>? budgetId,
    Expression<String>? name,
    Expression<String>? category,
    Expression<String>? limitAmount,
    Expression<String>? spentAmount,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<double>? alertThreshold,
    Expression<bool>? isRollover,
    Expression<bool>? isActive,
    Expression<String>? userId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (scopeKey != null) 'scope_key': scopeKey,
      if (budgetId != null) 'budget_id': budgetId,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (limitAmount != null) 'limit_amount': limitAmount,
      if (spentAmount != null) 'spent_amount': spentAmount,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (alertThreshold != null) 'alert_threshold': alertThreshold,
      if (isRollover != null) 'is_rollover': isRollover,
      if (isActive != null) 'is_active': isActive,
      if (userId != null) 'user_id': userId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BudgetsCompanion copyWith(
      {Value<String>? scopeKey,
      Value<String>? budgetId,
      Value<String>? name,
      Value<String>? category,
      Value<String>? limitAmount,
      Value<String>? spentAmount,
      Value<DateTime>? startDate,
      Value<DateTime>? endDate,
      Value<double>? alertThreshold,
      Value<bool>? isRollover,
      Value<bool>? isActive,
      Value<String?>? userId,
      Value<int>? rowid}) {
    return BudgetsCompanion(
      scopeKey: scopeKey ?? this.scopeKey,
      budgetId: budgetId ?? this.budgetId,
      name: name ?? this.name,
      category: category ?? this.category,
      limitAmount: limitAmount ?? this.limitAmount,
      spentAmount: spentAmount ?? this.spentAmount,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      alertThreshold: alertThreshold ?? this.alertThreshold,
      isRollover: isRollover ?? this.isRollover,
      isActive: isActive ?? this.isActive,
      userId: userId ?? this.userId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (scopeKey.present) {
      map['scope_key'] = Variable<String>(scopeKey.value);
    }
    if (budgetId.present) {
      map['budget_id'] = Variable<String>(budgetId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (limitAmount.present) {
      map['limit_amount'] = Variable<String>(limitAmount.value);
    }
    if (spentAmount.present) {
      map['spent_amount'] = Variable<String>(spentAmount.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (alertThreshold.present) {
      map['alert_threshold'] = Variable<double>(alertThreshold.value);
    }
    if (isRollover.present) {
      map['is_rollover'] = Variable<bool>(isRollover.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetsCompanion(')
          ..write('scopeKey: $scopeKey, ')
          ..write('budgetId: $budgetId, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('limitAmount: $limitAmount, ')
          ..write('spentAmount: $spentAmount, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('alertThreshold: $alertThreshold, ')
          ..write('isRollover: $isRollover, ')
          ..write('isActive: $isActive, ')
          ..write('userId: $userId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CustomersTable extends Customers
    with TableInfo<$CustomersTable, Customer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _scopeKeyMeta =
      const VerificationMeta('scopeKey');
  @override
  late final GeneratedColumn<String> scopeKey = GeneratedColumn<String>(
      'scope_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
      'uuid', aliasedName, false,
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
  static const VerificationMeta _taxNumberMeta =
      const VerificationMeta('taxNumber');
  @override
  late final GeneratedColumn<String> taxNumber = GeneratedColumn<String>(
      'tax_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
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
  static const VerificationMeta _creditLimitMeta =
      const VerificationMeta('creditLimit');
  @override
  late final GeneratedColumn<double> creditLimit = GeneratedColumn<double>(
      'credit_limit', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _balanceMeta =
      const VerificationMeta('balance');
  @override
  late final GeneratedColumn<double> balance = GeneratedColumn<double>(
      'balance', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _receivableAccountIdMeta =
      const VerificationMeta('receivableAccountId');
  @override
  late final GeneratedColumn<String> receivableAccountId =
      GeneratedColumn<String>('receivable_account_id', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('synced'));
  static const VerificationMeta _serverUpdatedAtMeta =
      const VerificationMeta('serverUpdatedAt');
  @override
  late final GeneratedColumn<DateTime> serverUpdatedAt =
      GeneratedColumn<DateTime>('server_updated_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        scopeKey,
        uuid,
        nameAr,
        nameEn,
        taxNumber,
        phone,
        email,
        address,
        notes,
        createdAt,
        updatedAt,
        creditLimit,
        balance,
        receivableAccountId,
        userId,
        syncStatus,
        serverUpdatedAt,
        isDeleted
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'customers';
  @override
  VerificationContext validateIntegrity(Insertable<Customer> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('scope_key')) {
      context.handle(_scopeKeyMeta,
          scopeKey.isAcceptableOrUnknown(data['scope_key']!, _scopeKeyMeta));
    } else if (isInserting) {
      context.missing(_scopeKeyMeta);
    }
    if (data.containsKey('uuid')) {
      context.handle(
          _uuidMeta, uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta));
    } else if (isInserting) {
      context.missing(_uuidMeta);
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
    if (data.containsKey('tax_number')) {
      context.handle(_taxNumberMeta,
          taxNumber.isAcceptableOrUnknown(data['tax_number']!, _taxNumberMeta));
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
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
    if (data.containsKey('credit_limit')) {
      context.handle(
          _creditLimitMeta,
          creditLimit.isAcceptableOrUnknown(
              data['credit_limit']!, _creditLimitMeta));
    }
    if (data.containsKey('balance')) {
      context.handle(_balanceMeta,
          balance.isAcceptableOrUnknown(data['balance']!, _balanceMeta));
    }
    if (data.containsKey('receivable_account_id')) {
      context.handle(
          _receivableAccountIdMeta,
          receivableAccountId.isAcceptableOrUnknown(
              data['receivable_account_id']!, _receivableAccountIdMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    if (data.containsKey('server_updated_at')) {
      context.handle(
          _serverUpdatedAtMeta,
          serverUpdatedAt.isAcceptableOrUnknown(
              data['server_updated_at']!, _serverUpdatedAtMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {scopeKey, uuid};
  @override
  Customer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Customer(
      scopeKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}scope_key'])!,
      uuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uuid'])!,
      nameAr: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_ar'])!,
      nameEn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_en'])!,
      taxNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tax_number']),
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone']),
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      creditLimit: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}credit_limit'])!,
      balance: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}balance'])!,
      receivableAccountId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}receivable_account_id']),
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id']),
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
      serverUpdatedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}server_updated_at']),
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
    );
  }

  @override
  $CustomersTable createAlias(String alias) {
    return $CustomersTable(attachedDatabase, alias);
  }
}

class Customer extends DataClass implements Insertable<Customer> {
  final String scopeKey;
  final String uuid;
  final String nameAr;
  final String nameEn;
  final String? taxNumber;
  final String? phone;
  final String? email;
  final String? address;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double creditLimit;
  final double balance;
  final String? receivableAccountId;
  final String? userId;
  final String syncStatus;
  final DateTime? serverUpdatedAt;
  final bool isDeleted;
  const Customer(
      {required this.scopeKey,
      required this.uuid,
      required this.nameAr,
      required this.nameEn,
      this.taxNumber,
      this.phone,
      this.email,
      this.address,
      this.notes,
      required this.createdAt,
      required this.updatedAt,
      required this.creditLimit,
      required this.balance,
      this.receivableAccountId,
      this.userId,
      required this.syncStatus,
      this.serverUpdatedAt,
      required this.isDeleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['scope_key'] = Variable<String>(scopeKey);
    map['uuid'] = Variable<String>(uuid);
    map['name_ar'] = Variable<String>(nameAr);
    map['name_en'] = Variable<String>(nameEn);
    if (!nullToAbsent || taxNumber != null) {
      map['tax_number'] = Variable<String>(taxNumber);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['credit_limit'] = Variable<double>(creditLimit);
    map['balance'] = Variable<double>(balance);
    if (!nullToAbsent || receivableAccountId != null) {
      map['receivable_account_id'] = Variable<String>(receivableAccountId);
    }
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || serverUpdatedAt != null) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt);
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  CustomersCompanion toCompanion(bool nullToAbsent) {
    return CustomersCompanion(
      scopeKey: Value(scopeKey),
      uuid: Value(uuid),
      nameAr: Value(nameAr),
      nameEn: Value(nameEn),
      taxNumber: taxNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(taxNumber),
      phone:
          phone == null && nullToAbsent ? const Value.absent() : Value(phone),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      creditLimit: Value(creditLimit),
      balance: Value(balance),
      receivableAccountId: receivableAccountId == null && nullToAbsent
          ? const Value.absent()
          : Value(receivableAccountId),
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
      syncStatus: Value(syncStatus),
      serverUpdatedAt: serverUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(serverUpdatedAt),
      isDeleted: Value(isDeleted),
    );
  }

  factory Customer.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Customer(
      scopeKey: serializer.fromJson<String>(json['scopeKey']),
      uuid: serializer.fromJson<String>(json['uuid']),
      nameAr: serializer.fromJson<String>(json['nameAr']),
      nameEn: serializer.fromJson<String>(json['nameEn']),
      taxNumber: serializer.fromJson<String?>(json['taxNumber']),
      phone: serializer.fromJson<String?>(json['phone']),
      email: serializer.fromJson<String?>(json['email']),
      address: serializer.fromJson<String?>(json['address']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      creditLimit: serializer.fromJson<double>(json['creditLimit']),
      balance: serializer.fromJson<double>(json['balance']),
      receivableAccountId:
          serializer.fromJson<String?>(json['receivableAccountId']),
      userId: serializer.fromJson<String?>(json['userId']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      serverUpdatedAt: serializer.fromJson<DateTime?>(json['serverUpdatedAt']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'scopeKey': serializer.toJson<String>(scopeKey),
      'uuid': serializer.toJson<String>(uuid),
      'nameAr': serializer.toJson<String>(nameAr),
      'nameEn': serializer.toJson<String>(nameEn),
      'taxNumber': serializer.toJson<String?>(taxNumber),
      'phone': serializer.toJson<String?>(phone),
      'email': serializer.toJson<String?>(email),
      'address': serializer.toJson<String?>(address),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'creditLimit': serializer.toJson<double>(creditLimit),
      'balance': serializer.toJson<double>(balance),
      'receivableAccountId': serializer.toJson<String?>(receivableAccountId),
      'userId': serializer.toJson<String?>(userId),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'serverUpdatedAt': serializer.toJson<DateTime?>(serverUpdatedAt),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  Customer copyWith(
          {String? scopeKey,
          String? uuid,
          String? nameAr,
          String? nameEn,
          Value<String?> taxNumber = const Value.absent(),
          Value<String?> phone = const Value.absent(),
          Value<String?> email = const Value.absent(),
          Value<String?> address = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          double? creditLimit,
          double? balance,
          Value<String?> receivableAccountId = const Value.absent(),
          Value<String?> userId = const Value.absent(),
          String? syncStatus,
          Value<DateTime?> serverUpdatedAt = const Value.absent(),
          bool? isDeleted}) =>
      Customer(
        scopeKey: scopeKey ?? this.scopeKey,
        uuid: uuid ?? this.uuid,
        nameAr: nameAr ?? this.nameAr,
        nameEn: nameEn ?? this.nameEn,
        taxNumber: taxNumber.present ? taxNumber.value : this.taxNumber,
        phone: phone.present ? phone.value : this.phone,
        email: email.present ? email.value : this.email,
        address: address.present ? address.value : this.address,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        creditLimit: creditLimit ?? this.creditLimit,
        balance: balance ?? this.balance,
        receivableAccountId: receivableAccountId.present
            ? receivableAccountId.value
            : this.receivableAccountId,
        userId: userId.present ? userId.value : this.userId,
        syncStatus: syncStatus ?? this.syncStatus,
        serverUpdatedAt: serverUpdatedAt.present
            ? serverUpdatedAt.value
            : this.serverUpdatedAt,
        isDeleted: isDeleted ?? this.isDeleted,
      );
  Customer copyWithCompanion(CustomersCompanion data) {
    return Customer(
      scopeKey: data.scopeKey.present ? data.scopeKey.value : this.scopeKey,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      nameAr: data.nameAr.present ? data.nameAr.value : this.nameAr,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
      taxNumber: data.taxNumber.present ? data.taxNumber.value : this.taxNumber,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
      address: data.address.present ? data.address.value : this.address,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      creditLimit:
          data.creditLimit.present ? data.creditLimit.value : this.creditLimit,
      balance: data.balance.present ? data.balance.value : this.balance,
      receivableAccountId: data.receivableAccountId.present
          ? data.receivableAccountId.value
          : this.receivableAccountId,
      userId: data.userId.present ? data.userId.value : this.userId,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      serverUpdatedAt: data.serverUpdatedAt.present
          ? data.serverUpdatedAt.value
          : this.serverUpdatedAt,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Customer(')
          ..write('scopeKey: $scopeKey, ')
          ..write('uuid: $uuid, ')
          ..write('nameAr: $nameAr, ')
          ..write('nameEn: $nameEn, ')
          ..write('taxNumber: $taxNumber, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('address: $address, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('creditLimit: $creditLimit, ')
          ..write('balance: $balance, ')
          ..write('receivableAccountId: $receivableAccountId, ')
          ..write('userId: $userId, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      scopeKey,
      uuid,
      nameAr,
      nameEn,
      taxNumber,
      phone,
      email,
      address,
      notes,
      createdAt,
      updatedAt,
      creditLimit,
      balance,
      receivableAccountId,
      userId,
      syncStatus,
      serverUpdatedAt,
      isDeleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Customer &&
          other.scopeKey == this.scopeKey &&
          other.uuid == this.uuid &&
          other.nameAr == this.nameAr &&
          other.nameEn == this.nameEn &&
          other.taxNumber == this.taxNumber &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.address == this.address &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.creditLimit == this.creditLimit &&
          other.balance == this.balance &&
          other.receivableAccountId == this.receivableAccountId &&
          other.userId == this.userId &&
          other.syncStatus == this.syncStatus &&
          other.serverUpdatedAt == this.serverUpdatedAt &&
          other.isDeleted == this.isDeleted);
}

class CustomersCompanion extends UpdateCompanion<Customer> {
  final Value<String> scopeKey;
  final Value<String> uuid;
  final Value<String> nameAr;
  final Value<String> nameEn;
  final Value<String?> taxNumber;
  final Value<String?> phone;
  final Value<String?> email;
  final Value<String?> address;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<double> creditLimit;
  final Value<double> balance;
  final Value<String?> receivableAccountId;
  final Value<String?> userId;
  final Value<String> syncStatus;
  final Value<DateTime?> serverUpdatedAt;
  final Value<bool> isDeleted;
  final Value<int> rowid;
  const CustomersCompanion({
    this.scopeKey = const Value.absent(),
    this.uuid = const Value.absent(),
    this.nameAr = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.taxNumber = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.address = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.creditLimit = const Value.absent(),
    this.balance = const Value.absent(),
    this.receivableAccountId = const Value.absent(),
    this.userId = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CustomersCompanion.insert({
    required String scopeKey,
    required String uuid,
    required String nameAr,
    required String nameEn,
    this.taxNumber = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.address = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.creditLimit = const Value.absent(),
    this.balance = const Value.absent(),
    this.receivableAccountId = const Value.absent(),
    this.userId = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : scopeKey = Value(scopeKey),
        uuid = Value(uuid),
        nameAr = Value(nameAr),
        nameEn = Value(nameEn),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Customer> custom({
    Expression<String>? scopeKey,
    Expression<String>? uuid,
    Expression<String>? nameAr,
    Expression<String>? nameEn,
    Expression<String>? taxNumber,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<String>? address,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<double>? creditLimit,
    Expression<double>? balance,
    Expression<String>? receivableAccountId,
    Expression<String>? userId,
    Expression<String>? syncStatus,
    Expression<DateTime>? serverUpdatedAt,
    Expression<bool>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (scopeKey != null) 'scope_key': scopeKey,
      if (uuid != null) 'uuid': uuid,
      if (nameAr != null) 'name_ar': nameAr,
      if (nameEn != null) 'name_en': nameEn,
      if (taxNumber != null) 'tax_number': taxNumber,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (address != null) 'address': address,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (creditLimit != null) 'credit_limit': creditLimit,
      if (balance != null) 'balance': balance,
      if (receivableAccountId != null)
        'receivable_account_id': receivableAccountId,
      if (userId != null) 'user_id': userId,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (serverUpdatedAt != null) 'server_updated_at': serverUpdatedAt,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CustomersCompanion copyWith(
      {Value<String>? scopeKey,
      Value<String>? uuid,
      Value<String>? nameAr,
      Value<String>? nameEn,
      Value<String?>? taxNumber,
      Value<String?>? phone,
      Value<String?>? email,
      Value<String?>? address,
      Value<String?>? notes,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<double>? creditLimit,
      Value<double>? balance,
      Value<String?>? receivableAccountId,
      Value<String?>? userId,
      Value<String>? syncStatus,
      Value<DateTime?>? serverUpdatedAt,
      Value<bool>? isDeleted,
      Value<int>? rowid}) {
    return CustomersCompanion(
      scopeKey: scopeKey ?? this.scopeKey,
      uuid: uuid ?? this.uuid,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
      taxNumber: taxNumber ?? this.taxNumber,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      creditLimit: creditLimit ?? this.creditLimit,
      balance: balance ?? this.balance,
      receivableAccountId: receivableAccountId ?? this.receivableAccountId,
      userId: userId ?? this.userId,
      syncStatus: syncStatus ?? this.syncStatus,
      serverUpdatedAt: serverUpdatedAt ?? this.serverUpdatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (scopeKey.present) {
      map['scope_key'] = Variable<String>(scopeKey.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (nameAr.present) {
      map['name_ar'] = Variable<String>(nameAr.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (taxNumber.present) {
      map['tax_number'] = Variable<String>(taxNumber.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (creditLimit.present) {
      map['credit_limit'] = Variable<double>(creditLimit.value);
    }
    if (balance.present) {
      map['balance'] = Variable<double>(balance.value);
    }
    if (receivableAccountId.present) {
      map['receivable_account_id'] =
          Variable<String>(receivableAccountId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (serverUpdatedAt.present) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomersCompanion(')
          ..write('scopeKey: $scopeKey, ')
          ..write('uuid: $uuid, ')
          ..write('nameAr: $nameAr, ')
          ..write('nameEn: $nameEn, ')
          ..write('taxNumber: $taxNumber, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('address: $address, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('creditLimit: $creditLimit, ')
          ..write('balance: $balance, ')
          ..write('receivableAccountId: $receivableAccountId, ')
          ..write('userId: $userId, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VendorsTable extends Vendors with TableInfo<$VendorsTable, Vendor> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VendorsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _scopeKeyMeta =
      const VerificationMeta('scopeKey');
  @override
  late final GeneratedColumn<String> scopeKey = GeneratedColumn<String>(
      'scope_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
      'uuid', aliasedName, false,
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
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
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
  static const VerificationMeta _payableAccountIdMeta =
      const VerificationMeta('payableAccountId');
  @override
  late final GeneratedColumn<String> payableAccountId = GeneratedColumn<String>(
      'payable_account_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _vatNumberMeta =
      const VerificationMeta('vatNumber');
  @override
  late final GeneratedColumn<String> vatNumber = GeneratedColumn<String>(
      'vat_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _registrationNumberMeta =
      const VerificationMeta('registrationNumber');
  @override
  late final GeneratedColumn<String> registrationNumber =
      GeneratedColumn<String>('registration_number', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _balanceMeta =
      const VerificationMeta('balance');
  @override
  late final GeneratedColumn<double> balance = GeneratedColumn<double>(
      'balance', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('synced'));
  static const VerificationMeta _serverUpdatedAtMeta =
      const VerificationMeta('serverUpdatedAt');
  @override
  late final GeneratedColumn<DateTime> serverUpdatedAt =
      GeneratedColumn<DateTime>('server_updated_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        scopeKey,
        uuid,
        nameAr,
        nameEn,
        phone,
        email,
        address,
        notes,
        createdAt,
        updatedAt,
        payableAccountId,
        vatNumber,
        registrationNumber,
        balance,
        userId,
        syncStatus,
        serverUpdatedAt,
        isDeleted
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vendors';
  @override
  VerificationContext validateIntegrity(Insertable<Vendor> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('scope_key')) {
      context.handle(_scopeKeyMeta,
          scopeKey.isAcceptableOrUnknown(data['scope_key']!, _scopeKeyMeta));
    } else if (isInserting) {
      context.missing(_scopeKeyMeta);
    }
    if (data.containsKey('uuid')) {
      context.handle(
          _uuidMeta, uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta));
    } else if (isInserting) {
      context.missing(_uuidMeta);
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
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
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
    if (data.containsKey('payable_account_id')) {
      context.handle(
          _payableAccountIdMeta,
          payableAccountId.isAcceptableOrUnknown(
              data['payable_account_id']!, _payableAccountIdMeta));
    }
    if (data.containsKey('vat_number')) {
      context.handle(_vatNumberMeta,
          vatNumber.isAcceptableOrUnknown(data['vat_number']!, _vatNumberMeta));
    }
    if (data.containsKey('registration_number')) {
      context.handle(
          _registrationNumberMeta,
          registrationNumber.isAcceptableOrUnknown(
              data['registration_number']!, _registrationNumberMeta));
    }
    if (data.containsKey('balance')) {
      context.handle(_balanceMeta,
          balance.isAcceptableOrUnknown(data['balance']!, _balanceMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    if (data.containsKey('server_updated_at')) {
      context.handle(
          _serverUpdatedAtMeta,
          serverUpdatedAt.isAcceptableOrUnknown(
              data['server_updated_at']!, _serverUpdatedAtMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {scopeKey, uuid};
  @override
  Vendor map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Vendor(
      scopeKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}scope_key'])!,
      uuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uuid'])!,
      nameAr: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_ar'])!,
      nameEn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_en'])!,
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone']),
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      payableAccountId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}payable_account_id']),
      vatNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}vat_number']),
      registrationNumber: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}registration_number']),
      balance: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}balance'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id']),
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
      serverUpdatedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}server_updated_at']),
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
    );
  }

  @override
  $VendorsTable createAlias(String alias) {
    return $VendorsTable(attachedDatabase, alias);
  }
}

class Vendor extends DataClass implements Insertable<Vendor> {
  final String scopeKey;
  final String uuid;
  final String nameAr;
  final String nameEn;
  final String? phone;
  final String? email;
  final String? address;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? payableAccountId;
  final String? vatNumber;
  final String? registrationNumber;
  final double balance;
  final String? userId;
  final String syncStatus;
  final DateTime? serverUpdatedAt;
  final bool isDeleted;
  const Vendor(
      {required this.scopeKey,
      required this.uuid,
      required this.nameAr,
      required this.nameEn,
      this.phone,
      this.email,
      this.address,
      this.notes,
      required this.createdAt,
      required this.updatedAt,
      this.payableAccountId,
      this.vatNumber,
      this.registrationNumber,
      required this.balance,
      this.userId,
      required this.syncStatus,
      this.serverUpdatedAt,
      required this.isDeleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['scope_key'] = Variable<String>(scopeKey);
    map['uuid'] = Variable<String>(uuid);
    map['name_ar'] = Variable<String>(nameAr);
    map['name_en'] = Variable<String>(nameEn);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || payableAccountId != null) {
      map['payable_account_id'] = Variable<String>(payableAccountId);
    }
    if (!nullToAbsent || vatNumber != null) {
      map['vat_number'] = Variable<String>(vatNumber);
    }
    if (!nullToAbsent || registrationNumber != null) {
      map['registration_number'] = Variable<String>(registrationNumber);
    }
    map['balance'] = Variable<double>(balance);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || serverUpdatedAt != null) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt);
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  VendorsCompanion toCompanion(bool nullToAbsent) {
    return VendorsCompanion(
      scopeKey: Value(scopeKey),
      uuid: Value(uuid),
      nameAr: Value(nameAr),
      nameEn: Value(nameEn),
      phone:
          phone == null && nullToAbsent ? const Value.absent() : Value(phone),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      payableAccountId: payableAccountId == null && nullToAbsent
          ? const Value.absent()
          : Value(payableAccountId),
      vatNumber: vatNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(vatNumber),
      registrationNumber: registrationNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(registrationNumber),
      balance: Value(balance),
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
      syncStatus: Value(syncStatus),
      serverUpdatedAt: serverUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(serverUpdatedAt),
      isDeleted: Value(isDeleted),
    );
  }

  factory Vendor.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Vendor(
      scopeKey: serializer.fromJson<String>(json['scopeKey']),
      uuid: serializer.fromJson<String>(json['uuid']),
      nameAr: serializer.fromJson<String>(json['nameAr']),
      nameEn: serializer.fromJson<String>(json['nameEn']),
      phone: serializer.fromJson<String?>(json['phone']),
      email: serializer.fromJson<String?>(json['email']),
      address: serializer.fromJson<String?>(json['address']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      payableAccountId: serializer.fromJson<String?>(json['payableAccountId']),
      vatNumber: serializer.fromJson<String?>(json['vatNumber']),
      registrationNumber:
          serializer.fromJson<String?>(json['registrationNumber']),
      balance: serializer.fromJson<double>(json['balance']),
      userId: serializer.fromJson<String?>(json['userId']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      serverUpdatedAt: serializer.fromJson<DateTime?>(json['serverUpdatedAt']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'scopeKey': serializer.toJson<String>(scopeKey),
      'uuid': serializer.toJson<String>(uuid),
      'nameAr': serializer.toJson<String>(nameAr),
      'nameEn': serializer.toJson<String>(nameEn),
      'phone': serializer.toJson<String?>(phone),
      'email': serializer.toJson<String?>(email),
      'address': serializer.toJson<String?>(address),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'payableAccountId': serializer.toJson<String?>(payableAccountId),
      'vatNumber': serializer.toJson<String?>(vatNumber),
      'registrationNumber': serializer.toJson<String?>(registrationNumber),
      'balance': serializer.toJson<double>(balance),
      'userId': serializer.toJson<String?>(userId),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'serverUpdatedAt': serializer.toJson<DateTime?>(serverUpdatedAt),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  Vendor copyWith(
          {String? scopeKey,
          String? uuid,
          String? nameAr,
          String? nameEn,
          Value<String?> phone = const Value.absent(),
          Value<String?> email = const Value.absent(),
          Value<String?> address = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<String?> payableAccountId = const Value.absent(),
          Value<String?> vatNumber = const Value.absent(),
          Value<String?> registrationNumber = const Value.absent(),
          double? balance,
          Value<String?> userId = const Value.absent(),
          String? syncStatus,
          Value<DateTime?> serverUpdatedAt = const Value.absent(),
          bool? isDeleted}) =>
      Vendor(
        scopeKey: scopeKey ?? this.scopeKey,
        uuid: uuid ?? this.uuid,
        nameAr: nameAr ?? this.nameAr,
        nameEn: nameEn ?? this.nameEn,
        phone: phone.present ? phone.value : this.phone,
        email: email.present ? email.value : this.email,
        address: address.present ? address.value : this.address,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        payableAccountId: payableAccountId.present
            ? payableAccountId.value
            : this.payableAccountId,
        vatNumber: vatNumber.present ? vatNumber.value : this.vatNumber,
        registrationNumber: registrationNumber.present
            ? registrationNumber.value
            : this.registrationNumber,
        balance: balance ?? this.balance,
        userId: userId.present ? userId.value : this.userId,
        syncStatus: syncStatus ?? this.syncStatus,
        serverUpdatedAt: serverUpdatedAt.present
            ? serverUpdatedAt.value
            : this.serverUpdatedAt,
        isDeleted: isDeleted ?? this.isDeleted,
      );
  Vendor copyWithCompanion(VendorsCompanion data) {
    return Vendor(
      scopeKey: data.scopeKey.present ? data.scopeKey.value : this.scopeKey,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      nameAr: data.nameAr.present ? data.nameAr.value : this.nameAr,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
      address: data.address.present ? data.address.value : this.address,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      payableAccountId: data.payableAccountId.present
          ? data.payableAccountId.value
          : this.payableAccountId,
      vatNumber: data.vatNumber.present ? data.vatNumber.value : this.vatNumber,
      registrationNumber: data.registrationNumber.present
          ? data.registrationNumber.value
          : this.registrationNumber,
      balance: data.balance.present ? data.balance.value : this.balance,
      userId: data.userId.present ? data.userId.value : this.userId,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      serverUpdatedAt: data.serverUpdatedAt.present
          ? data.serverUpdatedAt.value
          : this.serverUpdatedAt,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Vendor(')
          ..write('scopeKey: $scopeKey, ')
          ..write('uuid: $uuid, ')
          ..write('nameAr: $nameAr, ')
          ..write('nameEn: $nameEn, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('address: $address, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('payableAccountId: $payableAccountId, ')
          ..write('vatNumber: $vatNumber, ')
          ..write('registrationNumber: $registrationNumber, ')
          ..write('balance: $balance, ')
          ..write('userId: $userId, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      scopeKey,
      uuid,
      nameAr,
      nameEn,
      phone,
      email,
      address,
      notes,
      createdAt,
      updatedAt,
      payableAccountId,
      vatNumber,
      registrationNumber,
      balance,
      userId,
      syncStatus,
      serverUpdatedAt,
      isDeleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Vendor &&
          other.scopeKey == this.scopeKey &&
          other.uuid == this.uuid &&
          other.nameAr == this.nameAr &&
          other.nameEn == this.nameEn &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.address == this.address &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.payableAccountId == this.payableAccountId &&
          other.vatNumber == this.vatNumber &&
          other.registrationNumber == this.registrationNumber &&
          other.balance == this.balance &&
          other.userId == this.userId &&
          other.syncStatus == this.syncStatus &&
          other.serverUpdatedAt == this.serverUpdatedAt &&
          other.isDeleted == this.isDeleted);
}

class VendorsCompanion extends UpdateCompanion<Vendor> {
  final Value<String> scopeKey;
  final Value<String> uuid;
  final Value<String> nameAr;
  final Value<String> nameEn;
  final Value<String?> phone;
  final Value<String?> email;
  final Value<String?> address;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String?> payableAccountId;
  final Value<String?> vatNumber;
  final Value<String?> registrationNumber;
  final Value<double> balance;
  final Value<String?> userId;
  final Value<String> syncStatus;
  final Value<DateTime?> serverUpdatedAt;
  final Value<bool> isDeleted;
  final Value<int> rowid;
  const VendorsCompanion({
    this.scopeKey = const Value.absent(),
    this.uuid = const Value.absent(),
    this.nameAr = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.address = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.payableAccountId = const Value.absent(),
    this.vatNumber = const Value.absent(),
    this.registrationNumber = const Value.absent(),
    this.balance = const Value.absent(),
    this.userId = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VendorsCompanion.insert({
    required String scopeKey,
    required String uuid,
    required String nameAr,
    required String nameEn,
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.address = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.payableAccountId = const Value.absent(),
    this.vatNumber = const Value.absent(),
    this.registrationNumber = const Value.absent(),
    this.balance = const Value.absent(),
    this.userId = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : scopeKey = Value(scopeKey),
        uuid = Value(uuid),
        nameAr = Value(nameAr),
        nameEn = Value(nameEn),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Vendor> custom({
    Expression<String>? scopeKey,
    Expression<String>? uuid,
    Expression<String>? nameAr,
    Expression<String>? nameEn,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<String>? address,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? payableAccountId,
    Expression<String>? vatNumber,
    Expression<String>? registrationNumber,
    Expression<double>? balance,
    Expression<String>? userId,
    Expression<String>? syncStatus,
    Expression<DateTime>? serverUpdatedAt,
    Expression<bool>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (scopeKey != null) 'scope_key': scopeKey,
      if (uuid != null) 'uuid': uuid,
      if (nameAr != null) 'name_ar': nameAr,
      if (nameEn != null) 'name_en': nameEn,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (address != null) 'address': address,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (payableAccountId != null) 'payable_account_id': payableAccountId,
      if (vatNumber != null) 'vat_number': vatNumber,
      if (registrationNumber != null) 'registration_number': registrationNumber,
      if (balance != null) 'balance': balance,
      if (userId != null) 'user_id': userId,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (serverUpdatedAt != null) 'server_updated_at': serverUpdatedAt,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VendorsCompanion copyWith(
      {Value<String>? scopeKey,
      Value<String>? uuid,
      Value<String>? nameAr,
      Value<String>? nameEn,
      Value<String?>? phone,
      Value<String?>? email,
      Value<String?>? address,
      Value<String?>? notes,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<String?>? payableAccountId,
      Value<String?>? vatNumber,
      Value<String?>? registrationNumber,
      Value<double>? balance,
      Value<String?>? userId,
      Value<String>? syncStatus,
      Value<DateTime?>? serverUpdatedAt,
      Value<bool>? isDeleted,
      Value<int>? rowid}) {
    return VendorsCompanion(
      scopeKey: scopeKey ?? this.scopeKey,
      uuid: uuid ?? this.uuid,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      payableAccountId: payableAccountId ?? this.payableAccountId,
      vatNumber: vatNumber ?? this.vatNumber,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      balance: balance ?? this.balance,
      userId: userId ?? this.userId,
      syncStatus: syncStatus ?? this.syncStatus,
      serverUpdatedAt: serverUpdatedAt ?? this.serverUpdatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (scopeKey.present) {
      map['scope_key'] = Variable<String>(scopeKey.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (nameAr.present) {
      map['name_ar'] = Variable<String>(nameAr.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (payableAccountId.present) {
      map['payable_account_id'] = Variable<String>(payableAccountId.value);
    }
    if (vatNumber.present) {
      map['vat_number'] = Variable<String>(vatNumber.value);
    }
    if (registrationNumber.present) {
      map['registration_number'] = Variable<String>(registrationNumber.value);
    }
    if (balance.present) {
      map['balance'] = Variable<double>(balance.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (serverUpdatedAt.present) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VendorsCompanion(')
          ..write('scopeKey: $scopeKey, ')
          ..write('uuid: $uuid, ')
          ..write('nameAr: $nameAr, ')
          ..write('nameEn: $nameEn, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('address: $address, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('payableAccountId: $payableAccountId, ')
          ..write('vatNumber: $vatNumber, ')
          ..write('registrationNumber: $registrationNumber, ')
          ..write('balance: $balance, ')
          ..write('userId: $userId, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WarehousesTable extends Warehouses
    with TableInfo<$WarehousesTable, Warehouse> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WarehousesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _scopeKeyMeta =
      const VerificationMeta('scopeKey');
  @override
  late final GeneratedColumn<String> scopeKey = GeneratedColumn<String>(
      'scope_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
      'uuid', aliasedName, false,
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
  static const VerificationMeta _locationMeta =
      const VerificationMeta('location');
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
      'location', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
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
  List<GeneratedColumn> get $columns =>
      [scopeKey, uuid, nameAr, nameEn, location, userId, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'warehouses';
  @override
  VerificationContext validateIntegrity(Insertable<Warehouse> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('scope_key')) {
      context.handle(_scopeKeyMeta,
          scopeKey.isAcceptableOrUnknown(data['scope_key']!, _scopeKeyMeta));
    } else if (isInserting) {
      context.missing(_scopeKeyMeta);
    }
    if (data.containsKey('uuid')) {
      context.handle(
          _uuidMeta, uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta));
    } else if (isInserting) {
      context.missing(_uuidMeta);
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
    if (data.containsKey('location')) {
      context.handle(_locationMeta,
          location.isAcceptableOrUnknown(data['location']!, _locationMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
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
  Set<GeneratedColumn> get $primaryKey => {scopeKey, uuid};
  @override
  Warehouse map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Warehouse(
      scopeKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}scope_key'])!,
      uuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uuid'])!,
      nameAr: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_ar'])!,
      nameEn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_en'])!,
      location: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}location']),
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $WarehousesTable createAlias(String alias) {
    return $WarehousesTable(attachedDatabase, alias);
  }
}

class Warehouse extends DataClass implements Insertable<Warehouse> {
  final String scopeKey;
  final String uuid;
  final String nameAr;
  final String nameEn;
  final String? location;
  final String? userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Warehouse(
      {required this.scopeKey,
      required this.uuid,
      required this.nameAr,
      required this.nameEn,
      this.location,
      this.userId,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['scope_key'] = Variable<String>(scopeKey);
    map['uuid'] = Variable<String>(uuid);
    map['name_ar'] = Variable<String>(nameAr);
    map['name_en'] = Variable<String>(nameEn);
    if (!nullToAbsent || location != null) {
      map['location'] = Variable<String>(location);
    }
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  WarehousesCompanion toCompanion(bool nullToAbsent) {
    return WarehousesCompanion(
      scopeKey: Value(scopeKey),
      uuid: Value(uuid),
      nameAr: Value(nameAr),
      nameEn: Value(nameEn),
      location: location == null && nullToAbsent
          ? const Value.absent()
          : Value(location),
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Warehouse.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Warehouse(
      scopeKey: serializer.fromJson<String>(json['scopeKey']),
      uuid: serializer.fromJson<String>(json['uuid']),
      nameAr: serializer.fromJson<String>(json['nameAr']),
      nameEn: serializer.fromJson<String>(json['nameEn']),
      location: serializer.fromJson<String?>(json['location']),
      userId: serializer.fromJson<String?>(json['userId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'scopeKey': serializer.toJson<String>(scopeKey),
      'uuid': serializer.toJson<String>(uuid),
      'nameAr': serializer.toJson<String>(nameAr),
      'nameEn': serializer.toJson<String>(nameEn),
      'location': serializer.toJson<String?>(location),
      'userId': serializer.toJson<String?>(userId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Warehouse copyWith(
          {String? scopeKey,
          String? uuid,
          String? nameAr,
          String? nameEn,
          Value<String?> location = const Value.absent(),
          Value<String?> userId = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Warehouse(
        scopeKey: scopeKey ?? this.scopeKey,
        uuid: uuid ?? this.uuid,
        nameAr: nameAr ?? this.nameAr,
        nameEn: nameEn ?? this.nameEn,
        location: location.present ? location.value : this.location,
        userId: userId.present ? userId.value : this.userId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Warehouse copyWithCompanion(WarehousesCompanion data) {
    return Warehouse(
      scopeKey: data.scopeKey.present ? data.scopeKey.value : this.scopeKey,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      nameAr: data.nameAr.present ? data.nameAr.value : this.nameAr,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
      location: data.location.present ? data.location.value : this.location,
      userId: data.userId.present ? data.userId.value : this.userId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Warehouse(')
          ..write('scopeKey: $scopeKey, ')
          ..write('uuid: $uuid, ')
          ..write('nameAr: $nameAr, ')
          ..write('nameEn: $nameEn, ')
          ..write('location: $location, ')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      scopeKey, uuid, nameAr, nameEn, location, userId, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Warehouse &&
          other.scopeKey == this.scopeKey &&
          other.uuid == this.uuid &&
          other.nameAr == this.nameAr &&
          other.nameEn == this.nameEn &&
          other.location == this.location &&
          other.userId == this.userId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class WarehousesCompanion extends UpdateCompanion<Warehouse> {
  final Value<String> scopeKey;
  final Value<String> uuid;
  final Value<String> nameAr;
  final Value<String> nameEn;
  final Value<String?> location;
  final Value<String?> userId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const WarehousesCompanion({
    this.scopeKey = const Value.absent(),
    this.uuid = const Value.absent(),
    this.nameAr = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.location = const Value.absent(),
    this.userId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WarehousesCompanion.insert({
    required String scopeKey,
    required String uuid,
    required String nameAr,
    required String nameEn,
    this.location = const Value.absent(),
    this.userId = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : scopeKey = Value(scopeKey),
        uuid = Value(uuid),
        nameAr = Value(nameAr),
        nameEn = Value(nameEn),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Warehouse> custom({
    Expression<String>? scopeKey,
    Expression<String>? uuid,
    Expression<String>? nameAr,
    Expression<String>? nameEn,
    Expression<String>? location,
    Expression<String>? userId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (scopeKey != null) 'scope_key': scopeKey,
      if (uuid != null) 'uuid': uuid,
      if (nameAr != null) 'name_ar': nameAr,
      if (nameEn != null) 'name_en': nameEn,
      if (location != null) 'location': location,
      if (userId != null) 'user_id': userId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WarehousesCompanion copyWith(
      {Value<String>? scopeKey,
      Value<String>? uuid,
      Value<String>? nameAr,
      Value<String>? nameEn,
      Value<String?>? location,
      Value<String?>? userId,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return WarehousesCompanion(
      scopeKey: scopeKey ?? this.scopeKey,
      uuid: uuid ?? this.uuid,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
      location: location ?? this.location,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (scopeKey.present) {
      map['scope_key'] = Variable<String>(scopeKey.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (nameAr.present) {
      map['name_ar'] = Variable<String>(nameAr.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
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
    return (StringBuffer('WarehousesCompanion(')
          ..write('scopeKey: $scopeKey, ')
          ..write('uuid: $uuid, ')
          ..write('nameAr: $nameAr, ')
          ..write('nameEn: $nameEn, ')
          ..write('location: $location, ')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncOutboxTable extends SyncOutbox
    with TableInfo<$SyncOutboxTable, SyncOutboxData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncOutboxTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entityTypeMeta =
      const VerificationMeta('entityType');
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
      'entity_type', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 64),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _entityIdMeta =
      const VerificationMeta('entityId');
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
      'entity_id', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 128),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _operationMeta =
      const VerificationMeta('operation');
  @override
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
      'operation', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 16),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _payloadJsonMeta =
      const VerificationMeta('payloadJson');
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
      'payload_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _attemptCountMeta =
      const VerificationMeta('attemptCount');
  @override
  late final GeneratedColumn<int> attemptCount = GeneratedColumn<int>(
      'attempt_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _nextAttemptAtMeta =
      const VerificationMeta('nextAttemptAt');
  @override
  late final GeneratedColumn<DateTime> nextAttemptAt =
      GeneratedColumn<DateTime>('next_attempt_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _lastErrorMeta =
      const VerificationMeta('lastError');
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
      'last_error', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        entityType,
        entityId,
        operation,
        payloadJson,
        attemptCount,
        nextAttemptAt,
        lastError,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_outbox';
  @override
  VerificationContext validateIntegrity(Insertable<SyncOutboxData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
          _entityTypeMeta,
          entityType.isAcceptableOrUnknown(
              data['entity_type']!, _entityTypeMeta));
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(_entityIdMeta,
          entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta));
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('operation')) {
      context.handle(_operationMeta,
          operation.isAcceptableOrUnknown(data['operation']!, _operationMeta));
    } else if (isInserting) {
      context.missing(_operationMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
          _payloadJsonMeta,
          payloadJson.isAcceptableOrUnknown(
              data['payload_json']!, _payloadJsonMeta));
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('attempt_count')) {
      context.handle(
          _attemptCountMeta,
          attemptCount.isAcceptableOrUnknown(
              data['attempt_count']!, _attemptCountMeta));
    }
    if (data.containsKey('next_attempt_at')) {
      context.handle(
          _nextAttemptAtMeta,
          nextAttemptAt.isAcceptableOrUnknown(
              data['next_attempt_at']!, _nextAttemptAtMeta));
    }
    if (data.containsKey('last_error')) {
      context.handle(_lastErrorMeta,
          lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {entityType, entityId, operation},
      ];
  @override
  SyncOutboxData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncOutboxData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      entityType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_type'])!,
      entityId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_id'])!,
      operation: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}operation'])!,
      payloadJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payload_json'])!,
      attemptCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}attempt_count'])!,
      nextAttemptAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}next_attempt_at']),
      lastError: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_error']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $SyncOutboxTable createAlias(String alias) {
    return $SyncOutboxTable(attachedDatabase, alias);
  }
}

class SyncOutboxData extends DataClass implements Insertable<SyncOutboxData> {
  final String id;
  final String entityType;
  final String entityId;
  final String operation;
  final String payloadJson;
  final int attemptCount;
  final DateTime? nextAttemptAt;
  final String? lastError;
  final DateTime createdAt;
  final DateTime updatedAt;
  const SyncOutboxData(
      {required this.id,
      required this.entityType,
      required this.entityId,
      required this.operation,
      required this.payloadJson,
      required this.attemptCount,
      this.nextAttemptAt,
      this.lastError,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['operation'] = Variable<String>(operation);
    map['payload_json'] = Variable<String>(payloadJson);
    map['attempt_count'] = Variable<int>(attemptCount);
    if (!nullToAbsent || nextAttemptAt != null) {
      map['next_attempt_at'] = Variable<DateTime>(nextAttemptAt);
    }
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SyncOutboxCompanion toCompanion(bool nullToAbsent) {
    return SyncOutboxCompanion(
      id: Value(id),
      entityType: Value(entityType),
      entityId: Value(entityId),
      operation: Value(operation),
      payloadJson: Value(payloadJson),
      attemptCount: Value(attemptCount),
      nextAttemptAt: nextAttemptAt == null && nullToAbsent
          ? const Value.absent()
          : Value(nextAttemptAt),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SyncOutboxData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncOutboxData(
      id: serializer.fromJson<String>(json['id']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      operation: serializer.fromJson<String>(json['operation']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      attemptCount: serializer.fromJson<int>(json['attemptCount']),
      nextAttemptAt: serializer.fromJson<DateTime?>(json['nextAttemptAt']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'operation': serializer.toJson<String>(operation),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'attemptCount': serializer.toJson<int>(attemptCount),
      'nextAttemptAt': serializer.toJson<DateTime?>(nextAttemptAt),
      'lastError': serializer.toJson<String?>(lastError),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SyncOutboxData copyWith(
          {String? id,
          String? entityType,
          String? entityId,
          String? operation,
          String? payloadJson,
          int? attemptCount,
          Value<DateTime?> nextAttemptAt = const Value.absent(),
          Value<String?> lastError = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      SyncOutboxData(
        id: id ?? this.id,
        entityType: entityType ?? this.entityType,
        entityId: entityId ?? this.entityId,
        operation: operation ?? this.operation,
        payloadJson: payloadJson ?? this.payloadJson,
        attemptCount: attemptCount ?? this.attemptCount,
        nextAttemptAt:
            nextAttemptAt.present ? nextAttemptAt.value : this.nextAttemptAt,
        lastError: lastError.present ? lastError.value : this.lastError,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  SyncOutboxData copyWithCompanion(SyncOutboxCompanion data) {
    return SyncOutboxData(
      id: data.id.present ? data.id.value : this.id,
      entityType:
          data.entityType.present ? data.entityType.value : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      operation: data.operation.present ? data.operation.value : this.operation,
      payloadJson:
          data.payloadJson.present ? data.payloadJson.value : this.payloadJson,
      attemptCount: data.attemptCount.present
          ? data.attemptCount.value
          : this.attemptCount,
      nextAttemptAt: data.nextAttemptAt.present
          ? data.nextAttemptAt.value
          : this.nextAttemptAt,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncOutboxData(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('operation: $operation, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('attemptCount: $attemptCount, ')
          ..write('nextAttemptAt: $nextAttemptAt, ')
          ..write('lastError: $lastError, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      entityType,
      entityId,
      operation,
      payloadJson,
      attemptCount,
      nextAttemptAt,
      lastError,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncOutboxData &&
          other.id == this.id &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.operation == this.operation &&
          other.payloadJson == this.payloadJson &&
          other.attemptCount == this.attemptCount &&
          other.nextAttemptAt == this.nextAttemptAt &&
          other.lastError == this.lastError &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SyncOutboxCompanion extends UpdateCompanion<SyncOutboxData> {
  final Value<String> id;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String> operation;
  final Value<String> payloadJson;
  final Value<int> attemptCount;
  final Value<DateTime?> nextAttemptAt;
  final Value<String?> lastError;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SyncOutboxCompanion({
    this.id = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.operation = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.attemptCount = const Value.absent(),
    this.nextAttemptAt = const Value.absent(),
    this.lastError = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncOutboxCompanion.insert({
    required String id,
    required String entityType,
    required String entityId,
    required String operation,
    required String payloadJson,
    this.attemptCount = const Value.absent(),
    this.nextAttemptAt = const Value.absent(),
    this.lastError = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        entityType = Value(entityType),
        entityId = Value(entityId),
        operation = Value(operation),
        payloadJson = Value(payloadJson);
  static Insertable<SyncOutboxData> custom({
    Expression<String>? id,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? operation,
    Expression<String>? payloadJson,
    Expression<int>? attemptCount,
    Expression<DateTime>? nextAttemptAt,
    Expression<String>? lastError,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (operation != null) 'operation': operation,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (attemptCount != null) 'attempt_count': attemptCount,
      if (nextAttemptAt != null) 'next_attempt_at': nextAttemptAt,
      if (lastError != null) 'last_error': lastError,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncOutboxCompanion copyWith(
      {Value<String>? id,
      Value<String>? entityType,
      Value<String>? entityId,
      Value<String>? operation,
      Value<String>? payloadJson,
      Value<int>? attemptCount,
      Value<DateTime?>? nextAttemptAt,
      Value<String?>? lastError,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return SyncOutboxCompanion(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      operation: operation ?? this.operation,
      payloadJson: payloadJson ?? this.payloadJson,
      attemptCount: attemptCount ?? this.attemptCount,
      nextAttemptAt: nextAttemptAt ?? this.nextAttemptAt,
      lastError: lastError ?? this.lastError,
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
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (attemptCount.present) {
      map['attempt_count'] = Variable<int>(attemptCount.value);
    }
    if (nextAttemptAt.present) {
      map['next_attempt_at'] = Variable<DateTime>(nextAttemptAt.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
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
    return (StringBuffer('SyncOutboxCompanion(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('operation: $operation, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('attemptCount: $attemptCount, ')
          ..write('nextAttemptAt: $nextAttemptAt, ')
          ..write('lastError: $lastError, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$BasirDatabase extends GeneratedDatabase {
  _$BasirDatabase(QueryExecutor e) : super(e);
  $BasirDatabaseManager get managers => $BasirDatabaseManager(this);
  late final $LocalMetadataTable localMetadata = $LocalMetadataTable(this);
  late final $BarcodeConfigsTable barcodeConfigs = $BarcodeConfigsTable(this);
  late final $MarketPricesTable marketPrices = $MarketPricesTable(this);
  late final $ProfilesTable profiles = $ProfilesTable(this);
  late final $BusinessSettingsTable businessSettings =
      $BusinessSettingsTable(this);
  late final $GoalsTable goals = $GoalsTable(this);
  late final $BudgetsTable budgets = $BudgetsTable(this);
  late final $CustomersTable customers = $CustomersTable(this);
  late final $VendorsTable vendors = $VendorsTable(this);
  late final $WarehousesTable warehouses = $WarehousesTable(this);
  late final $SyncOutboxTable syncOutbox = $SyncOutboxTable(this);
  late final Index marketPricesItemAsOfIdx = Index(
      'market_prices_item_as_of_idx',
      'CREATE INDEX market_prices_item_as_of_idx ON market_prices (item_id, as_of_date)');
  late final Index customersScopeNameArIdx = Index(
      'customers_scope_name_ar_idx',
      'CREATE INDEX customers_scope_name_ar_idx ON customers (scope_key, name_ar)');
  late final Index customersScopeNameEnIdx = Index(
      'customers_scope_name_en_idx',
      'CREATE INDEX customers_scope_name_en_idx ON customers (scope_key, name_en)');
  late final Index vendorsScopeNameArIdx = Index('vendors_scope_name_ar_idx',
      'CREATE INDEX vendors_scope_name_ar_idx ON vendors (scope_key, name_ar)');
  late final Index vendorsScopeNameEnIdx = Index('vendors_scope_name_en_idx',
      'CREATE INDEX vendors_scope_name_en_idx ON vendors (scope_key, name_en)');
  late final Index warehousesScopeNameArIdx = Index(
      'warehouses_scope_name_ar_idx',
      'CREATE INDEX warehouses_scope_name_ar_idx ON warehouses (scope_key, name_ar)');
  late final Index warehousesScopeNameEnIdx = Index(
      'warehouses_scope_name_en_idx',
      'CREATE INDEX warehouses_scope_name_en_idx ON warehouses (scope_key, name_en)');
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        localMetadata,
        barcodeConfigs,
        marketPrices,
        profiles,
        businessSettings,
        goals,
        budgets,
        customers,
        vendors,
        warehouses,
        syncOutbox,
        marketPricesItemAsOfIdx,
        customersScopeNameArIdx,
        customersScopeNameEnIdx,
        vendorsScopeNameArIdx,
        vendorsScopeNameEnIdx,
        warehousesScopeNameArIdx,
        warehousesScopeNameEnIdx
      ];
}

typedef $$LocalMetadataTableCreateCompanionBuilder = LocalMetadataCompanion
    Function({
  required String key,
  required String valueJson,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$LocalMetadataTableUpdateCompanionBuilder = LocalMetadataCompanion
    Function({
  Value<String> key,
  Value<String> valueJson,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$LocalMetadataTableFilterComposer
    extends Composer<_$BasirDatabase, $LocalMetadataTable> {
  $$LocalMetadataTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get valueJson => $composableBuilder(
      column: $table.valueJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$LocalMetadataTableOrderingComposer
    extends Composer<_$BasirDatabase, $LocalMetadataTable> {
  $$LocalMetadataTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get valueJson => $composableBuilder(
      column: $table.valueJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$LocalMetadataTableAnnotationComposer
    extends Composer<_$BasirDatabase, $LocalMetadataTable> {
  $$LocalMetadataTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get valueJson =>
      $composableBuilder(column: $table.valueJson, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LocalMetadataTableTableManager extends RootTableManager<
    _$BasirDatabase,
    $LocalMetadataTable,
    LocalMetadataData,
    $$LocalMetadataTableFilterComposer,
    $$LocalMetadataTableOrderingComposer,
    $$LocalMetadataTableAnnotationComposer,
    $$LocalMetadataTableCreateCompanionBuilder,
    $$LocalMetadataTableUpdateCompanionBuilder,
    (
      LocalMetadataData,
      BaseReferences<_$BasirDatabase, $LocalMetadataTable, LocalMetadataData>
    ),
    LocalMetadataData,
    PrefetchHooks Function()> {
  $$LocalMetadataTableTableManager(
      _$BasirDatabase db, $LocalMetadataTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalMetadataTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalMetadataTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalMetadataTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> valueJson = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalMetadataCompanion(
            key: key,
            valueJson: valueJson,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String key,
            required String valueJson,
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalMetadataCompanion.insert(
            key: key,
            valueJson: valueJson,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LocalMetadataTableProcessedTableManager = ProcessedTableManager<
    _$BasirDatabase,
    $LocalMetadataTable,
    LocalMetadataData,
    $$LocalMetadataTableFilterComposer,
    $$LocalMetadataTableOrderingComposer,
    $$LocalMetadataTableAnnotationComposer,
    $$LocalMetadataTableCreateCompanionBuilder,
    $$LocalMetadataTableUpdateCompanionBuilder,
    (
      LocalMetadataData,
      BaseReferences<_$BasirDatabase, $LocalMetadataTable, LocalMetadataData>
    ),
    LocalMetadataData,
    PrefetchHooks Function()>;
typedef $$BarcodeConfigsTableCreateCompanionBuilder = BarcodeConfigsCompanion
    Function({
  required String id,
  Value<String> printerType,
  Value<int> columnsPerRow,
  Value<double> heightMm,
  Value<double> widthMm,
  Value<double> marginMm,
  Value<bool> showItemName,
  Value<bool> showPrice,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$BarcodeConfigsTableUpdateCompanionBuilder = BarcodeConfigsCompanion
    Function({
  Value<String> id,
  Value<String> printerType,
  Value<int> columnsPerRow,
  Value<double> heightMm,
  Value<double> widthMm,
  Value<double> marginMm,
  Value<bool> showItemName,
  Value<bool> showPrice,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$BarcodeConfigsTableFilterComposer
    extends Composer<_$BasirDatabase, $BarcodeConfigsTable> {
  $$BarcodeConfigsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get printerType => $composableBuilder(
      column: $table.printerType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get columnsPerRow => $composableBuilder(
      column: $table.columnsPerRow, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get heightMm => $composableBuilder(
      column: $table.heightMm, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get widthMm => $composableBuilder(
      column: $table.widthMm, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get marginMm => $composableBuilder(
      column: $table.marginMm, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get showItemName => $composableBuilder(
      column: $table.showItemName, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get showPrice => $composableBuilder(
      column: $table.showPrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$BarcodeConfigsTableOrderingComposer
    extends Composer<_$BasirDatabase, $BarcodeConfigsTable> {
  $$BarcodeConfigsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get printerType => $composableBuilder(
      column: $table.printerType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get columnsPerRow => $composableBuilder(
      column: $table.columnsPerRow,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get heightMm => $composableBuilder(
      column: $table.heightMm, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get widthMm => $composableBuilder(
      column: $table.widthMm, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get marginMm => $composableBuilder(
      column: $table.marginMm, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get showItemName => $composableBuilder(
      column: $table.showItemName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get showPrice => $composableBuilder(
      column: $table.showPrice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$BarcodeConfigsTableAnnotationComposer
    extends Composer<_$BasirDatabase, $BarcodeConfigsTable> {
  $$BarcodeConfigsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get printerType => $composableBuilder(
      column: $table.printerType, builder: (column) => column);

  GeneratedColumn<int> get columnsPerRow => $composableBuilder(
      column: $table.columnsPerRow, builder: (column) => column);

  GeneratedColumn<double> get heightMm =>
      $composableBuilder(column: $table.heightMm, builder: (column) => column);

  GeneratedColumn<double> get widthMm =>
      $composableBuilder(column: $table.widthMm, builder: (column) => column);

  GeneratedColumn<double> get marginMm =>
      $composableBuilder(column: $table.marginMm, builder: (column) => column);

  GeneratedColumn<bool> get showItemName => $composableBuilder(
      column: $table.showItemName, builder: (column) => column);

  GeneratedColumn<bool> get showPrice =>
      $composableBuilder(column: $table.showPrice, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$BarcodeConfigsTableTableManager extends RootTableManager<
    _$BasirDatabase,
    $BarcodeConfigsTable,
    BarcodeConfig,
    $$BarcodeConfigsTableFilterComposer,
    $$BarcodeConfigsTableOrderingComposer,
    $$BarcodeConfigsTableAnnotationComposer,
    $$BarcodeConfigsTableCreateCompanionBuilder,
    $$BarcodeConfigsTableUpdateCompanionBuilder,
    (
      BarcodeConfig,
      BaseReferences<_$BasirDatabase, $BarcodeConfigsTable, BarcodeConfig>
    ),
    BarcodeConfig,
    PrefetchHooks Function()> {
  $$BarcodeConfigsTableTableManager(
      _$BasirDatabase db, $BarcodeConfigsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BarcodeConfigsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BarcodeConfigsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BarcodeConfigsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> printerType = const Value.absent(),
            Value<int> columnsPerRow = const Value.absent(),
            Value<double> heightMm = const Value.absent(),
            Value<double> widthMm = const Value.absent(),
            Value<double> marginMm = const Value.absent(),
            Value<bool> showItemName = const Value.absent(),
            Value<bool> showPrice = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BarcodeConfigsCompanion(
            id: id,
            printerType: printerType,
            columnsPerRow: columnsPerRow,
            heightMm: heightMm,
            widthMm: widthMm,
            marginMm: marginMm,
            showItemName: showItemName,
            showPrice: showPrice,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String> printerType = const Value.absent(),
            Value<int> columnsPerRow = const Value.absent(),
            Value<double> heightMm = const Value.absent(),
            Value<double> widthMm = const Value.absent(),
            Value<double> marginMm = const Value.absent(),
            Value<bool> showItemName = const Value.absent(),
            Value<bool> showPrice = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BarcodeConfigsCompanion.insert(
            id: id,
            printerType: printerType,
            columnsPerRow: columnsPerRow,
            heightMm: heightMm,
            widthMm: widthMm,
            marginMm: marginMm,
            showItemName: showItemName,
            showPrice: showPrice,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BarcodeConfigsTableProcessedTableManager = ProcessedTableManager<
    _$BasirDatabase,
    $BarcodeConfigsTable,
    BarcodeConfig,
    $$BarcodeConfigsTableFilterComposer,
    $$BarcodeConfigsTableOrderingComposer,
    $$BarcodeConfigsTableAnnotationComposer,
    $$BarcodeConfigsTableCreateCompanionBuilder,
    $$BarcodeConfigsTableUpdateCompanionBuilder,
    (
      BarcodeConfig,
      BaseReferences<_$BasirDatabase, $BarcodeConfigsTable, BarcodeConfig>
    ),
    BarcodeConfig,
    PrefetchHooks Function()>;
typedef $$MarketPricesTableCreateCompanionBuilder = MarketPricesCompanion
    Function({
  required String id,
  required String itemId,
  required double price,
  required DateTime asOfDate,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$MarketPricesTableUpdateCompanionBuilder = MarketPricesCompanion
    Function({
  Value<String> id,
  Value<String> itemId,
  Value<double> price,
  Value<DateTime> asOfDate,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$MarketPricesTableFilterComposer
    extends Composer<_$BasirDatabase, $MarketPricesTable> {
  $$MarketPricesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get itemId => $composableBuilder(
      column: $table.itemId, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get asOfDate => $composableBuilder(
      column: $table.asOfDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$MarketPricesTableOrderingComposer
    extends Composer<_$BasirDatabase, $MarketPricesTable> {
  $$MarketPricesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get itemId => $composableBuilder(
      column: $table.itemId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get asOfDate => $composableBuilder(
      column: $table.asOfDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$MarketPricesTableAnnotationComposer
    extends Composer<_$BasirDatabase, $MarketPricesTable> {
  $$MarketPricesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<DateTime> get asOfDate =>
      $composableBuilder(column: $table.asOfDate, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$MarketPricesTableTableManager extends RootTableManager<
    _$BasirDatabase,
    $MarketPricesTable,
    MarketPrice,
    $$MarketPricesTableFilterComposer,
    $$MarketPricesTableOrderingComposer,
    $$MarketPricesTableAnnotationComposer,
    $$MarketPricesTableCreateCompanionBuilder,
    $$MarketPricesTableUpdateCompanionBuilder,
    (
      MarketPrice,
      BaseReferences<_$BasirDatabase, $MarketPricesTable, MarketPrice>
    ),
    MarketPrice,
    PrefetchHooks Function()> {
  $$MarketPricesTableTableManager(_$BasirDatabase db, $MarketPricesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MarketPricesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MarketPricesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MarketPricesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> itemId = const Value.absent(),
            Value<double> price = const Value.absent(),
            Value<DateTime> asOfDate = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MarketPricesCompanion(
            id: id,
            itemId: itemId,
            price: price,
            asOfDate: asOfDate,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String itemId,
            required double price,
            required DateTime asOfDate,
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              MarketPricesCompanion.insert(
            id: id,
            itemId: itemId,
            price: price,
            asOfDate: asOfDate,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MarketPricesTableProcessedTableManager = ProcessedTableManager<
    _$BasirDatabase,
    $MarketPricesTable,
    MarketPrice,
    $$MarketPricesTableFilterComposer,
    $$MarketPricesTableOrderingComposer,
    $$MarketPricesTableAnnotationComposer,
    $$MarketPricesTableCreateCompanionBuilder,
    $$MarketPricesTableUpdateCompanionBuilder,
    (
      MarketPrice,
      BaseReferences<_$BasirDatabase, $MarketPricesTable, MarketPrice>
    ),
    MarketPrice,
    PrefetchHooks Function()>;
typedef $$ProfilesTableCreateCompanionBuilder = ProfilesCompanion Function({
  required String scopeKey,
  required String id,
  required String email,
  Value<String?> displayName,
  Value<String?> avatarUrl,
  Value<String?> phoneNumber,
  Value<String?> userId,
  Value<String> syncStatus,
  Value<DateTime?> serverUpdatedAt,
  Value<bool> isDeleted,
  Value<int> rowid,
});
typedef $$ProfilesTableUpdateCompanionBuilder = ProfilesCompanion Function({
  Value<String> scopeKey,
  Value<String> id,
  Value<String> email,
  Value<String?> displayName,
  Value<String?> avatarUrl,
  Value<String?> phoneNumber,
  Value<String?> userId,
  Value<String> syncStatus,
  Value<DateTime?> serverUpdatedAt,
  Value<bool> isDeleted,
  Value<int> rowid,
});

class $$ProfilesTableFilterComposer
    extends Composer<_$BasirDatabase, $ProfilesTable> {
  $$ProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get scopeKey => $composableBuilder(
      column: $table.scopeKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get avatarUrl => $composableBuilder(
      column: $table.avatarUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phoneNumber => $composableBuilder(
      column: $table.phoneNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get serverUpdatedAt => $composableBuilder(
      column: $table.serverUpdatedAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnFilters(column));
}

class $$ProfilesTableOrderingComposer
    extends Composer<_$BasirDatabase, $ProfilesTable> {
  $$ProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get scopeKey => $composableBuilder(
      column: $table.scopeKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get avatarUrl => $composableBuilder(
      column: $table.avatarUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phoneNumber => $composableBuilder(
      column: $table.phoneNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get serverUpdatedAt => $composableBuilder(
      column: $table.serverUpdatedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnOrderings(column));
}

class $$ProfilesTableAnnotationComposer
    extends Composer<_$BasirDatabase, $ProfilesTable> {
  $$ProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get scopeKey =>
      $composableBuilder(column: $table.scopeKey, builder: (column) => column);

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => column);

  GeneratedColumn<String> get avatarUrl =>
      $composableBuilder(column: $table.avatarUrl, builder: (column) => column);

  GeneratedColumn<String> get phoneNumber => $composableBuilder(
      column: $table.phoneNumber, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);

  GeneratedColumn<DateTime> get serverUpdatedAt => $composableBuilder(
      column: $table.serverUpdatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$ProfilesTableTableManager extends RootTableManager<
    _$BasirDatabase,
    $ProfilesTable,
    Profile,
    $$ProfilesTableFilterComposer,
    $$ProfilesTableOrderingComposer,
    $$ProfilesTableAnnotationComposer,
    $$ProfilesTableCreateCompanionBuilder,
    $$ProfilesTableUpdateCompanionBuilder,
    (Profile, BaseReferences<_$BasirDatabase, $ProfilesTable, Profile>),
    Profile,
    PrefetchHooks Function()> {
  $$ProfilesTableTableManager(_$BasirDatabase db, $ProfilesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> scopeKey = const Value.absent(),
            Value<String> id = const Value.absent(),
            Value<String> email = const Value.absent(),
            Value<String?> displayName = const Value.absent(),
            Value<String?> avatarUrl = const Value.absent(),
            Value<String?> phoneNumber = const Value.absent(),
            Value<String?> userId = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<DateTime?> serverUpdatedAt = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProfilesCompanion(
            scopeKey: scopeKey,
            id: id,
            email: email,
            displayName: displayName,
            avatarUrl: avatarUrl,
            phoneNumber: phoneNumber,
            userId: userId,
            syncStatus: syncStatus,
            serverUpdatedAt: serverUpdatedAt,
            isDeleted: isDeleted,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String scopeKey,
            required String id,
            required String email,
            Value<String?> displayName = const Value.absent(),
            Value<String?> avatarUrl = const Value.absent(),
            Value<String?> phoneNumber = const Value.absent(),
            Value<String?> userId = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<DateTime?> serverUpdatedAt = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProfilesCompanion.insert(
            scopeKey: scopeKey,
            id: id,
            email: email,
            displayName: displayName,
            avatarUrl: avatarUrl,
            phoneNumber: phoneNumber,
            userId: userId,
            syncStatus: syncStatus,
            serverUpdatedAt: serverUpdatedAt,
            isDeleted: isDeleted,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ProfilesTableProcessedTableManager = ProcessedTableManager<
    _$BasirDatabase,
    $ProfilesTable,
    Profile,
    $$ProfilesTableFilterComposer,
    $$ProfilesTableOrderingComposer,
    $$ProfilesTableAnnotationComposer,
    $$ProfilesTableCreateCompanionBuilder,
    $$ProfilesTableUpdateCompanionBuilder,
    (Profile, BaseReferences<_$BasirDatabase, $ProfilesTable, Profile>),
    Profile,
    PrefetchHooks Function()>;
typedef $$BusinessSettingsTableCreateCompanionBuilder
    = BusinessSettingsCompanion Function({
  required String scopeKey,
  required String id,
  required String companyName,
  Value<String?> taxNumber,
  Value<String?> address,
  Value<String?> logoUrl,
  required double defaultTaxRate,
  required String currencyCode,
  required String currencySymbol,
  Value<String?> userId,
  Value<String> syncStatus,
  Value<DateTime?> serverUpdatedAt,
  Value<bool> isDeleted,
  Value<int> rowid,
});
typedef $$BusinessSettingsTableUpdateCompanionBuilder
    = BusinessSettingsCompanion Function({
  Value<String> scopeKey,
  Value<String> id,
  Value<String> companyName,
  Value<String?> taxNumber,
  Value<String?> address,
  Value<String?> logoUrl,
  Value<double> defaultTaxRate,
  Value<String> currencyCode,
  Value<String> currencySymbol,
  Value<String?> userId,
  Value<String> syncStatus,
  Value<DateTime?> serverUpdatedAt,
  Value<bool> isDeleted,
  Value<int> rowid,
});

class $$BusinessSettingsTableFilterComposer
    extends Composer<_$BasirDatabase, $BusinessSettingsTable> {
  $$BusinessSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get scopeKey => $composableBuilder(
      column: $table.scopeKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get companyName => $composableBuilder(
      column: $table.companyName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get taxNumber => $composableBuilder(
      column: $table.taxNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get logoUrl => $composableBuilder(
      column: $table.logoUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get defaultTaxRate => $composableBuilder(
      column: $table.defaultTaxRate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currencyCode => $composableBuilder(
      column: $table.currencyCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currencySymbol => $composableBuilder(
      column: $table.currencySymbol,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get serverUpdatedAt => $composableBuilder(
      column: $table.serverUpdatedAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnFilters(column));
}

class $$BusinessSettingsTableOrderingComposer
    extends Composer<_$BasirDatabase, $BusinessSettingsTable> {
  $$BusinessSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get scopeKey => $composableBuilder(
      column: $table.scopeKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get companyName => $composableBuilder(
      column: $table.companyName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get taxNumber => $composableBuilder(
      column: $table.taxNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get logoUrl => $composableBuilder(
      column: $table.logoUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get defaultTaxRate => $composableBuilder(
      column: $table.defaultTaxRate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currencyCode => $composableBuilder(
      column: $table.currencyCode,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currencySymbol => $composableBuilder(
      column: $table.currencySymbol,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get serverUpdatedAt => $composableBuilder(
      column: $table.serverUpdatedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnOrderings(column));
}

class $$BusinessSettingsTableAnnotationComposer
    extends Composer<_$BasirDatabase, $BusinessSettingsTable> {
  $$BusinessSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get scopeKey =>
      $composableBuilder(column: $table.scopeKey, builder: (column) => column);

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get companyName => $composableBuilder(
      column: $table.companyName, builder: (column) => column);

  GeneratedColumn<String> get taxNumber =>
      $composableBuilder(column: $table.taxNumber, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get logoUrl =>
      $composableBuilder(column: $table.logoUrl, builder: (column) => column);

  GeneratedColumn<double> get defaultTaxRate => $composableBuilder(
      column: $table.defaultTaxRate, builder: (column) => column);

  GeneratedColumn<String> get currencyCode => $composableBuilder(
      column: $table.currencyCode, builder: (column) => column);

  GeneratedColumn<String> get currencySymbol => $composableBuilder(
      column: $table.currencySymbol, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);

  GeneratedColumn<DateTime> get serverUpdatedAt => $composableBuilder(
      column: $table.serverUpdatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$BusinessSettingsTableTableManager extends RootTableManager<
    _$BasirDatabase,
    $BusinessSettingsTable,
    BusinessSetting,
    $$BusinessSettingsTableFilterComposer,
    $$BusinessSettingsTableOrderingComposer,
    $$BusinessSettingsTableAnnotationComposer,
    $$BusinessSettingsTableCreateCompanionBuilder,
    $$BusinessSettingsTableUpdateCompanionBuilder,
    (
      BusinessSetting,
      BaseReferences<_$BasirDatabase, $BusinessSettingsTable, BusinessSetting>
    ),
    BusinessSetting,
    PrefetchHooks Function()> {
  $$BusinessSettingsTableTableManager(
      _$BasirDatabase db, $BusinessSettingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BusinessSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BusinessSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BusinessSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> scopeKey = const Value.absent(),
            Value<String> id = const Value.absent(),
            Value<String> companyName = const Value.absent(),
            Value<String?> taxNumber = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String?> logoUrl = const Value.absent(),
            Value<double> defaultTaxRate = const Value.absent(),
            Value<String> currencyCode = const Value.absent(),
            Value<String> currencySymbol = const Value.absent(),
            Value<String?> userId = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<DateTime?> serverUpdatedAt = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BusinessSettingsCompanion(
            scopeKey: scopeKey,
            id: id,
            companyName: companyName,
            taxNumber: taxNumber,
            address: address,
            logoUrl: logoUrl,
            defaultTaxRate: defaultTaxRate,
            currencyCode: currencyCode,
            currencySymbol: currencySymbol,
            userId: userId,
            syncStatus: syncStatus,
            serverUpdatedAt: serverUpdatedAt,
            isDeleted: isDeleted,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String scopeKey,
            required String id,
            required String companyName,
            Value<String?> taxNumber = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String?> logoUrl = const Value.absent(),
            required double defaultTaxRate,
            required String currencyCode,
            required String currencySymbol,
            Value<String?> userId = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<DateTime?> serverUpdatedAt = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BusinessSettingsCompanion.insert(
            scopeKey: scopeKey,
            id: id,
            companyName: companyName,
            taxNumber: taxNumber,
            address: address,
            logoUrl: logoUrl,
            defaultTaxRate: defaultTaxRate,
            currencyCode: currencyCode,
            currencySymbol: currencySymbol,
            userId: userId,
            syncStatus: syncStatus,
            serverUpdatedAt: serverUpdatedAt,
            isDeleted: isDeleted,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BusinessSettingsTableProcessedTableManager = ProcessedTableManager<
    _$BasirDatabase,
    $BusinessSettingsTable,
    BusinessSetting,
    $$BusinessSettingsTableFilterComposer,
    $$BusinessSettingsTableOrderingComposer,
    $$BusinessSettingsTableAnnotationComposer,
    $$BusinessSettingsTableCreateCompanionBuilder,
    $$BusinessSettingsTableUpdateCompanionBuilder,
    (
      BusinessSetting,
      BaseReferences<_$BasirDatabase, $BusinessSettingsTable, BusinessSetting>
    ),
    BusinessSetting,
    PrefetchHooks Function()>;
typedef $$GoalsTableCreateCompanionBuilder = GoalsCompanion Function({
  required String scopeKey,
  required String uuid,
  required String name,
  required String category,
  required String targetAmount,
  required String currentAmount,
  required DateTime startDate,
  required DateTime targetDate,
  Value<bool> isActive,
  Value<String?> description,
  Value<String?> userId,
  Value<int> rowid,
});
typedef $$GoalsTableUpdateCompanionBuilder = GoalsCompanion Function({
  Value<String> scopeKey,
  Value<String> uuid,
  Value<String> name,
  Value<String> category,
  Value<String> targetAmount,
  Value<String> currentAmount,
  Value<DateTime> startDate,
  Value<DateTime> targetDate,
  Value<bool> isActive,
  Value<String?> description,
  Value<String?> userId,
  Value<int> rowid,
});

class $$GoalsTableFilterComposer
    extends Composer<_$BasirDatabase, $GoalsTable> {
  $$GoalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get scopeKey => $composableBuilder(
      column: $table.scopeKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get targetAmount => $composableBuilder(
      column: $table.targetAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currentAmount => $composableBuilder(
      column: $table.currentAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get targetDate => $composableBuilder(
      column: $table.targetDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));
}

class $$GoalsTableOrderingComposer
    extends Composer<_$BasirDatabase, $GoalsTable> {
  $$GoalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get scopeKey => $composableBuilder(
      column: $table.scopeKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get targetAmount => $composableBuilder(
      column: $table.targetAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currentAmount => $composableBuilder(
      column: $table.currentAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get targetDate => $composableBuilder(
      column: $table.targetDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));
}

class $$GoalsTableAnnotationComposer
    extends Composer<_$BasirDatabase, $GoalsTable> {
  $$GoalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get scopeKey =>
      $composableBuilder(column: $table.scopeKey, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get targetAmount => $composableBuilder(
      column: $table.targetAmount, builder: (column) => column);

  GeneratedColumn<String> get currentAmount => $composableBuilder(
      column: $table.currentAmount, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get targetDate => $composableBuilder(
      column: $table.targetDate, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);
}

class $$GoalsTableTableManager extends RootTableManager<
    _$BasirDatabase,
    $GoalsTable,
    Goal,
    $$GoalsTableFilterComposer,
    $$GoalsTableOrderingComposer,
    $$GoalsTableAnnotationComposer,
    $$GoalsTableCreateCompanionBuilder,
    $$GoalsTableUpdateCompanionBuilder,
    (Goal, BaseReferences<_$BasirDatabase, $GoalsTable, Goal>),
    Goal,
    PrefetchHooks Function()> {
  $$GoalsTableTableManager(_$BasirDatabase db, $GoalsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GoalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GoalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GoalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> scopeKey = const Value.absent(),
            Value<String> uuid = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String> targetAmount = const Value.absent(),
            Value<String> currentAmount = const Value.absent(),
            Value<DateTime> startDate = const Value.absent(),
            Value<DateTime> targetDate = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> userId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GoalsCompanion(
            scopeKey: scopeKey,
            uuid: uuid,
            name: name,
            category: category,
            targetAmount: targetAmount,
            currentAmount: currentAmount,
            startDate: startDate,
            targetDate: targetDate,
            isActive: isActive,
            description: description,
            userId: userId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String scopeKey,
            required String uuid,
            required String name,
            required String category,
            required String targetAmount,
            required String currentAmount,
            required DateTime startDate,
            required DateTime targetDate,
            Value<bool> isActive = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> userId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GoalsCompanion.insert(
            scopeKey: scopeKey,
            uuid: uuid,
            name: name,
            category: category,
            targetAmount: targetAmount,
            currentAmount: currentAmount,
            startDate: startDate,
            targetDate: targetDate,
            isActive: isActive,
            description: description,
            userId: userId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$GoalsTableProcessedTableManager = ProcessedTableManager<
    _$BasirDatabase,
    $GoalsTable,
    Goal,
    $$GoalsTableFilterComposer,
    $$GoalsTableOrderingComposer,
    $$GoalsTableAnnotationComposer,
    $$GoalsTableCreateCompanionBuilder,
    $$GoalsTableUpdateCompanionBuilder,
    (Goal, BaseReferences<_$BasirDatabase, $GoalsTable, Goal>),
    Goal,
    PrefetchHooks Function()>;
typedef $$BudgetsTableCreateCompanionBuilder = BudgetsCompanion Function({
  required String scopeKey,
  required String budgetId,
  required String name,
  required String category,
  required String limitAmount,
  required String spentAmount,
  required DateTime startDate,
  required DateTime endDate,
  required double alertThreshold,
  Value<bool> isRollover,
  Value<bool> isActive,
  Value<String?> userId,
  Value<int> rowid,
});
typedef $$BudgetsTableUpdateCompanionBuilder = BudgetsCompanion Function({
  Value<String> scopeKey,
  Value<String> budgetId,
  Value<String> name,
  Value<String> category,
  Value<String> limitAmount,
  Value<String> spentAmount,
  Value<DateTime> startDate,
  Value<DateTime> endDate,
  Value<double> alertThreshold,
  Value<bool> isRollover,
  Value<bool> isActive,
  Value<String?> userId,
  Value<int> rowid,
});

class $$BudgetsTableFilterComposer
    extends Composer<_$BasirDatabase, $BudgetsTable> {
  $$BudgetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get scopeKey => $composableBuilder(
      column: $table.scopeKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get budgetId => $composableBuilder(
      column: $table.budgetId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get limitAmount => $composableBuilder(
      column: $table.limitAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get spentAmount => $composableBuilder(
      column: $table.spentAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get alertThreshold => $composableBuilder(
      column: $table.alertThreshold,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isRollover => $composableBuilder(
      column: $table.isRollover, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));
}

class $$BudgetsTableOrderingComposer
    extends Composer<_$BasirDatabase, $BudgetsTable> {
  $$BudgetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get scopeKey => $composableBuilder(
      column: $table.scopeKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get budgetId => $composableBuilder(
      column: $table.budgetId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get limitAmount => $composableBuilder(
      column: $table.limitAmount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get spentAmount => $composableBuilder(
      column: $table.spentAmount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get alertThreshold => $composableBuilder(
      column: $table.alertThreshold,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isRollover => $composableBuilder(
      column: $table.isRollover, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));
}

class $$BudgetsTableAnnotationComposer
    extends Composer<_$BasirDatabase, $BudgetsTable> {
  $$BudgetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get scopeKey =>
      $composableBuilder(column: $table.scopeKey, builder: (column) => column);

  GeneratedColumn<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get limitAmount => $composableBuilder(
      column: $table.limitAmount, builder: (column) => column);

  GeneratedColumn<String> get spentAmount => $composableBuilder(
      column: $table.spentAmount, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<double> get alertThreshold => $composableBuilder(
      column: $table.alertThreshold, builder: (column) => column);

  GeneratedColumn<bool> get isRollover => $composableBuilder(
      column: $table.isRollover, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);
}

class $$BudgetsTableTableManager extends RootTableManager<
    _$BasirDatabase,
    $BudgetsTable,
    Budget,
    $$BudgetsTableFilterComposer,
    $$BudgetsTableOrderingComposer,
    $$BudgetsTableAnnotationComposer,
    $$BudgetsTableCreateCompanionBuilder,
    $$BudgetsTableUpdateCompanionBuilder,
    (Budget, BaseReferences<_$BasirDatabase, $BudgetsTable, Budget>),
    Budget,
    PrefetchHooks Function()> {
  $$BudgetsTableTableManager(_$BasirDatabase db, $BudgetsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BudgetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BudgetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> scopeKey = const Value.absent(),
            Value<String> budgetId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String> limitAmount = const Value.absent(),
            Value<String> spentAmount = const Value.absent(),
            Value<DateTime> startDate = const Value.absent(),
            Value<DateTime> endDate = const Value.absent(),
            Value<double> alertThreshold = const Value.absent(),
            Value<bool> isRollover = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<String?> userId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BudgetsCompanion(
            scopeKey: scopeKey,
            budgetId: budgetId,
            name: name,
            category: category,
            limitAmount: limitAmount,
            spentAmount: spentAmount,
            startDate: startDate,
            endDate: endDate,
            alertThreshold: alertThreshold,
            isRollover: isRollover,
            isActive: isActive,
            userId: userId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String scopeKey,
            required String budgetId,
            required String name,
            required String category,
            required String limitAmount,
            required String spentAmount,
            required DateTime startDate,
            required DateTime endDate,
            required double alertThreshold,
            Value<bool> isRollover = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<String?> userId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BudgetsCompanion.insert(
            scopeKey: scopeKey,
            budgetId: budgetId,
            name: name,
            category: category,
            limitAmount: limitAmount,
            spentAmount: spentAmount,
            startDate: startDate,
            endDate: endDate,
            alertThreshold: alertThreshold,
            isRollover: isRollover,
            isActive: isActive,
            userId: userId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BudgetsTableProcessedTableManager = ProcessedTableManager<
    _$BasirDatabase,
    $BudgetsTable,
    Budget,
    $$BudgetsTableFilterComposer,
    $$BudgetsTableOrderingComposer,
    $$BudgetsTableAnnotationComposer,
    $$BudgetsTableCreateCompanionBuilder,
    $$BudgetsTableUpdateCompanionBuilder,
    (Budget, BaseReferences<_$BasirDatabase, $BudgetsTable, Budget>),
    Budget,
    PrefetchHooks Function()>;
typedef $$CustomersTableCreateCompanionBuilder = CustomersCompanion Function({
  required String scopeKey,
  required String uuid,
  required String nameAr,
  required String nameEn,
  Value<String?> taxNumber,
  Value<String?> phone,
  Value<String?> email,
  Value<String?> address,
  Value<String?> notes,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<double> creditLimit,
  Value<double> balance,
  Value<String?> receivableAccountId,
  Value<String?> userId,
  Value<String> syncStatus,
  Value<DateTime?> serverUpdatedAt,
  Value<bool> isDeleted,
  Value<int> rowid,
});
typedef $$CustomersTableUpdateCompanionBuilder = CustomersCompanion Function({
  Value<String> scopeKey,
  Value<String> uuid,
  Value<String> nameAr,
  Value<String> nameEn,
  Value<String?> taxNumber,
  Value<String?> phone,
  Value<String?> email,
  Value<String?> address,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<double> creditLimit,
  Value<double> balance,
  Value<String?> receivableAccountId,
  Value<String?> userId,
  Value<String> syncStatus,
  Value<DateTime?> serverUpdatedAt,
  Value<bool> isDeleted,
  Value<int> rowid,
});

class $$CustomersTableFilterComposer
    extends Composer<_$BasirDatabase, $CustomersTable> {
  $$CustomersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get scopeKey => $composableBuilder(
      column: $table.scopeKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameAr => $composableBuilder(
      column: $table.nameAr, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameEn => $composableBuilder(
      column: $table.nameEn, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get taxNumber => $composableBuilder(
      column: $table.taxNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get creditLimit => $composableBuilder(
      column: $table.creditLimit, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get balance => $composableBuilder(
      column: $table.balance, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get receivableAccountId => $composableBuilder(
      column: $table.receivableAccountId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get serverUpdatedAt => $composableBuilder(
      column: $table.serverUpdatedAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnFilters(column));
}

class $$CustomersTableOrderingComposer
    extends Composer<_$BasirDatabase, $CustomersTable> {
  $$CustomersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get scopeKey => $composableBuilder(
      column: $table.scopeKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameAr => $composableBuilder(
      column: $table.nameAr, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameEn => $composableBuilder(
      column: $table.nameEn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get taxNumber => $composableBuilder(
      column: $table.taxNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get creditLimit => $composableBuilder(
      column: $table.creditLimit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get balance => $composableBuilder(
      column: $table.balance, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get receivableAccountId => $composableBuilder(
      column: $table.receivableAccountId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get serverUpdatedAt => $composableBuilder(
      column: $table.serverUpdatedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnOrderings(column));
}

class $$CustomersTableAnnotationComposer
    extends Composer<_$BasirDatabase, $CustomersTable> {
  $$CustomersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get scopeKey =>
      $composableBuilder(column: $table.scopeKey, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get nameAr =>
      $composableBuilder(column: $table.nameAr, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);

  GeneratedColumn<String> get taxNumber =>
      $composableBuilder(column: $table.taxNumber, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<double> get creditLimit => $composableBuilder(
      column: $table.creditLimit, builder: (column) => column);

  GeneratedColumn<double> get balance =>
      $composableBuilder(column: $table.balance, builder: (column) => column);

  GeneratedColumn<String> get receivableAccountId => $composableBuilder(
      column: $table.receivableAccountId, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);

  GeneratedColumn<DateTime> get serverUpdatedAt => $composableBuilder(
      column: $table.serverUpdatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$CustomersTableTableManager extends RootTableManager<
    _$BasirDatabase,
    $CustomersTable,
    Customer,
    $$CustomersTableFilterComposer,
    $$CustomersTableOrderingComposer,
    $$CustomersTableAnnotationComposer,
    $$CustomersTableCreateCompanionBuilder,
    $$CustomersTableUpdateCompanionBuilder,
    (Customer, BaseReferences<_$BasirDatabase, $CustomersTable, Customer>),
    Customer,
    PrefetchHooks Function()> {
  $$CustomersTableTableManager(_$BasirDatabase db, $CustomersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> scopeKey = const Value.absent(),
            Value<String> uuid = const Value.absent(),
            Value<String> nameAr = const Value.absent(),
            Value<String> nameEn = const Value.absent(),
            Value<String?> taxNumber = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<double> creditLimit = const Value.absent(),
            Value<double> balance = const Value.absent(),
            Value<String?> receivableAccountId = const Value.absent(),
            Value<String?> userId = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<DateTime?> serverUpdatedAt = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CustomersCompanion(
            scopeKey: scopeKey,
            uuid: uuid,
            nameAr: nameAr,
            nameEn: nameEn,
            taxNumber: taxNumber,
            phone: phone,
            email: email,
            address: address,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            creditLimit: creditLimit,
            balance: balance,
            receivableAccountId: receivableAccountId,
            userId: userId,
            syncStatus: syncStatus,
            serverUpdatedAt: serverUpdatedAt,
            isDeleted: isDeleted,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String scopeKey,
            required String uuid,
            required String nameAr,
            required String nameEn,
            Value<String?> taxNumber = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<double> creditLimit = const Value.absent(),
            Value<double> balance = const Value.absent(),
            Value<String?> receivableAccountId = const Value.absent(),
            Value<String?> userId = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<DateTime?> serverUpdatedAt = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CustomersCompanion.insert(
            scopeKey: scopeKey,
            uuid: uuid,
            nameAr: nameAr,
            nameEn: nameEn,
            taxNumber: taxNumber,
            phone: phone,
            email: email,
            address: address,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            creditLimit: creditLimit,
            balance: balance,
            receivableAccountId: receivableAccountId,
            userId: userId,
            syncStatus: syncStatus,
            serverUpdatedAt: serverUpdatedAt,
            isDeleted: isDeleted,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CustomersTableProcessedTableManager = ProcessedTableManager<
    _$BasirDatabase,
    $CustomersTable,
    Customer,
    $$CustomersTableFilterComposer,
    $$CustomersTableOrderingComposer,
    $$CustomersTableAnnotationComposer,
    $$CustomersTableCreateCompanionBuilder,
    $$CustomersTableUpdateCompanionBuilder,
    (Customer, BaseReferences<_$BasirDatabase, $CustomersTable, Customer>),
    Customer,
    PrefetchHooks Function()>;
typedef $$VendorsTableCreateCompanionBuilder = VendorsCompanion Function({
  required String scopeKey,
  required String uuid,
  required String nameAr,
  required String nameEn,
  Value<String?> phone,
  Value<String?> email,
  Value<String?> address,
  Value<String?> notes,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<String?> payableAccountId,
  Value<String?> vatNumber,
  Value<String?> registrationNumber,
  Value<double> balance,
  Value<String?> userId,
  Value<String> syncStatus,
  Value<DateTime?> serverUpdatedAt,
  Value<bool> isDeleted,
  Value<int> rowid,
});
typedef $$VendorsTableUpdateCompanionBuilder = VendorsCompanion Function({
  Value<String> scopeKey,
  Value<String> uuid,
  Value<String> nameAr,
  Value<String> nameEn,
  Value<String?> phone,
  Value<String?> email,
  Value<String?> address,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<String?> payableAccountId,
  Value<String?> vatNumber,
  Value<String?> registrationNumber,
  Value<double> balance,
  Value<String?> userId,
  Value<String> syncStatus,
  Value<DateTime?> serverUpdatedAt,
  Value<bool> isDeleted,
  Value<int> rowid,
});

class $$VendorsTableFilterComposer
    extends Composer<_$BasirDatabase, $VendorsTable> {
  $$VendorsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get scopeKey => $composableBuilder(
      column: $table.scopeKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameAr => $composableBuilder(
      column: $table.nameAr, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameEn => $composableBuilder(
      column: $table.nameEn, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get payableAccountId => $composableBuilder(
      column: $table.payableAccountId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get vatNumber => $composableBuilder(
      column: $table.vatNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get registrationNumber => $composableBuilder(
      column: $table.registrationNumber,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get balance => $composableBuilder(
      column: $table.balance, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get serverUpdatedAt => $composableBuilder(
      column: $table.serverUpdatedAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnFilters(column));
}

class $$VendorsTableOrderingComposer
    extends Composer<_$BasirDatabase, $VendorsTable> {
  $$VendorsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get scopeKey => $composableBuilder(
      column: $table.scopeKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameAr => $composableBuilder(
      column: $table.nameAr, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameEn => $composableBuilder(
      column: $table.nameEn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get payableAccountId => $composableBuilder(
      column: $table.payableAccountId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get vatNumber => $composableBuilder(
      column: $table.vatNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get registrationNumber => $composableBuilder(
      column: $table.registrationNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get balance => $composableBuilder(
      column: $table.balance, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get serverUpdatedAt => $composableBuilder(
      column: $table.serverUpdatedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnOrderings(column));
}

class $$VendorsTableAnnotationComposer
    extends Composer<_$BasirDatabase, $VendorsTable> {
  $$VendorsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get scopeKey =>
      $composableBuilder(column: $table.scopeKey, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get nameAr =>
      $composableBuilder(column: $table.nameAr, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get payableAccountId => $composableBuilder(
      column: $table.payableAccountId, builder: (column) => column);

  GeneratedColumn<String> get vatNumber =>
      $composableBuilder(column: $table.vatNumber, builder: (column) => column);

  GeneratedColumn<String> get registrationNumber => $composableBuilder(
      column: $table.registrationNumber, builder: (column) => column);

  GeneratedColumn<double> get balance =>
      $composableBuilder(column: $table.balance, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);

  GeneratedColumn<DateTime> get serverUpdatedAt => $composableBuilder(
      column: $table.serverUpdatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$VendorsTableTableManager extends RootTableManager<
    _$BasirDatabase,
    $VendorsTable,
    Vendor,
    $$VendorsTableFilterComposer,
    $$VendorsTableOrderingComposer,
    $$VendorsTableAnnotationComposer,
    $$VendorsTableCreateCompanionBuilder,
    $$VendorsTableUpdateCompanionBuilder,
    (Vendor, BaseReferences<_$BasirDatabase, $VendorsTable, Vendor>),
    Vendor,
    PrefetchHooks Function()> {
  $$VendorsTableTableManager(_$BasirDatabase db, $VendorsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VendorsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VendorsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VendorsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> scopeKey = const Value.absent(),
            Value<String> uuid = const Value.absent(),
            Value<String> nameAr = const Value.absent(),
            Value<String> nameEn = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<String?> payableAccountId = const Value.absent(),
            Value<String?> vatNumber = const Value.absent(),
            Value<String?> registrationNumber = const Value.absent(),
            Value<double> balance = const Value.absent(),
            Value<String?> userId = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<DateTime?> serverUpdatedAt = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              VendorsCompanion(
            scopeKey: scopeKey,
            uuid: uuid,
            nameAr: nameAr,
            nameEn: nameEn,
            phone: phone,
            email: email,
            address: address,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            payableAccountId: payableAccountId,
            vatNumber: vatNumber,
            registrationNumber: registrationNumber,
            balance: balance,
            userId: userId,
            syncStatus: syncStatus,
            serverUpdatedAt: serverUpdatedAt,
            isDeleted: isDeleted,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String scopeKey,
            required String uuid,
            required String nameAr,
            required String nameEn,
            Value<String?> phone = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<String?> payableAccountId = const Value.absent(),
            Value<String?> vatNumber = const Value.absent(),
            Value<String?> registrationNumber = const Value.absent(),
            Value<double> balance = const Value.absent(),
            Value<String?> userId = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<DateTime?> serverUpdatedAt = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              VendorsCompanion.insert(
            scopeKey: scopeKey,
            uuid: uuid,
            nameAr: nameAr,
            nameEn: nameEn,
            phone: phone,
            email: email,
            address: address,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            payableAccountId: payableAccountId,
            vatNumber: vatNumber,
            registrationNumber: registrationNumber,
            balance: balance,
            userId: userId,
            syncStatus: syncStatus,
            serverUpdatedAt: serverUpdatedAt,
            isDeleted: isDeleted,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$VendorsTableProcessedTableManager = ProcessedTableManager<
    _$BasirDatabase,
    $VendorsTable,
    Vendor,
    $$VendorsTableFilterComposer,
    $$VendorsTableOrderingComposer,
    $$VendorsTableAnnotationComposer,
    $$VendorsTableCreateCompanionBuilder,
    $$VendorsTableUpdateCompanionBuilder,
    (Vendor, BaseReferences<_$BasirDatabase, $VendorsTable, Vendor>),
    Vendor,
    PrefetchHooks Function()>;
typedef $$WarehousesTableCreateCompanionBuilder = WarehousesCompanion Function({
  required String scopeKey,
  required String uuid,
  required String nameAr,
  required String nameEn,
  Value<String?> location,
  Value<String?> userId,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$WarehousesTableUpdateCompanionBuilder = WarehousesCompanion Function({
  Value<String> scopeKey,
  Value<String> uuid,
  Value<String> nameAr,
  Value<String> nameEn,
  Value<String?> location,
  Value<String?> userId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$WarehousesTableFilterComposer
    extends Composer<_$BasirDatabase, $WarehousesTable> {
  $$WarehousesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get scopeKey => $composableBuilder(
      column: $table.scopeKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameAr => $composableBuilder(
      column: $table.nameAr, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameEn => $composableBuilder(
      column: $table.nameEn, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get location => $composableBuilder(
      column: $table.location, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$WarehousesTableOrderingComposer
    extends Composer<_$BasirDatabase, $WarehousesTable> {
  $$WarehousesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get scopeKey => $composableBuilder(
      column: $table.scopeKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameAr => $composableBuilder(
      column: $table.nameAr, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameEn => $composableBuilder(
      column: $table.nameEn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get location => $composableBuilder(
      column: $table.location, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$WarehousesTableAnnotationComposer
    extends Composer<_$BasirDatabase, $WarehousesTable> {
  $$WarehousesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get scopeKey =>
      $composableBuilder(column: $table.scopeKey, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get nameAr =>
      $composableBuilder(column: $table.nameAr, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$WarehousesTableTableManager extends RootTableManager<
    _$BasirDatabase,
    $WarehousesTable,
    Warehouse,
    $$WarehousesTableFilterComposer,
    $$WarehousesTableOrderingComposer,
    $$WarehousesTableAnnotationComposer,
    $$WarehousesTableCreateCompanionBuilder,
    $$WarehousesTableUpdateCompanionBuilder,
    (Warehouse, BaseReferences<_$BasirDatabase, $WarehousesTable, Warehouse>),
    Warehouse,
    PrefetchHooks Function()> {
  $$WarehousesTableTableManager(_$BasirDatabase db, $WarehousesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WarehousesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WarehousesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WarehousesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> scopeKey = const Value.absent(),
            Value<String> uuid = const Value.absent(),
            Value<String> nameAr = const Value.absent(),
            Value<String> nameEn = const Value.absent(),
            Value<String?> location = const Value.absent(),
            Value<String?> userId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WarehousesCompanion(
            scopeKey: scopeKey,
            uuid: uuid,
            nameAr: nameAr,
            nameEn: nameEn,
            location: location,
            userId: userId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String scopeKey,
            required String uuid,
            required String nameAr,
            required String nameEn,
            Value<String?> location = const Value.absent(),
            Value<String?> userId = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              WarehousesCompanion.insert(
            scopeKey: scopeKey,
            uuid: uuid,
            nameAr: nameAr,
            nameEn: nameEn,
            location: location,
            userId: userId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$WarehousesTableProcessedTableManager = ProcessedTableManager<
    _$BasirDatabase,
    $WarehousesTable,
    Warehouse,
    $$WarehousesTableFilterComposer,
    $$WarehousesTableOrderingComposer,
    $$WarehousesTableAnnotationComposer,
    $$WarehousesTableCreateCompanionBuilder,
    $$WarehousesTableUpdateCompanionBuilder,
    (Warehouse, BaseReferences<_$BasirDatabase, $WarehousesTable, Warehouse>),
    Warehouse,
    PrefetchHooks Function()>;
typedef $$SyncOutboxTableCreateCompanionBuilder = SyncOutboxCompanion Function({
  required String id,
  required String entityType,
  required String entityId,
  required String operation,
  required String payloadJson,
  Value<int> attemptCount,
  Value<DateTime?> nextAttemptAt,
  Value<String?> lastError,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$SyncOutboxTableUpdateCompanionBuilder = SyncOutboxCompanion Function({
  Value<String> id,
  Value<String> entityType,
  Value<String> entityId,
  Value<String> operation,
  Value<String> payloadJson,
  Value<int> attemptCount,
  Value<DateTime?> nextAttemptAt,
  Value<String?> lastError,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$SyncOutboxTableFilterComposer
    extends Composer<_$BasirDatabase, $SyncOutboxTable> {
  $$SyncOutboxTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get operation => $composableBuilder(
      column: $table.operation, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get payloadJson => $composableBuilder(
      column: $table.payloadJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get attemptCount => $composableBuilder(
      column: $table.attemptCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get nextAttemptAt => $composableBuilder(
      column: $table.nextAttemptAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastError => $composableBuilder(
      column: $table.lastError, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$SyncOutboxTableOrderingComposer
    extends Composer<_$BasirDatabase, $SyncOutboxTable> {
  $$SyncOutboxTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get operation => $composableBuilder(
      column: $table.operation, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get payloadJson => $composableBuilder(
      column: $table.payloadJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get attemptCount => $composableBuilder(
      column: $table.attemptCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get nextAttemptAt => $composableBuilder(
      column: $table.nextAttemptAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastError => $composableBuilder(
      column: $table.lastError, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$SyncOutboxTableAnnotationComposer
    extends Composer<_$BasirDatabase, $SyncOutboxTable> {
  $$SyncOutboxTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => column);

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
      column: $table.payloadJson, builder: (column) => column);

  GeneratedColumn<int> get attemptCount => $composableBuilder(
      column: $table.attemptCount, builder: (column) => column);

  GeneratedColumn<DateTime> get nextAttemptAt => $composableBuilder(
      column: $table.nextAttemptAt, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SyncOutboxTableTableManager extends RootTableManager<
    _$BasirDatabase,
    $SyncOutboxTable,
    SyncOutboxData,
    $$SyncOutboxTableFilterComposer,
    $$SyncOutboxTableOrderingComposer,
    $$SyncOutboxTableAnnotationComposer,
    $$SyncOutboxTableCreateCompanionBuilder,
    $$SyncOutboxTableUpdateCompanionBuilder,
    (
      SyncOutboxData,
      BaseReferences<_$BasirDatabase, $SyncOutboxTable, SyncOutboxData>
    ),
    SyncOutboxData,
    PrefetchHooks Function()> {
  $$SyncOutboxTableTableManager(_$BasirDatabase db, $SyncOutboxTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncOutboxTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncOutboxTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncOutboxTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> entityType = const Value.absent(),
            Value<String> entityId = const Value.absent(),
            Value<String> operation = const Value.absent(),
            Value<String> payloadJson = const Value.absent(),
            Value<int> attemptCount = const Value.absent(),
            Value<DateTime?> nextAttemptAt = const Value.absent(),
            Value<String?> lastError = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncOutboxCompanion(
            id: id,
            entityType: entityType,
            entityId: entityId,
            operation: operation,
            payloadJson: payloadJson,
            attemptCount: attemptCount,
            nextAttemptAt: nextAttemptAt,
            lastError: lastError,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String entityType,
            required String entityId,
            required String operation,
            required String payloadJson,
            Value<int> attemptCount = const Value.absent(),
            Value<DateTime?> nextAttemptAt = const Value.absent(),
            Value<String?> lastError = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncOutboxCompanion.insert(
            id: id,
            entityType: entityType,
            entityId: entityId,
            operation: operation,
            payloadJson: payloadJson,
            attemptCount: attemptCount,
            nextAttemptAt: nextAttemptAt,
            lastError: lastError,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SyncOutboxTableProcessedTableManager = ProcessedTableManager<
    _$BasirDatabase,
    $SyncOutboxTable,
    SyncOutboxData,
    $$SyncOutboxTableFilterComposer,
    $$SyncOutboxTableOrderingComposer,
    $$SyncOutboxTableAnnotationComposer,
    $$SyncOutboxTableCreateCompanionBuilder,
    $$SyncOutboxTableUpdateCompanionBuilder,
    (
      SyncOutboxData,
      BaseReferences<_$BasirDatabase, $SyncOutboxTable, SyncOutboxData>
    ),
    SyncOutboxData,
    PrefetchHooks Function()>;

class $BasirDatabaseManager {
  final _$BasirDatabase _db;
  $BasirDatabaseManager(this._db);
  $$LocalMetadataTableTableManager get localMetadata =>
      $$LocalMetadataTableTableManager(_db, _db.localMetadata);
  $$BarcodeConfigsTableTableManager get barcodeConfigs =>
      $$BarcodeConfigsTableTableManager(_db, _db.barcodeConfigs);
  $$MarketPricesTableTableManager get marketPrices =>
      $$MarketPricesTableTableManager(_db, _db.marketPrices);
  $$ProfilesTableTableManager get profiles =>
      $$ProfilesTableTableManager(_db, _db.profiles);
  $$BusinessSettingsTableTableManager get businessSettings =>
      $$BusinessSettingsTableTableManager(_db, _db.businessSettings);
  $$GoalsTableTableManager get goals =>
      $$GoalsTableTableManager(_db, _db.goals);
  $$BudgetsTableTableManager get budgets =>
      $$BudgetsTableTableManager(_db, _db.budgets);
  $$CustomersTableTableManager get customers =>
      $$CustomersTableTableManager(_db, _db.customers);
  $$VendorsTableTableManager get vendors =>
      $$VendorsTableTableManager(_db, _db.vendors);
  $$WarehousesTableTableManager get warehouses =>
      $$WarehousesTableTableManager(_db, _db.warehouses);
  $$SyncOutboxTableTableManager get syncOutbox =>
      $$SyncOutboxTableTableManager(_db, _db.syncOutbox);
}
