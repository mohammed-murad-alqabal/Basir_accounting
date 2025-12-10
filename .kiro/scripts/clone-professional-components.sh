#!/bin/bash

# سكريبت استنساخ المكونات الاحترافية لـ Kiro
# المؤلف: فريق وكلاء تطوير مشروع بصير
# التاريخ: 10 ديسمبر 2025

set -e  # إيقاف عند أي خطأ

# الألوان للإخراج
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# دالة طباعة ملونة
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# التحقق من وجود git
if ! command -v git &> /dev/null; then
    print_error "Git غير مثبت. يرجى تثبيت Git أولاً."
    exit 1
fi

print_status "🚀 بدء استنساخ المكونات الاحترافية لـ Kiro..."

# إنشاء مجلد مؤقت
TEMP_DIR="temp/kiro-sources"
mkdir -p "$TEMP_DIR"

print_status "📁 إنشاء البنية الأساسية..."

# إنشاء البنية الجديدة
mkdir -p .kiro/{steering/technologies,hooks/{automatic,manual,optional},prompts/models/{openai,anthropic,bedrock,ollama},templates/specs,rules,security,powers}

print_success "✅ تم إنشاء البنية الأساسية"

# قائمة المستودعات للاستنساخ
declare -A REPOS=(
    ["best-practices"]="https://github.com/awsdataarchitect/kiro-best-practices.git"
    ["ears-methodology"]="https://github.com/jasonkneen/kiro.git"
    ["multi-ai"]="https://github.com/ghuntley/amazon-kiro.kiro-agent-source-code-analysis.git"
    ["powers"]="https://github.com/kirodotdev/powers.git"
    ["security-rules"]="https://github.com/matank001/cursor-security-rules.git"
    ["cursor-templates"]="https://github.com/sangampandey/cursor-templates.git"
)

# استنساخ المستودعات
print_status "📥 جاري استنساخ المستودعات المرجعية..."

for repo_name in "${!REPOS[@]}"; do
    repo_url="${REPOS[$repo_name]}"
    print_status "استنساخ $repo_name من $repo_url"
    
    if git clone "$repo_url" "$TEMP_DIR/$repo_name" 2>/dev/null; then
        print_success "✅ تم استنساخ $repo_name بنجاح"
    else
        print_warning "⚠️  فشل في استنساخ $repo_name - سيتم تخطيه"
    fi
done

print_status "📋 جاري نسخ المكونات..."

# نسخ Steering Documents
print_status "نسخ Steering Documents..."
STEERING_COUNT=0

