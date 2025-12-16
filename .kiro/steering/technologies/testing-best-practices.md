**المشروع:** بصير MVP
**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**المصدر:** مكيف من مصادر مجتمع Kiro المعتمدة
**التاريخ:** 10 December 2025

---

---

title: Testing Best Practices
inclusion: always

---

# Testing Best Practices

## Test Execution

- Always run tests with minimal verbosity to prevent session timeouts
- Use `--silent` or `--quiet` flags when available
- Filter tests with grep/pattern matching for focused testing
- Avoid running full test suites in automated contexts unless necessary

## Common Test Commands

```bash
# Flutter Test - Quiet mode (Primary for Baseer MVP)
flutter test --reporter=compact
dart test --reporter=compact

# Flutter Test - Specific test filtering
flutter test test/unit/invoice_test.dart
flutter test --name "specific test pattern"

# Flutter Test - Coverage reporting
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html

# Flutter Test - Performance mode
flutter test --concurrency=4
flutter test --plain-name "test pattern"
```

## Output Management

- Use summary reporters instead of verbose output
- Capture detailed logs only when tests fail
- Use `--bail` to stop on first failure in Flutter tests
- Redirect verbose output to files when needed: `flutter test > test-results.log 2>&1`

## Test Organization

- Group related tests to enable selective running
- Use test tags/categories for filtering
- Keep test names descriptive but concise
- Separate unit, integration, and e2e tests

## Performance

- Run tests in parallel when possible (`--concurrency=4` for Flutter)
- Use Flutter test caching mechanisms
- Mock external dependencies to speed up tests (using `mockito` package)
- Skip slow integration tests in development with `--exclude-tags=slow`

## CI/CD Considerations

- Use different verbosity levels for local vs CI environments
- Capture test artifacts (coverage, reports) separately from console output
- Use test result formatters that work well with CI systems
- Consider splitting large test suites across multiple jobs
