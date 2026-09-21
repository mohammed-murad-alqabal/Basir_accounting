// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'barcode_config_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetBarcodeConfigModelCollection on Isar {
  IsarCollection<BarcodeConfigModel> get barcodeConfigModels =>
      this.collection();
}

const BarcodeConfigModelSchema = CollectionSchema(
  name: r'BarcodeConfigModel',
  id: -3765836076480800723,
  properties: {
    r'columnsPerRow': PropertySchema(
      id: 0,
      name: r'columnsPerRow',
      type: IsarType.long,
    ),
    r'height': PropertySchema(
      id: 1,
      name: r'height',
      type: IsarType.double,
    ),
    r'id': PropertySchema(
      id: 2,
      name: r'id',
      type: IsarType.string,
    ),
    r'margin': PropertySchema(
      id: 3,
      name: r'margin',
      type: IsarType.double,
    ),
    r'printerType': PropertySchema(
      id: 4,
      name: r'printerType',
      type: IsarType.byte,
      enumMap: _BarcodeConfigModelprinterTypeEnumValueMap,
    ),
    r'showItemName': PropertySchema(
      id: 5,
      name: r'showItemName',
      type: IsarType.bool,
    ),
    r'showPrice': PropertySchema(
      id: 6,
      name: r'showPrice',
      type: IsarType.bool,
    ),
    r'width': PropertySchema(
      id: 7,
      name: r'width',
      type: IsarType.double,
    )
  },
  estimateSize: _barcodeConfigModelEstimateSize,
  serialize: _barcodeConfigModelSerialize,
  deserialize: _barcodeConfigModelDeserialize,
  deserializeProp: _barcodeConfigModelDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'id': IndexSchema(
      id: -3268401673993471357,
      name: r'id',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'id',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _barcodeConfigModelGetId,
  getLinks: _barcodeConfigModelGetLinks,
  attach: _barcodeConfigModelAttach,
  version: '3.1.0+1',
);

int _barcodeConfigModelEstimateSize(
  BarcodeConfigModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.id.length * 3;
  return bytesCount;
}

void _barcodeConfigModelSerialize(
  BarcodeConfigModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.columnsPerRow);
  writer.writeDouble(offsets[1], object.height);
  writer.writeString(offsets[2], object.id);
  writer.writeDouble(offsets[3], object.margin);
  writer.writeByte(offsets[4], object.printerType.index);
  writer.writeBool(offsets[5], object.showItemName);
  writer.writeBool(offsets[6], object.showPrice);
  writer.writeDouble(offsets[7], object.width);
}

BarcodeConfigModel _barcodeConfigModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = BarcodeConfigModel();
  object.columnsPerRow = reader.readLong(offsets[0]);
  object.height = reader.readDouble(offsets[1]);
  object.id = reader.readString(offsets[2]);
  object.isarId = id;
  object.margin = reader.readDouble(offsets[3]);
  object.printerType = _BarcodeConfigModelprinterTypeValueEnumMap[
          reader.readByteOrNull(offsets[4])] ??
      PrinterType.thermal;
  object.showItemName = reader.readBool(offsets[5]);
  object.showPrice = reader.readBool(offsets[6]);
  object.width = reader.readDouble(offsets[7]);
  return object;
}

P _barcodeConfigModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    case 4:
      return (_BarcodeConfigModelprinterTypeValueEnumMap[
              reader.readByteOrNull(offset)] ??
          PrinterType.thermal) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _BarcodeConfigModelprinterTypeEnumValueMap = {
  'thermal': 0,
  'a4': 1,
};
const _BarcodeConfigModelprinterTypeValueEnumMap = {
  0: PrinterType.thermal,
  1: PrinterType.a4,
};

