import 'dart:async';

import 'package:basir_accounting_system/features/users/application/user_service.dart';
import 'package:basir_accounting_system/features/users/domain/entities/user.dart';
import 'package:basir_accounting_system/features/users/domain/entities/user_role.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

/// شاشة نموذج إضافة/تعديل مستخدم
class UserFormScreen extends ConsumerStatefulWidget {
  /// إنشاء الشاشة
  const UserFormScreen({super.key, this.user});

  /// المستخدم المراد تعديله (اختياري)
  final User? user;

  @override
  ConsumerState<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends ConsumerState<UserFormScreen> {
  final _formKey = <credential-fixture><FormState>();
  late TextEditingController _usernameController;
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  UserRole _role = UserRole.viewer;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(
      text: widget.user?.username ?? '',
    );
    _fullNameController = TextEditingController(
      text: widget.user?.fullName ?? '',
    );
    _emailController = TextEditingController(
      text: widget.user?.email ?? '',
    );
    _passwordController = TextEditingController(); // Empty for edit

    if (widget.user != null) {
      _role = widget.user!.role;
      _isActive = widget.user!.isActive;
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final isEditing = widget.user != null;

    // For edit, password is optional/separate
    // For create, password is required
    if (!isEditing && _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('كلمة المرور مطلوبة')),
      );
      return;
    }

    try {
      final user = User(
        id: widget.user?.id ?? const Uuid().v4(),
        username: _usernameController.text,
        fullName: _fullNameController.text,
        email: _emailController.text,
        role: _role,
        isActive: _isActive,
        createdAt: widget.user?.createdAt,
        updatedAt: DateTime.now(),
      );

      final notifier = ref.read(userServiceProvider.notifier);

      if (isEditing) {
        await notifier.updateUser(user);
        if (_passwordController.text.isNotEmpty) {
          await notifier.changePassword(user.id, _passwordController.text);
        }
      } else {
        await notifier.createUser(user, _passwordController.text);
      }

      if (mounted) Navigator.pop(context);
    } on Exception catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.user != null ? 'تعديل مستخدم' : 'مستخدم جديد'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: <credential-fixture>,
            child: ListView(
              children: [
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: 'اسم المستخدم'),
                  validator: (v) => v!.isEmpty ? 'مطلوب' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _fullNameController,
                  decoration: const InputDecoration(labelText: 'الاسم الكامل'),
                  validator: (v) => v!.isEmpty ? 'مطلوب' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'البريد الإلكتروني',
                  ),
                  validator: (v) => v!.contains('@') ? null : 'بريد غير صحيح',
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<UserRole>(
                  initialValue: _role,
                  decoration: const InputDecoration(labelText: 'الدور'),
                  items: UserRole.values
                      .map(
                        (role) => DropdownMenuItem(
                          value: role,
                          child: Text(role.displayName),
                        ),
                      )
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _role = val);
                  },
                ),
                const SizedBox(height: 16),
                if (widget.user != null)
                  SwitchListTile(
                    title: const Text('نشط'),
                    value: _isActive,
                    onChanged: (val) => setState(() => _isActive = val),
                  ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: widget.user != null
                        ? 'كلمة المرور '
                            '(اتركها فارغة للتجاهل)'
                        : 'كلمة المرور',
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _submit,
                  child: const Text('حفظ'),
                ),
              ],
            ),
          ),
        ),
      );
}
