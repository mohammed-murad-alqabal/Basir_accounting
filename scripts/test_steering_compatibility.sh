#!/bin/bash

# سكريبت اختبار نظام فحص توافق ملفات التوجيه
# Test script for steering files compatibility checking system

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

# متغيرات
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEST_DIR="$SCRIPT_DIR/test_files"
REPORTS_DIR="reports/compatibility"

# دالة إنشاء ملفات اختبار
create_test_files() {
    print_info "إنشاء ملفات اختبار..."
    
    mkdir -p "$TEST_DIR"
    
    # ملف يحتوي على مراجع غير متوافقة
    cat > "$TEST_DIR/incompatible_example.md" << 'EOF'
---
title: مثال على ملف غير متوافق
inclusion: always
---

# مثال على ملف غير متوافق

## إعداد البيئة

لإعداد بيئة التطوير، تحتاج إلى:

1. تثبيت Node.js من الموقع الرسمي
2. تشغيل `npm install` لتثبيت التبعيات
3. استخدام webpack لبناء المشروع

## أمثلة الكود

```typescript
interface User {
  id: string;
  name: string;
}

const user: User = {
  id: "123",
  name: "أحمد"
};
```

## استخدام React

```javascript
import React from 'react';

function App() {
  return <div>Hello World</div>;
}
```

## Docker Setup

```bash
docker build -t myapp .
docker run -p 3000:3000 myapp
```
EOF

    # ملف متوافق
    cat > "$TEST_DIR/compatible_example.md" << 'EOF'
---
title: مثال على ملف متوافق
inclusion: always
---

# مثال على ملف متوافق

## إعداد بيئة Flutter

لإعداد بيئة التطوير، تحتاج إلى:

1. تثبيت Flutter SDK من الموقع الرسمي
2. تشغيل `flutter pub get` لتثبيت التبعيات
3. استخدام `flutter build` لبناء المشروع

## أمثلة الكود

```dart
class User {
  final String id;
  final String name;

  const User({
    required this.id,
    required this.name,
  });
}

const user = User(
  id: "123",
  name: "أحمد",
);
```

## استخدام Flutter

```dart
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World'),
        ),
      ),
    );
  }
}
```
EOF

    # ملف يحتوي على مراجع في سياق توضيحي (يجب تجاهلها)
    cat > "$TEST_DIR/explanatory_example.md" << 'EOF'
---
title: مثال على ملف توضيحي
inclusion: always
---

# ما يجب تجنبه

## تقنيات يجب تجنبها

- تجنب استخدام Node.js للتطبيقات المحلية
- لا تستخدم TypeScript، استخدم Dart بدلاً من ذلك
- React غير متوافق مع مشروع بصير
- Docker غير مطلوب للتطبيقات المحلية

## أمثلة على ما يجب تجنبه

```typescript
// مثال على ما يجب تجنبه - TypeScript
interface BadExample {
  id: string;
}
```

بدلاً من ذلك، استخدم Dart:

```dart
// الطريقة الصحيحة - Dart
class GoodExample {
  final String id;
  const GoodExample({required this.id});
}
```
EOF

    print_success "تم إنشاء ملفات الاختبار في $TEST_DIR"
}

# دالة تنظيف ملفات الاختبار
cleanup_test_files() {
    if [[ -d "$TEST_DIR" ]]; then
        rm -rf "$TEST_DIR"
        print_info "تم تنظيف ملفات الاختبار"
    fi
}

