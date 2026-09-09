// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bulk_price_change_execution_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetBulkPriceChangeExecutionModelCollection on Isar {
  IsarCollection<BulkPriceChangeExecutionModel>
      get bulkPriceChangeExecutionModels => this.collection();
}

const BulkPriceChangeExecutionModelSchema = CollectionSchema(
  name: r'BulkPriceChangeExecutionModel',
  id: -1852737194493072598,
  properties: {
    r'cancellationDeadline': PropertySchema(
      id: 0,
      name: r'cancellationDeadline',
      type: IsarType.dateTime,
    ),
    r'cancelledAt': PropertySchema(
      id: 1,
      name: r'cancelledAt',
      type: IsarType.dateTime,
    ),
    r'createdAt': PropertySchema(
      id: 2,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'effectiveAt': PropertySchema(
      id: 3,
      name: r'effectiveAt',
      type: IsarType.dateTime,
    ),
    r'executedAt': PropertySchema(
      id: 4,
      name: r'executedAt',
      type: IsarType.dateTime,
    ),
    r'id': PropertySchema(
      id: 5,
      name: r'id',
      type: IsarType.string,
    ),
    r'operatorName': PropertySchema(
      id: 6,
      name: r'operatorName',
      type: IsarType.string,
    ),
    r'reason': PropertySchema(
      id: 7,
      name: r'reason',
      type: IsarType.string,
    ),
    r'recordJson': PropertySchema(
      id: 8,
      name: r'recordJson',
      type: IsarType.string,
    )
  },
  estimateSize: _bulkPriceChangeExecutionModelEstimateSize,
  serialize: _bulkPriceChangeExecutionModelSerialize,
  deserialize: _bulkPriceChangeExecutionModelDeserialize,
  deserializeProp: _bulkPriceChangeExecutionModelDeserializeProp,
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
    ),
    r'operatorName': IndexSchema(
      id: 7092374673249713856,
      name: r'operatorName',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'operatorName',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'executedAt': IndexSchema(
      id: -1394297690758325806,
      name: r'executedAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'executedAt',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'cancellationDeadline': IndexSchema(
      id: 8290133688577042348,
      name: r'cancellationDeadline',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'cancellationDeadline',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _bulkPriceChangeExecutionModelGetId,
  getLinks: _bulkPriceChangeExecutionModelGetLinks,
  attach: _bulkPriceChangeExecutionModelAttach,
  version: '3.1.0+1',
);

int _bulkPriceChangeExecutionModelEstimateSize(
  BulkPriceChangeExecutionModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.id.length * 3;
  bytesCount += 3 + object.operatorName.length * 3;
  bytesCount += 3 + object.reason.length * 3;
  bytesCount += 3 + object.recordJson.length * 3;
  return bytesCount;
}

void _bulkPriceChangeExecutionModelSerialize(
  BulkPriceChangeExecutionModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.cancellationDeadline);
  writer.writeDateTime(offsets[1], object.cancelledAt);
  writer.writeDateTime(offsets[2], object.createdAt);
  writer.writeDateTime(offsets[3], object.effectiveAt);
  writer.writeDateTime(offsets[4], object.executedAt);
  writer.writeString(offsets[5], object.id);
  writer.writeString(offsets[6], object.operatorName);
  writer.writeString(offsets[7], object.reason);
  writer.writeString(offsets[8], object.recordJson);
}

BulkPriceChangeExecutionModel _bulkPriceChangeExecutionModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = BulkPriceChangeExecutionModel();
  object.cancellationDeadline = reader.readDateTime(offsets[0]);
  object.cancelledAt = reader.readDateTimeOrNull(offsets[1]);
  object.createdAt = reader.readDateTime(offsets[2]);
  object.effectiveAt = reader.readDateTimeOrNull(offsets[3]);
  object.executedAt = reader.readDateTime(offsets[4]);
  object.id = reader.readString(offsets[5]);
  object.isarId = id;
  object.operatorName = reader.readString(offsets[6]);
  object.reason = reader.readString(offsets[7]);
  object.recordJson = reader.readString(offsets[8]);
  return object;
}

P _bulkPriceChangeExecutionModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _bulkPriceChangeExecutionModelGetId(BulkPriceChangeExecutionModel object) {
  return object.isarId ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _bulkPriceChangeExecutionModelGetLinks(
    BulkPriceChangeExecutionModel object) {
  return [];
}

void _bulkPriceChangeExecutionModelAttach(
    IsarCollection<dynamic> col, Id id, BulkPriceChangeExecutionModel object) {
  object.isarId = id;
}

extension BulkPriceChangeExecutionModelByIndex
    on IsarCollection<BulkPriceChangeExecutionModel> {
  Future<BulkPriceChangeExecutionModel?> getById(String id) {
    return getByIndex(r'id', [id]);
  }

  BulkPriceChangeExecutionModel? getByIdSync(String id) {
    return getByIndexSync(r'id', [id]);
  }

  Future<bool> deleteById(String id) {
    return deleteByIndex(r'id', [id]);
  }

  bool deleteByIdSync(String id) {
    return deleteByIndexSync(r'id', [id]);
  }

  Future<List<BulkPriceChangeExecutionModel?>> getAllById(
      List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndex(r'id', values);
  }

  List<BulkPriceChangeExecutionModel?> getAllByIdSync(List<String> idValues) {
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

  Future<Id> putById(BulkPriceChangeExecutionModel object) {
    return putByIndex(r'id', object);
  }

  Id putByIdSync(BulkPriceChangeExecutionModel object,
      {bool saveLinks = true}) {
    return putByIndexSync(r'id', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllById(List<BulkPriceChangeExecutionModel> objects) {
    return putAllByIndex(r'id', objects);
  }

  List<Id> putAllByIdSync(List<BulkPriceChangeExecutionModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'id', objects, saveLinks: saveLinks);
  }
}

extension BulkPriceChangeExecutionModelQueryWhereSort on QueryBuilder<
    BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel, QWhere> {
  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterWhere> anyExecutedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'executedAt'),
      );
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterWhere> anyCancellationDeadline() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'cancellationDeadline'),
      );
    });
  }
}

