# Quick Action Checklist - Repository Audit

**Date:** January 15, 2026  
**Status:** Ready for Execution

---

## 🔴 CRITICAL - Do This Week

### 1. Root Directory Cleanup (2 hours)

```bash
# Create archive directories
mkdir -p docs/archive/reports/2026-01
mkdir -p logs/archive/flutter
mkdir -p backups/pubspec

# Move report files
mv *_report_*.md docs/archive/reports/2026-01/ 2>/dev/null || true
mv *_status_*.md docs/archive/reports/2026-01/ 2>/dev/null || true
mv *_plan_*.md docs/archive/reports/2026-01/ 2>/dev/null || true
mv *_analysis*.txt docs/archive/reports/2026-01/ 2>/dev/null || true
mv comprehensive_*.md docs/archive/reports/2026-01/ 2>/dev/null || true
mv dashboard_*.md docs/archive/reports/2026-01/ 2>/dev/null || true
mv phase_*.md docs/archive/reports/2026-01/ 2>/dev/null || true
mv final_*.md docs/archive/reports/2026-01/ 2>/dev/null || true
mv manual_*.md docs/archive/reports/2026-01/ 2>/dev/null || true
mv test_*.md docs/archive/reports/2026-01/ 2>/dev/null || true
mv performance_*.md docs/archive/reports/2026-01/ 2>/dev/null || true
mv project_*.md docs/archive/reports/2026-01/ 2>/dev/null || true
mv next_*.md docs/archive/reports/2026-01/ 2>/dev/null || true

# Move log files
mv flutter_*.log logs/archive/flutter/ 2>/dev/null || true
mv firebase-debug.log logs/archive/ 2>/dev/null || true

# Move backup files
mv pubspec_backup_*.yaml backups/pubspec/ 2>/dev/null || true

# Update .gitignore (add these lines if missing)
cat >> .gitignore << 'EOF'

# Root directory cleanup rules
/*.isar
/*.isar.lock
/*.db
/*.db-shm
/*.db-wal
/*_report_*.md
/*_status_*.md
/*_plan_*.md
/*_analysis*.txt
/*_analysis*.md
/comprehensive_*.md
/dashboard_*.md
/phase_*.md
/final_*.md
/manual_*.md
/test_*.md
/performance_*.md
/project_*.md
/next_*.md

# Keep important root docs
!README.md
!CHANGELOG.md
!CONTRIBUTING.md
!LICENSE
!SECURITY.md
!ARCHITECTURE.md
!TECHNICAL_SPEC.md
!STRUCTURE.md
!ENGINEERING_AUDIT_REPORT.md
EOF

# Remove tracked database files
git rm --cached *.isar *.isar.lock *.db 2>/dev/null || true

# Commit cleanup
git add .
git commit -m "chore: clean root directory and update gitignore

- Move 38 temporary files to appropriate archives
- Update .gitignore to prevent future clutter
- Remove tracked database files
- Maintain professional repository structure

Refs: COMPREHENSIVE_REPOSITORY_AUDIT_20260115.md"
```

**Verification:**

- [ ] Root directory has <10 files
- [ ] All reports moved to docs/archive/
- [ ] All logs moved to logs/archive/
- [ ] .gitignore updated
- [ ] Git commit successful

---

### 2. Fix Test Timeout Issues (4-8 hours)

**Step 1: Profile Tests**

```bash
# Run tests with detailed output
flutter test --reporter json > test_profile.json

# Identify slow tests
cat test_profile.json | grep -A 5 '"time"' | sort -t: -k2 -n
```

**Step 2: Optimize Slow Tests**

- [ ] Identify tests taking >5 seconds
- [ ] Check for heavy database operations
- [ ] Implement proper mocking for Isar
- [ ] Optimize setUp() and tearDown()
- [ ] Add test isolation

**Step 3: Split Test Suites**

```bash
# Run unit tests only
flutter test test/unit/ --timeout 60s

# Run widget tests separately
flutter test test/widget/ --timeout 60s

# Run integration tests separately
flutter test integration_test/ --timeout 120s
```

