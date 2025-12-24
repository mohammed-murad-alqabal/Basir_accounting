# دليل استخدام Figma مع Kiro

**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 12 ديسمبر 2025

---

## 🎯 نظرة عامة

تم تكوين تكامل Figma مع مشروع بصير لتسهيل الوصول إلى ملفات التصميم والتعاون.

## 🔧 الاستخدام المباشر

### الطريقة الموصى بها حالياً

استخدم الأدوات المحلية مباشرة لتجنب مشاكل انقطاع الدردشة:

```bash
# الحصول على معلومات المستخدم
dart run scripts/figma_api.dart me

# الحصول على الفرق
dart run scripts/figma_api.dart teams

# الحصول على مشاريع فريق معين
dart run scripts/figma_api.dart team-projects TEAM_ID

# الحصول على ملفات مشروع معين
dart run scripts/figma_api.dart project-files PROJECT_ID

# الحصول على معلومات ملف
dart run scripts/figma_api.dart file FILE_KEY

# الحصول على تعليقات ملف
dart run scripts/figma_api.dart comments FILE_KEY
```

## 📋 الحصول على المعرفات المطلوبة

### 1. Team ID

```bash
# احصل على قائمة الفرق أولاً
dart run scripts/figma_api.dart teams

# ستحصل على استجابة تحتوي على team_id لكل فريق
```

### 2. Project ID

```bash
# استخدم team_id للحصول على المشاريع
dart run scripts/figma_api.dart team-projects YOUR_TEAM_ID

# ستحصل على قائمة المشاريع مع project_id لكل مشروع
```

### 3. File Key

```bash
# استخدم project_id للحصول على الملفات
dart run scripts/figma_api.dart project-files YOUR_PROJECT_ID

# أو احصل عليه من رابط Figma:
# https://www.figma.com/file/FILE_KEY/file-name
```

## 🔍 أمثلة عملية

### مثال كامل للوصول إلى ملف تصميم:

```bash
# 1. احصل على معلومات المستخدم
dart run scripts/figma_api.dart me

# 2. احصل على الفرق (إذا كنت عضواً في فرق)
dart run scripts/figma_api.dart teams

# 3. إذا لم تكن في فرق، يمكنك استخدام file key مباشرة
dart run scripts/figma_api.dart file YOUR_FILE_KEY
```

## ⚠️ استكشاف الأخطاء

### خطأ 401 - Unauthorized

- تحقق من صحة `FIGMA_ACCESS_TOKEN` في `.env`
- تأكد من أن التوكن لم ينته صلاحيته

### خطأ 403 - Forbidden

- تحقق من صلاحيات الوصول للملف/المشروع
- تأكد من أنك عضو في الفريق المطلوب

### خطأ 404 - Not Found

- تحقق من صحة المعرفات (team_id, project_id, file_key)
- تأكد من وجود المورد المطلوب

## 🚀 الخطوات التالية

1. **اختبر الاتصال**: ابدأ بـ `dart run scripts/figma_api.dart me`
2. **احصل على المعرفات**: استخدم الأوامر أعلاه للحصول على IDs
3. **وثّق المعرفات**: احفظ المعرفات المهمة في `.env`
4. **استخدم في التطوير**: ادمج الأدوات في سير العمل

## 📚 مراجع إضافية

- [Figma API Documentation](https://www.figma.com/developers/api)
- [دليل تكامل Figma الكامل](./FIGMA_INTEGRATION_GUIDE.md)
- [ملف التكوين](./.env.example)

---

**ملاحظة:** تم تعطيل MCP server مؤقتاً لتجنب مشاكل انقطاع الدردشة. استخدم الأدوات المحلية حتى يتم حل المشكلة.
