# تحقق Spike Drift المحلي

## الفحوص المنفذة

### سلامة Git
PASS: git diff --check

### عناصر Drift المطلوبة
PASS: lib/core/persistence/drift/basir_database.dart
PASS: lib/features/settings/data/repositories/drift_barcode_config_repository.dart
PASS: test/drift/drift_barcode_config_repository_test.dart
PASS: drift runtime dependency pinned
PASS: cross-platform connector dependency pinned
PASS: drift code generator dependency pinned
PASS: guided migration configuration present
PASS: foreign key enforcement configured
PASS: Web/WASM connection declared

### Web assets
PENDING: web/sqlite3.wasm
PENDING: web/drift_worker.dart.js

### SDK availability
BLOCKED: Flutter SDK unavailable in current sandbox
BLOCKED: Dart SDK unavailable in current sandbox

### Required next verification in Flutter-capable CI/local environment
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter test test/drift/drift_barcode_config_repository_test.dart
flutter build web --release

### Diff summary
 build.yaml   | 6 [32m++++++[m
 pubspec.yaml | 4 [32m++++[m
 2 files changed, 10 insertions(+)
