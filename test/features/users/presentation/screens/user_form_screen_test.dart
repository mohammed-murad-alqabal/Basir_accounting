import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/users/domain/entities/user.dart';
import 'package:basir_accounting_system/features/users/domain/entities/user_role.dart';
import 'package:basir_accounting_system/features/users/domain/repositories/user_repository.dart';
import 'package:basir_accounting_system/features/users/presentation/screens/user_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'user_form_screen_test.mocks.dart';

@GenerateMocks([UserRepository])
void main() {
  late MockUserRepository mockRepository;

  setUp(() {
    mockRepository = MockUserRepository();
    // Default stubs
    when(mockRepository.getAllUsers()).thenAnswer((_) async => []);
  });

  Future<void> pumpScreen(WidgetTester tester, {User? user}) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          userRepositoryProvider.overrideWithValue(mockRepository),
        ],
        child: MaterialApp(
          home: UserFormScreen(user: user),
        ),
      ),
    );
  }

  group('UserFormScreen', () {
    testWidgets('renders correct title for new user', (tester) async {
      await pumpScreen(tester);
      expect(find.text('مستخدم جديد'), findsOneWidget);
      expect(find.text('حفظ'), findsOneWidget);
    });

    testWidgets('renders correct title for existing user', (tester) async {
      const user = User(
        id: '1',
        username: 'old',
        fullName: 'Old User',
        email: 'old@example.com',
        role: UserRole.accountant,
      );
      await pumpScreen(tester, user: user);
      expect(find.text('تعديل مستخدم'), findsOneWidget);
      expect(find.text('Old User'), findsOneWidget);
    });

    testWidgets('validates required fields', (tester) async {
      await pumpScreen(tester);

      await tester.tap(find.text('حفظ'));
      await tester.pumpAndSettle();

      expect(find.text('مطلوب'), findsNWidgets(2)); // Username, FullName
    });

    testWidgets('submits data when valid', (tester) async {
      when(mockRepository.createUser(any, any)).thenAnswer((_) async {});

      await pumpScreen(tester);

      await tester.enterText(
        find.ancestor(
          of: find.text('اسم المستخدم'),
          matching: find.byType(TextField),
        ),
        'newuser',
      );
      await tester.enterText(
        find.ancestor(
          of: find.text('الاسم الكامل'),
          matching: find.byType(TextField),
        ),
        'New User',
      );
      await tester.enterText(
        find.ancestor(
          of: find.text('البريد الإلكتروني'),
          matching: find.byType(TextField),
        ),
        'new@example.com',
      );
      await tester.enterText(
        find.ancestor(
          of: find.text('كلمة المرور'),
          matching: find.byType(TextField),
        ),
        'password123',
      );

      // Scroll to button if needed
      await tester.ensureVisible(find.text('حفظ'));
      await tester.tap(find.text('حفظ'));
      await tester.pumpAndSettle(); // Wait for future and navigation

      verify(mockRepository.createUser(any, any)).called(1);
    });
  });
}
