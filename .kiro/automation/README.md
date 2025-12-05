# نظام الأتمتة الذكي للوكلاء

**المشروع:** بصير MVP  
**التاريخ:** 5 ديسمبر 2025  
**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**الحالة:** 🚀 جاهز للإنتاج

---

## 📋 نظرة عامة

نظام ذكي متكامل لأتمتة إدارة ومراقبة واتخاذ القرارات لفريق الوكلاء المطورين. يوفر النظام:

- 🤖 **تنسيق ذكي** بين 8 وكلاء متخصصين
- 📊 **مراقبة مستمرة** للأداء والجودة
- 🧠 **قرارات تلقائية** بناءً على قواعد ذكية
- 🔔 **تنبيهات متعددة المستويات** (حرج، تحذير، معلومات)
- 🔧 **إصلاح ذاتي** للمشاكل الشائعة
- 📈 **لوحة تحكم** لمتابعة الحالة

---

## 🏗️ البنية المعمارية

```
┌─────────────────────────────────────────────────────────┐
│              Agent Orchestrator (المنسق)                │
│         ينسق ويدير جميع الوكلاء والعمليات              │
└────────────────────┬────────────────────────────────────┘
                     │
        ┌────────────┼────────────┐
        │            │            │
┌───────▼──────┐ ┌──▼──────┐ ┌──▼──────────┐
│ Performance  │ │Decision │ │Alert System │
│   Monitor    │ │ Engine  │ │   (تنبيهات) │
│  (مراقبة)    │ │(قرارات)│ │             │
└───────┬──────┘ └──┬──────┘ └──┬──────────┘
        │            │            │
        └────────────┼────────────┘
                     │
        ┌────────────▼────────────┐
        │    Auto-Healing         │
        │   (إصلاح ذاتي)          │
        └────────────┬────────────┘
                     │
        ┌────────────▼────────────┐
        │    Dashboard            │
        │   (لوحة التحكم)         │
        └─────────────────────────┘
```

---

## 🚀 البدء السريع

### 1. التثبيت

```bash
cd .kiro/automation
./run.sh install
```

هذا الأمر سيقوم بـ:

- ✅ التحقق من Python 3
- ✅ إنشاء بيئة افتراضية
- ✅ تثبيت جميع المتطلبات
- ✅ إنشاء المجلدات المطلوبة
- ✅ التحقق من التكوينات

### 2. التشغيل

```bash
./run.sh start
```

### 3. التحقق من الحالة

```bash
./run.sh status
```

### 4. الإيقاف

```bash
./run.sh stop
```

---

## 📦 المكونات الرئيسية

### 1. Agent Orchestrator (المنسق)

**الملف:** `orchestrator.py`

**الوظيفة:** التنسيق المركزي لجميع الوكلاء

**الميزات:**

- إدارة 8 وكلاء متخصصين
- قائمة مهام ذكية مع أولويات
- جدولة تلقائية للمهام
- تتبع حالة الوكلاء
- حفظ واستعادة الحالة

**الاستخدام:**

```bash
python orchestrator.py start
python orchestrator.py status
python orchestrator.py dashboard
```

### 2. Performance Monitor (مراقب الأداء)

**الملف:** `performance_monitor.py`

**الوظيفة:** مراقبة مستمرة للأداء

**المقاييس المراقبة:**

- 💻 استهلاك CPU
- 🧠 استهلاك الذاكرة
- 💾 استهلاك القرص
- 📦 حجم المشروع
- ✅ جودة الكود
- 🧪 تغطية الاختبارات

**الاستخدام:**

```python
from performance_monitor import PerformanceMonitor

monitor = PerformanceMonitor()
system_metrics = monitor.collect_system_metrics()
project_metrics = monitor.collect_project_metrics()
score = monitor.get_performance_score()
```

### 3. Decision Engine (محرك القرارات)

**الملف:** `decision_engine.py`

**الوظيفة:** اتخاذ قرارات ذكية تلقائياً

**أنواع القرارات:**

