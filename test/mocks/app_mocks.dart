import 'package:basir_accounting_system/features/auth/application/auth_service.dart';
import 'package:basir_accounting_system/features/customers/domain/repositories/customer_repository.dart';
import 'package:basir_accounting_system/features/invoices/domain/repositories/invoice_repository.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([AuthService, CustomerRepository, InvoiceRepository])
void main() {}
