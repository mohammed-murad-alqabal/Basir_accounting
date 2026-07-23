/// نظام الأيقونات الموحد (Icon System)
///
/// هذا الملف يحتوي على جميع الأيقونات المستخدمة في التطبيق
/// جميع الأيقونات من Material Icons Outlined لضمان الاتساق
///
/// الهيكل:
/// - AppIcons: الفئة الرئيسية للأيقونات (static access)
/// - AppIconsBase: الفئة المجردة للتخصيص
/// - منظمة حسب الفئات (Navigation, Actions, Content, etc.)
/// - استخدام IconSizes من tokens للأحجام الموحدة
library;

import 'package:flutter/material.dart';

/// حزم الأيقونات المتاحة
enum IconPack {
  /// حزمة Material Design
  material,

  /// حزمة Cupertino (iOS)
  cupertino,
}

/// الفئة المجردة لنظام الأيقونات
///
/// تستخدم لإنشاء حزم أيقونات مخصصة
abstract class AppIconsBase {
  const AppIconsBase();

  // ═══════════════════════════════════════════════════════════════════════════
  // Navigation Icons - أيقونات التنقل
  // ═══════════════════════════════════════════════════════════════════════════

  /// الصفحة الرئيسية
  IconData get home;

  /// الفواتير
  IconData get invoices;

  /// العملاء
  IconData get customers;

  /// المنتجات
  IconData get products;

  /// الإعدادات
  IconData get settings;

  /// القائمة
  IconData get menu;

  /// الرجوع
  IconData get back;

  /// التالي
  IconData get forward;

  /// أكثر (قائمة إضافية)
  IconData get more;

  /// أكثر (أفقي)
  IconData get moreHorizontal;

  /// سهم لليمين (للقوائم)
  IconData get chevronRight;

  /// لوحة التحكم
  IconData get dashboard;

  // ═══════════════════════════════════════════════════════════════════════════
  // Action Icons - أيقونات الإجراءات
  // ═══════════════════════════════════════════════════════════════════════════

  /// إضافة
  IconData get add;

  /// تعديل
  IconData get edit;

  /// حذف
  IconData get delete;

  /// بحث
  IconData get search;

  /// تصفية
  IconData get filter;

  /// ترتيب
  IconData get sort;

  /// حفظ
  IconData get save;

  /// إلغاء
  IconData get cancel;

  /// تأكيد / صح
  IconData get check;

  /// إغلاق
  IconData get close;

  /// إرسال
  IconData get send;

  /// مشاركة
  IconData get share;

  /// طباعة
  IconData get print;

  /// تنزيل
  IconData get download;

  /// رفع
  IconData get upload;

  /// نسخ
  IconData get copy;

  /// قص
  IconData get cut;

  /// لصق
  IconData get paste;

  /// تحديث
  IconData get refresh;

  /// تراجع
  IconData get undo;

  /// إعادة
  IconData get redo;

  /// قائمة
  IconData get list;

  // ═══════════════════════════════════════════════════════════════════════════
  // Status Icons - أيقونات الحالة
  // ═══════════════════════════════════════════════════════════════════════════

  /// معلومات
  IconData get info;

  /// تحذير
  IconData get warning;

  /// خطأ
  IconData get error;

  /// نجاح
  IconData get success;

  /// مساعدة
  IconData get help;

  /// إشعار
  IconData get notification;

  /// جديد (شارة)
  IconData get newBadge;

  // ═══════════════════════════════════════════════════════════════════════════
  // Content Icons - أيقونات المحتوى
  // ═══════════════════════════════════════════════════════════════════════════

  /// ملف
  IconData get file;

  /// مجلد
  IconData get folder;

  /// صورة
  IconData get image;

  /// مستند
  IconData get document;

  /// ملاحظة
  IconData get note;

  /// شبكة
  IconData get grid;

  /// تقويم
  IconData get calendar;

  /// ساعة
  IconData get clock;

  /// موقع
  IconData get location;

  /// علامة
  IconData get bookmark;

  /// نجمة
  IconData get star;

  /// قلب (مفضلة)
  IconData get favorite;

  // ═══════════════════════════════════════════════════════════════════════════
  // Business Icons - أيقونات الأعمال
  // ═══════════════════════════════════════════════════════════════════════════

  /// مال
  IconData get money;

  /// محفظة
  IconData get wallet;

  /// بطاقة ائتمان
  IconData get creditCard;

  /// دفع
  IconData get payment;

  /// فاتورة
  IconData get invoice;

  /// تقرير
  IconData get report;

  /// رسم بياني
  IconData get chart;

  /// إحصائيات
  IconData get analytics;

  /// اتجاه صاعد
  IconData get trendUp;

