// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fixed_asset_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetFixedAssetModelCollection on Isar {
  IsarCollection<FixedAssetModel> get fixedAssetModels => this.collection();
}

const FixedAssetModelSchema = CollectionSchema(
  name: r'FixedAssetModel',
  id: -3511949572021914657,
  properties: {
    r'accumDepreciationAccountId': PropertySchema(
      id: 0,
      name: r'accumDepreciationAccountId',
      type: IsarType.string,
    ),
    r'accumulatedDepreciation': PropertySchema(
      id: 1,
      name: r'accumulatedDepreciation',
      type: IsarType.double,
    ),
    r'acquisitionDate': PropertySchema(
      id: 2,
      name: r'acquisitionDate',
      type: IsarType.dateTime,
    ),
    r'assetAccountId': PropertySchema(
      id: 3,
      name: r'assetAccountId',
      type: IsarType.string,
    ),
    r'categoryId': PropertySchema(
      id: 4,
      name: r'categoryId',
      type: IsarType.string,
    ),
    r'code': PropertySchema(
      id: 5,
      name: r'code',
      type: IsarType.string,
    ),
    r'cost': PropertySchema(
      id: 6,
      name: r'cost',
      type: IsarType.double,
    ),
    r'depreciationAccountId': PropertySchema(
      id: 7,
      name: r'depreciationAccountId',
      type: IsarType.string,
    ),
    r'depreciationMethod': PropertySchema(
      id: 8,
      name: r'depreciationMethod',
      type: IsarType.string,
    ),
    r'id': PropertySchema(
      id: 9,
      name: r'id',
      type: IsarType.string,
    ),
    r'isActive': PropertySchema(
      id: 10,
      name: r'isActive',
      type: IsarType.bool,
    ),
    r'nameAr': PropertySchema(
      id: 11,
      name: r'nameAr',
      type: IsarType.string,
    ),
    r'nameEn': PropertySchema(
      id: 12,
      name: r'nameEn',
      type: IsarType.string,
    ),
    r'residualValue': PropertySchema(
      id: 13,
      name: r'residualValue',
      type: IsarType.double,
    ),
    r'usefulLifeYears': PropertySchema(
      id: 14,
      name: r'usefulLifeYears',
      type: IsarType.long,
    ),
    r'userId': PropertySchema(
      id: 15,
      name: r'userId',
      type: IsarType.string,
    )
  },
  estimateSize: _fixedAssetModelEstimateSize,
  serialize: _fixedAssetModelSerialize,
  deserialize: _fixedAssetModelDeserialize,
  deserializeProp: _fixedAssetModelDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'id': IndexSchema(
      id: -3268401673993471357,
      name: r'id',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'id',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'code': IndexSchema(
      id: 329780482934683790,
      name: r'code',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'code',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _fixedAssetModelGetId,
  getLinks: _fixedAssetModelGetLinks,
  attach: _fixedAssetModelAttach,
  version: '3.1.0+1',
);

int _fixedAssetModelEstimateSize(
  FixedAssetModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.accumDepreciationAccountId.length * 3;
  bytesCount += 3 + object.assetAccountId.length * 3;
  bytesCount += 3 + object.categoryId.length * 3;
  bytesCount += 3 + object.code.length * 3;
  bytesCount += 3 + object.depreciationAccountId.length * 3;
  bytesCount += 3 + object.depreciationMethod.length * 3;
  bytesCount += 3 + object.id.length * 3;
  bytesCount += 3 + object.nameAr.length * 3;
  bytesCount += 3 + object.nameEn.length * 3;
  {
    final value = object.userId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _fixedAssetModelSerialize(
  FixedAssetModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.accumDepreciationAccountId);
  writer.writeDouble(offsets[1], object.accumulatedDepreciation);
  writer.writeDateTime(offsets[2], object.acquisitionDate);
  writer.writeString(offsets[3], object.assetAccountId);
  writer.writeString(offsets[4], object.categoryId);
  writer.writeString(offsets[5], object.code);
  writer.writeDouble(offsets[6], object.cost);
  writer.writeString(offsets[7], object.depreciationAccountId);
  writer.writeString(offsets[8], object.depreciationMethod);
  writer.writeString(offsets[9], object.id);
  writer.writeBool(offsets[10], object.isActive);
  writer.writeString(offsets[11], object.nameAr);
  writer.writeString(offsets[12], object.nameEn);
  writer.writeDouble(offsets[13], object.residualValue);
  writer.writeLong(offsets[14], object.usefulLifeYears);
  writer.writeString(offsets[15], object.userId);
}

FixedAssetModel _fixedAssetModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = FixedAssetModel();
  object.accumDepreciationAccountId = reader.readString(offsets[0]);
  object.accumulatedDepreciation = reader.readDouble(offsets[1]);
  object.acquisitionDate = reader.readDateTime(offsets[2]);
  object.assetAccountId = reader.readString(offsets[3]);
  object.categoryId = reader.readString(offsets[4]);
  object.code = reader.readString(offsets[5]);
  object.cost = reader.readDouble(offsets[6]);
  object.depreciationAccountId = reader.readString(offsets[7]);
  object.depreciationMethod = reader.readString(offsets[8]);
  object.id = reader.readString(offsets[9]);
  object.isActive = reader.readBool(offsets[10]);
  object.isarId = id;
  object.nameAr = reader.readString(offsets[11]);
  object.nameEn = reader.readString(offsets[12]);
  object.residualValue = reader.readDouble(offsets[13]);
  object.usefulLifeYears = reader.readLong(offsets[14]);
  object.userId = reader.readStringOrNull(offsets[15]);
  return object;
}

P _fixedAssetModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readDouble(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readBool(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readString(offset)) as P;
    case 13:
      return (reader.readDouble(offset)) as P;
    case 14:
      return (reader.readLong(offset)) as P;
    case 15:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _fixedAssetModelGetId(FixedAssetModel object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _fixedAssetModelGetLinks(FixedAssetModel object) {
  return [];
}

void _fixedAssetModelAttach(
    IsarCollection<dynamic> col, Id id, FixedAssetModel object) {
  object.isarId = id;
}

extension FixedAssetModelByIndex on IsarCollection<FixedAssetModel> {
  Future<FixedAssetModel?> getById(String id) {
    return getByIndex(r'id', [id]);
  }

  FixedAssetModel? getByIdSync(String id) {
    return getByIndexSync(r'id', [id]);
  }

  Future<bool> deleteById(String id) {
    return deleteByIndex(r'id', [id]);
  }

  bool deleteByIdSync(String id) {
    return deleteByIndexSync(r'id', [id]);
  }

  Future<List<FixedAssetModel?>> getAllById(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndex(r'id', values);
  }

  List<FixedAssetModel?> getAllByIdSync(List<String> idValues) {
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

  Future<Id> putById(FixedAssetModel object) {
    return putByIndex(r'id', object);
  }

  Id putByIdSync(FixedAssetModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'id', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllById(List<FixedAssetModel> objects) {
    return putAllByIndex(r'id', objects);
  }

  List<Id> putAllByIdSync(List<FixedAssetModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'id', objects, saveLinks: saveLinks);
  }

  Future<FixedAssetModel?> getByCode(String code) {
    return getByIndex(r'code', [code]);
  }

  FixedAssetModel? getByCodeSync(String code) {
    return getByIndexSync(r'code', [code]);
  }

  Future<bool> deleteByCode(String code) {
    return deleteByIndex(r'code', [code]);
  }

  bool deleteByCodeSync(String code) {
    return deleteByIndexSync(r'code', [code]);
  }

  Future<List<FixedAssetModel?>> getAllByCode(List<String> codeValues) {
    final values = codeValues.map((e) => [e]).toList();
    return getAllByIndex(r'code', values);
  }

  List<FixedAssetModel?> getAllByCodeSync(List<String> codeValues) {
    final values = codeValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'code', values);
  }

  Future<int> deleteAllByCode(List<String> codeValues) {
    final values = codeValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'code', values);
  }

  int deleteAllByCodeSync(List<String> codeValues) {
    final values = codeValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'code', values);
  }

  Future<Id> putByCode(FixedAssetModel object) {
    return putByIndex(r'code', object);
  }

  Id putByCodeSync(FixedAssetModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'code', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByCode(List<FixedAssetModel> objects) {
    return putAllByIndex(r'code', objects);
  }

  List<Id> putAllByCodeSync(List<FixedAssetModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'code', objects, saveLinks: saveLinks);
  }
}

extension FixedAssetModelQueryWhereSort
    on QueryBuilder<FixedAssetModel, FixedAssetModel, QWhere> {
  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension FixedAssetModelQueryWhere
    on QueryBuilder<FixedAssetModel, FixedAssetModel, QWhereClause> {
  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterWhereClause>
      isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterWhereClause>
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

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterWhereClause>
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

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterWhereClause> idEqualTo(
      String id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'id',
        value: [id],
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterWhereClause>
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

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterWhereClause> codeEqualTo(
      String code) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'code',
        value: [code],
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterWhereClause>
      codeNotEqualTo(String code) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'code',
              lower: [],
              upper: [code],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'code',
              lower: [code],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'code',
              lower: [code],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'code',
              lower: [],
              upper: [code],
              includeUpper: false,
            ));
      }
    });
  }
}

