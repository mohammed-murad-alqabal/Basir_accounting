/// Sustainability Metric Classifications per ISSB (IFRS S1 & S2) standards.
///
/// This ontology supports the disclosure of non-financial risks and
/// opportunities related to climate and sustainability.
enum SustainabilityMetricType {
  /// Direct greenhouse gas emissions from sources owned or controlled (e.g., boilers, vehicles).
  emissionsScope1,

  /// Indirect GHG emissions from the generation of purchased electricity or energy.
  emissionsScope2,

  /// All other indirect emissions in the organization's value chain.
  emissionsScope3,

  /// Risks to operations arising from extreme weather events or rising sea levels.
  physicalClimateRisk,

  /// Risks related to moving towards a lower-carbon economy (e.g., policy changes).
  transitionClimateRisk,

  /// Metrics tracking the usage of biodiversity, water, and circular economy resources.
  naturalResources,
}

/// Represents a quantitative non-financial disclosure tied to a fiscal period.
class SustainabilityMetric {
  /// Creates a sustainability metric measurement.
  const SustainabilityMetric({
    required this.type,
    required this.value,
    required this.unit,
    required this.measuredAt,
    required this.methodology,
  });

  /// The ISSB-aligned classification of the metric.
  final SustainabilityMetricType type;

  /// The scalar value of the measurement.
  final double value;

  /// The standard unit of measurement (e.g., "tCO2e", "m3").
  final String unit;

  /// Precise point in time the measurement was recorded.
  final DateTime measuredAt;

  /// Scientific or regulatory methodology used for calculation (e.g., "GHG Protocol").
  final String methodology;
}
