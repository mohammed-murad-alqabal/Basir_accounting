// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'import_row.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ImportRow {
  /// The name of the account or customer.
  String get name => throw _privateConstructorUsedError;

  /// The opening balance amount.
  Decimal get balance => throw _privateConstructorUsedError;

  /// The accounting nature (Debit/Credit).
  AccountNature get nature => throw _privateConstructorUsedError;

  /// Optional phone number.
  String? get phone => throw _privateConstructorUsedError;

  /// Optional address.
  String? get address => throw _privateConstructorUsedError;

  /// Validation error message if any.
  String? get error => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ImportRowCopyWith<ImportRow> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ImportRowCopyWith<$Res> {
  factory $ImportRowCopyWith(ImportRow value, $Res Function(ImportRow) then) =
      _$ImportRowCopyWithImpl<$Res, ImportRow>;
  @useResult
  $Res call(
      {String name,
      Decimal balance,
      AccountNature nature,
      String? phone,
      String? address,
      String? error});
}

/// @nodoc
class _$ImportRowCopyWithImpl<$Res, $Val extends ImportRow>
    implements $ImportRowCopyWith<$Res> {
  _$ImportRowCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? balance = null,
    Object? nature = null,
    Object? phone = freezed,
    Object? address = freezed,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as Decimal,
      nature: null == nature
          ? _value.nature
          : nature // ignore: cast_nullable_to_non_nullable
              as AccountNature,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ImportRowImplCopyWith<$Res>
    implements $ImportRowCopyWith<$Res> {
  factory _$$ImportRowImplCopyWith(
          _$ImportRowImpl value, $Res Function(_$ImportRowImpl) then) =
      __$$ImportRowImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      Decimal balance,
      AccountNature nature,
      String? phone,
      String? address,
      String? error});
}

/// @nodoc
class __$$ImportRowImplCopyWithImpl<$Res>
    extends _$ImportRowCopyWithImpl<$Res, _$ImportRowImpl>
    implements _$$ImportRowImplCopyWith<$Res> {
  __$$ImportRowImplCopyWithImpl(
      _$ImportRowImpl _value, $Res Function(_$ImportRowImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? balance = null,
    Object? nature = null,
    Object? phone = freezed,
    Object? address = freezed,
    Object? error = freezed,
  }) {
    return _then(_$ImportRowImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as Decimal,
      nature: null == nature
          ? _value.nature
          : nature // ignore: cast_nullable_to_non_nullable
              as AccountNature,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$ImportRowImpl extends _ImportRow {
  const _$ImportRowImpl(
      {required this.name,
      required this.balance,
      required this.nature,
      this.phone,
      this.address,
      this.error})
      : super._();

  /// The name of the account or customer.
  @override
  final String name;

  /// The opening balance amount.
  @override
  final Decimal balance;

  /// The accounting nature (Debit/Credit).
  @override
  final AccountNature nature;

  /// Optional phone number.
  @override
  final String? phone;

  /// Optional address.
  @override
  final String? address;

  /// Validation error message if any.
  @override
  final String? error;

  @override
  String toString() {
    return 'ImportRow(name: $name, balance: $balance, nature: $nature, phone: $phone, address: $address, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ImportRowImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.balance, balance) || other.balance == balance) &&
            (identical(other.nature, nature) || other.nature == nature) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, name, balance, nature, phone, address, error);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ImportRowImplCopyWith<_$ImportRowImpl> get copyWith =>
      __$$ImportRowImplCopyWithImpl<_$ImportRowImpl>(this, _$identity);
}

abstract class _ImportRow extends ImportRow {
  const factory _ImportRow(
      {required final String name,
      required final Decimal balance,
      required final AccountNature nature,
      final String? phone,
      final String? address,
      final String? error}) = _$ImportRowImpl;
  const _ImportRow._() : super._();

  @override

  /// The name of the account or customer.
  String get name;
  @override

  /// The opening balance amount.
  Decimal get balance;
  @override

  /// The accounting nature (Debit/Credit).
  AccountNature get nature;
  @override

  /// Optional phone number.
  String? get phone;
  @override

  /// Optional address.
  String? get address;
  @override

  /// Validation error message if any.
  String? get error;
  @override
  @JsonKey(ignore: true)
  _$$ImportRowImplCopyWith<_$ImportRowImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