extension FixedAssetModelQueryFilter
    on QueryBuilder<FixedAssetModel, FixedAssetModel, QFilterCondition> {
  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      accumDepreciationAccountIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'accumDepreciationAccountId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      accumDepreciationAccountIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'accumDepreciationAccountId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      accumDepreciationAccountIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'accumDepreciationAccountId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      accumDepreciationAccountIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'accumDepreciationAccountId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      accumDepreciationAccountIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'accumDepreciationAccountId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      accumDepreciationAccountIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'accumDepreciationAccountId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      accumDepreciationAccountIdContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'accumDepreciationAccountId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      accumDepreciationAccountIdMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'accumDepreciationAccountId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      accumDepreciationAccountIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'accumDepreciationAccountId',
        value: '',
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      accumDepreciationAccountIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'accumDepreciationAccountId',
        value: '',
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      accumulatedDepreciationEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'accumulatedDepreciation',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      accumulatedDepreciationGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'accumulatedDepreciation',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      accumulatedDepreciationLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'accumulatedDepreciation',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      accumulatedDepreciationBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'accumulatedDepreciation',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      acquisitionDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'acquisitionDate',
        value: value,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      acquisitionDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'acquisitionDate',
        value: value,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      acquisitionDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'acquisitionDate',
        value: value,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      acquisitionDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'acquisitionDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      assetAccountIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'assetAccountId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      assetAccountIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'assetAccountId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      assetAccountIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'assetAccountId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      assetAccountIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'assetAccountId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      assetAccountIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'assetAccountId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      assetAccountIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'assetAccountId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      assetAccountIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'assetAccountId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      assetAccountIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'assetAccountId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      assetAccountIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'assetAccountId',
        value: '',
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      assetAccountIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'assetAccountId',
        value: '',
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      categoryIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'categoryId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      categoryIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'categoryId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      categoryIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'categoryId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      categoryIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'categoryId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      categoryIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'categoryId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      categoryIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'categoryId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      categoryIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'categoryId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      categoryIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'categoryId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      categoryIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'categoryId',
        value: '',
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      categoryIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'categoryId',
        value: '',
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      codeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'code',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      codeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'code',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      codeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'code',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      codeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'code',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      codeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'code',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      codeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'code',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      codeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'code',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      codeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'code',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      codeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'code',
        value: '',
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      codeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'code',
        value: '',
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      costEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cost',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      costGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cost',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      costLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cost',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      costBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cost',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      depreciationAccountIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'depreciationAccountId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      depreciationAccountIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'depreciationAccountId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      depreciationAccountIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'depreciationAccountId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      depreciationAccountIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'depreciationAccountId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      depreciationAccountIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'depreciationAccountId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      depreciationAccountIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'depreciationAccountId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      depreciationAccountIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'depreciationAccountId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      depreciationAccountIdMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'depreciationAccountId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      depreciationAccountIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'depreciationAccountId',
        value: '',
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      depreciationAccountIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'depreciationAccountId',
        value: '',
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      depreciationMethodEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'depreciationMethod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      depreciationMethodGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'depreciationMethod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      depreciationMethodLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'depreciationMethod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      depreciationMethodBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'depreciationMethod',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      depreciationMethodStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'depreciationMethod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      depreciationMethodEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'depreciationMethod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      depreciationMethodContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'depreciationMethod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      depreciationMethodMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'depreciationMethod',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      depreciationMethodIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'depreciationMethod',
        value: '',
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      depreciationMethodIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'depreciationMethod',
        value: '',
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
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

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
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

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
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

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
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

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
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

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
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

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      idContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      idMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'id',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      isActiveEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isActive',
        value: value,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      isarIdGreaterThan(
    Id value, {
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

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      isarIdLessThan(
    Id value, {
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

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      isarIdBetween(
    Id lower,
    Id upper, {
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

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      nameArEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nameAr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      nameArGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nameAr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      nameArLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nameAr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      nameArBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nameAr',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      nameArStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'nameAr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      nameArEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'nameAr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      nameArContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'nameAr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      nameArMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'nameAr',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      nameArIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nameAr',
        value: '',
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      nameArIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'nameAr',
        value: '',
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      nameEnEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nameEn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      nameEnGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nameEn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      nameEnLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nameEn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      nameEnBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nameEn',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      nameEnStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'nameEn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      nameEnEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'nameEn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      nameEnContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'nameEn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      nameEnMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'nameEn',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      nameEnIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nameEn',
        value: '',
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      nameEnIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'nameEn',
        value: '',
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      residualValueEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'residualValue',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      residualValueGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'residualValue',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      residualValueLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'residualValue',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      residualValueBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'residualValue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      usefulLifeYearsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'usefulLifeYears',
        value: value,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      usefulLifeYearsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'usefulLifeYears',
        value: value,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      usefulLifeYearsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'usefulLifeYears',
        value: value,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      usefulLifeYearsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'usefulLifeYears',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      userIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'userId',
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      userIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'userId',
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      userIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      userIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      userIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      userIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'userId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      userIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      userIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      userIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      userIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      userIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: '',
      ));
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterFilterCondition>
      userIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userId',
        value: '',
      ));
    });
  }
}

