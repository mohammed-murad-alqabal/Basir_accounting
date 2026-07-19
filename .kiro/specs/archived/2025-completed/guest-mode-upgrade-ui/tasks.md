# Tasks Document - Guest Mode Upgrade UI

**المشروع:** بصير MVP  
**التاريخ:** 29 ديسمبر 2025  
**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**الحالة:** 🔴 قيد التنفيذ (Pending Implementation)

---

## 📋 نظرة عامة

تم اكتشاف أن **واجهة ترقية الضيف (Guest Upgrade Screen)** غير موجودة في الكود الحالي رغم وجودها في التوثيق الرسمي (`FINAL_PROJECT_STATUS.md`).

### المشكلة المكتشفة

| العنصر                                                          | الحالة       | الموقع المتوقع                                                     |
| --------------------------------------------------------------- | ------------ | ------------------------------------------------------------------ |
| Backend Logic (`loginAsGuest`, `isGuest`, `convertGuestToUser`) | ✅ موجود     | `lib/features/auth/data/services/auth_service.dart`                |
| Guest Upgrade Screen UI                                         | ❌ **مفقود** | `lib/features/auth/presentation/screens/guest_upgrade_screen.dart` |
| Route `/guest-upgrade`                                          | ❌ **مفقود** | `lib/core/router.dart`                                             |

---

## 🎯 المهام المطلوبة

### Task 1: Create Guest Upgrade Screen

**الأولوية:** 🟠 متوسطة  
**الوقت المقدر:** 30 دقيقة  
**التبعيات:** لا يوجد

#### المهام الفرعية

- [ ] **Task 1.1:** إنشاء ملف `guest_upgrade_screen.dart`

  - إنشاء `StatelessWidget` أو `ConsumerWidget`
  - تضمين حقول `username` و `password`
  - استخدام `AppTextField` و `AppPrimaryButton` الموجودة
  - استدعاء `authService.convertGuestToUser()`

- [ ] **Task 1.2:** إضافة مسار `/guest-upgrade` في `AppRouter`

  - تحديث `lib/core/router.dart`
  - إضافة `case '/guest-upgrade':` في `switch`

- [ ] **Task 1.3:** إضافة زر "ترقية الحساب" في `DashboardScreen`
  - عرض الزر فقط للمستخدمين الضيوف (`isGuest == true`)
  - التنقل إلى `/guest-upgrade` عند الضغط

---

### Task 2: Testing & Validation

**الأولوية:** 🟢 منخفضة  
**الوقت المقدر:** 20 دقيقة  
**التبعيات:** Task 1

#### المهام الفرعية

- [ ] **Task 2.1:** إضافة اختبارات Widget للشاشة الجديدة
- [ ] **Task 2.2:** تشغيل `flutter analyze` والتأكد من عدم وجود أخطاء
- [ ] **Task 2.3:** تشغيل `flutter test` والتأكد من نجاح جميع الاختبارات

---

### Task 3: Documentation Sync

**الأولوية:** 🟢 منخفضة  
**الوقت المقدر:** 10 دقيقة  
**التبعيات:** Task 2

#### المهام الفرعية

- [ ] **Task 3.1:** تحديث `FINAL_PROJECT_STATUS.md` لتعكس الحالة الفعلية
- [ ] **Task 3.2:** إضافة الشاشة إلى قائمة المسارات في التوثيق
- [ ] **Task 3.3:** إغلاق هذه المواصفة بعد الإكمال

---

## ✅ معايير القبول

- [ ] الشاشة تعمل وتعرض النموذج بشكل صحيح
- [ ] يمكن للضيف ترقية حسابه بنجاح
- [ ] لا توجد أخطاء في `flutter analyze`
- [ ] جميع الاختبارات تنجح
- [ ] التوثيق محدث ومتسق

---

**تم إنشاؤه بواسطة:** Antigravity AI Agent  
**تاريخ الاكتشاف:** 29 ديسمبر 2025  
**المرجع:** Comprehensive Branch & Development Audit
