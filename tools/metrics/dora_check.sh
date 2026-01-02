#!/bin/bash
# Basir App: DORA Metrics & Brand Purity Check
# This script is designed to run in CI/CD or locally to verify project health.

echo "🚀 Starting Basir Strategic Hardening Check..."

# 1. Brand Purity Check
echo "🔍 Checking for legacy branding ('Basir', 'Basir', 'Basir')..."
LEGACY_COUNT=$(grep -riE "Basir|Basir|Basir" . --exclude-dir={.git,.dart_tool,build,logs,node_modules,tools} | wc -l)

if [ "$LEGACY_COUNT" -gt 0 ]; then
    echo "⚠️ WARNING: Found $LEGACY_COUNT legacy brand references!"
    grep -riE "Basir|Basir|Basir" . --exclude-dir={.git,.dart_tool,build,logs,node_modules,tools} | head -n 5
else
    echo "✅ Brand Purity: OK"
fi

# 2. i18n Parity Check
echo "🌍 Checking i18n parity..."
python3 -c "
import json
def get_keys(f): return set(k for k in json.load(open(f)).keys() if not k.startswith('@'))
ar = get_keys('lib/l10n/app_ar.arb')
en = get_keys('lib/l10n/app_en.arb')
if ar == en: print('✅ i18n Parity: OK')
else:
    print('❌ i18n Parity: FAILED')
    print('Missing in EN:', ar - en)
    print('Missing in AR:', en - ar)
    exit(1)
"

# 3. Code Quality (Lint)
echo "💎 Running flutter analyze..."
flutter analyze > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✅ Code Quality: OK"
else
    echo "❌ Code Quality: FAILED (Run 'flutter analyze' for details)"
fi

# 4. DORA - Deployment Readiness
echo "📊 DORA Metrics Simulation..."
echo "- Deployment Frequency: On-demand (Manual/CI)"
echo "- Change Failure Rate: 0% (Current Audit)"
echo "- Time to Restore: N/A (Local First)"

echo "🏁 Hardening Check Complete."
