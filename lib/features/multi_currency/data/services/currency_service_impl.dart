// Multi-Currency Engine - Service Implementation
// Part of Basir MVP Phase 2 Implementation
// Prepared by: فريق وكلاء تطوير مشروع بصير

import 'package:basir_app/core/services/isar_service.dart';
import 'package:basir_app/features/multi_currency/domain/entities/currency.dart';
import 'package:basir_app/features/multi_currency/domain/entities/currency_transaction.dart';
import 'package:basir_app/features/multi_currency/domain/entities/exchange_rate.dart';
import 'package:basir_app/features/multi_currency/domain/services/currency_service.dart';
import 'package:decimal/decimal.dart';
import 'package:isar/isar.dart';

/// Implementation of CurrencyService using Isar database
class CurrencyServiceImpl implements CurrencyService {
  CurrencyServiceImpl(this._isarService);
  final IsarService _isarService;

  @override
  Future<List<Currency>> getActiveCurrencies() async {
    final isar = await _isarService.database;
    return await isar.currencys.filter().isActiveEqualTo(true).sortByCode().findAll();
  }

  @override
  Future<Currency> getFunctionalCurrency() async {
    final isar = await _isarService.database;
    final functional = await isar.currencys.filter().isFunctionalEqualTo(true).findFirst();

    if (functional == null) {
      throw StateError('No functional currency defined');
    }

    return functional;
  }

  @override
  Future<ExchangeRate?> getCurrentRate(String from, String to) async {
    if (from == to) return null; // Same currency

    final isar = await _isarService.database;
    return await isar.exchangeRates
        .filter()
        .baseCurrencyEqualTo(from)
        .and()
        .targetCurrencyEqualTo(to)
        .and()
        .isActiveEqualTo(true)
        .sortByEffectiveDateDesc()
        .findFirst();
  }

  @override
  Future<ExchangeRate?> getHistoricalRate(
    String from,
    String to,
    DateTime date,
  ) async {
    if (from == to) return null; // Same currency

    final isar = await _isarService.database;
    return await isar.exchangeRates
        .filter()
        .baseCurrencyEqualTo(from)
        .and()
        .targetCurrencyEqualTo(to)
        .and()
        .effectiveDateLessThan(date.add(const Duration(days: 1)))
        .sortByEffectiveDateDesc()
        .findFirst();
  }

  @override
  Future<Decimal> convertAmount(
    Decimal amount,
    String fromCurrency,
    String toCurrency, {
    DateTime? valueDate,
  }) async {
    if (fromCurrency == toCurrency) return amount;

    ExchangeRate? rate;
    if (valueDate != null) {
      rate = await getHistoricalRate(fromCurrency, toCurrency, valueDate);
    } else {
      rate = await getCurrentRate(fromCurrency, toCurrency);
    }

    if (rate == null) {
      throw StateError('No exchange rate found for $fromCurrency/$toCurrency');
    }

    return amount * Decimal.parse(rate.rate.toString());
  }

  @override
  Future<CurrencyTransaction> createCurrencyTransaction({
    required String transactionRef,
    required String transactionCurrency,
    required Decimal originalAmount,
    required DateTime transactionDate,
    required String transactionType,
    bool isMonetaryItem = true,
    String? notes,
  }) async {
    final functional = await getFunctionalCurrency();
    final functionalCurrency = functional.code;

    // Convert to functional currency
    final functionalAmount = await convertAmount(
      originalAmount,
      transactionCurrency,
      functionalCurrency,
      valueDate: transactionDate,
    );

    // Get the exchange rate used
    final rate = await getHistoricalRate(
      transactionCurrency,
      functionalCurrency,
      transactionDate,
    );

    if (rate == null) {
      throw StateError('No exchange rate available for conversion');
    }

    final transaction = CurrencyTransaction.create(
      transactionRef: transactionRef,
      transactionCurrency: transactionCurrency,
      functionalCurrency: functionalCurrency,
      originalAmount: originalAmount.toDouble(),
      functionalAmount: functionalAmount.toDouble(),
      exchangeRate: rate.rate,
      rateSource: rate.source,
      rateDate: rate.effectiveDate,
      transactionDate: transactionDate,
      transactionType: transactionType,
      isMonetaryItem: isMonetaryItem,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      notes: notes,
    );

    // Save to database
    final isar = await _isarService.database;
    await isar.writeTxn(() async {
      await isar.currencyTransactions.put(transaction);
    });

    return transaction;
  }

  @override
  Future<List<CurrencyTransaction>> revaluateMonetaryItems(
    DateTime revaluationDate,
  ) async {
    final isar = await _isarService.database;

    // Get all open monetary items
    final monetaryItems = await isar.currencyTransactions
        .filter()
        .isMonetaryItemEqualTo(true)
        .and()
        .settlementStatusEqualTo('open')
        .findAll();

    final revaluatedItems = <CurrencyTransaction>[];

    for (final item in monetaryItems) {
      if (item.transactionCurrency == item.functionalCurrency) continue;

      // Get current rate
      final currentRate = await getCurrentRate(
        item.transactionCurrency,
        item.functionalCurrency,
      );

      if (currentRate == null) continue;

      // Revalue the item
      final revaluated = item.revalue(currentRate.rate, revaluationDate);
      revaluatedItems.add(revaluated);
    }

    // Save revaluated items
    await isar.writeTxn(() async {
      await isar.currencyTransactions.putAll(revaluatedItems);
    });

    return revaluatedItems;
  }

