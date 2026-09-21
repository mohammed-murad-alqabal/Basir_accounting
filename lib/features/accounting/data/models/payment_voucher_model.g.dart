// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_voucher_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPaymentVoucherModelCollection on Isar {
  IsarCollection<PaymentVoucherModel> get paymentVoucherModels =>
      this.collection();
}

const PaymentVoucherModelSchema = CollectionSchema(
  name: r'PaymentVoucherModel',
  id: -5804115213062926314,
  properties: {
    r'accountId': PropertySchema(
      id: 0,
      name: r'accountId',
      type: IsarType.string,
    ),
    r'amount': PropertySchema(
      id: 1,
      name: r'amount',
      type: IsarType.double,
    ),
    r'bankAccountNumber': PropertySchema(
      id: 2,
      name: r'bankAccountNumber',
      type: IsarType.string,
    ),
    r'checkDueDate': PropertySchema(
      id: 3,
      name: r'checkDueDate',
      type: IsarType.dateTime,
    ),
    r'checkNumber': PropertySchema(
      id: 4,
      name: r'checkNumber',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 5,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'createdBy': PropertySchema(
      id: 6,
      name: r'createdBy',
      type: IsarType.string,
    ),
    r'isDeleted': PropertySchema(
      id: 7,
      name: r'isDeleted',
      type: IsarType.bool,
    ),
    r'journalEntryId': PropertySchema(
      id: 8,
      name: r'journalEntryId',
      type: IsarType.string,
    ),
    r'notes': PropertySchema(
      id: 9,
      name: r'notes',
      type: IsarType.string,
    ),
    r'paymentDate': PropertySchema(
      id: 10,
      name: r'paymentDate',
      type: IsarType.dateTime,
    ),
    r'paymentMethod': PropertySchema(
      id: 11,
      name: r'paymentMethod',
      type: IsarType.long,
    ),
    r'paymentVoucherId': PropertySchema(
      id: 12,
      name: r'paymentVoucherId',
      type: IsarType.string,
    ),
    r'reference': PropertySchema(
      id: 13,
      name: r'reference',
      type: IsarType.string,
    ),
    r'serverUpdatedAt': PropertySchema(
      id: 14,
      name: r'serverUpdatedAt',
      type: IsarType.dateTime,
    ),
    r'status': PropertySchema(
      id: 15,
      name: r'status',
      type: IsarType.long,
    ),
    r'syncStatus': PropertySchema(
      id: 16,
      name: r'syncStatus',
      type: IsarType.long,
    ),
    r'userId': PropertySchema(
      id: 17,
      name: r'userId',
      type: IsarType.string,
    ),
    r'vendorId': PropertySchema(
      id: 18,
      name: r'vendorId',
      type: IsarType.string,
    ),
    r'vendorName': PropertySchema(
      id: 19,
      name: r'vendorName',
      type: IsarType.string,
    ),
    r'voucherNumber': PropertySchema(
      id: 20,
      name: r'voucherNumber',
      type: IsarType.string,
    ),
    r'warehouseId': PropertySchema(
      id: 21,
      name: r'warehouseId',
      type: IsarType.string,
    )
  },
  estimateSize: _paymentVoucherModelEstimateSize,
  serialize: _paymentVoucherModelSerialize,
  deserialize: _paymentVoucherModelDeserialize,
  deserializeProp: _paymentVoucherModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'paymentVoucherId': IndexSchema(
      id: -1600435480051296003,
      name: r'paymentVoucherId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'paymentVoucherId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'voucherNumber': IndexSchema(
      id: -6620117117444045036,
      name: r'voucherNumber',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'voucherNumber',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'vendorId': IndexSchema(
      id: -4437098950868530640,
      name: r'vendorId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'vendorId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'paymentDate': IndexSchema(
      id: 2770231740271717250,
      name: r'paymentDate',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'paymentDate',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'accountId': IndexSchema(
      id: -1591555361937770434,
      name: r'accountId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'accountId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'status': IndexSchema(
      id: -107785170620420283,
      name: r'status',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'status',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'userId': IndexSchema(
      id: -2005826577402374815,
      name: r'userId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'userId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'warehouseId': IndexSchema(
      id: -3759612439572445753,
      name: r'warehouseId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'warehouseId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _paymentVoucherModelGetId,
  getLinks: _paymentVoucherModelGetLinks,
  attach: _paymentVoucherModelAttach,
  version: '3.1.0+1',
);

int _paymentVoucherModelEstimateSize(
  PaymentVoucherModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.accountId.length * 3;
  {
    final value = object.bankAccountNumber;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.checkNumber;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.createdBy.length * 3;
  {
    final value = object.journalEntryId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.notes;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.paymentVoucherId.length * 3;
  {
    final value = object.reference;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.userId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.vendorId.length * 3;
  bytesCount += 3 + object.vendorName.length * 3;
  bytesCount += 3 + object.voucherNumber.length * 3;
  {
    final value = object.warehouseId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _paymentVoucherModelSerialize(
  PaymentVoucherModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.accountId);
  writer.writeDouble(offsets[1], object.amount);
  writer.writeString(offsets[2], object.bankAccountNumber);
  writer.writeDateTime(offsets[3], object.checkDueDate);
  writer.writeString(offsets[4], object.checkNumber);
  writer.writeDateTime(offsets[5], object.createdAt);
  writer.writeString(offsets[6], object.createdBy);
  writer.writeBool(offsets[7], object.isDeleted);
  writer.writeString(offsets[8], object.journalEntryId);
  writer.writeString(offsets[9], object.notes);
  writer.writeDateTime(offsets[10], object.paymentDate);
  writer.writeLong(offsets[11], object.paymentMethod);
  writer.writeString(offsets[12], object.paymentVoucherId);
  writer.writeString(offsets[13], object.reference);
  writer.writeDateTime(offsets[14], object.serverUpdatedAt);
  writer.writeLong(offsets[15], object.status);
  writer.writeLong(offsets[16], object.syncStatus);
  writer.writeString(offsets[17], object.userId);
  writer.writeString(offsets[18], object.vendorId);
  writer.writeString(offsets[19], object.vendorName);
  writer.writeString(offsets[20], object.voucherNumber);
  writer.writeString(offsets[21], object.warehouseId);
}

PaymentVoucherModel _paymentVoucherModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PaymentVoucherModel();
  object.accountId = reader.readString(offsets[0]);
  object.amount = reader.readDouble(offsets[1]);
  object.bankAccountNumber = reader.readStringOrNull(offsets[2]);
  object.checkDueDate = reader.readDateTimeOrNull(offsets[3]);
  object.checkNumber = reader.readStringOrNull(offsets[4]);
  object.createdAt = reader.readDateTime(offsets[5]);
  object.createdBy = reader.readString(offsets[6]);
  object.id = id;
  object.isDeleted = reader.readBool(offsets[7]);
  object.journalEntryId = reader.readStringOrNull(offsets[8]);
  object.notes = reader.readStringOrNull(offsets[9]);
  object.paymentDate = reader.readDateTime(offsets[10]);
  object.paymentMethod = reader.readLong(offsets[11]);
  object.paymentVoucherId = reader.readString(offsets[12]);
  object.reference = reader.readStringOrNull(offsets[13]);
  object.serverUpdatedAt = reader.readDateTimeOrNull(offsets[14]);
  object.status = reader.readLong(offsets[15]);
  object.syncStatus = reader.readLong(offsets[16]);
  object.userId = reader.readStringOrNull(offsets[17]);
  object.vendorId = reader.readString(offsets[18]);
  object.vendorName = reader.readString(offsets[19]);
  object.voucherNumber = reader.readString(offsets[20]);
  object.warehouseId = reader.readStringOrNull(offsets[21]);
  return object;
}

P _paymentVoucherModelDeserializeProp<P>(
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
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readDateTime(offset)) as P;
    case 11:
      return (reader.readLong(offset)) as P;
    case 12:
      return (reader.readString(offset)) as P;
    case 13:
      return (reader.readStringOrNull(offset)) as P;
    case 14:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 15:
      return (reader.readLong(offset)) as P;
    case 16:
      return (reader.readLong(offset)) as P;
    case 17:
      return (reader.readStringOrNull(offset)) as P;
    case 18:
      return (reader.readString(offset)) as P;
    case 19:
      return (reader.readString(offset)) as P;
    case 20:
      return (reader.readString(offset)) as P;
    case 21:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _paymentVoucherModelGetId(PaymentVoucherModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _paymentVoucherModelGetLinks(
    PaymentVoucherModel object) {
  return [];
}

void _paymentVoucherModelAttach(
    IsarCollection<dynamic> col, Id id, PaymentVoucherModel object) {
  object.id = id;
}

extension PaymentVoucherModelByIndex on IsarCollection<PaymentVoucherModel> {
  Future<PaymentVoucherModel?> getByPaymentVoucherId(String paymentVoucherId) {
    return getByIndex(r'paymentVoucherId', [paymentVoucherId]);
  }

  PaymentVoucherModel? getByPaymentVoucherIdSync(String paymentVoucherId) {
    return getByIndexSync(r'paymentVoucherId', [paymentVoucherId]);
  }

  Future<bool> deleteByPaymentVoucherId(String paymentVoucherId) {
    return deleteByIndex(r'paymentVoucherId', [paymentVoucherId]);
  }

  bool deleteByPaymentVoucherIdSync(String paymentVoucherId) {
    return deleteByIndexSync(r'paymentVoucherId', [paymentVoucherId]);
  }

  Future<List<PaymentVoucherModel?>> getAllByPaymentVoucherId(
      List<String> paymentVoucherIdValues) {
    final values = paymentVoucherIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'paymentVoucherId', values);
  }

  List<PaymentVoucherModel?> getAllByPaymentVoucherIdSync(
      List<String> paymentVoucherIdValues) {
    final values = paymentVoucherIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'paymentVoucherId', values);
  }

  Future<int> deleteAllByPaymentVoucherId(List<String> paymentVoucherIdValues) {
    final values = paymentVoucherIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'paymentVoucherId', values);
  }

  int deleteAllByPaymentVoucherIdSync(List<String> paymentVoucherIdValues) {
    final values = paymentVoucherIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'paymentVoucherId', values);
  }

  Future<Id> putByPaymentVoucherId(PaymentVoucherModel object) {
    return putByIndex(r'paymentVoucherId', object);
  }

  Id putByPaymentVoucherIdSync(PaymentVoucherModel object,
      {bool saveLinks = true}) {
    return putByIndexSync(r'paymentVoucherId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByPaymentVoucherId(List<PaymentVoucherModel> objects) {
    return putAllByIndex(r'paymentVoucherId', objects);
  }

  List<Id> putAllByPaymentVoucherIdSync(List<PaymentVoucherModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'paymentVoucherId', objects,
        saveLinks: saveLinks);
  }

  Future<PaymentVoucherModel?> getByVoucherNumber(String voucherNumber) {
    return getByIndex(r'voucherNumber', [voucherNumber]);
  }

  PaymentVoucherModel? getByVoucherNumberSync(String voucherNumber) {
    return getByIndexSync(r'voucherNumber', [voucherNumber]);
  }

  Future<bool> deleteByVoucherNumber(String voucherNumber) {
    return deleteByIndex(r'voucherNumber', [voucherNumber]);
  }

  bool deleteByVoucherNumberSync(String voucherNumber) {
    return deleteByIndexSync(r'voucherNumber', [voucherNumber]);
  }

  Future<List<PaymentVoucherModel?>> getAllByVoucherNumber(
      List<String> voucherNumberValues) {
    final values = voucherNumberValues.map((e) => [e]).toList();
    return getAllByIndex(r'voucherNumber', values);
  }

  List<PaymentVoucherModel?> getAllByVoucherNumberSync(
      List<String> voucherNumberValues) {
    final values = voucherNumberValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'voucherNumber', values);
  }

  Future<int> deleteAllByVoucherNumber(List<String> voucherNumberValues) {
    final values = voucherNumberValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'voucherNumber', values);
  }

  int deleteAllByVoucherNumberSync(List<String> voucherNumberValues) {
    final values = voucherNumberValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'voucherNumber', values);
  }

  Future<Id> putByVoucherNumber(PaymentVoucherModel object) {
    return putByIndex(r'voucherNumber', object);
  }

  Id putByVoucherNumberSync(PaymentVoucherModel object,
      {bool saveLinks = true}) {
    return putByIndexSync(r'voucherNumber', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByVoucherNumber(List<PaymentVoucherModel> objects) {
    return putAllByIndex(r'voucherNumber', objects);
  }

  List<Id> putAllByVoucherNumberSync(List<PaymentVoucherModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'voucherNumber', objects, saveLinks: saveLinks);
  }
}

extension PaymentVoucherModelQueryWhereSort
    on QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QWhere> {
  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterWhere>
      anyPaymentDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'paymentDate'),
      );
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterWhere>
      anyStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'status'),
      );
    });
  }
}

