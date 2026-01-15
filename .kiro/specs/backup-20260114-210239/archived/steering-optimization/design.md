# تصميم تحسين ملفات التوجيه - بصير MVP

**المشروع:** بصير MVP  
**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 17 ديسمبر 2025  
**الحالة:** 🎨 تصميم تقني

---

## نظرة عامة

تصميم نظام شامل لتحسين وإعادة تنظيم ملفات التوجيه في `.kiro/steering/` من خلال:

- إزالة التكرار الكامل والجزئي
- دمج الملفات المتداخلة والصغيرة
- تقسيم الملفات الضخمة
- إعادة تنظيم الهيكل العام
- تحسين الأداء والجودة

## المعمارية

### الهيكل المقترح الجديد

```
.kiro/steering/
├── README.md                    # فهرس شامل ودليل التنقل
├── core/                        # التوجيهات الأساسية
│   ├── philosophy.md           # الفلسفة الهندسية
│   ├── kiro-compliance.md      # معايير Kiro.dev
│   ├── team-identity.md        # هوية الفريق
│   └── quick-reference.md      # المرجع السريع
├── development/                 # معايير التطوير (مدموج)
│   ├── flutter-standards.md   # Flutter/Dart شامل
│   ├── git-standards.md        # Git شامل
│   ├── testing-standards.md    # الاختبارات
│   ├── security-standards.md   # الأمان
│   └── performance-standards.md # الأداء
├── quality/                     # ضمان الجودة (محسن)
│   ├── quality-system.md       # النظام الموحد
│   └── quality-index.md        # الفهرس
├── tools/                       # الأدوات والتقنيات
│   ├── mcp-standards.md        # MCP
│   ├── ai-development.md       # الذكاء الاصطناعي
│   └── content-management.md   # إدارة المحتوى
└── project/                     # خاص بالمشروع
    ├── tech-stack.md           # المكدس التقني (مقسم)
    ├── agents-framework.md     # إطار الوكلاء (مقسم)
    └── project-standards.md    # معايير المشروع
```

## المكونات والواجهات

### 1. محلل التكرار (Duplication Analyzer)

**الوظيفة:** اكتشاف الملفات المكررة والمتداخلة

```typescript
interface DuplicationAnalyzer {
  detectExactDuplicates(files: FileInfo[]): DuplicateGroup[];
  detectContentOverlap(files: FileInfo[]): OverlapGroup[];
  calculateSimilarity(file1: string, file2: string): number;
}
```

### 2. محرك الدمج (Merge Engine)

**الوظيفة:** دمج الملفات المتداخلة والصغيرة

```typescript
interface MergeEngine {
  mergeOverlappingFiles(group: OverlapGroup): MergedFile;
  mergeSmallFiles(files: FileInfo[]): MergedFile;
  preserveImportantContent(content: string[]): string;
}
```

### 3. مقسم الملفات (File Splitter)

**الوظيفة:** تقسيم الملفات الضخمة إلى أجزاء منطقية

```typescript
interface FileSplitter {
  identifyLargeFiles(files: FileInfo[], threshold: number): FileInfo[];
  splitByLogicalSections(file: FileInfo): SplitResult;
  createIndexFile(splitFiles: FileInfo[]): IndexFile;
}
```

### 4. منظم الهيكل (Structure Organizer)

**الوظيفة:** إعادة تنظيم الملفات في الهيكل الجديد

```typescript
interface StructureOrganizer {
  categorizeFiles(files: FileInfo[]): CategoryMap;
  moveToNewStructure(files: FileInfo[], structure: DirectoryStructure): void;
  updateReferences(files: FileInfo[]): void;
}
```

### 5. محسن الأداء (Performance Optimizer)

**الوظيفة:** تحسين أداء الملفات والوصول إليها

```typescript
interface PerformanceOptimizer {
  optimizeFileSize(file: FileInfo): OptimizedFile;
  createSearchIndex(files: FileInfo[]): SearchIndex;
  validatePerformance(files: FileInfo[]): PerformanceReport;
}
```

### 6. مراقب الجودة (Quality Monitor)

**الوظيفة:** ضمان جودة المحتوى والروابط

