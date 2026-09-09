#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../scripts/utils/error_handler.sh"

TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

# Detect high-confidence secret material, not ordinary words such as
# "secret feature", class names, imports, or generic documentation.
detect_secrets() {
    local content=${1-}

    if [[ $content =~ (ghp_|github_pat_|gho_|sk_live_|whsec_|AKIA[0-9A-Z]{12,}) ]]; then
        return 0
    fi

    if [[ $content =~ [Aa]uthorization[[:space:]]*:[[:space:]]*[Bb]earer[[:space:]]+[A-Za-z0-9._~+/=-]{8,} ]]; then
        return 0
    fi

    if [[ $content =~ (remove|rotate|exposed|your|set|use)[[:space:]]+.{0,30}(api[_-]?key|password|access[_-]?token|bearer[_-]?token|secret) ]]; then
        return 0
    fi

    local assignment_pattern='(api[_-]?key|password|token|secret|access[_-]?token|bearer[_-]?token|client[_-]?secret|secret[_-]?key|auth[_-]?(key|token))[[:space:]]*[:=]'
    if [[ $content =~ $assignment_pattern ]]; then
        return 0
    fi

    local setter_pattern='(setToken|setSecret|setPassword|token|secret|password)[[:space:]]*\([^)]*\)'
    if [[ $content =~ $setter_pattern ]]; then
        return 0
    fi

    return 1
}

run_case() {
    local name=$1
    local expected=$2
    local content=$3
    local detected=1

    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    if detect_secrets "$content"; then
        detected=0
    fi

    if [[ $detected -eq $expected ]]; then
        PASSED_TESTS=$((PASSED_TESTS + 1))
        print_success "✓ $name"
    else
        FAILED_TESTS=$((FAILED_TESTS + 1))
        print_error "✗ $name"
        printf '  content=%q\n' "$content" >&2
    fi
}

print_colored "$BLUE" "═══════════════════════════════════════════════════════════"
print_colored "$BLUE" "  اختبار أنماط الأسرار عالي الدقة"
print_colored "$BLUE" "═══════════════════════════════════════════════════════════"

run_case "api_key assignment" 0 "const api_key = 'value';"
run_case "password assignment" 0 "password: 'value'"
run_case "token assignment" 0 "final token = 'value';"
run_case "secret assignment" 0 "const secret = 'value';"
run_case "auth key assignment" 0 "auth_token = 'value'"
run_case "bearer header" 0 "Authorization: Bearer abcdefgh123456"
run_case "known GitHub token prefix" 0 "github_pat_12345678901234567890"
STRIPE_TEST_SUFFIX="12345678901234567890"
run_case "known Stripe token prefix" 0 "sk_live_${STRIPE_TEST_SUFFIX}"
run_case "security remediation comment" 0 "// TODO: remove api_key before commit"
run_case "token setter call" 0 "setToken('value')"
run_case "ordinary secret wording" 1 "// This is a secret feature"
run_case "class name" 1 "class SecretManager {}"
run_case "auth import" 1 "import 'package:auth/auth.dart';"
run_case "ordinary user identifier" 1 "const userId = 12345;"
run_case "ordinary customer name" 1 "const customerName = 'Ahmed';"
run_case "ordinary total" 1 "final totalPrice = 99.99;"

print_colored "$BLUE" "\n═══════════════════════════════════════════════════════════"
print_colored "$BLUE" "  النتائج النهائية"
print_colored "$BLUE" "═══════════════════════════════════════════════════════════"
printf 'إجمالي الاختبارات: %s\n' "$TOTAL_TESTS"
print_colored "$GREEN" "✓ نجح: $PASSED_TESTS"
print_colored "$RED" "✗ فشل: $FAILED_TESTS"

if [[ $FAILED_TESTS -ne 0 ]]; then
    exit 1
fi

exit 0
