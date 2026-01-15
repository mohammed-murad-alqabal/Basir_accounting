# Phase 2.4: Test Infrastructure Fixes - Implementation Plan

**Specification ID:** BASIR-SPEC-2026-001-P2.4  
**Date:** January 12, 2026  
**Author:** Basir Accounting System Development Agents Team  
**Priority:** Critical (Blocking Phase 3)

---

## 🎯 Objective

Fix critical test infrastructure issues preventing reliable test execution:

1. RustLib initialization failures in integration tests
2. Timeout issues in Dashboard controller tests
3. Test performance optimization

---

## 🔍 Root Cause Analysis

### Issue 1: RustLib Initialization Failures

**Error Pattern:**

```
Bad state: flutter_rust_bridge has not been initialized.
Did you forget to call `await RustLib.init();`?
```

**Affected Tests:**

- `test/integration/invoice_posting_test.dart`
- `test/unit/features/accounting/accounting_core_institutional_test.dart`

**Root Cause:**

- Tests attempt to use Rust API functions without proper RustLib initialization
- No mock implementation for RustLib in test environment
- Missing test setup for flutter_rust_bridge

### Issue 2: Dashboard Test Timeouts

**Error Pattern:**

```
pumpAndSettle timed out
```

**Root Cause:**

- Complex Dashboard widgets with heavy data loading
- Inefficient test setup/teardown
- Missing proper mock data for Dashboard tests

---

## 🛠️ Implementation Strategy

### Strategy 1: Mock RustLib for Tests

**Approach:** Create mock implementation of RustLib API for test environment

**Benefits:**

- Eliminates RustLib initialization dependency in tests
- Faster test execution
- Isolated unit testing

**Implementation:**

1. Create `test/helpers/mock_rust_lib.dart`
2. Implement mock versions of all RustLib API calls
3. Update test setup to use mock implementation

### Strategy 2: Optimize Dashboard Tests

**Approach:** Improve test performance and reliability

**Benefits:**

- Faster test execution
- Reduced timeout issues
- More reliable CI/CD pipeline

**Implementation:**

1. Optimize Dashboard test data setup
2. Implement proper widget testing patterns
3. Add timeout configuration for complex tests

---

## 📋 Detailed Implementation Plan

### Task 1: Create RustLib Mock Infrastructure

#### 1.1 Create Mock RustLib API

```dart
// test/helpers/mock_rust_lib.dart
class MockRustLibApi extends Mock implements RustLibApi {
  @override
  bool crateApiCheckHealth() => true;

  @override
  Future<void> crateApiInitApi({required String databaseUrl}) async {
    // Mock implementation - no actual initialization
  }

  // ... implement all other API methods as mocks
}
```

#### 1.2 Create Test Helper for RustLib Setup

```dart
// test/helpers/rust_lib_test_helper.dart
void setupMockRustLib() {
  RustLib.initMock(api: MockRustLibApi());
}
```

#### 1.3 Update Integration Tests

Update `test/integration/invoice_posting_test.dart`:

- Add `setupMockRustLib()` call in `setUp()`
- Remove dependency on actual RustLib initialization

### Task 2: Fix Dashboard Test Performance

#### 2.1 Optimize Dashboard Test Setup

```dart
// test/widget/features/dashboard/dashboard_screen_test.dart
setUp(() async {
  // Use minimal test data
  // Optimize mock setup
  // Configure appropriate timeouts
});
```

#### 2.2 Implement Proper Widget Testing Patterns

- Use `pumpWidget()` instead of `pumpAndSettle()` where appropriate
- Add explicit timeout configurations
- Implement proper test data factories

### Task 3: Update Test Configuration

#### 3.1 Create Test Configuration File

```dart
// test/test_config.dart
class TestConfig {
  static const Duration defaultTimeout = Duration(seconds: 30);
  static const Duration widgetTestTimeout = Duration(seconds: 10);
  static const Duration integrationTestTimeout = Duration(seconds: 60);
}
```

#### 3.2 Update Test Runner Configuration

Update test timeout settings in appropriate test files.

---

## 🎯 Success Criteria

### Primary Metrics

| Metric                  | Current  | Target | Status         |
| ----------------------- | -------- | ------ | -------------- |
| **Failed Tests**        | 53       | 0      | 🔄 In Progress |
| **RustLib Errors**      | Multiple | 0      | 🔄 In Progress |
| **Timeout Errors**      | Multiple | 0      | 🔄 In Progress |
| **Test Execution Time** | >30s     | <15s   | 🔄 In Progress |

### Verification Steps

1. ✅ All integration tests pass without RustLib errors
2. ✅ Dashboard tests complete within timeout limits
3. ✅ Overall test suite execution time improved
4. ✅ No critical test failures blocking development

---

## 📅 Implementation Timeline

### Day 1 (January 12, 2026)

- **Morning:** Create RustLib mock infrastructure
- **Afternoon:** Update integration tests with mock setup

### Day 2 (January 13, 2026)

- **Morning:** Fix Dashboard test performance issues
- **Afternoon:** Update test configuration and timeouts

### Day 3 (January 14, 2026)

- **Morning:** Run comprehensive test suite validation
- **Afternoon:** Document fixes and update progress tracking

---

## 🚨 Risk Mitigation

### Risk 1: Mock Implementation Incomplete

**Mitigation:** Implement only required API methods for current tests

### Risk 2: Test Performance Still Poor

**Mitigation:** Implement progressive timeout increases and test splitting

### Risk 3: New Test Failures Introduced

**Mitigation:** Run tests incrementally after each fix

---

## 📞 Next Steps

1. **Immediate:** Begin RustLib mock implementation
2. **Short-term:** Fix critical test failures
3. **Medium-term:** Optimize overall test performance
4. **Long-term:** Establish robust test infrastructure

---

**Prepared by:** Basir Accounting System Development Agents Team  
**Review Date:** January 15, 2026  
**Status:** Ready for Implementation
