# دليل صيانة التبعيات - مشروع بصير

**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 13 ديسمبر 2025  
**الإصدار:** 1.0

---

## 🎯 الهدف من هذا الدليل

هذا الدليل يوفر إرشادات شاملة لصيانة تبعيات مشروع بصير وضمان استقراره طويل المدى.

---

## 🚨 علامات التحذير المبكر

### متى تحتاج لصيانة فورية؟

- ❌ ظهور أخطاء جديدة بدون تغييرات في الكود
- ⚠️ بطء في أداء التطبيق
- 🔄 فشل في عملية البناء (Build)
- 📦 رسائل تحذير من التبعيات
- 🧪 فشل الاختبارات المُعتادة

---

## 🛠️ أدوات الصيانة

### 1. السكريبت التلقائي

```bash
# تشغيل المراقبة التلقائية
./scripts/maintenance/dependency_monitor.sh
```

### 2. الأوامر اليدوية

```bash
# فحص سريع
flutter doctor
flutter analyze
flutter pub outdated

# تنظيف شامل
flutter clean
flutter pub get

# اختبار سريع
flutter test test/unit/domain/entities/ --reporter=compact
```

---

## 📋 إجراءات الصيانة الدورية

### يومياً (للمطورين النشطين)

```bash
# فحص سريع قبل بدء العمل
flutter analyze
```

### أسبوعياً

```bash
# تشغيل السكريبت التلقائي
./scripts/maintenance/dependency_monitor.sh

# مراجعة التحديثات المتاحة
flutter pub outdated
```

### شهرياً

```bash
# صيانة شاملة
flutter clean
flutter pub get
flutter test --reporter=compact

# مراجعة النسخ الاحتياطية
ls -la .dependency_backups/
```

### ربع سنوياً

- مراجعة شاملة للتبعيات
- تحديث الحزم الكبيرة (Major Updates)
- تقييم الحزم المتوقفة واستبدالها

---

## 🔧 إجراءات الطوارئ

### عند ظهور أخطاء مفاجئة

#### الخطوة 1: التشخيص السريع

```bash
# فحص الحالة العامة
flutter doctor -v
flutter analyze
```

#### الخطوة 2: التنظيف الآمن

```bash
# إنشاء نسخة احتياطية
cp pubspec.yaml .dependency_backups/pubspec_emergency_$(date +%Y%m%d_%H%M%S).yaml

# تنظيف شامل
flutter clean
rm -rf build/ .dart_tool/
flutter pub get
```

#### الخطوة 3: الاختبار

```bash
# اختبار سريع
flutter analyze
flutter test test/unit/domain/entities/ --reporter=compact
```

#### الخطوة 4: الاستعادة (إذا لزم الأمر)

```bash
# استعادة من النسخة الاحتياطية الأخيرة
cp .dependency_backups/pubspec_YYYYMMDD_HHMMSS.yaml pubspec.yaml
flutter pub get
```

---

## 📊 إدارة التحديثات

### تصنيف التحديثات

#### 🟢 آمنة (تطبيق فوري)

- Patch updates (1.0.0 → 1.0.1)
- Bug fixes
- Security patches

#### 🟡 متوسطة (اختبار أولاً)

- Minor updates (1.0.0 → 1.1.0)
- New features
- Performance improvements

#### 🔴 خطيرة (مراجعة شاملة)

- Major updates (1.0.0 → 2.0.0)
- Breaking changes
- API changes

### استراتيجية التحديث

```bash
# للتحديثات الآمنة
flutter pub upgrade

# للتحديثات الكبيرة (بحذر)
flutter pub upgrade --major-versions

# لتحديث حزمة واحدة
flutter pub upgrade package_name
```

---

## 🚫 الحزم المتوقفة

### الحزم المُحددة للاستبدال:

| الحزمة الحالية      | البديل المُقترح         | الأولوية |
| ------------------- | ----------------------- | -------- |
| `js`                | `dart:js_interop`       | عالية    |
| `build_resolvers`   | alternatives            | متوسطة   |
| `build_runner_core` | managed by build_runner | منخفضة   |

### خطة الاستبدال:

1. **البحث**: تحديد البديل المناسب
2. **الاختبار**: اختبار البديل في بيئة منفصلة
3. **التطبيق**: تطبيق التغيير تدريجياً
4. **التحقق**: التأكد من عمل جميع الوظائف

---

## 📁 إدارة النسخ الاحتياطية

### هيكل النسخ الاحتياطية:

```
.dependency_backups/
├── pubspec_20251213_before_maintenance.yaml
├── pubspec_20251213_before_maintenance.lock
├── pubspec_20251213_monitor.yaml
└── pubspec_20251213_monitor.lock
```

