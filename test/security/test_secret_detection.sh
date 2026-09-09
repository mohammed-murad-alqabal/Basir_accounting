#!/usr/bin/env bash

# Compatibility entry point retained for callers of the former BATS-style file.
# The executable suite now lives in test_secret_patterns.sh.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec bash "$SCRIPT_DIR/test_secret_patterns.sh"