  /// اتجاه هابط
  IconData get trendDown;

  /// محاسبة
  IconData get accounting;

  // ═══════════════════════════════════════════════════════════════════════════
  // User Icons - أيقونات المستخدم
  // ═══════════════════════════════════════════════════════════════════════════

  /// مستخدم
  IconData get user;

  /// مجموعة مستخدمين
  IconData get users;

  /// إضافة مستخدم
  IconData get userAdd;

  /// ملف شخصي
  IconData get profile;

  /// تسجيل دخول
  IconData get login;

  /// تسجيل خروج
  IconData get logout;

  /// حساب
  IconData get account;

  /// ترقية
  IconData get upgrade;

  /// برق
  IconData get bolt;

  // ═══════════════════════════════════════════════════════════════════════════
  // Communication Icons - أيقونات الاتصال
  // ═══════════════════════════════════════════════════════════════════════════

  /// بريد إلكتروني
  IconData get email;

  /// رسالة
  IconData get message;

  /// محادثة
  IconData get chat;

  /// هاتف
  IconData get phone;

  /// اتصال
  IconData get call;

  /// فيديو
  IconData get video;

  // ═══════════════════════════════════════════════════════════════════════════
  // UI Control Icons - أيقونات التحكم
  // ═══════════════════════════════════════════════════════════════════════════

  /// عرض
  IconData get visibility;

  /// إخفاء
  IconData get visibilityOff;

  /// قفل
  IconData get lock;

  /// فتح القفل
  IconData get unlock;

  /// توسيع
  IconData get expand;

  /// طي
  IconData get collapse;

  /// ملء الشاشة
  IconData get fullscreen;

  /// خروج من ملء الشاشة
  IconData get fullscreenExit;

  /// تشغيل
  IconData get play;

  /// إيقاف مؤقت
  IconData get pause;

  /// إيقاف
  IconData get stop;

  // ═══════════════════════════════════════════════════════════════════════════
  // Theme Icons - أيقونات الثيم
  // ═══════════════════════════════════════════════════════════════════════════

  /// وضع فاتح
  IconData get lightMode;

  /// وضع داكن
  IconData get darkMode;

  /// وضع تلقائي
  IconData get autoMode;

  /// سطوع
  IconData get brightness;

  // ═══════════════════════════════════════════════════════════════════════════
  // Utility Icons - أيقونات الأدوات
  // ═══════════════════════════════════════════════════════════════════════════

  /// اللغة
  IconData get language;

  /// ترجمة
  IconData get translate;

  /// إعدادات
  IconData get tune;

  /// أدوات
  IconData get tools;

  /// روابط
  IconData get link;

  /// فك الرابط
  IconData get unlink;

  /// رمز QR
  IconData get qrCode;

  /// ماسح ضوئي
  IconData get scanner;

  /// كاميرا
  IconData get camera;

  /// معرض الصور
  IconData get gallery;

  // ═══════════════════════════════════════════════════════════════════════════
  // Product Icons - أيقونات المنتجات
  // ═══════════════════════════════════════════════════════════════════════════

  /// منتج
  IconData get product;

  /// سلة
  IconData get cart;

  /// متجر
  IconData get store;

  /// مخزون
  IconData get inventory;

  /// علامة السعر
  IconData get priceTag;

  /// عرض
  IconData get offer;

  /// باركود
  IconData get barcode;

  /// قارئ باركود
  IconData get barcodeReader;

  // ═══════════════════════════════════════════════════════════════════════════
  // Direction Icons - أيقونات الاتجاهات
  // ═══════════════════════════════════════════════════════════════════════════

  /// أعلى
  IconData get arrowUp;

  /// أسفل
  IconData get arrowDown;

  /// يمين
  IconData get arrowRight;

  /// يسار
  IconData get arrowLeft;

  /// سهم دائري (تحديث)
  IconData get rotate;

  /// تبديل
  IconData get swap;

  // ═══════════════════════════════════════════════════════════════════════════
  // Additional Icons
  // ═══════════════════════════════════════════════════════════════════════════

  /// تحديث
  IconData get update;

  /// إستعادة
  IconData get restore;

  /// شخص
  IconData get person;

  /// دائرة
  IconData get circle;

  /// نص
  IconData get text;

  /// لمس
  IconData get touch;

  /// أعمال
  IconData get business;

  /// أمان
  IconData get security;

  /// إشعارات
  IconData get notifications;

  /// إشعارات مطفئة
  IconData get notificationsOff;

  /// نمط
  IconData get style;

  /// موضوع
  IconData get theme;

  /// أرقام
  IconData get numbers;

  /// لوحة ألوان
  IconData get palette;

