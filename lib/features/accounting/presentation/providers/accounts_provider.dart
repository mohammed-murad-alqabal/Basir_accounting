import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/account.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'accounts_provider.g.dart';

/// Global provider for the consolidated local Chart of Accounts (COA).
///
/// Serves as the reactive source of truth for all ledger accounts,
/// enabling real-time UI updates when balances or metadata change.
@riverpod
Future<List<Account>> accounts(AccountsRef ref) async {
  final repository = ref.watch(accountingRepositoryProvider);
  return repository.getAccounts();
}

/// Dynamic filtered provider for accounts of a specific [AccountType].
///
/// Optimizes UI performance by providing slice-based access to the COA,
/// useful for account selection in forms (e.g., filtering for Assets only).
@riverpod
Future<List<Account>> accountsByType(
  AccountsByTypeRef ref,
  AccountType type,
) async {
  final allAccounts = await ref.watch(accountsProvider.future);
  return allAccounts.where((a) => a.type == type).toList();
}