  @override
  Future<Decimal> calculateExchangeDifference(
    CurrencyTransaction transaction,
    DateTime asOfDate,
  ) async {
    if (!transaction.isMonetaryItem ||
        transaction.transactionCurrency == transaction.functionalCurrency) {
      return Decimal.zero;
    }

    final currentRate = await getHistoricalRate(
      transaction.transactionCurrency,
      transaction.functionalCurrency,
      asOfDate,
    );

    if (currentRate == null) return Decimal.zero;

    final currentValue = Decimal.parse(transaction.originalAmount.toString()) *
        Decimal.parse(currentRate.rate.toString());
    final originalValue = Decimal.parse(transaction.functionalAmount.toString());

    return currentValue - originalValue;
  }

  @override
  Future<CurrencyTransaction> settleCurrencyTransaction(
    int transactionId, {
    required DateTime settlementDate,
    Decimal? actualAmount,
  }) async {
    final isar = await _isarService.database;
    final transaction = await isar.currencyTransactions.get(transactionId);

    if (transaction == null) {
      throw StateError('Transaction not found');
    }

    // Get settlement rate
    final settlementRate = await getHistoricalRate(
      transaction.transactionCurrency,
      transaction.functionalCurrency,
      settlementDate,
    );

    if (settlementRate == null) {
      throw StateError('No settlement rate available');
    }

    // Settle the transaction
    final settled = transaction.settle(
      settlementDate: settlementDate,
      settlementRate: settlementRate.rate,
      actualSettlementAmount: actualAmount?.toDouble(),
    );

    // Save to database
    await isar.writeTxn(() async {
      await isar.currencyTransactions.put(settled);
    });

    return settled;
  }

  @override
  Future<List<ExchangeRate>> getRateHistory(
    String baseCurrency,
    String targetCurrency, {
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    final isar = await _isarService.database;
    var query = isar.exchangeRates
        .filter()
        .baseCurrencyEqualTo(baseCurrency)
        .and()
        .targetCurrencyEqualTo(targetCurrency);

    if (fromDate != null) {
      query = query.and().effectiveDateGreaterThan(fromDate);
    }

    if (toDate != null) {
      query = query.and().effectiveDateLessThan(toDate);
    }

    return await query.sortByEffectiveDateDesc().findAll();
  }

  @override
  Future<void> updateExchangeRates({
    required String source,
    required Map<String, double> rates,
    DateTime? effectiveDate,
  }) async {
    final isar = await _isarService.database;
    final functional = await getFunctionalCurrency();
    final date = effectiveDate ?? DateTime.now();

    final exchangeRates = <ExchangeRate>[];

    for (final entry in rates.entries) {
      final currencyPair = entry.key.split('/');
      if (currencyPair.length != 2) continue;

      final rate = ExchangeRate(
        id: DateTime.now().millisecondsSinceEpoch + exchangeRates.length,
        baseCurrency: currencyPair[0],
        targetCurrency: currencyPair[1],
        rate: entry.value,
        effectiveDate: date,
        source: source,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );

      exchangeRates.add(rate);
    }

    await isar.writeTxn(() async {
      await isar.exchangeRates.putAll(exchangeRates);
    });
  }

  @override
  Future<bool> validateCurrencyTransaction(
    CurrencyTransaction transaction,
  ) async {
    // Basic validation
    if (!transaction.isValid) return false;

    // Check if currencies exist
    final currencies = await getActiveCurrencies();
    final currencyCodes = currencies.map((c) => c.code).toSet();

    if (!currencyCodes.contains(transaction.transactionCurrency) ||
        !currencyCodes.contains(transaction.functionalCurrency)) {
      return false;
    }

    // Validate exchange rate
    if (transaction.isForeignCurrency) {
      final expectedRate = await getHistoricalRate(
        transaction.transactionCurrency,
        transaction.functionalCurrency,
        transaction.transactionDate,
      );

      if (expectedRate == null) return false;

      // Allow small tolerance for rate differences
      const tolerance = 0.0001;
      final rateDiff = (transaction.exchangeRate - expectedRate.rate).abs();
      if (rateDiff > tolerance) return false;
    }

    return true;
  }

  @override
  Future<Map<String, Decimal>> getUnrealizedExchangeGL(
    DateTime asOfDate,
  ) async {
    final isar = await _isarService.database;
    final openItems = await isar.currencyTransactions
        .filter()
        .isMonetaryItemEqualTo(true)
        .and()
        .settlementStatusEqualTo('open')
        .findAll();

    final glByAccount = <String, Decimal>{};

    for (final item in openItems) {
      final exchangeDiff = await calculateExchangeDifference(item, asOfDate);
      final account = item.exchangeDifferenceAccount ?? 'EXCHANGE_GL';

      glByAccount[account] = (glByAccount[account] ?? Decimal.zero) + exchangeDiff;
    }

    return glByAccount;
  }

  @override
  Future<Map<String, Decimal>> getRealizedExchangeGL(
    DateTime fromDate,
    DateTime toDate,
  ) async {
    final isar = await _isarService.database;
    final settledItems = await isar.currencyTransactions
        .filter()
        .settlementStatusEqualTo('settled')
        .and()
        .settlementDateBetween(fromDate, toDate)
        .findAll();

    final glByAccount = <String, Decimal>{};

    for (final item in settledItems) {
      final realizedGL = Decimal.parse(item.realizedExchangeGL.toString());
      final account = item.exchangeDifferenceAccount ?? 'EXCHANGE_GL';

      glByAccount[account] = (glByAccount[account] ?? Decimal.zero) + realizedGL;
    }

    return glByAccount;
  }
}
