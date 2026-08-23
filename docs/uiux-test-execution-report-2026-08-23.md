# تقرير تنفيذ اختبارات UI/UX — 2026-08-23

**المشروع:** Basir Accounting  
**الفرع:** `manus/basir-ui-ux-foundation`  
**النطاق:** الدفعتان الأولى والثانية من تنفيذ خطة الاختبار الشاملة

## الملخص التنفيذي

تم تحويل مجموعة موسعة من متطلبات UI/UX إلى اختبارات قابلة للتشغيل داخل مستودع المشروع. تغطي الدفعة الحالية هيكل `BasirAppShell` والتنقل الجانبي والاستجابة والوصولية، و`Omnibar`، وGolden للشريط العلوي بالعربية، ورحلة تسجيل الدخول، ومحرر مستندات الفاتورة، وشاشة أصناف المخزون، ولوحة التقارير. كما كُشف عيب بصري/وظيفي حقيقي في التخطيط المضغوط لمحرر المستند عند حجم هاتف فعلي، وتم إصلاحه بإتاحة تمرير المحتوى عموديًا بدل ترك `Column` غير قابل للتمرير.

نتيجة التحقق المحلي الحالية هي **39 اختبارًا ناجحًا** في المجموعة المركزة الموسعة، مع نجاح التحليل الساكن للمساحات المعدلة وعدم وجود فروقات تنسيق أو trailing whitespace. لم يُعتمد نجاح اختبار التطبيق الحي على Linux؛ إذ تعذر الوصول إلى assertions الخاصة بالرحلة بسبب مشكلة بيئة بناء في CMake وRPATH ومسار تثبيت bundle، ولذلك تم فصل هذه النتيجة عن صحة سلوك التطبيق وعدم وصفها كنجاح وظيفي.

أُعد Workflow مستقل باسم `Basir UI/UX Regression` ليشمل الآن مسارات الفواتير والمخزون والتقارير، واختبارات الرحلات الجديدة، والتحقق من format وanalyze وbuild_runner ورفع artifacts عند الفشل. بقي ملف Workflow غير منشور لأن رمز الوصول الحالي لا يملك صلاحية `workflows` اللازمة لتحديث GitHub Actions؛ لذلك يجب اعتباره ملفًا محليًا جاهزًا للمراجعة، لا فحصًا منشورًا على GitHub.

## ما تم تنفيذه

| المجال | التنفيذ والتحقق |
|---|---|
| AppShell | اختبارات حدود الاستجابة، الوحدات الإنتاجية، التنقل، الطي، الحالة النشطة، الإشعارات، وSemantics عند الطي. |
| Topbar وGolden | اختبارا سطح مكتب وعرض مضغوط بالعربية مع RTL وتهيئة Cairo قبل الرسم. الاختبار البكسلي يمر، لكن المراجعة البشرية النهائية للـ glyphs العربية ما زالت مطلوبة من artifact موثوق. |
| Omnibar | اختبارات فتح الاقتراحات، تنفيذ أوامر إنشاء فاتورة، تنفيذ نتيجة بحث، وحالة عدم وجود نتائج. |
| المصادقة | رحلة Widget تبدأ بإدخال بيانات demo، تضغط زر الدخول، تتحقق من استدعاء `login` و`setKeepLoggedIn`، ثم تتحقق من الوصول إلى مسار لوحة التحكم. تم تثبيت `appIconsProvider` في الاختبار لتجنب تهيئة Supabase غير اللازمة. |
| محرر الفواتير | اختبارات التخطيط المكتبي والمضغوط، ظهور إجراءات المعاينة والحفظ والترحيل، تعطيل الترحيل قبل preview، وتمكينه بعد preview صالح. |
| إصلاح overflow | أضيف `SingleChildScrollView` حول التخطيط المضغوط في `DocumentEditor`، مع اختبار regression صريح بحجم `390×844` يثبت أن `tester.takeException()` يساوي `null`. |
| المخزون | اختبارات التحميل، عرض الأصناف، البحث بالاسم وSKU، Semantics للكمية والمعرفات، الحالة الفارغة، حالة الخطأ، والانتقال إلى نموذج الإضافة/التعديل باستخدام repository ذاكرية مضبوطة. |
| التقارير | اختبارات ظهور أقسام لوحة التقارير والتنقل إلى تقريري أعمار العملاء والموردين، مع overrides لخدمات التقارير وبيانات المستخدم. |
| CI | توسيع Workflow المحلي ليشمل مسارات `invoices` و`inventory` و`reports` واختبارات الرحلات المقابلة، مع الاحتفاظ برفع artifacts عند الفشل. |

