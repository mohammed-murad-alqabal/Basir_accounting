import 'dart:async';

import 'package:basir_app/features/auth/application/auth_service.dart';

class MockAuthServiceTestHelper implements AuthService {
  bool convertCalled = false;
  String? lastUsername;
  String? lastPassword;

  @override
  Future<void> convertGuestToUser(String username, String password) async {
    convertCalled = true;
    lastUsername = username;
    lastPassword = password;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