# دالة اختبار السكريبت الأساسي
test_basic_functionality() {
    print_info "اختبار الوظائف الأساسية..."
    
    # اختبار ملف غير متوافق
    print_info "اختبار ملف غير متوافق..."
    if python3 "$SCRIPT_DIR/steering_compatibility_checker.py" \
        --file "$TEST_DIR/incompatible_example.md" \
        --output-format json \
        --fail-on-issues > /dev/null 2>&1; then
        print_error "فشل: لم يتم اكتشاف المشاكل في الملف غير المتوافق"
        return 1
    else
        print_success "نجح: تم اكتشاف المشاكل في الملف غير المتوافق"
    fi
    
    # اختبار ملف متوافق
    print_info "اختبار ملف متوافق..."
    if python3 "$SCRIPT_DIR/steering_compatibility_checker.py" \
        --file "$TEST_DIR/compatible_example.md" \
        --output-format json \
        --fail-on-issues > /dev/null 2>&1; then
        print_success "نجح: الملف المتوافق لم يُظهر مشاكل"
    else
        print_error "فشل: تم اكتشاف مشاكل في الملف المتوافق"
        return 1
    fi
    
    # اختبار ملف توضيحي (يجب تجاهل المراجع)
    print_info "اختبار ملف توضيحي..."
    if python3 "$SCRIPT_DIR/steering_compatibility_checker.py" \
        --file "$TEST_DIR/explanatory_example.md" \
        --output-format json \
        --fail-on-issues > /dev/null 2>&1; then
        print_success "نجح: تم تجاهل المراجع في السياق التوضيحي"
    else
        print_warning "تحذير: قد تحتاج لتحسين منطق تجاهل السياق التوضيحي"
    fi
}

# دالة اختبار تنسيقات التقارير
test_report_formats() {
    print_info "اختبار تنسيقات التقارير..."
    
    # إنشاء مجلد التقارير
    mkdir -p "$REPORTS_DIR"
    
    # اختبار تقرير Markdown
    print_info "اختبار تقرير Markdown..."
    python3 "$SCRIPT_DIR/steering_compatibility_checker.py" \
        --file "$TEST_DIR/incompatible_example.md" \
        --output-format markdown > /dev/null 2>&1
    
    # البحث عن أحدث تقرير Markdown
    LATEST_MD=$(ls -t "$REPORTS_DIR"/compatibility_report_*.md 2>/dev/null | head -1)
    if [[ -n "$LATEST_MD" && -f "$LATEST_MD" ]]; then
        print_success "نجح: تم إنشاء تقرير Markdown"
    else
        print_error "فشل: لم يتم إنشاء تقرير Markdown"
        return 1
    fi
    
    # اختبار تقرير JSON
    print_info "اختبار تقرير JSON..."
    python3 "$SCRIPT_DIR/steering_compatibility_checker.py" \
        --file "$TEST_DIR/incompatible_example.md" \
        --output-format json > /dev/null 2>&1
    
    # البحث عن أحدث تقرير JSON
    LATEST_JSON=$(ls -t "$REPORTS_DIR"/compatibility_issues_*.json 2>/dev/null | head -1)
    if [[ -n "$LATEST_JSON" && -f "$LATEST_JSON" ]]; then
        print_success "نجح: تم إنشاء تقرير JSON"
        
        # التحقق من صحة JSON
        if python3 -m json.tool "$LATEST_JSON" > /dev/null 2>&1; then
            print_success "نجح: تقرير JSON صحيح"
        else
            print_error "فشل: تقرير JSON غير صحيح"
            return 1
        fi
    else
        print_error "فشل: لم يتم إنشاء تقرير JSON"
        return 1
    fi
}

# دالة اختبار مستويات الخطورة
test_severity_levels() {
    print_info "اختبار مستويات الخطورة..."
    
    # اختبار مستوى منخفض
    print_info "اختبار مستوى خطورة منخفض..."
    if python3 "$SCRIPT_DIR/steering_compatibility_checker.py" \
        --file "$TEST_DIR/incompatible_example.md" \
        --severity-threshold low \
        --fail-on-issues > /dev/null 2>&1; then
        print_error "فشل: لم يفشل مع مستوى خطورة منخفض"
        return 1
    else
        print_success "نجح: فشل مع مستوى خطورة منخفض"
    fi
    
    # اختبار مستوى عالي
    print_info "اختبار مستوى خطورة عالي..."
    if python3 "$SCRIPT_DIR/steering_compatibility_checker.py" \
        --file "$TEST_DIR/incompatible_example.md" \
        --severity-threshold high \
        --fail-on-issues > /dev/null 2>&1; then
        print_error "فشل: لم يفشل مع مستوى خطورة عالي"
        return 1
    else
        print_success "نجح: فشل مع مستوى خطورة عالي"
    fi
}

