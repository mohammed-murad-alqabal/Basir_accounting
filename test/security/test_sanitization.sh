#!/bin/bash

# =============================================================================
# اختبار تنظيف البيانات الحساسة - Security Testing
# =============================================================================
# المشروع: بصير MVP
# التاريخ: 6 ديسمبر 2025
# المؤلف: فريق وكلاء تطوير مشروع بصير
# =============================================================================
# الوصف: اختبار تنظيف البيانات الحساسة من السجلات
# المتطلبات: Requirements 9.1, 9.5
# =============================================================================

set -e

# تحميل مكتبة معالجة الأخطاء
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../scripts/utils/error_handler.sh"

# الألوان
readonly BOLD='\033[1m'

# عدادات
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

# =============================================================================
# دوال الاختبار
# =============================================================================

# اختبار تنظيف نمط معين
test_sanitization() {
    local test_name=$1
    local input_content=$2
    local sensitive_pattern=$3
    
    ((TOTAL_TESTS++))
    
    # إنشاء ملف تجريبي
    local test_file=$(mktemp)
    echo "$input_content" > "$test_file"
    
    # تشغيل التنظيف
    bash scripts/utils/sanitize.sh file "$test_file" > /dev/null 2>&1
    
    # التحقق من عدم وجود البيانات الحساسة
    if grep -q "$sensitive_pattern" "$test_file" 2>/dev/null; then
        print_error "✗ $test_name: البيانات الحساسة لا تزال موجودة"
        ((FAILED_TESTS++))
        rm -f "$test_file"
        return 1
    else
        print_success "✓ $test_name: تم تنظيف البيانات الحساسة"
        ((PASSED_TESTS++))
        rm -f "$test_file"
        return 0
    fi
}

# =============================================================================
# بدء الاختبارات
# =============================================================================

print_colored "$BLUE" "═══════════════════════════════════════════════════════════"
print_colored "$BLUE" "  اختبار تنظيف البيانات الحساسة"
print_colored "$BLUE" "═══════════════════════════════════════════════════════════"
echo ""

# =============================================================================
# 1. اختبار تنظيف API Keys
# =============================================================================

print_colored "$YELLOW" "\n═══ 1. اختبار تنظيف API Keys ═══\n"

test_sanitization "API Key (api_key=)" \
    "api_key=<credential-fixture>" \
    "<stripe-key-fixture>"

test_sanitization "API Key (apiKey:)" \
    "const apiKey: '<credential-fixture>'" \
    "pk_test_abcdefghijklmnop"

test_sanitization "API Key (API_KEY=)" \
    "API_KEY=<credential-fixture>" \
    "<aws-access-key-fixture>"

# =============================================================================
# 2. اختبار تنظيف Passwords
# =============================================================================

print_colored "$YELLOW" "\n═══ 2. اختبار تنظيف Passwords ═══\n"

test_sanitization "Password (password=)" \
    "password=<credential-fixture>" \
    "MySecretP@ssw0rd123"

test_sanitization "Password (pwd:)" \
    "pwd: 'admin123456'" \
    "admin123456"

test_sanitization "Password (PASSWORD=)" \
    "PASSWORD=<credential-fixture>" \
    "SuperSecret!2024"

test_sanitization "Password في JSON" \
    '{"username": "admin", "password": "secret123"}' \
    "secret123"

# =============================================================================
# 3. اختبار تنظيف Tokens
# =============================================================================

print_colored "$YELLOW" "\n═══ 3. اختبار تنظيف Tokens ═══\n"

test_sanitization "Token (token=)" \
    "token=<credential-fixture>" \
    "<github-token-fixture>"

test_sanitization "Bearer Token" \
    "Authorization: Bearer <credential-fixture>" \
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9"

test_sanitization "Access Token" \
    "access_token=<credential-fixture>" \
    "ya29.a0AfH6SMBx"

# =============================================================================
# 4. اختبار تنظيف Secret Keys
# =============================================================================

print_colored "$YELLOW" "\n═══ 4. اختبار تنظيف Secret Keys ═══\n"

test_sanitization "Secret Key (secret_key=)" \
    "secret_key=<credential-fixture>" \
    "sk_live_51H"

test_sanitization "Secret (SECRET=)" \
    "SECRET=<credential-fixture>" \
    "my-super-secret-value-2024"

test_sanitization "Client Secret" \
    "client_secret=<credential-fixture>" \
    "abc123def456ghi789"

# =============================================================================
# 5. اختبار تنظيف AWS Credentials
# =============================================================================

print_colored "$YELLOW" "\n═══ 5. اختبار تنظيف AWS Credentials ═══\n"

test_sanitization "AWS Access Key" \
    "AWS_ACCESS_KEY_ID=<aws-access-key-fixture>" \
    "<aws-access-key-fixture>"

test_sanitization "AWS Secret Key" \
    "AWS_SECRET_ACCESS_KEY=<credential-fixture>" \
    "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"

