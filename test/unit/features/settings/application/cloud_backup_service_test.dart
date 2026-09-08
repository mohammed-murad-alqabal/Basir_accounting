import 'package:basir_accounting_system/features/settings/application/cloud_backup_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'يرفض عمليات Drive بأمان دون جلسة Google ولا يعرّض بيانات النسخ المحلية',
    () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final service = container.read(cloudBackupServiceProvider.notifier);
      await container.read(cloudBackupServiceProvider.future);

      expect(service.isSignedIn, isFalse);
      expect(service.userEmail, isNull);
      expect(
        await service.downloadBackup('backup-private', '/tmp/backup.db'),
        isFalse,
      );
      expect(await service.checkConnection(), isFalse);
      expect(await service.listBackups(), isEmpty);
      expect(await service.restoreFromDrive('backup-private'), isFalse);
    },
  );

  test(
    'يتعافى من غياب منصة تسجيل Google عند طلب الرفع',
    () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final service = container.read(cloudBackupServiceProvider.notifier);
      await container.read(cloudBackupServiceProvider.future);

      expect(await service.uploadToDrive(), isFalse);
      expect(service.isSignedIn, isFalse);
    },
  );
}
