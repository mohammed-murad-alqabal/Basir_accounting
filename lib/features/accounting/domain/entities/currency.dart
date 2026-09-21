// Currency entity for multi-currency support
class Currency {
  const Currency({
    required this.id,
    required this.name,
    required this.symbol,
    required this.exchangeRate,
    this.isDefault = false,
  });
  final String id;
  final String name;
  final String symbol;
  final double exchangeRate;
  final bool isDefault;

  Currency copyWith({
    String? id,
    String? name,
    String? symbol,
    double? exchangeRate,
    bool? isDefault,
  }) => Currency(
    id: id ?? this.id,
    name: name ?? this.name,
    symbol: symbol ?? this.symbol,
    exchangeRate: exchangeRate ?? this.exchangeRate,
    isDefault: isDefault ?? this.isDefault,
  );
}
