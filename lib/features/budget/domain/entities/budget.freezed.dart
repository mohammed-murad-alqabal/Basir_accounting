// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budget.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Budget _$BudgetFromJson(Map<String, dynamic> json) {
  return _Budget.fromJson(json);
}

/// @nodoc
mixin _$Budget {
  /// المعرف الفريد للميزانية
  String get id => throw _privateConstructorUsedError;

  /// اسم الميزانية (مثلاً: "ميزانية يناير")
  String get name => throw _privateConstructorUsedError;

  /// التصنيف المخصص لهذه الميزانية
  BudgetCategory get category => throw _privateConstructorUsedError;

  /// الحد الأقصى للميزانية (Decimal لدقة عالية)
  Decimal get limitAmount => throw _privateConstructorUsedError;

  /// تاريخ البدء
  DateTime get startDate => throw _privateConstructorUsedError;

  /// تاريخ الانتهاء
  DateTime get endDate => throw _privateConstructorUsedError;

  /// المبلغ المصروف فعلياً
  Decimal get spentAmount => throw _privateConstructorUsedError;

  /// عتبة التنبيه (مثلاً 0.8 تعني 80%)
  double get alertThreshold => throw _privateConstructorUsedError;

  /// هل يتم ترحيل الفائض للشهر التالي (Rollover)
  bool get isRollover => throw _privateConstructorUsedError;

  /// حالة تفعيل الميزانية
  bool get isActive => throw _privateConstructorUsedError;

  /// معرف المستخدم صاحب الميزانية
  String? get userId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BudgetCopyWith<Budget> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BudgetCopyWith<$Res> {
  factory $BudgetCopyWith(Budget value, $Res Function(Budget) then) =
      _$BudgetCopyWithImpl<$Res, Budget>;
  @useResult
  $Res call(
      {String id,
      String name,
      BudgetCategory category,
      Decimal limitAmount,
      DateTime startDate,
      DateTime endDate,
      Decimal spentAmount,
      double alertThreshold,
      bool isRollover,
      bool isActive,
      String? userId});
}

/// @nodoc
class _$BudgetCopyWithImpl<$Res, $Val extends Budget>
    implements $BudgetCopyWith<$Res> {
  _$BudgetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? category = null,
    Object? limitAmount = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? spentAmount = null,
    Object? alertThreshold = null,
    Object? isRollover = null,
    Object? isActive = null,
    Object? userId = freezed,
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
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as BudgetCategory,
      limitAmount: null == limitAmount
          ? _value.limitAmount
          : limitAmount // ignore: cast_nullable_to_non_nullable
              as Decimal,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      spentAmount: null == spentAmount
          ? _value.spentAmount
          : spentAmount // ignore: cast_nullable_to_non_nullable
              as Decimal,
      alertThreshold: null == alertThreshold
          ? _value.alertThreshold
          : alertThreshold // ignore: cast_nullable_to_non_nullable
              as double,
      isRollover: null == isRollover
          ? _value.isRollover
          : isRollover // ignore: cast_nullable_to_non_nullable
              as bool,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BudgetImplCopyWith<$Res> implements $BudgetCopyWith<$Res> {
  factory _$$BudgetImplCopyWith(
          _$BudgetImpl value, $Res Function(_$BudgetImpl) then) =
      __$$BudgetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      BudgetCategory category,
      Decimal limitAmount,
      DateTime startDate,
      DateTime endDate,
      Decimal spentAmount,
      double alertThreshold,
      bool isRollover,
      bool isActive,
      String? userId});
}

