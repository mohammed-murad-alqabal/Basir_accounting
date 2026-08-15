// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'strategic_outlook.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StrategicOutlookImpl _$$StrategicOutlookImplFromJson(
        Map<String, dynamic> json) =>
    _$StrategicOutlookImpl(
      generatedAt: DateTime.parse(json['generatedAt'] as String),
      pnlForecast: (json['pnlForecast'] as List<dynamic>)
          .map((e) => PredictiveMetric.fromJson(e as Map<String, dynamic>))
          .toList(),
      cashFlowForecast: (json['cashFlowForecast'] as List<dynamic>)
          .map((e) => PredictiveMetric.fromJson(e as Map<String, dynamic>))
          .toList(),
      insights: (json['insights'] as List<dynamic>)
          .map((e) => StrategicInsight.fromJson(e as Map<String, dynamic>))
          .toList(),
      confidenceScore: (json['confidenceScore'] as num).toDouble(),
    );

Map<String, dynamic> _$$StrategicOutlookImplToJson(
        _$StrategicOutlookImpl instance) =>
    <String, dynamic>{
      'generatedAt': instance.generatedAt.toIso8601String(),
      'pnlForecast': instance.pnlForecast,
      'cashFlowForecast': instance.cashFlowForecast,
      'insights': instance.insights,
      'confidenceScore': instance.confidenceScore,
    };

_$PredictiveMetricImpl _$$PredictiveMetricImplFromJson(
        Map<String, dynamic> json) =>
    _$PredictiveMetricImpl(
      period: DateTime.parse(json['period'] as String),
      revenue: Decimal.fromJson(json['revenue'] as String),
      expense: Decimal.fromJson(json['expense'] as String),
      netIncome: Decimal.fromJson(json['netIncome'] as String),
      cashInflow: Decimal.fromJson(json['cashInflow'] as String),
      cashOutflow: Decimal.fromJson(json['cashOutflow'] as String),
    );

Map<String, dynamic> _$$PredictiveMetricImplToJson(
        _$PredictiveMetricImpl instance) =>
    <String, dynamic>{
      'period': instance.period.toIso8601String(),
      'revenue': instance.revenue,
      'expense': instance.expense,
      'netIncome': instance.netIncome,
      'cashInflow': instance.cashInflow,
      'cashOutflow': instance.cashOutflow,
    };

_$StrategicInsightImpl _$$StrategicInsightImplFromJson(
        Map<String, dynamic> json) =>
    _$StrategicInsightImpl(
      title: json['title'] as String,
      observation: json['observation'] as String,
      recommendation: json['recommendation'] as String,
      impact: $enumDecode(_$InsightImpactEnumMap, json['impact']),
      priority: json['priority'] as String,
    );

Map<String, dynamic> _$$StrategicInsightImplToJson(
        _$StrategicInsightImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'observation': instance.observation,
      'recommendation': instance.recommendation,
      'impact': _$InsightImpactEnumMap[instance.impact]!,
      'priority': instance.priority,
    };

const _$InsightImpactEnumMap = {
  InsightImpact.positive: 'positive',
  InsightImpact.negative: 'negative',
  InsightImpact.neutral: 'neutral',
};
