# تصميم شريحة Drift الثانية: أسعار السوق

## نموذج التخزين

ينشئ الـschema جدول `market_prices` بعمود `id` نصي كمفتاح رئيسي، و`item_id`، و`price`، و`as_of_date`، و`created_at`. يطابق ذلك UUID الفريد في Isar ويزيل الاعتماد على `Id? isarId`. يضاف فهرس مركب `(item_id, as_of_date)` لتسريع الاستعلامين الأكثر استخدامًا، كما يحافظ الفهرس المنطقي على عدم وجود سجلين بالمعرف نفسه.

## DAO المحايد

يقدم `MarketPriceStore` دوال `upsert` و`latestForItem` و`historyForItem` و`latestForAllItems`. تتعامل الدوال مع DTO `MarketPriceRecord` فقط ولا تستورد كيان reports أو Freezed أو Supabase.

| عقد Isar الحالي | عقد Drift المقابل |
|---|---|
| `put(MarketPriceModel)` | upsert بحسب `id` |
| `itemIdEqualTo + asOfDateLessThan(include: true) + sort desc + findFirst` | `item_id = ? AND as_of_date <= ? ORDER BY as_of_date DESC, created_at DESC, id DESC LIMIT 1` |
| history حسب itemId | `WHERE item_id = ? ORDER BY as_of_date DESC, created_at DESC, id DESC` |
| أحدث سجل لكل صنف ضمن تاريخ | تصفية `as_of_date <= ?` ثم اختيار أول سجل ضمن ترتيب حتمي لكل `item_id` |

## الترتيب الحتمي

كان Isar يحدد ترتيب التاريخ فقط. يضيف Drift `created_at DESC, id DESC` عند تساوي `as_of_date` كي تكون النتيجة حتمية عبر SQLite وWeb. لا يغير ذلك نتيجة الحالات التي تملك تواريخ مختلفة؛ وتتحقق الاختبارات من حالة التعادل صراحة.

## migration

يرتفع `schemaVersion` من 1 إلى 2. في `onUpgrade` ينشأ جدول `market_prices` فقط عندما يكون `from < 2`. لا تلمس هذه الترقية جدول Isar أو بياناته، ولا تنفذ نسخ بيانات تلقائيًا. تتولى موجة لاحقة أداة استيراد قابلة للاستئناف، بعد تطابق القراءات على البيانات الفعلية.

## حدود التنفيذ

يضاف مكيّف `DriftMarketPriceRepository` دون تسجيله في providers. يبقى `MarketPriceRepositoryImpl` المعتمد على Isar هو التنفيذ النشط. وتغطي الاختبارات التكافؤ السلوكي للحالات: عدم وجود سعر، الحد الشامل، التاريخ التنازلي، upsert، والسعر الأحدث لكل صنف مع تعادل زمني.