  /// PDF
  IconData get pdf;

  /// تقليل الحركة
  IconData get reduceMotion;

  /// تباين
  IconData get contrast;

  /// إمكانية الوصول
  IconData get accessibility;

  /// إضافة دائرة
  IconData get addCircle;

  /// تبادل العملات
  IconData get currencyExchange;

  /// نسبة مئوية
  IconData get percent;
}

/// نظام الأيقونات الموحد (Static Access)
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
  // Helper Methods - دوال مساعدة
  // ═══════════════════════════════════════════════════════════════════════════

  /// الحصول على أيقونة حسب الحالة
  ///
  /// Example:
  /// ```dart
  /// Icon(AppIcons.getStatusIcon('success'))
  /// ```
  static IconData getStatusIcon(String status) {
    final lower = status.toLowerCase();
    return switch (lower) {
      'success' || 'completed' || 'paid' => const MaterialAppIcons().success,
      'error' || 'failed' || 'cancelled' => const MaterialAppIcons().error,
      'warning' || 'pending' => const MaterialAppIcons().warning,
      'info' || 'draft' => const MaterialAppIcons().info,
      _ => const MaterialAppIcons().info,
    };
  }

  /// الحصول على أيقونة حسب نوع الملف
  static IconData getFileIcon(String fileType) {
    final lower = fileType.toLowerCase();
    return switch (lower) {
      'pdf' || 'doc' || 'docx' => const MaterialAppIcons().document,
      'jpg' || 'jpeg' || 'png' || 'gif' => const MaterialAppIcons().image,
      'zip' || 'rar' => const MaterialAppIcons().folder,
      _ => const MaterialAppIcons().file,
    };
  }

  /// الحصول على أيقونة اتجاه الترتيب
  ///
  /// Example:
  /// ```dart
  /// Icon(AppIcons.getSortIcon(ascending: true))
  /// ```
  static IconData getSortIcon({
    required bool ascending,
  }) =>
      ascending
          ? const MaterialAppIcons().arrowUp
          : const MaterialAppIcons().arrowDown;

  /// الحصول على أيقونة الرؤية
  ///
  /// Example:
  /// ```dart
  /// Icon(AppIcons.getVisibilityIcon(isVisible: showPassword))
  /// ```
  static IconData getVisibilityIcon({required bool isVisible}) => isVisible
      ? const MaterialAppIcons().visibility
      : const MaterialAppIcons().visibilityOff;

  // Backward compatibility static getters
  static IconData get home => const MaterialAppIcons().home;
  static IconData get invoices => const MaterialAppIcons().invoices;
  static IconData get customers => const MaterialAppIcons().customers;
  static IconData get products => const MaterialAppIcons().products;
  static IconData get settings => const MaterialAppIcons().settings;
  static IconData get menu => const MaterialAppIcons().menu;
  static IconData get back => const MaterialAppIcons().back;
  static IconData get forward => const MaterialAppIcons().forward;
  static IconData get more => const MaterialAppIcons().more;
  static IconData get moreHorizontal => const MaterialAppIcons().moreHorizontal;
  static IconData get chevronRight => const MaterialAppIcons().chevronRight;
  static IconData get add => const MaterialAppIcons().add;
  static IconData get edit => const MaterialAppIcons().edit;
  static IconData get delete => const MaterialAppIcons().delete;
  static IconData get search => const MaterialAppIcons().search;
  static IconData get filter => const MaterialAppIcons().filter;
  static IconData get sort => const MaterialAppIcons().sort;
  static IconData get save => const MaterialAppIcons().save;
  static IconData get cancel => const MaterialAppIcons().cancel;
  static IconData get check => const MaterialAppIcons().check;
  static IconData get close => const MaterialAppIcons().close;
  static IconData get send => const MaterialAppIcons().send;
  static IconData get share => const MaterialAppIcons().share;
  static IconData get print => const MaterialAppIcons().print;
  static IconData get download => const MaterialAppIcons().download;
  static IconData get upload => const MaterialAppIcons().upload;
  static IconData get copy => const MaterialAppIcons().copy;
  static IconData get cut => const MaterialAppIcons().cut;
  static IconData get paste => const MaterialAppIcons().paste;
  static IconData get refresh => const MaterialAppIcons().refresh;
  static IconData get undo => const MaterialAppIcons().undo;
  static IconData get redo => const MaterialAppIcons().redo;
  static IconData get info => const MaterialAppIcons().info;
  static IconData get warning => const MaterialAppIcons().warning;
  static IconData get error => const MaterialAppIcons().error;
  static IconData get success => const MaterialAppIcons().success;
  static IconData get help => const MaterialAppIcons().help;
  static IconData get notification => const MaterialAppIcons().notification;
  static IconData get newBadge => const MaterialAppIcons().newBadge;
  static IconData get file => const MaterialAppIcons().file;
  static IconData get folder => const MaterialAppIcons().folder;
  static IconData get image => const MaterialAppIcons().image;
  static IconData get document => const MaterialAppIcons().document;
  static IconData get note => const MaterialAppIcons().note;
  static IconData get list => const MaterialAppIcons().list;
  static IconData get grid => const MaterialAppIcons().grid;
  static IconData get calendar => const MaterialAppIcons().calendar;
  static IconData get clock => const MaterialAppIcons().clock;
  static IconData get location => const MaterialAppIcons().location;
  static IconData get bookmark => const MaterialAppIcons().bookmark;
  static IconData get star => const MaterialAppIcons().star;
  static IconData get favorite => const MaterialAppIcons().favorite;
  static IconData get money => const MaterialAppIcons().money;
  static IconData get wallet => const MaterialAppIcons().wallet;
  static IconData get creditCard => const MaterialAppIcons().creditCard;
  static IconData get payment => const MaterialAppIcons().payment;
  static IconData get invoice => const MaterialAppIcons().invoice;
  static IconData get report => const MaterialAppIcons().report;
  static IconData get chart => const MaterialAppIcons().chart;
  static IconData get analytics => const MaterialAppIcons().analytics;
  static IconData get trendUp => const MaterialAppIcons().trendUp;
  static IconData get trendDown => const MaterialAppIcons().trendDown;
  static IconData get user => const MaterialAppIcons().user;
  static IconData get users => const MaterialAppIcons().users;
  static IconData get userAdd => const MaterialAppIcons().userAdd;
  static IconData get profile => const MaterialAppIcons().profile;
  static IconData get login => const MaterialAppIcons().login;
  static IconData get logout => const MaterialAppIcons().logout;
  static IconData get account => const MaterialAppIcons().account;
  static IconData get email => const MaterialAppIcons().email;
  static IconData get message => const MaterialAppIcons().message;
  static IconData get chat => const MaterialAppIcons().chat;
  static IconData get phone => const MaterialAppIcons().phone;
  static IconData get call => const MaterialAppIcons().call;
  static IconData get video => const MaterialAppIcons().video;
  static IconData get visibility => const MaterialAppIcons().visibility;
  static IconData get visibilityOff => const MaterialAppIcons().visibilityOff;
  static IconData get lock => const MaterialAppIcons().lock;
  static IconData get unlock => const MaterialAppIcons().unlock;
  static IconData get expand => const MaterialAppIcons().expand;
  static IconData get collapse => const MaterialAppIcons().collapse;
  static IconData get fullscreen => const MaterialAppIcons().fullscreen;
  static IconData get fullscreenExit => const MaterialAppIcons().fullscreenExit;
  static IconData get play => const MaterialAppIcons().play;
  static IconData get pause => const MaterialAppIcons().pause;
  static IconData get stop => const MaterialAppIcons().stop;
  static IconData get lightMode => const MaterialAppIcons().lightMode;
  static IconData get darkMode => const MaterialAppIcons().darkMode;
  static IconData get autoMode => const MaterialAppIcons().autoMode;
  static IconData get brightness => const MaterialAppIcons().brightness;
  static IconData get language => const MaterialAppIcons().language;
  static IconData get translate => const MaterialAppIcons().translate;
  static IconData get tune => const MaterialAppIcons().tune;
  static IconData get tools => const MaterialAppIcons().tools;
  static IconData get link => const MaterialAppIcons().link;
  static IconData get unlink => const MaterialAppIcons().unlink;
  static IconData get qrCode => const MaterialAppIcons().qrCode;
  static IconData get scanner => const MaterialAppIcons().scanner;
  static IconData get camera => const MaterialAppIcons().camera;
  static IconData get gallery => const MaterialAppIcons().gallery;
  static IconData get product => const MaterialAppIcons().product;
  static IconData get cart => const MaterialAppIcons().cart;
  static IconData get store => const MaterialAppIcons().store;
  static IconData get inventory => const MaterialAppIcons().inventory;
  static IconData get priceTag => const MaterialAppIcons().priceTag;
  static IconData get offer => const MaterialAppIcons().offer;
  static IconData get barcode => const MaterialAppIcons().barcode;
  static IconData get barcodeReader => const MaterialAppIcons().barcodeReader;
  static IconData get arrowUp => const MaterialAppIcons().arrowUp;
  static IconData get arrowDown => const MaterialAppIcons().arrowDown;
  static IconData get arrowRight => const MaterialAppIcons().arrowRight;
  static IconData get arrowLeft => const MaterialAppIcons().arrowLeft;
  static IconData get rotate => const MaterialAppIcons().rotate;
  static IconData get swap => const MaterialAppIcons().swap;
  static IconData get dashboard => const MaterialAppIcons().dashboard;
  static IconData get accounting => const MaterialAppIcons().accounting;
  static IconData get upgrade => const MaterialAppIcons().upgrade;
  static IconData get bolt => const MaterialAppIcons().bolt;
  static IconData get update => const MaterialAppIcons().update;
  static IconData get restore => const MaterialAppIcons().restore;
  static IconData get person => const MaterialAppIcons().person;
  static IconData get circle => const MaterialAppIcons().circle;
  static IconData get text => const MaterialAppIcons().text;
  static IconData get touch => const MaterialAppIcons().touch;
  static IconData get business => const MaterialAppIcons().business;
  static IconData get security => const MaterialAppIcons().security;
  static IconData get notifications => const MaterialAppIcons().notifications;
  static IconData get notificationsOff =>
      const MaterialAppIcons().notificationsOff;
  static IconData get style => const MaterialAppIcons().style;
  static IconData get theme => const MaterialAppIcons().theme;
  static IconData get numbers => const MaterialAppIcons().numbers;
  static IconData get palette => const MaterialAppIcons().palette;
  static IconData get pdf => const MaterialAppIcons().pdf;
  static IconData get reduceMotion => const MaterialAppIcons().reduceMotion;
  static IconData get contrast => const MaterialAppIcons().contrast;
  static IconData get accessibility => const MaterialAppIcons().accessibility;
  static IconData get addCircle => const MaterialAppIcons().addCircle;
  static IconData get currencyExchange =>
      const MaterialAppIcons().currencyExchange;
  static IconData get percent => const MaterialAppIcons().percent;
}

