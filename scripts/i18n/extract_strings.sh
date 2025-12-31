#!/bin/bash

# Get the project root directory
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

# Run the dart script
dart run "$PROJECT_ROOT/scripts/i18n/extract_strings.dart"
