import 'package:basir_app/core/providers.dart';
import 'package:basir_app/features/accounting/domain/entities/journal_entry.dart';
import 'package:decimal/decimal.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'accounts_payable_service.g.dart';

/// بيانات تعمير ديون المورد (Supplier Aging Data)
/// تحتوي على تفاصيل الديون المستحقة مقسمة حسب الفترات الزمنية.
class SupplierAging {
  /// إنشاء بيانات تعمير ديون المورد.
  SupplierAging({
    required this.supplierId,
    required this.supplierNameAr,
    required this.supplierNameEn,
    required this.current,
    required this.period1_30,
    required this.period31_60,
    required this.periodOver90,
    required this.totalBalance,
  });

  /// معرف المورد.
  final String supplierId;

  /// اسم المورد بالعربية.
  final String supplierNameAr;

  /// اسم المورد بالإنجليزية.
  final String supplierNameEn;

  /// الديون الحالية (لم تستحق بعد).
  final Decimal current;

  /// الديون المتأخرة من 1 إلى 30 يوم.
  final Decimal period1_30;

  /// الديون المتأخرة من 31 إلى 60 يوم.
  final Decimal period31_60;

  /// الديون المتأخرة لأكثر من 90 يوم.
  final Decimal periodOver90;

  /// إجمالي رصيد الديون المستحقة للمورد.
  final Decimal totalBalance;

  /// الحصول على الاسم المناسب حسب اللغة
  String name({required bool isArabic}) =>
      isArabic ? supplierNameAr : supplierNameEn;
}

/// خدمة حسابات الموردين (Accounts Payable Service)
/// تدير الالتزامات المالية والديون المستحقة للموردين.
@riverpod
class AccountsPayableService extends _$AccountsPayableService {
  @override
  FutureOr<void> build() {}

  /// الحصول على رصيد مورد محدد
  Future<Decimal> getSupplierBalance(String supplierId) async {
    final repository = ref.read(accountingRepositoryProvider);
    final vendorRepo = ref.read(vendorRepositoryProvider);

    final vendor = await vendorRepo.getVendorById(supplierId);
    final targetAccountId = vendor?.payableAccountId ?? 'acc-2101';

    final entries = await repository.getJournalEntries();

    var balance = Decimal.zero;
    for (final entry in entries) {
      for (final line in entry.lines) {
        if (line.accountId == targetAccountId ||
            (targetAccountId == 'acc-2101' &&
                line.accountName.contains(supplierId))) {
          // في الخصوم: الدائن يزيد الرصيد والمدين ينقصه
          balance += line.credit - line.debit;
        }
      }
    }
    return balance;
  }

  /// تقرير تعمير الديون بالتفصيل لكل مورد (Detailed Aging Report)
  Future<List<SupplierAging>> getPayablesAging() async {
    final accountingRepo = ref.read(accountingRepositoryProvider);
    final vendorRepo = ref.read(vendorRepositoryProvider);

    final vendors = await vendorRepo.getAllVendors();
    final entries = await accountingRepo.getJournalEntries();
    final now = DateTime.now();

    final result = <SupplierAging>[];

    for (final vendor in vendors) {
      final targetAccountId = vendor.payableAccountId ?? 'acc-2101';

      var current = Decimal.zero;
      var p1 = Decimal.zero;
      var p2 = Decimal.zero;
      var pOver = Decimal.zero;

      for (final entry in entries) {
        if (entry.status == JournalEntryStatus.posted) {
          for (final line in entry.lines) {
            if (line.accountId == targetAccountId) {
              final balance = line.credit - line.debit;
              if (balance != Decimal.zero) {
                final diff = now.difference(entry.date).inDays;
                if (diff <= 0) {
                  current += balance;
                } else if (diff <= 30) {
                  p1 += balance;
                } else if (diff <= 60) {
                  p2 += balance;
                } else {
                  pOver += balance;
                }
              }
            }
          }
        }
      }

      final total = current + p1 + p2 + pOver;
      if (total != Decimal.zero) {
        result.add(
          SupplierAging(
            supplierId: vendor.id,
            supplierNameAr: vendor.nameAr,
            supplierNameEn: vendor.nameEn,
            current: current,
            period1_30: p1,
            period31_60: p2,
            periodOver90: pOver,
            totalBalance: total,
          ),
        );
      }
    }

    return result;
  }

  /// كشف حساب مورد (Detailed Ledger)
  Future<List<JournalEntry>> getSupplierLedger(String supplierId) async {
    final repository = ref.read(accountingRepositoryProvider);
    final vendorRepo = ref.read(vendorRepositoryProvider);

    final vendor = await vendorRepo.getVendorById(supplierId);
    final targetAccountId = vendor?.payableAccountId ?? 'acc-2101';

    final entries = await repository.getJournalEntries();

    return entries
        .where(
          (e) => e.lines.any(
            (l) =>
                l.accountId == targetAccountId ||
                (targetAccountId == 'acc-2101' &&
                    l.accountName.contains(supplierId)),
          ),
        )
        .toList();
  }
}
