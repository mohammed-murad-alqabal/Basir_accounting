import 'dart:async';

import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/features/users/application/user_service.dart';
import 'package:basir_accounting_system/features/users/presentation/screens/user_form_screen.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// شاشة لوحة تحكم المستخدمين
class UsersDashboardScreen extends ConsumerWidget {
  /// إنشاء شاشة لوحة التحكم
  const UsersDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(userServiceProvider);

    return GlassScaffold(
      title: 'إدارة المستخدمين',
      actions: const [],
      body: usersAsync.when(
        data: (users) {
          if (users.isEmpty) {
            return const AppEmptyState(title: 'لا يوجد مستخدمين');
          }
          return ListView.builder(
            padding: const EdgeInsets.all(Spacing.md),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return AppCard(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                    child: Text(
                      user.fullName.isEmpty ? '?' : user.fullName[0],
                      style: const TextStyle(color: AppColors.primary),
                    ),
                  ),
                  title: Text(user.fullName),
                  subtitle: Text(
                    '${user.email} • '
                    '${user.role.displayName}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: AppColors.primary),
                        tooltip: 'تعديل المستخدم',
                        onPressed: () {
                          unawaited(
                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (_) => UserFormScreen(user: user),
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: AppColors.error),
                        tooltip: 'حذف المستخدم',
                        onPressed: () async {
                          final confirm = await AppDialog.showConfirmation(
                            context,
                            title: 'حذف المستخدم',
                            message: 'هل أنت متأكد من حذف ${user.username}؟',
                            confirmLabel: 'حذف',
                          );

                          if (confirm) {
                            final notifier =
                                ref.read(userServiceProvider.notifier);
                            await notifier.deleteUser(user.id);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: AppLoadingIndicator()),
        error: (err, st) => AppErrorWidget(
          message: 'خطأ: $err',
          onRetry: () => ref.invalidate(userServiceProvider),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'users_add_fab',
        onPressed: () {
          unawaited(
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => const UserFormScreen(),
              ),
            ),
          );
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