/// حزمة أيقونات Material Design
class MaterialAppIcons extends AppIconsBase {
  const MaterialAppIcons();

  @override
  IconData get home => Icons.home_outlined;

  @override
  IconData get invoices => Icons.receipt_long_outlined;

  @override
  IconData get customers => Icons.people_outline;

  @override
  IconData get products => Icons.inventory_2_outlined;

  @override
  IconData get settings => Icons.settings_outlined;

  @override
  IconData get menu => Icons.menu_outlined;

  @override
  IconData get back => Icons.arrow_back_outlined;

  @override
  IconData get forward => Icons.arrow_forward_outlined;

  @override
  IconData get more => Icons.more_vert_outlined;

  @override
  IconData get moreHorizontal => Icons.more_horiz_outlined;

  @override
  IconData get chevronRight => Icons.chevron_right_outlined;

  @override
  IconData get add => Icons.add_outlined;

  @override
  IconData get edit => Icons.edit_outlined;

  @override
  IconData get delete => Icons.delete_outline;

  @override
  IconData get search => Icons.search_outlined;

  @override
  IconData get filter => Icons.filter_list_outlined;

  @override
  IconData get sort => Icons.sort_outlined;

  @override
  IconData get save => Icons.save_outlined;

  @override
  IconData get cancel => Icons.close_outlined;