**Step 4: Update CI/CD**

```yaml
# In .github/workflows/flutter_ci.yml
- name: Run unit tests
  run: flutter test test/unit/ --coverage --timeout 60s

- name: Run widget tests
  run: flutter test test/widget/ --timeout 60s
```

**Verification:**

- [ ] All tests complete within timeout
- [ ] Coverage report generated
- [ ] CI/CD passes
- [ ] No test failures

---

### 3. Update .gitignore for Database Files (15 minutes)

**Already included in Step 1 above**

**Additional Verification:**

```bash
# Check for tracked database files
git ls-files | grep -E '\.(isar|db)$'

# Should return nothing
```

---

## 🟡 HIGH - Next 2 Weeks

### 4. Plan Riverpod 3.0 Migration (8 hours)

**Week 1: Research & Planning**

```bash
# Create migration branch
git checkout -b refactor/riverpod-3.0-migration

# Create migration document
cat > docs/migrations/RIVERPOD_3.0_MIGRATION.md << 'EOF'
# Riverpod 3.0 Migration Plan

## Overview
Migrate from Riverpod 2.6.1 to 3.1.0

## Breaking Changes
1. Provider syntax changes
2. AsyncNotifier improvements
3. New ref API

## Migration Checklist
- [ ] Audit all provider usage
- [ ] Update provider declarations
- [ ] Update ref.watch() calls
- [ ] Update ref.read() calls
- [ ] Test each module
- [ ] Update documentation

## Timeline
- Week 1: Planning and audit
- Week 2: Non-breaking updates
- Week 3: Riverpod migration
- Week 4: Testing and verification
EOF
```

**Tasks:**

- [ ] Read Riverpod 3.0 migration guide
- [ ] Audit all Riverpod usage in codebase
- [ ] Create detailed migration checklist
- [ ] Estimate effort per module
- [ ] Plan testing strategy

**Audit Command:**

```bash
# Find all provider declarations
grep -r "Provider" lib/ --include="*.dart" | wc -l

# Find all ref.watch usage
grep -r "ref.watch" lib/ --include="*.dart" | wc -l

# Find all ref.read usage
grep -r "ref.read" lib/ --include="*.dart" | wc -l
```

---

### 5. Fix Discarded Futures (2-4 hours)

**Find Issues:**

```bash
# Run analyzer to find discarded futures
flutter analyze 2>&1 | grep "discarded_futures"
```

**Fix Pattern:**

```dart
// ❌ Bad - Discarded future
someAsyncFunction();

// ✅ Good - Awaited
await someAsyncFunction();

// ✅ Good - Explicitly unawaited
unawaited(someAsyncFunction());
```

**Tasks:**

- [ ] Find all discarded futures
- [ ] Determine if each should be awaited
- [ ] Add await or unawaited() as appropriate
- [ ] Test affected code
- [ ] Verify analyzer passes

---

### 6. Add Missing API Documentation (4-6 hours)

**Find Undocumented APIs:**

```bash
# Run analyzer to find missing docs
flutter analyze 2>&1 | grep "public_member_api_docs"
```

**Documentation Template:**

````dart
/// Brief description of what this does.
///
/// More detailed explanation if needed.
///
/// Example:
/// ```dart
/// final result = myFunction(param);
/// ```
///
/// Parameters:
/// - [param]: Description of parameter
///
/// Returns: Description of return value
///
/// Throws: [Exception] if something goes wrong
````

**Priority Files:**

- [ ] Core services
- [ ] Domain entities
- [ ] Public repositories
- [ ] Utility functions

---

## 🟢 MEDIUM - Next Month

### 7. Update Non-Breaking Dependencies (4 hours)

```bash
# Update build_runner
flutter pub upgrade build_runner

# Update freezed
flutter pub upgrade freezed

# Update flutter_lints
flutter pub upgrade flutter_lints

# Run code generation
flutter pub run build_runner build --delete-conflicting-outputs

# Test
flutter test

# Commit
git add pubspec.lock
git commit -m "chore(deps): update non-breaking dependencies

- build_runner: 2.4.13 → 2.10.5
- freezed: 2.5.2 → 3.2.4
- flutter_lints: updated to latest

All tests passing."
```

