import 'package:basir_accounting_system/core/security/access_policy.dart';
import 'package:basir_accounting_system/features/auth/domain/models/auth_models.dart';
import 'package:basir_accounting_system/features/users/domain/entities/user_role.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const admin = BasirUser(
    id: 'admin-1',
    email: 'admin@example.test',
    role: UserRole.admin,
    permissions: Permission.all,
  );
  const viewer = BasirUser(
    id: 'viewer-1',
    email: 'viewer@example.test',
    role: UserRole.viewer,
    permissions: Permission.viewFinancials,
  );
  const guest = BasirUser(
    id: 'guest',
    email: 'guest@basir.local',
    isGuest: true,
  );

  test('admin can access user management', () {
    expect(AccessPolicy.can(admin, Permission.manageUsers), isTrue);
  });

  test('viewer is denied user management', () {
    expect(AccessPolicy.can(viewer, Permission.manageUsers), isFalse);
    expect(
      () => AccessPolicy.require(viewer, Permission.manageUsers),
      throwsA(isA<AccessDeniedException>()),
    );
  });

  test(
    'guest is denied sensitive access even with a broad permission bitmask',
    () {
      expect(
        AccessPolicy.can(guest, Permission.viewFinancials, allowGuest: false),
        isFalse,
      );
    },
  );

  test('warehouse scope is enforced for non-admin users', () {
    const scopedUser = BasirUser(
      id: 'warehouse-user',
      email: 'warehouse@example.test',
      role: UserRole.clerk,
      permissions: Permission.manageInventory,
      warehouseId: 'warehouse-a',
    );

    expect(
      AccessPolicy.can(
        scopedUser,
        Permission.manageInventory,
        warehouseId: 'warehouse-a',
      ),
      isTrue,
    );
    expect(
      AccessPolicy.can(
        scopedUser,
        Permission.manageInventory,
        warehouseId: 'warehouse-b',
      ),
      isFalse,
    );
  });
}