## نتائج التحقق المحلي

### التحليل والتنسيق

تم تشغيل `dart format` على الملفات المعدلة، ثم تشغيل التحليل التالي باستخدام Flutter 3.35.5:

```bash
flutter analyze --fatal-infos \
  lib/features/invoices/presentation/widgets \
  lib/features/inventory/presentation/screens \
  lib/features/reports/presentation/screens \
  lib/shared/widgets/document_editor \
  test/widget/features/auth \
  test/widget/features/invoices \
  test/widget/features/inventory \
  test/widget/features/reports
```

النتيجة: **لا توجد ملاحظات تحليلية**. كما اجتاز المستودع `git diff --check` دون أخطاء، واجتاز `dart format --set-exit-if-changed` للمساحات التي شملها التحقق بعد تطبيق التنسيق المطلوب.

### مجموعة الاختبارات المركزة

تم تشغيل الاختبارات التالية بترتيب متسلسل لتقليل تداخل الحالة بين اختبارات Flutter:

```bash
flutter test --concurrency=1 --reporter expanded \
  test/unit/shared/widgets/app_shell_test.dart \
  test/golden/basir_topbar_golden_test.dart \
  test/widget/features/navigation/presentation/widgets/omnibar_test.dart \
  test/widget/features/auth/presentation/screens/login_ui_journey_test.dart \
  test/widget/features/invoices/presentation/widgets/document_editor_responsive_test.dart \
  test/widget/features/inventory/presentation/screens/inventory_items_screen_test.dart \
  test/widget/features/reports/reports_dashboard_screen_test.dart
```

النتيجة: **39 اختبارًا ناجحًا، ولا توجد إخفاقات**.

| المجموعة | النتيجة |
|---|---:|
| AppShell | 22 ناجحًا |
| Topbar Golden | 2 ناجحان |
| Omnibar | 3 ناجحة |
| Login UI journey | 1 ناجح |
| DocumentEditor responsive | 4 ناجحة |
| InventoryItemsScreen | 4 ناجحة |
| ReportsDashboardScreen | 3 ناجحة |
| **الإجمالي** | **39 ناجحًا** |

## العيب المكتشف والإصلاح

قبل الإصلاح، كان التخطيط المضغوط في `DocumentEditor` يعيد `Column` مباشرة داخل مساحة viewport محدودة. وعند وضع محتوى طويل نسبيًا في حجم هاتف `390×844` كان ذلك يعرض التطبيق لخطر `RenderFlex overflow` بدل السماح للمستخدم بالوصول إلى الملخص والإجراءات بالتمرير.

تم تعديل التخطيط المضغوط ليستخدم `SingleChildScrollView` مع الإبقاء على المفتاح `documentEditorCompactLayout` وبقية سلوك الملخص دون تغيير. أضيفت حالة اختبار مخصصة للحجم `390×844` حتى لا يختفي هذا العيب مرة أخرى خلف اختبار يستخدم ارتفاعًا اصطناعيًا كبيرًا مثل `1400`.

## المراجعة البصرية للـ Golden

الاختبارات البكسلية للـ Golden تمر، وتم توليد baseline لسطح المكتب والعرض المضغوط. غير أن معاينة الصور في عارض بيئة العمل أظهرت glyphs عربية كمربعات، رغم وجود Cairo ضمن أصول المشروع وتهيئته قبل الرسم. لذلك لا يُقدَّم هذا التقرير على أنه اعتماد بصري نهائي للخط العربي؛ يلزم فحص artifact صادر من CI أو مراجعة بشرية على بيئة تعرض Cairo بصورة سليمة. هذه الملاحظة محفوظة أيضًا في `docs/uiux-golden-visual-review-notes.md`.

## اختبار التطبيق الحي

