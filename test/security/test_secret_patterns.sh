#!/bin/bash

# =============================================================================
# اختبار أنماط الأسرار - Security Testing
# =============================================================================
# المشروع: بصير MVP
# التاريخ: 6 ديسمبر 2025
# المؤلف: فريق وكلاء تطوير مشروع بصير
# =============================================================================
# الوصف: اختبار فحص الأسرار المكشوفة مع أنماط مختلفة
# المتطلبات: Requirements 9.2, 9.3
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

# اختبار نمط معين
test_secret_pattern() {
    local pattern_name=$1
    local test_content=$2
    local should_detect=$3
    
    ((TOTAL_TESTS++))
    
    # إنشاء ملف تجريبي
    local test_file=$(mktemp)
    echo "$test_content" > "$test_file"
    
    # تشغيل فحص الأسرار
    if bash scripts/utils/validate.sh secrets "$test_file" > /dev/null 2>&1; then
        # لم يتم اكتشاف أسرار
        if [ "$should_detect" = "false" ]; then
            print_success "✓ $pattern_name: لم يتم اكتشاف أسرار (صحيح)"
            ((PASSED_TESTS++))
            rm -f "$test_file"
            return 0
        else
            print_error "✗ $pattern_name: لم يتم اكتشاف السر (خطأ)"
            ((FAILED_TESTS++))
            rm -f "$test_file"
            return 1
        fi
    else
        # تم اكتشاف أسرار
        if [ "$should_detect" = "true" ]; then
            print_success "✓ $pattern_name: تم اكتشاف السر (صحيح)"
            ((PASSED_TESTS++))
            rm -f "$test_file"
            return 0
        else
            print_error "✗ $pattern_name: تم اكتشاف سر خاطئ (false positive)"
            ((FAILED_TESTS++))
            rm -f "$test_file"
            return 1
        fi
    fi
}

# =============================================================================
# بدء الاختبارات
# =============================================================================

print_colored "$BLUE" "═══════════════════════════════════════════════════════════"
print_colored "$BLUE" "  اختبار أنماط الأسرار المكشوفة"
print_colored "$BLUE" "═══════════════════════════════════════════════════════════"
echo ""

# =============================================================================
# 1. اختبار API Keys
# =============================================================================

print_colored "$YELLOW" "\n═══ 1. اختبار API Keys ═══\n"

# نمط 1: API Key بصيغة api_key=
test_secret_pattern "API Key (api_key=)" \
    "api_key=redacted" \
    "true"

# نمط 2: API Key بصيغة apiKey:
test_secret_pattern "API Key (apiKey:)" \
    "const apiKey: 'redacted'" \
    "true"

# نمط 3: API Key بصيغة API_KEY=
test_secret_pattern "API Key (API_KEY=)" \
    "API_KEY=redacted" \
    "true"

# نمط 4: API Key بصيغة x-api-key
test_secret_pattern "API Key (x-api-key)" \
    "x-api-key: Bearer redacted" \
    "true"

# نمط 5: كود عادي بدون API Key
test_secret_pattern "كود عادي (لا يوجد API Key)" \
    "const apiKeyLength = 32; // طول المفتاح" \
    "false"

# =============================================================================
# 2. اختبار Passwords
# =============================================================================

print_colored "$YELLOW" "\n═══ 2. اختبار Passwords ═══\n"

# نمط 1: Password بصيغة password=
test_secret_pattern "Password (password=)" \
    "password=MySecretP@ssw0rd123" \
    "true"

# نمط 2: Password بصيغة pwd:
test_secret_pattern "Password (pwd:)" \
    "pwd: 'admin123456'" \
    "true"

# نمط 3: Password بصيغة PASSWORD=
test_secret_pattern "Password (PASSWORD=)" \
    "PASSWORD=SuperSecret!2024" \
    "true"

# نمط 4: Password في JSON
test_secret_pattern "Password (JSON)" \
    '{"username": "admin", "password": "secret123"}' \
    "true"

# نمط 5: كلمة password في تعليق
test_secret_pattern "كلمة password في تعليق" \
    "// يجب تغيير password الافتراضي" \
    "false"

# =============================================================================
# 3. اختبار Tokens
# =============================================================================

print_colored "$YELLOW" "\n═══ 3. اختبار Tokens ═══\n"

# نمط 1: Token بصيغة token=
test_secret_pattern "Token (token=)" \
    "token=redacted" \
    "true"

# نمط 2: Bearer Token
test_secret_pattern "Bearer Token" \
    "Authorization: Bearer redacted" \
    "true"

# نمط 3: Access Token
test_secret_pattern "Access Token" \
    "access_token=redacted" \
    "true"

# نمط 4: Refresh Token
test_secret_pattern "Refresh Token" \
    "refresh_token=1//0gHZqN9..." \
    "true"

# نمط 5: كلمة token في متغير
test_secret_pattern "كلمة token في متغير" \
    "const tokenLength = 64;" \
    "false"

# =============================================================================
# 4. اختبار Secret Keys
# =============================================================================

print_colored "$YELLOW" "\n═══ 4. اختبار Secret Keys ═══\n"

# نمط 1: Secret Key بصيغة secret_key=
test_secret_pattern "Secret Key (secret_key=)" \
    "secret_key=sk_live_51H..." \
    "true"

