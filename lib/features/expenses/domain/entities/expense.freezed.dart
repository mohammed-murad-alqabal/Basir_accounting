// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Expense _$ExpenseFromJson(Map<String, dynamic> json) {
  return _Expense.fromJson(json);
}

/// @nodoc
mixin _$Expense {
  /// The unique identifier of the expense.
  String get id => throw _privateConstructorUsedError;

  /// A brief description of the expense.
  String get description => throw _privateConstructorUsedError;

  /// The monetary amount of the expense.
  Decimal get amount => throw _privateConstructorUsedError;

  /// The currency code (e.g., 'SAR').
  String get currencyCode => throw _privateConstructorUsedError;

  /// The date the expense was incurred.
  DateTime get expenseDate => throw _privateConstructorUsedError;

  /// The ID of the category this expense belongs to.
  String get categoryId => throw _privateConstructorUsedError;

  /// The optional ID of the vendor.
  String? get vendorId => throw _privateConstructorUsedError;

  /// The optional name of the vendor.
  String? get vendorName => throw _privateConstructorUsedError;

  /// The URL or path to the receipt image.
  String? get receiptUrl => throw _privateConstructorUsedError;

  /// Additional notes or remarks.
  String? get notes => throw _privateConstructorUsedError;

  /// Whether this is a recurring expense.
  bool get isRecurring => throw _privateConstructorUsedError;

  /// The date when the recurrence ends, if applicable.
  DateTime? get recurringEndDate => throw _privateConstructorUsedError;

  /// The current status of the expense (e.g., pending, approved).
  String get status =>
      throw _privateConstructorUsedError; // pending, approved, rejected, posted
  /// The ID of the associated GL journal entry when posted.
  String? get journalEntryId =>
      throw _privateConstructorUsedError; // Link to GL when posted
  /// The ID of the user who created this record.
  String? get createdBy => throw _privateConstructorUsedError;

  /// The timestamp when this record was created.
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// The timestamp when this record was last updated.
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ExpenseCopyWith<Expense> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExpenseCopyWith<$Res> {
  factory $ExpenseCopyWith(Expense value, $Res Function(Expense) then) =
      _$ExpenseCopyWithImpl<$Res, Expense>;
  @useResult
  $Res call(
      {String id,
      String description,
      Decimal amount,
      String currencyCode,
      DateTime expenseDate,
      String categoryId,
      String? vendorId,
      String? vendorName,
      String? receiptUrl,
      String? notes,
      bool isRecurring,
      DateTime? recurringEndDate,
      String status,
      String? journalEntryId,
      String? createdBy,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$ExpenseCopyWithImpl<$Res, $Val extends Expense>
    implements $ExpenseCopyWith<$Res> {
  _$ExpenseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? description = null,
    Object? amount = null,
    Object? currencyCode = null,
    Object? expenseDate = null,
    Object? categoryId = null,
    Object? vendorId = freezed,
    Object? vendorName = freezed,
    Object? receiptUrl = freezed,
    Object? notes = freezed,
    Object? isRecurring = null,
    Object? recurringEndDate = freezed,
    Object? status = null,
    Object? journalEntryId = freezed,
    Object? createdBy = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as Decimal,
      currencyCode: null == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      expenseDate: null == expenseDate
          ? _value.expenseDate
          : expenseDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      vendorId: freezed == vendorId
          ? _value.vendorId
          : vendorId // ignore: cast_nullable_to_non_nullable
              as String?,
      vendorName: freezed == vendorName
          ? _value.vendorName
          : vendorName // ignore: cast_nullable_to_non_nullable
              as String?,
      receiptUrl: freezed == receiptUrl
          ? _value.receiptUrl
          : receiptUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      isRecurring: null == isRecurring
          ? _value.isRecurring
          : isRecurring // ignore: cast_nullable_to_non_nullable
              as bool,
      recurringEndDate: freezed == recurringEndDate
          ? _value.recurringEndDate
          : recurringEndDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      journalEntryId: freezed == journalEntryId
          ? _value.journalEntryId
          : journalEntryId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExpenseImplCopyWith<$Res> implements $ExpenseCopyWith<$Res> {
  factory _$$ExpenseImplCopyWith(
          _$ExpenseImpl value, $Res Function(_$ExpenseImpl) then) =
      __$$ExpenseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String description,
      Decimal amount,
      String currencyCode,
      DateTime expenseDate,
      String categoryId,
      String? vendorId,
      String? vendorName,
      String? receiptUrl,
      String? notes,
      bool isRecurring,
      DateTime? recurringEndDate,
      String status,
      String? journalEntryId,
      String? createdBy,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$ExpenseImplCopyWithImpl<$Res>
    extends _$ExpenseCopyWithImpl<$Res, _$ExpenseImpl>
    implements _$$ExpenseImplCopyWith<$Res> {
  __$$ExpenseImplCopyWithImpl(
      _$ExpenseImpl _value, $Res Function(_$ExpenseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? description = null,
    Object? amount = null,
    Object? currencyCode = null,
    Object? expenseDate = null,
    Object? categoryId = null,
    Object? vendorId = freezed,
    Object? vendorName = freezed,
    Object? receiptUrl = freezed,
    Object? notes = freezed,
    Object? isRecurring = null,
    Object? recurringEndDate = freezed,
    Object? status = null,
    Object? journalEntryId = freezed,
    Object? createdBy = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$ExpenseImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as Decimal,
      currencyCode: null == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      expenseDate: null == expenseDate
          ? _value.expenseDate
          : expenseDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      vendorId: freezed == vendorId
          ? _value.vendorId
          : vendorId // ignore: cast_nullable_to_non_nullable
              as String?,
      vendorName: freezed == vendorName
          ? _value.vendorName
          : vendorName // ignore: cast_nullable_to_non_nullable
              as String?,
      receiptUrl: freezed == receiptUrl
          ? _value.receiptUrl
          : receiptUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      isRecurring: null == isRecurring
          ? _value.isRecurring
          : isRecurring // ignore: cast_nullable_to_non_nullable
              as bool,
      recurringEndDate: freezed == recurringEndDate
          ? _value.recurringEndDate
          : recurringEndDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      journalEntryId: freezed == journalEntryId
          ? _value.journalEntryId
          : journalEntryId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExpenseImpl extends _Expense {
  const _$ExpenseImpl(
      {required this.id,
      required this.description,
      required this.amount,
      required this.currencyCode,
      required this.expenseDate,
      required this.categoryId,
      this.vendorId,
      this.vendorName,
      this.receiptUrl,
      this.notes,
      this.isRecurring = false,
      this.recurringEndDate,
      this.status = 'pending',
      this.journalEntryId,
      this.createdBy,
      this.createdAt,
      this.updatedAt})
      : super._();

  factory _$ExpenseImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExpenseImplFromJson(json);

  /// The unique identifier of the expense.
  @override
  final String id;

  /// A brief description of the expense.
  @override
  final String description;

  /// The monetary amount of the expense.
  @override
  final Decimal amount;

  /// The currency code (e.g., 'SAR').
  @override
  final String currencyCode;

  /// The date the expense was incurred.
  @override
  final DateTime expenseDate;

  /// The ID of the category this expense belongs to.
  @override
  final String categoryId;

  /// The optional ID of the vendor.
  @override
  final String? vendorId;

  /// The optional name of the vendor.
  @override
  final String? vendorName;

  /// The URL or path to the receipt image.
  @override
  final String? receiptUrl;

  /// Additional notes or remarks.
  @override
  final String? notes;

  /// Whether this is a recurring expense.
  @override
  @JsonKey()
  final bool isRecurring;

  /// The date when the recurrence ends, if applicable.
  @override
  final DateTime? recurringEndDate;

  /// The current status of the expense (e.g., pending, approved).
  @override
  @JsonKey()
  final String status;
// pending, approved, rejected, posted
  /// The ID of the associated GL journal entry when posted.
  @override
  final String? journalEntryId;
// Link to GL when posted
  /// The ID of the user who created this record.
  @override
  final String? createdBy;

  /// The timestamp when this record was created.
  @override
  final DateTime? createdAt;

  /// The timestamp when this record was last updated.
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Expense(id: $id, description: $description, amount: $amount, currencyCode: $currencyCode, expenseDate: $expenseDate, categoryId: $categoryId, vendorId: $vendorId, vendorName: $vendorName, receiptUrl: $receiptUrl, notes: $notes, isRecurring: $isRecurring, recurringEndDate: $recurringEndDate, status: $status, journalEntryId: $journalEntryId, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExpenseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.expenseDate, expenseDate) ||
                other.expenseDate == expenseDate) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.vendorId, vendorId) ||
                other.vendorId == vendorId) &&
            (identical(other.vendorName, vendorName) ||
                other.vendorName == vendorName) &&
            (identical(other.receiptUrl, receiptUrl) ||
                other.receiptUrl == receiptUrl) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.isRecurring, isRecurring) ||
                other.isRecurring == isRecurring) &&
            (identical(other.recurringEndDate, recurringEndDate) ||
                other.recurringEndDate == recurringEndDate) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.journalEntryId, journalEntryId) ||
                other.journalEntryId == journalEntryId) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      description,
      amount,
      currencyCode,
      expenseDate,
      categoryId,
      vendorId,
      vendorName,
      receiptUrl,
      notes,
      isRecurring,
      recurringEndDate,
      status,
      journalEntryId,
      createdBy,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ExpenseImplCopyWith<_$ExpenseImpl> get copyWith =>
      __$$ExpenseImplCopyWithImpl<_$ExpenseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExpenseImplToJson(
      this,
    );
  }
}

abstract class _Expense extends Expense {
  const factory _Expense(
      {required final String id,
      required final String description,
      required final Decimal amount,
      required final String currencyCode,
      required final DateTime expenseDate,
      required final String categoryId,
      final String? vendorId,
      final String? vendorName,
      final String? receiptUrl,
      final String? notes,
      final bool isRecurring,
      final DateTime? recurringEndDate,
      final String status,
      final String? journalEntryId,
      final String? createdBy,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$ExpenseImpl;
  const _Expense._() : super._();

  factory _Expense.fromJson(Map<String, dynamic> json) = _$ExpenseImpl.fromJson;

  @override

  /// The unique identifier of the expense.
  String get id;
  @override

  /// A brief description of the expense.
  String get description;
  @override

  /// The monetary amount of the expense.
  Decimal get amount;
  @override

  /// The currency code (e.g., 'SAR').
  String get currencyCode;
  @override

  /// The date the expense was incurred.
  DateTime get expenseDate;
  @override

  /// The ID of the category this expense belongs to.
  String get categoryId;
  @override

  /// The optional ID of the vendor.
  String? get vendorId;
  @override

  /// The optional name of the vendor.
  String? get vendorName;
  @override

  /// The URL or path to the receipt image.
  String? get receiptUrl;
  @override

  /// Additional notes or remarks.
  String? get notes;
  @override

  /// Whether this is a recurring expense.
  bool get isRecurring;
  @override

  /// The date when the recurrence ends, if applicable.
  DateTime? get recurringEndDate;
  @override

  /// The current status of the expense (e.g., pending, approved).
  String get status;
  @override // pending, approved, rejected, posted
  /// The ID of the associated GL journal entry when posted.
  String? get journalEntryId;
  @override // Link to GL when posted
  /// The ID of the user who created this record.
  String? get createdBy;
  @override

  /// The timestamp when this record was created.
  DateTime? get createdAt;
  @override

  /// The timestamp when this record was last updated.
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$ExpenseImplCopyWith<_$ExpenseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ExpenseCategory _$ExpenseCategoryFromJson(Map<String, dynamic> json) {
  return _ExpenseCategory.fromJson(json);
}

/// @nodoc
mixin _$ExpenseCategory {
  /// Unique identifier.
  String get id => throw _privateConstructorUsedError;

  /// English name.
  String get name => throw _privateConstructorUsedError;

  /// Arabic name.
  String get nameAr => throw _privateConstructorUsedError;

  /// Icon code point or name.
  String? get icon => throw _privateConstructorUsedError;

  /// Hex color code.
  String? get color => throw _privateConstructorUsedError;

  /// Linked GL account ID.
  String? get accountId =>
      throw _privateConstructorUsedError; // GL account for posting
  /// Whether category is active.
  bool get isActive => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ExpenseCategoryCopyWith<ExpenseCategory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExpenseCategoryCopyWith<$Res> {
  factory $ExpenseCategoryCopyWith(
          ExpenseCategory value, $Res Function(ExpenseCategory) then) =
      _$ExpenseCategoryCopyWithImpl<$Res, ExpenseCategory>;
  @useResult
  $Res call(
      {String id,
      String name,
      String nameAr,
      String? icon,
      String? color,
      String? accountId,
      bool isActive});
}

/// @nodoc
class _$ExpenseCategoryCopyWithImpl<$Res, $Val extends ExpenseCategory>
    implements $ExpenseCategoryCopyWith<$Res> {
  _$ExpenseCategoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? nameAr = null,
    Object? icon = freezed,
    Object? color = freezed,
    Object? accountId = freezed,
    Object? isActive = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      nameAr: null == nameAr
          ? _value.nameAr
          : nameAr // ignore: cast_nullable_to_non_nullable
              as String,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      accountId: freezed == accountId
          ? _value.accountId
          : accountId // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExpenseCategoryImplCopyWith<$Res>
    implements $ExpenseCategoryCopyWith<$Res> {
  factory _$$ExpenseCategoryImplCopyWith(_$ExpenseCategoryImpl value,
          $Res Function(_$ExpenseCategoryImpl) then) =
      __$$ExpenseCategoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String nameAr,
      String? icon,
      String? color,
      String? accountId,
      bool isActive});
}

/// @nodoc
class __$$ExpenseCategoryImplCopyWithImpl<$Res>
    extends _$ExpenseCategoryCopyWithImpl<$Res, _$ExpenseCategoryImpl>
    implements _$$ExpenseCategoryImplCopyWith<$Res> {
  __$$ExpenseCategoryImplCopyWithImpl(
      _$ExpenseCategoryImpl _value, $Res Function(_$ExpenseCategoryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? nameAr = null,
    Object? icon = freezed,
    Object? color = freezed,
    Object? accountId = freezed,
    Object? isActive = null,
  }) {
    return _then(_$ExpenseCategoryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      nameAr: null == nameAr
          ? _value.nameAr
          : nameAr // ignore: cast_nullable_to_non_nullable
              as String,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      accountId: freezed == accountId
          ? _value.accountId
          : accountId // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExpenseCategoryImpl implements _ExpenseCategory {
  const _$ExpenseCategoryImpl(
      {required this.id,
      required this.name,
      required this.nameAr,
      this.icon,
      this.color,
      this.accountId,
      this.isActive = true});

  factory _$ExpenseCategoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExpenseCategoryImplFromJson(json);

  /// Unique identifier.
  @override
  final String id;

  /// English name.
  @override
  final String name;

  /// Arabic name.
  @override
  final String nameAr;

  /// Icon code point or name.
  @override
  final String? icon;

  /// Hex color code.
  @override
  final String? color;

  /// Linked GL account ID.
  @override
  final String? accountId;
// GL account for posting
  /// Whether category is active.
  @override
  @JsonKey()
  final bool isActive;

  @override
  String toString() {
    return 'ExpenseCategory(id: $id, name: $name, nameAr: $nameAr, icon: $icon, color: $color, accountId: $accountId, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExpenseCategoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.nameAr, nameAr) || other.nameAr == nameAr) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, name, nameAr, icon, color, accountId, isActive);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ExpenseCategoryImplCopyWith<_$ExpenseCategoryImpl> get copyWith =>
      __$$ExpenseCategoryImplCopyWithImpl<_$ExpenseCategoryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExpenseCategoryImplToJson(
      this,
    );
  }
}

abstract class _ExpenseCategory implements ExpenseCategory {
  const factory _ExpenseCategory(
      {required final String id,
      required final String name,
      required final String nameAr,
      final String? icon,
      final String? color,
      final String? accountId,
      final bool isActive}) = _$ExpenseCategoryImpl;

  factory _ExpenseCategory.fromJson(Map<String, dynamic> json) =
      _$ExpenseCategoryImpl.fromJson;

  @override

  /// Unique identifier.
  String get id;
  @override

  /// English name.
  String get name;
  @override

  /// Arabic name.
  String get nameAr;
  @override

  /// Icon code point or name.
  String? get icon;
  @override

  /// Hex color code.
  String? get color;
  @override

  /// Linked GL account ID.
  String? get accountId;
  @override // GL account for posting
  /// Whether category is active.
  bool get isActive;
  @override
  @JsonKey(ignore: true)
  _$$ExpenseCategoryImplCopyWith<_$ExpenseCategoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
