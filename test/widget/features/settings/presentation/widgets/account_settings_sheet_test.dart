import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/auth/application/auth_service.dart';
import 'package:basir_accounting_system/features/settings/presentation/widgets/account_settings_sheet.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:basir_accounting_system/shared/widgets/app_enhanced_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../mocks/mock_secure_storage.dart';

class _RecordingAuthService extends AuthService {
  _RecordingAuthService({
    required super.secureStorage,
    this.shouldFail = false,
  });

  final bool shouldFail;
  String? username;
  String? oldPassword;
  String? newPassword;

  @override
  Future<void> updateUsername(String newUsername) async {
    if (shouldFail) throw Exception('تعذر تحديث الحساب');
    username = newUsername;
  }

  @override
  Future<void> changePassword(String oldValue, String newValue) async {
    if (shouldFail) throw Exception('تعذر تحديث الحساب');
    oldPassword = oldValue;
    newPassword = newValue;
  }
}

class _SheetLauncher extends StatelessWidget {
  const _SheetLauncher({required this.username});

  final String username;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () => AccountSettingsSheet.show(context, username),
            child: const Text('فتح الإعدادات'),
          ),
        ),
      );
}

Widget _host(_RecordingAuthService auth, FlutterSecureStorage storage) =>
    ProviderScope(
      overrides: [
        secureStorageProvider.overrideWithValue(storage),
        authServiceProvider.overrideWithValue(auth),
      ],
      child: MaterialApp(
        theme: ThemeData.light(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('ar'),
        home: const _SheetLauncher(username: 'basir_admin'),
      ),
    );

Future<void> _openSheet(WidgetTester tester) async {
  await tester.tap(find.text('فتح الإعدادات'));
  await tester.pumpAndSettle();
}

void main() {
  group('AccountSettingsSheet', () {
    testWidgets('يعرض اسم المستخدم الحالي ويكشف حقول تغيير كلمة المرور',
        (tester) async {
      final storage = MockSecureStorage();
      final auth = _RecordingAuthService(secureStorage: storage);

      await tester.pumpWidget(_host(auth, storage));
      await _openSheet(tester);

      expect(find.byType(TextField), findsOneWidget);
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        'basir_admin',
      );
      expect(find.text('تغيير كلمة المرور'), findsOneWidget);

      await tester.tap(find.text('تغيير كلمة المرور'));
      await tester.pump();

      expect(find.byType(TextField), findsNWidgets(3));
      expect(find.text('كلمة المرور القديمة'), findsOneWidget);
    });

    testWidgets('يحفظ اسم المستخدم وكلمة المرور ثم يغلق الورقة',
        (tester) async {
      final storage = MockSecureStorage();
      final auth = _RecordingAuthService(secureStorage: storage);

      await tester.pumpWidget(_host(auth, storage));
      await _openSheet(tester);
      await tester.enterText(find.byType(TextField).first, 'basir_finance');
      await tester.tap(find.text('تغيير كلمة المرور'));
      await tester.pump();
      await tester.enterText(find.byType(TextField).at(1), 'old-secret');
      await tester.enterText(find.byType(TextField).at(2), 'new-secret');
      await tester.tap(find.byType(AppEnhancedButton));
      await tester.pumpAndSettle();

      expect(auth.username, 'basir_finance');
      expect(auth.oldPassword, 'old-secret');
      expect(auth.newPassword, 'new-secret');
      expect(find.text('فتح الإعدادات'), findsOneWidget);
      expect(find.text('تغيير كلمة المرور'), findsNothing);
    });

    testWidgets('يبقي الورقة مفتوحة ويعرض رسالة الخطأ عند فشل الحفظ',
        (tester) async {
      final storage = MockSecureStorage();
      final auth = _RecordingAuthService(
        secureStorage: storage,
        shouldFail: true,
      );

      await tester.pumpWidget(_host(auth, storage));
      await _openSheet(tester);
      await tester.enterText(find.byType(TextField), 'basir_blocked');
      await tester.tap(find.byType(AppEnhancedButton));
      await tester.pumpAndSettle();

      expect(find.textContaining('تعذر تحديث الحساب'), findsOneWidget);
      expect(find.text('تغيير كلمة المرور'), findsOneWidget);
    });
  });
}
