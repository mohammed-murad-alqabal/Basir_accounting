import 'package:basir_app/core/providers.dart';
import 'package:basir_app/features/accounting/domain/entities/financial_year.dart';
import 'package:basir_app/features/accounting/domain/entities/journal_entry.dart';
import 'package:basir_app/features/accounting/domain/repositories/financial_year_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'financial_year_service.g.dart';

/// خدمة السنة المالية (Financial Year Service)
/// مسؤولة عن إدارة الفترات المالية والتحقق من صلاحية الترحيل.
@Riverpod(keepAlive: true)
class FinancialYearService extends _$FinancialYearService {
  @override
  FutureOr<void> build() {}

  FinancialYearRepository get _repository =>
      ref.read(financialYearRepositoryProvider);

  /// تهيئة السنة المالية الافتراضية إذا لم تكن موجودة.
  /// (FR-ACC-015: إدارة الفترات المالية)
  Future<void> initializeDefaultYear() async {
    final existingYears = await _repository.getAllFinancialYears();
    if (existingYears.isNotEmpty) return;

    final now = DateTime.now();
    final startDate = DateTime(now.year);
    final endDate = DateTime(now.year, 12, 31);

    final defaultYear = FinancialYear(
      id: 'fy-${now.year}',
      name: 'السنة المالية ${now.year}',
      startDate: startDate,
      endDate: endDate,
    );

    await _repository.saveFinancialYear(defaultYear);
  }

  /// التحقق من إمكانية إجراء عملية مالية في تاريخ معين
  Future<bool> canPostToDate(DateTime date) async {
    final year = await _repository.getFinancialYearByDate(date);
    if (year == null) return false;
    if (year.isClosed) return false;

    // التحقق من الفترات الشهرية المغلقة (إن وجدت)
    final periodId = '${date.year}-${date.month.toString().padLeft(2, '0')}';
    if (year.lockedPeriodIds.contains(periodId)) return false;

    return true;
  }

  /// إغلاق فترة شهرية محددة
  Future<void> lockMonthlyPeriod(String yearId, int month, int year) async {
    final fy = await _repository.getAllFinancialYears();
    final targetYear = fy.firstWhere((y) => y.id == yearId);

    final periodId = '$year-${month.toString().padLeft(2, '0')}';
    if (targetYear.lockedPeriodIds.contains(periodId)) return;

    final updatedYear = targetYear.copyWith(
      lockedPeriodIds: [...targetYear.lockedPeriodIds, periodId],
    );

    await _repository.saveFinancialYear(updatedYear);
  }

  /// إغلاق السنة المالية نهائياً
  Future<void> closeYear(String yearId, String userId) async {
    final fy = await _repository.getAllFinancialYears();
    final targetYear = fy.firstWhere((y) => y.id == yearId);

    // التحقق من وجود مسودات قيود لم ترحل بعد لهذه السنة
    final accountingRepo = ref.read(accountingRepositoryProvider);
    final entries = await accountingRepo.getJournalEntries();

    final pendingDrafts = entries.where(
      (e) =>
          e.status == JournalEntryStatus.draft &&
          targetYear.containsDate(e.date),
    );

    if (pendingDrafts.isNotEmpty) {
      throw Exception(
        'Cannot close year: There are ${pendingDrafts.length} unposted draft entries.',
      );
    }

    await _repository.closeFinancialYear(yearId, userId);
  }
}
