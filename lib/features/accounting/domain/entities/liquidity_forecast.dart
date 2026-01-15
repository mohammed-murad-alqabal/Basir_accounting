import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'liquidity_forecast.freezed.dart';

/// Represents a liquidity forecast for a specific duration.
@freezed
class LiquidityForecast with _$LiquidityForecast {
  const factory LiquidityForecast({
    /// Start date of the forecast period.
    required DateTime startDate,

    /// End date of the forecast period.
    required DateTime endDate,

    /// Total expected cash inflow (Receivables).
    required Decimal totalInflow,

    /// Total expected cash outflow (Payables).
    required Decimal totalOutflow,

    /// Net cash flow (Inflow - Outflow).
    required Decimal netChange,

    /// Daily breakdown of cash flow.
    required List<DailyCashFlow> dailyBreakdown,
  }) = _LiquidityForecast;
}

@freezed
class DailyCashFlow with _$DailyCashFlow {
  const factory DailyCashFlow({
    required DateTime date,
    required Decimal inflow,
    required Decimal outflow,
  }) = _DailyCashFlow;
}
