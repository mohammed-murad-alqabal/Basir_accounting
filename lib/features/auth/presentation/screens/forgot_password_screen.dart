import 'package:basir_accounting_system/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ***
/// Cognitive Foundation: ForgotPasswordScreen
///
/// Minimal recovery entry point referenced by [AppRouter] at
/// `'/forgot-password'`. Collects the user's registered e-mail address.
///
/// This module provides the navigation contract only; actual recovery
/// submission logic belongs to a future phase of the Basir executive
/// blueprint and is intentionally out of scope here.
/// ***
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = <credential-fixture><FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final email = _emailController.text.trim();

    final context = this.context;
    Navigator.of(context).pushReplacementNamed(
      '/reset-password',
      arguments: <String, String>{'email': email, 'token': ''},
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.forgotPassword)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: <credential-fixture>,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _emailController,
                keyboardType: <credential-fixture>,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Required';
                  }
                  if (!value.contains('@')) {
                    return 'Enter a valid e-mail';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _onSubmit,
                child: Text(l10n.forgotPassword),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
