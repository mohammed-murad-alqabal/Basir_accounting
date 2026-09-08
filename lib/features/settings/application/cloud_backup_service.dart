import 'dart:async';
import 'dart:io';

import 'package:basir_accounting_system/core/providers.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cloud_backup_service.g.dart';

/// خدمة النسخ الاحتياطي السحابي والمزامنة مع Google Drive.
@riverpod
class CloudBackupService extends _$CloudBackupService {
  late final GoogleSignIn _googleSignIn;
  GoogleSignInAccount? _currentUser;
  StreamSubscription<GoogleSignInAuthenticationEvent>? _sub;

  @override
  FutureOr<void> build() {
    _googleSignIn = ref.watch(googleSignInProvider);

    // Track user state via authenticationEvents (v7 pattern)
    _sub = _googleSignIn.authenticationEvents.listen((event) {
      if (event is GoogleSignInAuthenticationEventSignIn) {
        _currentUser = event.account;
      } else if (event is GoogleSignInAuthenticationEventSignOut) {
        _currentUser = null;
      }
    });

    ref.onDispose(() async {
      await _sub?.cancel();
    });
  }

  /// تحميل نسخة احتياطية من Drive
  Future<bool> downloadBackup(String fileId, String destinationPath) async {
    try {
      if (!isSignedIn || _currentUser == null) return false;

      final authorization = await _currentUser!.authorizationClient
          .authorizationForScopes([drive.DriveApi.driveFileScope]);
      if (authorization == null) return false;

      final client = authorization.authClient(
        scopes: [drive.DriveApi.driveFileScope],
      );

      final driveApi = drive.DriveApi(client);

      debugPrint('📥 [BACKUP] Downloading $fileId from Google Drive...');
      final media = await driveApi.files.get(
        fileId,
        downloadOptions: drive.DownloadOptions.fullMedia,
      ) as drive.Media;

      final file = File(destinationPath);
      final iosSink = file.openWrite();

      await media.stream.pipe(iosSink);
      await iosSink.close();

      return true;
    } on Exception catch (e) {
      debugPrint('❌ [BACKUP] Download Error: $e');
      return false;
    }
  }

  /// استعادة نسخة احتياطية من Drive (تتطلب إعادة تشغيل التطبيق)
  Future<bool> restoreFromDrive(String fileId) async {
    try {
      if (!isSignedIn || _currentUser == null) return false;

      final appDocDir = await getApplicationDocumentsDirectory();
      // Isar 3 name convention: [name].isar
      final restorePath = '${appDocDir.path}/basir_db.isar.restore';

      final success = await downloadBackup(fileId, restorePath);
      if (success) {
        debugPrint('✅ [BACKUP] Restore file staged at: $restorePath');
        debugPrint('ℹ️ [BACKUP] Application restart required to apply.');
        return true;
      }
      return false;
    } on Exception catch (e) {
      debugPrint('❌ [BACKUP] Restore Error: $e');
      return false;
    }
  }

  /// تسجيل الدخول إلى Google Drive
  Future<GoogleSignInAccount?> signIn() async {
    try {
      // Use authenticate() for interactive sign-in in v7
      final account = await _googleSignIn.authenticate();
      _currentUser = account;
      return account;
    } on Object catch (e) {
      debugPrint('❌ [BACKUP] Google Sign-In Error: $e');
      return null;
    }
  }