extension FixedAssetModelQueryObject
    on QueryBuilder<FixedAssetModel, FixedAssetModel, QFilterCondition> {}

extension FixedAssetModelQueryLinks
    on QueryBuilder<FixedAssetModel, FixedAssetModel, QFilterCondition> {}

extension FixedAssetModelQuerySortBy
    on QueryBuilder<FixedAssetModel, FixedAssetModel, QSortBy> {
  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterSortBy>
      sortByAccumDepreciationAccountId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accumDepreciationAccountId', Sort.asc);
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterSortBy>
      sortByAccumDepreciationAccountIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accumDepreciationAccountId', Sort.desc);
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterSortBy>
      sortByAccumulatedDepreciation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accumulatedDepreciation', Sort.asc);
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterSortBy>
      sortByAccumulatedDepreciationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accumulatedDepreciation', Sort.desc);
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterSortBy>
      sortByAcquisitionDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'acquisitionDate', Sort.asc);
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterSortBy>
      sortByAcquisitionDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'acquisitionDate', Sort.desc);
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterSortBy>
      sortByAssetAccountId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assetAccountId', Sort.asc);
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterSortBy>
      sortByAssetAccountIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assetAccountId', Sort.desc);
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterSortBy>
      sortByCategoryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.asc);
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterSortBy>
      sortByCategoryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.desc);
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterSortBy> sortByCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'code', Sort.asc);
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterSortBy>
      sortByCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'code', Sort.desc);
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterSortBy> sortByCost() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cost', Sort.asc);
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterSortBy>
      sortByCostDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cost', Sort.desc);
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterSortBy>
      sortByDepreciationAccountId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'depreciationAccountId', Sort.asc);
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterSortBy>
      sortByDepreciationAccountIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'depreciationAccountId', Sort.desc);
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterSortBy>
      sortByDepreciationMethod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'depreciationMethod', Sort.asc);
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterSortBy>
      sortByDepreciationMethodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'depreciationMethod', Sort.desc);
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterSortBy>
      sortByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterSortBy>
      sortByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterSortBy> sortByNameAr() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameAr', Sort.asc);
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterSortBy>
      sortByNameArDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameAr', Sort.desc);
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterSortBy> sortByNameEn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameEn', Sort.asc);
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterSortBy>
      sortByNameEnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameEn', Sort.desc);
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterSortBy>
      sortByResidualValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'residualValue', Sort.asc);
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterSortBy>
      sortByResidualValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'residualValue', Sort.desc);
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterSortBy>
      sortByUsefulLifeYears() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'usefulLifeYears', Sort.asc);
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterSortBy>
      sortByUsefulLifeYearsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'usefulLifeYears', Sort.desc);
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterSortBy> sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterSortBy>
      sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension FixedAssetModelQuerySortThenBy
    on QueryBuilder<FixedAssetModel, FixedAssetModel, QSortThenBy> {
  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterSortBy>
      thenByAccumDepreciationAccountId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accumDepreciationAccountId', Sort.asc);
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterSortBy>
      thenByAccumDepreciationAccountIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accumDepreciationAccountId', Sort.desc);
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterSortBy>
      thenByAccumulatedDepreciation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accumulatedDepreciation', Sort.asc);
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterSortBy>
      thenByAccumulatedDepreciationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accumulatedDepreciation', Sort.desc);
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterSortBy>
      thenByAcquisitionDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'acquisitionDate', Sort.asc);
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterSortBy>
      thenByAcquisitionDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'acquisitionDate', Sort.desc);
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterSortBy>
      thenByAssetAccountId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assetAccountId', Sort.asc);
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterSortBy>
      thenByAssetAccountIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assetAccountId', Sort.desc);
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterSortBy>
      thenByCategoryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.asc);
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterSortBy>
      thenByCategoryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.desc);
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterSortBy> thenByCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'code', Sort.asc);
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterSortBy>
      thenByCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'code', Sort.desc);
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterSortBy> thenByCost() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cost', Sort.asc);
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterSortBy>
      thenByCostDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cost', Sort.desc);
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterSortBy>
      thenByDepreciationAccountId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'depreciationAccountId', Sort.asc);
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterSortBy>
      thenByDepreciationAccountIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'depreciationAccountId', Sort.desc);
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterSortBy>
      thenByDepreciationMethod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'depreciationMethod', Sort.asc);
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterSortBy>
      thenByDepreciationMethodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'depreciationMethod', Sort.desc);
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterSortBy>
      thenByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterSortBy>
      thenByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterSortBy> thenByNameAr() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameAr', Sort.asc);
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterSortBy>
      thenByNameArDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameAr', Sort.desc);
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterSortBy> thenByNameEn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameEn', Sort.asc);
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterSortBy>
      thenByNameEnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameEn', Sort.desc);
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterSortBy>
      thenByResidualValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'residualValue', Sort.asc);
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterSortBy>
      thenByResidualValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'residualValue', Sort.desc);
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterSortBy>
      thenByUsefulLifeYears() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'usefulLifeYears', Sort.asc);
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterSortBy>
      thenByUsefulLifeYearsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'usefulLifeYears', Sort.desc);
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterSortBy> thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QAfterSortBy>
      thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension FixedAssetModelQueryWhereDistinct
    on QueryBuilder<FixedAssetModel, FixedAssetModel, QDistinct> {
  QueryBuilder<FixedAssetModel, FixedAssetModel, QDistinct>
      distinctByAccumDepreciationAccountId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'accumDepreciationAccountId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QDistinct>
      distinctByAccumulatedDepreciation() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'accumulatedDepreciation');
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QDistinct>
      distinctByAcquisitionDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'acquisitionDate');
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QDistinct>
      distinctByAssetAccountId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'assetAccountId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QDistinct>
      distinctByCategoryId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'categoryId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QDistinct> distinctByCode(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'code', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QDistinct> distinctByCost() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cost');
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QDistinct>
      distinctByDepreciationAccountId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'depreciationAccountId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QDistinct>
      distinctByDepreciationMethod({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'depreciationMethod',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QDistinct> distinctById(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QDistinct>
      distinctByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isActive');
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QDistinct> distinctByNameAr(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nameAr', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QDistinct> distinctByNameEn(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nameEn', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QDistinct>
      distinctByResidualValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'residualValue');
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QDistinct>
      distinctByUsefulLifeYears() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'usefulLifeYears');
    });
  }

  QueryBuilder<FixedAssetModel, FixedAssetModel, QDistinct> distinctByUserId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId', caseSensitive: caseSensitive);
    });
  }
}

