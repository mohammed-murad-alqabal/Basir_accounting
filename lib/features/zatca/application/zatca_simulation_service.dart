import 'dart:async';
import 'dart:math';

import 'package:basir_accounting_system/features/invoices/domain/entities/invoice.dart';
import 'package:basir_accounting_system/features/zatca/domain/zatca_types.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'zatca_simulation_service.g.dart';

/// Simulates the ZATCA Phase 2 "Live Reporting" experience.
///
/// This service provides mock endpoints for onboarding and invoice reporting,
/// allow the UI to reflect the compliance flow without a live Sandbox
/// connection.
@riverpod
class ZatcaSimulationService extends _$ZatcaSimulationService {
  @override
  void build() {
    return;
  }

  /// Simulates onboarding a device (CSR Generation -> CSID).
  ///
  /// Returns a success message and mock credentials (implicitly).
  Future<ZatcaSubmissionResult> onboardDevice({
    required String otp,
  }) async {
    // Simulate network delay
    await Future<void>.delayed(const Duration(seconds: 2));

    if (otp == '000000') {
      return const ZatcaSubmissionResult(
        success: false,
        message: 'Invalid OTP provided.',
        status: ZatcaSubmissionStatus.rejected,
      );
    }

    return const ZatcaSubmissionResult(
      success: true,
      message: 'Device successfully onboarded with ZATCA (Simulated).',
      status: ZatcaSubmissionStatus.reported,
    );
  }

  /// Simulates reporting an invoice to ZATCA.
  ///
  /// returns a [ZatcaSubmissionResult] with a simulated UUID and Status.
  Future<ZatcaSubmissionResult> reportInvoice(Invoice invoice) async {
    // Simulate processing time
    await Future<void>.delayed(const Duration(milliseconds: 1500));

    final random = Random();
    final isSuccess = random.nextDouble() > 0.1; // 90% success rate

    if (!isSuccess) {
      return const ZatcaSubmissionResult(
        success: false,
        message: 'Validation Error: BR-KSA-EN-12: Buyer address missing.',
        status: ZatcaSubmissionStatus.rejected,
      );
    }

    final uuid = const Uuid().v4();

    return ZatcaSubmissionResult(
      success: true,
      message: 'Invoice cleared successfully.',
      status: ZatcaSubmissionStatus.reported,
      zatcaUuid: uuid,
      qrCode: 'SimulatedQRBase64StringForInvoice${invoice.id}',
    );
  }
}
