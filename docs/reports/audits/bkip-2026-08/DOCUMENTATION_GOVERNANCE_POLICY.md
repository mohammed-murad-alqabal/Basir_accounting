# BKIP — سياسة حوكمة الوثائق والمعرفة

> **الحالة:** مقترح جاهز للاعتماد. لا يغيّر تلقائيًا سلطة الوثائق القائمة قبل اعتماد مالك المشروع.

## 1. المبدأ

التوثيق جزء من النظام، ولذلك يدار بإصدارات ومالكين ومراجعة وأدلة، لا كمجموعة ملاحظات. لا يوجد مصدر حقيقة واحد مطلق لكل سؤال: واقع المستودع يحكم السلوك الفعلي، والمتطلبات المعتمدة تحكم النية، ودليل CI/الاختبار يحكم الادعاء بالتحقق.

## 2. نموذج السلطة

| الطبقة | النوع | مستوى السلطة | مثال | لا يجوز استخدامها لـ |
|---|---|---:|---|---|
| واقع التنفيذ | كود، ترحيلات، config، اختبار، artifact CI | 0 | `lib/`, `rust/`, workflows | استنتاج نية منتج غير موثقة. |
| نية معتمدة | `REQ-*` مع معيار قبول | 1 | مواصفة نطاقية مع مالك | تقرير اكتمال أو شرح تنفيذي عام. |
| قرار/تصميم | `ADR-*`، data/security/API contracts | 2 | قرار تخزين/مصادقة | تغيير requirement بلا موافقة. |
| خطة | `TASK-*`، roadmap، PR plan | 3 | خارطة المراحل | إثبات تنفيذ أو امتثال. |
| دليل تشغيلي | guide، runbook، reference | 4 | الاسترجاع والتشغيل | إنشاء التزام منتج. |
| تاريخ/دليل | report، status، session، audit، archive | 5 | تقرير اختبار مؤرخ | الحالة الحالية بلا SHA/evidence حديث. |

## 3. metadata إلزامية

كل وثيقة حية حاكمة أو تشغيلية يجب أن تبدأ بكتلة واضحة (YAML أو جدول) تتضمن:

| الحقل | المطلوب |
|---|---|
| `document_id` | معرّف ثابت، مثل `REQ-ACC-001` أو `ADR-004`. |
| `title` | اسم وحيد واضح. |
| `status` | `DRAFT`, `ACTIVE`, `APPROVED`, `SUPERSEDED`, `ARCHIVED`. |
| `authority_level` | من 0 إلى 5 حسب جدول السلطة. |
| `owner` | دور مسؤول، لا اسم مجهول. |
| `approved_by` | مطلوب لـREQUIREMENT/ADR الحاكم. |
| `effective_from` | تاريخ/نسخة بداية السريان. |
| `last_verified_sha` | مطلوب لأي ادعاء سلوك/اختبار/حالة. |
| `supersedes` / `superseded_by` | روابط صريحة عند الاستبدال. |
| `related_requirements` | IDs فقط، لا عناوين غامضة. |
| `review_due` | موعد مراجعة محدد. |

## 4. دورة الحياة

| الانتقال | من يوافق | شروطه |
|---|---|---|
| DRAFT → ACTIVE | owner + reviewer | نطاق ومالك ومسار مراجعة واضحان. |
| ACTIVE → APPROVED | owner + engineering/domain approver | IDs، معايير قبول، أثر معماري/أمني/محاسبي معروف. |
| APPROVED → SUPERSEDED | owner + approver | رابط البديل وخطة migration وتأثير واضح. |
| أي حالة → ARCHIVED | owner | banner تاريخي، سبب، تاريخ، والروابط إلى البديل/الدليل. |
| ARCHIVED → DELETE | owner + repository maintainer | فحص روابط، سياسة retention، إثبات عدم فقد دليل، وقابلية الاسترجاع عبر Git. |

لا يوجد انتقال «Active → Completed» بالاسم فقط؛ تكتمل **المهمة أو المتطلب** عند تحقق acceptance evidence، بينما تبقى الوثيقة الحاكمة `APPROVED` أو تُستبدل.

