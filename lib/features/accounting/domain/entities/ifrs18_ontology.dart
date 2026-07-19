/// IFRS 18 specific categories for the Statement of Profit or Loss.
///
/// This ontology enables the mandatory subtotals and classification structure
/// required by the new IFRS 18 standard for financial performance reporting.
enum Ifrs18Category {
  /// Income and expenses from core business operations and daily activities.
  operating,

  /// Returns from investments in associates, joint ventures, and financial
  /// assets.
  investing,

  /// Income and expenses related to capital structure and debt servicing.
  financing,

  /// Income tax expense or credit as defined by the relevant jurisdiction.
  incomeTax,

  /// Gains or losses from operational segments that have been terminated.
  discontinued,

  /// Not applicable for this specific account type (e.g., Balance Sheet
  /// accounts).
  none,
}

/// Management Performance Measure (MPM) container as mandated by IFRS 18.
///
/// MPMs are non-GAAP measures used by management to communicate financial
/// performance, requiring strict reconciliation to the nearest IFRS subtotal.
class ManagementPerformanceMeasure {
  /// Creates an MPM record.
  const ManagementPerformanceMeasure({
    required this.name,
    required this.description,
    required this.value,
    required this.reconciliationToIfrs,
  });

  /// The custom narrative name of the performance indicator (e.g., "Adjusted
  /// EBITDA").
  final String name;

  /// Clear explanation of why this measure reflects business performance.
  final String description;

  /// The quantitative value of the measure.
  final double value;

  /// Mathematical and narrative bridge to the corresponding IFRS subtotal.
  final String reconciliationToIfrs;
}