extension PaymentVoucherModelQueryWhere
    on QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QWhereClause> {
  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterWhereClause>
      paymentVoucherIdEqualTo(String paymentVoucherId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'paymentVoucherId',
        value: [paymentVoucherId],
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterWhereClause>
      paymentVoucherIdNotEqualTo(String paymentVoucherId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'paymentVoucherId',
              lower: [],
              upper: [paymentVoucherId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'paymentVoucherId',
              lower: [paymentVoucherId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'paymentVoucherId',
              lower: [paymentVoucherId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'paymentVoucherId',
              lower: [],
              upper: [paymentVoucherId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterWhereClause>
      voucherNumberEqualTo(String voucherNumber) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'voucherNumber',
        value: [voucherNumber],
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterWhereClause>
      voucherNumberNotEqualTo(String voucherNumber) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'voucherNumber',
              lower: [],
              upper: [voucherNumber],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'voucherNumber',
              lower: [voucherNumber],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'voucherNumber',
              lower: [voucherNumber],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'voucherNumber',
              lower: [],
              upper: [voucherNumber],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterWhereClause>
      vendorIdEqualTo(String vendorId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'vendorId',
        value: [vendorId],
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterWhereClause>
      vendorIdNotEqualTo(String vendorId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'vendorId',
              lower: [],
              upper: [vendorId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'vendorId',
              lower: [vendorId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'vendorId',
              lower: [vendorId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'vendorId',
              lower: [],
              upper: [vendorId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterWhereClause>
      paymentDateEqualTo(DateTime paymentDate) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'paymentDate',
        value: [paymentDate],
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterWhereClause>
      paymentDateNotEqualTo(DateTime paymentDate) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'paymentDate',
              lower: [],
              upper: [paymentDate],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'paymentDate',
              lower: [paymentDate],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'paymentDate',
              lower: [paymentDate],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'paymentDate',
              lower: [],
              upper: [paymentDate],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterWhereClause>
      paymentDateGreaterThan(
    DateTime paymentDate, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'paymentDate',
        lower: [paymentDate],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterWhereClause>
      paymentDateLessThan(
    DateTime paymentDate, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'paymentDate',
        lower: [],
        upper: [paymentDate],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterWhereClause>
      paymentDateBetween(
    DateTime lowerPaymentDate,
    DateTime upperPaymentDate, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'paymentDate',
        lower: [lowerPaymentDate],
        includeLower: includeLower,
        upper: [upperPaymentDate],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterWhereClause>
      accountIdEqualTo(String accountId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'accountId',
        value: [accountId],
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterWhereClause>
      accountIdNotEqualTo(String accountId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'accountId',
              lower: [],
              upper: [accountId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'accountId',
              lower: [accountId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'accountId',
              lower: [accountId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'accountId',
              lower: [],
              upper: [accountId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterWhereClause>
      statusEqualTo(int status) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'status',
        value: [status],
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterWhereClause>
      statusNotEqualTo(int status) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'status',
              lower: [],
              upper: [status],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'status',
              lower: [status],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'status',
              lower: [status],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'status',
              lower: [],
              upper: [status],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterWhereClause>
      statusGreaterThan(
    int status, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'status',
        lower: [status],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterWhereClause>
      statusLessThan(
    int status, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'status',
        lower: [],
        upper: [status],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterWhereClause>
      statusBetween(
    int lowerStatus,
    int upperStatus, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'status',
        lower: [lowerStatus],
        includeLower: includeLower,
        upper: [upperStatus],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterWhereClause>
      userIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'userId',
        value: [null],
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterWhereClause>
      userIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'userId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterWhereClause>
      userIdEqualTo(String? userId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'userId',
        value: [userId],
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterWhereClause>
      userIdNotEqualTo(String? userId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [],
              upper: [userId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [userId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [userId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [],
              upper: [userId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterWhereClause>
      warehouseIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'warehouseId',
        value: [null],
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterWhereClause>
      warehouseIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'warehouseId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterWhereClause>
      warehouseIdEqualTo(String? warehouseId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'warehouseId',
        value: [warehouseId],
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterWhereClause>
      warehouseIdNotEqualTo(String? warehouseId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'warehouseId',
              lower: [],
              upper: [warehouseId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'warehouseId',
              lower: [warehouseId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'warehouseId',
              lower: [warehouseId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'warehouseId',
              lower: [],
              upper: [warehouseId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension PaymentVoucherModelQueryFilter on QueryBuilder<PaymentVoucherModel,
    PaymentVoucherModel, QFilterCondition> {
  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      accountIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'accountId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      accountIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'accountId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      accountIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'accountId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      accountIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'accountId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      accountIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'accountId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      accountIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'accountId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      accountIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'accountId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      accountIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'accountId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      accountIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'accountId',
        value: '',
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      accountIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'accountId',
        value: '',
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      amountEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'amount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      amountGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'amount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      amountLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'amount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      amountBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'amount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      bankAccountNumberIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'bankAccountNumber',
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      bankAccountNumberIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'bankAccountNumber',
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      bankAccountNumberEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bankAccountNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      bankAccountNumberGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bankAccountNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      bankAccountNumberLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bankAccountNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      bankAccountNumberBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bankAccountNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      bankAccountNumberStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'bankAccountNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      bankAccountNumberEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'bankAccountNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      bankAccountNumberContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'bankAccountNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      bankAccountNumberMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'bankAccountNumber',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      bankAccountNumberIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bankAccountNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      bankAccountNumberIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'bankAccountNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      checkDueDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'checkDueDate',
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      checkDueDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'checkDueDate',
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      checkDueDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'checkDueDate',
        value: value,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      checkDueDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'checkDueDate',
        value: value,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      checkDueDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'checkDueDate',
        value: value,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      checkDueDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'checkDueDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      checkNumberIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'checkNumber',
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      checkNumberIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'checkNumber',
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      checkNumberEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'checkNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      checkNumberGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'checkNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      checkNumberLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'checkNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      checkNumberBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'checkNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      checkNumberStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'checkNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      checkNumberEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'checkNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      checkNumberContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'checkNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      checkNumberMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'checkNumber',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      checkNumberIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'checkNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      checkNumberIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'checkNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      createdAtGreaterThan(
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

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      createdAtLessThan(
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

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      createdAtBetween(
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

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      createdByEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      createdByGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      createdByLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      createdByBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdBy',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      createdByStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'createdBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      createdByEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'createdBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      createdByContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'createdBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      createdByMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'createdBy',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      createdByIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdBy',
        value: '',
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      createdByIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'createdBy',
        value: '',
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      isDeletedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isDeleted',
        value: value,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      journalEntryIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'journalEntryId',
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      journalEntryIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'journalEntryId',
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      journalEntryIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'journalEntryId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      journalEntryIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'journalEntryId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      journalEntryIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'journalEntryId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      journalEntryIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'journalEntryId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      journalEntryIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'journalEntryId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      journalEntryIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'journalEntryId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      journalEntryIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'journalEntryId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      journalEntryIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'journalEntryId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      journalEntryIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'journalEntryId',
        value: '',
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      journalEntryIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'journalEntryId',
        value: '',
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      notesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      notesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      notesEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      notesGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      notesLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      notesBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'notes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      notesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      notesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      notesContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      notesMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'notes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      paymentDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'paymentDate',
        value: value,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      paymentDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'paymentDate',
        value: value,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      paymentDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'paymentDate',
        value: value,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      paymentDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'paymentDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      paymentMethodEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'paymentMethod',
        value: value,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      paymentMethodGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'paymentMethod',
        value: value,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      paymentMethodLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'paymentMethod',
        value: value,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      paymentMethodBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'paymentMethod',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      paymentVoucherIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'paymentVoucherId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      paymentVoucherIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'paymentVoucherId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      paymentVoucherIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'paymentVoucherId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      paymentVoucherIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'paymentVoucherId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      paymentVoucherIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'paymentVoucherId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      paymentVoucherIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'paymentVoucherId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      paymentVoucherIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'paymentVoucherId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      paymentVoucherIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'paymentVoucherId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      paymentVoucherIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'paymentVoucherId',
        value: '',
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      paymentVoucherIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'paymentVoucherId',
        value: '',
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      referenceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'reference',
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      referenceIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'reference',
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      referenceEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reference',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      referenceGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reference',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      referenceLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reference',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      referenceBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reference',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      referenceStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'reference',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      referenceEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'reference',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      referenceContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'reference',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      referenceMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'reference',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      referenceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reference',
        value: '',
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      referenceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'reference',
        value: '',
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      serverUpdatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'serverUpdatedAt',
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      serverUpdatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'serverUpdatedAt',
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      serverUpdatedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'serverUpdatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      serverUpdatedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'serverUpdatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      serverUpdatedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'serverUpdatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      serverUpdatedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'serverUpdatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      statusEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      statusGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      statusLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      statusBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      syncStatusEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'syncStatus',
        value: value,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      syncStatusGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'syncStatus',
        value: value,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      syncStatusLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'syncStatus',
        value: value,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      syncStatusBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'syncStatus',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      userIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'userId',
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      userIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'userId',
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
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

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
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

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
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

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
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

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
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

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
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

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      userIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      userIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      userIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: '',
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      userIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userId',
        value: '',
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      vendorIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vendorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      vendorIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'vendorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      vendorIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'vendorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      vendorIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'vendorId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      vendorIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'vendorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      vendorIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'vendorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      vendorIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'vendorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      vendorIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'vendorId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      vendorIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vendorId',
        value: '',
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      vendorIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'vendorId',
        value: '',
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      vendorNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vendorName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      vendorNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'vendorName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      vendorNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'vendorName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      vendorNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'vendorName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      vendorNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'vendorName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      vendorNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'vendorName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      vendorNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'vendorName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      vendorNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'vendorName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      vendorNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vendorName',
        value: '',
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      vendorNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'vendorName',
        value: '',
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      voucherNumberEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'voucherNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      voucherNumberGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'voucherNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      voucherNumberLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'voucherNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      voucherNumberBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'voucherNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      voucherNumberStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'voucherNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      voucherNumberEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'voucherNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      voucherNumberContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'voucherNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      voucherNumberMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'voucherNumber',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      voucherNumberIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'voucherNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      voucherNumberIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'voucherNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      warehouseIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'warehouseId',
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      warehouseIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'warehouseId',
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      warehouseIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'warehouseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      warehouseIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'warehouseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      warehouseIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'warehouseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      warehouseIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'warehouseId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      warehouseIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'warehouseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      warehouseIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'warehouseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      warehouseIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'warehouseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      warehouseIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'warehouseId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      warehouseIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'warehouseId',
        value: '',
      ));
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterFilterCondition>
      warehouseIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'warehouseId',
        value: '',
      ));
    });
  }
}

extension PaymentVoucherModelQueryObject on QueryBuilder<PaymentVoucherModel,
    PaymentVoucherModel, QFilterCondition> {}

extension PaymentVoucherModelQueryLinks on QueryBuilder<PaymentVoucherModel,
    PaymentVoucherModel, QFilterCondition> {}

extension PaymentVoucherModelQuerySortBy
    on QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QSortBy> {
  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      sortByAccountId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountId', Sort.asc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      sortByAccountIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountId', Sort.desc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      sortByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      sortByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      sortByBankAccountNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bankAccountNumber', Sort.asc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      sortByBankAccountNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bankAccountNumber', Sort.desc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      sortByCheckDueDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkDueDate', Sort.asc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      sortByCheckDueDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkDueDate', Sort.desc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      sortByCheckNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkNumber', Sort.asc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      sortByCheckNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkNumber', Sort.desc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      sortByCreatedBy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdBy', Sort.asc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      sortByCreatedByDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdBy', Sort.desc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      sortByIsDeleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDeleted', Sort.asc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      sortByIsDeletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDeleted', Sort.desc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      sortByJournalEntryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'journalEntryId', Sort.asc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      sortByJournalEntryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'journalEntryId', Sort.desc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      sortByPaymentDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentDate', Sort.asc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      sortByPaymentDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentDate', Sort.desc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      sortByPaymentMethod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentMethod', Sort.asc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      sortByPaymentMethodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentMethod', Sort.desc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      sortByPaymentVoucherId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentVoucherId', Sort.asc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      sortByPaymentVoucherIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentVoucherId', Sort.desc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      sortByReference() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reference', Sort.asc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      sortByReferenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reference', Sort.desc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      sortByServerUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverUpdatedAt', Sort.asc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      sortByServerUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverUpdatedAt', Sort.desc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      sortBySyncStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.asc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      sortBySyncStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.desc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      sortByVendorId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vendorId', Sort.asc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      sortByVendorIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vendorId', Sort.desc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      sortByVendorName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vendorName', Sort.asc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      sortByVendorNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vendorName', Sort.desc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      sortByVoucherNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'voucherNumber', Sort.asc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      sortByVoucherNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'voucherNumber', Sort.desc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      sortByWarehouseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'warehouseId', Sort.asc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      sortByWarehouseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'warehouseId', Sort.desc);
    });
  }
}

extension PaymentVoucherModelQuerySortThenBy
    on QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QSortThenBy> {
  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      thenByAccountId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountId', Sort.asc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      thenByAccountIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountId', Sort.desc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      thenByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      thenByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      thenByBankAccountNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bankAccountNumber', Sort.asc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      thenByBankAccountNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bankAccountNumber', Sort.desc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      thenByCheckDueDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkDueDate', Sort.asc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      thenByCheckDueDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkDueDate', Sort.desc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      thenByCheckNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkNumber', Sort.asc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      thenByCheckNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkNumber', Sort.desc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      thenByCreatedBy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdBy', Sort.asc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      thenByCreatedByDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdBy', Sort.desc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      thenByIsDeleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDeleted', Sort.asc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      thenByIsDeletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDeleted', Sort.desc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      thenByJournalEntryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'journalEntryId', Sort.asc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      thenByJournalEntryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'journalEntryId', Sort.desc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      thenByPaymentDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentDate', Sort.asc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      thenByPaymentDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentDate', Sort.desc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      thenByPaymentMethod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentMethod', Sort.asc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      thenByPaymentMethodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentMethod', Sort.desc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      thenByPaymentVoucherId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentVoucherId', Sort.asc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      thenByPaymentVoucherIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentVoucherId', Sort.desc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      thenByReference() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reference', Sort.asc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      thenByReferenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reference', Sort.desc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      thenByServerUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverUpdatedAt', Sort.asc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      thenByServerUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverUpdatedAt', Sort.desc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      thenBySyncStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.asc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      thenBySyncStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.desc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      thenByVendorId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vendorId', Sort.asc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      thenByVendorIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vendorId', Sort.desc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      thenByVendorName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vendorName', Sort.asc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      thenByVendorNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vendorName', Sort.desc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      thenByVoucherNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'voucherNumber', Sort.asc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      thenByVoucherNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'voucherNumber', Sort.desc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      thenByWarehouseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'warehouseId', Sort.asc);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QAfterSortBy>
      thenByWarehouseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'warehouseId', Sort.desc);
    });
  }
}

extension PaymentVoucherModelQueryWhereDistinct
    on QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QDistinct> {
  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QDistinct>
      distinctByAccountId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'accountId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QDistinct>
      distinctByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amount');
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QDistinct>
      distinctByBankAccountNumber({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bankAccountNumber',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QDistinct>
      distinctByCheckDueDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'checkDueDate');
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QDistinct>
      distinctByCheckNumber({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'checkNumber', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QDistinct>
      distinctByCreatedBy({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdBy', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QDistinct>
      distinctByIsDeleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isDeleted');
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QDistinct>
      distinctByJournalEntryId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'journalEntryId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QDistinct>
      distinctByNotes({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QDistinct>
      distinctByPaymentDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'paymentDate');
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QDistinct>
      distinctByPaymentMethod() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'paymentMethod');
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QDistinct>
      distinctByPaymentVoucherId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'paymentVoucherId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QDistinct>
      distinctByReference({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reference', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QDistinct>
      distinctByServerUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'serverUpdatedAt');
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QDistinct>
      distinctByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status');
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QDistinct>
      distinctBySyncStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'syncStatus');
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QDistinct>
      distinctByUserId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QDistinct>
      distinctByVendorId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'vendorId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QDistinct>
      distinctByVendorName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'vendorName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QDistinct>
      distinctByVoucherNumber({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'voucherNumber',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QDistinct>
      distinctByWarehouseId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'warehouseId', caseSensitive: caseSensitive);
    });
  }
}

extension PaymentVoucherModelQueryProperty
    on QueryBuilder<PaymentVoucherModel, PaymentVoucherModel, QQueryProperty> {
  QueryBuilder<PaymentVoucherModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PaymentVoucherModel, String, QQueryOperations>
      accountIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'accountId');
    });
  }

  QueryBuilder<PaymentVoucherModel, double, QQueryOperations> amountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amount');
    });
  }

  QueryBuilder<PaymentVoucherModel, String?, QQueryOperations>
      bankAccountNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bankAccountNumber');
    });
  }

  QueryBuilder<PaymentVoucherModel, DateTime?, QQueryOperations>
      checkDueDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'checkDueDate');
    });
  }

  QueryBuilder<PaymentVoucherModel, String?, QQueryOperations>
      checkNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'checkNumber');
    });
  }

  QueryBuilder<PaymentVoucherModel, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<PaymentVoucherModel, String, QQueryOperations>
      createdByProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdBy');
    });
  }

  QueryBuilder<PaymentVoucherModel, bool, QQueryOperations>
      isDeletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isDeleted');
    });
  }

  QueryBuilder<PaymentVoucherModel, String?, QQueryOperations>
      journalEntryIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'journalEntryId');
    });
  }

  QueryBuilder<PaymentVoucherModel, String?, QQueryOperations> notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<PaymentVoucherModel, DateTime, QQueryOperations>
      paymentDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'paymentDate');
    });
  }

  QueryBuilder<PaymentVoucherModel, int, QQueryOperations>
      paymentMethodProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'paymentMethod');
    });
  }

  QueryBuilder<PaymentVoucherModel, String, QQueryOperations>
      paymentVoucherIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'paymentVoucherId');
    });
  }

  QueryBuilder<PaymentVoucherModel, String?, QQueryOperations>
      referenceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reference');
    });
  }

  QueryBuilder<PaymentVoucherModel, DateTime?, QQueryOperations>
      serverUpdatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'serverUpdatedAt');
    });
  }

  QueryBuilder<PaymentVoucherModel, int, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<PaymentVoucherModel, int, QQueryOperations>
      syncStatusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncStatus');
    });
  }

  QueryBuilder<PaymentVoucherModel, String?, QQueryOperations>
      userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }

  QueryBuilder<PaymentVoucherModel, String, QQueryOperations>
      vendorIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'vendorId');
    });
  }

  QueryBuilder<PaymentVoucherModel, String, QQueryOperations>
      vendorNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'vendorName');
    });
  }

  QueryBuilder<PaymentVoucherModel, String, QQueryOperations>
      voucherNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'voucherNumber');
    });
  }

  QueryBuilder<PaymentVoucherModel, String?, QQueryOperations>
      warehouseIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'warehouseId');
    });
  }
}
