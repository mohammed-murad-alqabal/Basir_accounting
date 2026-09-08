import 'package:basir_accounting_system/features/forensics/application/ledger_integrity_service.dart';
import 'package:basir_accounting_system/features/forensics/domain/entities/integrity_status.dart';
import 'package:basir_accounting_system/features/forensics/presentation/screens/forensic_guardian_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildSubject(
    LedgerHealth health,
    void Function(_LedgerServiceFake) onReady,
  ) =>
      ProviderScope(
        overrides: [
          ledgerIntegrityServiceProvider.overrideWith((ref) {
            final service = _LedgerServiceFake(ref, health);
            onReady(service);
            return service;
          }),
        ],
        child: const MaterialApp(home: ForensicGuardianScreen()),
      );

  LedgerHealth health({
    required IntegrityStatus status,
    required int verifiedCount,
    required int errorCount,
    String? message,
  }) =>
      LedgerHealth(
        status: status,
        lastVerification: DateTime(2026, 8, 15),
        verifiedCount: verifiedCount,
        errorCount: errorCount,
        anomalousEntryIds: const ['journal-7'],
        message: message,
      );

  group('ForensicGuardianScreen', () {
    testWidgets('يعرض دفترًا سليمًا وإحصاءات وسلسلة كتل قابلة للمراجعة',
        (tester) async {
      await tester.pumpWidget(
        buildSubject(
          health(
            status: IntegrityStatus.healthy,
            verifiedCount: 42,
            errorCount: 0,
          ),
          (_) {},
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Forensic Guardian'), findsOneWidget);
      expect(find.text('HEALTHY'), findsOneWidget);
      expect(
        find.text('All systems operational. Ledger integrity verified.'),
        findsOneWidget,
      );
      expect(find.text('42'), findsOneWidget);
      expect(find.text('0'), findsOneWidget);
      expect(find.text('Verified Entries'), findsOneWidget);
      expect(find.text('Anomalies'), findsOneWidget);
      expect(find.text('Hash Chain Sequence'), findsOneWidget);
      expect(find.text('Block #5000'), findsOneWidget);
      expect(find.text('Block #4996'), findsOneWidget);
      expect(find.byIcon(Icons.gpp_good), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsNWidgets(5));
      expect(find.text('Execute Self-Healing Protocol'), findsNothing);
    });

    testWidgets(
        'يعرض حالة الإصلاح الذاتي وينفذها عند وجود شذوذات قابلة للمعالجة',
        (tester) async {
      late _LedgerServiceFake service;
      await tester.pumpWidget(
        buildSubject(
          health(
            status: IntegrityStatus.needsHeal,
            verifiedCount: 41,
            errorCount: 1,
            message: 'Rounding discrepancy detected in JE-7',
          ),
          (value) => service = value,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('NEEDSHEAL'), findsOneWidget);
      expect(
        find.text('Rounding discrepancy detected in JE-7'),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.gpp_maybe), findsOneWidget);
      expect(find.text('1'), findsOneWidget);

      final healingAction = find.text('Execute Self-Healing Protocol');
      await tester.ensureVisible(healingAction);
      await tester.tap(healingAction);
      await tester.pumpAndSettle();

      expect(service.healCalls, 1);
      expect(find.text('Self-healing completed successfully.'), findsOneWidget);
    });
  });
}

class _LedgerServiceFake extends LedgerIntegrityService {
  _LedgerServiceFake(super._ref, LedgerHealth initialHealth) {
    state = initialHealth;
  }

  int healCalls = 0;

  @override
  Future<void> healLedger() async {
    healCalls++;
    state = state.copyWith(message: 'Self-healing completed successfully.');
  }
}
