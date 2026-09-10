import 'package:drift/drift.dart';
import 'package:drift/native.dart';

/// Fallback آمن لأدوات Dart VM مثل snapshot runner.
/// لا يُستخدم كمسار تخزين إنتاجي دائم؛ التطبيق يمرر executor أو يستخدم Flutter path.
QueryExecutor openBasirConnection() => NativeDatabase.memory();