extension BulkPriceChangeExecutionModelQueryWhere on QueryBuilder<
    BulkPriceChangeExecutionModel,
    BulkPriceChangeExecutionModel,
    QWhereClause> {
  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterWhereClause> isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterWhereClause> isarIdNotEqualTo(Id isarId) {
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

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterWhereClause> isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterWhereClause> isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterWhereClause> isarIdBetween(
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

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterWhereClause> idEqualTo(String id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'id',
        value: [id],
      ));
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterWhereClause> idNotEqualTo(String id) {
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

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterWhereClause> operatorNameEqualTo(String operatorName) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'operatorName',
        value: [operatorName],
      ));
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterWhereClause> operatorNameNotEqualTo(String operatorName) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'operatorName',
              lower: [],
              upper: [operatorName],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'operatorName',
              lower: [operatorName],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'operatorName',
              lower: [operatorName],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'operatorName',
              lower: [],
              upper: [operatorName],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterWhereClause> executedAtEqualTo(DateTime executedAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'executedAt',
        value: [executedAt],
      ));
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterWhereClause> executedAtNotEqualTo(DateTime executedAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'executedAt',
              lower: [],
              upper: [executedAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'executedAt',
              lower: [executedAt],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'executedAt',
              lower: [executedAt],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'executedAt',
              lower: [],
              upper: [executedAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterWhereClause> executedAtGreaterThan(
    DateTime executedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'executedAt',
        lower: [executedAt],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterWhereClause> executedAtLessThan(
    DateTime executedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'executedAt',
        lower: [],
        upper: [executedAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterWhereClause> executedAtBetween(
    DateTime lowerExecutedAt,
    DateTime upperExecutedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'executedAt',
        lower: [lowerExecutedAt],
        includeLower: includeLower,
        upper: [upperExecutedAt],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
          QAfterWhereClause>
      cancellationDeadlineEqualTo(DateTime cancellationDeadline) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'cancellationDeadline',
        value: [cancellationDeadline],
      ));
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
          QAfterWhereClause>
      cancellationDeadlineNotEqualTo(DateTime cancellationDeadline) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'cancellationDeadline',
              lower: [],
              upper: [cancellationDeadline],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'cancellationDeadline',
              lower: [cancellationDeadline],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'cancellationDeadline',
              lower: [cancellationDeadline],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'cancellationDeadline',
              lower: [],
              upper: [cancellationDeadline],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterWhereClause> cancellationDeadlineGreaterThan(
    DateTime cancellationDeadline, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'cancellationDeadline',
        lower: [cancellationDeadline],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterWhereClause> cancellationDeadlineLessThan(
    DateTime cancellationDeadline, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'cancellationDeadline',
        lower: [],
        upper: [cancellationDeadline],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterWhereClause> cancellationDeadlineBetween(
    DateTime lowerCancellationDeadline,
    DateTime upperCancellationDeadline, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'cancellationDeadline',
        lower: [lowerCancellationDeadline],
        includeLower: includeLower,
        upper: [upperCancellationDeadline],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension BulkPriceChangeExecutionModelQueryFilter on QueryBuilder<
    BulkPriceChangeExecutionModel,
    BulkPriceChangeExecutionModel,
    QFilterCondition> {
  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterFilterCondition> cancellationDeadlineEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cancellationDeadline',
        value: value,
      ));
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterFilterCondition> cancellationDeadlineGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cancellationDeadline',
        value: value,
      ));
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterFilterCondition> cancellationDeadlineLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cancellationDeadline',
        value: value,
      ));
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterFilterCondition> cancellationDeadlineBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cancellationDeadline',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterFilterCondition> cancelledAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'cancelledAt',
      ));
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterFilterCondition> cancelledAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'cancelledAt',
      ));
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterFilterCondition> cancelledAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cancelledAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterFilterCondition> cancelledAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cancelledAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterFilterCondition> cancelledAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cancelledAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterFilterCondition> cancelledAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cancelledAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterFilterCondition> createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterFilterCondition> createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterFilterCondition> createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterFilterCondition> effectiveAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'effectiveAt',
      ));
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterFilterCondition> effectiveAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'effectiveAt',
      ));
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterFilterCondition> effectiveAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'effectiveAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterFilterCondition> effectiveAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'effectiveAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterFilterCondition> effectiveAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'effectiveAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterFilterCondition> effectiveAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'effectiveAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterFilterCondition> executedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'executedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterFilterCondition> executedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'executedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterFilterCondition> executedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'executedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterFilterCondition> executedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'executedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterFilterCondition> idEqualTo(
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

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterFilterCondition> idLessThan(
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

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterFilterCondition> idBetween(
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

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterFilterCondition> idStartsWith(
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

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterFilterCondition> idEndsWith(
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

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
          QAfterFilterCondition>
      idContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
          QAfterFilterCondition>
      idMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'id',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterFilterCondition> idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterFilterCondition> idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterFilterCondition> isarIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isarId',
      ));
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterFilterCondition> isarIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isarId',
      ));
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterFilterCondition> isarIdEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterFilterCondition> isarIdGreaterThan(
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

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterFilterCondition> isarIdLessThan(
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

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterFilterCondition> isarIdBetween(
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

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterFilterCondition> operatorNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'operatorName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterFilterCondition> operatorNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'operatorName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterFilterCondition> operatorNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'operatorName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterFilterCondition> operatorNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'operatorName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterFilterCondition> operatorNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'operatorName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterFilterCondition> operatorNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'operatorName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
          QAfterFilterCondition>
      operatorNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'operatorName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
          QAfterFilterCondition>
      operatorNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'operatorName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterFilterCondition> operatorNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'operatorName',
        value: '',
      ));
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterFilterCondition> operatorNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'operatorName',
        value: '',
      ));
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterFilterCondition> reasonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterFilterCondition> reasonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterFilterCondition> reasonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterFilterCondition> reasonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reason',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterFilterCondition> reasonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'reason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterFilterCondition> reasonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'reason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
          QAfterFilterCondition>
      reasonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'reason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
          QAfterFilterCondition>
      reasonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'reason',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterFilterCondition> reasonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reason',
        value: '',
      ));
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterFilterCondition> reasonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'reason',
        value: '',
      ));
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterFilterCondition> recordJsonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recordJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterFilterCondition> recordJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'recordJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterFilterCondition> recordJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'recordJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterFilterCondition> recordJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'recordJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterFilterCondition> recordJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'recordJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterFilterCondition> recordJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'recordJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
          QAfterFilterCondition>
      recordJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'recordJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
          QAfterFilterCondition>
      recordJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'recordJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterFilterCondition> recordJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recordJson',
        value: '',
      ));
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterFilterCondition> recordJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'recordJson',
        value: '',
      ));
    });
  }
}

extension BulkPriceChangeExecutionModelQueryObject on QueryBuilder<
    BulkPriceChangeExecutionModel,
    BulkPriceChangeExecutionModel,
    QFilterCondition> {}

