import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';

/// خدمة التعامل مع جهات الاتصال في الجهاز
class ContactService {
  /// طلب إذن الوصول إلى جهات الاتصال
  Future<bool> requestPermission() async {
    final status = await Permission.contacts.request();
    return status.isGranted;
  }

  /// الحصول على قائمة جهات الاتصال
  Future<List<Contact>> getContacts() async {
    if (await requestPermission()) {
      return FlutterContacts.getContacts(withProperties: true);
    }
    return [];
  }

  /// البحث في جهات الاتصال
  Future<List<Contact>> searchContacts(String query) async {
    final contacts = await getContacts();
    if (query.isEmpty) return contacts;

    return contacts.where((contact) {
      final firstName = contact.name.first;
      final lastName = contact.name.last;
      final fullName = '$firstName $lastName'.toLowerCase();
      return fullName.contains(query.toLowerCase()) ||
          contact.phones.any((phone) => phone.number.contains(query));
    }).toList();
  }
}
