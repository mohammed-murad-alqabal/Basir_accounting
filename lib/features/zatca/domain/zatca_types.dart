/// Represents the status of an invoice in the ZATCA system.
enum ZatcaSubmissionStatus {
  /// The invoice has not been reported to ZATCA yet.
  notReported,

  /// The invoice has been successfully reported and cleared/signed.
  reported,

  /// The invoice was rejected by ZATCA due to validation errors.
  rejected,

  /// The invoice was accepted but with warnings.
  reportedWithWarnings,
}

/// Represents the result of a ZATCA submission attempt (Simulation).
class ZatcaSubmissionResult {
  /// Creates a [ZatcaSubmissionResult].
  const ZatcaSubmissionResult({
    required this.success,
    required this.message,
    required this.status,
    this.zatcaUuid,
    this.qrCode,
  });

  /// Whether the submission was successful.
  final bool success;

  /// A descriptive message from the system (e.g., error details).
  final String message;

  /// The UUID returned by ZATCA (simulated).
  final String? zatcaUuid;

  /// The QR code string generated (simulated).
  final String? qrCode;

  /// The submission status.
  final ZatcaSubmissionStatus status;
}
