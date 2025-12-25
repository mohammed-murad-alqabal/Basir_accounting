# دليل المكونات الأساسية

**تاريخ:** 25 ديسمبر 2025  
**الإصدار:** 1.0  
**المشروع:** بصير MVP

---

## 📋 نظرة عامة

هذا الدليل يوثق المكونات الأساسية لواجهة المستخدم في تطبيق بصير. جميع المكونات مبنية على نظام Design Tokens وتضمن تجربة متسقة.

### المكونات المتاحة

1. **AppButton** - نظام الأزرار الموحد
2. **AppCard** - البطاقات والحاويات
3. **AppTextField** - حقول الإدخال

---

## 🔘 AppButton

نظام أزرار متقدم مع دعم حالات متعددة وحركات سلسة.

### الأنواع المتاحة

#### 1. AppPrimaryButton (الزر الأساسي)

```dart
import 'package:basser_app/core/widgets/app_button.dart';

AppPrimaryButton(
  label: 'حفظ',
  onPressed: () {
    // معالجة الضغط
  },
)
```

**الميزات:**

- لون خلفية أزرق (`ButtonColors.primaryBackground`)
- نص أبيض (`ButtonColors.primaryForeground`)
- تباين: **7.04:1** ✅
- haptic feedback عند الضغط
- حركة scale animation

#### 2. AppSecondaryButton (الزر الثان)

```dart
AppSecondaryButton(
  label: 'إلغاء',
  onPressed: () {
    // معالجة الإلغاء
  },
)
```

**الميزات:**

- خلفية رمادية فاتحة
- تباين: **5.14:1** ✅
- مناسب للإجراءات الثانوية

#### 3. AppTextButton (زر النص)

```dart
AppTextButton(
  label: 'تخطي',
  onPressed: () {
    // معالجة التخطي
  },
)
```

**الميزات:**

- بدون خلفية
- نص ملون فقط
- مناسب للروابط والإجراءات الخفيفة

#### 4. AppOutlinedButton (زر بإطار)

```dart
AppOutlinedButton(
  label: 'تفاصيل',
  onPressed: () {
    // معالجة التفاصيل
  },
)
```

#### 5. AppDangerButton (زر الخطر)

```dart
AppDangerButton(
  label: 'حذف',
  onPressed: () {
    // تأكيد الحذف
  },
)
```

**الميزات:**

- لون أحمر (`ButtonColors.dangerBackground`)
- تباين: **5.62:1** ✅
- للإجراءات الحرجة

### الأحجام

```dart
// صغير (44px)
AppPrimaryButton(
  label: 'صغير',
  size: ButtonSize.small,
  onPressed: () {},
)

// متوسط (48px) - الافتراضي
AppPrimaryButton(
  label: 'متوسط',
  size: ButtonSize.medium,
  onPressed: () {},
)

// كبير (52px)
AppPrimaryButton(
  label: 'كبير',
  size: ButtonSize.large,
  onPressed: () {},
)
```

### حالة التحميل

```dart
AppPrimaryButton(
  label: 'إرسال',
  isLoading: isSubmitting,
  onPressed: isSubmitting ? null : _handleSubmit,
)
```

### حالة التعطيل

```dart
AppPrimaryButton(
  label: 'غير متاح',
  onPressed: null,  // معطّل
)
```

### مع أيقونة

```dart
AppPrimaryButton(
  label: 'إضافة',
  icon: AppIcons.add,
  onPressed: () {},
)
```

### API الكامل

```dart
AppPrimaryButton({
  required String label,           // النص (إجباري)
  required VoidCallback? onPressed, // معالج الضغط
  ButtonSize size = ButtonSize.medium,
  bool isLoading = false,
  IconData? icon,
  bool fullWidth = false,
})
```

---

## 🃏 AppCard

نظام بطاقات مرن للمحتوى.

### AppCard الأساسية

```dart
import 'package:basser_app/core/widgets/app_card.dart';

AppCard(
  child: Padding(
    padding: EdgeInsets.all(Spacing.md),
    child: Text('محتوى البطاقة'),
  ),
)
```

**الميزات:**

- خلفية بيضاء (`SemanticColors.surface`)
- حدود مستديرة (`Radii.md`)
- ظل خفيف (`Elevation.low`)

### AppCard قابلة للضغط

```dart
AppCard(
  onTap: () {
    // معالجة الضغط
  },
  child: // محتوى...
)
```

**الميزات:**

- haptic feedback
- scale animation عند الضغط
- تأثير hover

### AppCard محددة

```dart
AppCard(
  isSelected: isSelected,
  onTap: () {
    setState(() => isSelected = !isSelected);
  },
  child: // محتوى...
)
```

### AppListCard (بطاقة قائمة)

```dart
AppListCard(
  title: 'العنوان',
  subtitle: 'الوصف',
  leading: Icon(AppIcons.person),
  trailing: Icon(AppIcons.chevronRight),
  onTap: () {
    // معالجة الضغط
  },
)
```

### AppStatCard (بطاقة إحصائية)

