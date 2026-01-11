// Multi-Currency Engine - Core Service
// Part of Basir MVP Phase 2 Implementation
// Prepared by: فريق وكلاء تطوير مشروع بصير

import 'package:decimal/decimal.dart';

import '../entities/currency.dart';
import '../entities/currency_transaction.dart';
import '../entities/exchange_rate.dart';

/// Core service for multi-currency operations
/// Implements IFRS requirements for foreign currency transactions
abstract class CurrencyService {
  /// Gets all active currencies
  Future<List<Currency>> getActiveCurrencies();

  /// Gets functional currency for the entity
  Future<Currency> getFunctionalCurrency();

  /// Gets current exchange rate between two currencies
  Future<ExchangeRate?> getCurrentRate(String from, String to);

  /// Gets historical exchange rate for a specific date
  Future<ExchangeRate?> getHistoricalRate(
    String from,
    String to,
    DateTime date,
  );

  /// Converts amount between currencies using current rate
  Future<Decimal> convertAmount(
    Decimal amount,
    String fromCurrency,
    String toCurrency, {
    DateTime? valueDate,
  });

  /// Creates a currency transaction record
  Future<CurrencyTransaction> createCurrencyTransaction({
    required String transactionRef,
    required String transactionCurrency,
    required Decimal originalAmount,
    required DateTime transactionDate,
    required String transactionType,
    bool isMonetaryItem = true,
    String? notes,
  });

  /// Revalues monetary items at period end
  Future<List<CurrencyTransaction>> revaluateMonetaryItems(
    DateTime revaluationDate,
  );

  /// Calculates exchange differences for a transaction
  Future<Decimal> calculateExchangeDifference(
    CurrencyTransaction transaction,
    DateTime asOfDate,
  );

  /// Settles a currency transaction
  Future<CurrencyTransaction> settleCurrencyTransaction(
    int transactionId, {
    required DateTime settlementDate,
    Decimal? actualAmount,
  });

  /// Gets exchange rate audit trail
  Future<List<ExchangeRate>> getRateHistory(
    String baseCurrency,
    String targetCurrency, {
    DateTime? fromDate,
    DateTime? toDate,
  });

  /// Updates exchange rates from external source
  Future<void> updateExchangeRates({
    required String source,
    required Map<String, double> rates,
    DateTime? effectiveDate,
  });

  /// Validates currency transaction for IFRS compliance
  Future<bool> validateCurrencyTransaction(CurrencyTransaction transaction);

  /// Gets unrealized exchange gains/losses
  Future<Map<String, Decimal>> getUnrealizedExchangeGL(DateTime asOfDate);

  /// Gets realized exchange gains/losses for a period
  Future<Map<String, Decimal>> getRealizedExchangeGL(
    DateTime fromDate,
    DateTime toDate,
  );
}