  @override
  IconData get check => Icons.check_outlined;

  @override
  IconData get close => Icons.close_outlined;

  @override
  IconData get send => Icons.send_outlined;

  @override
  IconData get share => Icons.share_outlined;

  @override
  IconData get print => Icons.print_outlined;

  @override
  IconData get download => Icons.download_outlined;

  @override
  IconData get upload => Icons.upload_outlined;

  @override
  IconData get copy => Icons.content_copy_outlined;

  @override
  IconData get cut => Icons.content_cut_outlined;

  @override
  IconData get paste => Icons.content_paste_outlined;

  @override
  IconData get refresh => Icons.refresh_outlined;

  @override
  IconData get undo => Icons.undo_outlined;

  @override
  IconData get redo => Icons.redo_outlined;

  @override
  IconData get info => Icons.info_outline;

  @override
  IconData get warning => Icons.warning_amber_outlined;

  @override
  IconData get error => Icons.error_outline;

  @override
  IconData get success => Icons.check_circle_outline;

  @override
  IconData get help => Icons.help_outline;

  @override
  IconData get notification => Icons.notifications_outlined;

  @override
  IconData get newBadge => Icons.new_releases_outlined;

  @override
  IconData get file => Icons.insert_drive_file_outlined;

  @override
  IconData get folder => Icons.folder_outlined;

  @override
  IconData get image => Icons.image_outlined;

  @override
  IconData get document => Icons.description_outlined;

  @override
  IconData get note => Icons.note_outlined;