if [ -d "$TEMP_DIR/best-practices/.kiro/steering" ]; then
    for file in "$TEMP_DIR/best-practices/.kiro/steering"/*.md; do
        if [ -f "$file" ]; then
            filename=$(basename "$file")
            cp "$file" ".kiro/steering/technologies/$filename"
            ((STEERING_COUNT++))
        fi
    done
    print_success "✅ تم نسخ $STEERING_COUNT ملف steering"
else
    print_warning "⚠️  مجلد steering غير موجود في best-practices"
fi

# نسخ Agent Hooks
print_status "نسخ Agent Hooks..."
HOOKS_COUNT=0

for hook_type in automatic manual optional; do
    if [ -d "$TEMP_DIR/best-practices/.kiro/hooks/$hook_type" ]; then
        cp -r "$TEMP_DIR/best-practices/.kiro/hooks/$hook_type"/* ".kiro/hooks/$hook_type/" 2>/dev/null || true
        count=$(find ".kiro/hooks/$hook_type" -name "*.hook" 2>/dev/null | wc -l)
        HOOKS_COUNT=$((HOOKS_COUNT + count))
    fi
done

print_success "✅ تم نسخ $HOOKS_COUNT hook"

# نسخ Model-Specific Prompts
print_status "نسخ Model-Specific Prompts..."
PROMPTS_COUNT=0

if [ -d "$TEMP_DIR/multi-ai/.kiro/prompts/models" ]; then
    cp -r "$TEMP_DIR/multi-ai/.kiro/prompts/models"/* ".kiro/prompts/models/" 2>/dev/null || true
    PROMPTS_COUNT=$(find ".kiro/prompts/models" -name "*.md" 2>/dev/null | wc -l)
    print_success "✅ تم نسخ $PROMPTS_COUNT model prompt"
else
    print_warning "⚠️  مجلد model prompts غير موجود"
fi

# نسخ EARS Templates
print_status "نسخ EARS Templates..."
TEMPLATES_COUNT=0

if [ -d "$TEMP_DIR/ears-methodology/.kiro/templates" ]; then
    cp -r "$TEMP_DIR/ears-methodology/.kiro/templates"/* ".kiro/templates/" 2>/dev/null || true
    TEMPLATES_COUNT=$(find ".kiro/templates" -name "*.md" 2>/dev/null | wc -l)
    print_success "✅ تم نسخ $TEMPLATES_COUNT template"
else
    print_warning "⚠️  مجلد templates غير موجود"
fi

# نسخ Powers System
print_status "نسخ Powers System..."
if [ -d "$TEMP_DIR/powers" ]; then
    cp -r "$TEMP_DIR/powers"/* ".kiro/powers/" 2>/dev/null || true
    print_success "✅ تم نسخ Powers System"
else
    print_warning "⚠️  مجلد Powers غير موجود"
fi

# نسخ Security Rules
print_status "نسخ Security Rules..."
if [ -d "$TEMP_DIR/security-rules" ]; then
    cp -r "$TEMP_DIR/security-rules"/* ".kiro/security/" 2>/dev/null || true
    print_success "✅ تم نسخ Security Rules"
else
    print_warning "⚠️  مجلد Security Rules غير موجود"
fi

# التخصيص للمشروع العربي
print_status "🎨 تخصيص الملفات للمشروع العربي..."

# إضافة هوية المشروع
PROJECT_HEADER="**المشروع:** بصير MVP
**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**المصدر:** مكيف من مصادر مجتمع Kiro المعتمدة
**التاريخ:** $(date '+%d %B %Y')

---

"

# تطبيق الهوية على ملفات steering
find .kiro/steering/technologies -name "*.md" -exec sh -c '
    temp_file=$(mktemp)
    echo "'"$PROJECT_HEADER"'" > "$temp_file"
    cat "$1" >> "$temp_file"
    mv "$temp_file" "$1"
' _ {} \;

# إضافة معايير Flutter/Dart المخصصة
cat > .kiro/steering/technologies/flutter-dart-standards.md << 'EOF'
**المشروع:** بصير MVP
**المؤلف:** فريق وكلاء تطوير مشروع بصير
**التاريخ:** 10 ديسمبر 2025

---

# معايير Flutter/Dart للمشروع

## معايير Dart

### التنسيق والأسلوب
- استخدم `dart format` للتنسيق التلقائي
- اتبع `effective_dart` guidelines
- استخدم `const` constructors حيثما أمكن
- استخدم `final` للمتغيرات غير القابلة للتغيير

### التسمية
- Classes: PascalCase (`CustomerRepository`)
- Functions/Variables: camelCase (`getAllCustomers`)
- Constants: lowerCamelCase (`maxRetries`)
- Private members: underscore prefix (`_privateMethod`)

## معايير Flutter

### البنية والتنظيم
- اتبع Clean Architecture (3 layers)
- استخدم feature-first organization
- فصل UI عن Business Logic

### إدارة الحالة
- استخدم Riverpod كمزود رئيسي للحالة
- تجنب setState في الويدجت المعقدة
- استخدم StateNotifier للحالات المعقدة

### الأداء
- استخدم `const` widgets حيثما أمكن
- تجنب إعادة البناء غير الضرورية
- استخدم `ListView.builder` للقوائم الطويلة

### قاعدة البيانات المحلية
- استخدم Isar للقاعدة المحلية
- طبق indexing للاستعلامات السريعة
- استخدم transactions للعمليات المعقدة

## الاختبارات

### Unit Tests
- اختبر كل public function
- استخدم mocks للـ dependencies
- حقق 70%+ test coverage

### Widget Tests
- اختبر المسارات الحرجة
- تحقق من UI interactions
- اختبر حالات الخطأ

### Integration Tests
- اختبر user journeys كاملة
- تحقق من تدفق البيانات
- اختبر الأداء

## الأمان

### حماية البيانات
- استخدم `flutter_secure_storage` للبيانات الحساسة
- شفّر البيانات المحلية المهمة
- تحقق من صحة جميع المدخلات

### الشبكة
- استخدم HTTPS دائماً
- طبق certificate pinning
- تحقق من صحة الاستجابات

## التوثيق

### DartDoc
- وثّق جميع public APIs
- أضف أمثلة في التوثيق
- اشرح المعاملات والقيم المرجعة

### README
- اشرح كيفية تشغيل المشروع
- أضف متطلبات النظام
- وثّق عملية البناء والنشر

EOF

print_success "✅ تم إنشاء معايير Flutter/Dart المخصصة"

# تنظيف الملفات المؤقتة
print_status "🧹 تنظيف الملفات المؤقتة..."
rm -rf "$TEMP_DIR"

# إحصائيات النهائية
print_status "📊 إحصائيات الاستنساخ النهائية:"
echo "   📋 Steering Documents: $STEERING_COUNT ملف"
echo "   🔗 Agent Hooks: $HOOKS_COUNT hook"
echo "   🤖 Model Prompts: $PROMPTS_COUNT prompt"  
echo "   📝 Templates: $TEMPLATES_COUNT template"

# التحقق من البنية النهائية
print_status "🔍 التحقق من البنية النهائية..."
if command -v tree &> /dev/null; then
    tree .kiro -L 3
else
    find .kiro -type d | head -20
fi

print_success "🎉 تم إكمال استنساخ ودمج المكونات الاحترافية بنجاح!"
print_success "💡 يمكنك الآن استخدام جميع المكونات الجاهزة فوراً"

echo ""
echo "🚀 الخطوات التالية:"
echo "   1. راجع الملفات المنسوخة في .kiro/"
echo "   2. خصص المكونات حسب احتياجاتك"
echo "   3. ابدأ استخدام الـ hooks والـ steering documents"
echo "   4. طبق الـ model prompts في تطويرك"
echo ""
echo "📖 للمزيد من المعلومات، راجع:"
echo "   .kiro/docs/PROFESSIONAL_KIRO_REFERENCES_ANALYSIS.md"