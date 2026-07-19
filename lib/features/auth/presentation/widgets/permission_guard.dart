import 'package:basir_accounting_system/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A widget that reveals its child only if the current user has the required
/// permission.
///
/// If [fallback] is provided, it will be shown when permission is denied.
/// Otherwise, an empty [SizedBox] is returned.
class PermissionGuard extends ConsumerWidget {
  /// Creates a permission guard with required permission bitmask and child.
  const PermissionGuard({
    required this.permission,
    required this.child,
    super.key,
    this.fallback,
  });

  /// The specific permission bitmask required to view the child.
  final int permission;

  /// The widget to show if generic validation passes.
  final Widget child;

  /// Optional widget to show if permission is denied (e.g., a "Locked" icon).
  final Widget? fallback;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProfileProvider);

    if (user == null || !user.hasPermission(permission)) {
      return fallback ?? const SizedBox.shrink();
    }

    return child;
  }
}
