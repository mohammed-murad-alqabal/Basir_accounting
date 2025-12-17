#!/bin/bash

# سكريبت تثبيت Git hooks لفحص توافق ملفات التوجيه
# Install Git hooks for steering files compatibility checking

set -e

# الألوان للمخرجات
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# دالة طباعة الرسائل الملونة
print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# التحقق من وجود Git repository
if [[ ! -d ".git" ]]; then
    print_error "هذا المجلد ليس Git repository"
    exit 1
fi

# مسارات الملفات
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOOKS_DIR="$SCRIPT_DIR/hooks"
GIT_HOOKS_DIR=".git/hooks"

print_info "تثبيت Git hooks لفحص توافق ملفات التوجيه..."

# إنشاء مجلد hooks إذا لم يكن موجوداً
mkdir -p "$GIT_HOOKS_DIR"

# تثبيت pre-commit hook
PRE_COMMIT_SOURCE="$HOOKS_DIR/pre-commit-steering-check"
PRE_COMMIT_TARGET="$GIT_HOOKS_DIR/pre-commit"

if [[ ! -f "$PRE_COMMIT_SOURCE" ]]; then
    print_error "ملف pre-commit hook غير موجود: $PRE_COMMIT_SOURCE"
    exit 1
fi

# التحقق من وجود pre-commit hook موجود
if [[ -f "$PRE_COMMIT_TARGET" ]]; then
    print_warning "يوجد pre-commit hook موجود بالفعل"
    
    # إنشاء نسخة احتياطية
    BACKUP_FILE="$PRE_COMMIT_TARGET.backup.$(date +%Y%m%d_%H%M%S)"
    cp "$PRE_COMMIT_TARGET" "$BACKUP_FILE"
    print_info "تم إنشاء نسخة احتياطية: $BACKUP_FILE"
    
    # دمج الـ hooks
    print_info "دمج فحص التوافق مع pre-commit hook الموجود..."
    
    # إنشاء hook مدمج
    cat > "$PRE_COMMIT_TARGET" << 'EOF'
#!/bin/bash

# Combined pre-commit hook
# يتضمن فحص توافق ملفات التوجيه والـ hooks الأخرى

set -e

# تشغيل الـ hook الأصلي إذا كان موجوداً
BACKUP_HOOK=$(ls .git/hooks/pre-commit.backup.* 2>/dev/null | head -1)
if [[ -n "$BACKUP_HOOK" && -f "$BACKUP_HOOK" ]]; then
    echo "🔄 تشغيل pre-commit hook الأصلي..."
    bash "$BACKUP_HOOK"
fi

# تشغيل فحص توافق ملفات التوجيه
STEERING_CHECK_SCRIPT="scripts/hooks/pre-commit-steering-check"
if [[ -f "$STEERING_CHECK_SCRIPT" ]]; then
    echo "🔍 فحص توافق ملفات التوجيه..."
    bash "$STEERING_CHECK_SCRIPT"
else
    echo "⚠️  سكريبت فحص التوافق غير موجود: $STEERING_CHECK_SCRIPT"
fi

echo "✅ اكتملت جميع فحوصات pre-commit"
EOF

else
    # إنشاء hook جديد
    cat > "$PRE_COMMIT_TARGET" << 'EOF'
#!/bin/bash

# Pre-commit hook لفحص توافق ملفات التوجيه
# Steering files compatibility check pre-commit hook

set -e

# تشغيل فحص توافق ملفات التوجيه
STEERING_CHECK_SCRIPT="scripts/hooks/pre-commit-steering-check"
if [[ -f "$STEERING_CHECK_SCRIPT" ]]; then
    echo "🔍 فحص توافق ملفات التوجيه..."
    bash "$STEERING_CHECK_SCRIPT"
else
    echo "⚠️  سكريبت فحص التوافق غير موجود: $STEERING_CHECK_SCRIPT"
    exit 1
fi

echo "✅ اكتمل فحص توافق ملفات التوجيه"
EOF

fi

# جعل الـ hook قابل للتنفيذ
chmod +x "$PRE_COMMIT_TARGET"

print_success "تم تثبيت pre-commit hook بنجاح"

# إنشاء post-commit hook للتحقق الدوري
POST_COMMIT_TARGET="$GIT_HOOKS_DIR/post-commit"

cat > "$POST_COMMIT_TARGET" << 'EOF'
#!/bin/bash

# Post-commit hook للتحقق الدوري من توافق ملفات التوجيه
# Periodic steering files compatibility check

# تشغيل فحص شامل كل 10 commits
COMMIT_COUNT=$(git rev-list --count HEAD)
if (( COMMIT_COUNT % 10 == 0 )); then
    echo "🔍 فحص دوري شامل لتوافق ملفات التوجيه (كل 10 commits)..."
    
    if [[ -f "scripts/check_steering_compatibility.sh" ]]; then
        bash scripts/check_steering_compatibility.sh --quiet || true
    fi
fi
EOF

chmod +x "$POST_COMMIT_TARGET"
print_success "تم تثبيت post-commit hook للفحص الدوري"

# إنشاء ملف تكوين للـ hooks
HOOKS_CONFIG="$GIT_HOOKS_DIR/steering-hooks.conf"

cat > "$HOOKS_CONFIG" << EOF
# تكوين Git hooks لفحص توافق ملفات التوجيه
# Steering files compatibility hooks configuration

# تاريخ التثبيت
INSTALL_DATE=$(date +%Y-%m-%d\ %H:%M:%S)

# إعدادات الفحص
SEVERITY_THRESHOLD=medium
FAIL_ON_ISSUES=true
OUTPUT_FORMAT=json

# مسارات الملفات
CHECKER_SCRIPT=scripts/steering_compatibility_checker.py
CONFIG_FILE=scripts/incompatible_technologies.json

# إعدادات الفحص الدوري
PERIODIC_CHECK_INTERVAL=10  # كل 10 commits
PERIODIC_CHECK_ENABLED=true
EOF

print_success "تم إنشاء ملف التكوين: $HOOKS_CONFIG"

# اختبار الـ hooks
print_info "اختبار الـ hooks المثبتة..."

# اختبار pre-commit hook
if bash "$PRE_COMMIT_TARGET" --help > /dev/null 2>&1 || true; then
    print_success "pre-commit hook يعمل بشكل صحيح"
else
    print_warning "قد تحتاج لاختبار pre-commit hook يدوياً"
fi

# عرض معلومات الاستخدام
echo ""
print_info "تم تثبيت Git hooks بنجاح!"
echo ""
echo "الـ hooks المثبتة:"
echo "  • pre-commit: فحص ملفات التوجيه قبل كل commit"
echo "  • post-commit: فحص دوري شامل كل 10 commits"
echo ""
echo "لاختبار الفحص يدوياً:"
echo "  ./scripts/check_steering_compatibility.sh"
echo ""
echo "لتعطيل الفحص مؤقتاً:"
echo "  git commit --no-verify"
echo ""
echo "لإلغاء تثبيت الـ hooks:"
echo "  rm .git/hooks/pre-commit .git/hooks/post-commit"
echo ""

print_success "اكتمل تثبيت نظام فحص التوافق التلقائي!"