```typescript
interface QualityMonitor {
  validateLinks(files: FileInfo[]): LinkValidationReport;
  checkContentQuality(file: FileInfo): QualityScore;
  ensureKiroCompliance(file: FileInfo): ComplianceReport;
}
```

## نماذج البيانات

### FileInfo

```typescript
interface FileInfo {
  path: string;
  size: number;
  lines: number;
  content: string;
  frontmatter: FrontMatter;
  lastModified: Date;
  category: FileCategory;
}
```

### DuplicateGroup

```typescript
interface DuplicateGroup {
  files: FileInfo[];
  similarity: number;
  recommendedAction: "keep_first" | "keep_best_location" | "merge";
  primaryFile: FileInfo;
}
```

### OverlapGroup

```typescript
interface OverlapGroup {
  files: FileInfo[];
  overlapPercentage: number;
  commonSections: ContentSection[];
  mergeStrategy: MergeStrategy;
}
```

## خوارزميات التحسين

### 1. خوارزمية اكتشاف التكرار

```
function detectDuplicates(files: FileInfo[]): DuplicateGroup[] {
  1. حساب hash لكل ملف
  2. مجموعة الملفات بنفس hash
  3. للملفات المتشابهة، حساب similarity score
  4. تحديد الملف الأساسي بناءً على:
     - الموقع (core/ > technologies/ > root)
     - حداثة التحديث
     - جودة المحتوى
  5. إرجاع مجموعات التكرار
}
```

### 2. خوارزمية الدمج الذكي

```
function smartMerge(files: FileInfo[]): MergedFile {
  1. تحليل بنية كل ملف
  2. استخراج الأقسام المشتركة
  3. دمج المحتوى بترتيب منطقي:
     - المقدمة والنظرة العامة
     - المحتوى الأساسي
     - الأمثلة والتفاصيل
     - المراجع والروابط
  4. إزالة التكرار مع الحفاظ على المعلومات المهمة
  5. تحديث frontmatter
}
```

### 3. خوارزمية التقسيم المنطقي

```
function logicalSplit(file: FileInfo): SplitResult {
  1. تحليل بنية العناوين (H1, H2, H3)
  2. تحديد نقاط التقسيم الطبيعية
  3. ضمان أن كل جزء 200-300 سطر
  4. إنشاء ملف فهرس يربط الأجزاء
  5. تحديث الروابط الداخلية
}
```

## استراتيجية التنفيذ

### المرحلة 1: التحليل والتخطيط

1. فحص شامل لجميع الملفات
2. تحديد المشاكل وتصنيفها
3. إنشاء خطة التحسين المفصلة
4. إنشاء نسخة احتياطية كاملة

### المرحلة 2: إزالة التكرار

1. اكتشاف الملفات المكررة تماماً
2. تحديد الملف الأساسي لكل مجموعة
3. حذف النسخ المكررة
4. تحديث جميع المراجع

### المرحلة 3: الدمج والتحسين

1. دمج الملفات المتداخلة
2. دمج الملفات الصغيرة المترابطة
3. تقسيم الملفات الضخمة
4. تحسين المحتوى والتنسيق

### المرحلة 4: إعادة التنظيم

1. تطبيق الهيكل الجديد
2. نقل الملفات للمجلدات المناسبة
3. إنشاء ملفات الفهرس
4. تحديث جميع الروابط والمراجع

### المرحلة 5: التحقق والاختبار

1. فحص جودة الملفات الجديدة
2. اختبار الروابط والمراجع
3. قياس تحسن الأداء
4. التحقق من التوافق مع Kiro.dev

## الخصائص الصحيحة

_خاصية هي سمة أو سلوك يجب أن يكون صحيحاً عبر جميع التنفيذات الصالحة للنظام - في الأساس، بيان رسمي حول ما يجب أن يفعله النظام. الخصائص تعمل كجسر بين المواصفات المقروءة بشرياً وضمانات الصحة القابلة للتحقق آلياً._

### خاصية 1: اكتشاف التكرار الكامل

_لأي_ مجموعة من ملفات التوجيه، عند فحص التكرار، يجب اكتشاف جميع الملفات ذات المحتوى المتطابق تماماً
**تتحقق من: المتطلبات 1.1**