  @override
  IconData get list => Icons.list_outlined;

  @override
  IconData get grid => Icons.grid_view_outlined;

  @override
  IconData get calendar => Icons.calendar_today_outlined;

  @override
  IconData get clock => Icons.access_time_outlined;

  @override
  IconData get location => Icons.location_on_outlined;

  @override
  IconData get bookmark => Icons.bookmark_outline;

  @override
  IconData get star => Icons.star_outline;

  @override
  IconData get favorite => Icons.favorite_outline;

  @override
  IconData get money => Icons.attach_money_outlined;

  @override
  IconData get wallet => Icons.account_balance_wallet_outlined;

  @override
  IconData get creditCard => Icons.credit_card_outlined;

  @override
  IconData get payment => Icons.payment_outlined;

  @override
  IconData get invoice => Icons.receipt_outlined;

  @override
  IconData get report => Icons.assessment_outlined;

  @override
  IconData get chart => Icons.show_chart_outlined;

  @override
  IconData get analytics => Icons.analytics_outlined;

  @override
  IconData get trendUp => Icons.trending_up_outlined;

  @override
  IconData get trendDown => Icons.trending_down_outlined;

  @override
  IconData get user => Icons.person_outline;

  @override
  IconData get users => Icons.people_outline;

  @override
  IconData get userAdd => Icons.person_add_outlined;

  @override
  IconData get profile => Icons.account_circle_outlined;

  @override
  IconData get login => Icons.login_outlined;

  @override
  IconData get logout => Icons.logout_outlined;

  @override
  IconData get account => Icons.account_box_outlined;

  @override
  IconData get email => Icons.email_outlined;

  @override
  IconData get message => Icons.message_outlined;

  @override
  IconData get chat => Icons.chat_outlined;

  @override
  IconData get phone => Icons.phone_outlined;

  @override
  IconData get call => Icons.call_outlined;

  @override
  IconData get video => Icons.videocam_outlined;

  @override
  IconData get visibility => Icons.visibility_outlined;

  @override
  IconData get visibilityOff => Icons.visibility_off_outlined;

  @override
  IconData get lock => Icons.lock_outlined;

  @override
  IconData get unlock => Icons.lock_open_outlined;

  @override
  IconData get expand => Icons.expand_more_outlined;

  @override
  IconData get collapse => Icons.expand_less_outlined;

  @override
  IconData get fullscreen => Icons.fullscreen_outlined;

  @override
  IconData get fullscreenExit => Icons.fullscreen_exit_outlined;

  @override
  IconData get play => Icons.play_arrow_outlined;

  @override
  IconData get pause => Icons.pause_outlined;

  @override
  IconData get stop => Icons.stop_outlined;

  @override
  IconData get lightMode => Icons.light_mode_outlined;

  @override
  IconData get darkMode => Icons.dark_mode_outlined;

  @override
  IconData get autoMode => Icons.brightness_auto_outlined;

  @override
  IconData get brightness => Icons.brightness_6_outlined;

  @override
  IconData get language => Icons.language_outlined;

  @override
  IconData get translate => Icons.translate_outlined;

  @override
  IconData get tune => Icons.tune_outlined;

  @override
  IconData get tools => Icons.build_outlined;

  @override
  IconData get link => Icons.link_outlined;

  @override
  IconData get unlink => Icons.link_off_outlined;

  @override
  IconData get qrCode => Icons.qr_code_outlined;

  @override
  IconData get scanner => Icons.qr_code_scanner_outlined;

  @override
  IconData get camera => Icons.camera_alt_outlined;

  @override
  IconData get gallery => Icons.photo_library_outlined;

  @override
  IconData get product => Icons.shopping_bag_outlined;

  @override
  IconData get cart => Icons.shopping_cart_outlined;

  @override
  IconData get store => Icons.store_outlined;

  @override
  IconData get inventory => Icons.inventory_outlined;

  @override
  IconData get priceTag => Icons.sell_outlined;

  @override
  IconData get offer => Icons.local_offer_outlined;

  @override
  IconData get barcode => Icons.qr_code_2_outlined;

  @override
  IconData get barcodeReader => Icons.qr_code_scanner;

  @override
  IconData get arrowUp => Icons.arrow_upward_outlined;

  @override
  IconData get arrowDown => Icons.arrow_downward_outlined;

  @override
  IconData get arrowRight => Icons.arrow_forward_outlined;

  @override
  IconData get arrowLeft => Icons.arrow_back_outlined;

  @override
  IconData get rotate => Icons.rotate_right_outlined;

  @override
  IconData get swap => Icons.swap_horiz_outlined;

  @override
  IconData get dashboard => Icons.dashboard_outlined;

