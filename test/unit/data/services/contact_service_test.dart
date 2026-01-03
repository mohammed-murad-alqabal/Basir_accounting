import 'package:basir_app/features/customers/data/services/contact_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ContactService contactService;
  final log = <MethodCall>[];

  setUp(() {
    contactService = ContactService();
    log.clear();

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('github.com/QuisApp/flutter_contacts'),
      (methodCall) async {
        log.add(methodCall);
        if (methodCall.method == 'select') {
          return [
            {
              'id': '1',
              'displayName': 'Ahmed Mohamed',
              'thumbnail': null,
              'photo': null,
              'isStarred': false,
              'name': {'first': 'Ahmed', 'last': 'Mohamed'},
              'phones': [
                {'number': '0555555555', 'label': 'mobile'},
              ],
              'emails': <dynamic>[],
              'addresses': <dynamic>[],
              'organizations': <dynamic>[],
              'websites': <dynamic>[],
              'socialMedias': <dynamic>[],
              'events': <dynamic>[],
              'notes': <dynamic>[],
              'groups': <dynamic>[],
            },
            {
              'id': '2',
              'displayName': 'Sara Ali',
              'thumbnail': null,
              'photo': null,
              'isStarred': false,
              'name': {'first': 'Sara', 'last': 'Ali'},
              'phones': [
                {'number': '0566666666', 'label': 'mobile'},
              ],
              'emails': <dynamic>[],
              'addresses': <dynamic>[],
              'organizations': <dynamic>[],
              'websites': <dynamic>[],
              'socialMedias': <dynamic>[],
              'events': <dynamic>[],
              'notes': <dynamic>[],
              'groups': <dynamic>[],
            }
          ];
        }
        return null;
      },
    );

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('flutter.baseflow.com/permissions/methods'),
      (methodCall) async {
        if (methodCall.method == 'requestPermissions') {
          final arguments = methodCall.arguments as List<dynamic>;
          return {
            arguments[0]: 1,
          };
        }
        return null;
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('flutter_contacts'),
      null,
    );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('flutter.baseflow.com/permissions/methods'),
      null,
    );
  });

  group('ContactService Tests', () {
    test('getContacts should return list of contacts when permission granted',
        () async {
      // Act
      final contacts = await contactService.getContacts();

      // Assert
      expect(contacts.length, 2);
      expect(contacts.first.displayName, 'Ahmed Mohamed');
      expect(contacts.last.displayName, 'Sara Ali');
    });

    test('searchContacts should filter by name', () async {
      // Act
      final results = await contactService.searchContacts('Ahmed');

      // Assert
      expect(results.length, 1);
      expect(results.first.displayName, 'Ahmed Mohamed');
    });

    test('searchContacts should filter by phone number', () async {
      // Act
      final results = await contactService.searchContacts('056');

      // Assert
      expect(results.length, 1);
      expect(results.first.displayName, 'Sara Ali');
    });

    test('searchContacts should return empty list if no match found', () async {
      // Act
      final results = await contactService.searchContacts('XYZ');

      // Assert
      expect(results, isEmpty);
    });

    test('searchContacts should return all contacts if query is empty',
        () async {
      // Act
      final results = await contactService.searchContacts('');

      // Assert
      expect(results.length, 2);
    });
  });
}
