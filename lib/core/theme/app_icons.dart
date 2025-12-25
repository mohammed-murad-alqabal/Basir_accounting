/// نظام الأيقونات الموحد (Icon System)
///
/// هذا الملف يحتوي على جميع الأيقونات المستخدمة في التطبيق
/// جميع الأيقونات من Material Icons Outlined لضمان الاتساق
///
/// الهيكل:
/// - AppIcons: الفئة الرئيسية للأيقونات
/// - منظمة حسب الفئات (Navigation, Actions, Content, etc.)
/// - استخدام IconSizes من tokens للأحجام الموحدة
library;

import 'package:flutter/material.dart';

/// نظام الأيقونات الموحد
///
/// جميع الأيقونات من Material Icons Outlined
/// للحفاظ على اتساق بصري موحد
///
/// Example:
/// ```dart
/// Icon(AppIcons.home)
/// Icon(AppIcons.settings, size: IconSizes.lg)
/// ```
abstract final class AppIcons {
  // ═══════════════════════════════════════════════════════════════════════════
  // Navigation Icons - أيقونات التنقل
  // ═══════════════════════════════════════════════════════════════════════════

  /// الصفحة الرئيسية
  static const IconData home = Icons.home_outlined;

  /// الفواتير
  static const IconData invoices = Icons.receipt_long_outlined;

  /// العملاء
  static const IconData customers = Icons.people_outline;

  /// المنتجات
  static const IconData products = Icons.inventory_2_outlined;

  /// الإعدادات
  static const IconData settings = Icons.settings_outlined;

  /// القائمة
  static const IconData menu = Icons.menu_outlined;

  /// الرجوع
  static const IconData back = Icons.arrow_back_outlined;

  /// التالي
  static const IconData forward = Icons.arrow_forward_outlined;

  /// أكثر (قائمة إضافية)
  static const IconData more = Icons.more_vert_outlined;

  /// أكثر (أفقي)
  static const IconData moreHorizontal = Icons.more_horiz_outlined;

  // ═══════════════════════════════════════════════════════════════════════════
  // Action Icons - أيقونات الإجراءات
  // ═══════════════════════════════════════════════════════════════════════════

  /// إضافة
  static const IconData add = Icons.add_outlined;

  /// تعديل
  static const IconData edit = Icons.edit_outlined;

  /// حذف
  static const IconData delete = Icons.delete_outline;

  /// بحث
  static const IconData search = Icons.search_outlined;

  /// تصفية
  static const IconData filter = Icons.filter_list_outlined;

  /// ترتيب
  static const IconData sort = Icons.sort_outlined;

  /// حفظ
  static const IconData save = Icons.save_outlined;

  /// إلغاء
  static const IconData cancel = Icons.close_outlined;

  /// تأكيد / صح
  static const IconData check = Icons.check_outlined;

  /// مشاركة
  static const IconData share = Icons.share_outlined;

  /// طباعة
  static const IconData print = Icons.print_outlined;

  /// تنزيل
  static const IconData download = Icons.download_outlined;

  /// رفع
  static const IconData upload = Icons.upload_outlined;

  /// نسخ
  static const IconData copy = Icons.content_copy_outlined;

  /// قص
  static const IconData cut = Icons.content_cut_outlined;

  /// لصق
  static const IconData paste = Icons.content_paste_outlined;

  /// تحديث
  static const IconData refresh = Icons.refresh_outlined;

  /// تراجع
  static const IconData undo = Icons.undo_outlined;

  /// إعادة
  static const IconData redo = Icons.redo_outlined;

  // ═══════════════════════════════════════════════════════════════════════════
  // Status Icons - أيقونات الحالة
  // ═══════════════════════════════════════════════════════════════════════════

  /// معلومات
  static const IconData info = Icons.info_outline;

  /// تحذير
  static const IconData warning = Icons.warning_amber_outlined;

  /// خطأ
  static const IconData error = Icons.error_outline;

  /// نجاح
  static const IconData success = Icons.check_circle_outline;

  /// مساعدة
  static const IconData help = Icons.help_outline;

  /// إشعار
  static const IconData notification = Icons.notifications_outlined;

  /// جديد (شارة)
  static const IconData newBadge = Icons.new_releases_outlined;

  // ═══════════════════════════════════════════════════════════════════════════
  // Content Icons - أيقونات المحتوى
  // ═══════════════════════════════════════════════════════════════════════════

  /// ملف
  static const IconData file = Icons.insert_drive_file_outlined;

