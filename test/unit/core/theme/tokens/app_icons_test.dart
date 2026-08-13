/// اختبارات عقد رموز واجهة بصير العامة.
library;

import 'package:basir_accounting_system/core/theme/tokens/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppIcons', () {
    test('يوفر جميع الرموز العامة المتوافقة مع حزمة Material', () {
      final icons = <IconData>[
        AppIcons.home,
        AppIcons.invoices,
        AppIcons.customers,
        AppIcons.products,
        AppIcons.settings,
        AppIcons.menu,
        AppIcons.back,
        AppIcons.forward,
        AppIcons.more,
        AppIcons.moreHorizontal,
        AppIcons.chevronRight,
        AppIcons.add,
        AppIcons.edit,
        AppIcons.delete,
        AppIcons.search,
        AppIcons.filter,
        AppIcons.sort,
        AppIcons.save,
        AppIcons.cancel,
        AppIcons.check,
        AppIcons.close,
        AppIcons.send,
        AppIcons.share,
        AppIcons.print,
        AppIcons.download,
        AppIcons.upload,
        AppIcons.copy,
        AppIcons.cut,
        AppIcons.paste,
        AppIcons.refresh,
        AppIcons.undo,
        AppIcons.redo,
        AppIcons.info,
        AppIcons.warning,
        AppIcons.error,
        AppIcons.success,
        AppIcons.help,
        AppIcons.notification,
        AppIcons.newBadge,
        AppIcons.file,
        AppIcons.folder,
        AppIcons.image,
        AppIcons.document,
        AppIcons.note,
        AppIcons.list,
        AppIcons.grid,
        AppIcons.calendar,
        AppIcons.clock,
        AppIcons.location,
        AppIcons.bookmark,
        AppIcons.star,
        AppIcons.favorite,
        AppIcons.money,
        AppIcons.wallet,
        AppIcons.creditCard,
        AppIcons.payment,
        AppIcons.invoice,
        AppIcons.report,
        AppIcons.chart,
        AppIcons.analytics,
        AppIcons.trendUp,
        AppIcons.trendDown,
        AppIcons.user,
        AppIcons.users,
        AppIcons.userAdd,
        AppIcons.profile,
        AppIcons.login,
        AppIcons.logout,
        AppIcons.account,
        AppIcons.email,
        AppIcons.message,
        AppIcons.chat,
        AppIcons.phone,
        AppIcons.call,
        AppIcons.video,
        AppIcons.visibility,
        AppIcons.visibilityOff,
        AppIcons.lock,
        AppIcons.unlock,
        AppIcons.expand,
        AppIcons.collapse,
        AppIcons.fullscreen,
        AppIcons.fullscreenExit,
        AppIcons.play,
        AppIcons.pause,
        AppIcons.stop,
        AppIcons.lightMode,
        AppIcons.darkMode,
        AppIcons.autoMode,
        AppIcons.brightness,
        AppIcons.language,
        AppIcons.translate,
        AppIcons.tune,
        AppIcons.tools,
        AppIcons.link,
        AppIcons.unlink,
        AppIcons.qrCode,
        AppIcons.scanner,
        AppIcons.camera,
        AppIcons.gallery,
        AppIcons.product,
        AppIcons.cart,
        AppIcons.store,
        AppIcons.inventory,
        AppIcons.priceTag,
        AppIcons.offer,
        AppIcons.barcode,
        AppIcons.barcodeReader,
        AppIcons.arrowUp,
        AppIcons.arrowDown,
        AppIcons.arrowRight,
        AppIcons.arrowLeft,
        AppIcons.rotate,
        AppIcons.swap,
        AppIcons.dashboard,
        AppIcons.accounting,
        AppIcons.upgrade,
        AppIcons.bolt,
        AppIcons.update,
        AppIcons.restore,
        AppIcons.person,
        AppIcons.circle,
        AppIcons.text,
        AppIcons.touch,
        AppIcons.business,
        AppIcons.security,
        AppIcons.notifications,
        AppIcons.notificationsOff,
        AppIcons.style,
        AppIcons.theme,
        AppIcons.numbers,
        AppIcons.palette,
        AppIcons.pdf,
        AppIcons.reduceMotion,
        AppIcons.contrast,
        AppIcons.accessibility,
        AppIcons.addCircle,
        AppIcons.currencyExchange,
        AppIcons.percent,
      ];

      expect(icons, isNotEmpty);
      expect(icons.every((icon) => icon.codePoint > 0), isTrue);
      expect(icons.map((icon) => icon.fontFamily).toSet(),
          contains('MaterialIcons'));
    });

    test('يختار رمز الحالة وفق الحالات المحاسبية المدعومة والافتراضية', () {
      expect(AppIcons.getStatusIcon('paid'), AppIcons.success);
      expect(AppIcons.getStatusIcon('FAILED'), AppIcons.error);
      expect(AppIcons.getStatusIcon('pending'), AppIcons.warning);
      expect(AppIcons.getStatusIcon('draft'), AppIcons.info);
      expect(AppIcons.getStatusIcon('unrecognized'), AppIcons.info);
    });

    test('يختار رمز الملف وفق نوع المورد أو الامتداد', () {
      expect(AppIcons.getFileIcon('pdf'), AppIcons.document);
      expect(AppIcons.getFileIcon('PNG'), AppIcons.image);
      expect(AppIcons.getFileIcon('zip'), AppIcons.folder);
      expect(AppIcons.getFileIcon('ledger'), AppIcons.file);
    });

    test('يبدل رموز الترتيب والرؤية حسب الحالة المطلوبة', () {
      expect(AppIcons.getSortIcon(ascending: true), AppIcons.arrowUp);
      expect(AppIcons.getSortIcon(ascending: false), AppIcons.arrowDown);
      expect(
        AppIcons.getVisibilityIcon(isVisible: true),
        AppIcons.visibility,
      );
      expect(
        AppIcons.getVisibilityIcon(isVisible: false),
        AppIcons.visibilityOff,
      );
    });
  });
}