---

### 8. Refactor Long Lines (6-8 hours)

**Find Long Lines:**

```bash
# Find lines >80 characters
find lib/ test/ -name "*.dart" -exec awk 'length > 80 {
  print FILENAME ":" NR ": " length " chars"
}' {} \; | head -50
```

**Refactoring Strategies:**

1. Break long function calls
2. Extract complex expressions
3. Use trailing commas
4. Split long strings

**Priority:**

- [ ] Core business logic
- [ ] Public APIs
- [ ] Frequently modified files

---

### 9. Optimize Test Performance (8 hours)

**Strategies:**

1. **Mock Heavy Dependencies**

```dart
// Mock Isar database
class MockIsarService extends Mock implements IsarService {}

setUp(() {
  mockIsar = MockIsarService();
  // Setup mocks
});
```

2. **Use Test Fixtures**

```dart
// Create reusable test data
class TestFixtures {
  static Invoice createInvoice({...}) => Invoice(...);
}
```

3. **Implement Test Sharding**

```bash
# Split tests into groups
flutter test test/unit/features/invoices/
flutter test test/unit/features/customers/
```

4. **Optimize setUp/tearDown**

```dart
// Use setUpAll for expensive operations
setUpAll(() async {
  // One-time setup
});

setUp(() {
  // Per-test setup (fast)
});
```

---

## 🔵 LOW - Future

### 10. Replace Deprecated Methods (2-4 hours)

**Find Deprecated Usage:**

```bash
flutter analyze 2>&1 | grep "deprecated"
```

**Common Replacements:**

```dart
// Color.withOpacity → Color.withValues
color.withOpacity(0.5) → color.withValues(alpha: 0.5)

// Table.fromTextArray → Use newer API
// Check pdf package documentation
```

---

### 11. Add SAST Tools (4 hours)

**Options:**

1. Snyk
2. SonarQube
3. GitGuardian

**Implementation:**

```yaml
# .github/workflows/security.yml
name: Security Scan

on: [push, pull_request]

jobs:
  snyk:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: snyk/actions/flutter@master
        env:
          SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}
```

---

### 12. Performance Regression Testing (8+ hours)

**Setup:**

1. Define performance benchmarks
2. Create automated tests
3. Set up monitoring
4. Configure alerts

**Example:**

```dart
// test/performance/invoice_performance_test.dart
void main() {
  test('Invoice creation performance', () async {
    final stopwatch = Stopwatch()..start();

    // Create 1000 invoices
    for (int i = 0; i < 1000; i++) {
      await createInvoice();
    }

    stopwatch.stop();

    // Should complete in <5 seconds
    expect(stopwatch.elapsedMilliseconds, lessThan(5000));
  });
}
```

---

## Progress Tracking

### Week 1

- [ ] Root directory cleanup
- [ ] Test timeout fixes
- [ ] .gitignore updates

### Week 2

- [ ] Riverpod migration planning
- [ ] Fix discarded futures
- [ ] Add API documentation

### Week 3

- [ ] Update non-breaking dependencies
- [ ] Refactor long lines
- [ ] Optimize test performance

### Week 4

- [ ] Replace deprecated methods
- [ ] Plan SAST integration
- [ ] Design performance tests

---

## Success Criteria

**After Week 1:**

- ✅ Root directory has <10 files
- ✅ All tests complete within timeout
- ✅ Coverage report generated
- ✅ CI/CD passes

**After Week 2:**

- ✅ Riverpod migration plan complete
- ✅ 0 discarded futures
- ✅ Public APIs documented

**After Week 3:**

- ✅ Dependencies updated
- ✅ Long lines reduced by 50%
- ✅ Test performance improved

**After Week 4:**

- ✅ Deprecated methods replaced
- ✅ SAST tools configured
- ✅ Performance baseline established

---

**Prepared By:**  
Basir Accounting System Development Agents Team

**Date:** January 15, 2026  
**Version:** 1.0