  @override
  IconData get accounting => Icons.account_balance_outlined;

  @override
  IconData get upgrade => Icons.upgrade_outlined;

  @override
  IconData get bolt => Icons.bolt_outlined;

  @override
  IconData get update => Icons.update_outlined;

  @override
  IconData get restore => Icons.restore_outlined;

  @override
  IconData get person => Icons.person_outline;

  @override
  IconData get circle => Icons.circle_outlined;

  @override
  IconData get text => Icons.text_fields_outlined;

  @override
  IconData get touch => Icons.touch_app_outlined;

  @override
  IconData get business => Icons.business_outlined;

  @override
  IconData get security => Icons.security_outlined;

  @override
  IconData get notifications => Icons.notifications_outlined;

  @override
  IconData get notificationsOff => Icons.notifications_off_outlined;

  @override
  IconData get style => Icons.style_outlined;

  @override
  IconData get theme => Icons.dark_mode_outlined;

  @override
  IconData get numbers => Icons.numbers_outlined;

  @override
  IconData get palette => Icons.palette_outlined;

  @override
  IconData get pdf => Icons.picture_as_pdf_outlined;

  @override
  IconData get reduceMotion => Icons.motion_photos_off_outlined;

  @override
  IconData get contrast => Icons.contrast_outlined;

  @override
  IconData get accessibility => Icons.accessibility_outlined;

  @override
  IconData get addCircle => Icons.add_circle_outline_outlined;

  @override
  IconData get currencyExchange => Icons.currency_exchange_outlined;

  @override
  IconData get percent => Icons.percent_outlined;
}

/// حزمة أيقونات Cupertino (iOS)
class CupertinoAppIcons extends AppIconsBase {
  const CupertinoAppIcons();

  @override
  IconData get home => Icons.home;

  @override
  IconData get invoices => Icons.receipt_long;

  @override
  IconData get customers => Icons.people;

  @override
  IconData get products => Icons.inventory_2;

  @override
  IconData get settings => Icons.settings;

  @override
  IconData get menu => Icons.menu;

  @override
  IconData get back => Icons.arrow_back;

  @override
  IconData get forward => Icons.arrow_forward;

  @override
  IconData get more => Icons.more_vert;

  @override
  IconData get moreHorizontal => Icons.more_horiz;

  @override
  IconData get chevronRight => Icons.chevron_right;

  @override
  IconData get add => Icons.add;

  @override
  IconData get edit => Icons.edit;

  @override
  IconData get delete => Icons.delete;

  @override
  IconData get search => Icons.search;

  @override
  IconData get filter => Icons.filter_list;

  @override
  IconData get sort => Icons.sort;

  @override
  IconData get save => Icons.save;

  @override
  IconData get cancel => Icons.close;

  @override
  IconData get check => Icons.check;

  @override
  IconData get close => Icons.close;

  @override
  IconData get send => Icons.send;

  @override
  IconData get share => Icons.share;

  @override
  IconData get print => Icons.print;

  @override
  IconData get download => Icons.download;

  @override
  IconData get upload => Icons.upload;

  @override
  IconData get copy => Icons.content_copy;

  @override
  IconData get cut => Icons.content_cut;

  @override
  IconData get paste => Icons.content_paste;

  @override
  IconData get refresh => Icons.refresh;

  @override
  IconData get undo => Icons.undo;

  @override
  IconData get redo => Icons.redo;

  @override
  IconData get info => Icons.info;

  @override
  IconData get warning => Icons.warning_amber;

  @override
  IconData get error => Icons.error;

  @override
  IconData get success => Icons.check_circle;

  @override
  IconData get help => Icons.help;

  @override
  IconData get notification => Icons.notifications;

  @override
  IconData get newBadge => Icons.new_releases;

  @override
  IconData get file => Icons.insert_drive_file;

  @override
  IconData get folder => Icons.folder;

  @override
  IconData get image => Icons.image;

  @override
  IconData get document => Icons.description;

  @override
  IconData get note => Icons.note;

  @override
  IconData get list => Icons.list;

  @override
  IconData get grid => Icons.grid_view;

  @override
  IconData get calendar => Icons.calendar_today;

  @override
  IconData get clock => Icons.access_time;

  @override
  IconData get location => Icons.location_on;

  @override
  IconData get bookmark => Icons.bookmark;

  @override
  IconData get star => Icons.star;

  @override
  IconData get favorite => Icons.favorite;

  @override
  IconData get money => Icons.attach_money;

  @override
  IconData get wallet => Icons.account_balance_wallet;

  @override
  IconData get creditCard => Icons.credit_card;

  @override
  IconData get payment => Icons.payment;

