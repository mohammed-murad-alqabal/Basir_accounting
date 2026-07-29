[OPEN] Debug Session: mobile-device-validation

هدف الجلسة

- تشغيل التطبيق على جهاز أندرويد متصل عبر USB وجمع أدلة تشغيل (Runtime Evidence) لتحديد المشاكل وإصلاحها بأقل تغييرات ممكنة ثم التحقق بعد الإصلاح على نفس الجهاز.

البيئة

- التاريخ: 2026-07-28
- الجهاز: (سيتم تعبئته بعد كشف adb)
- وضع التشغيل: Debug / Profile / Release (سيتم تحديده أثناء إعادة الإنتاج)

الأعراض المتوقعة/المرصودة

- المرصود حالياً: غير محدد (بانتظار وصف المستخدم/السجلات)
- المتوقع: التطبيق يعمل دون أعطال، بدون MissingPluginException، بدون أخطاء Rust FFI، وبدون فشل مزامنة Supabase أو Isar.

فرضيات قابلة للدحض (سيتم إثباتها/نفيها بالأدلة)

1. مشكلة تسجيل Plugins في وضع Release/Minify ما زالت تظهر في مسارات معينة → دليلها StackTrace يحتوي MissingPluginException أو ClassNotFound.
2. مشكلة صلاحيات/ملفات (Storage/Downloads/Photos) على Android 12 تمنع التصدير (PDF/Excel) → دليلها SecurityException أو EACCES.
3. مشكلة شبكة/SSL/DNS مع Supabase على الشبكة الحالية → دليلها SocketException/HandshakeException/Timeout.
4. مشكلة تهيئة Isar/مسار القاعدة أو Migration عند أول تشغيل على الجهاز → دليلها IsarError/Path/Schema mismatch.
5. مشكلة Rust FFI (panic/undefined behavior) في خدمات التقارير/التحليل → دليلها رسائل FFI أو crash native في logcat.

خطة جمع الأدلة

- تشغيل Debug Server وتوجيه نقاط القياس (Instrumentation) لإرسال أحداث NDJSON.
- تشغيل التطبيق على الجهاز وجمع: flutter run logs + adb logcat + NDJSON من Debug Server.
- تثبيت مسار إعادة إنتاج محدد لكل عطل ثم مقارنة pre-fix vs post-fix.

قرارات/ملاحظات

- ممنوع تعديل منطق الأعمال قبل جمع دليل تشغيل واضح.

سجل التنفيذ

- [ ] إعداد الاتصال بالجهاز (adb + flutter devices)
- [ ] تشغيل Debug Server وتأكيد /health
- [ ] جمع pre-fix logs وإعادة الإنتاج
- [ ] إضافة Instrumentation (فقط) لنقاط الاشتباه
- [ ] تحليل الأدلة وتحديد السبب الجذري
- [ ] تنفيذ إصلاح محدود
- [ ] تشغيل post-fix وتوثيق المقارنة
