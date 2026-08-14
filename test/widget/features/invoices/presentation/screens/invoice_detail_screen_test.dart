/// اختبارات السلوك المرئي لتفاصيل الفاتورة.
library;

import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/core/theme/tokens/app_icons.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice_status.dart';
import 'package:basir_accounting_system/features/invoices/presentation/screens/invoice_detail_screen.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:basir_accounting_system/shared/widgets/app_qr_code.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../fixtures/invoice_fixtures.dart';

class _GregorianCalendarNotifier extends CalendarNotifier {
  @override
  Future<CalendarType> build() async => CalendarType.gregorian;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final platformCalls = <MethodCall>[];

  setUp(() {
    platformCalls.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (methodCall) async {
      platformCalls.add(methodCall);
      return null;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, null);
  });

  Widget testApp({required Invoice invoice}) => ProviderScope(
        overrides: [
          appIconsProvider.overrideWithValue(const MaterialAppIcons()),
          calendarProvider.overrideWith(_GregorianCalendarNotifier.new),
          basirUserProvider.overrideWith((ref) => null),
        ],
        child: MaterialApp(
          locale: const Locale('ar'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: InvoiceDetailScreen(invoice: invoice),
        ),
      );

  Finder appBarActions() => find.descendant(
        of: find.byType(AppBar),
        matching: find.byType(IconButton),
      );

  testWidgets('يعرض المسودة وبنودها وإجمالياتها مع إجراء التعديل فقط', (
    tester,
  ) async {
    await tester.pumpWidget(testApp(invoice: InvoiceFixtures.invoice1));
    await tester.pumpAndSettle();

    expect(find.textContaining('INV-001'), findsOneWidget);
    expect(find.text(InvoiceFixtures.invoice1.customerName), findsOneWidget);
    expect(find.text('خدمة استشارية'), findsOneWidget);
    expect(find.textContaining('ر.س'), findsWidgets);
    expect(appBarActions(), findsNWidgets(5));
  });

  testWidgets('يعرض بيانات السداد والعملة الأجنبية والامتثال للفواتير المدفوعة',
      (
    tester,
  ) async {
    final foreignPaidInvoice = InvoiceFixtures.invoice3.copyWith(
      currency: 'USD',
      exchangeRate: Decimal.parse('3.75'),
      discountAmount: Decimal.parse('25'),
      paidDate: DateTime(2025, 11, 16),
      qrCode: 'basir-test-qr',
      zatcaUuid: 'ZATCA-UUID-PAID-001',
      zatcaHash: 'ZATCA-HASH-PAID-001',
    );

    await tester.pumpWidget(testApp(invoice: foreignPaidInvoice));
    await tester.pumpAndSettle();

    expect(find.text('USD'), findsOneWidget);
    expect(find.byType(AppQrCode), findsOneWidget);
    expect(find.text('ZATCA-UUID-PAID-001'), findsOneWidget);
    expect(find.text('ZATCA-HASH-PAID-001'), findsOneWidget);

    final uuid = find.text('ZATCA-UUID-PAID-001');
    await tester.ensureVisible(uuid);
    await tester.tap(uuid);
    await tester.pumpAndSettle();

    expect(
      platformCalls.where((call) => call.method == 'Clipboard.setData'),
      hasLength(1),
    );
    expect(find.text('تم نسخ القيمة إلى الحافظة'), findsOneWidget);
  });

  testWidgets('يعرض حوار التأكيد قبل عكس فاتورة مرسلة ويلغيه دون تعديل', (
    tester,
  ) async {
    final sentInvoice = InvoiceFixtures.invoice2.copyWith(
      status: InvoiceStatus.sent,
    );
    await tester.pumpWidget(testApp(invoice: sentInvoice));
    await tester.pumpAndSettle();

    expect(appBarActions(), findsNWidgets(5));
    await tester.tap(appBarActions().at(4));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
    await tester.tap(
      find
          .descendant(
            of: find.byType(AlertDialog),
            matching: find.byType(TextButton),
          )
          .first,
    );
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
  });
}
