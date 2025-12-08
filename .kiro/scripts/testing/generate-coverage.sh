#!/bin/bash
# Generate test coverage report

set -e

echo "📊 Generating coverage report..."

# Run tests with coverage
flutter test --coverage

# Generate HTML report
genhtml coverage/lcov.info -o coverage/html

echo "✅ Coverage report generated at coverage/html/index.html"
