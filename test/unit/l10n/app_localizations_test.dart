import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<AppLocalizations> load(String languageCode) =>
      AppLocalizations.delegate.load(Locale(languageCode));

  group('AppLocalizations', () {
    test('يدعم مفوض التعريب العربية والإنجليزية فقط', () {
      expect(AppLocalizations.delegate.isSupported(const Locale('ar')), isTrue);
      expect(AppLocalizations.delegate.isSupported(const Locale('en')), isTrue);
      expect(
        AppLocalizations.delegate.isSupported(const Locale('fr')),
        isFalse,
      );
      expect(
        AppLocalizations.supportedLocales,
        const [Locale('ar'), Locale('en')],
      );
    });

    test('يعرض العقد المحاسبي الأساسي بالعربية', () async {
      final ar = await load('ar');

      expect(ar.appTitle, 'بصير');
      expect(ar.labelCurrency, 'العملة');
      expect(ar.labelAddCurrency, 'إضافة عملة');
      expect(ar.labelAccountCode, 'رقم الحساب');
      expect(ar.labelAccountName, 'اسم الحساب');
      expect(ar.labelTotalAmount, 'الإجمالي');
      expect(ar.msgBalanceBalancedTB, contains('متزن'));
      expect(ar.msgBalanceUnbalancedTB, contains('غير متزن'));
      expect(ar.sectionBasicReports, 'التقارير الأساسية');
      expect(ar.labelGeneralLedger, 'دفتر الأستاذ');
      expect(ar.labelTaxTotal, 'إجمالي الضريبة');
      expect(ar.labelVatRate, 'نسبة الضريبة');
      expect(ar.zatcaComplianceText, contains('هيئة الزكاة'));
      expect(ar.journalEntryFormTitleAdd, 'إضافة قيد يدوي');
      expect(ar.invoiceFormTitleAdd, 'إضافة فاتورة جديدة');
      expect(ar.dialogTaxTitle, 'نسبة الضريبة');
      expect(ar.labelInvoiceItems, 'بنود الفاتورة');
      expect(ar.labelGrandTotal, 'الإجمالي الكلي:');
      expect(ar.errNoItems, 'يرجى إضافة بند واحد على الأقل');
    });

    test('يستبدل معاملات الرسائل العربية ويحافظ على المدخل', () async {
      final ar = await load('ar');

      expect(ar.errGeneric('رمز-42'), 'حدث خطأ: رمز-42');
      expect(
        ar.msgConfirmDeleteVendor('مورد الاختبار'),
        contains('مورد الاختبار'),
      );
      expect(ar.invoiceTitle('INV-2025-001'), contains('INV-2025-001'));
      expect(ar.errLoadCustomers('انقطاع الشبكة'), contains('انقطاع الشبكة'));
    });

    test('يعرض عقد الفاتورة والتقارير بالإنجليزية مع المعاملات', () async {
      final en = await load('en');

      expect(en.appTitle, 'Basir');
      expect(en.labelCurrency, 'Currency');
      expect(en.labelAddCurrency, 'Add Currency');
      expect(en.labelAccountCode, 'Account Code');
      expect(en.labelAccountName, 'Account Name');
      expect(en.labelTotalAmount, 'Total Amount');
      expect(en.msgBalanceBalancedTB, contains('balanced'));
      expect(en.msgBalanceUnbalancedTB, contains('unbalanced'));
      expect(en.sectionBasicReports, 'Basic Reports');
      expect(en.labelGeneralLedger, 'General Ledger');
      expect(en.labelTaxTotal, 'Total Tax');
      expect(en.labelVatRate, 'VAT Rate');
      expect(en.zatcaComplianceText, contains('ZATCA'));
      expect(en.journalEntryFormTitleAdd, 'Add Manual Journal Entry');
      expect(en.invoiceFormTitleAdd, 'Add New Invoice');
      expect(en.dialogTaxTitle, 'Tax Rate');
      expect(en.labelInvoiceItems, 'Invoice Items');
      expect(en.labelGrandTotal, 'Grand Total:');
      expect(en.errNoItems, 'Please add at least one item');
      expect(en.errGeneric('ERR-42'), 'Error occurred: ERR-42');
      expect(en.msgConfirmDeleteVendor('Test Vendor'), contains('Test Vendor'));
      expect(en.invoiceTitle('INV-2025-001'), contains('INV-2025-001'));
      expect(en.errLoadCustomers('offline'), contains('offline'));
    });
  });
}