```dart
AppStatCard(
  title: 'العملاء',
  value: '234',
  icon: AppIcons.people,
  trend: StatTrend.up,
  trendValue: '+12%',
)
```

**الاتجاهات:**

- `StatTrend.up` - زيادة (أخضر)
- `StatTrend.down` - نقصان (أحمر)
- `StatTrend.neutral` - ثابت (رمادي)

### API الكامل

```dart
AppCard({
  required Widget child,
  VoidCallback? onTap,
  bool isSelected = false,
  EdgeInsets? padding,
  double? elevation,
  BorderRadius? borderRadius,
})
```

---

## 📝 AppTextField

حقل إدخال متقدم مع دعم التحقق و RTL.

### الاستخدام الأساسي

```dart
import 'package:basser_app/core/widgets/app_text_field.dart';

AppTextField(
  label: 'اسم المستخدم',
  hint: 'أدخل اسمك',
  onChanged: (value) {
    // معالجة التغيير
  },
)
```

### أنواع لوحة المفاتيح

```dart
// بريد إلكتروني
AppTextField(
  label: 'البريد الإلكتروني',
  keyboardType: TextInputType.emailAddress,
)

// رقم
AppTextField(
  label: 'الهاتف',
  keyboardType: TextInputType.phone,
)

// كلمة مرور
AppTextField(
  label: 'كلمة المرور',
  isPassword: true,
)
```

### التحقق

```dart
AppTextField(
  label: 'البريد الإلكتروني',
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'الحقل مطلوب';
    }
    if (!value.contains('@')) {
      return 'بريد إلكتروني غير صالح';
    }
    return null;
  },
)
```

### مع Controller

```dart
final controller = TextEditingController();

AppTextField(
  label: 'الاسم',
  controller: controller,
)

// للحصول على القيمة
final name = controller.text;
```

### مع أيقونات

```dart
// أيقونة بداية
AppTextField(
  label: 'البحث',
  prefixIcon: Icon(AppIcons.search),
)

// أيقونة نهاية
AppTextField(
  label: 'البريد',
  suffixIcon: Icon(AppIcons.email),
)
```

### حالة الخطأ

```dart
AppTextField(
  label: 'الحقل',
  errorText: hasError ? 'قيمة غير صحيحة' : null,
)
```

### متعدد الأسطر

```dart
AppTextField(
  label: 'الوصف',
  maxLines: 5,
  hint: 'أدخل وصفاً مفصلاً...',
)
```

### API الكامل

```dart
AppTextField({
  required String label,
  String? hint,
  TextEditingController? controller,
  ValueChanged<String>? onChanged,
  FormFieldValidator<String>? validator,
  TextInputType? keyboardType,
  bool isPassword = false,
  int maxLines = 1,
  Widget? prefixIcon,
  Widget? suffixIcon,
  String? errorText,
  bool enabled = true,
})
```

---

## 🎨 التخصيص المتقدم

### مثال: نموذج تسجيل دخول كامل

```dart
class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // معالجة تسجيل الدخول
      await loginUser(
        email: _emailController.text,
        password: redacted,
      );
    } catch (e) {
      // معالجة الخطأ
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        spacing: Spacing.md,
        children: [
          AppTextField(
            label: 'البريد الإلكتروني',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icon(AppIcons.email),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'الحقل مطلوب';
              }
              return null;
            },
          ),

          AppTextField(
            label: 'كلمة المرور',
            controller: _passwordController,
            isPassword: true,
            prefixIcon: Icon(AppIcons.lock),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'الحقل مطلوب';
              }
              return null;
            },
          ),

          SizedBox(height: Spacing.lg),

          AppPrimaryButton(
            label: 'تسجيل الدخول',
            isLoading: _isLoading,
            fullWidth: true,
            onPressed: _isLoading ? null : _handleLogin,
          ),

          AppTextButton(
            label: 'نسيت كلمة المرور؟',
            onPressed: () {
              // الانتقال لاستعادة كلمة المرور
            },
          ),
        ],
      ),
    );
  }
}
```

---

## ♿ إمكانية الوصول

جميع المكونات متوافقة مع **WCAG 2.1 AA**:

### ✅ المعايير المطبقة

1. **التباين اللوني:** جميع الأزرار ≥ 4.5:1
2. **Touch Targets:** جميع العناصر التفاعلية ≥ 44x44px
3. **Semantic Labels:** دعم كامل لقارئ الشاشة
4. **Text Scaling:** حتى 200%
5. **RTL Support:** دعم اللغة العربية والإنجليزية

### مثال: التحقق من التباين

```bash
flutter test test/core/theme/tokens_test.dart
```

---

## 📚 روابط مفيدة

- [دليل Design Tokens](design_tokens_guide.md)
- [الكود المصدري](file:///home/m/Projects/Basser_MVP/lib/core/widgets)
- [الاختبارات](file:///home/m/Projects/Basser_MVP/test/core/widgets)

---

**آخر تحديث:** 25 ديسمبر 2025  
**الحالة:** ✅ معتمد للإنتاج
