#!/bin/bash
# Check code quality

set -e

echo "🔍 Checking code quality..."

# Format check
echo "📝 Checking formatting..."
dart format --set-exit-if-changed .

# Analyze
echo "🔬 Analyzing code..."
flutter analyze

# Run tests
echo "🧪 Running tests..."
flutter test --coverage

# Check coverage threshold
echo "📊 Checking coverage..."
COVERAGE=$(lcov --summary coverage/lcov.info 2>&1 | grep lines | awk '{print $2}' | sed 's/%//')
if (( $(echo "$COVERAGE < 70" | bc -l) )); then
  echo "❌ Coverage $COVERAGE% is below 70%"
  exit 1
fi

echo "✅ Quality checks passed!"
