# ADR-PLAT-001 — حد دعم بناء Web ومنصة التخزين المحلية

> **document_id:** ADR-PLAT-001
> **status:** DRAFT
> **authority_level:** 2
> **owner:** Architecture Owner + Data Owner
> **approved_by:** Pending formal repository owner approval
> **effective_from:** 2026-08-14
> **last_verified_sha:** `b790cc815ec34b4606d9b76f14aae88d6eeec63f`
> **review_due:** 2026-09-14
> **related_requirements:** REQ-DATA-001, REQ-UX-004
> **supersedes:** None

## السياق

يستخدم التطبيق `Isar 3.1.0` ونماذج `@Collection` ذات `Id id = Isar.autoIncrement`. عند توليد schemas ثم تنفيذ `flutter build web` في تشغيل PR اليدوي `31768371322`، فشل compiler بسبب schema IDs مولدة أكبر من دقة أعداد JavaScript. لا يمثل ذلك خطأً في Atlas أو في اختباراته: تقرير Isar يصف الحالة نفسها مع `Id id = Isar.autoIncrement`، وتشخيص Dart يبين أن الأعداد خارج المجال `-(2^53 - 1)` إلى `2^53 - 1` قد تتغير قيمتها عند الترجمة إلى JavaScript.[1][2]

> **حد الدليل:** لا يثبت هذا القرار أن إصدار Isar الحالي غير صالح في كل سيناريو Web، ولا يجيز تجاهل مشكلة التخزين. إنه يثبت فقط أن تركيبة التطبيق الحالية لا تنتج Web artifact صحيحًا على SHA الموثق.

## القرار

يبقى توليد Android مع التحليل والاختبارات والأمن بوابة مانعة لطلبات الدمج. لا يشغّل مسار CI المطلوب `flutter build web` حاليًا، لأن الحزمة الحالية لا تنتج artifact ويب صحيحًا؛ ويعاد تشغيله كتحقق تحقيق يدوي موثق عند العمل على توافق Web، إلى أن يعتمد مالكا Architecture وData واحدًا مما يأتي:

1. طبقة تخزين بديلة ومدعومة للويب مع عقد DTO ومزامنة واختبارات تكامل، أو
2. مسار conditional platform يعزل Isar تمامًا عن Web ويقدم repository مكافئًا مثبتًا بالاختبارات.

يظل فشل بناء Web الموثق متاحًا في سجل التحقيق، ولا يعلن تعليق هذا المسار دعم Web أو جاهزيته للإنتاج. يعاد إدخاله كبوابة مانعة فقط بعد نجاح البديل المعتمد على SHA موثق.

## النتائج

| القرار | الأثر | معيار الإغلاق |
|---|---|---|
| Android build إلزامي | يحافظ على artifact لمنصة التخزين الفعلية. | نجاح `Build Test (android)` على SHA الدمج. |
| Web build خارج بوابة CI المطلوبة | يمنع تكرار فشل معروف مع بقاء إعادة التحقيق اليدوي ممكنة. | لا يتحول إلى مانع إلا بعد إثبات بديل التخزين. |
| بديل Web صريح | يمنع إدخال Isar إلى bundle ويب من دون عقد. | ADR محدث + DTO contract + تكامل Web + دليل CI. |
| حظر الادعاءات | يمنع تسمية المنتج داعمًا للويب بلا دليل. | مراجعة الوثائق وواجهة المنتج قبل تغيير الحالة. |

## المخاطر وخطة الترحيل

إخراج Web من بوابة CI المطلوبة يحمل خطر تأخر اكتشاف عيوب منصة ويب مستقبلية. يعالج ذلك بإعادة التحقيق اليدوي عند أي عمل Web، وبتوثيق مالك وخطة انتقال قبل إعادة تصنيفه كمسار مطلوب. لا يحذف هذا القرار Isar، ولا يغير schema، ولا يرحل بيانات المستخدمين. أي استبدال تخزين يحتاج ADR متابعة، وخطة migration قابلة للرجوع، واختبار بيانات حقيقية خالٍ من الأسرار.

## التحقق

يعاد التحقق عبر تشغيل `flutter build web` وإرفاق السجل عند أي نطاق يطلب Web إلى أن تعتمد استراتيجية البديل. أما قبول طلبات الدمج الحالية فيتطلب نجاح التحليل بعد code generation، واختبارات العزل التسلسلي، وبناء Android، وفحوص الأمن والاعتماديات وفق سياسة حماية الفرع.

## المراجع

[1]: https://github.com/isar/isar/issues/1255 "Isar issue #1255 — generated schema IDs fail on web"
[2]: https://dart.dev/tools/diagnostics/avoid_js_rounded_ints "Dart diagnostic — avoid_js_rounded_ints"
[3]: https://github.com/isar/isar/issues/686 "Isar issue #686 — web support discussion"
[4]: ADR-DATA-001-financial-data-boundaries.md "حدود البيانات المالية"
[5]: ../../audits/bkip-2026-08/TEST_RUNNER_STABILITY_INCIDENT_2026-08-13.md "حادثة استقرار عامل الاختبارات"