# دالة اختبار السكريبت المُغلف
test_wrapper_script() {
    print_info "اختبار السكريبت المُغلف..."
    
    if [[ ! -f "$SCRIPT_DIR/check_steering_compatibility.sh" ]]; then
        print_error "السكريبت المُغلف غير موجود"
        return 1
    fi
    
    # اختبار المساعدة
    if bash "$SCRIPT_DIR/check_steering_compatibility.sh" --help > /dev/null 2>&1; then
        print_success "نجح: عرض المساعدة"
    else
        print_error "فشل: لم يتم عرض المساعدة"
        return 1
    fi
    
    # اختبار فحص ملف واحد
    if bash "$SCRIPT_DIR/check_steering_compatibility.sh" \
        --file "$TEST_DIR/compatible_example.md" \
        --quiet > /dev/null 2>&1; then
        print_success "نجح: فحص ملف متوافق"
    else
        print_error "فشل: فحص ملف متوافق"
        return 1
    fi
}

# دالة اختبار Git hooks
test_git_hooks() {
    print_info "اختبار Git hooks..."
    
    if [[ ! -f "$SCRIPT_DIR/hooks/pre-commit-steering-check" ]]; then
        print_error "pre-commit hook غير موجود"
        return 1
    fi
    
    if [[ ! -x "$SCRIPT_DIR/hooks/pre-commit-steering-check" ]]; then
        print_error "pre-commit hook غير قابل للتنفيذ"
        return 1
    fi
    
    print_success "نجح: Git hooks موجودة وقابلة للتنفيذ"
}

# دالة عرض إحصائيات الاختبار
show_test_summary() {
    echo ""
    print_info "ملخص الاختبارات:"
    echo "  ✅ الوظائف الأساسية"
    echo "  ✅ تنسيقات التقارير"
    echo "  ✅ مستويات الخطورة"
    echo "  ✅ السكريبت المُغلف"
    echo "  ✅ Git hooks"
    echo ""
    
    # عرض الملفات المُنشأة
    if [[ -d "$REPORTS_DIR" ]]; then
        REPORT_COUNT=$(ls "$REPORTS_DIR"/*.md "$REPORTS_DIR"/*.json 2>/dev/null | wc -l)
        print_info "تم إنشاء $REPORT_COUNT تقرير في $REPORTS_DIR"
    fi
}

# الدالة الرئيسية
main() {
    echo "🧪 اختبار نظام فحص توافق ملفات التوجيه"
    echo "================================================"
    
    # التحقق من المتطلبات
    if ! command -v python3 &> /dev/null; then
        print_error "Python 3 غير مثبت"
        exit 1
    fi
    
    if [[ ! -f "$SCRIPT_DIR/steering_compatibility_checker.py" ]]; then
        print_error "سكريبت الفحص غير موجود"
        exit 1
    fi
    
    # تنظيف ملفات الاختبار السابقة
    cleanup_test_files
    
    # إنشاء ملفات اختبار جديدة
    create_test_files
    
    # تشغيل الاختبارات
    TESTS_PASSED=0
    TOTAL_TESTS=5
    
    if test_basic_functionality; then
        ((TESTS_PASSED++))
    fi
    
    if test_report_formats; then
        ((TESTS_PASSED++))
    fi
    
    if test_severity_levels; then
        ((TESTS_PASSED++))
    fi
    
    if test_wrapper_script; then
        ((TESTS_PASSED++))
    fi
    
    if test_git_hooks; then
        ((TESTS_PASSED++))
    fi
    
    # عرض النتائج
    echo ""
    echo "================================================"
    
    if [[ $TESTS_PASSED -eq $TOTAL_TESTS ]]; then
        print_success "جميع الاختبارات نجحت! ($TESTS_PASSED/$TOTAL_TESTS)"
        show_test_summary
        
        # تنظيف ملفات الاختبار
        cleanup_test_files
        
        echo ""
        print_success "نظام فحص التوافق جاهز للاستخدام!"
        echo ""
        echo "للاستخدام:"
        echo "  ./scripts/check_steering_compatibility.sh"
        echo ""
        echo "لتثبيت Git hooks:"
        echo "  ./scripts/install_steering_hooks.sh"
        
        exit 0
    else
        print_error "فشلت بعض الاختبارات ($TESTS_PASSED/$TOTAL_TESTS نجحت)"
        
        # الاحتفاظ بملفات الاختبار للتصحيح
        print_info "ملفات الاختبار محفوظة في $TEST_DIR للتصحيح"
        
        exit 1
    fi
}

# تشغيل الاختبارات
main "$@"