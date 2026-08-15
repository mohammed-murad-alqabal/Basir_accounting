import 'package:basir_accounting_system/core/theme/glass_theme.dart';
import 'package:basir_accounting_system/features/accounting/application/orchestrator_service.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/accounting_agent.dart';
import 'package:basir_accounting_system/features/accounting/presentation/widgets/consensus_report_overlay.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildOverlay({
    required AgentConsensus consensus,
    required VoidCallback onConfirm,
    required VoidCallback onCancel,
  }) => MaterialApp(
    theme: ThemeData.dark().copyWith(extensions: [GlassTheme.dark()]),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('ar'),
    home: ConsensusReportOverlay(
      consensus: consensus,
      onConfirm: onConfirm,
      onCancel: onCancel,
    ),
  );

  AgentConsensus consensus({
    required bool approved,
    required List<AgentResult> results,
    Map<String, dynamic>? adjustments,
  }) => AgentConsensus(
    isApproved: approved,
    explanation: 'تقرير تدقيق تجريبي',
    agentResults: results,
    suggestedAdjustments: adjustments,
    orchestrationTimestamp: DateTime(2026, 8, 15),
  );

  group('ConsensusReportOverlay', () {
    testWidgets('يعرض الإجماع المعتمد والتوصية وينفذ التأكيد', (tester) async {
      var confirmations = 0;
      var cancellations = 0;

      await tester.pumpWidget(
        buildOverlay(
          consensus: consensus(
            approved: true,
            results: const [
              AgentResult(
                agentId: 'agent-tax',
                isAllowed: true,
                rationale: 'تمت مطابقة الضوابط الضريبية.',
                confidenceScore: 0.97,
              ),
            ],
            adjustments: {
              'tax': {
                'title': 'تصحيح ضريبة مقترح',
                'reason': 'مراجعة معدل الضريبة',
                'suggestedAmount': '150.00',
              },
            },
          ),
          onConfirm: () => confirmations++,
          onCancel: () => cancellations++,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Consensus Approved'), findsOneWidget);
      expect(find.text('TAX'), findsOneWidget);
      expect(find.text('97% CONFIDENCE'), findsOneWidget);
      expect(find.text('تمت مطابقة الضوابط الضريبية.'), findsOneWidget);
      expect(find.text('تصحيح ضريبة مقترح'), findsOneWidget);
      expect(find.text('مراجعة معدل الضريبة'), findsOneWidget);
      expect(find.textContaining('150.00'), findsOneWidget);

      await tester.tap(find.text('Post Transaction'));
      expect(confirmations, 1);
      expect(cancellations, 0);
    });

    testWidgets('يعرض الاعتراض ويستدعي الإلغاء', (tester) async {
      var cancellations = 0;

      await tester.pumpWidget(
        buildOverlay(
          consensus: consensus(
            approved: false,
            results: const [
              AgentResult(
                agentId: 'agent-forensic',
                isAllowed: false,
                rationale: 'تعارض في تسلسل السجل.',
                confidenceScore: 0.41,
              ),
            ],
          ),
          onConfirm: () {},
          onCancel: () => cancellations++,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Consensus Rejected'), findsOneWidget);
      expect(find.text('FORENSIC'), findsOneWidget);
      expect(find.text('41% CONFIDENCE'), findsOneWidget);
      expect(find.text('Override & Post'), findsOneWidget);

      await tester.tap(find.text('Cancel'));
      expect(cancellations, 1);
    });

    testWidgets('يبني تقريراً قابلاً للإغلاق عندما لا تعيد الوكالات نتائج', (
      tester,
    ) async {
      var cancellations = 0;

      await tester.pumpWidget(
        buildOverlay(
          consensus: consensus(approved: true, results: const []),
          onConfirm: () {},
          onCancel: () => cancellations++,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Consensus Approved'), findsOneWidget);
      expect(find.text('Post Transaction'), findsOneWidget);
      expect(find.textContaining('CONFIDENCE'), findsNothing);

      await tester.tap(find.text('Cancel'));
      expect(cancellations, 1);
    });
  });
}