Id _barcodeConfigModelGetId(BarcodeConfigModel object) {
  return object.isarId ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _barcodeConfigModelGetLinks(
    BarcodeConfigModel object) {
  return [];
}

void _barcodeConfigModelAttach(
    IsarCollection<dynamic> col, Id id, BarcodeConfigModel object) {
  object.isarId = id;
}

extension BarcodeConfigModelByIndex on IsarCollection<BarcodeConfigModel> {
  Future<BarcodeConfigModel?> getById(String id) {
    return getByIndex(r'id', [id]);
  }

  BarcodeConfigModel? getByIdSync(String id) {
    return getByIndexSync(r'id', [id]);
  }

  Future<bool> deleteById(String id) {
    return deleteByIndex(r'id', [id]);
  }

  bool deleteByIdSync(String id) {
    return deleteByIndexSync(r'id', [id]);
  }

  Future<List<BarcodeConfigModel?>> getAllById(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndex(r'id', values);
  }

  List<BarcodeConfigModel?> getAllByIdSync(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'id', values);
  }

  Future<int> deleteAllById(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'id', values);
  }

  int deleteAllByIdSync(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'id', values);
  }

  Future<Id> putById(BarcodeConfigModel object) {
    return putByIndex(r'id', object);
  }

  Id putByIdSync(BarcodeConfigModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'id', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllById(List<BarcodeConfigModel> objects) {
    return putAllByIndex(r'id', objects);
  }

  List<Id> putAllByIdSync(List<BarcodeConfigModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'id', objects, saveLinks: saveLinks);
  }
}

extension BarcodeConfigModelQueryWhereSort
    on QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QWhere> {
  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterWhere>
      anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension BarcodeConfigModelQueryWhere
    on QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QWhereClause> {
  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterWhereClause>
      isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterWhereClause>
      isarIdNotEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterWhereClause>
      isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerIsarId,
        includeLower: includeLower,
        upper: upperIsarId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterWhereClause>
      idEqualTo(String id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'id',
        value: [id],
      ));
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterWhereClause>
      idNotEqualTo(String id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [],
              upper: [id],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [id],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [id],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [],
              upper: [id],
              includeUpper: false,
            ));
      }
    });
  }
}

extension BarcodeConfigModelQueryFilter
    on QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QFilterCondition> {
  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterFilterCondition>
      columnsPerRowEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'columnsPerRow',
        value: value,
      ));
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterFilterCondition>
      columnsPerRowGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'columnsPerRow',
        value: value,
      ));
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterFilterCondition>
      columnsPerRowLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'columnsPerRow',
        value: value,
      ));
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterFilterCondition>
      columnsPerRowBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'columnsPerRow',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterFilterCondition>
      heightEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'height',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterFilterCondition>
      heightGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'height',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterFilterCondition>
      heightLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'height',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterFilterCondition>
      heightBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'height',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterFilterCondition>
      idEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterFilterCondition>
      idGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterFilterCondition>
      idLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterFilterCondition>
      idBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterFilterCondition>
      idStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterFilterCondition>
      idEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterFilterCondition>
      idContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterFilterCondition>
      idMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'id',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterFilterCondition>
      idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterFilterCondition>
      idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterFilterCondition>
      isarIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isarId',
      ));
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterFilterCondition>
      isarIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isarId',
      ));
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterFilterCondition>
      isarIdEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterFilterCondition>
      isarIdGreaterThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterFilterCondition>
      isarIdLessThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterFilterCondition>
      isarIdBetween(
    Id? lower,
    Id? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isarId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterFilterCondition>
      marginEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'margin',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterFilterCondition>
      marginGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'margin',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterFilterCondition>
      marginLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'margin',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterFilterCondition>
      marginBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'margin',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterFilterCondition>
      printerTypeEqualTo(PrinterType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'printerType',
        value: value,
      ));
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterFilterCondition>
      printerTypeGreaterThan(
    PrinterType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'printerType',
        value: value,
      ));
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterFilterCondition>
      printerTypeLessThan(
    PrinterType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'printerType',
        value: value,
      ));
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterFilterCondition>
      printerTypeBetween(
    PrinterType lower,
    PrinterType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'printerType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterFilterCondition>
      showItemNameEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'showItemName',
        value: value,
      ));
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterFilterCondition>
      showPriceEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'showPrice',
        value: value,
      ));
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterFilterCondition>
      widthEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'width',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterFilterCondition>
      widthGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'width',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterFilterCondition>
      widthLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'width',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterFilterCondition>
      widthBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'width',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension BarcodeConfigModelQueryObject
    on QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QFilterCondition> {}

