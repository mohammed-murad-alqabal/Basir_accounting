import 'dart:async';

import 'package:basir_accounting_system/features/users/application/user_service.dart';
import 'package:basir_accounting_system/features/users/presentation/screens/user_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// شاشة لوحة تحكم المستخدمين
class UsersDashboardScreen extends ConsumerWidget {
  /// إنشاء شاشة لوحة التحكم
  const UsersDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(userServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة المستخدمين'),
      ),
      body: usersAsync.when(
        data: (users) {
          if (users.isEmpty) {
            return const Center(child: Text('لا يوجد مستخدمين'));
          }
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                leading: CircleAvatar(
                  child: Text(user.fullName.isEmpty ? '?' : user.fullName[0]),
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
                      icon: const Icon(Icons.edit, color: Colors.blue),
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
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('حذف المستخدم'),
                            content: Text(
                              'هل أنت متأكد من حذف ${user.username}؟',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('إلغاء'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('حذف'),
                              ),
                            ],
                          ),
                        );

                        if (confirm ?? false) {
                          final notifier =
                              ref.read(userServiceProvider.notifier);
                          await notifier.deleteUser(user.id);
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text('خطأ: $err')),
      ),
      floatingActionButton: FloatingActionButton(
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
        child: const Icon(Icons.add),
      ),
    );
  }
}
