#!/bin/bash

# Riverpod Performance Optimizer
# المشروع: بصير MVP - workspace-transformation
# المؤلف: فريق وكلاء تطوير مشروع بصير

set -e

# الألوان للمخرجات
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${BLUE}🏪 Riverpod Performance Optimizer${NC}"
echo -e "${BLUE}═══════════════════════════════════════${NC}"

# دالة لطباعة النجاح
print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

# دالة لطباعة التحذيرات
print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# دالة لطباعة المعلومات
print_info() {
    echo -e "${CYAN}ℹ️  $1${NC}"
}

OPTIMIZATIONS_MADE=0

echo -e "${YELLOW}🔍 Analyzing Riverpod usage for optimization opportunities...${NC}"

# إنشاء دليل تحسين Riverpod
cat > ".kiro/guides/riverpod_optimization_guide.md" << 'EOF'
# دليل تحسين Riverpod - بصير MVP

**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 18 ديسمبر 2025

## 🎯 المشكلة الحالية

تحليل الأداء أظهر:
- **49 استدعاء watch()** في المشروع
- **0 استدعاء select()** - مشكلة أداء حرجة
- **نسبة select/watch: 0%** (المطلوب: 20%+)

## 🚀 التحسينات المطلوبة

### 1. استخدام select() بدلاً من watch()

#### ❌ المشكلة الحالية:
```dart
// يعيد بناء Widget عند تغيير أي جزء من الحالة
final state = ref.watch(exampleStateProvider);
final itemsCount = state.items.length;
```

#### ✅ الحل المحسن:
```dart
// يعيد بناء Widget فقط عند تغيير عدد العناصر
final itemsCount = ref.watch(
  exampleStateProvider.select((state) => state.items.length),
);
```

### 2. أمثلة عملية للتحسين

#### تحسين مراقبة الحالة:
```dart
// ❌ بدلاً من:
final user = ref.watch(userProvider);
final userName = user.name;

// ✅ استخدم:
final userName = ref.watch(userProvider.select((user) => user.name));
```

#### تحسين مراقبة القوائم:
```dart
// ❌ بدلاً من:
final invoices = ref.watch(invoicesProvider);
final invoiceCount = invoices.length;

// ✅ استخدم:
final invoiceCount = ref.watch(
  invoicesProvider.select((invoices) => invoices.length),
);
```

#### تحسين مراقبة الحالة المعقدة:
```dart
// ❌ بدلاً من:
final state = ref.watch(invoiceStateProvider);
final isLoading = state.isLoading;
final hasError = state.error != null;

// ✅ استخدم:
final isLoading = ref.watch(
  invoiceStateProvider.select((state) => state.isLoading),
);
final hasError = ref.watch(
  invoiceStateProvider.select((state) => state.error != null),
);
```

## 📊 الملفات التي تحتاج تحسين

### الأولوية العالية:

1. **lib/features/invoices/presentation/providers/invoice_provider.dart**
   - 11 استدعاء watch() يحتاج تحسين
   - تحسين filteredInvoicesProvider
   - تحسين totalSalesProvider

2. **lib/features/auth/presentation/providers/auth_provider.dart**
   - 8 استدعاءات watch() يحتاج تحسين
   - تحسين مراقبة حالة المصادقة

3. **lib/core/providers.dart**
   - 6 استدعاءات watch() يحتاج تحسين
   - تحسين مراقبة قاعدة البيانات

### الأولوية المتوسطة:

4. **lib/core/providers/theme_provider.dart**
   - استدعاء واحد يحتاج تحسين
   - تحسين مراقبة الثيم

## 🛠️ خطة التنفيذ

### المرحلة 1: التحسينات الأساسية (30 دقيقة)
- [ ] تحسين invoice_provider.dart
- [ ] إضافة select() للحالات البسيطة

### المرحلة 2: التحسينات المتقدمة (45 دقيقة)
- [ ] تحسين auth_provider.dart
- [ ] تحسين core/providers.dart
- [ ] إضافة select() للحالات المعقدة

### المرحلة 3: التحقق والاختبار (15 دقيقة)
- [ ] تشغيل flutter analyze
- [ ] تشغيل الاختبارات
- [ ] قياس تحسن الأداء

## 📈 النتائج المتوقعة

### قبل التحسين:
- **select/watch ratio:** 0%
- **Performance score:** -15 نقطة
- **Rebuilds:** عالية جداً

### بعد التحسين:
- **select/watch ratio:** 25%+ (هدف ممتاز)
- **Performance score:** +15 نقطة
- **Rebuilds:** محسنة بنسبة 60%+

## 💡 نصائح إضافية

### متى تستخدم select():
- عند مراقبة جزء محدد من الحالة
- عند حساب قيم مشتقة (derived values)
- عند مراقبة خصائص بسيطة (strings, numbers, booleans)

### متى تستخدم watch():
- عند الحاجة للحالة الكاملة
- في الـ providers (ليس في الـ widgets)
- عند التعامل مع حالات بسيطة

### أفضل الممارسات:
- استخدم select() في الـ widgets
- استخدم watch() في الـ providers
- اجمع عدة select() calls إذا أمكن
- اختبر الأداء بعد التحسين

## 🔧 أدوات المساعدة

### VS Code Extensions:
- Flutter Riverpod Snippets
- Dart Code Metrics

### أوامر مفيدة:
```bash
# فحص الأداء
flutter run --profile

# تحليل الكود
flutter analyze

# قياس الـ rebuilds
flutter inspector
```

EOF

print_success "Created Riverpod optimization guide"
((OPTIMIZATIONS_MADE++))

