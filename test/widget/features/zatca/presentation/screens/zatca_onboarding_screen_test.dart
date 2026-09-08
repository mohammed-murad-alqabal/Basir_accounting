import 'package:basir_accounting_system/features/zatca/application/zatca_simulation_service.dart';
import 'package:basir_accounting_system/features/zatca/domain/zatca_types.dart';
import 'package:basir_accounting_system/features/zatca/presentation/screens/zatca_onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeZatcaSimulationService extends ZatcaSimulationService {
  _FakeZatcaSimulationService({required this.result, this.shouldThrow = false});

  final ZatcaSubmissionResult result;
  final bool shouldThrow;
  int calls = 0;
  String? lastOtp;

  @override
  Future<ZatcaSubmissionResult> onboardDevice({required String otp}) async {
    calls++;
    lastOtp = otp;
    if (shouldThrow) throw Exception('simulated ZATCA outage');
    return result;
  }
}

Widget _host(_FakeZatcaSimulationService service) => ProviderScope(
      overrides: [
        zatcaSimulationServiceProvider.overrideWith(() => service),
      ],
      child: const MaterialApp(home: ZatcaOnboardingScreen()),
    );

void main() {
  const successfulResult = ZatcaSubmissionResult(
    success: true,
    message: 'Device successfully onboarded with ZATCA (Simulated).',
    status: ZatcaSubmissionStatus.reported,
  );
  const rejectedResult = ZatcaSubmissionResult(
    success: false,
    message: 'Invalid OTP provided.',
    status: ZatcaSubmissionStatus.rejected,
  );

  group('ZatcaOnboardingScreen', () {
    testWidgets('does not call onboarding until the user enters an OTP',
        (tester) async {
      final service = _FakeZatcaSimulationService(result: successfulResult);

      await tester.pumpWidget(_host(service));
      await tester.tap(find.text('Simulate Onboarding'));
      await tester.pump();

      expect(service.calls, 0);
      expect(find.text('Device Onboarding'), findsOneWidget);
    });

    testWidgets('shows the active compliance state after successful onboarding',
        (tester) async {
      final service = _FakeZatcaSimulationService(result: successfulResult);

      await tester.pumpWidget(_host(service));
      await tester.enterText(find.byType(TextFormField), '123456');
      await tester.tap(find.text('Simulate Onboarding'));
      await tester.pumpAndSettle();

      expect(service.calls, 1);
      expect(service.lastOtp, '123456');
      expect(find.text('Device Onboarded!'), findsOneWidget);
      expect(find.text('Compliance Status:'), findsOneWidget);
      expect(find.text('Active'), findsOneWidget);
      expect(
        find.text('Device successfully onboarded with ZATCA (Simulated).'),
        findsOneWidget,
      );
    });

    testWidgets('keeps the form and explains a rejected onboarding request',
        (tester) async {
      final service = _FakeZatcaSimulationService(result: rejectedResult);

      await tester.pumpWidget(_host(service));
      await tester.enterText(find.byType(TextFormField), '000000');
      await tester.tap(find.text('Simulate Onboarding'));
      await tester.pumpAndSettle();

      expect(service.lastOtp, '000000');
      expect(find.text('Device Onboarding'), findsOneWidget);
      expect(find.text('Device Onboarded!'), findsNothing);
      expect(find.text('Invalid OTP provided.'), findsOneWidget);
    });

    testWidgets('shows a recoverable message when onboarding throws',
        (tester) async {
      final service = _FakeZatcaSimulationService(
        result: successfulResult,
        shouldThrow: true,
      );

      await tester.pumpWidget(_host(service));
      await tester.enterText(find.byType(TextFormField), '654321');
      await tester.tap(find.text('Simulate Onboarding'));
      await tester.pumpAndSettle();

      expect(service.calls, 1);
      expect(find.text('Device Onboarding'), findsOneWidget);
      expect(find.textContaining('simulated ZATCA outage'), findsOneWidget);
    });
  });
}
