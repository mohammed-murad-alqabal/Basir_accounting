import 'package:basir_accounting_system/features/accounting/domain/entities/currency.dart';
import 'package:isar/isar.dart';

part 'currency_model.g.dart';

@collection
class CurrencyModel {
  CurrencyModel();

  factory CurrencyModel.fromEntity(Currency entity) => CurrencyModel()
    ..id = entity.id
    ..name = entity.name
    ..symbol = entity.symbol
    ..exchangeRate = entity.exchangeRate
    ..isDefault = entity.isDefault
    ..updatedAt = DateTime.now();

  Id? isarId;

  @Index(unique: true, replace: true)
  late String id;

  late String name;
  late String symbol;
  late double exchangeRate;
  late bool isDefault;
  late DateTime updatedAt;

  Currency toEntity() => Currency(
    id: id, name: name, symbol: symbol,
    exchangeRate: exchangeRate, isDefault: isDefault,
  );
}