- ⚡ **فورية:** تنفيذ فوري (مثل: تنظيف عند ارتفاع CPU)
- 📅 **مجدولة:** تنفيذ لاحق (مثل: جدولة refactoring)
- 🎯 **استراتيجية:** تتطلب مراجعة (مثل: مراجعة شاملة للأداء)

**القواعد المدمجة:**

- استهلاك CPU > 90% → تنظيف فوري
- استهلاك الذاكرة > 85% → تنظيف الذاكرة
- تغطية الاختبارات < 70% → جدولة sprint اختبارات
- جودة الكود < 70% → جدولة refactoring
- 3+ تنبيهات حرجة → مراجعة طارئة

**الاستخدام:**

```python
from decision_engine import DecisionEngine

engine = DecisionEngine()
context = {
    'cpu_percent': 95,
    'memory_percent': 88,
    'test_coverage': 65
}
decisions = engine.evaluate(context)
```

### 4. Alert System (نظام التنبيهات)

**الملف:** `alert_system.py`

**الوظيفة:** تنبيهات ذكية متعددة المستويات

**مستويات التنبيه:**

- 🔴 **حرج (Critical):** مشاكل تتطلب تدخل فوري
- 🟡 **تحذير (Warning):** مشاكل تحتاج متابعة
- 🟢 **معلومات (Info):** معلومات عامة

**القنوات:**

- 📝 السجل (Log)
- 📄 ملف (File)
- 🖥️ الطرفية (Console)
- 📧 البريد الإلكتروني (قريباً)
- 💬 Slack (قريباً)

**الاستخدام:**

```python
from alert_system import AlertSystem

alerts = AlertSystem()
alerts.create_alert('high_cpu_usage', {'value': 95})
critical = alerts.get_critical_alerts()
```

### 5. Auto-Healing (الإصلاح الذاتي)

**الملف:** `auto_healing.py`

**الوظيفة:** إصلاح المشاكل تلقائياً

**السيناريوهات المدعومة:**

- 🔧 استهلاك CPU عالي → تشغيل cleanup.sh
- 🧠 استهلاك ذاكرة عالي → flutter clean + pub get
- 💾 مساحة قرص منخفضة → تنظيف شامل
- 🏗️ فشل البناء → clean + rebuild
- 📦 مشاكل التبعيات → pub cache repair
- 🔍 مشاكل التحليل → dart fix --apply
- 🔐 ثغرات أمنية → flutter pub upgrade

**الاستخدام:**

```python
from auto_healing import AutoHealing

healing = AutoHealing()
result = healing.heal('high_cpu_usage', context)
if result.success:
    print(f"✅ {result.message}")
```

---

## ⚙️ التكوين

### ملف config.yaml

```yaml
# إعدادات الوكلاء
agents:
  analysis:
    enabled: true
    interval: 300 # 5 دقائق
    on_commit: true

  testing:
    enabled: true
    on_commit: true
    coverage_threshold: 70

# إعدادات المراقبة
monitoring:
  interval: 60 # ثانية
  thresholds:
    cpu_percent: 80.0
    memory_percent: 85.0
    test_coverage: 70.0

# إعدادات التنبيهات
alerts:
  enabled: true
  channels:
    log: true
    file: true
    console: true

# إعدادات الإصلاح الذاتي
auto_healing:
  enabled: true
  max_retries: 3
  auto_rollback: true
```

---

## 📊 لوحة التحكم

### عرض الحالة

```bash
./run.sh status
```

**الإخراج:**

```
==========================================
🤖 نظام الأتمتة الذكي للوكلاء
==========================================

✅ النظام يعمل (PID: 12345)

📊 آخر حالة:
  الوقت: 2025-12-05T20:30:00
  الوكلاء النشطون: 8/8
  حجم قائمة المهام: 3
  صحة النظام: 95.5%
```

### عرض السجلات

```bash
./run.sh logs
```

### البيانات المحفوظة

```
logs/
├── main.log                    # السجل الرئيسي
├── orchestrator.log            # سجل المنسق
├── performance.log             # سجل الأداء
├── decisions.log               # سجل القرارات
├── healing.log                 # سجل الإصلاحات
├── alerts/                     # مجلد التنبيهات
│   └── alerts_2025-12-05.json
├── reports/                    # مجلد التقارير
│   └── final_report.json
├── dashboard.json              # بيانات لوحة التحكم
└── orchestrator_state.json     # حالة النظام
```