### خاصية 2: الحفاظ على الملف الأنسب

_لأي_ مجموعة ملفات مكررة، عند الاختيار، يجب الاحتفاظ بالملف في الموقع الأنسب وفقاً لمعايير الأولوية المحددة
**تتحقق من: المتطلبات 1.2**

### خاصية 3: اكتشاف التداخل

_لأي_ زوج من ملفات التوجيه، عند تحليل المحتوى، يجب حساب نسبة التداخل بدقة وتحديد الملفات ذات التداخل 50%+
**تتحقق من: المتطلبات 2.1**

### خاصية 4: الدمج الشامل

_لأي_ مجموعة ملفات متداخلة، عند الدمج، يجب أن يحتوي الملف الناتج على جميع المعلومات المهمة من الملفات الأصلية
**تتحقق من: المتطلبات 2.2**

### خاصية 5: تحديد الملفات الضخمة

_لأي_ ملف توجيه، عند فحص الحجم، يجب تحديد الملفات الأكبر من 400 سطر بدقة
**تتحقق من: المتطلبات 3.1**

### خاصية 6: تحديد الملفات الصغيرة

_لأي_ ملف توجيه، عند فحص الحجم، يجب تحديد الملفات الأصغر من 50 سطر بدقة
**تتحقق من: المتطلبات 4.1**

### خاصية 7: التصنيف الصحيح

_لأي_ ملف توجيه، عند التنظيم، يجب وضعه في المجلد المناسب وفقاً لمعايير التصنيف المحددة
**تتحقق من: المتطلبات 5.1**

### خاصية 8: الأداء المحسن

_لأي_ عملية تحميل لملفات التوجيه، يجب إكمالها في أقل من 2 ثانية
**تتحقق من: المتطلبات 6.1**

### خاصية 9: صحة الروابط

_لأي_ رابط في ملفات التوجيه، عند الفحص، يجب التحقق من صحته وإصلاح أو حذف الروابط المكسورة
**تتحقق من: المتطلبات 7.1**

### خاصية 10: الحفاظ على Frontmatter

_لأي_ ملف توجيه، عند التحديث أو الدمج، يجب الحفاظ على جميع frontmatter المطلوبة لتوافق Kiro.dev
**تتحقق من: المتطلبات 8.1**

## معالجة الأخطاء

### أخطاء التكرار

- **ملف غير موجود**: تسجيل تحذير ومتابعة المعالجة
- **صلاحيات غير كافية**: طلب صلاحيات أو تخطي الملف
- **ملف مقفل**: انتظار أو تأجيل المعالجة

### أخطاء الدمج

- **تعارض في المحتوى**: طلب تدخل يدوي أو تطبيق قواعد الأولوية
- **فقدان معلومات**: إيقاف العملية وطلب مراجعة
- **خطأ في التنسيق**: محاولة إصلاح تلقائي أو تحذير

### أخطاء الأداء

- **تجاوز الوقت المحدد**: تحسين العملية أو تقسيمها
- **نفاد الذاكرة**: معالجة تدريجية أو تحسين الخوارزمية
- **فشل في الكتابة**: إعادة المحاولة أو تسجيل خطأ

## استراتيجية الاختبار

### اختبارات الوحدة

- اختبار كل مكون بشكل منفصل
- محاكاة التبعيات الخارجية
- تغطية جميع الحالات الحدية
- اختبار معالجة الأخطاء

### اختبارات التكامل

- اختبار التفاعل بين المكونات
- اختبار سير العمل الكامل
- اختبار الأداء تحت الضغط
- اختبار التوافق مع Kiro.dev

### اختبارات الخصائص

- تنفيذ اختبارات لكل خاصية محددة
- استخدام بيانات عشوائية للاختبار
- التحقق من صحة النتائج
- قياس الأداء والجودة

---

**تم إعداده بواسطة:** فريق وكلاء تطوير مشروع بصير  
**الحالة:** ✅ تصميم تقني شامل ومعتمد  
**المراجعة القادمة:** بعد اعتماد قائمة المهام
