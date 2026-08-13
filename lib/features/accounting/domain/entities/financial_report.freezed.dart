// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'financial_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$FinancialReportLine {
  /// Descriptive text for the line (e.g., "Gross Revenue", "Depreciation").
  String get label => throw _privateConstructorUsedError;

  /// The numerical value as a high-precision [Decimal].
  Decimal get amount => throw _privateConstructorUsedError;

  /// If true, this line serves as a header or section title.
  bool get isTitle => throw _privateConstructorUsedError;

  /// If true, this line represents a subtotal or grand total.
  bool get isTotal => throw _privateConstructorUsedError;

  /// Visual depth level for hierarchical presentation (0 = root).
  int get indentLevel => throw _privateConstructorUsedError;

  /// Optional reference to the underlying account for drill-down.
  String? get accountId => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $FinancialReportLineCopyWith<FinancialReportLine> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FinancialReportLineCopyWith<$Res> {
  factory $FinancialReportLineCopyWith(
          FinancialReportLine value, $Res Function(FinancialReportLine) then) =
      _$FinancialReportLineCopyWithImpl<$Res, FinancialReportLine>;
  @useResult
  $Res call(
      {String label,
      Decimal amount,
      bool isTitle,
      bool isTotal,
      int indentLevel,
      String? accountId});
}

