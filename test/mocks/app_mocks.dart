import 'package:basser_app/features/auth/data/services/auth_service.dart';
import 'package:basser_app/features/customers/domain/repositories/customer_repository.dart';
import 'package:basser_app/features/invoices/domain/repositories/invoice_repository.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([AuthService, CustomerRepository, InvoiceRepository])
void main() {}