تمت توسعة `integration_test/live_app_tour_test.dart` استكشافيًا لمحاولة المرور بالمخزون والتقارير قبل الإعدادات والعودة للرئيسية. لم تُعتمد هذه التوسعة بعد، لأن harness الحالي يستخدم محدد `BottomNavigationBar` بينما بنية `BasirAppShell` الحديثة قد تستخدم تنقلًا مخصصًا للهاتف. كما أن تشغيل Linux integration محليًا توقف أثناء بناء bundle بسبب مسار تثبيت CMake إلى `/usr/local/basir_app` ومشكلة RPATH، قبل الوصول إلى assertions الخاصة بالرحلة.

وعليه، تبقى اختبارات Widget ذات repository/service overrides هي الدليل القابل لإعادة التشغيل حاليًا، بينما تحتاج الجولة الحية إلى جهاز/بيئة CI مناسبة ومحددات Semantics مستقرة قبل إدخالها في بوابة الإصدار.

## حالة GitHub وCI

ملف `.github/workflows/uiux-regression.yml` موجود محليًا ويتضمن التوسعة المطلوبة، لكنه غير متعقّب في Git بسبب تعذر دفع ملفات `.github/workflows/**` بالرمز الحالي. لا ينبغي اعتبار Workflow فعالًا على GitHub حتى يتم منحه صلاحية `workflows` ثم رفعه ومراجعة تشغيله على Flutter `3.44.9`.

الملفات غير المتعلقة بـWorkflow قابلة للالتزام والدفع بعد المراجعة، مع إبقاء `.env` المحلي خارج الالتزام. كما ينبغي عدم دفع توسعة `integration_test/live_app_tour_test.dart` قبل تثبيت محدد التنقل وتشغيلها على بيئة بناء مناسبة.

## بوابة القبول الحالية

| البند | الحالة | الملاحظة |
|---|---|---|
| تنسيق Dart للمساحات المعدلة | ناجح | لا توجد تغييرات تنسيق متبقية. |
| `flutter analyze --fatal-infos` للمساحات المعدلة | ناجح | لا توجد ملاحظات. |
| اختبارات AppShell وGolden وOmnibar | ناجح | 27 اختبارًا من الدفعة الأولى. |
| اختبار Login UI journey | ناجح | يعتمد على mocks/overrides آمنة. |
| اختبار DocumentEditor responsive | ناجح | يتضمن regression لحجم 390×844. |
| اختبارات المخزون والتقارير | ناجح | 7 اختبارات مع repositories/services مضبوطة. |
| مراجعة Golden العربية النهائية | قيد الانتظار | يلزم artifact من بيئة تدعم Cairo أو مراجعة بشرية موثوقة. |
| اختبار التطبيق الحي Linux | محجوب بيئيًا | فشل build bundle قبل assertions بسبب CMake/RPATH. |
| نشر Workflow إلى GitHub | محجوب بالصلاحية | الرمز الحالي يرفض تحديث ملفات Actions دون `workflows`. |

## الخطوات التالية

الخطوة العملية التالية هي الالتزام ودفع الملفات غير المتعلقة بـWorkflow بعد مراجعة diff، ثم تشغيل فحوص PR المتاحة على الفرع. بعد توفير صلاحية `workflows`، يجب دفع Workflow وتشغيله على Flutter `3.44.9` ومراجعة artifacts بصريًا. وبعد تثبيت تنقل الهاتف، يمكن إعادة اعتماد الجولة الحية ثم إضافة رحلات أعمق للفواتير والمخزون تعتمد على بيانات اختبار مضبوطة وعقود repository حقيقية، دون اختلاق نتائج محاسبية أو ترحيلات غير مغطاة بعقد واضح.

## المراجع

[1]: https://github.com/mohammed-murad-alqabal/Basir_accounting "مستودع Basir Accounting"

[2]: https://github.com/mohammed-murad-alqabal/Basir_accounting/pull/162 "مسودة Pull Request لتحسينات UI/UX"

[3]: https://github.com/mohammed-murad-alqabal/Basir_accounting/blob/manus/basir-ui-ux-foundation/docs/ui-ux-comprehensive-test-plan.md "خطة اختبار UI/UX الشاملة"
