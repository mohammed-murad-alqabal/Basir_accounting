#!/bin/bash
# Run integration tests

set -e

echo "🔗 Running integration tests..."

flutter test integration_test

echo "✅ Integration tests passed!"