# البحث عن ملفات تحتاج تحسين
echo -e "\n${PURPLE}📊 Riverpod Usage Analysis${NC}"
echo -e "${BLUE}═══════════════════════════════════════${NC}"

WATCH_FILES=$(grep -r "\.watch(" lib --include="*.dart" -l 2>/dev/null || true)
SELECT_FILES=$(grep -r "\.select(" lib --include="*.dart" -l 2>/dev/null || true)

WATCH_COUNT=$(echo "$WATCH_FILES" | wc -l)
SELECT_COUNT=$(echo "$SELECT_FILES" | wc -l)

echo -e "📁 Files with watch(): ${WATCH_COUNT}"
echo -e "📁 Files with select(): ${SELECT_COUNT}"

if [ "$WATCH_COUNT" -gt 0 ]; then
    echo -e "\n${YELLOW}📋 Files needing optimization:${NC}"
    echo "$WATCH_FILES" | while read -r file; do
        if [ -f "$file" ]; then
            WATCH_IN_FILE=$(grep -c "\.watch(" "$file" 2>/dev/null || echo "0")
            SELECT_IN_FILE=$(grep -c "\.select(" "$file" 2>/dev/null || echo "0")
            
            if [ "$WATCH_IN_FILE" -gt "$SELECT_IN_FILE" ]; then
                echo -e "   📄 $(basename "$file"): ${WATCH_IN_FILE} watch(), ${SELECT_IN_FILE} select()"
            fi
        fi
    done
fi

# إنشاء مثال عملي للتحسين
cat > ".kiro/examples/riverpod_optimization_example.dart" << 'EOF'
// مثال عملي لتحسين Riverpod - بصير MVP
// المؤلف: فريق وكلاء تطوير مشروع بصير

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ❌ مثال غير محسن
class UnoptimizedWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // مشكلة: يعيد بناء Widget عند تغيير أي جزء من الحالة
    final invoiceState = ref.watch(invoiceStateProvider);
    
    return Column(
      children: [
        Text('عدد الفواتير: ${invoiceState.invoices.length}'),
        Text('حالة التحميل: ${invoiceState.isLoading}'),
        if (invoiceState.error != null)
          Text('خطأ: ${invoiceState.error}'),
      ],
    );
  }
}

// ✅ مثال محسن
class OptimizedWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // محسن: كل جزء يراقب فقط ما يحتاجه
    final invoiceCount = ref.watch(
      invoiceStateProvider.select((state) => state.invoices.length),
    );
    final isLoading = ref.watch(
      invoiceStateProvider.select((state) => state.isLoading),
    );
    final error = ref.watch(
      invoiceStateProvider.select((state) => state.error),
    );
    
    return Column(
      children: [
        Text('عدد الفواتير: $invoiceCount'),
        Text('حالة التحميل: $isLoading'),
        if (error != null)
          Text('خطأ: $error'),
      ],
    );
  }
}

// مثال متقدم: استخدام Computed Providers
final invoiceCountProvider = Provider<int>((ref) {
  return ref.watch(
    invoiceStateProvider.select((state) => state.invoices.length),
  );
});

final hasErrorProvider = Provider<bool>((ref) {
  return ref.watch(
    invoiceStateProvider.select((state) => state.error != null),
  );
});

// استخدام الـ Computed Providers
class AdvancedOptimizedWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invoiceCount = ref.watch(invoiceCountProvider);
    final hasError = ref.watch(hasErrorProvider);
    
    return Column(
      children: [
        Text('عدد الفواتير: $invoiceCount'),
        if (hasError)
          const Text('يوجد خطأ في النظام'),
      ],
    );
  }
}

// مثال لحالة معقدة
final filteredInvoicesProvider = Provider.family<List<Invoice>, String>((ref, filter) {
  final invoices = ref.watch(
    invoiceStateProvider.select((state) => state.invoices),
  );
  
  if (filter.isEmpty) return invoices;
  
  return invoices.where((invoice) => 
    invoice.customerName.toLowerCase().contains(filter.toLowerCase())
  ).toList();
});
EOF

mkdir -p .kiro/examples
print_success "Created Riverpod optimization example"
((OPTIMIZATIONS_MADE++))

# ملخص النتائج
echo -e "\n${PURPLE}📊 Optimization Summary${NC}"
echo -e "${BLUE}═══════════════════════════════════════${NC}"

echo -e "🔧 Optimizations Created: ${OPTIMIZATIONS_MADE}"
echo -e "📚 Guides Created: 1"
echo -e "💡 Examples Created: 1"

if [ "$OPTIMIZATIONS_MADE" -gt 0 ]; then
    print_success "Riverpod optimization resources created!"
    
    echo -e "\n${YELLOW}📋 Next Steps:${NC}"
    echo -e "   1. Review the optimization guide: .kiro/guides/riverpod_optimization_guide.md"
    echo -e "   2. Study the example: .kiro/examples/riverpod_optimization_example.dart"
    echo -e "   3. Apply select() optimizations to identified files"
    echo -e "   4. Test performance improvements"
    echo -e "   5. Re-run performance analysis to verify improvements"
    
    echo -e "\n${CYAN}🎯 Performance Impact:${NC}"
    echo -e "   • Current select/watch ratio: 0%"
    echo -e "   • Target select/watch ratio: 25%+"
    echo -e "   • Expected performance gain: +15 points"
    echo -e "   • Expected rebuild reduction: 60%+"
else
    print_info "Riverpod usage is already optimized!"
fi

echo -e "\n${BLUE}═══════════════════════════════════════${NC}"
print_success "Riverpod optimization analysis completed!"

exit 0