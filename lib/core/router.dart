import 'package:basir_accounting_system/core/extensions/context_extensions.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/account.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/financial_voucher.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/financial_year.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/journal_entry.dart';
import 'package:basir_accounting_system/features/accounting/presentation/screens/account_form_screen.dart';
import 'package:basir_accounting_system/features/accounting/presentation/screens/aging_reports_screen.dart';
import 'package:basir_accounting_system/features/accounting/presentation/screens/balance_sheet_screen.dart';
import 'package:basir_accounting_system/features/accounting/presentation/screens/cash_flow_screen.dart';
import 'package:basir_accounting_system/features/accounting/presentation/screens/cash_reconciliation_screen.dart';
import 'package:basir_accounting_system/features/accounting/presentation/screens/chart_of_accounts_screen.dart';
import 'package:basir_accounting_system/features/accounting/presentation/screens/entity_transactions_screen.dart';
import 'package:basir_accounting_system/features/accounting/presentation/screens/financial_calculator_screen.dart';
import 'package:basir_accounting_system/features/accounting/presentation/screens/financial_year_form_screen.dart';
import 'package:basir_accounting_system/features/accounting/presentation/screens/fiscal_control_center_screen.dart';
import 'package:basir_accounting_system/features/accounting/presentation/screens/income_statement_screen.dart';
import 'package:basir_accounting_system/features/accounting/presentation/screens/journal_entries_screen.dart';
import 'package:basir_accounting_system/features/accounting/presentation/screens/journal_entry_detail_screen.dart';
import 'package:basir_accounting_system/features/accounting/presentation/screens/journal_entry_form_screen.dart';
import 'package:basir_accounting_system/features/accounting/presentation/screens/reports_screen.dart';
import 'package:basir_accounting_system/features/accounting/presentation/screens/strategic_outlook_screen.dart';
import 'package:basir_accounting_system/features/accounting/presentation/screens/treasury_dashboard_screen.dart';
import 'package:basir_accounting_system/features/accounting/presentation/screens/trial_balance_screen.dart';
import 'package:basir_accounting_system/features/accounting/presentation/screens/voucher_form_screen.dart';
import 'package:basir_accounting_system/features/accounting/presentation/screens/voucher_list_screen.dart';
import 'package:basir_accounting_system/features/assets/presentation/screens/asset_form_screen.dart';
import 'package:basir_accounting_system/features/assets/presentation/screens/assets_screen.dart';
import 'package:basir_accounting_system/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:basir_accounting_system/features/auth/presentation/screens/guest_upgrade_screen.dart';
import 'package:basir_accounting_system/features/auth/presentation/screens/login_screen.dart';
import 'package:basir_accounting_system/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:basir_accounting_system/features/auth/presentation/screens/setup_screen.dart';
import 'package:basir_accounting_system/features/customers/domain/entities/customer.dart';
import 'package:basir_accounting_system/features/customers/presentation/screens/customer_details_screen.dart';
import 'package:basir_accounting_system/features/customers/presentation/screens/customer_form_screen.dart';
import 'package:basir_accounting_system/features/customers/presentation/screens/customers_screen.dart';
import 'package:basir_accounting_system/features/dashboard/presentation/screens/main_shell.dart';
import 'package:basir_accounting_system/features/expenses/presentation/screens/expense_form_screen.dart';
import 'package:basir_accounting_system/features/expenses/presentation/screens/expenses_dashboard_screen.dart';
import 'package:basir_accounting_system/features/forensics/presentation/screens/forensic_portal_screen.dart';
import 'package:basir_accounting_system/features/inventory/presentation/screens/barcode_creation_screen.dart';
import 'package:basir_accounting_system/features/inventory/presentation/screens/inventory_item_form_screen.dart';
import 'package:basir_accounting_system/features/inventory/presentation/screens/inventory_items_screen.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice.dart';
import 'package:basir_accounting_system/features/invoices/presentation/screens/invoice_detail_screen.dart';
import 'package:basir_accounting_system/features/invoices/presentation/screens/invoice_form_screen.dart';
import 'package:basir_accounting_system/features/invoices/presentation/screens/invoices_screen.dart';
import 'package:basir_accounting_system/features/invoices/presentation/screens/returns_and_damages_screen.dart';
import 'package:basir_accounting_system/features/reports/presentation/screens/audit_trail_report_screen.dart';
import 'package:basir_accounting_system/features/reports/presentation/screens/financial_report_screen.dart';
import 'package:basir_accounting_system/features/reports/presentation/screens/general_ledger_screen.dart';
import 'package:basir_accounting_system/features/reports/presentation/screens/intelligence_screen.dart';
import 'package:basir_accounting_system/features/reports/presentation/screens/reports_dashboard_screen.dart';
import 'package:basir_accounting_system/features/reports/presentation/screens/smart_tax_report_screen.dart';
import 'package:basir_accounting_system/features/settings/presentation/screens/barcode_settings_screen.dart';
import 'package:basir_accounting_system/features/settings/presentation/screens/cloud_backup_screen.dart';
import 'package:basir_accounting_system/features/settings/presentation/screens/excel_import_screen.dart';
import 'package:basir_accounting_system/features/settings/presentation/screens/settings_screen.dart';
import 'package:basir_accounting_system/features/users/domain/entities/user.dart';
import 'package:basir_accounting_system/features/users/presentation/screens/user_form_screen.dart';
import 'package:basir_accounting_system/features/users/presentation/screens/users_dashboard_screen.dart';
import 'package:basir_accounting_system/features/vendors/presentation/screens/vendor_form_screen.dart';
import 'package:basir_accounting_system/features/vendors/presentation/screens/vendors_screen.dart';
import 'package:basir_accounting_system/features/zatca/presentation/screens/zatca_onboarding_screen.dart';
import 'package:flutter/material.dart';

