import 'package:freezed_annotation/freezed_annotation.dart';

part 'financial_kpi.freezed.dart';
part 'financial_kpi.g.dart';

enum KpiHealth { healthy, warning, critical }

@freezed
class FinancialKpi with _$FinancialKpi {
  const factory FinancialKpi({
    required String name,
    required double value,
    required String unit,
    required double trend, // Percentage change from previous period
    required KpiHealth health,
    required String description,
  }) = _FinancialKpi;

  factory FinancialKpi.fromJson(Map<String, dynamic> json) =>
      _$FinancialKpiFromJson(json);
}
