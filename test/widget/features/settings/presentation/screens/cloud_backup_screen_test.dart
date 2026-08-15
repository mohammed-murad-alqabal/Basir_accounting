import 'dart:async';
import 'dart:io';

import 'package:basir_accounting_system/features/settings/application/cloud_backup_service.dart';
import 'package:basir_accounting_system/features/settings/presentation/screens/cloud_backup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildSubject(_FakeCloudBackupService service) => ProviderScope(
        overrides: [
          cloudBackupServiceProvider.overrideWith(() => service),
        ],
        child: const MaterialApp(home: CloudBackupScreen()),
      );

  group('CloudBackupScreen', () {
    testWidgets('ينشئ نسخة محلية ويعرض مسارها للمستخدم', (tester) async {
      final service = _FakeCloudBackupService(
        backupFile: File('/tmp/basir-local-backup.db'),
      );
      await tester.pumpWidget(buildSubject(service));
      await tester.pump();

      await tester.tap(find.text('إنشاء نسخة احتياطية الآن'));
      await tester.pump();
      expect(service.localBackupRequests, 1);
      expect(
        find.textContaining('/tmp/basir-local-backup.db'),
        findsOneWidget,
      );
    });

    testWidgets('يعرض الحساب المربوط ويرفع النسخة ثم يغيّر الحساب',
        (tester) async {
      final service = _FakeCloudBackupService(
        signedIn: true,
        email: 'audit@basir.test',
      );
      await tester.pumpWidget(buildSubject(service));
      await tester.pump();

      await tester.tap(find.text('Google Drive'));
      await tester.pumpAndSettle();
      expect(find.text('audit@basir.test'), findsOneWidget);
      expect(find.text('مزامنة الآن إلى Google Drive'), findsOneWidget);

      await tester.tap(find.text('مزامنة الآن إلى Google Drive'));
      await tester.pump();
      expect(service.uploadRequests, 1);
      expect(find.text('تمت مزامنة البيانات بنجاح'), findsOneWidget);

      await tester.tap(find.text('تغيير الحساب'));
      await tester.pump();
      expect(service.signOutRequests, 1);
      expect(find.text('ربط حساب Google'), findsOneWidget);
    });

    testWidgets('يعطّل بدء النسخ المحلي ما دامت الخدمة في حالة تحميل',
        (tester) async {
      final service = _FakeCloudBackupService(
        delay: const Duration(milliseconds: 30),
      );
      await tester.pumpWidget(buildSubject(service));
      final button = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'إنشاء نسخة احتياطية الآن'),
      );
      expect(button.onPressed, isNull);

      await tester.pump(const Duration(milliseconds: 40));
      final enabledButton = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'إنشاء نسخة احتياطية الآن'),
      );
      expect(enabledButton.onPressed, isNotNull);
    });
  });
}

class _FakeCloudBackupService extends CloudBackupService {
  _FakeCloudBackupService({
    this.signedIn = false,
    this.email,
    this.backupFile,
    this.delay,
  });

  bool signedIn;
  final String? email;
  final File? backupFile;
  final Duration? delay;
  int localBackupRequests = 0;
  int uploadRequests = 0;
  int signOutRequests = 0;

  @override
  FutureOr<void> build() async {
    if (delay != null) await Future<void>.delayed(delay!);
  }

  @override
  bool get isSignedIn => signedIn;

  @override
  String? get userEmail => signedIn ? email : null;

  @override
  Future<File?> createLocalBackup() async {
    localBackupRequests++;
    return backupFile;
  }

  @override
  Future<bool> uploadToDrive() async {
    uploadRequests++;
    return signedIn;
  }

  @override
  Future<void> signOut() async {
    signOutRequests++;
    signedIn = false;
  }
}