# نمط 2: Secret بصيغة SECRET=
test_secret_pattern "Secret (SECRET=)" \
    "SECRET=my-super-secret-value-2024" \
    "true"

# نمط 3: Private Key
test_secret_pattern "Private Key" \
    "private_key=-----BEGIN PRIVATE KEY-----" \
    "true"

# نمط 4: Client Secret
test_secret_pattern "Client Secret" \
    "client_secret=redacted" \
    "true"

# نمط 5: كلمة secret في تعليق
test_secret_pattern "كلمة secret في تعليق" \
    "// هذا سر مهم يجب حمايته" \
    "false"

# =============================================================================
# 5. اختبار AWS Credentials
# =============================================================================

print_colored "$YELLOW" "\n═══ 5. اختبار AWS Credentials ═══\n"

# نمط 1: AWS Access Key
test_secret_pattern "AWS Access Key" \
    "AWS_ACCESS_KEY_ID=redacted" \
    "true"

# نمط 2: AWS Secret Key
test_secret_pattern "AWS Secret Key" \
    "AWS_SECRET_ACCESS_KEY=redacted" \
    "true"

# نمط 3: AWS Session Token
test_secret_pattern "AWS Session Token" \
    "AWS_SESSION_TOKEN=redacted" \
    "true"

# نمط 4: كود AWS عادي
test_secret_pattern "كود AWS عادي" \
    "const awsRegion = 'us-east-1';" \
    "false"

# =============================================================================
# 6. اختبار Database Credentials
# =============================================================================

print_colored "$YELLOW" "\n═══ 6. اختبار Database Credentials ═══\n"

# نمط 1: Database URL
test_secret_pattern "Database URL" \
    "DATABASE_URL=postgresql://user:password@localhost:5432/db" \
    "true"

# نمط 2: MongoDB Connection String
test_secret_pattern "MongoDB Connection" \
    "MONGO_URI=mongodb+srv://admin:pass123@cluster.mongodb.net/db" \
    "true"

# نمط 3: Redis URL
test_secret_pattern "Redis URL" \
    "REDIS_URL=redis://:password@localhost:6379" \
    "true"

# نمط 4: Database Host فقط
test_secret_pattern "Database Host فقط" \
    "DB_HOST=localhost" \
    "false"

# =============================================================================
# 7. اختبار SSH Keys
# =============================================================================

print_colored "$YELLOW" "\n═══ 7. اختبار SSH Keys ═══\n"

# نمط 1: SSH Private Key
test_secret_pattern "SSH Private Key" \
    "-----BEGIN RSA PRIVATE KEY-----" \
    "true"

# نمط 2: SSH Public Key (يجب ألا يُكتشف)
test_secret_pattern "SSH Public Key" \
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQ..." \
    "false"

# نمط 3: OpenSSH Private Key
test_secret_pattern "OpenSSH Private Key" \
    "-----BEGIN OPENSSH PRIVATE KEY-----" \
    "true"

# =============================================================================
# 8. اختبار Stripe Keys
# =============================================================================

print_colored "$YELLOW" "\n═══ 8. اختبار Stripe Keys ═══\n"

# نمط 1: Stripe Secret Key
test_secret_pattern "Stripe Secret Key" \
    "STRIPE_SECRET_KEY=sk_live_51H..." \
    "true"

# نمط 2: Stripe Publishable Key (يجب ألا يُكتشف)
test_secret_pattern "Stripe Publishable Key" \
    "STRIPE_PUBLISHABLE_KEY=pk_live_51H..." \
    "false"

# نمط 3: Stripe Webhook Secret
test_secret_pattern "Stripe Webhook Secret" \
    "STRIPE_WEBHOOK_SECRET=whsec_..." \
    "true"

# =============================================================================
# 9. اختبار GitHub Tokens
# =============================================================================

print_colored "$YELLOW" "\n═══ 9. اختبار GitHub Tokens ═══\n"

# نمط 1: GitHub Personal Access Token
test_secret_pattern "GitHub PAT" \
    "GITHUB_TOKEN=redacted" \
    "true"

# نمط 2: GitHub OAuth Token
test_secret_pattern "GitHub OAuth" \
    "GITHUB_OAUTH=redacted" \
    "true"

# نمط 3: GitHub App Token
test_secret_pattern "GitHub App Token" \
    "GITHUB_APP_TOKEN=redacted" \
    "true"

# =============================================================================
# 10. اختبار False Positives
# =============================================================================

print_colored "$YELLOW" "\n═══ 10. اختبار False Positives ═══\n"

# نمط 1: تعليق عن API Key
test_secret_pattern "تعليق عن API Key" \
    "// TODO: إضافة API key من لوحة التحكم" \
    "false"

# نمط 2: مثال في التوثيق
test_secret_pattern "مثال في التوثيق" \
    "مثال: api_key=YOUR_API_KEY_HERE" \
    "false"

# نمط 3: متغير placeholder
test_secret_pattern "متغير placeholder" \
    "const API_KEY = process.env.API_KEY;" \
    "false"

# نمط 4: اسم دالة
test_secret_pattern "اسم دالة" \
    "function validateApiKey(key: string) {" \
    "false"

# نمط 5: اسم ملف
test_secret_pattern "اسم ملف" \
    "// ملف: api_key_validator.dart" \
    "false"

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
        print_colored "$GREEN" "\n🎉 ممتاز! فحص الأسرار يعمل بشكل ممتاز"
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
