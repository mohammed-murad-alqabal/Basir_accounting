/// أدوار المستخدمين في النظام
enum UserRole {
  /// مسؤول النظام الكامل
  admin('مدير النظام'),

  /// مدير عمليات
  manager('مدير'),

  /// محاسب
  accountant('محاسب'),

  /// مدخل بيانات
  clerk('مدخل بيانات'),

  /// مدقق حسابات
  auditor('مدقق'),

  /// مشاهد فقط
  viewer('مشاهد');

  const UserRole(this.displayName);

  /// الاسم المعروض للدور
  final String displayName;
}