# =============================================================================
# 6. اختبار تنظيف Database Credentials
# =============================================================================

print_colored "$YELLOW" "\n═══ 6. اختبار تنظيف Database Credentials ═══\n"

test_sanitization "Database URL" \
    "DATABASE_URL=postgresql://user:password@localhost:5432/db" \
    "password"

test_sanitization "MongoDB Connection" \
    "MONGO_URI=mongodb+srv://admin:pass123@cluster.mongodb.net/db" \
    "pass123"

# =============================================================================
# 7. اختبار تنظيف SSH Keys
# =============================================================================

print_colored "$YELLOW" "\n═══ 7. اختبار تنظيف SSH Keys ═══\n"

test_sanitization "SSH Private Key" \
    "-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEA..." \
    "MIIEpAIBAAKCAQEA"

# =============================================================================
# 8. اختبار تنظيف Stripe Keys
# =============================================================================

print_colored "$YELLOW" "\n═══ 8. اختبار تنظيف Stripe Keys ═══\n"

test_sanitization "Stripe Secret Key" \
    "STRIPE_SECRET_KEY=<credential-fixture>" \
    "sk_live_51H"

test_sanitization "Stripe Webhook Secret" \
    "STRIPE_WEBHOOK_SECRET=<credential-fixture>" \
    "whsec_"

# =============================================================================
# 9. اختبار تنظيف GitHub Tokens
# =============================================================================

print_colored "$YELLOW" "\n═══ 9. اختبار تنظيف GitHub Tokens ═══\n"

test_sanitization "GitHub PAT" \
    "GITHUB_TOKEN=<github-token-fixture>" \
    "<github-token-fixture>"

test_sanitization "GitHub OAuth" \
    "GITHUB_OAUTH=<github-token-fixture>" \
    "<github-token-fixture>"

# =============================================================================
# 10. اختبار تنظيف Email Addresses
# =============================================================================

print_colored "$YELLOW" "\n═══ 10. اختبار تنظيف Email Addresses ═══\n"

test_sanitization "Email في سجل" \
    "User email: user@example.com logged in" \
    "user@example.com"

test_sanitization "Email في JSON" \
    '{"email": "admin@company.com", "role": "admin"}' \
    "admin@company.com"

# =============================================================================
# 11. اختبار تنظيف Phone Numbers
# =============================================================================

print_colored "$YELLOW" "\n═══ 11. اختبار تنظيف Phone Numbers ═══\n"

test_sanitization "رقم هاتف سعودي" \
    "Phone: 0501234567" \
    "0501234567"

test_sanitization "رقم هاتف دولي" \
    "Contact: +966501234567" \
    "+966501234567"

# =============================================================================
# 12. اختبار تنظيف IP Addresses
# =============================================================================

print_colored "$YELLOW" "\n═══ 12. اختبار تنظيف IP Addresses ═══\n"

test_sanitization "IPv4 Address" \
    "Server IP: 192.168.1.100" \
    "192.168.1.100"

test_sanitization "IPv6 Address" \
    "IPv6: 2001:0db8:85a3:0000:0000:8a2e:0370:7334" \
    "2001:0db8:85a3:0000:0000:8a2e:0370:7334"

# =============================================================================
# 13. اختبار تنظيف Credit Card Numbers
# =============================================================================

print_colored "$YELLOW" "\n═══ 13. اختبار تنظيف Credit Card Numbers ═══\n"

test_sanitization "رقم بطاقة ائتمان" \
    "Card: 4532-1234-5678-9010" \
    "4532-1234-5678-9010"

test_sanitization "رقم بطاقة بدون شرطات" \
    "CC: 4532123456789010" \
    "4532123456789010"

# =============================================================================
# النتائج النهائية
# =============================================================================

print_colored "$BLUE" "\n═══════════════════════════════════════════════════════════"
print_colored "$BLUE" "  النتائج النهائية"
print_colored "$BLUE" "═══════════════════════════════════════════════════════════"
echo ""

echo "إجمالي الاختبارات: $TOTAL_TESTS"
print_colored "$GREEN" "✓ نجح: $PASSED_TESTS"
print_colored "$RED" "✗ فشل: $FAILED_TESTS"

if [ $TOTAL_TESTS -gt 0 ]; then
    SUCCESS_RATE=$((PASSED_TESTS * 100 / TOTAL_TESTS))
    echo "معدل النجاح: ${SUCCESS_RATE}%"
    
    if [ $SUCCESS_RATE -ge 90 ]; then
        print_colored "$GREEN" "\n🎉 ممتاز! تنظيف البيانات يعمل بشكل ممتاز"
    elif [ $SUCCESS_RATE -ge 70 ]; then
        print_colored "$YELLOW" "\n⚠ جيد، لكن يحتاج بعض التحسين"
    else
        print_colored "$RED" "\n✗ يحتاج إلى تحسينات كبيرة"
    fi
fi

echo ""

# الخروج
if [ $FAILED_TESTS -gt 0 ]; then
    exit 1
fi

exit 0
