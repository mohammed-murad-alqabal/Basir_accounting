# L2 Decision Layer - طبقة القرار الذكية

**المشروع:** بصير MVP  
**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 11 ديسمبر 2025  
**الحالة:** ✅ **مكتمل**

---

## 🎯 نظرة عامة

L2 Decision Layer هي الطبقة الثانية في نظام الوكلاء الذكية لمشروع بصير MVP. تستقبل هذه الطبقة البيانات من L1 Analysis Layer وتتخذ قرارات ذكية بناءً على القواعد المحددة مسبقاً ونماذج التعلم الآلي.

## 🏗️ المعمارية

```
┌─────────────────────────────────────────────────────────────┐
│                    L2 Decision Layer                        │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │   Decision  │  │    Rule     │  │    ML Models        │  │
│  │   Engine    │◄─┤  Processor  │  │    Manager          │  │
│  │             │  │             │  │                     │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
│         │                 │                    │            │
│         ▼                 ▼                    ▼            │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │   Context   │  │   Action    │  │     Event           │  │
│  │   Manager   │  │  Executor   │  │    Publisher        │  │
│  │             │  │             │  │                     │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

## 📦 المكونات الرئيسية

### 1. Decision Engine (محرك القرارات)
- **الملف:** `engine/decision-engine.ts`
- **الوظيفة:** المكون الأساسي لاتخاذ القرارات
- **المسؤوليات:**
  - معالجة بيانات التحليل من L1
  - تقييم القواعد والحصول على توقعات ML
  - ترتيب القرارات حسب الأولوية
  - التحقق من التعارضات والتبعيات
  - تنفيذ القرارات والتراجع عنها

### 2. Rule Processor (معالج القواعد)
- **الملف:** `rules/rule-processor.ts`
- **الوظيفة:** إدارة وتنفيذ قواعد القرار
- **المسؤوليات:**
  - تحميل القواعد من ملفات YAML
  - تقييم الشروط والقواعد
  - حل التعارضات بين القواعد
  - تحسين أداء تنفيذ القواعد

### 3. ML Models Manager (مدير نماذج التعلم الآلي)
- **الملف:** `ml/ml-models-manager.ts`
- **الوظيفة:** إدارة نماذج التعلم الآلي
- **المسؤوليات:**
  - تحميل وحفظ النماذج
  - تدريب النماذج على البيانات الجديدة
  - التنبؤ بالقرارات
  - تقييم أداء النماذج

### 4. Context Manager (مدير السياق)
- **الملف:** `context/context-manager.ts`
- **الوظيفة:** إدارة سياق القرارات والحالة
- **المسؤوليات:**
  - تتبع حالة النظام
  - إدارة التبعيات بين القرارات
  - كشف التعارضات
  - حفظ تاريخ السياق

### 5. Action Executor (منفذ الإجراءات)
- **الملف:** `actions/action-executor.ts`
- **الوظيفة:** تنفيذ إجراءات القرارات
- **المسؤوليات:**
  - تنفيذ الإجراءات بأمان
  - مراقبة تقدم التنفيذ
  - التراجع عن الإجراءات
  - معالجة الأخطاء

## 🚀 الاستخدام

### التشغيل الأساسي

```typescript
import { L2DecisionLayer } from './l2-decision-layer';

// إنشاء طبقة القرار
const l2Layer = new L2DecisionLayer();

// بدء الطبقة
await l2Layer.start();

// معالجة بيانات التحليل
const analysisData = {
  source: 'flutter',
  timestamp: new Date(),
  metrics: {
    performance: { cpu: 85, memory: 70 },
    flutter: { buildTime: 12000, widgetCount: 150 },
    riverpod: { rebuildsPerMinute: 120 }
  }
};

const result = await l2Layer.processAnalysisData(analysisData);
console.log('Decisions made:', result.decisions.length);

// إيقاف الطبقة
await l2Layer.stop();
```

### التكوين المخصص

```typescript
import { L2DecisionLayer, getBasirMVPConfig } from './l2-decision-layer';

// الحصول على تكوين مشروع بصير
const config = getBasirMVPConfig();

