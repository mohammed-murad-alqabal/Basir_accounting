import 'package:basir_app/features/auth/application/auth_service.dart';
import 'package:basir_app/features/customers/domain/repositories/customer_repository.dart';
import 'package:basir_app/features/invoices/domain/repositories/invoice_repository.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([AuthService, CustomerRepository, InvoiceRepository])
void main() {}