extension FixedAssetModelQueryProperty
    on QueryBuilder<FixedAssetModel, FixedAssetModel, QQueryProperty> {
  QueryBuilder<FixedAssetModel, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<FixedAssetModel, String, QQueryOperations>
      accumDepreciationAccountIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'accumDepreciationAccountId');
    });
  }

  QueryBuilder<FixedAssetModel, double, QQueryOperations>
      accumulatedDepreciationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'accumulatedDepreciation');
    });
  }

  QueryBuilder<FixedAssetModel, DateTime, QQueryOperations>
      acquisitionDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'acquisitionDate');
    });
  }

  QueryBuilder<FixedAssetModel, String, QQueryOperations>
      assetAccountIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'assetAccountId');
    });
  }

  QueryBuilder<FixedAssetModel, String, QQueryOperations> categoryIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'categoryId');
    });
  }

  QueryBuilder<FixedAssetModel, String, QQueryOperations> codeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'code');
    });
  }

  QueryBuilder<FixedAssetModel, double, QQueryOperations> costProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cost');
    });
  }

  QueryBuilder<FixedAssetModel, String, QQueryOperations>
      depreciationAccountIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'depreciationAccountId');
    });
  }

  QueryBuilder<FixedAssetModel, String, QQueryOperations>
      depreciationMethodProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'depreciationMethod');
    });
  }

  QueryBuilder<FixedAssetModel, String, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<FixedAssetModel, bool, QQueryOperations> isActiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isActive');
    });
  }

  QueryBuilder<FixedAssetModel, String, QQueryOperations> nameArProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nameAr');
    });
  }

  QueryBuilder<FixedAssetModel, String, QQueryOperations> nameEnProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nameEn');
    });
  }

  QueryBuilder<FixedAssetModel, double, QQueryOperations>
      residualValueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'residualValue');
    });
  }

  QueryBuilder<FixedAssetModel, int, QQueryOperations>
      usefulLifeYearsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'usefulLifeYears');
    });
  }

  QueryBuilder<FixedAssetModel, String?, QQueryOperations> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }
}
