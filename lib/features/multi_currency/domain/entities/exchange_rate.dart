// Multi-Currency Engine - Exchange Rate Entity (Simplified)
// Part of Basir MVP Phase 2 Implementation
// Prepared by: فريق وكلاء تطوير مشروع بصير

import 'package:isar/isar.dart';

part 'exchange_rate.g.dart';

/// Exchange rate entity for currency conversions
/// Implements IFRS requirements for spot rates and historical rates
@collection
class ExchangeRate {
  /// Isar ID (auto-generated)
  Id id = Isar.autoIncrement;

  /// Base currency code (ISO 4217)
  @Index()
  late String baseCurrency;

  /// Target currency code (ISO 4217)
  @Index()
  late String targetCurrency;

  /// Exchange rate (1 base = rate * target)
  late double rate;

  /// Effective date for this rate
  @Index()
  late DateTime effectiveDate;

  /// Rate source (e.g., 'SAMA', 'ECB', 'Manual')
  late String source;

  /// Rate type ('spot', 'forward', 'average')
  late String rateType;

  /// Whether this is the current active rate
  late bool isActive;

  /// Bid rate (for buying base currency)
  double? bidRate;

  /// Ask rate (for selling base currency)
  double? askRate;

  /// Creation timestamp
  late int createdAt;

  /// Created by user ID
  String? createdBy;

  /// Audit trail notes
  String? notes;

  /// Default constructor for Isar
  ExchangeRate();

  /// Named constructor for creating exchange rate instances
  ExchangeRate.create({
    required this.baseCurrency,
    required this.targetCurrency,
    required this.rate,
    required this.effectiveDate,
    required this.source,
    this.rateType = 'spot',
    this.isActive = true,
    this.bidRate,
    this.askRate,
    int? createdAt,
    this.createdBy,
    this.notes,
  }) {
    this.createdAt = createdAt ?? DateTime.now().millisecondsSinceEpoch;
  }

  /// Gets the currency pair identifier
  String get currencyPair => '$baseCurrency/$targetCurrency';

  /// Gets the inverse rate (target to base)
  double get inverseRate => 1.0 / rate;

  /// Validates the exchange rate
  bool get isValid =>
      rate > 0 &&
      baseCurrency.length == 3 &&
      targetCurrency.length == 3 &&
      baseCurrency != targetCurrency;

  /// Converts amount from base to target currency
  double convertAmount(double amount) => amount * rate;

  /// Converts amount from target to base currency
  double convertAmountInverse(double amount) => amount / rate;

  /// Checks if rate is within acceptable spread
  bool isWithinSpread(double maxSpread) {
    if (bidRate == null || askRate == null) return true;
    final spread = (askRate! - bidRate!) / bidRate!;
    return spread <= maxSpread;
  }

  /// Gets the mid rate (average of bid and ask)
  double get midRate {
    if (bidRate != null && askRate != null) {
      return (bidRate! + askRate!) / 2;
    }
    return rate;
  }

  /// Converts to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'baseCurrency': baseCurrency,
        'targetCurrency': targetCurrency,
        'rate': rate,
        'effectiveDate': effectiveDate.toIso8601String(),
        'source': source,
        'rateType': rateType,
        'isActive': isActive,
        'bidRate': bidRate,
        'askRate': askRate,
        'createdAt': createdAt,
        'createdBy': createdBy,
        'notes': notes,
      };

  /// Creates from JSON
  factory ExchangeRate.fromJson(Map<String, dynamic> json) {
    final rate = ExchangeRate.create(
      baseCurrency: json['baseCurrency'] as String,
      targetCurrency: json['targetCurrency'] as String,
      rate: (json['rate'] as num).toDouble(),
      effectiveDate: DateTime.parse(json['effectiveDate'] as String),
      source: json['source'] as String,
      rateType: json['rateType'] as String? ?? 'spot',
      isActive: json['isActive'] as bool? ?? true,
      bidRate: (json['bidRate'] as num?)?.toDouble(),
      askRate: (json['askRate'] as num?)?.toDouble(),
      createdAt: json['createdAt'] as int?,
      createdBy: json['createdBy'] as String?,
      notes: json['notes'] as String?,
    );
    if (json['id'] != null) {
      rate.id = json['id'] as int;
    }
    return rate;
  }

  @override
  String toString() => '$currencyPair @ $rate ($source)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExchangeRate &&
          runtimeType == other.runtimeType &&
          baseCurrency == other.baseCurrency &&
          targetCurrency == other.targetCurrency &&
          effectiveDate == other.effectiveDate;

  @override
  int get hashCode => baseCurrency.hashCode ^ targetCurrency.hashCode ^ effectiveDate.hashCode;
}
