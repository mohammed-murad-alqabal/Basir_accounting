import 'package:basir_accounting_system/features/auth/domain/models/auth_models.dart';
import 'package:basir_accounting_system/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// صلاحيات المسارات والعمليات الحساسة في التطبيق.
abstract final class AccessPolicy {
  /// يتحقق من إمكانية تنفيذ عملية محددة في سياق المستخدم الحالي.
  static bool can(
    BasirUser? user,
    int permission, {
    bool allowGuest = false,
    String? warehouseId,
  }) {
    if (user == null) return false;
    if (user.isGuest && !allowGuest) return false;
    if (!user.hasPermission(permission)) return false;
    if (warehouseId != null && !user.hasAccessToWarehouse(warehouseId)) {
      return false;
    }
    return true;
  }

  /// يوقف العملية باستثناء واضح عند غياب الصلاحية.
  static void require(
    BasirUser? user,
    int permission, {
    bool allowGuest = false,
    String? warehouseId,
  }) {
    if (!can(
      user,
      permission,
      allowGuest: allowGuest,
      warehouseId: warehouseId,
    )) {
      throw const AccessDeniedException();
    }
  }

  /// سياسة المسارات المسجلة مركزيًا.
  static int? requiredPermissionForRoute(String route) => switch (route) {
    '/users' || '/user-form' => Permission.manageUsers,
    '/cloud-backup' => Permission.manageUsers,
    '/forensic-portal' ||
    '/audit-trail-report' => Permission.viewSensitiveReports,
    '/smart-tax-report' || '/intelligence' => Permission.viewSensitiveReports,
    '/journal-entry-form' || '/voucher-form' => Permission.postJournalEntry,
    '/zatca-onboarding' ||
    '/fiscal-control-center' => Permission.approveTransactions,
    _ => null,
  };

  /// المسارات التي لا تتطلب جلسة.
  static bool isPublicRoute(String route) => switch (route) {
    '/setup' || '/login' || '/forgot-password' || '/reset-password' => true,
    _ => false,
  };
}

/// حارس مصادقة/تفويض على مستوى route، وليس مجرد إخفاء Widget.
class AccessDeniedException implements Exception {
  const AccessDeniedException();

  @override
  String toString() => 'Access denied';
}

class AuthGuard extends ConsumerWidget {
  const AuthGuard({required this.child, required this.routeName, super.key});

  final Widget child;
  final String routeName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(basirUserProvider);
    final isGuest = ref
        .watch(isGuestProvider)
        .maybeWhen(
          data: (value) => value,
          orElse: () => user?.isGuest ?? false,
        );
    final effectiveUser =
        user ??
        (isGuest
            ? const BasirUser(
                id: 'guest',
                email: 'guest@basir.local',
                displayName: 'مستخدم ضيف',
                isGuest: true,
              )
            : null);

    if (effectiveUser == null) {
      return _DeniedRoute(
        message: 'تحتاج إلى تسجيل الدخول للوصول إلى هذه الشاشة.',
        actionLabel: 'تسجيل الدخول',
        onAction: () => Navigator.of(context).pushReplacementNamed('/login'),
      );
    }

    final permission = AccessPolicy.requiredPermissionForRoute(routeName);
    if (permission != null &&
        !AccessPolicy.can(effectiveUser, permission, allowGuest: false)) {
      return const _DeniedRoute(
        message: 'ليس لديك الصلاحية اللازمة للوصول إلى هذه الشاشة.',
      );
    }

    return child;
  }
}

class _DeniedRoute extends StatelessWidget {
  const _DeniedRoute({required this.message, this.actionLabel, this.onAction});

  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.lock_outline, size: 48),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            if (onAction != null) ...[
              const SizedBox(height: 16),
              FilledButton(
                onPressed: onAction,
                child: Text(actionLabel ?? 'متابعة'),
              ),
            ],
          ],
        ),
      ),
    ),
  );
}