/// @nodoc
class _$FinancialReportLineCopyWithImpl<$Res, $Val extends FinancialReportLine>
    implements $FinancialReportLineCopyWith<$Res> {
  _$FinancialReportLineCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? amount = null,
    Object? isTitle = null,
    Object? isTotal = null,
    Object? indentLevel = null,
    Object? accountId = freezed,
  }) {
    return _then(_value.copyWith(
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as Decimal,
      isTitle: null == isTitle
          ? _value.isTitle
          : isTitle // ignore: cast_nullable_to_non_nullable
              as bool,
      isTotal: null == isTotal
          ? _value.isTotal
          : isTotal // ignore: cast_nullable_to_non_nullable
              as bool,
      indentLevel: null == indentLevel
          ? _value.indentLevel
          : indentLevel // ignore: cast_nullable_to_non_nullable
              as int,
      accountId: freezed == accountId
          ? _value.accountId
          : accountId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FinancialReportLineImplCopyWith<$Res>
    implements $FinancialReportLineCopyWith<$Res> {
  factory _$$FinancialReportLineImplCopyWith(_$FinancialReportLineImpl value,
          $Res Function(_$FinancialReportLineImpl) then) =
      __$$FinancialReportLineImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String label,
      Decimal amount,
      bool isTitle,
      bool isTotal,
      int indentLevel,
      String? accountId});
}

/// @nodoc
class __$$FinancialReportLineImplCopyWithImpl<$Res>
    extends _$FinancialReportLineCopyWithImpl<$Res, _$FinancialReportLineImpl>
    implements _$$FinancialReportLineImplCopyWith<$Res> {
  __$$FinancialReportLineImplCopyWithImpl(_$FinancialReportLineImpl _value,
      $Res Function(_$FinancialReportLineImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? amount = null,
    Object? isTitle = null,
    Object? isTotal = null,
    Object? indentLevel = null,
    Object? accountId = freezed,
  }) {
    return _then(_$FinancialReportLineImpl(
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as Decimal,
      isTitle: null == isTitle
          ? _value.isTitle
          : isTitle // ignore: cast_nullable_to_non_nullable
              as bool,
      isTotal: null == isTotal
          ? _value.isTotal
          : isTotal // ignore: cast_nullable_to_non_nullable
              as bool,
      indentLevel: null == indentLevel
          ? _value.indentLevel
          : indentLevel // ignore: cast_nullable_to_non_nullable
              as int,
      accountId: freezed == accountId
          ? _value.accountId
          : accountId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$FinancialReportLineImpl implements _FinancialReportLine {
  const _$FinancialReportLineImpl(
      {required this.label,
      required this.amount,
      this.isTitle = false,
      this.isTotal = false,
      this.indentLevel = 0,
      this.accountId});

  /// Descriptive text for the line (e.g., "Gross Revenue", "Depreciation").
  @override
  final String label;

  /// The numerical value as a high-precision [Decimal].
  @override
  final Decimal amount;

  /// If true, this line serves as a header or section title.
  @override
  @JsonKey()
  final bool isTitle;

  /// If true, this line represents a subtotal or grand total.
  @override
  @JsonKey()
  final bool isTotal;

  /// Visual depth level for hierarchical presentation (0 = root).
  @override
  @JsonKey()
  final int indentLevel;

  /// Optional reference to the underlying account for drill-down.
  @override
  final String? accountId;

  @override
  String toString() {
    return 'FinancialReportLine(label: $label, amount: $amount, isTitle: $isTitle, isTotal: $isTotal, indentLevel: $indentLevel, accountId: $accountId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FinancialReportLineImpl &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.isTitle, isTitle) || other.isTitle == isTitle) &&
            (identical(other.isTotal, isTotal) || other.isTotal == isTotal) &&
            (identical(other.indentLevel, indentLevel) ||
                other.indentLevel == indentLevel) &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, label, amount, isTitle, isTotal, indentLevel, accountId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FinancialReportLineImplCopyWith<_$FinancialReportLineImpl> get copyWith =>
      __$$FinancialReportLineImplCopyWithImpl<_$FinancialReportLineImpl>(
          this, _$identity);
}

abstract class _FinancialReportLine implements FinancialReportLine {
  const factory _FinancialReportLine(
      {required final String label,
      required final Decimal amount,
      final bool isTitle,
      final bool isTotal,
      final int indentLevel,
      final String? accountId}) = _$FinancialReportLineImpl;

  @override

  /// Descriptive text for the line (e.g., "Gross Revenue", "Depreciation").
  String get label;
  @override

  /// The numerical value as a high-precision [Decimal].
  Decimal get amount;
  @override

  /// If true, this line serves as a header or section title.
  bool get isTitle;
  @override

  /// If true, this line represents a subtotal or grand total.
  bool get isTotal;
  @override

  /// Visual depth level for hierarchical presentation (0 = root).
  int get indentLevel;
  @override

  /// Optional reference to the underlying account for drill-down.
  String? get accountId;
  @override
  @JsonKey(ignore: true)
  _$$FinancialReportLineImplCopyWith<_$FinancialReportLineImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$FinancialReport {
  /// Report name (e.g., "Statutory Balance Sheet").
  String get title => throw _privateConstructorUsedError;

  /// Start of the reporting period.
  DateTime get fromDate => throw _privateConstructorUsedError;

  /// End of the reporting period.
  DateTime get toDate => throw _privateConstructorUsedError;

  /// Ordered sequence of report lines.
  List<FinancialReportLine> get lines => throw _privateConstructorUsedError;

  /// System timestamp of report generation.
  DateTime get generatedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $FinancialReportCopyWith<FinancialReport> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FinancialReportCopyWith<$Res> {
  factory $FinancialReportCopyWith(
          FinancialReport value, $Res Function(FinancialReport) then) =
      _$FinancialReportCopyWithImpl<$Res, FinancialReport>;
  @useResult
  $Res call(
      {String title,
      DateTime fromDate,
      DateTime toDate,
      List<FinancialReportLine> lines,
      DateTime generatedAt});
}

/// @nodoc
class _$FinancialReportCopyWithImpl<$Res, $Val extends FinancialReport>
    implements $FinancialReportCopyWith<$Res> {
  _$FinancialReportCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? fromDate = null,
    Object? toDate = null,
    Object? lines = null,
    Object? generatedAt = null,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      fromDate: null == fromDate
          ? _value.fromDate
          : fromDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      toDate: null == toDate
          ? _value.toDate
          : toDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lines: null == lines
          ? _value.lines
          : lines // ignore: cast_nullable_to_non_nullable
              as List<FinancialReportLine>,
      generatedAt: null == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FinancialReportImplCopyWith<$Res>
    implements $FinancialReportCopyWith<$Res> {
  factory _$$FinancialReportImplCopyWith(_$FinancialReportImpl value,
          $Res Function(_$FinancialReportImpl) then) =
      __$$FinancialReportImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String title,
      DateTime fromDate,
      DateTime toDate,
      List<FinancialReportLine> lines,
      DateTime generatedAt});
}

/// @nodoc
class __$$FinancialReportImplCopyWithImpl<$Res>
    extends _$FinancialReportCopyWithImpl<$Res, _$FinancialReportImpl>
    implements _$$FinancialReportImplCopyWith<$Res> {
  __$$FinancialReportImplCopyWithImpl(
      _$FinancialReportImpl _value, $Res Function(_$FinancialReportImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? fromDate = null,
    Object? toDate = null,
    Object? lines = null,
    Object? generatedAt = null,
  }) {
    return _then(_$FinancialReportImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      fromDate: null == fromDate
          ? _value.fromDate
          : fromDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      toDate: null == toDate
          ? _value.toDate
          : toDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lines: null == lines
          ? _value._lines
          : lines // ignore: cast_nullable_to_non_nullable
              as List<FinancialReportLine>,
      generatedAt: null == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$FinancialReportImpl implements _FinancialReport {
  const _$FinancialReportImpl(
      {required this.title,
      required this.fromDate,
      required this.toDate,
      required final List<FinancialReportLine> lines,
      required this.generatedAt})
      : _lines = lines;

  /// Report name (e.g., "Statutory Balance Sheet").
  @override
  final String title;

  /// Start of the reporting period.
  @override
  final DateTime fromDate;

  /// End of the reporting period.
  @override
  final DateTime toDate;

  /// Ordered sequence of report lines.
  final List<FinancialReportLine> _lines;

  /// Ordered sequence of report lines.
  @override
  List<FinancialReportLine> get lines {
    if (_lines is EqualUnmodifiableListView) return _lines;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lines);
  }

  /// System timestamp of report generation.
  @override
  final DateTime generatedAt;

  @override
  String toString() {
    return 'FinancialReport(title: $title, fromDate: $fromDate, toDate: $toDate, lines: $lines, generatedAt: $generatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FinancialReportImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.fromDate, fromDate) ||
                other.fromDate == fromDate) &&
            (identical(other.toDate, toDate) || other.toDate == toDate) &&
            const DeepCollectionEquality().equals(other._lines, _lines) &&
            (identical(other.generatedAt, generatedAt) ||
                other.generatedAt == generatedAt));
  }

  @override
  int get hashCode => Object.hash(runtimeType, title, fromDate, toDate,
      const DeepCollectionEquality().hash(_lines), generatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FinancialReportImplCopyWith<_$FinancialReportImpl> get copyWith =>
      __$$FinancialReportImplCopyWithImpl<_$FinancialReportImpl>(
          this, _$identity);
}

abstract class _FinancialReport implements FinancialReport {
  const factory _FinancialReport(
      {required final String title,
      required final DateTime fromDate,
      required final DateTime toDate,
      required final List<FinancialReportLine> lines,
      required final DateTime generatedAt}) = _$FinancialReportImpl;

  @override

  /// Report name (e.g., "Statutory Balance Sheet").
  String get title;
  @override

  /// Start of the reporting period.
  DateTime get fromDate;
  @override

  /// End of the reporting period.
  DateTime get toDate;
  @override

  /// Ordered sequence of report lines.
  List<FinancialReportLine> get lines;
  @override

  /// System timestamp of report generation.
  DateTime get generatedAt;
  @override
  @JsonKey(ignore: true)
  _$$FinancialReportImplCopyWith<_$FinancialReportImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$TrialBalanceLine {
  /// Unique accounting code string.
  String get accountCode => throw _privateConstructorUsedError;

  /// Localized account name.
  String get accountName => throw _privateConstructorUsedError;

  /// Period-to-date Debit total.
  Decimal get debitBalance => throw _privateConstructorUsedError;

  /// Period-to-date Credit total.
  Decimal get creditBalance => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TrialBalanceLineCopyWith<TrialBalanceLine> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TrialBalanceLineCopyWith<$Res> {
  factory $TrialBalanceLineCopyWith(
          TrialBalanceLine value, $Res Function(TrialBalanceLine) then) =
      _$TrialBalanceLineCopyWithImpl<$Res, TrialBalanceLine>;
  @useResult
  $Res call(
      {String accountCode,
      String accountName,
      Decimal debitBalance,
      Decimal creditBalance});
}

/// @nodoc
class _$TrialBalanceLineCopyWithImpl<$Res, $Val extends TrialBalanceLine>
    implements $TrialBalanceLineCopyWith<$Res> {
  _$TrialBalanceLineCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accountCode = null,
    Object? accountName = null,
    Object? debitBalance = null,
    Object? creditBalance = null,
  }) {
    return _then(_value.copyWith(
      accountCode: null == accountCode
          ? _value.accountCode
          : accountCode // ignore: cast_nullable_to_non_nullable
              as String,
      accountName: null == accountName
          ? _value.accountName
          : accountName // ignore: cast_nullable_to_non_nullable
              as String,
      debitBalance: null == debitBalance
          ? _value.debitBalance
          : debitBalance // ignore: cast_nullable_to_non_nullable
              as Decimal,
      creditBalance: null == creditBalance
          ? _value.creditBalance
          : creditBalance // ignore: cast_nullable_to_non_nullable
              as Decimal,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TrialBalanceLineImplCopyWith<$Res>
    implements $TrialBalanceLineCopyWith<$Res> {
  factory _$$TrialBalanceLineImplCopyWith(_$TrialBalanceLineImpl value,
          $Res Function(_$TrialBalanceLineImpl) then) =
      __$$TrialBalanceLineImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String accountCode,
      String accountName,
      Decimal debitBalance,
      Decimal creditBalance});
}

/// @nodoc
class __$$TrialBalanceLineImplCopyWithImpl<$Res>
    extends _$TrialBalanceLineCopyWithImpl<$Res, _$TrialBalanceLineImpl>
    implements _$$TrialBalanceLineImplCopyWith<$Res> {
  __$$TrialBalanceLineImplCopyWithImpl(_$TrialBalanceLineImpl _value,
      $Res Function(_$TrialBalanceLineImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accountCode = null,
    Object? accountName = null,
    Object? debitBalance = null,
    Object? creditBalance = null,
  }) {
    return _then(_$TrialBalanceLineImpl(
      accountCode: null == accountCode
          ? _value.accountCode
          : accountCode // ignore: cast_nullable_to_non_nullable
              as String,
      accountName: null == accountName
          ? _value.accountName
          : accountName // ignore: cast_nullable_to_non_nullable
              as String,
      debitBalance: null == debitBalance
          ? _value.debitBalance
          : debitBalance // ignore: cast_nullable_to_non_nullable
              as Decimal,
      creditBalance: null == creditBalance
          ? _value.creditBalance
          : creditBalance // ignore: cast_nullable_to_non_nullable
              as Decimal,
    ));
  }
}

/// @nodoc

class _$TrialBalanceLineImpl implements _TrialBalanceLine {
  const _$TrialBalanceLineImpl(
      {required this.accountCode,
      required this.accountName,
      required this.debitBalance,
      required this.creditBalance});

  /// Unique accounting code string.
  @override
  final String accountCode;

  /// Localized account name.
  @override
  final String accountName;

  /// Period-to-date Debit total.
  @override
  final Decimal debitBalance;

  /// Period-to-date Credit total.
  @override
  final Decimal creditBalance;

  @override
  String toString() {
    return 'TrialBalanceLine(accountCode: $accountCode, accountName: $accountName, debitBalance: $debitBalance, creditBalance: $creditBalance)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TrialBalanceLineImpl &&
            (identical(other.accountCode, accountCode) ||
                other.accountCode == accountCode) &&
            (identical(other.accountName, accountName) ||
                other.accountName == accountName) &&
            (identical(other.debitBalance, debitBalance) ||
                other.debitBalance == debitBalance) &&
            (identical(other.creditBalance, creditBalance) ||
                other.creditBalance == creditBalance));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, accountCode, accountName, debitBalance, creditBalance);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TrialBalanceLineImplCopyWith<_$TrialBalanceLineImpl> get copyWith =>
      __$$TrialBalanceLineImplCopyWithImpl<_$TrialBalanceLineImpl>(
          this, _$identity);
}

abstract class _TrialBalanceLine implements TrialBalanceLine {
  const factory _TrialBalanceLine(
      {required final String accountCode,
      required final String accountName,
      required final Decimal debitBalance,
      required final Decimal creditBalance}) = _$TrialBalanceLineImpl;

  @override

  /// Unique accounting code string.
  String get accountCode;
  @override

  /// Localized account name.
  String get accountName;
  @override

  /// Period-to-date Debit total.
  Decimal get debitBalance;
  @override

  /// Period-to-date Credit total.
  Decimal get creditBalance;
  @override
  @JsonKey(ignore: true)
  _$$TrialBalanceLineImplCopyWith<_$TrialBalanceLineImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$TrialBalance {
  /// The specific date the snapshot was taken.
  DateTime get date => throw _privateConstructorUsedError;

  /// Collection of account-level balances.
  List<TrialBalanceLine> get lines => throw _privateConstructorUsedError;

  /// Grand sum of all Debit balances (must match totalCredit).
  Decimal get totalDebit => throw _privateConstructorUsedError;

  /// Grand sum of all Credit balances (must match totalDebit).
  Decimal get totalCredit => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TrialBalanceCopyWith<TrialBalance> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TrialBalanceCopyWith<$Res> {
  factory $TrialBalanceCopyWith(
          TrialBalance value, $Res Function(TrialBalance) then) =
      _$TrialBalanceCopyWithImpl<$Res, TrialBalance>;
  @useResult
  $Res call(
      {DateTime date,
      List<TrialBalanceLine> lines,
      Decimal totalDebit,
      Decimal totalCredit});
}

/// @nodoc
class _$TrialBalanceCopyWithImpl<$Res, $Val extends TrialBalance>
    implements $TrialBalanceCopyWith<$Res> {
  _$TrialBalanceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? lines = null,
    Object? totalDebit = null,
    Object? totalCredit = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lines: null == lines
          ? _value.lines
          : lines // ignore: cast_nullable_to_non_nullable
              as List<TrialBalanceLine>,
      totalDebit: null == totalDebit
          ? _value.totalDebit
          : totalDebit // ignore: cast_nullable_to_non_nullable
              as Decimal,
      totalCredit: null == totalCredit
          ? _value.totalCredit
          : totalCredit // ignore: cast_nullable_to_non_nullable
              as Decimal,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TrialBalanceImplCopyWith<$Res>
    implements $TrialBalanceCopyWith<$Res> {
  factory _$$TrialBalanceImplCopyWith(
          _$TrialBalanceImpl value, $Res Function(_$TrialBalanceImpl) then) =
      __$$TrialBalanceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime date,
      List<TrialBalanceLine> lines,
      Decimal totalDebit,
      Decimal totalCredit});
}

/// @nodoc
class __$$TrialBalanceImplCopyWithImpl<$Res>
    extends _$TrialBalanceCopyWithImpl<$Res, _$TrialBalanceImpl>
    implements _$$TrialBalanceImplCopyWith<$Res> {
  __$$TrialBalanceImplCopyWithImpl(
      _$TrialBalanceImpl _value, $Res Function(_$TrialBalanceImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? lines = null,
    Object? totalDebit = null,
    Object? totalCredit = null,
  }) {
    return _then(_$TrialBalanceImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lines: null == lines
          ? _value._lines
          : lines // ignore: cast_nullable_to_non_nullable
              as List<TrialBalanceLine>,
      totalDebit: null == totalDebit
          ? _value.totalDebit
          : totalDebit // ignore: cast_nullable_to_non_nullable
              as Decimal,
      totalCredit: null == totalCredit
          ? _value.totalCredit
          : totalCredit // ignore: cast_nullable_to_non_nullable
              as Decimal,
    ));
  }
}

/// @nodoc

class _$TrialBalanceImpl implements _TrialBalance {
  const _$TrialBalanceImpl(
      {required this.date,
      required final List<TrialBalanceLine> lines,
      required this.totalDebit,
      required this.totalCredit})
      : _lines = lines;

  /// The specific date the snapshot was taken.
  @override
  final DateTime date;

  /// Collection of account-level balances.
  final List<TrialBalanceLine> _lines;

  /// Collection of account-level balances.
  @override
  List<TrialBalanceLine> get lines {
    if (_lines is EqualUnmodifiableListView) return _lines;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lines);
  }

  /// Grand sum of all Debit balances (must match totalCredit).
  @override
  final Decimal totalDebit;

  /// Grand sum of all Credit balances (must match totalDebit).
  @override
  final Decimal totalCredit;

  @override
  String toString() {
    return 'TrialBalance(date: $date, lines: $lines, totalDebit: $totalDebit, totalCredit: $totalCredit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TrialBalanceImpl &&
            (identical(other.date, date) || other.date == date) &&
            const DeepCollectionEquality().equals(other._lines, _lines) &&
            (identical(other.totalDebit, totalDebit) ||
                other.totalDebit == totalDebit) &&
            (identical(other.totalCredit, totalCredit) ||
                other.totalCredit == totalCredit));
  }

  @override
  int get hashCode => Object.hash(runtimeType, date,
      const DeepCollectionEquality().hash(_lines), totalDebit, totalCredit);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TrialBalanceImplCopyWith<_$TrialBalanceImpl> get copyWith =>
      __$$TrialBalanceImplCopyWithImpl<_$TrialBalanceImpl>(this, _$identity);
}

abstract class _TrialBalance implements TrialBalance {
  const factory _TrialBalance(
      {required final DateTime date,
      required final List<TrialBalanceLine> lines,
      required final Decimal totalDebit,
      required final Decimal totalCredit}) = _$TrialBalanceImpl;

  @override

  /// The specific date the snapshot was taken.
  DateTime get date;
  @override

  /// Collection of account-level balances.
  List<TrialBalanceLine> get lines;
  @override

  /// Grand sum of all Debit balances (must match totalCredit).
  Decimal get totalDebit;
  @override

  /// Grand sum of all Credit balances (must match totalDebit).
  Decimal get totalCredit;
  @override
  @JsonKey(ignore: true)
  _$$TrialBalanceImplCopyWith<_$TrialBalanceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
