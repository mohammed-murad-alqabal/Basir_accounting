#!/bin/bash

# سكريبت شامل لإصلاح جميع مشكلات flutter analyze
# فريق وكلاء تطوير مشروع بصير

echo "🔧 بدء إصلاح جميع المشكلات..."

# 1. إصلاح مشاكل scripts (استبدال print بـ debugPrint)
echo "📝 إصلاح مشاكل scripts..."
sed -i "s/print(/debugPrint(/g" scripts/generate_app_icon.dart

# 2. إصلاح مشاكل test files
echo "🧪 إصلاح مشاكل الاختبارات..."

# إصلاح prefer_int_literals في invoice_test.dart
sed -i 's/subtotal: \([0-9]*\)\.0,/subtotal: \1,/g' test/unit/features/invoices/domain/entities/invoice_test.dart
sed -i 's/tax: \([0-9]*\)\.0,/tax: \1,/g' test/unit/features/invoices/domain/entities/invoice_test.dart
sed -i 's/total: \([0-9]*\)\.0,/total: \1,/g' test/unit/features/invoices/domain/entities/invoice_test.dart
sed -i 's/discount: \([0-9]*\)\.0,/discount: \1,/g' test/unit/features/invoices/domain/entities/invoice_test.dart

# 3. تشغيل dart format
echo "✨ تنسيق الكود..."
dart format lib/ test/ --line-length=80

# 4. تشغيل dart fix
echo "🔨 تطبيق الإصلاحات التلقائية..."
dart fix --apply

echo "✅ تم إصلاح جميع المشكلات القابلة للإصلاح التلقائي!"
echo "🔍 تشغيل flutter analyze للتحقق..."
flutter analyze --no-pub