## 5. قواعد التغيير

عند تغيير كود له أثر محاسبي أو أمني أو تكاملي أو امتثال أو مخطط بيانات، يجب أن يتضمن PR في الوصف: IDs المتطلبات، ADRs المتأثرة، ملفات التوثيق المحدثة، الاختبارات، وارتباط artifact CI. يحظر على PR استعمال «complete»، «verified»، «production ready»، «compliant»، أو نسبة تغطية من دون SHA أو رابط دليل قابل للوصول.

| نوع التغيير | تحديث إلزامي |
|---|---|
| قاعدة قيد/ترحيل/عكس/قفل | `Accounting Invariants` + REQ + اختبار خاصية/تكامل. |
| حقل/نوع/ترحيل | data dictionary + mapping Isar/PostgreSQL + ADR عند تغير الحدود. |
| مصادقة/إذن/سر | security control + threat model + test/CI evidence. |
| ZATCA/VAT/قانون | compliance evidence register + scope/status + مراجعة owner. |
| token/مكون UX | canonical design tokens + visual/accessibility test. |
| API/sync/backup | versioned contract + runbook + recovery/integration tests. |

## 6. الحراسة الآلية المقترحة

لا ينبغي أن تعتمد الحوكمة على التذكير اليدوي. يضاف فحص CI تدريجيًا للتحقق من metadata، صلاحية الروابط، معرّفات REQ في PR، وعدم وجود وثيقة حاكمة بلا owner/review due. يضاف أيضًا فحص خاص يمنع الانتقال إلى `VERIFIED` إذا غاب `last_verified_sha` وartifact CI أو evidence موثق.

```text
Changed source path
  → map to domain rules
  → require REQ / ADR / docs links in PR
  → execute targeted tests
  → store CI artifact and SHA
  → approve documentation update
  → permit merge
```

## 7. المسؤوليات

| الدور | المسؤولية |
|---|---|
| Engineering Lead | الحسم في تضارب السلطة، اعتماد ADRs، تعيين المالكين. |
| Accounting Domain Owner | قواعد القيد والتقارير والعملات والفترات والأدلة المالية. |
| Security Owner | نموذج التهديد والضوابط والمصادقة والأسرار والأدلة. |
| Compliance Owner | نطاق ZATCA/VAT وحالة المحاكاة/الاختبار/الاعتماد. |
| Data Owner | قاموس البيانات والترحيلات وعقود التحويل والمزامنة. |
| QA Owner | معايير القبول وevidence index وقابلية إعادة الاختبار. |
| Documentation Steward | الفهرسة، الروابط، الأرشفة، الصحة الشكلية؛ لا يمنح صلاحية تقنية بمفرده. |

## 8. تعريف الانجراف ومؤشرات الإنذار

تعد الوثيقة منجرفة عندما يغير SHA التنفيذ المرتبط بها من دون تحديثها، أو عندما تعلن حالة لا يثبتها artifact، أو عندما تستخدم مصطلحًا مخالفًا للقاموس، أو تبقى beyond `review_due`. تفتح بطاقة `DOC-DRIFT-*` تربط الادعاء والدليل والحالة والإجراء، ولا تعالج بحذف صامت.

| مؤشر | إنذار |
|---|---|
| وثيقة حاكمة بلا `owner` أو `last_verified_sha` | حرج. |
| ادعاء «complete/compliant» بلا artifact | حرج. |
| REQ بلا test/evidence | عالٍ. |
| ADR بلا `superseded_by` بعد تغير معماري | عالٍ. |
| تقرير حالة في مسار حي أقدم من 90 يومًا | متوسط؛ يحتاج archive أو refresh. |
| عنوان مكرر/محتوى متطابق | متوسط؛ يفتح مراجعة، لا حذفًا. |

## 9. المراجع

[1]: KNOWLEDGE_INTEGRITY_REPORT.md "نتائج تدقيق BKIP"
[2]: DOCUMENT_MIGRATION_PLAN.md "خطة الهجرة"
[3]: REQUIREMENTS_TRACEABILITY_MATRIX.md "مصفوفة التتبّع"

**المؤلف:** Manus AI
