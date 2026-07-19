import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'strategic_outlook.freezed.dart';
part 'strategic_outlook.g.dart';

/// Root entity for the Strategic Outlook forecast.
@freezed
class StrategicOutlook with _$StrategicOutlook {
  /// Creates a [StrategicOutlook].
  const factory StrategicOutlook({
    /// Timestamp when the outlook was generated.
    required DateTime generatedAt,

    /// Predicted P&L metrics for future periods.
    required List<PredictiveMetric> pnlForecast,

    /// Predicted Cash Flow metrics for future periods.
    required List<PredictiveMetric> cashFlowForecast,

    /// List of AI-generated insights based on the forecast.
    required List<StrategicInsight> insights,

    /// Confidence score (0.0 to 1.0) of the prediction model.
    required double confidenceScore,
  }) = _StrategicOutlook;

  /// Creates a [StrategicOutlook] from a JSON map.
  factory StrategicOutlook.fromJson(Map<String, dynamic> json) =>
      _$StrategicOutlookFromJson(json);
}

/// Represents a forecasted value for a specific period.
@freezed
class PredictiveMetric with _$PredictiveMetric {
  /// Creates a [PredictiveMetric].
  const factory PredictiveMetric({
    /// The period (month) this metric refers to.
    required DateTime period,

    /// Forecasted revenue.
    required Decimal revenue,

    /// Forecasted expenses.
    required Decimal expense,

    /// Forecasted net income.
    required Decimal netIncome,

    /// Forecasted cash inflow.
    required Decimal cashInflow,

    /// Forecasted cash outflow.
    required Decimal cashOutflow,
  }) = _PredictiveMetric;

  /// Creates a [PredictiveMetric] from a JSON map.
  factory PredictiveMetric.fromJson(Map<String, dynamic> json) =>
      _$PredictiveMetricFromJson(json);
}

/// AI-generated strategic observation.
@freezed
class StrategicInsight with _$StrategicInsight {
  /// Creates a [StrategicInsight].
  const factory StrategicInsight({
    /// Short title of the insight.
    required String title,

    /// Detailed observation based on data trends.
    required String observation,

    /// Actionable recommendation for the user.
    required String recommendation,

    /// Impact level (positive, negative, neutral).
    required InsightImpact impact,

    /// Priority level ('high', 'medium', 'low').
    required String priority,
  }) = _StrategicInsight;

  /// Creates a [StrategicInsight] from a JSON map.
  factory StrategicInsight.fromJson(Map<String, dynamic> json) =>
      _$StrategicInsightFromJson(json);
}

/// Impact level of a strategic insight.
enum InsightImpact {
  /// Positive impact on business health.
  positive,

  /// Negative impact on business health.
  negative,

  /// Neutral or informational impact.
  neutral,
}
