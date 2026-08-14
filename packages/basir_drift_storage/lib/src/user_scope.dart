/// يحول userId الاختياري إلى مفتاح داخلي غير ملتبس للجداول ذات السجل الواحد
/// لكل مستخدم. لا يستخدم هذا المفتاح كهوية سحابية ولا يرسل إلى Supabase.
String userScopeKey(String? userId) =>
    userId == null ? 'anonymous' : 'user:$userId';
