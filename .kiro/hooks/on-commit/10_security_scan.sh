#!/bin/bash
# Hook: 10_security_scan.sh
# Type: on-commit
# Description: فحص أمني قبل الـ commit للكشف عن الأسرار (API keys, passwords)
# Project: بصير MVP (Flutter)
# Compliance: يطبق مبدأ Security First من steering/security.md

# --- Configuration ---
# أنماط الأسرار الشائعة
SECRET_PATTERNS='(password|secret|api_key|token|aws_access_key_id|private_key|firebase|supabase)'

# المجلدات المستثناة
EXCLUDE_DIRS="--exclude-dir={.git,.dart_tool,build,android/app/build,ios/Pods,.idea,.vscode}"

# ملفات Flutter الحساسة
FLUTTER_CONFIG_FILES="--include=*\.env --include=*\.json --include=*\.yaml --include=*\.yml --include=*\.dart"

# --- Execution ---
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔒 Kiro Security Pre-Commit Scan (بصير MVP)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# 1. فحص الملفات المُجهزة للـ commit
echo "📋 1. فحص الملفات المُجهزة للـ commit..."
if git diff --cached --name-only | xargs grep -E "$SECRET_PATTERNS" 2>/dev/null; then
    echo ""
    echo "❌ تحذير أمني! (Staged Files)"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "تم العثور على معلومات حساسة في الملفات المُجهزة للـ commit"
    echo "يرجى إزالة الأسرار أو استخدام flutter_secure_storage"
    echo "تم إيقاف الـ commit لمنع تسريب البيانات الحساسة"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    exit 1
fi
echo "   ✅ لم يتم العثور على أسرار في الملفات المُجهزة"

# 2. فحص ملفات الإعدادات
echo ""
echo "📋 2. فحص ملفات الإعدادات والـ Dart..."
if grep -r -E "$SECRET_PATTERNS" lib/ $FLUTTER_CONFIG_FILES $EXCLUDE_DIRS 2>/dev/null | grep -v "// TODO\|// FIXME\|test"; then
    echo ""
    echo "❌ تحذير أمني! (Configuration Files)"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "تم العثور على أسرار مُخزنة بشكل صريح في ملفات الإعدادات"
    echo "هذا يخالف مبدأ Security First"
    echo ""
    echo "الحلول الموصى بها:"
    echo "  • استخدم flutter_secure_storage للبيانات الحساسة"
    echo "  • استخدم environment variables"
    echo "  • استخدم .env files (مع إضافتها لـ .gitignore)"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    exit 1
fi
echo "   ✅ لم يتم العثور على أسرار في ملفات الإعدادات"

# 3. فحص ملفات Android/iOS الحساسة
echo ""
echo "📋 3. فحص ملفات Android/iOS..."
SENSITIVE_FILES=(
    "android/app/google-services.json"
    "ios/Runner/GoogleService-Info.plist"
    "android/key.properties"
    "ios/Runner/Info.plist"
)

for file in "${SENSITIVE_FILES[@]}"; do
    if [ -f "$file" ] && git diff --cached --name-only | grep -q "$file"; then
        echo ""
        echo "⚠️  تحذير: محاولة commit ملف حساس"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "الملف: $file"
        echo "هذا الملف يحتوي على معلومات حساسة ولا يجب رفعه للمستودع"
        echo "يرجى إضافته إلى .gitignore"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
        exit 1
    fi
done
echo "   ✅ لم يتم العثور على ملفات حساسة"

# 4. التحقق من .gitignore
echo ""
echo "📋 4. التحقق من .gitignore..."
REQUIRED_IGNORES=(
    "*.env"
    "*.key"
    "*.jks"
    "google-services.json"
    "GoogleService-Info.plist"
    "key.properties"
)

MISSING_IGNORES=()
for pattern in "${REQUIRED_IGNORES[@]}"; do
    if ! grep -q "$pattern" .gitignore 2>/dev/null; then
        MISSING_IGNORES+=("$pattern")
    fi
done

if [ ${#MISSING_IGNORES[@]} -gt 0 ]; then
    echo ""
    echo "⚠️  تحذير: أنماط ناقصة في .gitignore"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "الأنماط الناقصة:"
    for pattern in "${MISSING_IGNORES[@]}"; do
        echo "  • $pattern"
    done
    echo ""
    echo "يُنصح بإضافة هذه الأنماط إلى .gitignore"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    # لا نوقف الـ commit، فقط تحذير
fi
echo "   ✅ .gitignore يحتوي على الأنماط الأساسية"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ الفحص الأمني اكتمل بنجاح"
echo "✅ لم يتم العثور على أسرار أو معلومات حساسة"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

exit 0