/// نظام التوجيه للتطبيق
///
/// يدير التنقل بين جميع شاشات التطبيق باستخدام Named Routes
/// ويوفر معالجة مركزية لجميع المسارات
///
/// Example:
/// ```dart
/// MaterialApp(
///   onGenerateRoute: AppRouter.generateRoute,
///   initialRoute: '/setup',
/// )
/// ```
class AppRouter {
  /// توليد المسار المناسب بناءً على الاسم
  ///
  /// يستقبل [RouteSettings] ويعيد [Route] المناسب للشاشة المطلوبة
  ///
  /// Parameters:
  /// - [settings]: إعدادات المسار تحتوي على اسم المسار والمعاملات
  ///
  /// Returns: [Route] للشاشة المطلوبة أو شاشة خطأ إذا لم يتم العثور على المسار
  ///
  /// المسارات المتاحة:
  /// - `/setup`: شاشة الإعداد الأولي
  /// - `/login`: شاشة تسجيل الدخول
  /// - `/dashboard`: لوحة التحكم الرئيسية
  /// - `/customers`: شاشة إدارة العملاء
  /// - `/invoices`: شاشة إدارة الفواتير
  /// - `/settings`: شاشة الإعدادات
  /// - `/button-test`: شاشة اختبار الأزرار (debug only)
  ///
  /// Example:
  /// ```dart
  /// Navigator.pushNamed(context, '/dashboard',);
  /// ```
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/setup':
        return MaterialPageRoute(builder: (_) => const SetupScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/forgot-password':
        return MaterialPageRoute(
          builder: (_) => const ForgotPasswordScreen(),
        );
      case '/reset-password':
        final args = settings.arguments as Map<String, String>?;
        final hasEmail = args?.containsKey('email') ?? false;
        final hasToken = args?.containsKey('token') ?? false;

        if (args != null && hasEmail && hasToken) {
          return MaterialPageRoute(
            builder: (_) => ResetPasswordScreen(
              email: args['email']!,
              token: args['token']!,
            ),
          );
        }
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(
              child: Text(context.l10n.errInvalidResetLink),
            ),
          ),
        );
      case '/dashboard':
        return MaterialPageRoute(builder: (_) => const MainShell());
      case '/customers':
        return MaterialPageRoute(builder: (_) => const CustomersScreen());
      case '/vendors':
        return MaterialPageRoute(builder: (_) => const VendorsScreen());
      case '/invoices':
        return MaterialPageRoute(builder: (_) => const InvoicesScreen());
      case '/invoice-form':
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => InvoiceFormScreen(
            invoice: args?['invoice'] as Invoice?,
          ),
        );
      case '/invoice-detail':
        final invoice = settings.arguments! as Invoice;
        return MaterialPageRoute(
          builder: (_) => InvoiceDetailScreen(invoice: invoice),
        );
      case '/customer-form':
        return MaterialPageRoute(builder: (_) => const CustomerFormScreen());
      case '/customer-detail':
        final customer = settings.arguments! as Customer;
        return MaterialPageRoute(
          builder: (_) => CustomerDetailsScreen(customer: customer),
        );
      case '/vendor-form':
        return MaterialPageRoute(builder: (_) => const VendorFormScreen());
      case '/settings':
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case '/inventory':
        return MaterialPageRoute(builder: (_) => const InventoryItemsScreen());
      case '/inventory-form':
        return MaterialPageRoute(
          builder: (_) => const InventoryItemFormScreen(),
        );
      case '/assets':
        return MaterialPageRoute(builder: (_) => const AssetsScreen());
      case '/asset-form':
        return MaterialPageRoute(builder: (_) => const AssetFormScreen());

      case '/returns-and-damages':
        return MaterialPageRoute(
          builder: (_) => const ReturnsAndDamagesScreen(),
        );
      case '/financial-calculator':
        return MaterialPageRoute(
          builder: (_) => const FinancialCalculatorScreen(),
        );
      case '/treasury-dashboard':
        return MaterialPageRoute(
          builder: (_) => const TreasuryDashboardScreen(),
        );
      case '/voucher-list':
        return MaterialPageRoute(builder: (_) => const VoucherListScreen());
      case '/cash-reconciliation':
        return MaterialPageRoute(
          builder: (_) => const CashReconciliationScreen(),
        );
      case '/journal-entry-detail':
        final entry = settings.arguments! as JournalEntry;
        return MaterialPageRoute(
          builder: (_) => JournalEntryDetailScreen(entry: entry),
        );
      case '/strategic-outlook':
        return MaterialPageRoute(
          builder: (_) => const StrategicOutlookScreen(),
        );
      case '/users':
        return MaterialPageRoute(builder: (_) => const UsersDashboardScreen());
      case '/user-form':
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => UserFormScreen(user: args?['user'] as User?),
        );
      case '/forensic-portal':
        return MaterialPageRoute(
          builder: (_) => const ForensicPortalScreen(),
        );
      case '/guest-upgrade':
        return MaterialPageRoute(builder: (_) => const GuestUpgradeScreen());
      case '/zatca-onboarding':
        return MaterialPageRoute(builder: (_) => const ZatcaOnboardingScreen());
      case '/fiscal-control-center':
        return MaterialPageRoute(
          builder: (_) => const FiscalControlCenterScreen(),
        );
      case '/financial-year-form':
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => FinancialYearFormScreen(
            financialYear: args?['financialYear'] as FinancialYear?,
          ),
        );
      case '/account-form':
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => AccountFormScreen(
            account: args?['account'] as Account?,
            initialParentId: args?['parentId'] as String?,
          ),
        );
      case '/expenses':
        return MaterialPageRoute(
          builder: (_) => const ExpensesDashboardScreen(),
        );
      case '/expenses/add':
        return MaterialPageRoute(
          builder: (_) => const ExpenseFormScreen(),
        );
      case '/expenses/edit':
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => ExpenseFormScreen(
            expenseId: args?['id'] as String?,
          ),
        );
      case '/excel-import':
        return MaterialPageRoute(builder: (_) => const ExcelImportScreen());
      case '/cloud-backup':
        return MaterialPageRoute(builder: (_) => const CloudBackupScreen());
      case '/barcode-creation':
        return MaterialPageRoute(builder: (_) => const BarcodeCreationScreen());
      case '/barcode-settings':
        return MaterialPageRoute(builder: (_) => const BarcodeSettingsScreen());
      case '/chart-of-accounts':
        return MaterialPageRoute(builder: (_) => const ChartOfAccountsScreen());
      case '/journal-entries':
        return MaterialPageRoute(builder: (_) => const JournalEntriesScreen());
      case '/journal-entry-form':
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => JournalEntryFormScreen(
            entry: args?['entry'] as JournalEntry?,
          ),
        );
      case '/balance-sheet':
        return MaterialPageRoute(builder: (_) => const BalanceSheetScreen());
      case '/income-statement':
        return MaterialPageRoute(builder: (_) => const IncomeStatementScreen());
      case '/cash-flow':
        return MaterialPageRoute(builder: (_) => const CashFlowScreen());
      case '/trial-balance':
        return MaterialPageRoute(builder: (_) => const TrialBalanceScreen());
      case '/aging-reports':
        return MaterialPageRoute(builder: (_) => const AgingReportsScreen());
      case '/reports':
        return MaterialPageRoute(
          builder: (_) => const ReportingOverviewScreen(),
        );
      case '/voucher-form':
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => VoucherFormScreen(
            type: args?['type'] as VoucherType? ?? VoucherType.receipt,
          ),
        );
      case '/reports-dashboard':
        return MaterialPageRoute(
          builder: (_) => const ReportsDashboardScreen(),
        );
      case '/general-ledger':
        final args = settings.arguments as Map<String, dynamic>?;
        if (args == null ||
            args['accountId'] == null ||
            args['accountName'] == null ||
            args['fromDate'] == null ||
            args['toDate'] == null) {
          return MaterialPageRoute(
            builder: (context) => Scaffold(
              body: Center(
                child: Text(
                  context.l10n.errorScreenNotFound(settings.name ?? ''),
                ),
              ),
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => GeneralLedgerScreen(
            accountId: args['accountId'] as String,
            accountName: args['accountName'] as String,
            fromDate: args['fromDate'] as DateTime,
            toDate: args['toDate'] as DateTime,
          ),
        );
      case '/financial-report':
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => FinancialReportScreen(
            reportType: args?['reportType'] as FinancialReportType? ??
                FinancialReportType.incomeStatement,
          ),
        );
      case '/audit-trail-report':
        return MaterialPageRoute(
          builder: (_) => const AuditTrailReportScreen(),
        );
      case '/smart-tax-report':
        return MaterialPageRoute(builder: (_) => const SmartTaxReportScreen());
      case '/intelligence':
        return MaterialPageRoute(builder: (_) => const IntelligenceScreen());
      case '/entity-transactions':
        final args = settings.arguments as Map<String, dynamic>?;
        if (args == null) {
          return MaterialPageRoute(
            builder: (context) => Scaffold(
              body: Center(
                child:
                    Text(context.l10n.errorScreenNotFound(settings.name ?? '')),
              ),
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => EntityTransactionsScreen(
            entityId: (args['entityId'] as String?) ?? '',
            entityName: (args['entityName'] as String?) ?? '',
            isCustomer: (args['isCustomer'] as bool?) ?? false,
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(
              child: Text(
                context.l10n.errorScreenNotFound(settings.name ?? ''),
              ),
            ),
          ),
        );
    }
  }
}
