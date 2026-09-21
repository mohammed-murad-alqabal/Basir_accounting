// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'goal.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Goal {
  /// المعرف الفريد
  String get id => throw _privateConstructorUsedError;

  /// اسم الهدف
  String get name => throw _privateConstructorUsedError;

  /// تصنيف الهدف
  GoalCategory get category => throw _privateConstructorUsedError;

  /// المبلغ المستهدف
  Decimal get targetAmount => throw _privateConstructorUsedError;

  /// المبلغ الحالي
  Decimal get currentAmount => throw _privateConstructorUsedError;

  /// تاريخ البداية
  DateTime get startDate => throw _privateConstructorUsedError;

  /// تاريخ النهاية المستهدف
  DateTime get targetDate => throw _privateConstructorUsedError;

  /// حالة النشاط
  bool get isActive => throw _privateConstructorUsedError;

  /// وصف اختياري
  String? get description => throw _privateConstructorUsedError;

  /// معرف المستخدم
  String? get userId => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $GoalCopyWith<Goal> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GoalCopyWith<$Res> {
  factory $GoalCopyWith(Goal value, $Res Function(Goal) then) =
      _$GoalCopyWithImpl<$Res, Goal>;
  @useResult
  $Res call(
      {String id,
      String name,
      GoalCategory category,
      Decimal targetAmount,
      Decimal currentAmount,
      DateTime startDate,
      DateTime targetDate,
      bool isActive,
      String? description,
      String? userId});
}

/// @nodoc
class _$GoalCopyWithImpl<$Res, $Val extends Goal>
    implements $GoalCopyWith<$Res> {
  _$GoalCopyWithImpl(this._value, this._then);

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
    Object? targetAmount = null,
    Object? currentAmount = null,
    Object? startDate = null,
    Object? targetDate = null,
    Object? isActive = null,
    Object? description = freezed,
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
              as GoalCategory,
      targetAmount: null == targetAmount
          ? _value.targetAmount
          : targetAmount // ignore: cast_nullable_to_non_nullable
              as Decimal,
      currentAmount: null == currentAmount
          ? _value.currentAmount
          : currentAmount // ignore: cast_nullable_to_non_nullable
              as Decimal,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      targetDate: null == targetDate
          ? _value.targetDate
          : targetDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GoalImplCopyWith<$Res> implements $GoalCopyWith<$Res> {
  factory _$$GoalImplCopyWith(
          _$GoalImpl value, $Res Function(_$GoalImpl) then) =
      __$$GoalImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      GoalCategory category,
      Decimal targetAmount,
      Decimal currentAmount,
      DateTime startDate,
      DateTime targetDate,
      bool isActive,
      String? description,
      String? userId});
}

/// @nodoc
class __$$GoalImplCopyWithImpl<$Res>
    extends _$GoalCopyWithImpl<$Res, _$GoalImpl>
    implements _$$GoalImplCopyWith<$Res> {
  __$$GoalImplCopyWithImpl(_$GoalImpl _value, $Res Function(_$GoalImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? category = null,
    Object? targetAmount = null,
    Object? currentAmount = null,
    Object? startDate = null,
    Object? targetDate = null,
    Object? isActive = null,
    Object? description = freezed,
    Object? userId = freezed,
  }) {
    return _then(_$GoalImpl(
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
              as GoalCategory,
      targetAmount: null == targetAmount
          ? _value.targetAmount
          : targetAmount // ignore: cast_nullable_to_non_nullable
              as Decimal,
      currentAmount: null == currentAmount
          ? _value.currentAmount
          : currentAmount // ignore: cast_nullable_to_non_nullable
              as Decimal,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      targetDate: null == targetDate
          ? _value.targetDate
          : targetDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$GoalImpl extends _Goal {
  const _$GoalImpl(
      {required this.id,
      required this.name,
      required this.category,
      required this.targetAmount,
      required this.currentAmount,
      required this.startDate,
      required this.targetDate,
      this.isActive = true,
      this.description,
      this.userId})
      : super._();

  /// المعرف الفريد
  @override
  final String id;

  /// اسم الهدف
  @override
  final String name;

  /// تصنيف الهدف
  @override
  final GoalCategory category;

  /// المبلغ المستهدف
  @override
  final Decimal targetAmount;

  /// المبلغ الحالي
  @override
  final Decimal currentAmount;

  /// تاريخ البداية
  @override
  final DateTime startDate;

  /// تاريخ النهاية المستهدف
  @override
  final DateTime targetDate;

  /// حالة النشاط
  @override
  @JsonKey()
  final bool isActive;

  /// وصف اختياري
  @override
  final String? description;

  /// معرف المستخدم
  @override
  final String? userId;

  @override
  String toString() {
    return 'Goal(id: $id, name: $name, category: $category, targetAmount: $targetAmount, currentAmount: $currentAmount, startDate: $startDate, targetDate: $targetDate, isActive: $isActive, description: $description, userId: $userId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GoalImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.targetAmount, targetAmount) ||
                other.targetAmount == targetAmount) &&
            (identical(other.currentAmount, currentAmount) ||
                other.currentAmount == currentAmount) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.targetDate, targetDate) ||
                other.targetDate == targetDate) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, name, category, targetAmount,
      currentAmount, startDate, targetDate, isActive, description, userId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GoalImplCopyWith<_$GoalImpl> get copyWith =>
      __$$GoalImplCopyWithImpl<_$GoalImpl>(this, _$identity);
}

abstract class _Goal extends Goal {
  const factory _Goal(
      {required final String id,
      required final String name,
      required final GoalCategory category,
      required final Decimal targetAmount,
      required final Decimal currentAmount,
      required final DateTime startDate,
      required final DateTime targetDate,
      final bool isActive,
      final String? description,
      final String? userId}) = _$GoalImpl;
  const _Goal._() : super._();

  @override

  /// المعرف الفريد
  String get id;
  @override

  /// اسم الهدف
  String get name;
  @override

  /// تصنيف الهدف
  GoalCategory get category;
  @override

  /// المبلغ المستهدف
  Decimal get targetAmount;
  @override

  /// المبلغ الحالي
  Decimal get currentAmount;
  @override

  /// تاريخ البداية
  DateTime get startDate;
  @override

  /// تاريخ النهاية المستهدف
  DateTime get targetDate;
  @override

  /// حالة النشاط
  bool get isActive;
  @override

  /// وصف اختياري
  String? get description;
  @override

  /// معرف المستخدم
  String? get userId;
  @override
  @JsonKey(ignore: true)
  _$$GoalImplCopyWith<_$GoalImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