/// @nodoc
class __$$BudgetImplCopyWithImpl<$Res>
    extends _$BudgetCopyWithImpl<$Res, _$BudgetImpl>
    implements _$$BudgetImplCopyWith<$Res> {
  __$$BudgetImplCopyWithImpl(
      _$BudgetImpl _value, $Res Function(_$BudgetImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? category = null,
    Object? limitAmount = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? spentAmount = null,
    Object? alertThreshold = null,
    Object? isRollover = null,
    Object? isActive = null,
    Object? userId = freezed,
  }) {
    return _then(_$BudgetImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as BudgetCategory,
      limitAmount: null == limitAmount
          ? _value.limitAmount
          : limitAmount // ignore: cast_nullable_to_non_nullable
              as Decimal,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      spentAmount: null == spentAmount
          ? _value.spentAmount
          : spentAmount // ignore: cast_nullable_to_non_nullable
              as Decimal,
      alertThreshold: null == alertThreshold
          ? _value.alertThreshold
          : alertThreshold // ignore: cast_nullable_to_non_nullable
              as double,
      isRollover: null == isRollover
          ? _value.isRollover
          : isRollover // ignore: cast_nullable_to_non_nullable
              as bool,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BudgetImpl implements _Budget {
  const _$BudgetImpl(
      {required this.id,
      required this.name,
      required this.category,
      required this.limitAmount,
      required this.startDate,
      required this.endDate,
      required this.spentAmount,
      this.alertThreshold = 0.8,
      this.isRollover = false,
      this.isActive = true,
      this.userId});

  factory _$BudgetImpl.fromJson(Map<String, dynamic> json) =>
      _$$BudgetImplFromJson(json);

  /// المعرف الفريد للميزانية
  @override
  final String id;

  /// اسم الميزانية (مثلاً: "ميزانية يناير")
  @override
  final String name;

  /// التصنيف المخصص لهذه الميزانية
  @override
  final BudgetCategory category;

  /// الحد الأقصى للميزانية (Decimal لدقة عالية)
  @override
  final Decimal limitAmount;

  /// تاريخ البدء
  @override
  final DateTime startDate;

  /// تاريخ الانتهاء
  @override
  final DateTime endDate;

  /// المبلغ المصروف فعلياً
  @override
  final Decimal spentAmount;

  /// عتبة التنبيه (مثلاً 0.8 تعني 80%)
  @override
  @JsonKey()
  final double alertThreshold;

  /// هل يتم ترحيل الفائض للشهر التالي (Rollover)
  @override
  @JsonKey()
  final bool isRollover;

  /// حالة تفعيل الميزانية
  @override
  @JsonKey()
  final bool isActive;

  /// معرف المستخدم صاحب الميزانية
  @override
  final String? userId;

  @override
  String toString() {
    return 'Budget(id: $id, name: $name, category: $category, limitAmount: $limitAmount, startDate: $startDate, endDate: $endDate, spentAmount: $spentAmount, alertThreshold: $alertThreshold, isRollover: $isRollover, isActive: $isActive, userId: $userId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BudgetImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.limitAmount, limitAmount) ||
                other.limitAmount == limitAmount) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.spentAmount, spentAmount) ||
                other.spentAmount == spentAmount) &&
            (identical(other.alertThreshold, alertThreshold) ||
                other.alertThreshold == alertThreshold) &&
            (identical(other.isRollover, isRollover) ||
                other.isRollover == isRollover) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      category,
      limitAmount,
      startDate,
      endDate,
      spentAmount,
      alertThreshold,
      isRollover,
      isActive,
      userId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BudgetImplCopyWith<_$BudgetImpl> get copyWith =>
      __$$BudgetImplCopyWithImpl<_$BudgetImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BudgetImplToJson(
      this,
    );
  }
}

abstract class _Budget implements Budget {
  const factory _Budget(
      {required final String id,
      required final String name,
      required final BudgetCategory category,
      required final Decimal limitAmount,
      required final DateTime startDate,
      required final DateTime endDate,
      required final Decimal spentAmount,
      final double alertThreshold,
      final bool isRollover,
      final bool isActive,
      final String? userId}) = _$BudgetImpl;

  factory _Budget.fromJson(Map<String, dynamic> json) = _$BudgetImpl.fromJson;

  @override

  /// المعرف الفريد للميزانية
  String get id;
  @override

  /// اسم الميزانية (مثلاً: "ميزانية يناير")
  String get name;
  @override

  /// التصنيف المخصص لهذه الميزانية
  BudgetCategory get category;
  @override

  /// الحد الأقصى للميزانية (Decimal لدقة عالية)
  Decimal get limitAmount;
  @override

  /// تاريخ البدء
  DateTime get startDate;
  @override

  /// تاريخ الانتهاء
  DateTime get endDate;
  @override

  /// المبلغ المصروف فعلياً
  Decimal get spentAmount;
  @override

  /// عتبة التنبيه (مثلاً 0.8 تعني 80%)
  double get alertThreshold;
  @override

  /// هل يتم ترحيل الفائض للشهر التالي (Rollover)
  bool get isRollover;
  @override

  /// حالة تفعيل الميزانية
  bool get isActive;
  @override

  /// معرف المستخدم صاحب الميزانية
  String? get userId;
  @override
  @JsonKey(ignore: true)
  _$$BudgetImplCopyWith<_$BudgetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