  @override
  IconData get invoice => Icons.receipt;

  @override
  IconData get report => Icons.assessment;

  @override
  IconData get chart => Icons.show_chart;

  @override
  IconData get analytics => Icons.analytics;

  @override
  IconData get trendUp => Icons.trending_up;

  @override
  IconData get trendDown => Icons.trending_down;

  @override
  IconData get user => Icons.person;

  @override
  IconData get users => Icons.people;

  @override
  IconData get userAdd => Icons.person_add;

  @override
  IconData get profile => Icons.account_circle;

  @override
  IconData get login => Icons.login;

  @override
  IconData get logout => Icons.logout;

  @override
  IconData get account => Icons.account_box;

  @override
  IconData get email => Icons.email;

  @override
  IconData get message => Icons.message;

  @override
  IconData get chat => Icons.chat;

  @override
  IconData get phone => Icons.phone;

  @override
  IconData get call => Icons.call;

  @override
  IconData get video => Icons.videocam;

  @override
  IconData get visibility => Icons.visibility;

  @override
  IconData get visibilityOff => Icons.visibility_off;

  @override
  IconData get lock => Icons.lock;

  @override
  IconData get unlock => Icons.lock_open;

  @override
  IconData get expand => Icons.expand_more;

  @override
  IconData get collapse => Icons.expand_less;

  @override
  IconData get fullscreen => Icons.fullscreen;

  @override
  IconData get fullscreenExit => Icons.fullscreen_exit;

  @override
  IconData get play => Icons.play_arrow;

  @override
  IconData get pause => Icons.pause;

  @override
  IconData get stop => Icons.stop;

  @override
  IconData get lightMode => Icons.light_mode;

  @override
  IconData get darkMode => Icons.dark_mode;

  @override
  IconData get autoMode => Icons.brightness_auto;

  @override
  IconData get brightness => Icons.brightness_6;

  @override
  IconData get language => Icons.language;

  @override
  IconData get translate => Icons.translate;

  @override
  IconData get tune => Icons.tune;

  @override
  IconData get tools => Icons.build;

  @override
  IconData get link => Icons.link;

  @override
  IconData get unlink => Icons.link_off;

  @override
  IconData get qrCode => Icons.qr_code;

  @override
  IconData get scanner => Icons.qr_code_scanner;

  @override
  IconData get camera => Icons.camera_alt;

  @override
  IconData get gallery => Icons.photo_library;

  @override
  IconData get product => Icons.shopping_bag;

  @override
  IconData get cart => Icons.shopping_cart;

  @override
  IconData get store => Icons.store;

  @override
  IconData get inventory => Icons.inventory;

  @override
  IconData get priceTag => Icons.sell;

  @override
  IconData get offer => Icons.local_offer;

  @override
  IconData get barcode => Icons.qr_code_2;

  @override
  IconData get barcodeReader => Icons.qr_code_scanner;

  @override
  IconData get arrowUp => Icons.arrow_upward;

  @override
  IconData get arrowDown => Icons.arrow_downward;

  @override
  IconData get arrowRight => Icons.arrow_forward;

  @override
  IconData get arrowLeft => Icons.arrow_back;

  @override
  IconData get rotate => Icons.rotate_right;

  @override
  IconData get swap => Icons.swap_horiz;

  @override
  IconData get dashboard => Icons.dashboard;

  @override
  IconData get accounting => Icons.account_balance;

  @override
  IconData get upgrade => Icons.upgrade;

  @override
  IconData get bolt => Icons.bolt;

  @override
  IconData get update => Icons.update;

  @override
  IconData get restore => Icons.restore;

  @override
  IconData get person => Icons.person;

  @override
  IconData get circle => Icons.circle;

  @override
  IconData get text => Icons.text_fields;

  @override
  IconData get touch => Icons.touch_app;

  @override
  IconData get business => Icons.business;

  @override
  IconData get security => Icons.security;

  @override
  IconData get notifications => Icons.notifications;

  @override
  IconData get notificationsOff => Icons.notifications_off;

  @override
  IconData get style => Icons.style;

  @override
  IconData get theme => Icons.dark_mode;

  @override
  IconData get numbers => Icons.numbers;

  @override
  IconData get palette => Icons.palette;

  @override
  IconData get pdf => Icons.picture_as_pdf;

  @override
  IconData get reduceMotion => Icons.motion_photos_off;

  @override
  IconData get contrast => Icons.contrast;

  @override
  IconData get accessibility => Icons.accessibility;

  @override
  IconData get addCircle => Icons.add_circle_outline;

  @override
  IconData get currencyExchange => Icons.currency_exchange;

  @override
  IconData get percent => Icons.percent;
}