  /// مجلد
  static const IconData folder = Icons.folder_outlined;

  /// صورة
  static const IconData image = Icons.image_outlined;

  /// مستند
  static const IconData document = Icons.description_outlined;

  /// ملاحظة
  static const IconData note = Icons.note_outlined;

  /// قائمة
  static const IconData list = Icons.list_outlined;

  /// شبكة
  static const IconData grid = Icons.grid_view_outlined;

  /// تقويم
  static const IconData calendar = Icons.calendar_today_outlined;

  /// ساعة
  static const IconData clock = Icons.access_time_outlined;

  /// موقع
  static const IconData location = Icons.location_on_outlined;

  /// علامة
  static const IconData bookmark = Icons.bookmark_outline;

  /// نجمة
  static const IconData star = Icons.star_outline;

  /// قلب (مفضلة)
  static const IconData favorite = Icons.favorite_outline;

  // ═══════════════════════════════════════════════════════════════════════════
  // Business Icons - أيقونات الأعمال
  // ═══════════════════════════════════════════════════════════════════════════

  /// مال
  static const IconData money = Icons.attach_money_outlined;

  /// محفظة
  static const IconData wallet = Icons.account_balance_wallet_outlined;

  /// بطاقة ائتمان
  static const IconData creditCard = Icons.credit_card_outlined;

  /// دفع
  static const IconData payment = Icons.payment_outlined;

  /// فاتورة
  static const IconData invoice = Icons.receipt_outlined;

  /// تقرير
  static const IconData report = Icons.assessment_outlined;

  /// رسم بياني
  static const IconData chart = Icons.show_chart_outlined;

  /// إحصائيات
  static const IconData analytics = Icons.analytics_outlined;

  /// اتجاه صاعد
  static const IconData trendUp = Icons.trending_up_outlined;

  /// اتجاه هابط
  static const IconData trendDown = Icons.trending_down_outlined;

  // ═══════════════════════════════════════════════════════════════════════════
  // User Icons - أيقونات المستخدم
  // ═══════════════════════════════════════════════════════════════════════════

  /// مستخدم
  static const IconData user = Icons.person_outline;

  /// مجموعة مستخدمين
  static const IconData users = Icons.people_outline;

  /// إضافة مستخدم
  static const IconData userAdd = Icons.person_add_outlined;

  /// ملف شخصي
  static const IconData profile = Icons.account_circle_outlined;

  /// تسجيل دخول
  static const IconData login = Icons.login_outlined;

  /// تسجيل خروج
  static const IconData logout = Icons.logout_outlined;

  /// حساب
  static const IconData account = Icons.account_box_outlined;

  // ═══════════════════════════════════════════════════════════════════════════
  // Communication Icons - أيقونات الاتصال
  // ═══════════════════════════════════════════════════════════════════════════

  /// بريد إلكتروني
  static const IconData email = Icons.email_outlined;

  /// رسالة
  static const IconData message = Icons.message_outlined;

  /// محادثة
  static const IconData chat = Icons.chat_outlined;

  /// هاتف
  static const IconData phone = Icons.phone_outlined;

  /// اتصال
  static const IconData call = Icons.call_outlined;

  /// فيديو
  static const IconData video = Icons.videocam_outlined;

  // ═══════════════════════════════════════════════════════════════════════════
  // UI Control Icons - أيقونات التحكم
  // ═══════════════════════════════════════════════════════════════════════════

  /// عرض
  static const IconData visibility = Icons.visibility_outlined;

  /// إخفاء
  static const IconData visibilityOff = Icons.visibility_off_outlined;

  /// قفل
  static const IconData lock = Icons.lock_outlined;

  /// فتح القفل
  static const IconData unlock = Icons.lock_open_outlined;

  /// توسيع
  static const IconData expand = Icons.expand_more_outlined;

  /// طي
  static const IconData collapse = Icons.expand_less_outlined;

  /// ملء الشاشة
  static const IconData fullscreen = Icons.fullscreen_outlined;

  /// خروج من ملء الشاشة
  static const IconData fullscreenExit = Icons.fullscreen_exit_outlined;

  /// تشغيل
  static const IconData play = Icons.play_arrow_outlined;

  /// إيقاف مؤقت
  static const IconData pause = Icons.pause_outlined;

  /// إيقاف
  static const IconData stop = Icons.stop_outlined;

  // ═══════════════════════════════════════════════════════════════════════════
  // Theme Icons - أيقونات الثيم
  // ═══════════════════════════════════════════════════════════════════════════