extension BarcodeConfigModelQueryLinks
    on QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QFilterCondition> {}

extension BarcodeConfigModelQuerySortBy
    on QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QSortBy> {
  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterSortBy>
      sortByColumnsPerRow() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'columnsPerRow', Sort.asc);
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterSortBy>
      sortByColumnsPerRowDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'columnsPerRow', Sort.desc);
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterSortBy>
      sortByHeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'height', Sort.asc);
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterSortBy>
      sortByHeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'height', Sort.desc);
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterSortBy>
      sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterSortBy>
      sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterSortBy>
      sortByMargin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'margin', Sort.asc);
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterSortBy>
      sortByMarginDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'margin', Sort.desc);
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterSortBy>
      sortByPrinterType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'printerType', Sort.asc);
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterSortBy>
      sortByPrinterTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'printerType', Sort.desc);
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterSortBy>
      sortByShowItemName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showItemName', Sort.asc);
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterSortBy>
      sortByShowItemNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showItemName', Sort.desc);
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterSortBy>
      sortByShowPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showPrice', Sort.asc);
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterSortBy>
      sortByShowPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showPrice', Sort.desc);
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterSortBy>
      sortByWidth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'width', Sort.asc);
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterSortBy>
      sortByWidthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'width', Sort.desc);
    });
  }
}

extension BarcodeConfigModelQuerySortThenBy
    on QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QSortThenBy> {
  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterSortBy>
      thenByColumnsPerRow() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'columnsPerRow', Sort.asc);
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterSortBy>
      thenByColumnsPerRowDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'columnsPerRow', Sort.desc);
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterSortBy>
      thenByHeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'height', Sort.asc);
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterSortBy>
      thenByHeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'height', Sort.desc);
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterSortBy>
      thenByMargin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'margin', Sort.asc);
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterSortBy>
      thenByMarginDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'margin', Sort.desc);
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterSortBy>
      thenByPrinterType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'printerType', Sort.asc);
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterSortBy>
      thenByPrinterTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'printerType', Sort.desc);
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterSortBy>
      thenByShowItemName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showItemName', Sort.asc);
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterSortBy>
      thenByShowItemNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showItemName', Sort.desc);
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterSortBy>
      thenByShowPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showPrice', Sort.asc);
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterSortBy>
      thenByShowPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showPrice', Sort.desc);
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterSortBy>
      thenByWidth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'width', Sort.asc);
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QAfterSortBy>
      thenByWidthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'width', Sort.desc);
    });
  }
}

extension BarcodeConfigModelQueryWhereDistinct
    on QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QDistinct> {
  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QDistinct>
      distinctByColumnsPerRow() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'columnsPerRow');
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QDistinct>
      distinctByHeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'height');
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QDistinct> distinctById(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QDistinct>
      distinctByMargin() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'margin');
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QDistinct>
      distinctByPrinterType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'printerType');
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QDistinct>
      distinctByShowItemName() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'showItemName');
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QDistinct>
      distinctByShowPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'showPrice');
    });
  }

  QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QDistinct>
      distinctByWidth() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'width');
    });
  }
}

extension BarcodeConfigModelQueryProperty
    on QueryBuilder<BarcodeConfigModel, BarcodeConfigModel, QQueryProperty> {
  QueryBuilder<BarcodeConfigModel, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<BarcodeConfigModel, int, QQueryOperations>
      columnsPerRowProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'columnsPerRow');
    });
  }

  QueryBuilder<BarcodeConfigModel, double, QQueryOperations> heightProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'height');
    });
  }

  QueryBuilder<BarcodeConfigModel, String, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<BarcodeConfigModel, double, QQueryOperations> marginProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'margin');
    });
  }

  QueryBuilder<BarcodeConfigModel, PrinterType, QQueryOperations>
      printerTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'printerType');
    });
  }

  QueryBuilder<BarcodeConfigModel, bool, QQueryOperations>
      showItemNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'showItemName');
    });
  }

  QueryBuilder<BarcodeConfigModel, bool, QQueryOperations> showPriceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'showPrice');
    });
  }

  QueryBuilder<BarcodeConfigModel, double, QQueryOperations> widthProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'width');
    });
  }
}