// تخصيص التكوين
config.engine.confidenceThreshold = 0.8;
config.ml.enablePredictions = true;

// إنشاء الطبقة مع التكوين المخصص
const l2Layer = new L2DecisionLayer(config);
```

## ⚙️ التكوين

### ملف التكوين الافتراضي

```typescript
const config = {
  project: 'بصير MVP',
  
  engine: {
    maxConcurrentDecisions: 8,
    decisionTimeout: 300000,
    confidenceThreshold: 0.75
  },
  
  rules: {
    rulesPath: '.kiro/config/basir-rules.yml',
    autoReload: true,
    cacheTimeout: 300000
  },
  
  ml: {
    modelsPath: '.kiro/data/basir-models',
    autoUpdate: true,
    confidenceThreshold: 0.6
  },
  
  actions: {
    maxConcurrentActions: 5,
    defaultTimeout: 60000,
    enableRollback: true
  }
};
```

### قواعد القرار (YAML)

```yaml
# .kiro/config/basir-rules.yml
rules:
  flutter_performance:
    - id: "widget_optimization"
      name: "Widget Performance Optimization"
      description: "تحسين أداء الويدجت"
      conditions:
        - field: "flutter.buildTime"
          operator: ">"
          value: 10000
          type: "number"
      actions:
        - type: "optimize_widget"
          description: "تحسين أداء الويدجت"
          parameters:
            target: "stateful_widgets"
      priority: 8
      enabled: true

  riverpod_optimization:
    - id: "provider_efficiency"
      name: "Riverpod Provider Optimization"
      description: "تحسين كفاءة موفري Riverpod"
      conditions:
        - field: "riverpod.rebuildsPerMinute"
          operator: ">"
          value: 100
          type: "number"
      actions:
        - type: "optimize_providers"
          description: "تحسين موفري Riverpod"
          parameters:
            strategy: "reduce_rebuilds"
      priority: 7
      enabled: true
```

## 🎯 أنواع القرارات المدعومة

### Flutter Performance
- `OPTIMIZE_WIDGET` - تحسين أداء الويدجت
- `REDUCE_REBUILDS` - تقليل إعادة البناء
- `IMPROVE_RENDERING` - تحسين الرسم

### State Management (Riverpod)
- `OPTIMIZE_PROVIDERS` - تحسين الموفرين
- `REFACTOR_STATE` - إعادة هيكلة الحالة
- `ADD_CACHING` - إضافة التخزين المؤقت

### Database (Isar)
- `OPTIMIZE_QUERIES` - تحسين الاستعلامات
- `ADD_INDEXES` - إضافة الفهارس
- `CLEANUP_DATA` - تنظيف البيانات

### Code Quality
- `REFACTOR_CODE` - إعادة هيكلة الكود
- `ADD_TESTS` - إضافة الاختبارات
- `UPDATE_DEPENDENCIES` - تحديث التبعيات

### System Health
- `SCALE_RESOURCES` - توسيع الموارد
- `RESTART_SERVICES` - إعادة تشغيل الخدمات
- `ALERT_TEAM` - تنبيه الفريق

## 🤖 نماذج التعلم الآلي

### النماذج الافتراضية

#### 1. محسن الأداء (Performance Optimizer)
- **النوع:** Classification
- **الهدف:** تحديد نوع التحسين المطلوب
- **المعالم:**
  - `performance_cpu`
  - `performance_memory`
  - `flutter_build_time`
  - `riverpod_rebuilds`
  - `isar_query_time`

#### 2. مصنف جودة الكود (Code Quality Classifier)
- **النوع:** Classification
- **الهدف:** تقييم جودة الكود
- **المعالم:**
  - `code_complexity`
  - `test_coverage`
  - `code_duplication`
  - `documentation_ratio`

### تدريب النماذج

```typescript
// تدريب نموذج جديد
const trainingData = {
  features: [
    { performance_cpu: 85, flutter_build_time: 12000 },
    { performance_cpu: 45, flutter_build_time: 3000 }
  ],
  targets: ['optimize_widget', 'no_action'],
  metadata: {
    source: 'production_data',
    timestamp: new Date(),
    quality: 0.9
  }
};

