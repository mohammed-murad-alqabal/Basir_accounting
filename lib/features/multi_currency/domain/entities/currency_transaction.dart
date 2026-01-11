// Multi-Currency Engine - Currency Transaction Entity (Simplified)
// Part of Basir MVP Phase 2 Implementation
// Prepared by: فريق وكلاء تطوير مشروع بصير

import 'package:isar/isar.dart';

part 'currency_transaction.g.dart';

/// Currency transaction entity for multi-currency operations
/// Implements IFRS requirements for foreign currency transactions
@collection
class CurrencyTransaction {
  /// Isar ID (auto-generated)
  Id id = Isar.autoIncrement;

  /// Reference to the main transaction/journal entry
  @Index()
  late String transactionRef;

  /// Transaction currency (original currency)
  late String transactionCurrency;

  /// Functional currency (entity's functional currency)
  late String functionalCurrency;

  /// Original amount in transaction currency
  late double originalAmount;

  /// Converted amount in functional currency
  late double functionalAmount;

  /// Exchange rate used for conversion
  late double exchangeRate;

  /// Rate source and timestamp
  late String rateSource;
  late DateTime rateDate;

  /// Transaction date
  @Index()
  late DateTime transactionDate;

  /// Transaction type ('revenue', 'expense', 'asset', 'liability')
  late String transactionType;

  /// Whether this is a monetary item (subject to revaluation)
  late bool isMonetaryItem;

  /// Exchange difference amount (for revaluation)
  late double exchangeDifference;

  /// Last revaluation date
  DateTime? lastRevaluationDate;

  /// Last revaluation rate
  double? lastRevaluationRate;

  /// Settlement status
  late String settlementStatus;

  /// Settlement date
  DateTime? settlementDate;

  /// Settlement amount in functional currency
  double? settlementAmount;

  /// Settlement exchange rate
  double? settlementRate;

  /// Realized exchange gain/loss
  late double realizedExchangeGL;

  /// Unrealized exchange gain/loss
  late double unrealizedExchangeGL;

  /// Account code for exchange differences
  String? exchangeDifferenceAccount;

  /// Creation timestamp
  late int createdAt;

  /// Created by user ID
  String? createdBy;

  /// Audit trail
  String? notes;

  /// Default constructor for Isar
  CurrencyTransaction();

  /// Named constructor for creating currency transaction instances
  CurrencyTransaction.create({
    required this.transactionRef,
    required this.transactionCurrency,
    required this.functionalCurrency,
    required this.originalAmount,
    required this.functionalAmount,
    required this.exchangeRate,
    required this.rateSource,
    required this.rateDate,
    required this.transactionDate,
    required this.transactionType,
    this.isMonetaryItem = true,
    this.exchangeDifference = 0.0,
    this.lastRevaluationDate,
    this.lastRevaluationRate,
    this.settlementStatus = 'open',
    this.settlementDate,
    this.settlementAmount,
    this.settlementRate,
    this.realizedExchangeGL = 0.0,
    this.unrealizedExchangeGL = 0.0,
    this.exchangeDifferenceAccount,
    int? createdAt,
    this.createdBy,
    this.notes,
  }) {
    this.createdAt = createdAt ?? DateTime.now().millisecondsSinceEpoch;
  }

  /// Checks if transaction is in foreign currency
  bool get isForeignCurrency => transactionCurrency != functionalCurrency;

  /// Calculates current exchange difference for revaluation
  double calculateExchangeDifference(double currentRate) {
    if (!isMonetaryItem || !isForeignCurrency) return 0.0;

    final currentFunctionalAmount = originalAmount * currentRate;
    return currentFunctionalAmount - functionalAmount;
  }

  /// Updates revaluation information
  void revalue(double newRate, DateTime revaluationDate) {
    if (!isMonetaryItem || !isForeignCurrency) return;

    final newFunctionalAmount = originalAmount * newRate;
    final exchangeDiff = newFunctionalAmount - functionalAmount;

    functionalAmount = newFunctionalAmount;
    exchangeDifference = exchangeDiff;
    lastRevaluationDate = revaluationDate;
    lastRevaluationRate = newRate;
    unrealizedExchangeGL += exchangeDiff;
  }