### قواعد الاحتفاظ:

- **يومية**: 7 أيام
- **أسبوعية**: 4 أسابيع
- **شهرية**: 12 شهر
- **ربع سنوية**: دائمة

### تنظيف تلقائي:

```bash
# حذف النسخ الأقدم من 30 يوم
find .dependency_backups/ -name "pubspec_*" -mtime +30 -delete
```

---

## 🧪 استراتيجية الاختبار

### مستويات الاختبار:

#### 1. اختبار سريع (< 1 دقيقة)

```bash
flutter analyze
flutter test test/unit/domain/entities/ --reporter=compact
```

#### 2. اختبار متوسط (< 5 دقائق)

```bash
flutter test test/unit/ --reporter=compact
```

#### 3. اختبار شامل (< 15 دقيقة)

```bash
flutter test --reporter=compact
```

### معايير النجاح:

- ✅ 0 أخطاء في التحليل
- ✅ 95%+ نجاح في الاختبارات
- ✅ لا توجد رسائل تحذير حرجة

---

## 📈 مراقبة الأداء

### مؤشرات مهمة:

| المؤشر          | القيمة المثلى | التحذير    |
| --------------- | ------------- | ---------- |
| وقت التحليل     | < 5 ثواني     | > 10 ثواني |
| نجاح الاختبارات | 95%+          | < 90%      |
| حجم التطبيق     | < 50 MB       | > 100 MB   |
| وقت البناء      | < 2 دقيقة     | > 5 دقائق  |

### أدوات المراقبة:

```bash
# قياس وقت التحليل
time flutter analyze

# قياس حجم التطبيق
flutter build apk --analyze-size

# مراقبة الذاكرة
flutter run --profile
```

---

## 🔍 استكشاف الأخطاء

### مشاكل شائعة وحلولها:

#### 1. "Version solving failed"

```bash
# الحل
flutter clean
rm pubspec.lock
flutter pub get
```

#### 2. "Build failed"

```bash
# الحل
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

#### 3. "Tests failing randomly"

```bash
# الحل
flutter test --concurrency=1
```

#### 4. "Slow performance"

```bash
# الحل
flutter clean
flutter pub get
flutter build apk --release
```

---

## 📞 جهات الاتصال والدعم

### للمساعدة الفورية:

- **الفريق التقني**: فريق وكلاء تطوير مشروع بصير
- **التوثيق**: `docs/reports/maintenance/`
- **السجلات**: `logs/dependency_monitor_*.log`

### للمراجعة الدورية:

- **أسبوعياً**: مراجعة تقارير المراقبة
- **شهرياً**: اجتماع فريق الصيانة
- **ربع سنوياً**: تقييم شامل للاستراتيجية

---

## 📚 مراجع إضافية

### الوثائق الرسمية:

- [Flutter Dependency Management](https://docs.flutter.dev/development/packages-and-plugins/using-packages)
- [Pub.dev Package Scoring](https://pub.dev/help/scoring)
- [Flutter Performance Best Practices](https://docs.flutter.dev/perf/best-practices)

### أدوات مفيدة:

- [Pub Outdated](https://dart.dev/tools/pub/cmd/pub-outdated)
- [Flutter Analyze](https://docs.flutter.dev/testing/code-debugging#the-dart-analyzer)
- [Dependency Validator](https://pub.dev/packages/dependency_validator)

---

## ✅ قائمة التحقق السريعة

### قبل بدء العمل:

- [ ] تشغيل `flutter analyze`
- [ ] فحص آخر تقرير مراقبة
- [ ] التأكد من وجود نسخة احتياطية حديثة

### بعد التحديثات:

- [ ] تشغيل `flutter clean && flutter pub get`
- [ ] تشغيل `flutter analyze`
- [ ] تشغيل الاختبارات الأساسية
- [ ] إنشاء نسخة احتياطية جديدة

### عند المشاكل:

- [ ] فحص السجلات
- [ ] تطبيق إجراءات الطوارئ
- [ ] توثيق المشكلة والحل
- [ ] تحديث هذا الدليل إذا لزم الأمر

---

**تم إعداد هذا الدليل بواسطة:** فريق وكلاء تطوير مشروع بصير  
**آخر تحديث:** 13 ديسمبر 2025  
**الإصدار:** 1.0

---

## 🎯 خلاصة سريعة

**للصيانة اليومية:** `flutter analyze`  
**للصيانة الأسبوعية:** `./scripts/maintenance/dependency_monitor.sh`  
**للطوارئ:** `flutter clean && flutter pub get`  
**للتحديثات:** `flutter pub upgrade` (بحذر)

**تذكر:** الوقاية خير من العلاج! 🛡️
