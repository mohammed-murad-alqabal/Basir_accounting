import 'dart:async';

import 'package:isar/isar.dart';

/// Initializes native test dependencies before every Flutter test suite.
///
/// Isar's native core is not bundled with `flutter test`; enabling the
/// documented downloader makes the test environment reproducible on CI.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  await Isar.initializeIsarCore(download: true);
  await testMain();
}
