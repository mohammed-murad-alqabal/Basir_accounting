import 'dart:async';

import 'package:isar/isar.dart';

/// Prepares native Isar support before each Flutter test isolate invokes its
/// test entrypoint. Individual suites may open isolated databases afterwards.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  await Isar.initializeIsarCore(download: true);
  await testMain();
}
