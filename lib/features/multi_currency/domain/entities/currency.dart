// Multi-Currency Engine - Currency Entity (Simplified)
// Part of Basir MVP Phase 2 Implementation
// Prepared by: فريق وكلاء تطوير مشروع بصير

import 'package:isar/isar.dart';

part 'currency.g.dart';

/// Currency entity following ISO 4217 standards
/// Implements IFRS requirements for functional and presentation currencies
@collection
class Currency {
  /// Isar ID (auto-generated)
  Id id = Isar.autoIncrement;

  /// ISO 4217 currency code (e.g., 'USD', 'SAR', 'AED')
  @Index(unique: true)
  late String code;

  /// Currency name in English
  late String nameEn;

  /// Currency name in Arabic
  late String nameAr;

  /// Currency symbol (e.g., '$', 'ر.س', 'د.إ')
  late String symbol;

  /// Number of decimal places (typically 2, but can be 0 for some)
  late int decimalPlaces;

  /// Whether this currency is active for transactions
  late bool isActive;

  /// Whether this is the base/functional currency
  late bool isFunctional;

  /// Country code (ISO 3166-1 alpha-2)
  String? countryCode;

  /// Creation timestamp
  late int createdAt;

  /// Last update timestamp
  late int updatedAt;

  /// Default constructor for Isar
  Currency();

  /// Named constructor for creating currency instances
  Currency.create({
    required this.code,
    required this.nameEn,
    required this.nameAr,
    required this.symbol,
    this.decimalPlaces = 2,
    this.isActive = true,
    this.isFunctional = false,
    this.countryCode,
    int? createdAt,
    int? updatedAt,
  }) {
    this.createdAt = createdAt ?? DateTime.now().millisecondsSinceEpoch;
    this.updatedAt = updatedAt ?? DateTime.now().millisecondsSinceEpoch;
  }

  /// Validates currency code format (ISO 4217)
  bool get isValidCode => code.length == 3 && code == code.toUpperCase();

  /// Gets display name based on locale
  String getDisplayName(String locale) {
    return locale.startsWith('ar') ? nameAr : nameEn;
  }

  /// Formats amount according to currency rules
  String formatAmount(double amount) {
    final formatted = amount.toStringAsFixed(decimalPlaces);
    return '$symbol $formatted';
  }

  /// Converts to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'nameEn': nameEn,
        'nameAr': nameAr,
        'symbol': symbol,
        'decimalPlaces': decimalPlaces,
        'isActive': isActive,
        'isFunctional': isFunctional,
        'countryCode': countryCode,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };

  /// Creates from JSON
  factory Currency.fromJson(Map<String, dynamic> json) {
    final currency = Currency.create(
      code: json['code'] as String,
      nameEn: json['nameEn'] as String,
      nameAr: json['nameAr'] as String,
      symbol: json['symbol'] as String,
      decimalPlaces: json['decimalPlaces'] as int? ?? 2,
      isActive: json['isActive'] as bool? ?? true,
      isFunctional: json['isFunctional'] as bool? ?? false,
      countryCode: json['countryCode'] as String?,
      createdAt: json['createdAt'] as int?,
      updatedAt: json['updatedAt'] as int?,
    );
    if (json['id'] != null) {
      currency.id = json['id'] as int;
    }
    return currency;
  }

  /// Common currency factory methods
  static Currency createSAR() => Currency.create(
        code: 'SAR',
        nameEn: 'Saudi Riyal',
        nameAr: 'ريال سعودي',
        symbol: 'ر.س',
        decimalPlaces: 2,
        countryCode: 'SA',
        isFunctional: true,
      );

  static Currency createUSD() => Currency.create(
        code: 'USD',
        nameEn: 'US Dollar',
        nameAr: 'دولار أمريكي',
        symbol: r'$',
        decimalPlaces: 2,
        countryCode: 'US',
      );

  static Currency createAED() => Currency.create(
        code: 'AED',
        nameEn: 'UAE Dirham',
        nameAr: 'درهم إماراتي',
        symbol: 'د.إ',
        decimalPlaces: 2,
        countryCode: 'AE',
      );

  static Currency createEUR() => Currency.create(
        code: 'EUR',
        nameEn: 'Euro',
        nameAr: 'يورو',
        symbol: '€',
        decimalPlaces: 2,
        countryCode: 'EU',
      );

  @override
  String toString() => '$code ($symbol)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Currency && runtimeType == other.runtimeType && code == other.code;

  @override
  int get hashCode => code.hashCode;
}
