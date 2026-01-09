import 'package:basir_app/core/providers.dart';
import 'package:basir_app/features/accounting/domain/entities/account.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'accounts_provider.g.dart';

/// يوفر قائمة بجميع الحسابات المتوفرة في النظام.
@riverpod
Future<List<Account>> accounts(AccountsRef ref) async {
  final repository = ref.watch(accountingRepositoryProvider);
  return repository.getAccounts();
}

/// يوفر قائمة بالحسابات مصنفة حسب النوع.
@riverpod
Future<List<Account>> accountsByType(
  AccountsByTypeRef ref,
  AccountType type,
) async {
  final allAccounts = await ref.watch(accountsProvider.future);
  return allAccounts.where((a) => a.type == type).toList();
}
