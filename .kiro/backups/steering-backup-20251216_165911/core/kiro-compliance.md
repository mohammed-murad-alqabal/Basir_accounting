---
title: Kiro.dev Compliance Standards
inclusion: always
---

# معايير الامتثال لـ Kiro.dev

**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**المصدر:** مراجع Kiro.dev الرسمية  
**التاريخ:** 15 ديسمبر 2025  
**آخر تحديث:** 15 ديسمبر 2025 - تحديث شامل لمعايير 2025

---

## المبادئ الأساسية من Kiro.dev

### 1. **Spec-Driven Development (إلزامي)**

**كما هو محدد في kiro.dev:**

> "Kiro turns your prompt into structured requirements, design, and tasks that are then implemented by agents"

**التطبيق في بصير:**

- كل ميزة تبدأ بـ spec في `.kiro/specs/`
- استخدام EARS methodology للمتطلبات
- تحويل المتطلبات إلى تصميم ثم مهام
- تنفيذ المهام بواسطة الوكلاء

### 2. **Agent Hooks للأتمتة**

**كما هو محدد في kiro.dev:**

> "Agent hooks help you scale your work by delegating tasks to agents that run in the background"

**التطبيق في بصير:**

- hooks تلقائية للاختبارات والتوثيق
- تحديث تلقائي للـ dependencies
- فحص أمني تلقائي
- تنسيق الكود التلقائي

### 3. **Powers Integration**

**كما هو محدد في kiro.dev:**

> "Powers package MCP, steering, and hooks into reusable capabilities"

**التطبيق في بصير:**

- استخدام Flutter-specific powers
- تجنب powers غير المتوافقة (AWS/Stripe للـ MVP)
- تفعيل powers حسب الحاجة
- توثيق powers المستخدمة

### 4. **Structured Input للوكلاء**

**كما هو محدد في kiro.dev:**

> "Agents need more structured input and contextual information than a natural language prompt"

**التطبيق في بصير:**

- steering files منظمة ومصنفة
- context واضح لكل تقنية
- معايير محددة لكل مجال
- أمثلة عملية وقوالب

### 5. **Background Task Delegation**

**كما هو محدد في kiro.dev:**

> "Tasks to agents that run in the background, such as updating docs, generating unit tests"

**التطبيق في بصير:**

- hooks للتوثيق التلقائي
- اختبارات تلقائية عند الحفظ
- فحص جودة الكود
- تحديث الـ changelog

---

## معايير الامتثال المطلوبة

### **Spec Structure Compliance**

```
.kiro/specs/{feature}/
├── requirements.md    # EARS methodology
├── design.md         # Architecture & components
└── tasks.md          # Implementation tasks
```

### **Hook Categories Compliance**

```
.kiro/hooks/
├── automatic/        # Auto-triggered
├── manual/          # User-triggered
├── on-save/         # File save triggers
└── on-commit/       # Git commit triggers
```

### **Steering Organization Compliance**

```
.kiro/steering/
├── core/            # Essential guidance
├── technologies/    # Tech-specific rules
└── backlog/         # Future capabilities
```

### **Powers Management Compliance**

- Only install relevant powers
- Document power usage
- Regular power audits
- Proper configuration

---

## Quality Gates

### **Before Implementation**

- [ ] Spec exists and approved
- [ ] Design reviewed and documented
- [ ] Tasks broken down properly
- [ ] Hooks configured for automation

### **During Implementation**

- [ ] Code follows steering guidelines
- [ ] Tests written (unit + integration)
- [ ] Documentation updated
- [ ] Security checks passed

### **After Implementation**

- [ ] All tasks completed
- [ ] Quality metrics met
- [ ] Performance validated
- [ ] User acceptance confirmed

---

## Kiro.dev Best Practices Integration

### **1. "Structure to the Chaos"**

- Organized file structure
- Clear naming conventions
- Consistent patterns
- Documented decisions

### **2. "Build Alongside You"**

- Collaborative development
- Incremental improvements
- Continuous learning
- Knowledge sharing

### **3. "Deliver Robust Engineering Work"**

- High code quality
- Comprehensive testing
- Security first
- Performance optimized

### **4. "Help You Become Better Engineer"**

- Learning opportunities
- Best practices enforcement
- Code review standards
- Skill development

---

## Compliance Checklist

### **Project Level**

- [ ] Follows spec-driven development
- [ ] Uses appropriate hooks
- [ ] Integrates relevant powers
- [ ] Maintains quality standards

### **Code Level**

- [ ] Structured and documented
- [ ] Tested and validated
- [ ] Secure and performant
- [ ] Maintainable and scalable

### **Process Level**

- [ ] Automated workflows
- [ ] Quality gates
- [ ] Continuous improvement
- [ ] Team collaboration

---

## معايير 2025 المحدثة

### **AI-Powered Development Integration**

**كما هو محدد في kiro.dev 2025:**

> "AI agents now provide intelligent code suggestions, automated testing, and continuous quality monitoring"

**التطبيق في بصير:**

- استخدام AI للمراجعة التلقائية للكود
- تحليل ذكي للأداء والأمان
- اقتراحات تحسين تلقائية
- توليد اختبارات ذكية

### **Advanced Metrics Integration**

**معايير 2025 المحدثة:**

- **Developer Experience Index (DXI)**: قياس تجربة المطور
- **AI Assistance Effectiveness**: فعالية المساعدة الذكية
- **Automated Quality Gates**: بوابات جودة تلقائية
- **Predictive Analytics**: تحليلات تنبؤية للمشاكل

### **Modern Flutter/Dart Standards (2025)**

**Flutter 3.35.5+ Requirements:**

- استخدام أحدث Dart 3.9.2+ features
- تطبيق Material Design 3.0
- استخدام Impeller rendering engine
- تطبيق Web Assembly support

### **Enhanced Security Framework**

**Zero-Trust 2.0 (2025):**

- **Quantum-Safe Cryptography**: تشفير مقاوم للحوسبة الكمية
- **AI-Powered Threat Detection**: كشف التهديدات بالذكاء الاصطناعي
- **Continuous Compliance Monitoring**: مراقبة الامتثال المستمرة
- **Automated Incident Response**: استجابة تلقائية للحوادث

---

## Quality Gates 2025

### **AI-Enhanced Quality Checks**

- [ ] AI code review passed
- [ ] Automated security scan completed
- [ ] Performance benchmarks met
- [ ] Accessibility compliance verified
- [ ] Carbon footprint optimized

### **Advanced Metrics Validation**

- [ ] DXI score > 8.5/10
- [ ] AI assistance utilization > 70%
- [ ] Automated test coverage > 85%
- [ ] Predictive quality score > 9.0/10

---

## Kiro.dev 2025 Integration Checklist

### **Project Level**

- [ ] AI-powered spec generation enabled
- [ ] Intelligent hooks configured
- [ ] Advanced powers integrated
- [ ] Quantum-safe security implemented

### **Development Level**

- [ ] AI code assistance active
- [ ] Automated quality monitoring
- [ ] Predictive error prevention
- [ ] Continuous learning enabled

### **Process Level**

- [ ] Intelligent workflow automation
- [ ] AI-enhanced code reviews
- [ ] Predictive maintenance active
- [ ] Continuous optimization running

---

**للمراجعة الدورية:** كل شهر (محدث من 3 أشهر)  
**المسؤول:** فريق وكلاء تطوير مشروع بصير  
**معايير الامتثال:** Kiro.dev 2025 Standards
