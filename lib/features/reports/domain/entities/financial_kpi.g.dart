// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'financial_kpi.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AgentInsightImpl _$$AgentInsightImplFromJson(Map<String, dynamic> json) =>
    _$AgentInsightImpl(
      id: json['id'] as String,
      source: $enumDecode(_$AgentSourceEnumMap, json['source']),
      riskLevel: $enumDecode(_$InsightRiskLevelEnumMap, json['riskLevel']),
      title: json['title'] as String,
      description: json['description'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
      actionLabel: json['actionLabel'] as String?,
      actionRoute: json['actionRoute'] as String?,
    );

Map<String, dynamic> _$$AgentInsightImplToJson(_$AgentInsightImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'source': _$AgentSourceEnumMap[instance.source]!,
      'riskLevel': _$InsightRiskLevelEnumMap[instance.riskLevel]!,
      'title': instance.title,
      'description': instance.description,
      'timestamp': instance.timestamp.toIso8601String(),
      'metadata': instance.metadata,
      'actionLabel': instance.actionLabel,
      'actionRoute': instance.actionRoute,
    };

const _$AgentSourceEnumMap = {
  AgentSource.strategist: 'strategist',
  AgentSource.tax: 'tax',
  AgentSource.forensic: 'forensic',
  AgentSource.operational: 'operational',
  AgentSource.sustainability: 'sustainability',
};

const _$InsightRiskLevelEnumMap = {
  InsightRiskLevel.info: 'info',
  InsightRiskLevel.low: 'low',
  InsightRiskLevel.medium: 'medium',
  InsightRiskLevel.high: 'high',
  InsightRiskLevel.critical: 'critical',
};

_$FinancialKpiImpl _$$FinancialKpiImplFromJson(Map<String, dynamic> json) =>
    _$FinancialKpiImpl(
      name: json['name'] as String,
      value: (json['value'] as num).toDouble(),
      unit: json['unit'] as String,
      trend: (json['trend'] as num).toDouble(),
      health: $enumDecode(_$KpiHealthEnumMap, json['health']),
      description: json['description'] as String,
    );

Map<String, dynamic> _$$FinancialKpiImplToJson(_$FinancialKpiImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'value': instance.value,
      'unit': instance.unit,
      'trend': instance.trend,
      'health': _$KpiHealthEnumMap[instance.health]!,
      'description': instance.description,
    };

const _$KpiHealthEnumMap = {
  KpiHealth.healthy: 'healthy',
  KpiHealth.warning: 'warning',
  KpiHealth.critical: 'critical',
};