extension BulkPriceChangeExecutionModelQueryLinks on QueryBuilder<
    BulkPriceChangeExecutionModel,
    BulkPriceChangeExecutionModel,
    QFilterCondition> {}

extension BulkPriceChangeExecutionModelQuerySortBy on QueryBuilder<
    BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel, QSortBy> {
  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterSortBy> sortByCancellationDeadline() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cancellationDeadline', Sort.asc);
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterSortBy> sortByCancellationDeadlineDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cancellationDeadline', Sort.desc);
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterSortBy> sortByCancelledAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cancelledAt', Sort.asc);
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterSortBy> sortByCancelledAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cancelledAt', Sort.desc);
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterSortBy> sortByEffectiveAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'effectiveAt', Sort.asc);
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterSortBy> sortByEffectiveAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'effectiveAt', Sort.desc);
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterSortBy> sortByExecutedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'executedAt', Sort.asc);
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterSortBy> sortByExecutedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'executedAt', Sort.desc);
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterSortBy> sortByOperatorName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'operatorName', Sort.asc);
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterSortBy> sortByOperatorNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'operatorName', Sort.desc);
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterSortBy> sortByReason() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reason', Sort.asc);
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterSortBy> sortByReasonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reason', Sort.desc);
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterSortBy> sortByRecordJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recordJson', Sort.asc);
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterSortBy> sortByRecordJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recordJson', Sort.desc);
    });
  }
}

extension BulkPriceChangeExecutionModelQuerySortThenBy on QueryBuilder<
    BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel, QSortThenBy> {
  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterSortBy> thenByCancellationDeadline() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cancellationDeadline', Sort.asc);
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterSortBy> thenByCancellationDeadlineDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cancellationDeadline', Sort.desc);
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterSortBy> thenByCancelledAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cancelledAt', Sort.asc);
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterSortBy> thenByCancelledAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cancelledAt', Sort.desc);
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterSortBy> thenByEffectiveAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'effectiveAt', Sort.asc);
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterSortBy> thenByEffectiveAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'effectiveAt', Sort.desc);
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterSortBy> thenByExecutedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'executedAt', Sort.asc);
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterSortBy> thenByExecutedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'executedAt', Sort.desc);
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterSortBy> thenByOperatorName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'operatorName', Sort.asc);
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterSortBy> thenByOperatorNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'operatorName', Sort.desc);
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterSortBy> thenByReason() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reason', Sort.asc);
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterSortBy> thenByReasonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reason', Sort.desc);
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterSortBy> thenByRecordJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recordJson', Sort.asc);
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QAfterSortBy> thenByRecordJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recordJson', Sort.desc);
    });
  }
}

extension BulkPriceChangeExecutionModelQueryWhereDistinct on QueryBuilder<
    BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel, QDistinct> {
  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QDistinct> distinctByCancellationDeadline() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cancellationDeadline');
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QDistinct> distinctByCancelledAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cancelledAt');
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QDistinct> distinctByEffectiveAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'effectiveAt');
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QDistinct> distinctByExecutedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'executedAt');
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QDistinct> distinctById({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QDistinct> distinctByOperatorName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'operatorName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QDistinct> distinctByReason({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reason', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, BulkPriceChangeExecutionModel,
      QDistinct> distinctByRecordJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'recordJson', caseSensitive: caseSensitive);
    });
  }
}

extension BulkPriceChangeExecutionModelQueryProperty on QueryBuilder<
    BulkPriceChangeExecutionModel,
    BulkPriceChangeExecutionModel,
    QQueryProperty> {
  QueryBuilder<BulkPriceChangeExecutionModel, int, QQueryOperations>
      isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, DateTime, QQueryOperations>
      cancellationDeadlineProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cancellationDeadline');
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, DateTime?, QQueryOperations>
      cancelledAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cancelledAt');
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, DateTime?, QQueryOperations>
      effectiveAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'effectiveAt');
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, DateTime, QQueryOperations>
      executedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'executedAt');
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, String, QQueryOperations>
      idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, String, QQueryOperations>
      operatorNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'operatorName');
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, String, QQueryOperations>
      reasonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reason');
    });
  }

  QueryBuilder<BulkPriceChangeExecutionModel, String, QQueryOperations>
      recordJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recordJson');
    });
  }
}