---

## 🔄 سير العمل التلقائي

### سيناريو 1: Commit جديد

```
Developer commits code
    ↓
Git Hook triggers
    ↓
Orchestrator activates
    ↓
Analysis Agent: Check code
    ↓
Quality OK? → Yes
    ↓
Testing Agent: Run tests
    ↓
Tests pass? → Yes
    ↓
Security Agent: Scan
    ↓
Secure? → Yes
    ↓
Documentation Agent: Update
    ↓
Management Agent: Log success
    ↓
Dashboard: Update status
```

### سيناريو 2: مراقبة مستمرة

```
Performance Monitor runs (every 5m)
    ↓
Collect metrics
    ↓
Threshold exceeded? → Yes
    ↓
Decision Engine analyzes
    ↓
Severity = Critical
    ↓
Auto-heal immediately
    ↓
Alert System notifies
    ↓
Dashboard updates
    ↓
Management Agent logs
```

---

## 🎯 الفوائد المتوقعة

### الكفاءة

- ⚡ **60% أقل** وقت للمراجعة
- 🚀 **40% أسرع** في التطوير
- 🔄 **80% أتمتة** للمهام الروتينية

### الجودة

- ✅ **اكتشاف فوري** للمشاكل
- 🛡️ **مراقبة مستمرة** للأمان
- 📊 **شفافية كاملة** للحالة

### التكلفة

- 💰 **50% توفير** في وقت الصيانة
- 🔧 **70% إصلاح ذاتي** للمشاكل
- 📉 **80% أقل** أخطاء في الإنتاج

---

## 🛠️ الأوامر المتاحة

```bash
# التثبيت
./run.sh install

# التشغيل
./run.sh start

# الإيقاف
./run.sh stop

# إعادة التشغيل
./run.sh restart

# عرض الحالة
./run.sh status

# عرض السجلات
./run.sh logs

# التنظيف
./run.sh cleanup

# المساعدة
./run.sh help
```

---

## 📚 الوثائق الإضافية

- [AGENTS_AUTOMATION_SYSTEM.md](AGENTS_AUTOMATION_SYSTEM.md) - التصميم الكامل
- [config.yaml](config.yaml) - ملف التكوين
- [requirements.txt](requirements.txt) - المتطلبات

---

## 🔧 استكشاف الأخطاء

### المشكلة: النظام لا يبدأ

**الحل:**

```bash
# التحقق من Python
python3 --version

# إعادة التثبيت
./run.sh install

# التحقق من السجلات
cat logs/main.log
```

### المشكلة: خطأ في المتطلبات

**الحل:**

```bash
# تحديث pip
pip install --upgrade pip

# إعادة تثبيت المتطلبات
pip install -r requirements.txt
```

### المشكلة: النظام يتوقف تلقائياً

**الحل:**

```bash
# التحقق من السجلات
./run.sh logs

# التحقق من الموارد
free -h
df -h
```

---

## 🚧 التطوير المستقبلي

### المرحلة القادمة

- [ ] لوحة تحكم ويب تفاعلية
- [ ] تكامل مع Slack/Email
- [ ] تعلم آلي للتنبؤ بالمشاكل
- [ ] API للتكامل الخارجي
- [ ] دعم Docker
- [ ] دعم Kubernetes

---

## 📞 الدعم

للمساعدة أو الإبلاغ عن مشاكل:

- 📧 البريد الإلكتروني: [email protected]
- 📝 GitHub Issues: [رابط المشروع]
- 📚 الوثائق: [رابط الوثائق]

---

## 📄 الترخيص

هذا المشروع مرخص تحت [MIT License](../../LICENSE)

---

**تم إعداده بواسطة:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 5 ديسمبر 2025  
**الإصدار:** 1.0  
**الحالة:** 🚀 جاهز للإنتاج

**المستقبل هو الأتمتة الذكية!** 🤖✨
