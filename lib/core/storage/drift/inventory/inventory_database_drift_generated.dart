// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_database.dart';

// ignore_for_file: type=lint
class $InventoryItemsTable extends InventoryItems
    with TableInfo<$InventoryItemsTable, InventoryItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InventoryItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
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
  static const VerificationMeta _skuMeta = const VerificationMeta('sku');
  @override
  late final GeneratedColumn<String> sku = GeneratedColumn<String>(
      'sku', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _barcodeMeta =
      const VerificationMeta('barcode');
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
      'barcode', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _purchasePriceMeta =
      const VerificationMeta('purchasePrice');
  @override
  late final GeneratedColumn<double> purchasePrice = GeneratedColumn<double>(
      'purchase_price', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _salePriceMeta =
      const VerificationMeta('salePrice');
  @override
  late final GeneratedColumn<double> salePrice = GeneratedColumn<double>(
      'sale_price', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _currentQuantityMeta =
      const VerificationMeta('currentQuantity');
  @override
  late final GeneratedColumn<double> currentQuantity = GeneratedColumn<double>(
      'current_quantity', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
      'category_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _valuationMethodMeta =
      const VerificationMeta('valuationMethod');
  @override
  late final GeneratedColumn<String> valuationMethod = GeneratedColumn<String>(
      'valuation_method', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('weightedAverage'));
  static const VerificationMeta _assetAccountIdMeta =
      const VerificationMeta('assetAccountId');
  @override
  late final GeneratedColumn<String> assetAccountId = GeneratedColumn<String>(
      'asset_account_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _cogsAccountIdMeta =
      const VerificationMeta('cogsAccountId');
  @override
  late final GeneratedColumn<String> cogsAccountId = GeneratedColumn<String>(
      'cogs_account_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _revenueAccountIdMeta =
      const VerificationMeta('revenueAccountId');
  @override
  late final GeneratedColumn<String> revenueAccountId = GeneratedColumn<String>(
      'revenue_account_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _primaryAccountIdMeta =
      const VerificationMeta('primaryAccountId');
  @override
  late final GeneratedColumn<String> primaryAccountId = GeneratedColumn<String>(
      'primary_account_id', aliasedName, true,
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
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _warehouseIdMeta =
      const VerificationMeta('warehouseId');
  @override
  late final GeneratedColumn<String> warehouseId = GeneratedColumn<String>(
      'warehouse_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _taxCategoryMeta =
      const VerificationMeta('taxCategory');
  @override
  late final GeneratedColumn<String> taxCategory = GeneratedColumn<String>(
      'tax_category', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('S'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        nameAr,
        nameEn,
        sku,
        barcode,
        description,
        purchasePrice,
        salePrice,
        currentQuantity,
        unit,
        categoryId,
        valuationMethod,
        assetAccountId,
        cogsAccountId,
        revenueAccountId,
        primaryAccountId,
        syncStatus,
        serverUpdatedAt,
        isDeleted,
        createdAt,
        updatedAt,
        userId,
        warehouseId,
        taxCategory
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inventory_items';
  @override
  VerificationContext validateIntegrity(Insertable<InventoryItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
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
    if (data.containsKey('sku')) {
      context.handle(
          _skuMeta, sku.isAcceptableOrUnknown(data['sku']!, _skuMeta));
    }
    if (data.containsKey('barcode')) {
      context.handle(_barcodeMeta,
          barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('purchase_price')) {
      context.handle(
          _purchasePriceMeta,
          purchasePrice.isAcceptableOrUnknown(
              data['purchase_price']!, _purchasePriceMeta));
    }
    if (data.containsKey('sale_price')) {
      context.handle(_salePriceMeta,
          salePrice.isAcceptableOrUnknown(data['sale_price']!, _salePriceMeta));
    }
    if (data.containsKey('current_quantity')) {
      context.handle(
          _currentQuantityMeta,
          currentQuantity.isAcceptableOrUnknown(
              data['current_quantity']!, _currentQuantityMeta));
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    }
    if (data.containsKey('valuation_method')) {
      context.handle(
          _valuationMethodMeta,
          valuationMethod.isAcceptableOrUnknown(
              data['valuation_method']!, _valuationMethodMeta));
    }
    if (data.containsKey('asset_account_id')) {
      context.handle(
          _assetAccountIdMeta,
          assetAccountId.isAcceptableOrUnknown(
              data['asset_account_id']!, _assetAccountIdMeta));
    }
    if (data.containsKey('cogs_account_id')) {
      context.handle(
          _cogsAccountIdMeta,
          cogsAccountId.isAcceptableOrUnknown(
              data['cogs_account_id']!, _cogsAccountIdMeta));
    }
    if (data.containsKey('revenue_account_id')) {
      context.handle(
          _revenueAccountIdMeta,
          revenueAccountId.isAcceptableOrUnknown(
              data['revenue_account_id']!, _revenueAccountIdMeta));
    }
    if (data.containsKey('primary_account_id')) {
      context.handle(
          _primaryAccountIdMeta,
          primaryAccountId.isAcceptableOrUnknown(
              data['primary_account_id']!, _primaryAccountIdMeta));
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
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    }
    if (data.containsKey('warehouse_id')) {
      context.handle(
          _warehouseIdMeta,
          warehouseId.isAcceptableOrUnknown(
              data['warehouse_id']!, _warehouseIdMeta));
    }
    if (data.containsKey('tax_category')) {
      context.handle(
          _taxCategoryMeta,
          taxCategory.isAcceptableOrUnknown(
              data['tax_category']!, _taxCategoryMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InventoryItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InventoryItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      nameAr: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_ar'])!,
      nameEn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_en'])!,
      sku: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sku']),
      barcode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}barcode']),
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      purchasePrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}purchase_price']),
      salePrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}sale_price']),
      currentQuantity: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}current_quantity'])!,
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit']),
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category_id']),
      valuationMethod: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}valuation_method'])!,
      assetAccountId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}asset_account_id']),
      cogsAccountId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cogs_account_id']),
      revenueAccountId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}revenue_account_id']),
      primaryAccountId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}primary_account_id']),
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
      serverUpdatedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}server_updated_at']),
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id']),
      warehouseId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}warehouse_id']),
      taxCategory: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tax_category'])!,
    );
  }

  @override
  $InventoryItemsTable createAlias(String alias) {
    return $InventoryItemsTable(attachedDatabase, alias);
  }
}

class InventoryItem extends DataClass implements Insertable<InventoryItem> {
  final String id;
  final String nameAr;
  final String nameEn;
  final String? sku;
  final String? barcode;
  final String? description;
  final double? purchasePrice;
  final double? salePrice;
  final double currentQuantity;
  final String? unit;
  final String? categoryId;
  final String valuationMethod;
  final String? assetAccountId;
  final String? cogsAccountId;
  final String? revenueAccountId;
  final String? primaryAccountId;
  final String syncStatus;
  final DateTime? serverUpdatedAt;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? userId;
  final String? warehouseId;
  final String taxCategory;
  const InventoryItem(
      {required this.id,
      required this.nameAr,
      required this.nameEn,
      this.sku,
      this.barcode,
      this.description,
      this.purchasePrice,
      this.salePrice,
      required this.currentQuantity,
      this.unit,
      this.categoryId,
      required this.valuationMethod,
      this.assetAccountId,
      this.cogsAccountId,
      this.revenueAccountId,
      this.primaryAccountId,
      required this.syncStatus,
      this.serverUpdatedAt,
      required this.isDeleted,
      required this.createdAt,
      required this.updatedAt,
      this.userId,
      this.warehouseId,
      required this.taxCategory});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name_ar'] = Variable<String>(nameAr);
    map['name_en'] = Variable<String>(nameEn);
    if (!nullToAbsent || sku != null) {
      map['sku'] = Variable<String>(sku);
    }
    if (!nullToAbsent || barcode != null) {
      map['barcode'] = Variable<String>(barcode);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || purchasePrice != null) {
      map['purchase_price'] = Variable<double>(purchasePrice);
    }
    if (!nullToAbsent || salePrice != null) {
      map['sale_price'] = Variable<double>(salePrice);
    }
    map['current_quantity'] = Variable<double>(currentQuantity);
    if (!nullToAbsent || unit != null) {
      map['unit'] = Variable<String>(unit);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    map['valuation_method'] = Variable<String>(valuationMethod);
    if (!nullToAbsent || assetAccountId != null) {
      map['asset_account_id'] = Variable<String>(assetAccountId);
    }
    if (!nullToAbsent || cogsAccountId != null) {
      map['cogs_account_id'] = Variable<String>(cogsAccountId);
    }
    if (!nullToAbsent || revenueAccountId != null) {
      map['revenue_account_id'] = Variable<String>(revenueAccountId);
    }
    if (!nullToAbsent || primaryAccountId != null) {
      map['primary_account_id'] = Variable<String>(primaryAccountId);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || serverUpdatedAt != null) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt);
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    if (!nullToAbsent || warehouseId != null) {
      map['warehouse_id'] = Variable<String>(warehouseId);
    }
    map['tax_category'] = Variable<String>(taxCategory);
    return map;
  }

  InventoryItemsCompanion toCompanion(bool nullToAbsent) {
    return InventoryItemsCompanion(
      id: Value(id),
      nameAr: Value(nameAr),
      nameEn: Value(nameEn),
      sku: sku == null && nullToAbsent ? const Value.absent() : Value(sku),
      barcode: barcode == null && nullToAbsent
          ? const Value.absent()
          : Value(barcode),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      purchasePrice: purchasePrice == null && nullToAbsent
          ? const Value.absent()
          : Value(purchasePrice),
      salePrice: salePrice == null && nullToAbsent
          ? const Value.absent()
          : Value(salePrice),
      currentQuantity: Value(currentQuantity),
      unit: unit == null && nullToAbsent ? const Value.absent() : Value(unit),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      valuationMethod: Value(valuationMethod),
      assetAccountId: assetAccountId == null && nullToAbsent
          ? const Value.absent()
          : Value(assetAccountId),
      cogsAccountId: cogsAccountId == null && nullToAbsent
          ? const Value.absent()
          : Value(cogsAccountId),
      revenueAccountId: revenueAccountId == null && nullToAbsent
          ? const Value.absent()
          : Value(revenueAccountId),
      primaryAccountId: primaryAccountId == null && nullToAbsent
          ? const Value.absent()
          : Value(primaryAccountId),
      syncStatus: Value(syncStatus),
      serverUpdatedAt: serverUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(serverUpdatedAt),
      isDeleted: Value(isDeleted),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
      warehouseId: warehouseId == null && nullToAbsent
          ? const Value.absent()
          : Value(warehouseId),
      taxCategory: Value(taxCategory),
    );
  }

  factory InventoryItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InventoryItem(
      id: serializer.fromJson<String>(json['id']),
      nameAr: serializer.fromJson<String>(json['nameAr']),
      nameEn: serializer.fromJson<String>(json['nameEn']),
      sku: serializer.fromJson<String?>(json['sku']),
      barcode: serializer.fromJson<String?>(json['barcode']),
      description: serializer.fromJson<String?>(json['description']),
      purchasePrice: serializer.fromJson<double?>(json['purchasePrice']),
      salePrice: serializer.fromJson<double?>(json['salePrice']),
      currentQuantity: serializer.fromJson<double>(json['currentQuantity']),
      unit: serializer.fromJson<String?>(json['unit']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      valuationMethod: serializer.fromJson<String>(json['valuationMethod']),
      assetAccountId: serializer.fromJson<String?>(json['assetAccountId']),
      cogsAccountId: serializer.fromJson<String?>(json['cogsAccountId']),
      revenueAccountId: serializer.fromJson<String?>(json['revenueAccountId']),
      primaryAccountId: serializer.fromJson<String?>(json['primaryAccountId']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      serverUpdatedAt: serializer.fromJson<DateTime?>(json['serverUpdatedAt']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      userId: serializer.fromJson<String?>(json['userId']),
      warehouseId: serializer.fromJson<String?>(json['warehouseId']),
      taxCategory: serializer.fromJson<String>(json['taxCategory']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nameAr': serializer.toJson<String>(nameAr),
      'nameEn': serializer.toJson<String>(nameEn),
      'sku': serializer.toJson<String?>(sku),
      'barcode': serializer.toJson<String?>(barcode),
      'description': serializer.toJson<String?>(description),
      'purchasePrice': serializer.toJson<double?>(purchasePrice),
      'salePrice': serializer.toJson<double?>(salePrice),
      'currentQuantity': serializer.toJson<double>(currentQuantity),
      'unit': serializer.toJson<String?>(unit),
      'categoryId': serializer.toJson<String?>(categoryId),
      'valuationMethod': serializer.toJson<String>(valuationMethod),
      'assetAccountId': serializer.toJson<String?>(assetAccountId),
      'cogsAccountId': serializer.toJson<String?>(cogsAccountId),
      'revenueAccountId': serializer.toJson<String?>(revenueAccountId),
      'primaryAccountId': serializer.toJson<String?>(primaryAccountId),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'serverUpdatedAt': serializer.toJson<DateTime?>(serverUpdatedAt),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'userId': serializer.toJson<String?>(userId),
      'warehouseId': serializer.toJson<String?>(warehouseId),
      'taxCategory': serializer.toJson<String>(taxCategory),
    };
  }

  InventoryItem copyWith(
          {String? id,
          String? nameAr,
          String? nameEn,
          Value<String?> sku = const Value.absent(),
          Value<String?> barcode = const Value.absent(),
          Value<String?> description = const Value.absent(),
          Value<double?> purchasePrice = const Value.absent(),
          Value<double?> salePrice = const Value.absent(),
          double? currentQuantity,
          Value<String?> unit = const Value.absent(),
          Value<String?> categoryId = const Value.absent(),
          String? valuationMethod,
          Value<String?> assetAccountId = const Value.absent(),
          Value<String?> cogsAccountId = const Value.absent(),
          Value<String?> revenueAccountId = const Value.absent(),
          Value<String?> primaryAccountId = const Value.absent(),
          String? syncStatus,
          Value<DateTime?> serverUpdatedAt = const Value.absent(),
          bool? isDeleted,
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<String?> userId = const Value.absent(),
          Value<String?> warehouseId = const Value.absent(),
          String? taxCategory}) =>
      InventoryItem(
        id: id ?? this.id,
        nameAr: nameAr ?? this.nameAr,
        nameEn: nameEn ?? this.nameEn,
        sku: sku.present ? sku.value : this.sku,
        barcode: barcode.present ? barcode.value : this.barcode,
        description: description.present ? description.value : this.description,
        purchasePrice:
            purchasePrice.present ? purchasePrice.value : this.purchasePrice,
        salePrice: salePrice.present ? salePrice.value : this.salePrice,
        currentQuantity: currentQuantity ?? this.currentQuantity,
        unit: unit.present ? unit.value : this.unit,
        categoryId: categoryId.present ? categoryId.value : this.categoryId,
        valuationMethod: valuationMethod ?? this.valuationMethod,
        assetAccountId:
            assetAccountId.present ? assetAccountId.value : this.assetAccountId,
        cogsAccountId:
            cogsAccountId.present ? cogsAccountId.value : this.cogsAccountId,
        revenueAccountId: revenueAccountId.present
            ? revenueAccountId.value
            : this.revenueAccountId,
        primaryAccountId: primaryAccountId.present
            ? primaryAccountId.value
            : this.primaryAccountId,
        syncStatus: syncStatus ?? this.syncStatus,
        serverUpdatedAt: serverUpdatedAt.present
            ? serverUpdatedAt.value
            : this.serverUpdatedAt,
        isDeleted: isDeleted ?? this.isDeleted,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        userId: userId.present ? userId.value : this.userId,
        warehouseId: warehouseId.present ? warehouseId.value : this.warehouseId,
        taxCategory: taxCategory ?? this.taxCategory,
      );
  InventoryItem copyWithCompanion(InventoryItemsCompanion data) {
    return InventoryItem(
      id: data.id.present ? data.id.value : this.id,
      nameAr: data.nameAr.present ? data.nameAr.value : this.nameAr,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
      sku: data.sku.present ? data.sku.value : this.sku,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      description:
          data.description.present ? data.description.value : this.description,
      purchasePrice: data.purchasePrice.present
          ? data.purchasePrice.value
          : this.purchasePrice,
      salePrice: data.salePrice.present ? data.salePrice.value : this.salePrice,
      currentQuantity: data.currentQuantity.present
          ? data.currentQuantity.value
          : this.currentQuantity,
      unit: data.unit.present ? data.unit.value : this.unit,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      valuationMethod: data.valuationMethod.present
          ? data.valuationMethod.value
          : this.valuationMethod,
      assetAccountId: data.assetAccountId.present
          ? data.assetAccountId.value
          : this.assetAccountId,
      cogsAccountId: data.cogsAccountId.present
          ? data.cogsAccountId.value
          : this.cogsAccountId,
      revenueAccountId: data.revenueAccountId.present
          ? data.revenueAccountId.value
          : this.revenueAccountId,
      primaryAccountId: data.primaryAccountId.present
          ? data.primaryAccountId.value
          : this.primaryAccountId,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      serverUpdatedAt: data.serverUpdatedAt.present
          ? data.serverUpdatedAt.value
          : this.serverUpdatedAt,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      userId: data.userId.present ? data.userId.value : this.userId,
      warehouseId:
          data.warehouseId.present ? data.warehouseId.value : this.warehouseId,
      taxCategory:
          data.taxCategory.present ? data.taxCategory.value : this.taxCategory,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InventoryItem(')
          ..write('id: $id, ')
          ..write('nameAr: $nameAr, ')
          ..write('nameEn: $nameEn, ')
          ..write('sku: $sku, ')
          ..write('barcode: $barcode, ')
          ..write('description: $description, ')
          ..write('purchasePrice: $purchasePrice, ')
          ..write('salePrice: $salePrice, ')
          ..write('currentQuantity: $currentQuantity, ')
          ..write('unit: $unit, ')
          ..write('categoryId: $categoryId, ')
          ..write('valuationMethod: $valuationMethod, ')
          ..write('assetAccountId: $assetAccountId, ')
          ..write('cogsAccountId: $cogsAccountId, ')
          ..write('revenueAccountId: $revenueAccountId, ')
          ..write('primaryAccountId: $primaryAccountId, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('userId: $userId, ')
          ..write('warehouseId: $warehouseId, ')
          ..write('taxCategory: $taxCategory')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        nameAr,
        nameEn,
        sku,
        barcode,
        description,
        purchasePrice,
        salePrice,
        currentQuantity,
        unit,
        categoryId,
        valuationMethod,
        assetAccountId,
        cogsAccountId,
        revenueAccountId,
        primaryAccountId,
        syncStatus,
        serverUpdatedAt,
        isDeleted,
        createdAt,
        updatedAt,
        userId,
        warehouseId,
        taxCategory
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InventoryItem &&
          other.id == this.id &&
          other.nameAr == this.nameAr &&
          other.nameEn == this.nameEn &&
          other.sku == this.sku &&
          other.barcode == this.barcode &&
          other.description == this.description &&
          other.purchasePrice == this.purchasePrice &&
          other.salePrice == this.salePrice &&
          other.currentQuantity == this.currentQuantity &&
          other.unit == this.unit &&
          other.categoryId == this.categoryId &&
          other.valuationMethod == this.valuationMethod &&
          other.assetAccountId == this.assetAccountId &&
          other.cogsAccountId == this.cogsAccountId &&
          other.revenueAccountId == this.revenueAccountId &&
          other.primaryAccountId == this.primaryAccountId &&
          other.syncStatus == this.syncStatus &&
          other.serverUpdatedAt == this.serverUpdatedAt &&
          other.isDeleted == this.isDeleted &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.userId == this.userId &&
          other.warehouseId == this.warehouseId &&
          other.taxCategory == this.taxCategory);
}

class InventoryItemsCompanion extends UpdateCompanion<InventoryItem> {
  final Value<String> id;
  final Value<String> nameAr;
  final Value<String> nameEn;
  final Value<String?> sku;
  final Value<String?> barcode;
  final Value<String?> description;
  final Value<double?> purchasePrice;
  final Value<double?> salePrice;
  final Value<double> currentQuantity;
  final Value<String?> unit;
  final Value<String?> categoryId;
  final Value<String> valuationMethod;
  final Value<String?> assetAccountId;
  final Value<String?> cogsAccountId;
  final Value<String?> revenueAccountId;
  final Value<String?> primaryAccountId;
  final Value<String> syncStatus;
  final Value<DateTime?> serverUpdatedAt;
  final Value<bool> isDeleted;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String?> userId;
  final Value<String?> warehouseId;
  final Value<String> taxCategory;
  final Value<int> rowid;
  const InventoryItemsCompanion({
    this.id = const Value.absent(),
    this.nameAr = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.sku = const Value.absent(),
    this.barcode = const Value.absent(),
    this.description = const Value.absent(),
    this.purchasePrice = const Value.absent(),
    this.salePrice = const Value.absent(),
    this.currentQuantity = const Value.absent(),
    this.unit = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.valuationMethod = const Value.absent(),
    this.assetAccountId = const Value.absent(),
    this.cogsAccountId = const Value.absent(),
    this.revenueAccountId = const Value.absent(),
    this.primaryAccountId = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.userId = const Value.absent(),
    this.warehouseId = const Value.absent(),
    this.taxCategory = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InventoryItemsCompanion.insert({
    required String id,
    required String nameAr,
    required String nameEn,
    this.sku = const Value.absent(),
    this.barcode = const Value.absent(),
    this.description = const Value.absent(),
    this.purchasePrice = const Value.absent(),
    this.salePrice = const Value.absent(),
    this.currentQuantity = const Value.absent(),
    this.unit = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.valuationMethod = const Value.absent(),
    this.assetAccountId = const Value.absent(),
    this.cogsAccountId = const Value.absent(),
    this.revenueAccountId = const Value.absent(),
    this.primaryAccountId = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.userId = const Value.absent(),
    this.warehouseId = const Value.absent(),
    this.taxCategory = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        nameAr = Value(nameAr),
        nameEn = Value(nameEn),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<InventoryItem> custom({
    Expression<String>? id,
    Expression<String>? nameAr,
    Expression<String>? nameEn,
    Expression<String>? sku,
    Expression<String>? barcode,
    Expression<String>? description,
    Expression<double>? purchasePrice,
    Expression<double>? salePrice,
    Expression<double>? currentQuantity,
    Expression<String>? unit,
    Expression<String>? categoryId,
    Expression<String>? valuationMethod,
    Expression<String>? assetAccountId,
    Expression<String>? cogsAccountId,
    Expression<String>? revenueAccountId,
    Expression<String>? primaryAccountId,
    Expression<String>? syncStatus,
    Expression<DateTime>? serverUpdatedAt,
    Expression<bool>? isDeleted,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? userId,
    Expression<String>? warehouseId,
    Expression<String>? taxCategory,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nameAr != null) 'name_ar': nameAr,
      if (nameEn != null) 'name_en': nameEn,
      if (sku != null) 'sku': sku,
      if (barcode != null) 'barcode': barcode,
      if (description != null) 'description': description,
      if (purchasePrice != null) 'purchase_price': purchasePrice,
      if (salePrice != null) 'sale_price': salePrice,
      if (currentQuantity != null) 'current_quantity': currentQuantity,
      if (unit != null) 'unit': unit,
      if (categoryId != null) 'category_id': categoryId,
      if (valuationMethod != null) 'valuation_method': valuationMethod,
      if (assetAccountId != null) 'asset_account_id': assetAccountId,
      if (cogsAccountId != null) 'cogs_account_id': cogsAccountId,
      if (revenueAccountId != null) 'revenue_account_id': revenueAccountId,
      if (primaryAccountId != null) 'primary_account_id': primaryAccountId,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (serverUpdatedAt != null) 'server_updated_at': serverUpdatedAt,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (userId != null) 'user_id': userId,
      if (warehouseId != null) 'warehouse_id': warehouseId,
      if (taxCategory != null) 'tax_category': taxCategory,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InventoryItemsCompanion copyWith(
      {Value<String>? id,
      Value<String>? nameAr,
      Value<String>? nameEn,
      Value<String?>? sku,
      Value<String?>? barcode,
      Value<String?>? description,
      Value<double?>? purchasePrice,
      Value<double?>? salePrice,
      Value<double>? currentQuantity,
      Value<String?>? unit,
      Value<String?>? categoryId,
      Value<String>? valuationMethod,
      Value<String?>? assetAccountId,
      Value<String?>? cogsAccountId,
      Value<String?>? revenueAccountId,
      Value<String?>? primaryAccountId,
      Value<String>? syncStatus,
      Value<DateTime?>? serverUpdatedAt,
      Value<bool>? isDeleted,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<String?>? userId,
      Value<String?>? warehouseId,
      Value<String>? taxCategory,
      Value<int>? rowid}) {
    return InventoryItemsCompanion(
      id: id ?? this.id,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
      sku: sku ?? this.sku,
      barcode: barcode ?? this.barcode,
      description: description ?? this.description,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      salePrice: salePrice ?? this.salePrice,
      currentQuantity: currentQuantity ?? this.currentQuantity,
      unit: unit ?? this.unit,
      categoryId: categoryId ?? this.categoryId,
      valuationMethod: valuationMethod ?? this.valuationMethod,
      assetAccountId: assetAccountId ?? this.assetAccountId,
      cogsAccountId: cogsAccountId ?? this.cogsAccountId,
      revenueAccountId: revenueAccountId ?? this.revenueAccountId,
      primaryAccountId: primaryAccountId ?? this.primaryAccountId,
      syncStatus: syncStatus ?? this.syncStatus,
      serverUpdatedAt: serverUpdatedAt ?? this.serverUpdatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
      warehouseId: warehouseId ?? this.warehouseId,
      taxCategory: taxCategory ?? this.taxCategory,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nameAr.present) {
      map['name_ar'] = Variable<String>(nameAr.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (sku.present) {
      map['sku'] = Variable<String>(sku.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (purchasePrice.present) {
      map['purchase_price'] = Variable<double>(purchasePrice.value);
    }
    if (salePrice.present) {
      map['sale_price'] = Variable<double>(salePrice.value);
    }
    if (currentQuantity.present) {
      map['current_quantity'] = Variable<double>(currentQuantity.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (valuationMethod.present) {
      map['valuation_method'] = Variable<String>(valuationMethod.value);
    }
    if (assetAccountId.present) {
      map['asset_account_id'] = Variable<String>(assetAccountId.value);
    }
    if (cogsAccountId.present) {
      map['cogs_account_id'] = Variable<String>(cogsAccountId.value);
    }
    if (revenueAccountId.present) {
      map['revenue_account_id'] = Variable<String>(revenueAccountId.value);
    }
    if (primaryAccountId.present) {
      map['primary_account_id'] = Variable<String>(primaryAccountId.value);
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
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (warehouseId.present) {
      map['warehouse_id'] = Variable<String>(warehouseId.value);
    }
    if (taxCategory.present) {
      map['tax_category'] = Variable<String>(taxCategory.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InventoryItemsCompanion(')
          ..write('id: $id, ')
          ..write('nameAr: $nameAr, ')
          ..write('nameEn: $nameEn, ')
          ..write('sku: $sku, ')
          ..write('barcode: $barcode, ')
          ..write('description: $description, ')
          ..write('purchasePrice: $purchasePrice, ')
          ..write('salePrice: $salePrice, ')
          ..write('currentQuantity: $currentQuantity, ')
          ..write('unit: $unit, ')
          ..write('categoryId: $categoryId, ')
          ..write('valuationMethod: $valuationMethod, ')
          ..write('assetAccountId: $assetAccountId, ')
          ..write('cogsAccountId: $cogsAccountId, ')
          ..write('revenueAccountId: $revenueAccountId, ')
          ..write('primaryAccountId: $primaryAccountId, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('userId: $userId, ')
          ..write('warehouseId: $warehouseId, ')
          ..write('taxCategory: $taxCategory, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$InventoryDatabase extends GeneratedDatabase {
  _$InventoryDatabase(QueryExecutor e) : super(e);
  $InventoryDatabaseManager get managers => $InventoryDatabaseManager(this);
  late final $InventoryItemsTable inventoryItems = $InventoryItemsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [inventoryItems];
}

typedef $$InventoryItemsTableCreateCompanionBuilder = InventoryItemsCompanion
    Function({
  required String id,
  required String nameAr,
  required String nameEn,
  Value<String?> sku,
  Value<String?> barcode,
  Value<String?> description,
  Value<double?> purchasePrice,
  Value<double?> salePrice,
  Value<double> currentQuantity,
  Value<String?> unit,
  Value<String?> categoryId,
  Value<String> valuationMethod,
  Value<String?> assetAccountId,
  Value<String?> cogsAccountId,
  Value<String?> revenueAccountId,
  Value<String?> primaryAccountId,
  Value<String> syncStatus,
  Value<DateTime?> serverUpdatedAt,
  Value<bool> isDeleted,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<String?> userId,
  Value<String?> warehouseId,
  Value<String> taxCategory,
  Value<int> rowid,
});
typedef $$InventoryItemsTableUpdateCompanionBuilder = InventoryItemsCompanion
    Function({
  Value<String> id,
  Value<String> nameAr,
  Value<String> nameEn,
  Value<String?> sku,
  Value<String?> barcode,
  Value<String?> description,
  Value<double?> purchasePrice,
  Value<double?> salePrice,
  Value<double> currentQuantity,
  Value<String?> unit,
  Value<String?> categoryId,
  Value<String> valuationMethod,
  Value<String?> assetAccountId,
  Value<String?> cogsAccountId,
  Value<String?> revenueAccountId,
  Value<String?> primaryAccountId,
  Value<String> syncStatus,
  Value<DateTime?> serverUpdatedAt,
  Value<bool> isDeleted,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<String?> userId,
  Value<String?> warehouseId,
  Value<String> taxCategory,
  Value<int> rowid,
});

class $$InventoryItemsTableFilterComposer
    extends Composer<_$InventoryDatabase, $InventoryItemsTable> {
  $$InventoryItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameAr => $composableBuilder(
      column: $table.nameAr, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameEn => $composableBuilder(
      column: $table.nameEn, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sku => $composableBuilder(
      column: $table.sku, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get barcode => $composableBuilder(
      column: $table.barcode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get purchasePrice => $composableBuilder(
      column: $table.purchasePrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get salePrice => $composableBuilder(
      column: $table.salePrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get currentQuantity => $composableBuilder(
      column: $table.currentQuantity,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get valuationMethod => $composableBuilder(
      column: $table.valuationMethod,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get assetAccountId => $composableBuilder(
      column: $table.assetAccountId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cogsAccountId => $composableBuilder(
      column: $table.cogsAccountId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get revenueAccountId => $composableBuilder(
      column: $table.revenueAccountId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get primaryAccountId => $composableBuilder(
      column: $table.primaryAccountId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get serverUpdatedAt => $composableBuilder(
      column: $table.serverUpdatedAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get warehouseId => $composableBuilder(
      column: $table.warehouseId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get taxCategory => $composableBuilder(
      column: $table.taxCategory, builder: (column) => ColumnFilters(column));
}

class $$InventoryItemsTableOrderingComposer
    extends Composer<_$InventoryDatabase, $InventoryItemsTable> {
  $$InventoryItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameAr => $composableBuilder(
      column: $table.nameAr, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameEn => $composableBuilder(
      column: $table.nameEn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sku => $composableBuilder(
      column: $table.sku, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get barcode => $composableBuilder(
      column: $table.barcode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get purchasePrice => $composableBuilder(
      column: $table.purchasePrice,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get salePrice => $composableBuilder(
      column: $table.salePrice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get currentQuantity => $composableBuilder(
      column: $table.currentQuantity,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get valuationMethod => $composableBuilder(
      column: $table.valuationMethod,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get assetAccountId => $composableBuilder(
      column: $table.assetAccountId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cogsAccountId => $composableBuilder(
      column: $table.cogsAccountId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get revenueAccountId => $composableBuilder(
      column: $table.revenueAccountId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get primaryAccountId => $composableBuilder(
      column: $table.primaryAccountId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get serverUpdatedAt => $composableBuilder(
      column: $table.serverUpdatedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get warehouseId => $composableBuilder(
      column: $table.warehouseId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get taxCategory => $composableBuilder(
      column: $table.taxCategory, builder: (column) => ColumnOrderings(column));
}

class $$InventoryItemsTableAnnotationComposer
    extends Composer<_$InventoryDatabase, $InventoryItemsTable> {
  $$InventoryItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nameAr =>
      $composableBuilder(column: $table.nameAr, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);

  GeneratedColumn<String> get sku =>
      $composableBuilder(column: $table.sku, builder: (column) => column);

  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<double> get purchasePrice => $composableBuilder(
      column: $table.purchasePrice, builder: (column) => column);

  GeneratedColumn<double> get salePrice =>
      $composableBuilder(column: $table.salePrice, builder: (column) => column);

  GeneratedColumn<double> get currentQuantity => $composableBuilder(
      column: $table.currentQuantity, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => column);

  GeneratedColumn<String> get valuationMethod => $composableBuilder(
      column: $table.valuationMethod, builder: (column) => column);

  GeneratedColumn<String> get assetAccountId => $composableBuilder(
      column: $table.assetAccountId, builder: (column) => column);

  GeneratedColumn<String> get cogsAccountId => $composableBuilder(
      column: $table.cogsAccountId, builder: (column) => column);

  GeneratedColumn<String> get revenueAccountId => $composableBuilder(
      column: $table.revenueAccountId, builder: (column) => column);

  GeneratedColumn<String> get primaryAccountId => $composableBuilder(
      column: $table.primaryAccountId, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);

  GeneratedColumn<DateTime> get serverUpdatedAt => $composableBuilder(
      column: $table.serverUpdatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get warehouseId => $composableBuilder(
      column: $table.warehouseId, builder: (column) => column);

  GeneratedColumn<String> get taxCategory => $composableBuilder(
      column: $table.taxCategory, builder: (column) => column);
}

class $$InventoryItemsTableTableManager extends RootTableManager<
    _$InventoryDatabase,
    $InventoryItemsTable,
    InventoryItem,
    $$InventoryItemsTableFilterComposer,
    $$InventoryItemsTableOrderingComposer,
    $$InventoryItemsTableAnnotationComposer,
    $$InventoryItemsTableCreateCompanionBuilder,
    $$InventoryItemsTableUpdateCompanionBuilder,
    (
      InventoryItem,
      BaseReferences<_$InventoryDatabase, $InventoryItemsTable, InventoryItem>
    ),
    InventoryItem,
    PrefetchHooks Function()> {
  $$InventoryItemsTableTableManager(
      _$InventoryDatabase db, $InventoryItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InventoryItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InventoryItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InventoryItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> nameAr = const Value.absent(),
            Value<String> nameEn = const Value.absent(),
            Value<String?> sku = const Value.absent(),
            Value<String?> barcode = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<double?> purchasePrice = const Value.absent(),
            Value<double?> salePrice = const Value.absent(),
            Value<double> currentQuantity = const Value.absent(),
            Value<String?> unit = const Value.absent(),
            Value<String?> categoryId = const Value.absent(),
            Value<String> valuationMethod = const Value.absent(),
            Value<String?> assetAccountId = const Value.absent(),
            Value<String?> cogsAccountId = const Value.absent(),
            Value<String?> revenueAccountId = const Value.absent(),
            Value<String?> primaryAccountId = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<DateTime?> serverUpdatedAt = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<String?> userId = const Value.absent(),
            Value<String?> warehouseId = const Value.absent(),
            Value<String> taxCategory = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              InventoryItemsCompanion(
            id: id,
            nameAr: nameAr,
            nameEn: nameEn,
            sku: sku,
            barcode: barcode,
            description: description,
            purchasePrice: purchasePrice,
            salePrice: salePrice,
            currentQuantity: currentQuantity,
            unit: unit,
            categoryId: categoryId,
            valuationMethod: valuationMethod,
            assetAccountId: assetAccountId,
            cogsAccountId: cogsAccountId,
            revenueAccountId: revenueAccountId,
            primaryAccountId: primaryAccountId,
            syncStatus: syncStatus,
            serverUpdatedAt: serverUpdatedAt,
            isDeleted: isDeleted,
            createdAt: createdAt,
            updatedAt: updatedAt,
            userId: userId,
            warehouseId: warehouseId,
            taxCategory: taxCategory,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String nameAr,
            required String nameEn,
            Value<String?> sku = const Value.absent(),
            Value<String?> barcode = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<double?> purchasePrice = const Value.absent(),
            Value<double?> salePrice = const Value.absent(),
            Value<double> currentQuantity = const Value.absent(),
            Value<String?> unit = const Value.absent(),
            Value<String?> categoryId = const Value.absent(),
            Value<String> valuationMethod = const Value.absent(),
            Value<String?> assetAccountId = const Value.absent(),
            Value<String?> cogsAccountId = const Value.absent(),
            Value<String?> revenueAccountId = const Value.absent(),
            Value<String?> primaryAccountId = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<DateTime?> serverUpdatedAt = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<String?> userId = const Value.absent(),
            Value<String?> warehouseId = const Value.absent(),
            Value<String> taxCategory = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              InventoryItemsCompanion.insert(
            id: id,
            nameAr: nameAr,
            nameEn: nameEn,
            sku: sku,
            barcode: barcode,
            description: description,
            purchasePrice: purchasePrice,
            salePrice: salePrice,
            currentQuantity: currentQuantity,
            unit: unit,
            categoryId: categoryId,
            valuationMethod: valuationMethod,
            assetAccountId: assetAccountId,
            cogsAccountId: cogsAccountId,
            revenueAccountId: revenueAccountId,
            primaryAccountId: primaryAccountId,
            syncStatus: syncStatus,
            serverUpdatedAt: serverUpdatedAt,
            isDeleted: isDeleted,
            createdAt: createdAt,
            updatedAt: updatedAt,
            userId: userId,
            warehouseId: warehouseId,
            taxCategory: taxCategory,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$InventoryItemsTableProcessedTableManager = ProcessedTableManager<
    _$InventoryDatabase,
    $InventoryItemsTable,
    InventoryItem,
    $$InventoryItemsTableFilterComposer,
    $$InventoryItemsTableOrderingComposer,
    $$InventoryItemsTableAnnotationComposer,
    $$InventoryItemsTableCreateCompanionBuilder,
    $$InventoryItemsTableUpdateCompanionBuilder,
    (
      InventoryItem,
      BaseReferences<_$InventoryDatabase, $InventoryItemsTable, InventoryItem>
    ),
    InventoryItem,
    PrefetchHooks Function()>;

class $InventoryDatabaseManager {
  final _$InventoryDatabase _db;
  $InventoryDatabaseManager(this._db);
  $$InventoryItemsTableTableManager get inventoryItems =>
      $$InventoryItemsTableTableManager(_db, _db.inventoryItems);
}
