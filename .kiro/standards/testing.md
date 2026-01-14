# Testing Standards

**Project:** Basir MVP  
**Status:** ✅ Active

---

## Testing Types

### Unit Tests

- **Goal:** Test isolated functions and classes.
- **Coverage Target:** 70%+
- **Speed:** Near-instant.

### Widget Tests

- **Goal:** Test UI components and single-widget behavior.
- **Coverage Target:** Critical user paths.
- **Speed:** Fast.

### Integration Tests

- **Goal:** Test end-to-end user flows and service orchestration.
- **Coverage Target:** Representative user journeys.
- **Speed:** Moderate.

---

## Core Rules

### Mandatory Requirements

- ✅ Test every public function and business logic branch.
- ✅ Test both "Happy Paths" (expected behavior) and "Edge Cases" (exceptional behavior).
- ✅ Use **Mocks** (e.g., Mocktail) to isolate external dependencies (databases, APIs).
- ✅ Each test must be completely independent and self-contained.

### Prohibited Practices

- ❌ Interdependent tests (one test relying on the side effects of another).
- ❌ Slow test suites (> 30 seconds for the entire local suite).
- ❌ Using real production or persistent data during execution.
- ❌ Over-mocking to force tests to pass without verifying real logic.

---

## Structure

### Test Organization

```
test/
├── unit/          # Isolated business logic tests
├── widget/        # Individual widget and UI tests
└── integration/   # Holistic flow and service tests
```

### File Naming Convention

```
customer_repository.dart → customer_repository_test.dart
```

---

## Best Practices

### Setup and Teardown

```dart
setUp(() async {
  // Logic to execute before every individual test.
});

tearDown(() async {
  // Logic to execute after every individual test.
});
```

### Descriptive Test Names

```dart
test('should add customer successfully when data is valid', () {
  // ...
});
```

### Effective Use of Matchers

```dart
expect(result, isNotNull);
expect(customers.length, equals(1));
expect(() => validate(''), throwsException);
```

---

## Execution

### CLI Commands

```bash
flutter test                    # Run all tests
flutter test --coverage         # Run with coverage report generation
flutter test test/unit/         # Run tests in a specific directory
```

---

**For practical examples, refer to:** `.kiro/steering/reference/testing-examples.md`
