/// اختبارات عقد النصوص المولدة المعروضة للمستخدم.
library;

import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _LocalizationProbe extends StatelessWidget {
  const _LocalizationProbe({required this.onTexts});

  final ValueChanged<List<String>> onTexts;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final texts = [
      l10n.appTitle,
      l10n.labelStandard,
      l10n.labelRecognitionBasis,
      l10n.labelMeasurementBasis,
      l10n.labelCurrency,
      l10n.labelAddCurrency,
      l10n.labelPartner,
      l10n.labelAccountCode,
      l10n.labelAccountName,
      l10n.labelFairValueAdjustment,
      l10n.subtitleFairValueAdjustment,
      l10n.labelTotalAmount,
      l10n.msgBalanceBalancedTB,
      l10n.msgBalanceUnbalancedTB,
      l10n.sectionBasicReports,
      l10n.sectionFinancialStatements,
      l10n.sectionAgingAnalysis,
      l10n.receivablesAgingTitle,
      l10n.payablesAgingTitle,
      l10n.labelGeneralLedger,
      l10n.labelPeriod,
      l10n.msgNoTransactionsFound,
      l10n.msgExportComingSoon,
      l10n.appearanceTitle,
      l10n.companySettingsTitle,
      l10n.errContactAccess('network'),
      l10n.errCustomerAdd,
      l10n.errCustomerDelete,
      l10n.errCustomerNameLength,
      l10n.errCustomerNameRequired,
      l10n.errCustomerUpdate,
      l10n.errEmptyField,
      l10n.errGeneric('network'),
      l10n.errInvalidEmail,
      l10n.errInvalidNumber,
      l10n.errInvoiceAdd,
      l10n.errInvoiceUpdate,
      l10n.errLoadCustomers('network'),
      l10n.errLoginFailed,
      l10n.errNoItems,
      l10n.errPasswordShort,
      l10n.errPasswordsDoNotMatch,
      l10n.errPhoneLength,
      l10n.errPhoneStart05,
      l10n.errSelectCustomer,
      l10n.errUsernameShort,
      l10n.errorCustomerNotFound,
      l10n.errorCustomerPhone,
      l10n.errorLoadingInvoices,
      l10n.errorLoadingSettings,
      l10n.errorScreenNotFound('ledger'),
      l10n.errorSharePdf('network'),
      l10n.errorShareWhatsapp('network'),
      l10n.filterAll,
      l10n.filterDraft,
      l10n.filterIssued,
      l10n.filterOverdue,
      l10n.filterPaid,
      l10n.fontCairo,
      l10n.fontRoboto,
      l10n.fontSettingsTitle,
      l10n.fontSizeLabel,
      l10n.taxConfigTitle,
      l10n.zatcaPhase2Title,
      l10n.zatcaPhase2Description,
    ];
    onTexts(texts);
    return ListView(children: texts.map(Text.new).toList());
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<List<String>> pumpLocalization(
    WidgetTester tester,
    Locale locale,
  ) async {
    var renderedTexts = <String>[];
    await tester.pumpWidget(
      MaterialApp(
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: _LocalizationProbe(onTexts: (texts) => renderedTexts = texts),
      ),
    );
    await tester.pumpAndSettle();
    return renderedTexts;
  }

  group('AppLocalizations contract', () {
    testWidgets('يعرض النصوص العامة المطلوبة باللغة العربية', (tester) async {
      final texts = await pumpLocalization(tester, const Locale('ar'));

      expect(texts, hasLength(65));
      expect(texts.every((text) => text.trim().isNotEmpty), isTrue);
      expect(texts, contains('بصير'));
    });

    testWidgets('يعرض النصوص العامة المطلوبة باللغة الإنجليزية',
        (tester) async {
      final texts = await pumpLocalization(tester, const Locale('en'));

      expect(texts, hasLength(65));
      expect(texts.every((text) => text.trim().isNotEmpty), isTrue);
      expect(texts, contains('Basir'));
    });

    test('يسجل مفوض الترجمة العربية والإنجليزية فقط كلغات مدعومة', () {
      expect(AppLocalizations.supportedLocales,
          const [Locale('ar'), Locale('en')]);
      expect(AppLocalizations.localizationsDelegates, hasLength(4));
    });
  });
}