  /// تسجيل الخروج
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    _currentUser = null;
  }

  /// الحصول على حالة تسجيل الدخول
  bool get isSignedIn => _currentUser != null;

  /// الحصول على بريد المستخدم الحالي
  String? get userEmail => _currentUser?.email;

  /// فحص توفر الاتصال بـ Google Drive
  Future<bool> checkConnection() async {
    try {
      if (!isSignedIn || _currentUser == null) return false;

      final authorization = await _currentUser!.authorizationClient
          .authorizationForScopes([drive.DriveApi.driveFileScope]);
      if (authorization == null) return false;

      final client = authorization.authClient(
        scopes: [drive.DriveApi.driveFileScope],
      );

      final response = await client.get(
        Uri.parse('https://www.googleapis.com/drive/v3/about?fields=user'),
      );

      return response.statusCode == 200;
    } on Exception catch (e) {
      debugPrint('❌ [BACKUP] Connection Check Error: $e');
      return false;
    }
  }

  /// إنشاء نسخة احتياطية محلية
  Future<File?> createLocalBackup() async {
    try {
      final isarAsync = ref.read(isarProvider);
      final isar = isarAsync.value;
      if (isar == null) {
        debugPrint('❌ [BACKUP] Database not ready');
        return null;
      }

      final appDocDir = await getApplicationDocumentsDirectory();
      final backupPath = '${appDocDir.path}/backups';
      final directory = Directory(backupPath);
      // ignore: avoid_slow_async_io
      if (!await directory.exists()) {
        // ignore: avoid_slow_async_io
        await directory.create(recursive: true);
      }

      final fileName = 'backup_${DateTime.now().microsecondsSinceEpoch}.db';
      final backupFile = File('$backupPath/$fileName');

      // استخدام copyToFile لتصدير نسخة آمنة من قاعدة البيانات
      await isar.copyToFile(backupFile.path);

      debugPrint('💾 [BACKUP] Database exported to: ${backupFile.path}');
      return backupFile;
    } on Exception catch (e) {
      debugPrint('❌ [BACKUP] Local Backup Error: $e');
      return null;
    }
  }

  /// مزامنة البيانات إلى Drive
  Future<bool> uploadToDrive() async {
    try {
      if (!isSignedIn) {
        final account = await signIn();
        if (account == null) return false;
      }

      if (_currentUser == null) return false;

      final authorization = await _currentUser!.authorizationClient
          .authorizationForScopes([drive.DriveApi.driveFileScope]);
      if (authorization == null) return false;

      final client = authorization.authClient(
        scopes: [drive.DriveApi.driveFileScope],
      );

      final driveApi = drive.DriveApi(client);

      // 1. البحث عن مجلد التطبيق أو إنشاؤه
      final folderId = await _getOrCreateBackupFolder(driveApi);
      if (folderId == null) return false;

      // 2. إنشاء النسخة المحلية للمزامنة
      final localBackup = await createLocalBackup();
      if (localBackup == null) return false;

      // 3. رفع الملف إلى Google Drive
      final driveFile = drive.File()
        ..name = localBackup.path.split('/').last
        ..parents = [folderId];

      final media = drive.Media(
        localBackup.openRead(),
        await localBackup.length(),
      );

      debugPrint('📤 [BACKUP] Uploading to Google Drive...');
      await driveApi.files.create(driveFile, uploadMedia: media);

      return true;
    } on Exception catch (e) {
      debugPrint('❌ [BACKUP] Sync Error: $e');
      return false;
    }
  }

  /// الحصول على قائمة الملفات من Drive
  Future<List<Map<String, String>>> listBackups() async {
    try {
      if (!isSignedIn || _currentUser == null) return [];

      final authorization = await _currentUser!.authorizationClient
          .authorizationForScopes([drive.DriveApi.driveFileScope]);
      if (authorization == null) return [];

      final client = authorization.authClient(
        scopes: [drive.DriveApi.driveFileScope],
      );

      final driveApi = drive.DriveApi(client);
      final folderId = await _findBackupFolder(driveApi);
      if (folderId == null) return [];

      final fileList = await driveApi.files.list(
        q: "'$folderId' in parents and trashed = false",
        $fields: 'files(id, name, createdTime)',
      );

      final files = fileList.files;
      if (files == null) return [];

      return files
          .map(
            (f) => {
              'id': f.id ?? '',
              'name': f.name ?? '',
              'date': f.createdTime?.toIso8601String() ?? '',
            },
          )
          .toList();
    } on Exception catch (e) {
      debugPrint('❌ [BACKUP] List Error: $e');
      return [];
    }
  }

  // --- Drive Helpers ---

  Future<String?> _getOrCreateBackupFolder(drive.DriveApi api) async {
    final existingId = await _findBackupFolder(api);
    if (existingId != null) return existingId;

    final folder = drive.File()
      ..name = 'Basir Backups'
      ..mimeType = 'application/vnd.google-apps.folder';

    final createdFolder = await api.files.create(folder);
    return createdFolder.id;
  }

  Future<String?> _findBackupFolder(drive.DriveApi api) async {
    final list = await api.files.list(
      q: "name = 'Basir Backups' and "
          "mimeType = 'application/vnd.google-apps.folder' and "
          'trashed = false',
    );
    if (list.files?.isNotEmpty ?? false) {
      return list.files!.first.id;
    }
    return null;
  }
}

extension on GoogleSignInAuthenticationEventSignIn {
  GoogleSignInAccount? get account => user;
}
