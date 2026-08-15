import 'dart:async';

import 'package:basir_accounting_system/features/forensics/application/forensic_portal_service.dart';
import 'package:basir_accounting_system/features/forensics/domain/entities/integrity_pulse.dart';
import 'package:basir_accounting_system/features/forensics/presentation/screens/forensic_portal_screen.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final healthyPulse = IntegrityPulse(
    isHealthy: true,
    lastVerifiedHash: '0xabc123',
    lastVerifiedAt: DateTime(2026, 8, 15, 10, 30),
    totalBlocksScanned: 42,
    healthPercentage: 100,
  );

  final blocks = [
    LedgerBlock(
      entryId: 'entry-1',
      referenceNumber: 'JE-001',
      date: DateTime(2026, 8, 14),
      hash: '0xhash-one',
      previousHash: null,
      isVerified: true,
      agentSignature: 'Agent-A',
    ),
    LedgerBlock(
      entryId: 'entry-2',
      referenceNumber: 'JE-002',
      date: DateTime(2026, 8, 15),
      hash: null,
      previousHash: '0xhash-one',
      isVerified: true,
      agentSignature: 'Agent-B',
    ),
  ];

  Widget buildPortal({
    required IntegrityPulse pulse,
    required Future<List<LedgerBlock>> Function() loadBlocks,
  }) => ProviderScope(
    overrides: [
      forensicPortalNotifierProvider.overrideWith(
        () => _FixedForensicPortalNotifier(pulse),
      ),
      ledgerBlocksProvider.overrideWith((ref) => loadBlocks()),
    ],
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('ar'),
      routes: {
        '/fiscal-control-center': (context) => const Scaffold(
          body: Center(child: Text('وصلت إلى إدارة الدورة المالية')),
        ),
      },
      home: const ForensicPortalScreen(),
    ),
  );

  group('ForensicPortalScreen', () {
    testWidgets('يعرض نبض السلامة وكتل السجل ثم ينتقل للضبط الإداري', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildPortal(pulse: healthyPulse, loadBlocks: () async => blocks),
      );
      await tester.pumpAndSettle();

      expect(find.text('HASH: 0xabc123'), findsOneWidget);
      expect(find.text('100.0%'), findsOneWidget);
      expect(find.text('#JE-001'), findsOneWidget);
      expect(find.text('#JE-002'), findsOneWidget);
      expect(find.textContaining('Agent-A'), findsOneWidget);
      expect(find.text('N/A'), findsOneWidget);

      await tester.tap(find.text('Fiscal Cycle Management'));
      await tester.pumpAndSettle();

      expect(find.text('وصلت إلى إدارة الدورة المالية'), findsOneWidget);
    });

    testWidgets('يعرض خطأ سجل الكتل مع بقاء بطاقة النبض متاحة', (tester) async {
      await tester.pumpWidget(
        buildPortal(
          pulse: healthyPulse,
          loadBlocks: () => Future<List<LedgerBlock>>.error(
            StateError('تعذر تحميل السجل'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('HASH: 0xabc123'), findsOneWidget);
      expect(find.textContaining('تعذر تحميل السجل'), findsOneWidget);
    });
  });
}

class _FixedForensicPortalNotifier extends ForensicPortalNotifier {
  _FixedForensicPortalNotifier(this._pulse);

  final IntegrityPulse _pulse;

  @override
  FutureOr<IntegrityPulse> build() => _pulse;
}
