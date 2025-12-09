#!/bin/bash

# سكريبت تحسين بيئة التطوير لمشروع بصير MVP
# المؤلف: فريق وكلاء تطوير مشروع بصير
# التاريخ: 1 ديسمبر 2025

set -e

echo "🚀 بدء تحسين بيئة التطوير لمشروع بصير MVP..."
echo ""

# الألوان
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# دالة للطباعة الملونة
print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "ℹ️  $1"
}

# 1. تحسين Git Configuration
echo "📦 المرحلة 1: تحسين إعدادات Git..."
echo ""

git config --global core.preloadindex true && print_success "تفعيل preloadindex"
git config --global core.fscache true && print_success "تفعيل fscache"
git config --global gc.auto 256 && print_success "تعيين gc.auto"
git config --global pack.threads 0 && print_success "تحسين pack.threads"
git config --global http.postBuffer 524288000 && print_success "تحسين HTTP buffer"
git config --global http.maxRequestBuffer 100M && print_success "تحسين max request buffer"
git config --global core.compression 9 && print_success "تفعيل الضغط"
git config --global core.looseCompression 9 && print_success "تحسين loose compression"
git config --global credential.helper 'cache --timeout=3600' && print_success "تفعيل credential cache"

echo ""
print_success "تم تحسين إعدادات Git بنجاح"
echo ""

# 2. تنظيف Flutter
echo "🧹 المرحلة 2: تنظيف Flutter..."
echo ""

if command -v flutter &> /dev/null; then
    flutter clean && print_success "تنظيف Flutter"
    flutter pub cache repair && print_success "إصلاح pub cache"
else
    print_warning "Flutter غير مثبت أو غير موجود في PATH"
fi

echo ""

# 3. تنظيف وتحسين Git Repository
echo "🗑️  المرحلة 3: تنظيف وتحسين المستودع..."
echo ""

# حفظ حجم .git قبل التحسين
BEFORE_SIZE=$(du -sh .git 2>/dev/null | cut -f1 || echo "unknown")
print_info "حجم .git قبل التحسين: $BEFORE_SIZE"

git gc --aggressive --prune=now && print_success "تنظيف وضغط المستودع"
git update-index --refresh && print_success "تحديث الفهرس"
git fsck --full > /dev/null 2>&1 && print_success "فحص سلامة المستودع"

# حجم .git بعد التحسين
AFTER_SIZE=$(du -sh .git 2>/dev/null | cut -f1 || echo "unknown")
print_info "حجم .git بعد التحسين: $AFTER_SIZE"

echo ""

# 4. تحديث Flutter (اختياري)
echo "⬆️  المرحلة 4: التحقق من تحديثات Flutter..."
echo ""

if command -v flutter &> /dev/null; then
    print_info "التحقق من التحديثات المتاحة..."
    flutter --version | head -1
    print_warning "لتحديث Flutter، قم بتشغيل: flutter upgrade"
else
    print_warning "Flutter غير مثبت"
fi

echo ""

# 5. إنشاء ملف .vscode/settings.json إذا لم يكن موجوداً
echo "⚙️  المرحلة 5: تحسين إعدادات VS Code..."
echo ""

if [ ! -d ".vscode" ]; then
    mkdir -p .vscode
    print_success "إنشاء مجلد .vscode"
fi

if [ ! -f ".vscode/settings.json" ]; then
    cat > .vscode/settings.json << 'EOF'
{
  "files.watcherExclude": {
    "**/.git/objects/**": true,
    "**/.git/subtree-cache/**": true,
    "**/node_modules/**": true,
    "**/.dart_tool/**": true,
    "**/build/**": true,
    "**/.pub-cache/**": true
  },
  "search.exclude": {
    "**/.dart_tool": true,
    "**/build": true,
    "**/.pub-cache": true
  },
  "dart.previewLsp": true,
  "dart.analysisServerFolding": false,
  "dart.lineLength": 80,
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll": true
  }
}
EOF
    print_success "إنشاء .vscode/settings.json"
else
    print_info ".vscode/settings.json موجود مسبقاً"
fi

echo ""

# 6. إحصائيات نهائية
echo "📊 الإحصائيات النهائية:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Git info
GIT_VERSION=$(git --version 2>/dev/null || echo "غير متاح")
print_info "Git: $GIT_VERSION"

# Flutter info
if command -v flutter &> /dev/null; then
    FLUTTER_VERSION=$(flutter --version 2>/dev/null | head -1 || echo "غير متاح")
    print_info "Flutter: $FLUTTER_VERSION"
else
    print_warning "Flutter: غير مثبت"
fi

# Dart info
if command -v dart &> /dev/null; then
    DART_VERSION=$(dart --version 2>&1 | head -1 || echo "غير متاح")
    print_info "Dart: $DART_VERSION"
fi

# Repository size
REPO_SIZE=$(du -sh . 2>/dev/null | cut -f1 || echo "unknown")
print_info "حجم المشروع: $REPO_SIZE"

# Git directory size
GIT_SIZE=$(du -sh .git 2>/dev/null | cut -f1 || echo "unknown")
print_info "حجم .git: $GIT_SIZE"

# Disk space
DISK_SPACE=$(df -h . 2>/dev/null | tail -1 | awk '{print $4}' || echo "unknown")
print_info "المساحة المتاحة: $DISK_SPACE"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

print_success "تم التحسين بنجاح! 🎉"
echo ""

# 7. توصيات إضافية
echo "💡 توصيات إضافية:"
echo ""
print_info "1. لتحسين الاتصال بـ GitHub، استخدم SSH بدلاً من HTTPS"
print_info "2. أضف aliases إلى ~/.bashrc للسرعة"
print_info "3. أعد تشغيل VS Code لتطبيق الإعدادات الجديدة"
print_info "4. راجع PERFORMANCE_OPTIMIZATION_GUIDE.md للمزيد من التحسينات"
echo ""

# 8. اختبار سريع
echo "🧪 اختبار سريع للأداء:"
echo ""

print_info "اختبار git status..."
time git status > /dev/null 2>&1 && print_success "git status يعمل بشكل طبيعي"

if command -v flutter &> /dev/null; then
    print_info "اختبار flutter doctor..."
    flutter doctor > /dev/null 2>&1 && print_success "flutter doctor يعمل بشكل طبيعي"
fi

echo ""
print_success "انتهى التحسين! استمتع ببيئة تطوير أسرع 🚀"