  /// Settles the transaction
  void settle({
    required DateTime settlementDate,
    required double settlementRate,
    double? actualSettlementAmount,
  }) {
    final expectedSettlement = originalAmount * settlementRate;
    final actualSettlement = actualSettlementAmount ?? expectedSettlement;
    final realizedGL = actualSettlement - functionalAmount;

    this.settlementStatus = 'settled';
    this.settlementDate = settlementDate;
    this.settlementAmount = actualSettlement;
    this.settlementRate = settlementRate;
    this.realizedExchangeGL = realizedGL;
    // Clear unrealized GL as it becomes realized
    this.unrealizedExchangeGL = 0.0;
  }

  /// Gets the net exchange gain/loss
  double get netExchangeGL => realizedExchangeGL + unrealizedExchangeGL;

  /// Validates the transaction
  bool get isValid =>
      originalAmount != 0 &&
      functionalAmount != 0 &&
      exchangeRate > 0 &&
      transactionCurrency.length == 3 &&
      functionalCurrency.length == 3;

  /// Gets display string for the transaction
  String get displayString => '$transactionCurrency ${originalAmount.toStringAsFixed(2)} → '
      '$functionalCurrency ${functionalAmount.toStringAsFixed(2)} '
      '@ ${exchangeRate.toStringAsFixed(4)}';

  /// Converts to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'transactionRef': transactionRef,
        'transactionCurrency': transactionCurrency,
        'functionalCurrency': functionalCurrency,
        'originalAmount': originalAmount,
        'functionalAmount': functionalAmount,
        'exchangeRate': exchangeRate,
        'rateSource': rateSource,
        'rateDate': rateDate.toIso8601String(),
        'transactionDate': transactionDate.toIso8601String(),
        'transactionType': transactionType,
        'isMonetaryItem': isMonetaryItem,
        'exchangeDifference': exchangeDifference,
        'lastRevaluationDate': lastRevaluationDate?.toIso8601String(),
        'lastRevaluationRate': lastRevaluationRate,
        'settlementStatus': settlementStatus,
        'settlementDate': settlementDate?.toIso8601String(),
        'settlementAmount': settlementAmount,
        'settlementRate': settlementRate,
        'realizedExchangeGL': realizedExchangeGL,
        'unrealizedExchangeGL': unrealizedExchangeGL,
        'exchangeDifferenceAccount': exchangeDifferenceAccount,
        'createdAt': createdAt,
        'createdBy': createdBy,
        'notes': notes,
      };

  /// Creates from JSON
  factory CurrencyTransaction.fromJson(Map<String, dynamic> json) {
    final transaction = CurrencyTransaction.create(
      transactionRef: json['transactionRef'] as String,
      transactionCurrency: json['transactionCurrency'] as String,
      functionalCurrency: json['functionalCurrency'] as String,
      originalAmount: (json['originalAmount'] as num).toDouble(),
      functionalAmount: (json['functionalAmount'] as num).toDouble(),
      exchangeRate: (json['exchangeRate'] as num).toDouble(),
      rateSource: json['rateSource'] as String,
      rateDate: DateTime.parse(json['rateDate'] as String),
      transactionDate: DateTime.parse(json['transactionDate'] as String),
      transactionType: json['transactionType'] as String,
      isMonetaryItem: json['isMonetaryItem'] as bool? ?? true,
      exchangeDifference: (json['exchangeDifference'] as num?)?.toDouble() ?? 0.0,
      lastRevaluationDate: json['lastRevaluationDate'] != null
          ? DateTime.parse(json['lastRevaluationDate'] as String)
          : null,
      lastRevaluationRate: (json['lastRevaluationRate'] as num?)?.toDouble(),
      settlementStatus: json['settlementStatus'] as String? ?? 'open',
      settlementDate:
          json['settlementDate'] != null ? DateTime.parse(json['settlementDate'] as String) : null,
      settlementAmount: (json['settlementAmount'] as num?)?.toDouble(),
      settlementRate: (json['settlementRate'] as num?)?.toDouble(),
      realizedExchangeGL: (json['realizedExchangeGL'] as num?)?.toDouble() ?? 0.0,
      unrealizedExchangeGL: (json['unrealizedExchangeGL'] as num?)?.toDouble() ?? 0.0,
      exchangeDifferenceAccount: json['exchangeDifferenceAccount'] as String?,
      createdAt: json['createdAt'] as int?,
      createdBy: json['createdBy'] as String?,
      notes: json['notes'] as String?,
    );
    if (json['id'] != null) {
      transaction.id = json['id'] as int;
    }
    return transaction;
  }

  @override
  String toString() => displayString;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CurrencyTransaction &&
          runtimeType == other.runtimeType &&
          transactionRef == other.transactionRef;

  @override
  int get hashCode => transactionRef.hashCode;
}