  /// وضع فاتح
  static const IconData lightMode = Icons.light_mode_outlined;

  /// وضع داكن
  static const IconData darkMode = Icons.dark_mode_outlined;

  /// وضع تلقائي
  static const IconData autoMode = Icons.brightness_auto_outlined;

  /// سطوع
  static const IconData brightness = Icons.brightness_6_outlined;

  // ═══════════════════════════════════════════════════════════════════════════
  // Utility Icons - أيقونات الأدوات
  // ═══════════════════════════════════════════════════════════════════════════

  /// اللغة
  static const IconData language = Icons.language_outlined;

  /// ترجمة
  static const IconData translate = Icons.translate_outlined;

  /// إعدادات
  static const IconData tune = Icons.tune_outlined;

  /// أدوات
  static const IconData tools = Icons.build_outlined;

  /// روابط
  static const IconData link = Icons.link_outlined;

  /// فك الرابط
  static const IconData unlink = Icons.link_off_outlined;

  /// رمز QR
  static const IconData qrCode = Icons.qr_code_outlined;

  /// ماسح ضوئي
  static const IconData scanner = Icons.qr_code_scanner_outlined;

  /// كاميرا
  static const IconData camera = Icons.camera_alt_outlined;

  /// معرض الصور
  static const IconData gallery = Icons.photo_library_outlined;

  // ═══════════════════════════════════════════════════════════════════════════
  // Product Icons - أيقونات المنتجات
  // ═══════════════════════════════════════════════════════════════════════════

  /// منتج
  static const IconData product = Icons.shopping_bag_outlined;

  /// سلة
  static const IconData cart = Icons.shopping_cart_outlined;

  /// متجر
  static const IconData store = Icons.store_outlined;

  /// مخزون
  static const IconData inventory = Icons.inventory_outlined;

  /// علامة السعر
  static const IconData priceTag = Icons.sell_outlined;

  /// عرض
  static const IconData offer = Icons.local_offer_outlined;

  /// باركود
  static const IconData barcode = Icons.qr_code_2_outlined;

  // ═══════════════════════════════════════════════════════════════════════════
  // Direction Icons - أيقونات الاتجاهات
  // ═══════════════════════════════════════════════════════════════════════════

  /// أعلى
  static const IconData arrowUp = Icons.arrow_upward_outlined;

  /// أسفل
  static const IconData arrowDown = Icons.arrow_downward_outlined;

  /// يمين
  static const IconData arrowRight = Icons.arrow_forward_outlined;

  /// يسار
  static const IconData arrowLeft = Icons.arrow_back_outlined;

  /// سهم دائري (تحديث)
  static const IconData rotate = Icons.rotate_right_outlined;

  /// تبديل
  static const IconData swap = Icons.swap_horiz_outlined;

  // ═══════════════════════════════════════════════════════════════════════════
  // Helper Methods - دوال مساعدة
  // ═══════════════════════════════════════════════════════════════════════════

  /// الحصول على أيقونة حسب الحالة
  ///
  /// Example:
  /// ```dart
  /// Icon(AppIcons.getStatusIcon('success'))
  /// ```
  static IconData getStatusIcon(String status) =>
      switch (status.toLowerCase()) {
        'success' || 'completed' || 'paid' => success,
        'error' || 'failed' || 'cancelled' => error,
        'warning' || 'pending' => warning,
        'info' || 'draft' => info,
        _ => info,
      };

  /// الحصول على أيقونة حسب نوع الملف
  ///
  /// Example:
  /// ```dart
  /// Icon(AppIcons.getFileIcon('pdf'))
  /// ```
  static IconData getFileIcon(String fileType) =>
      switch (fileType.toLowerCase()) {
        'pdf' || 'doc' || 'docx' => document,
        'jpg' || 'jpeg' || 'png' || 'gif' => image,
        'zip' || 'rar' => folder,
        _ => file,
      };

  /// الحصول على أيقونة اتجاه الترتيب
  ///
  /// Example:
  /// ```dart
  /// Icon(AppIcons.getSortIcon(ascending: true))
  /// ```
  static IconData getSortIcon({required bool ascending}) =>
      ascending ? arrowUp : arrowDown;

  /// الحصول على أيقونة الرؤية
  ///
  /// Example:
  /// ```dart
  /// Icon(AppIcons.getVisibilityIcon(isVisible: showPassword))
  /// ```
  static IconData getVisibilityIcon({required bool isVisible}) =>
      isVisible ? visibility : visibilityOff;
}