await l2Layer.mlManager.trainModel('performance_optimizer', trainingData);
```

## 📊 المراقبة والمقاييس

### مقاييس الأداء
- `decisionsPerMinute` - القرارات في الدقيقة
- `averageDecisionTime` - متوسط وقت القرار
- `ruleEvaluationTime` - وقت تقييم القواعد
- `mlPredictionTime` - وقت التنبؤ بالتعلم الآلي

### مقاييس الجودة
- `decisionAccuracy` - دقة القرارات
- `ruleEffectiveness` - فعالية القواعد
- `mlModelAccuracy` - دقة نماذج التعلم الآلي
- `actionSuccessRate` - معدل نجاح الإجراءات

### مقاييس النظام
- `memoryUsage` - استخدام الذاكرة
- `cpuUsage` - استخدام المعالج
- `activeDecisions` - القرارات النشطة
- `queuedDecisions` - القرارات في الانتظار

## 🔧 الأحداث (Events)

### أحداث الطبقة
- `layerStarted` - بدء الطبقة
- `layerStopped` - إيقاف الطبقة
- `analysisProcessed` - معالجة التحليل
- `configUpdated` - تحديث التكوين

### أحداث القرارات
- `decisionMade` - اتخاذ قرار
- `decisionExecuted` - تنفيذ قرار
- `decisionCompleted` - إكمال قرار
- `decisionFailed` - فشل قرار
- `decisionRolledBack` - التراجع عن قرار

### أحداث القواعد والتعلم الآلي
- `ruleTriggered` - تطبيق قاعدة
- `mlPrediction` - توقع التعلم الآلي
- `conflictsDetected` - كشف تعارضات

## 🛡️ الأمان

### تسجيل المراجعة
- جميع القرارات مسجلة مع الوقت والمبرر
- تتبع تنفيذ الإجراءات والنتائج
- حفظ تاريخ التغييرات في السياق

### التحكم في الوصول
- إمكانية تفعيل التحكم في الوصول
- تشفير البيانات الحساسة
- حماية ملفات التكوين

## 🧪 الاختبار

### تشغيل الاختبارات

```bash
# تشغيل جميع الاختبارات
npm test

# تشغيل اختبارات مكون معين
npm test -- --grep "DecisionEngine"

# تشغيل الاختبارات مع التغطية
npm run test:coverage
```

### اختبار التكامل

```typescript
// اختبار تكامل L1 و L2
const l1Layer = new L1AnalysisLayer();
const l2Layer = new L2DecisionLayer();

await l1Layer.start();
await l2Layer.start();

// ربط الطبقات
l1Layer.on('analysisCompleted', async (result) => {
  await l2Layer.processAnalysisData(result);
});
```

## 📈 الأداء

### التحسينات المطبقة
- تخزين مؤقت لتقييم القواعد
- معالجة متوازية للقرارات
- تحسين استعلامات قاعدة البيانات
- ضغط البيانات المحفوظة

### معايير الأداء
- معالجة 100+ قرار في الدقيقة
- وقت استجابة أقل من 100ms للقواعد البسيطة
- وقت استجابة أقل من 500ms لتوقعات التعلم الآلي
- استخدام ذاكرة أقل من 256MB

## 🔄 التطوير المستقبلي

### الميزات المخططة
- دعم قواعد ديناميكية أكثر تعقيداً
- تحسين نماذج التعلم الآلي
- واجهة ويب لمراقبة القرارات
- تكامل مع أنظمة CI/CD

### التحسينات المقترحة
- دعم التعلم التعزيزي
- تحليل تأثير القرارات
- توقع الأداء المستقبلي
- تحسين استهلاك الموارد

---

## 📞 الدعم

للحصول على المساعدة أو الإبلاغ عن المشاكل:

- **التوثيق:** `.kiro/docs/`
- **الأمثلة:** `.kiro/examples/`
- **السجلات:** `.kiro/logs/`

---

**تم بواسطة:** فريق وكلاء تطوير مشروع بصير  
**آخر تحديث:** 11 ديسمبر 2025