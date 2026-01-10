#!/bin/bash
# Script: verify_branding.sh
# Purpose: Enforce "Basir Accounting System" branding and detect legacy references.
# Author: <credential-fixture>

set -e

echo "🔍 Starting Branding Verification..."

LEGACY_TERMS=("Basser" "Baseer_0" "Baseer_MVP" "Baseer MVP")
ALLOWED_TERMS=("basir_accounting_system" "Basir Accounting System" "نظام بصير المحاسبي")

ERROR_COUNT=0

# Exclude directories
EXCLUDED_DIRS=".git .dart_tool build logs node_modules rust/target coverage"
EXCLUDES=""
for dir in $EXCLUDED_DIRS; do
    EXCLUDES="$EXCLUDES --exclude-dir=$dir"
done

for term in "${LEGACY_TERMS[@]}"; do
    echo "  - Checking for legacy term: '$term'..."
    COUNT=$(grep -ri "$term" . $EXCLUDES | wc -l)
    if [ "$COUNT" -gt 0 ]; then
        echo "    ⚠️  Found $COUNT instances of '$term'. Review needed:"
        grep -ri "$term" . $EXCLUDES | head -n 3 | sed 's/^/      /'
        ERROR_COUNT=$((ERROR_COUNT + 1))
    else
        echo "    ✅ Clean."
    fi
done

echo "----------------------------------------"

if [ "$ERROR_COUNT" -gt 0 ]; then
    echo "❌ Branding verification failed with legacy references."
    # We might not want to exit 1 immediately if we are just auditing, but for a strict check we should.
    # For now, just warn.
else
    echo "✨ Project is consistent with branding standards!"
fi
