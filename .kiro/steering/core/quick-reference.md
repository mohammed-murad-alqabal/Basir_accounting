# مرجع سريع

**المشروع:** بصير MVP  
**الحالة:** ✅ نشط

---

## التسمية (Naming)

| العنصر        | الصيغة         | مثال                       |
| :------------ | :------------- | :------------------------- |
| Files/Folders | snake_case     | `customer_repository.dart` |
| Classes       | PascalCase     | `CustomerRepository`       |
| Functions     | camelCase      | `getAllCustomers()`        |
| Variables     | camelCase      | `customerList`             |
| Constants     | lowerCamelCase | `maxRetries`               |
| Private       | \_prefix       | `_privateMethod()`         |

**التفاصيل:** `.kiro/standards/naming.md`

---

## الجودة (Quality)

### المعايير الأساسية

- Test coverage: **70%+**
- Max line length: **80**
- Max complexity: **10**
- DRY principle: **إلزامي**

### SOLID Principles

- Single Responsibility
- Open/Closed
- Liskov Substitution
- Interface Segregation
- Dependency Inversion

**التفاصيل:** `.kiro/standards/code-quality.md`

---

## الأمان (Security)

### القواعد الإلزامية

- ❌ No secrets in code
- ✅ Use `flutter_secure_storage`
- ✅ Validate all inputs
- ✅ Hash passwords (SHA-256+)
- ✅ Encrypt sensitive data

**التفاصيل:** `.kiro/guides/security-guide.md`

---

## الاختبارات (Testing)

### الأنواع

- **Unit Tests**: 70%+ coverage
- **Widget Tests**: critical paths
- **Integration Tests**: user journeys

### القواعد

- اختبار كل public function
- استخدام mocks للـ dependencies
- اختبارات مستقلة وسريعة

**التفاصيل:** `.kiro/standards/testing.md`

---

## التوثيق (Documentation)

### الإلزامي

- DartDoc لجميع public APIs
- أمثلة في التوثيق
- شرح المعاملات والقيم المرجعة

### اللغة

- **العربية**: للنصوص الموجهة للمستخدم
- **الإنجليزية**: للمصطلحات التقنية

**التفاصيل:** `.kiro/standards/documentation.md`

---

## Flutter

### Best Practices

- استخدام `const` constructors
- Clean Architecture (3 layers)
- Feature-first organization
- Riverpod لإدارة الحالة
- Isar للقاعدة المحلية

**التفاصيل:** `.kiro/guides/flutter-guide.md`

---

## العربية (Arabic)

### المصطلحات الأساسية

- Customer → عميل
- Invoice → فاتورة
- Total → الإجمالي
- Tax → الضريبة
- Payment → الدفع

### القواعد

- استخدام الفاصلة العربية (،)
- استخدام علامة الاستفهام العربية (؟)
- الأرقام الهندية (123) موصى بها

**التفاصيل:** `.kiro/standards/arabic.md`

---

## Git

### Commit Messages

```
type(scope): description

feat: إضافة ميزة جديدة
fix: إصلاح خطأ
docs: تحديث التوثيق
```

### Branching

- `main`: مستقر دائماً
- `feature/*`: للميزات الجديدة
- `fix/*`: للإصلاحات

**التفاصيل:** `.kiro/guides/git-guide.md`

## DORA/SPACE Metrics

### DORA Targets

- **Deployment Frequency**: Daily
- **Lead Time**: < 1 day
- **Change Failure Rate**: < 15%
- **Recovery Time**: < 1 hour

### SPACE Dimensions

- **Satisfaction**: Developer happiness (Target: 7.5+/10)
- **Performance**: Code quality and reliability
- **Activity**: Development work patterns
- **Communication**: Information flow effectiveness
- **Efficiency**: Minimal friction and interruptions

**التفاصيل:** `.kiro/templates/dora-space-metrics.md`

---

## Zero-Trust Security

### Core Principles

- ❌ Never trust, always verify
- ✅ Continuous authentication
- ✅ Least privilege access
- ✅ Supply chain security
- ✅ Artifact signing

**التفاصيل:** `.kiro/steering/technologies/security-best-practices.md`

---

**للمراجع الكاملة:** `.kiro/reference/`
